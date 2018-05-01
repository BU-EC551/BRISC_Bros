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
module tb_double_tx();

reg clock, reset, start, stall;
reg [19:0] prog_address;
wire report; // performance reporting

wire [31:0] current_pc;

// MM I/O
wire status;

wire pixel_clock;
wire red;
wire green;
wire blue;

reg serial_rx;
wire serial_tx;


// For I/O functions
reg [1:0]    from_peripheral;
reg [31:0]   from_peripheral_data;
reg          from_peripheral_valid;

wire [1:0]  to_peripheral;
wire [31:0] to_peripheral_data;
wire        to_peripheral_valid;


assign pixel_clock = clock;


/*******************************************************************************
* Generate sample RX data
*******************************************************************************/
reg [5:0] rx_state;
reg rx_enable;
wire clock_baud_9600;

baud_gen baud_gen_inst(
    .clock(clock),
    .reset(reset),
    .clock_baud_9600(clock_baud_9600)
);

always@(posedge clock_baud_9600) begin
    if(rx_enable) begin
        case(rx_state) // Transmit "B <return>"
            6'd0: serial_rx <= 1'b0; // Start Bit
            6'd1: serial_rx <= 1'b0; // Bit 0
            6'd2: serial_rx <= 1'b1; // Bit 1
            6'd3: serial_rx <= 1'b0; // Bit 2
            6'd4: serial_rx <= 1'b0; // Bit 3
            6'd5: serial_rx <= 1'b0; // Bit 4
            6'd6: serial_rx <= 1'b0; // Bit 5
            6'd7: serial_rx <= 1'b1; // Bit 6
            6'd8: serial_rx <= 1'b0; // Bit 7
            6'd9: serial_rx <= 1'b1; // Stop Bit
            6'd10: serial_rx <= 1'b1; // IDLE 
            6'd11: serial_rx <= 1'b0; // Start Bit 
            6'd12: serial_rx <= 1'b0; // Bit 0
            6'd13: serial_rx <= 1'b0; // Bit 1
            6'd14: serial_rx <= 1'b0; // Bit 2
            6'd15: serial_rx <= 1'b0; // Bit 3
            6'd16: serial_rx <= 1'b1; // Bit 4
            6'd17: serial_rx <= 1'b1; // Bit 5
            6'd18: serial_rx <= 1'b0; // Bit 6
            6'd19: serial_rx <= 1'b1; // Bit 7
            6'd20: serial_rx <= 1'b1; // Stop Bit
            default: serial_rx <= 1'b1;
        endcase

        if(rx_state < 6'd20)
            rx_state <= rx_state + 1;
        else
            rx_state <= 4'd0;
    end else begin
        serial_rx <= 1'b1;
        rx_state <= 6'd0;
    end
end

//assign report = ( (current_pc >= 32'h00000a2c) & (current_pc <= 32'h00000a70) );
assign report = (current_pc == 32'h00000118);

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

          .pixel_clock(pixel_clock),
          .fb_read_addr(19'd0),
          .red(red),
          .green(green),
          .blue(blue),

          .clock_baud_gen(clock),
          .serial_rx(serial_rx),
          .serial_tx(serial_tx)

);

    // Clock generator
    always #1 clock = ~clock;

    always@(posedge clock)begin
        if(current_pc == 32'h00000118) $stop();
    end

    initial begin
          clock  = 0;
          reset  = 1;
          stall  = 0;
          prog_address = 'h0;
          rx_enable = 1'b0;

          #10
          reset = 0;
          stall = 0;
          rx_enable = 1'b1;

          //#1000
          //$stop();

     end

endmodule
