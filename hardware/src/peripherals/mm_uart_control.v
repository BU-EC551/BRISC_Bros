module mm_uart_control #(
    parameter DATA_WIDTH = 32,
    parameter RX_ADDR = 32'h90000010,
    parameter TX_ADDR = 32'h90000020,
    parameter RX_READY_ADDR = 32'h90000014,
    parameter TX_READY_ADDR = 32'h90000024
) (
    input clock_baud_9600,
    input reset,
    input we,
    input [DATA_WIDTH-1:0] addr,
    output [DATA_WIDTH-1:0] data_out,

    // Tx FIFO
    input tx_fifo_full,
    input tx_fifo_empty,
    output tx_fifo_wr_rq,
    output tx_fifo_rd_rq,

    // UART Tx
    input tx_busy,
    output reg tx_start,

    // Rx FIFO
    input rx_fifo_full,
    input rx_fifo_empty,
    output rx_fifo_wr_rq,
    output rx_fifo_rd_rq,
    input [7:0] rx_fifo_read_data,

    // UART Rx
    input rx_valid

);


wire [DATA_WIDTH-1:0] tx_ready;
wire [DATA_WIDTH-1:0] rx_ready;
wire [DATA_WIDTH-1:0] rx_read_data;

// Data Out to CPU
assign data_out = (addr == TX_READY_ADDR) ? tx_ready     :
                  (addr == RX_READY_ADDR) ? rx_ready     :
                  (addr == RX_ADDR)       ? rx_read_data :
                  {DATA_WIDTH{1'b0}};

// Tx ready signal
assign tx_ready = { {DATA_WIDTH-1{1'b0}}, ~tx_fifo_full };

// Rx ready signal
assign rx_ready = { {DATA_WIDTH-1{1'b0}}, ~rx_fifo_empty };

// Pad data read from rx fifo
assign rx_read_data = { {DATA_WIDTH-8{1'b0}}, rx_fifo_read_data};

// Write to Tx FIFO
assign tx_fifo_wr_rq = we && (addr == TX_ADDR) && ~tx_fifo_full;

// Read from Tx FIFO
assign tx_fifo_rd_rq = tx_start && ~tx_fifo_empty;

// Write to Rx FIFO
assign rx_fifo_wr_rq = rx_valid && ~rx_fifo_full;

// Read from Rx FIFO
assign rx_fifo_rd_rq = ~we && (addr == RX_ADDR) && ~rx_fifo_empty;

always@(posedge clock_baud_9600) begin
    if(reset) begin
        tx_start <= 0;
    end else begin
        // TODO: make this nonblocking
        tx_start = ~tx_fifo_empty && ~tx_busy && ~tx_start;
    end
end

endmodule

