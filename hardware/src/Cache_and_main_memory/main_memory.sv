/*****************************************
* Module: main_memory
* Author: Sahan Bandara
* Main memory
*****************************************/

module main_memory #(
parameter int N = 32,  // 32 bit machine
parameter int ADDRWIDTH = 10,  // memoey capacity of 1024 lines
parameter int BLOCKSIZE = 8,  // Bytes per line (block sise in Bytes)
parameter int WORDSIZE = 4,  // word size in Bytes
parameter int WORDSPERLINE = BLOCKSIZE/WORDSIZE
)(
input clk, rst,
// signals to L2 cache
input [N-1:0] addr,
input [WORDSPERLINE-1:0][N-1:0] data_in,
input re,  // read enable
input we,  // write enable
output [WORDSPERLINE-1:0][N-1:0] data_out
);

localparam MEMDEPTH = 1 << ADDRWIDTH;

// memory array
logic [WORDSPERLINE-1:0][N-1:0] mem[0:MEMDEPTH-1];

reg [WORDSPERLINE-1:0][N-1:0] data_reg;

initial begin
	$readmemh("./factorial_swapped.vmh",mem);
end


	always@(posedge clk)
	begin
		if(we) begin
			mem[addr] <= data_in;
		end
	data_reg <= mem[addr];
	end

assign data_out = data_reg;
		
endmodule