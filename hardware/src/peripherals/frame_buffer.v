// Quartus Prime Verilog Template
// Simple Dual Port RAM with separate read/write addresses and
// separate read/write clocks

module frame_buffer #(
    parameter DATA_WIDTH=3,
    parameter ADDR_WIDTH=19,
    parameter MIN_ADDR=32'h80000000,
    parameter MAX_ADDR=32'h801FFFFF
) (
    input [(DATA_WIDTH-1):0] data,
    input [(ADDR_WIDTH-1):0] read_addr,
    input [31:0] write_addr,
    input we,
    input read_clock,
    input write_clock,
    //output reg [(DATA_WIDTH-1):0] wb,
    output reg [(DATA_WIDTH-1):0] q
);

  localparam SIZE = 2**ADDR_WIDTH;
    // Declare the RAM variable
    reg [DATA_WIDTH-1:0] ram[SIZE-1:0];

    always @ (posedge write_clock) begin
        // Write
        if (we & (write_addr >= MIN_ADDR) & (write_addr <= MAX_ADDR) )
            ram[write_addr[ADDR_WIDTH+2-1:2]] <= data;
            //ram[write_addr[ADDR_WIDTH-1:0]] <= data;
    end

    always @ (posedge read_clock)
    //always @ (posedge write_clock)
    begin
        // Read
        q <= ram[read_addr];
    end

endmodule

