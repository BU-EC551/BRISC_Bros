module uart_tx(
    input clock_baud_9600,
    input reset,
    input tx_start,
    input [7:0] tx_data_in,
    output reg serial_tx,
    output reg tx_busy
);

parameter IDLE = 4'h9;
parameter START_BIT = 4'hA;
parameter BIT0 = 4'h0;
parameter BIT1 = 4'h1;
parameter BIT2 = 4'h2;
parameter BIT3 = 4'h3;
parameter BIT4 = 4'h4;
parameter BIT5 = 4'h5;
parameter BIT6 = 4'h6;
parameter BIT7 = 4'h7;
parameter STOP_BIT = 4'h8;

reg [3:0] state;
reg [7:0] tx_data;

// Register tx_data when a start bit is recieved
always@(posedge clock_baud_9600) begin
    if(reset)
        tx_data <= 8'h00;
    else if(state == START_BIT)
        tx_data <= tx_data_in;
end

always@(posedge clock_baud_9600) begin
    if(reset) begin
        state <= IDLE;
        serial_tx <= 1'b1;
        tx_busy <= 1'b0;
    end else begin
        case(state)
            IDLE:
            begin
                state <= tx_start ? START_BIT : IDLE;
                serial_tx <= 1'b1;
                tx_busy <= tx_start ? 1'b1 : 1'b0;
            end
            START_BIT:
            begin
                state <= BIT0;
                serial_tx <= 1'b0;
                tx_busy <= 1'b1;
            end
            BIT0:
            begin
                state <= BIT1;
                serial_tx <= tx_data[0];
                tx_busy <= 1'b1;
            end
            BIT1:
            begin
                state <= BIT2;
                serial_tx <= tx_data[1];
                tx_busy <= 1'b1;
            end
            BIT2:
            begin
                state <= BIT3;
                serial_tx <= tx_data[2];
                tx_busy <= 1'b1;
            end
            BIT3:
            begin
                state <= BIT4;
                serial_tx <= tx_data[3];
                tx_busy <= 1'b1;
            end
            BIT4:
            begin
                state <= BIT5;
                serial_tx <= tx_data[4];
                tx_busy <= 1'b1;
            end
            BIT5:
            begin
                state <= BIT6;
                serial_tx <= tx_data[5];
                tx_busy <= 1'b1;
            end
            BIT6:
            begin
                state <= BIT7;
                serial_tx <= tx_data[6];
                tx_busy <= 1'b1;
            end
            BIT7:
            begin
                state <= STOP_BIT;
                serial_tx <= tx_data[7];
                tx_busy <= 1'b1;
            end
            STOP_BIT:
            begin
                state <= IDLE;
                serial_tx <= 1'b1;
                tx_busy <= 1'b1;
            end
            default:
            begin
                state <= IDLE;
                serial_tx <= 1'b1;
                tx_busy <= 1'b0;
            end
        endcase
    end
end

endmodule
