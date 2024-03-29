/** @module : memory
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

module memory_unit #(
    parameter CORE = 0,
    parameter DATA_WIDTH = 32,
    parameter INDEX_BITS = 6,
    parameter OFFSET_BITS = 3,
    parameter ADDRESS_BITS = 20,
    parameter PRINT_CYCLES_MIN = 1,
    parameter PRINT_CYCLES_MAX = 1000
) (
    input clock,
    input reset,
    input stall,
    input load,
    input store,
    input [ADDRESS_BITS-1:0] address,
    input [DATA_WIDTH-1:0] store_data,
    input report,

    output [ADDRESS_BITS-1:0] data_addr,
    output [DATA_WIDTH-1:0] load_data,
    output valid,
    output ready,

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

d_mem_interface #(
    .CORE(CORE),
    .DATA_WIDTH(DATA_WIDTH),
    .INDEX_BITS(INDEX_BITS),
    .OFFSET_BITS(OFFSET_BITS),
    .ADDRESS_BITS(ADDRESS_BITS)
) d_mem_interface0 (
    .clock(clock),
    .reset(reset),
    .stall(stall),
    .read(load),
    .write(store),
    .address(address),
    .in_data(store_data),
    .out_addr(data_addr),
    .out_data(load_data),
    .valid(valid),
    .ready(ready),
    .report(report),

    // I/O Ports
    .mm_reg(mm_reg),

    .pixel_clock(pixel_clock),
    .fb_read_addr(fb_read_addr),
    .red(red),
    .green(green),
    .blue(blue),

    .clock_baud_gen(clock_baud_gen),
    .serial_rx(serial_rx),
    .serial_tx(serial_tx),

    .interrupt_PC(interrupt_PC),
    .interrupt_trigger(interrupt_trigger)

);

reg [31: 0] cycles;
always @ (posedge clock) begin
    cycles <= reset? 0 : cycles + 1;
    //if (report & ((cycles >=  PRINT_CYCLES_MIN) & (cycles < PRINT_CYCLES_MAX +1)))begin
    if (report)begin
        $display ("------ Core %d Memory Unit - Current Cycle %d -------", CORE, cycles);
        $display ("| Address     [%h]", address);
        $display ("| Load        [%b]", load);
        $display ("| Data Address[%h]", data_addr);
        $display ("| Load Data   [%h]", load_data);
        $display ("| Store       [%b]", store);
        $display ("| Store Data  [%h]", store_data);
        $display ("| Ready       [%b]", ready);
        $display ("| Valid       [%b]", valid);
        $display ("----------------------------------------------------------------------");
    end
end

endmodule
