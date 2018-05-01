/*****************************************
* Module: simple_dual_port_RAM
* Author: Sahan Bandara
* Not Byte addressable
*****************************************/

module simple_dual_port_ram
	#(
		parameter int
		N = 32,
		WORDSPERLINE = 2,
		ADDRESS_WIDTH = 10
)
(
	input [ADDRESS_WIDTH-1:0] addr1,
	input [ADDRESS_WIDTH-1:0] addr2,
	input [WORDSPERLINE-1:0][N-1:0] data_in1, 
	input [WORDSPERLINE-1:0][N-1:0] data_in2, 
	input we1, we2, clk,
	output [WORDSPERLINE-1:0][N-1:0] data_out1,
	output [WORDSPERLINE-1:0][N-1:0] data_out2);
	localparam RAM_DEPTH = 1 << ADDRESS_WIDTH;

	// model the RAM with two dimensional packed array
	/* synthesis syn_ramstyle = "M10K, no_rw_check"*/
	logic [WORDSPERLINE-1:0][N-1:0] ram[0:RAM_DEPTH-1];

	reg [WORDSPERLINE-1:0][N-1:0] data_reg1;
	reg [WORDSPERLINE-1:0][N-1:0] data_reg2;

	// port A
	always@(posedge clk)
	begin
		if(we1) begin
			ram[addr1] <= data_in1;
		end
	data_reg1 <= ram[addr1];
	end

	assign data_out1 = data_reg1;
   
	// port B
	always@(posedge clk)
	begin
		if(we2) begin
			ram[addr2] <= data_in2;
		end
	data_reg2 <= ram[addr2];
	end

	assign data_out2 = data_reg2;

endmodule