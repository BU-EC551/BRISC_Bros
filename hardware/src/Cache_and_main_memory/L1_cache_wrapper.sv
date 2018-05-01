module L1_cache_wrapper #(
parameter CORE = 0, DATA_WIDTH = 32, INDEX_BITS = 6, 
OFFSET_BITS = 3, ADDRESS_BITS = 20,
ADDRWIDTH = INDEX_BITS,
BLOCKSIZE = 1 << OFFSET_BITS, //Assuming OFFSET_BITS is the full offset which is Byte offset + word offset.
WORDSIZE = 4,
WORDSPERLINE = BLOCKSIZE/WORDSIZE,
N = DATA_WIDTH
)(
input clock, reset, 
input read, write,
input [ADDRESS_BITS-1:0] address,
input [DATA_WIDTH-1:0]   in_data,
output valid, ready, hit,
output[ADDRESS_BITS-1:0] out_addr,
output[DATA_WIDTH-1:0]   out_data,

input  report,

// memory side signals
input [WORDSPERLINE-1:0][N-1:0]mem2cache_data,
input mem2cache_ready,
output [ADDRESS_BITS-1:0]cache2mem_addr,
output [WORDSPERLINE-1:0][N-1:0]cache2mem_data,
output cache2mem_we,
output cache2mem_re,

//snooping signals
input [N-1:0]snoop_addr,
input snoop_we,

input granted
);

wire hit_signal, test_signal;

L1_cache #(
.N(DATA_WIDTH),
.ADDRWIDTH(ADDRWIDTH),
.BLOCKSIZE(BLOCKSIZE),
.WORDSIZE(WORDSIZE)
)cache(
.clk(clock),
.rst(reset),

//processor side signals
.addr(address),
.data_in(in_data),
.MEM_funct3(3'b010),
.re(read),  // read enable
.we(write),  // write enable
.data_out(out_data),
.hit(hit_signal),  // informs the processor of cache hit/miss processor should stall when this output is low.
.test_sig(test_signal),
.out_addr(out_addr),

// memory side signals
.mem2cache_data(mem2cache_data),
.mem2cache_ready(mem2cache_ready),
.cache2mem_addr(cache2mem_addr),
.cache2mem_data(cache2mem_data),
.cache2mem_we(cache2mem_we),
.cache2mem_re(cache2mem_re),

//snooping signals
.snoop_addr(snoop_addr),
.snoop_we(snoop_we),

.granted(granted)
);


assign hit = hit_signal;

endmodule