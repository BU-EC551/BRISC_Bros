/*****************************************
* Module: full_cache_TB
* Author: Sahan Bandara
*
*****************************************/
`define WORDSIZE 32
`define WORDSPERLINE 2

module full_cache_TB();
logic clk, rst;

logic [`WORDSIZE-1:0] addr, snoop_addr;
logic [`WORDSIZE-1:0] data_in;
logic re;  // read enable
logic we, snoop_we;
logic [`WORDSIZE-1:0] data_out;
logic hit;
logic ready;
logic granted;

logic [`WORDSPERLINE-1:0][`WORDSIZE-1:0]mem2cache_data;
logic mem2cache_ready;
logic[`WORDSIZE-1:0]cache2mem_addr;
logic[`WORDSPERLINE-1:0][`WORDSIZE-1:0]cache2mem_data;
logic cache2mem_we;
logic cache2mem_re;


// L1 D cache
L1_cache_wrapper #(
.ADDRESS_BITS(32)
)L1_d(
.clock(clk), .reset(rst),
.read(re), .write(we),
.address(addr),
.in_data(data_in),
.ready(hit),
.out_data(data_out),
.out_addr(),
.valid(), .report(),
.mem2cache_data(mem2cache_data),
.mem2cache_ready(mem2cache_ready),
.cache2mem_addr(cache2mem_addr),
.cache2mem_data(cache2mem_data),
.cache2mem_we(cache2mem_we),
.cache2mem_re(cache2mem_re),
.snoop_addr,
.snoop_we,
.granted
);


always
#5 clk = ~clk;

initial
begin
clk=1;
rst=1;
#40;//40
rst=0;
granted = 0;
#10; //50
addr = 32'h00000001;
re = 1;
#35;//85
mem2cache_data[0] = 32'h00000013;
mem2cache_data[1] = 32'h00000023;
mem2cache_ready = 1;
#25;//110
addr = 32'h00000004;
#5;//115
mem2cache_ready = 0;
#5;//120
addr = 32'h00000008;
#45;//165
mem2cache_data[0] = 32'hEF000013;
mem2cache_data[1] = 32'h70000083;
mem2cache_ready = 1;
#25;//190
addr = 32'h00000004;
we = 1;
data_in = 32'h00000330;
#5;//195
mem2cache_ready = 0;
#6;//201
we = 0;
addr = 32'h00000000;
#4;//205
snoop_addr = 32'h00000004;
snoop_we = 1; 
#20;//225
snoop_we = 0;
#10;//235
mem2cache_data[0] = 32'h00000014;
mem2cache_data[1] = 32'h70000083;
mem2cache_ready = 1;
#35;//270
mem2cache_ready = 0;
#25;//295
mem2cache_ready = 1;
#15;//310
we = 0;
#5;//315
mem2cache_ready = 0;
#5;//320
addr = 32'h0000000C;
#10;//330
addr = 32'h00000008;
#5;//335
snoop_addr = 32'h00000008;
snoop_we = 1;


/*
#5;//315
mem2cache_ready = 0;
#5;//320
we = 1;
#42;//362
snoop_addr = 32'h00000008;
snoop_we = 1; 
#18;//380
snoop_we = 0;
#25;//405
mem2cache_data[0] = 32'h000000FF;
mem2cache_data[1] = 32'hC0000085;
mem2cache_ready = 1;
#35;//440
mem2cache_ready = 0;
#40;//480
mem2cache_ready = 1;
#20;//500
mem2cache_ready = 0;
we = 0;
addr = 32'h00000000;*/



end

endmodule
