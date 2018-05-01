module baud_gen (
    input clock,
    input reset,
    output reg clock_baud_9600
);

// Use 25.175MHz because it is the VGA pixel clock for 640x480
localparam TICKS_PER_BAUD_TICK = 1308; // 25.125MHz clk to 9600 baud
//localparam TICKS_PER_BAUD_TICK = 1302; // 25MHz clk to 9600 baud
//localparam TICKS_PER_BAUD_TICK = 2604; // 50MHz clk to 9600 baud

reg [31:0] counter;

always@(posedge clock) begin
    if(reset)
        counter <= 32'd0;
    else if(counter < TICKS_PER_BAUD_TICK )
        counter <= counter + 32'd1;
    else
        counter <= 32'd0;
end

always@(posedge clock) begin
    if(reset)
        clock_baud_9600 <= 1'b0;
    else if(counter == 32'd0)
        clock_baud_9600 <= ~clock_baud_9600;
end

endmodule
