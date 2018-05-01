/** @module : writeback_pipe_unit
 *  @author : Adaptive & Secure Computing Systems (ASCS) Laboratory
 
 *  Copyright (c) 2018 BRISC-V (ASCS/ECE/BU)
 *  Permission is hereby granted, free of charge, to any person obtaining a copy
 *  of this software and associated documentation files (the "Software"), to deal
 *  in the Software without restriction, including without limitation the rights
 *  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *  copies of the Software, and to permit persons to whom the Software is
 *  furnished to do so, subject to the following conditions:
 *  The above copyright notice and this permission notice shall be included in
 *  all copies or substantial portions of the Software.

 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 *  THE SOFTWARE.
 */
//////////////////////////////////////////////////////////////////////////////////
module writeback_pipe_unit #(parameter  DATA_WIDTH = 32,
                              ADDRESS_BITS = 20)(

    input clock, reset,
    input regWrite_writeback,
    input [4:0] write_reg_writeback,
    input [DATA_WIDTH-1:0] write_data_writeback,
    input write_writeback,

    output regWrite_fetch,
    output [4:0] write_reg_fetch,
    output [DATA_WIDTH-1:0] write_data_fetch,
    output write_fetch
);

reg [4:0] write_reg_writeback_to_fetch;
reg [DATA_WIDTH-1:0] write_data_writeback_to_fetch;
reg  write_writeback_to_fetch;
reg regWrite_writeback_to_fetch;


assign regWrite_fetch    =  regWrite_writeback_to_fetch;
assign write_reg_fetch   =  write_reg_writeback_to_fetch;
assign write_data_fetch  =  write_data_writeback_to_fetch;
assign write_fetch       =  write_writeback_to_fetch;


always @(posedge clock) begin
   if(reset) begin
       write_reg_writeback_to_fetch     <= 5'b0;
       write_data_writeback_to_fetch    <= {DATA_WIDTH{1'b0}};
       write_writeback_to_fetch         <= 1'b0;
       regWrite_writeback_to_fetch      <= 1'b0;
   end
   else begin
       write_reg_writeback_to_fetch     <=  write_reg_writeback;
       write_data_writeback_to_fetch    <=  write_data_writeback;
       write_writeback_to_fetch         <=  write_writeback;
       regWrite_writeback_to_fetch      <=  regWrite_writeback;
   end
end
endmodule
