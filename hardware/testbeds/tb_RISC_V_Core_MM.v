/** @module : tb_double_tx
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
 *
 */

`timescale 1ps/1ps
module tb_RISC_V_Core_MM ();

reg clock, reset, start, stall;
reg [19:0] prog_address;
wire report; // performance reporting

wire [31:0] current_pc;

// MM I/O
wire status;


// For I/O functions
reg [1:0]    from_peripheral;
reg [31:0]   from_peripheral_data;
reg          from_peripheral_valid;

wire [1:0]  to_peripheral;
wire [31:0] to_peripheral_data;
wire        to_peripheral_valid;


//assign report = ( (current_pc >= 32'h00000a2c) & (current_pc <= 32'h00000a70) );
assign report = (current_pc == 32'h00000118);

/*
always@(posedge clock)begin
    if(current_pc == 32'h000000ec) $stop();
end
*/


// module RISC_V_Core #(parameter CORE = 0, DATA_WIDTH = 32, INDEX_BITS = 6, OFFSET_BITS = 3, ADDRESS_BITS = 20)
RISC_V_Core #(
          .CORE(0),
          .DATA_WIDTH(32),
          .INDEX_BITS(6),
          .OFFSET_BITS(3),
          .ADDRESS_BITS(32)
) CORE (
          .clock(clock),
          .reset(reset),
          .start(start),
          .stall_in(stall),
          .prog_address(prog_address),
          .from_peripheral(from_peripheral),
          .from_peripheral_data(from_peripheral_data),
          .from_peripheral_valid(from_peripheral_valid),
          .to_peripheral(to_peripheral),
          .to_peripheral_data(to_peripheral_data),
          .to_peripheral_valid(to_peripheral_valid),

          .report(report),
          .current_pc(current_pc),

          // I/O Ports
          .mm_reg(status),

          .pixel_clock(),
          .fb_read_addr(),
          .red(),
          .green(),
          .blue(),

          .clock_baud_gen(),
          .serial_rx(),
          .serial_tx()

);

    // Clock generator
    always #1 clock = ~clock;

    initial begin
          clock  = 0;
          reset  = 1;
          stall  = 0;
          prog_address = 'h0;

          #10
          reset = 0;
          stall = 0;

          #1000
          $stop();

     end

endmodule
