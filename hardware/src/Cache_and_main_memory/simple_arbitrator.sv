/*****************************************
* Module: simple_arbitrator
* Author: Sahan Bandara
*
*****************************************/

module simple_arbitrator #(
parameter int N = 32,  // 32 bit machine
parameter int BLOCKSIZE = 8,  // Bytes per line (block sise in Bytes)
parameter int WORDSIZE = 4,  // word size in Bytes
parameter int WORDSPERLINE = BLOCKSIZE/WORDSIZE
)(
input clk, rst,

input [N-1:0] addr_1,addr_2,
input [WORDSPERLINE-1:0][N-1:0] data_in_1,data_in_2,
input re_1,re_2,
input we_1,we_2,
output reg [WORDSPERLINE-1:0][N-1:0] data_out_1,data_out_2,
output reg hit_1, hit_2,
output reg ready_1,ready_2, // to indicate that access is granted

// to L2
output reg [N-1:0] addr,
output reg [WORDSPERLINE-1:0][N-1:0] data_in,
output reg re,
output reg we,
input [WORDSPERLINE-1:0][N-1:0] data_out,
input hit

);

// internal variables
typedef enum{idle,s1,s2} st;
st state, next;

always_ff @(posedge clk, rst)begin
	if(rst)
		state <= idle;
	else
		state <= next;
end

always_comb begin
	case(state)
		idle:begin
			if(re_1)
				next = s1;
			else if(re_2)
				next = s2;
			else
				next = idle;
		end
		s1:begin
			if(re_1)
				next = s1;
			else
				next = idle;
		end
		s2:begin
			if(re_2)
				next = s2;
			else
				next = idle;
		end
		default: next = idle;
	endcase
end

// assign outputs
always_comb begin
	case(state)
		idle:begin
			data_out_1 = 'd0;
			data_out_2 = 'd0;
			hit_1 = 1'b0;
			hit_2 = 1'b0;
			ready_1 = 1'b0;
			ready_2 = 1'b0;
			addr = 'd0;
			data_in = 'd0;
			re = 1'b0;
			we = 1'b0;
		end
		s1:begin
			data_out_1 = data_out;
			data_out_2 = 'd0;
			hit_1 = hit;
			hit_2 = 1'b0;
			ready_1 = 1'b1;
			ready_2 = 1'b0;
			addr = addr_1;
			data_in = data_in_1;
			re = re_1;
			we = we_1;
		end
		s2:begin
			data_out_1 = 'd0;
			data_out_2 = data_out;
			hit_1 = 1'b0;
			hit_2 = hit;
			ready_1 = 1'b0;
			ready_2 = 1'b1;
			addr = addr_2;
			data_in = data_in_2;
			re = re_2;
			we = we_2;
		end
	endcase
end











endmodule