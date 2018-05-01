module uart_rx #(
    parameter COUNTER_WIDTH = 4
) (
    input clock_25, // a 25MHz or 25.125MHz clock.
    input clock_baud_9600,
    input reset,

    input serial_rx,
    output reg rx_valid,
    output reg [7:0] rx_data
);

localparam IDLE = 4'h9;
//localparam START_BIT = 4'hA;
localparam BIT0 = 4'h0;
localparam BIT1 = 4'h1;
localparam BIT2 = 4'h2;
localparam BIT3 = 4'h3;
localparam BIT4 = 4'h4;
localparam BIT5 = 4'h5;
localparam BIT6 = 4'h6;
localparam BIT7 = 4'h7;
localparam STOP_BIT = 4'h8;

reg rx_bit;
reg [3:0] state;
reg [COUNTER_WIDTH-1:0] sample_counter;

always@(posedge clock_25) begin
    if(reset) begin
        sample_counter <= 2'b11; // Rx is high when idle
    //end else if( ~serial_rx && sample_counter != {COUNTER_WIDTH{1'b0}} ) begin
    end else if( ~serial_rx && (|sample_counter) ) begin
        sample_counter <= sample_counter - { {COUNTER_WIDTH-1{1'b0}}, 1'b1};
    //end else if( serial_rx && sample_counter != 2'b11) begin
    end else if( serial_rx && ~(&sample_counter) ) begin
        sample_counter <= sample_counter + { {COUNTER_WIDTH-1{1'b0}}, 1'b1};
    end
end

always@(posedge clock_25) begin
    if(reset) begin
        rx_bit <= 1'b1; // Rx is high when idle
    end else if( sample_counter == {COUNTER_WIDTH{1'b0}} ) begin
        rx_bit <= 1'b0;
    end else if( sample_counter == {COUNTER_WIDTH{1'b1}} ) begin
        rx_bit <= 1'b1;
    end
end



always@(posedge clock_baud_9600) begin
    if(reset) begin
        state <= IDLE;
        rx_data <= 8'h00;
        rx_valid <= 1'b0;
    end else begin
        case(state)
            IDLE:
            begin
                state <= rx_bit ? IDLE : BIT0;
                rx_data <= 8'h00;
                rx_valid <= 1'b0;
            end
            BIT0:
            begin
                state <= BIT1;
                rx_data[0] <= serial_rx;
                rx_valid <= 1'b0;
            end
            BIT1:
            begin
                state <= BIT2;
                rx_data[1] <= serial_rx;
                rx_valid <= 1'b0;
            end
            BIT2:
            begin
                state <= BIT3;
                rx_data[2] <= serial_rx;
                rx_valid <= 1'b0;
            end
            BIT3:
            begin
                state <= BIT4;
                rx_data[3] <= serial_rx;
                rx_valid <= 1'b0;
            end
            BIT4:
            begin
                state <= BIT5;
                rx_data[4] <= serial_rx;
                rx_valid <= 1'b0;
            end
            BIT5:
            begin
                state <= BIT6;
                rx_data[5] <= serial_rx;
                rx_valid <= 1'b0;
            end
            BIT6:
            begin
                state <= BIT7;
                rx_data[6] <= serial_rx;
                rx_valid <= 1'b0;
            end
            BIT7:
            begin
                state <= STOP_BIT;
                rx_data[7] <= serial_rx;
                rx_valid <= 1'b0;
            end
            STOP_BIT:
            begin
                state <= IDLE;
                rx_valid <= serial_rx; // only valid if stop bit recieved
            end
            default:
            begin
                state <= IDLE;
                rx_data <= 8'h00;
                rx_valid <= 1'b0;
            end
        endcase
    end
end

endmodule
