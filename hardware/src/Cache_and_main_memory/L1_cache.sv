/*****************************************
* Module: L1_cache
* Author: Sahan Bandara
*
*****************************************/

/*********log***********
* * This version sets prev_word_sel in PREIDLE state as well.
* * in previous version addrA not set in PREIDLE. So issue with write after read when both are hit.
* * This version sets hit in PREIDLE state only if addr is equal to bak_addr. That means processor is stalled and waiting on a write miss.
* * in IDLE state, hit is set only if next state is not INVALIDATE. This way, if an invalidation happens while reading or writing an address, hit does not go *   high. processor stalls until the cache is updated
***********************/

module L1_cache #(
parameter int N = 32,  // 32 bit machine
parameter int ADDRWIDTH = 8,  // 256 cache lines
parameter int BLOCKSIZE = 8,  // Bytes per line (block sise in Bytes)
parameter int WORDSIZE = 4,  // word size in Bytes
parameter int ASSOCIATIVITY = 1,  // associativity set to 1 (not used in this implementation at this point)
parameter int WORDSPERLINE = BLOCKSIZE/WORDSIZE
)(
input clk,
input rst,
// processor side signals
/*make an interface for following signals later*/
input [N-1:0] addr,
input [N-1:0] data_in,
input [2:0] MEM_funct3,
input re,  // read enable
input we,  // write enable
output reg [N-1:0] data_out,
output reg hit,  // informs the processor of cache hit/miss processor should stall when this output is low.

output test_sig,

// memory side signals
input [WORDSPERLINE-1:0][N-1:0]mem2cache_data,
input mem2cache_ready,
output reg[N-1:0]cache2mem_addr,
output reg[WORDSPERLINE-1:0][N-1:0]cache2mem_data,
output reg cache2mem_we,
output reg cache2mem_re,
output [N-1:0] out_addr,

// snooping inputs
input [N-1:0] snoop_addr,
input snoop_we,

// granted signal from the arbitrator
input granted
);

localparam int WORDOFFSET = $clog2(WORDSPERLINE);
localparam int BYTEOFFSET = $clog2(WORDSIZE);  // number of bits to control the byte offset within a word
localparam int TAGWIDTH = N - ADDRWIDTH - BYTEOFFSET - WORDOFFSET;
localparam CACHEDEPTH = 1 << ADDRWIDTH;

/*******************************************************************************************************
* Dual port Byte enabled RAM to store the data internally.
* Use a banked structure to support multiple words per cache line. Each bank's width is parameterized so 
* that the cache can be configured for 32/64 bit system.
********************************************************************************************************/

// internal wires
// port A (used for read and write requests form the processor)
logic [WORDSPERLINE-1:0][ADDRWIDTH-1:0] addrA;
logic [WORDSPERLINE-1:0][WORDSIZE-1:0] benA;
logic [WORDSPERLINE-1:0][N-1:0] dataA;
logic [WORDSPERLINE-1:0][N-1:0] qA;
logic [WORDSPERLINE-1:0] weA;
logic [N-1:0] data_out_intermediate;  // output word selected from qA;

// port B (Used to internally update the cache)
logic [WORDSPERLINE-1:0][ADDRWIDTH-1:0] addrB;
logic [WORDSPERLINE-1:0][WORDSIZE-1:0] benB;
logic [WORDSPERLINE-1:0][N-1:0] dataB;
logic [WORDSPERLINE-1:0][N-1:0] qB;
logic [WORDSPERLINE-1:0] weB;

//internal signals
logic WE_i;
typedef enum {IDLE,CACHEMISS,R_MEMACCESS,CACHEUPDATE,UPDATEWAIT,WRITETHROUGH,W_MEMACCESS,PREIDLE,WRITEBACK,WBWAIT,INVALIDATE} state;
reg bak_we, bak_re, bak_hit;
reg [N-1:0] bak_data_in, bak_addr;
reg [2:0] bak_memfunc;
reg [TAGWIDTH-1:0]bak_ctag;
reg [ADDRWIDTH-1:0]bak_cindex;
reg [WORDSIZE-1:0] bak_ByteEn;
// signals for coherence protocol
logic invalidate;
logic sneqcur, sneqbak;
logic [TAGWIDTH-1:0]snoop_tag;
logic [ADDRWIDTH-1:0]snoop_index;

state c_state, n_state;



genvar i;
generate
for(i=0; i<WORDSPERLINE; i++)
begin:gen_ram
byte_enabled_true_dual_port_ram #(
.BYTES(WORDSIZE),
.ADDRESS_WIDTH(ADDRWIDTH)
) RAMi(
	.addr1(addrA[i]),
	.addr2(addrB[i]),
	.be1(benA[i]),
	.be2(benB[i]),
	.data_in1(dataA[i]), 
	.data_in2(dataB[i]), 
	.we1(weA[i]), .we2(weB[i]), .clk(clk),
	.data_out1(qA[i]),
	.data_out2(qB[i])
	);
end
endgenerate


// tag and index for cache
logic [TAGWIDTH-1:0]ctag;
logic [ADDRWIDTH-1:0]cindex;

assign ctag = (c_state==IDLE)?addr[(BYTEOFFSET+WORDOFFSET+ADDRWIDTH) +: TAGWIDTH] : bak_addr[(BYTEOFFSET+WORDOFFSET+ADDRWIDTH) +: TAGWIDTH];
assign cindex = (c_state==IDLE)?addr[(BYTEOFFSET+WORDOFFSET)+:ADDRWIDTH] : bak_addr[(BYTEOFFSET+WORDOFFSET)+:ADDRWIDTH];

// connctions from processor side
always_comb
begin
		dataA = {WORDSPERLINE{data_in}};
		weA = {WORDSPERLINE{WE_i}};
end

always_comb begin
	if(c_state==IDLE)
		addrA = {WORDSPERLINE{cindex}};
	else
		addrA = {WORDSPERLINE{bak_cindex}};
end


// write enable signal
always_comb
begin
	if((c_state == IDLE) && (re & we & hit))
		WE_i = we;
	else
		WE_i = 1'b0;
end


// Read logic
reg [WORDOFFSET-1:0] prev_word_sel [1:0];  // latches the word select from previous cycle so that the correct value could be put to output when data is read from the block RAM.

always_ff @(posedge clk)
begin
	if(c_state==IDLE || c_state==PREIDLE)
		prev_word_sel[0] <= addr[BYTEOFFSET+:WORDOFFSET];
	prev_word_sel[1] <= prev_word_sel[0];
end	
	
/*always_comb
begin:Word_Select
if(WORDSPERLINE > 1)
	data_out_intermediate = qA[prev_word_sel[1]];
else
	data_out_intermediate = qA[0];
end*/

assign data_out_intermediate = (WORDSPERLINE > 1)? qA[prev_word_sel[0]] : qA[0]; // This is not tested for writes. Need to be tested more.


always_comb
begin:Byte_Select // This block needs to be updated for 64bit
case(MEM_funct3)
	3'b000 :  data_out =  {{24{data_out_intermediate[7]}}, data_out_intermediate[7:0]}; // LB
	3'b001 :  data_out =  {{16{data_out_intermediate[15]}}, data_out_intermediate[15:0]}; // LH
	3'b010 :  data_out =  data_out_intermediate; // LW
	3'b100 :  data_out =  {{24{1'b0}}, data_out_intermediate[7:0]}; // LBU              
	3'b101 :  data_out =  {{16{1'b0}}, data_out_intermediate[15:0]}; // LHU
	default:  data_out =  data_out_intermediate; // LW
endcase
end


// Byte enable logic
logic [WORDSIZE-1:0] ByteEn;

always_comb
begin
	case(MEM_funct3)
		3'b000 : ByteEn = 4'b0001;
	   3'b001 : ByteEn = 4'b0011;
	   3'b010 : ByteEn = 4'b1111;
	   3'b100 : ByteEn = 4'b0001;
	   3'b101 : ByteEn = 4'b0011;
	   default: ByteEn = 4'b1111;
	endcase
end

always_comb
begin
if(WORDSPERLINE > 1)
	benA = ByteEn << (addr[BYTEOFFSET+:WORDOFFSET] * WORDSIZE);
else
	benA[0] = ByteEn;
end





/***********************************************************************
* Memory arrays to save tags, valid bits, dirty bits for each cache line.
***********************************************************************/
/* synthesis syn_ramstyle = "MLAB, no_rw_check"*/
reg [TAGWIDTH-1:0]tags[0:CACHEDEPTH-1];
reg valid[0:CACHEDEPTH-1];
//logic dirty[0:CACHEDEPTH-1];



//assign hit = ( ((c_state == IDLE) & (tags[cindex] == ctag) & (valid[cindex]) & (n_state != INVALIDATE)) | ((c_state == PREIDLE) & (tags[cindex] == ctag) & (valid[cindex]) & (addr == bak_addr)) )?1'b1: 1'b0;


always_comb
begin
	if ((c_state == IDLE) & (tags[cindex] == ctag) & (valid[cindex]) & (n_state != INVALIDATE))
		hit = 1'b1;
	else if ((c_state == PREIDLE) & (tags[cindex] == ctag) & (valid[cindex]) & (addr == bak_addr))
		hit = 1'b1;
	else
		hit = 1'b0;
end


/********* control logic **************/
always_ff @(posedge clk, posedge rst)
begin
if(rst)
	c_state <= IDLE;
else
	c_state <= n_state;
end

always_comb
begin
	case(c_state)
	IDLE:begin
		if(invalidate & sneqcur)
			n_state = INVALIDATE;
		else if((re | we) && ~hit)begin
			n_state = CACHEMISS;
		end
		else if(re & we & hit)
		begin
			n_state = WRITETHROUGH;
		end
		else
		begin
			n_state = IDLE;
		end
	end
	INVALIDATE:begin
		n_state = IDLE;
	end
	WRITETHROUGH:begin
		if(invalidate & sneqbak)	// a write has taken place for the same cache line I'm writing to.
			n_state = CACHEMISS;
		else
			n_state = W_MEMACCESS;
	end
	R_MEMACCESS:begin
		if(mem2cache_ready == 1)
			n_state = CACHEUPDATE;
		else
			n_state = R_MEMACCESS;
	end
	W_MEMACCESS:begin
		if(invalidate & sneqbak)
			n_state = CACHEMISS;
		else if(mem2cache_ready == 1)
			n_state = PREIDLE;
		else
			n_state = W_MEMACCESS;
	end
	PREIDLE:begin
		n_state = IDLE;
	end
	CACHEMISS:begin
		n_state = R_MEMACCESS;
	end
	//CACHEUPDATE: n_state = UPDATEWAIT;
	CACHEUPDATE:begin
		if(invalidate & sneqbak)
			n_state = CACHEMISS;
		else begin
			if(bak_we)  // update from write miss
				n_state = UPDATEWAIT;
			else			// update from read miss. Just update the cache and go to IDLE state.
				n_state = IDLE;
		end
	end
	UPDATEWAIT:begin
		if(invalidate & sneqbak)
			n_state = CACHEMISS;
		else
			n_state = WRITEBACK;
	end
	WRITEBACK:begin
		if(invalidate & sneqbak)
			n_state = CACHEMISS;
		else begin
			if(mem2cache_ready == 0)
				n_state = W_MEMACCESS;
			else
				n_state = WRITEBACK;
		end
	end
	default:begin
		n_state = IDLE;
	end
	endcase
end

// register the inputs from core at IDLE state, so that the cache can have correct addresses, etc. even if the signals from core changes.
always_ff @(posedge clk)
begin
	if(c_state == IDLE)
	begin
		bak_we <= we;
		bak_re <= re;
		bak_data_in <= data_in;
		bak_addr <= addr;
		bak_memfunc <= MEM_funct3;
		bak_cindex <= cindex;
		bak_ctag <= ctag;
		bak_ByteEn <= ByteEn;
		bak_hit <= hit;
	end
end


// update tag bits
always_ff @(posedge clk)
begin
	if(c_state == CACHEUPDATE)
		tags[bak_cindex] = bak_ctag;
end

// update valid bits
always_ff @(posedge clk)
begin
	if(rst)begin
		for(int it=0;it<CACHEDEPTH; it++)
			valid[it] = 1'b0;
	end
	else if(invalidate)
		valid[snoop_index] = 1'b0;
	else if(c_state == CACHEUPDATE)
			valid[bak_cindex] = 1'b1;
end

// setup write data and write enable for lower level cache/memory
always_ff @(posedge clk, posedge rst)begin
	if(rst)begin
		cache2mem_data <= 'd0;
	end
	else if(c_state == WRITETHROUGH)begin
		for(integer it=0; it<WORDSPERLINE; it++)begin
			if(it == bak_addr[BYTEOFFSET +: WORDOFFSET])
				cache2mem_data[it] <= bak_data_in;
			else
				cache2mem_data[it] <= qA[it];
		end
	end
	else if(c_state == WRITEBACK) begin  // write back after a cache update caused by a cache miss.
			cache2mem_data <= qB;
	end
end


//cache2mem_we
always_comb begin
	if(rst)
		cache2mem_we = 1'b0;
	else if(c_state==WRITEBACK)
		cache2mem_we = 1'b1;
	else if(c_state==W_MEMACCESS && mem2cache_ready==0 )
		cache2mem_we = 1'b1;
	else
		cache2mem_we = 1'b0;
end


// set address for lower level cache/memory access
always_comb
begin
	cache2mem_addr <= bak_addr >> (WORDOFFSET + BYTEOFFSET);
end


// cache2mem_re
always_ff @(posedge clk, posedge rst)begin
	if(rst)
		cache2mem_re <= 1'b0;
	else if(c_state == WRITETHROUGH || c_state == CACHEMISS || c_state == W_MEMACCESS || c_state == R_MEMACCESS || c_state == CACHEUPDATE || c_state==UPDATEWAIT || c_state==WRITEBACK)
		cache2mem_re <= 1'b1;
	else
		cache2mem_re <= 1'b0;
end



// write data to cache
always_comb begin
	if(rst)begin
		dataB = 'd0;
		addrB = 'd0;
		benB = 'd0;
		weB = 'd0;
	end
	else if(c_state == CACHEUPDATE)begin
		addrB = {WORDSPERLINE{bak_cindex}};
		weB = {WORDSPERLINE{1'b1}};
		benB = {BLOCKSIZE{1'b1}};
		if(bak_we) begin  // cache updated due to a write miss
			for(integer it=0; it<WORDSPERLINE; it++)begin
				if(it == bak_addr[BYTEOFFSET +: WORDOFFSET])
					dataB[it] = bak_data_in;
				else
					dataB[it] = mem2cache_data[it];
			end
		end
		else begin // cache updated due to a read miss
			dataB = mem2cache_data;
		end
	end
	else begin
		dataB = 'd0;
		addrB = {WORDSPERLINE{bak_cindex}};
		benB = 'd0;
		weB = 'd0;
	end
end

/********* control logic **************/

// Snooping logic. Invalidation on writes.
assign snoop_tag = snoop_addr[(BYTEOFFSET+WORDOFFSET+ADDRWIDTH) +: TAGWIDTH];
assign snoop_index = snoop_addr[(BYTEOFFSET+WORDOFFSET)+:ADDRWIDTH];
assign invalidate = (~granted & snoop_we & (tags[snoop_index]==snoop_tag) & valid[snoop_index]);
assign sneqcur = (snoop_index == cindex & snoop_tag == ctag)? 1'b1: 1'b0;
assign sneqbak = (snoop_index == bak_cindex & snoop_tag == bak_ctag)? 1'b1: 1'b0;

assign out_addr = bak_addr;

assign test_sig = ( ((c_state == IDLE) & (tags[cindex] == ctag) & (valid[cindex]) & (n_state != INVALIDATE)) | ((c_state == PREIDLE) & (tags[cindex] == ctag) & (valid[cindex]) & (addr == bak_addr)) )?1'b1: 1'b0;


endmodule