/*****************************************
* Module: L2_cache
* Author: Sahan Bandara
*
*****************************************/

module L2_cache #(
parameter int N = 32,  // 32 bit machine
parameter int ADDRWIDTH = 10,  // 1024 cache lines
parameter int BLOCKSIZE = 8,  // Bytes per line (block sise in Bytes)
parameter int WORDSIZE = 4,  // word size in Bytes
parameter int ASSOCIATIVITY = 1,  // associativity set to 1 (not used in this implementation at this point)
parameter int WORDSPERLINE = BLOCKSIZE/WORDSIZE
)(
input clk, rst,
// signals to L1 cache
input [N-1:0] addr,
input [WORDSPERLINE-1:0][N-1:0] data_in,
input re,  // read enable
input we,  // write enable
output [WORDSPERLINE-1:0][N-1:0] data_out,
output reg hit, 
//output reg ready,

// memory side signals
input [WORDSPERLINE-1:0][N-1:0]mem2cache_data,
input mem2cache_ready,
output reg[N-1:0]cache2mem_addr,
output reg[WORDSPERLINE-1:0][N-1:0]cache2mem_data,
output reg cache2mem_we,
output reg cache2mem_re
);

localparam CACHEDEPTH = 1 << ADDRWIDTH;
localparam TAGWIDTH = N - ADDRWIDTH;

// internal signals, variables
typedef enum {IDLE,CACHEMISS,R_MEMACCESS,R_MEMACCESS2,UPDATE,UPDATEWAIT,WRITETHROUGH,W_MEMACCESS,W_MEMACCESS2,PREIDLE}state;
state c_state, n_state;

logic hit_i, write_done;
logic bak_re, bak_we, bak_hit_i;
logic [TAGWIDTH-1:0]ctag, bak_ctag;
logic [ADDRWIDTH-1:0]cindex, bak_cindex;
logic [N-1:0] bak_addr;
logic [WORDSPERLINE-1:0][N-1:0]bak_data_in;


// memory instantiation for data
logic [N-1:0] addrA, addrB;
logic [WORDSPERLINE-1:0][N-1:0] dataA, dataB;
logic [WORDSPERLINE-1:0][N-1:0] qA, qB;
logic weA, weB;

simple_dual_port_ram #(.N(N), .WORDSPERLINE(WORDSPERLINE), .ADDRESS_WIDTH(ADDRWIDTH)) RAM1(
.addr1(addrA),
.addr2(addrB),
.data_in1(dataA), 
.data_in2(dataB), 
.we1(weA), .we2(weB), .clk(clk),
.data_out1(qA),
.data_out2(qB)
);

// memory for meta data
/* synthesis syn_ramstyle = "MLAB, no_rw_check"*/
reg [TAGWIDTH-1:0]tags[0:CACHEDEPTH-1];

reg valid[0:CACHEDEPTH-1];


/****************** control logic ****************/

// cindex and ctag
assign cindex = addrA[ADDRWIDTH-1:0];
assign ctag = addrA[ADDRWIDTH +: TAGWIDTH];

// main state machine
always_ff @(posedge clk, posedge rst)begin
	if(rst)
		c_state <= IDLE;
	else
		c_state <= n_state;
end

always_comb begin
	case(c_state)
		IDLE:begin
			if((re & ~we) & ~hit_i)
				n_state = CACHEMISS;
			else if(we)
				n_state = WRITETHROUGH;
			else
				n_state = IDLE;
		end
		CACHEMISS:begin
			n_state = R_MEMACCESS;
		end
		WRITETHROUGH:begin
			n_state = W_MEMACCESS;
		end
		R_MEMACCESS:begin
			n_state = R_MEMACCESS2;
		end
		R_MEMACCESS2:begin
			n_state = UPDATE;
		end
		W_MEMACCESS:begin
			n_state = W_MEMACCESS2;
		end
		W_MEMACCESS2:begin
			n_state = PREIDLE;
		end
		PREIDLE:begin
			n_state = IDLE;
		end
		UPDATEWAIT:begin
			n_state = IDLE;
		end
		UPDATE:begin
			n_state = UPDATEWAIT;
		end
	endcase
end
// main state machine

// inputs for port A of the RAM
always_comb begin
	if(re)begin
		addrA = addr;
		dataA = data_in;
		weA = we;
	end
	else begin
		addrA = 'd0;
		dataA = 'd0;
		weA = 1'b0;
	end
end

// register the signals
always @(posedge clk, posedge rst)begin
	if(rst)begin
		bak_re <= 1'b0;
		bak_we <= 1'b0;
		bak_cindex <= 'd0;
		bak_ctag <= 'd0;
		bak_addr <= 'd0;
		bak_data_in <= 'd0;
		bak_hit_i <= 1'b0;
	end
	else if(c_state==IDLE)begin
		bak_re <= re;
		bak_we <= we;
		bak_cindex <= cindex;
		bak_ctag <= ctag;
		bak_addr <= addr;
		bak_data_in <= data_in;
		bak_hit_i <= hit_i;
	end
end

// internal hit signal
always_comb begin
	if((c_state==IDLE || c_state==PREIDLE) && tags[cindex]==ctag && valid[cindex])
		hit_i = 1'b1;
	else
		hit_i = 1'b0;
end

// hit signals to L1 caches
//assign hit = hit_i;

always_ff @(posedge clk, posedge rst)begin
	if(rst)
		write_done <= 1'b0;
	else if(c_state==W_MEMACCESS)
		write_done <= 1'b1;
	else if(c_state==IDLE && hit)
		write_done <=1'b0;
end

always_comb begin
	if(rst)begin
		hit = 1'b0;
	end
	else if(c_state==IDLE || c_state==PREIDLE)begin
		if(~we | (we & write_done))
			hit = hit_i;
		else
			hit = 1'b0;
	end
	else begin
		hit = 1'b0;
	end
end

// update tags
always_ff @(posedge clk)begin
	if(c_state==UPDATE || c_state==WRITETHROUGH)
		tags[bak_cindex] = bak_ctag;
end

// update valid bits
always_ff @(posedge clk)
begin
	if(rst)
		for(int it=0;it<CACHEDEPTH; it++)
			valid[it] = 1'b0;
	else
		if(c_state == UPDATE || c_state==WRITETHROUGH)
			valid[bak_cindex] = 1'b1;
end

// assign outputs to L1 caches
assign data_out = (c_state==IDLE)?qA:'d0;

// address to memory
always_comb begin
	cache2mem_addr = bak_addr;
end

// setup write data and write enable for memory
always_ff @(posedge clk, posedge rst) begin
	if(rst)begin
		cache2mem_data <= 'd0;
		//cache2mem_we <= 1'b0;
	end
	else if(c_state==WRITETHROUGH || c_state==W_MEMACCESS)begin
		cache2mem_data <= dataA;
		//cache2mem_we <= 1'b1;
	end
	else begin
		cache2mem_data <= 'd0;
		//cache2mem_we <= 1'b0;
	end
end

always_comb begin
	if(rst)
		cache2mem_we <= 1'b0;
	else if(c_state==W_MEMACCESS)
		cache2mem_we <= 1'b1;
	else
		cache2mem_we <= 1'b0;
end


// cache2mem_re
always_ff @(posedge clk, posedge rst)begin
	if(rst)
		cache2mem_re <= 1'b0;
	else if(c_state == WRITETHROUGH || c_state == CACHEMISS || c_state == W_MEMACCESS || c_state == R_MEMACCESS/* || c_state == UPDATE*/)
		cache2mem_re <= 1'b1;
	else
		cache2mem_re <= 1'b0;
end


// write data to cache
always_comb begin
	if(rst)begin
		dataB = 'd0;
		addrB = 'd0;
		weB = 'd0;
	end
	else if(c_state == UPDATE)begin
		addrB = bak_cindex;
		weB = 1'b1;
		dataB = mem2cache_data;
	end
	else begin
		dataB = 'd0;
		addrB = 'd0;
		weB = 'd0;
	end
end


endmodule




















