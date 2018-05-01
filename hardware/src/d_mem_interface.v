/** @module : d_memory_interface
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

module d_mem_interface #(
    parameter CORE = 0,
    parameter DATA_WIDTH = 32,
    parameter INDEX_BITS = 6,
    parameter OFFSET_BITS = 3,
    parameter ADDRESS_BITS = 20
) (
    input clock,
    input reset,
    input stall,
    input read,
    input write,
    input [ADDRESS_BITS-1:0] address,
    input [DATA_WIDTH-1:0] in_data,

    output valid,
    output ready,
    output [ADDRESS_BITS-1:0] out_addr,
    output [DATA_WIDTH-1:0] out_data,

    input  report,

    // I/O Ports
    output [DATA_WIDTH-1:0] mm_reg,

    input pixel_clock,
    input [18:0] fb_read_addr,
    output red,
    output green,
    output blue,

    input clock_baud_gen,
    input serial_rx,
    output serial_tx,

    output [DATA_WIDTH-1:0] interrupt_PC,
    output [DATA_WIDTH-1:0] interrupt_trigger

);

/*************
* MEMORY MAP *
*************/
localparam BSRAM_MIN_ADDR   = 32'h00000000;
localparam BSRAM_MAX_ADDR   = 32'h000003FF;
localparam FB_MIN_ADDR      = 32'h80000000;
localparam FB_MAX_ADDR      = 32'h801FFFFF;
localparam MM_R_ADDR        = 32'h90000000;
localparam RX_ADDR          = 32'h90000010;
localparam TX_ADDR          = 32'h90000020;
localparam RX_READY_ADDR    = 32'h90000014;
localparam TX_READY_ADDR    = 32'h90000024;
localparam INT_PC_ADDR      = 32'h90000030;
localparam INT_TRIGGER_ADDR = 32'h90000034;

wire [DATA_WIDTH-1:0] bsram_out_data;
wire [DATA_WIDTH-1:0] mm_reg_out_data;
wire [DATA_WIDTH-1:0] fb_out_data;
wire [DATA_WIDTH-1:0] uart_out_data;
wire [DATA_WIDTH-1:0] interrupt_out_data;

wire bsram_select;
wire interrupt_select;
wire mm_reg_select;
wire fb_select;
wire uart_select;

wire bsram_write_enable;
wire interrupt_write_enable;
wire mm_reg_write_enable;
wire fb_write_enable;
wire uart_write_enable;

// TODO: Fix the range of addresses. Right now, they assume the order is
// preserved.
assign bsram_select = (address >= BSRAM_MIN_ADDR) && (address <= BSRAM_MAX_ADDR);
assign fb_select = (address >= FB_MIN_ADDR) && (address <= FB_MAX_ADDR);
assign mm_reg_select = address == MM_R_ADDR;
// TODO: Fix the range to be dependent on each address of the uart.
//       Or change the uart to have an address range instead of 4 unique
//       addresses
assign uart_select = (address >= RX_ADDR) && (address <= TX_READY_ADDR);
assign interrupt_select = (address >= INT_PC_ADDR) && (address <= INT_TRIGGER_ADDR);

assign bsram_write_enable = bsram_select & write;
assign fb_write_enable = fb_select & write;
assign mm_reg_write_enable = mm_reg_select & write;
assign uart_write_enable = uart_select & write;
assign interrupt_write_enable = interrupt_select & write;

assign out_data = bsram_select ? bsram_out_data :
                  uart_select  ? uart_out_data  : {DATA_WIDTH{1'b0}};

assign out_addr = read ? address : 1'b0;
assign valid    = (read | write)? 1'b1 : 1'b0;
assign ready    = (read | write)? 1'b0 : 1'b1; // Just for testing now

BSRAM #(
    .CORE(CORE),
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(11)
) RAM (
    .clock(clock),
    .reset(reset),
    .readEnable(read),
    .readAddress(address),
    .readData(bsram_out_data),

    .writeEnable(bsram_write_enable),
    .writeAddress(address),
    .writeData(in_data),

    .report(report)
);

frame_buffer #(
    .DATA_WIDTH(3),
    .ADDR_WIDTH(19), // ceil(log2(640*480))
    .MIN_ADDR(FB_MIN_ADDR),
    .MAX_ADDR(FB_MAX_ADDR)
) fb0 (
    // CPU Side
    .write_clock(clock),
    .data(in_data[2:0]),
    .write_addr(address),
    .we(fb_write_enable),

    // VGA Side
    .read_clock(pixel_clock),
    .read_addr(fb_read_addr),
    .q({blue, green, red})
);

mm_reg #(
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR(MM_R_ADDR)
) mm_reg0 (
    .clock(clock),
    .reset(reset),

    .we(mm_reg_write_enable),
    .data(in_data),
    .addr(address),

    .r(mm_reg)
);


mm_uart #(
    .DATA_WIDTH(DATA_WIDTH),
    .RX_ADDR(RX_ADDR),
    .TX_ADDR(TX_ADDR),
    .RX_READY_ADDR(RX_READY_ADDR),
    .TX_READY_ADDR(TX_READY_ADDR)
) uart0 (
    .clock(clock),
    .clock_baud_gen(clock_baud_gen),
    .reset(reset),
    .we(uart_write_enable),
    .data_in(in_data),
    .addr(address),
    .data_out(uart_out_data),
    // UART I/O
    .serial_rx(serial_rx),
    .serial_tx(serial_tx)

);

// TODO: Use ADDR_BITS param instead of data width for address
mm_interrupt #(
    .DATA_WIDTH(DATA_WIDTH),
    .INT_PC_ADDR(INT_PC_ADDR),
    .INT_TRIGGER_ADDR(INT_TRIGGER_ADDR)
) mm_interrupt0 (
    .clock(clock),
    .reset(reset),
    .stall(stall),

    .we(interrupt_write_enable),
    .data(in_data),
    .addr(address),

    .PC_reg(interrupt_PC),
    .trigger_reg(interrupt_trigger)
);



reg [31: 0] cycles;
always @ (posedge clock) begin
    cycles <= reset? 0 : cycles + 1;
    if (report)begin
        $display ("------ Core %d Memory Interface - Current Cycle %d --", CORE, cycles);

        $display ("| Address     [%h]", address);
        $display ("| Read        [%b]", read);
        $display ("| Write       [%b]", write);
        $display ("| Out Data    [%h]", out_data);
        $display ("| In Data     [%h]", in_data);
        $display ("| Ready       [%b]", ready);
        $display ("| Valid       [%b]", valid);
        $display ("----------------------------------------------------------------------");
    end
end

endmodule

