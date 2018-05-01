module mm_uart #(
  parameter DATA_WIDTH = 32,
  parameter RX_ADDR = 32'h90000010,
  parameter TX_ADDR = 32'h90000020,
  parameter RX_READY_ADDR = 32'h90000014,
  parameter TX_READY_ADDR = 32'h90000024
) (
  input clock,
  input clock_baud_gen,
  input reset,

  input we,
  input [DATA_WIDTH-1:0] data_in,
  input [DATA_WIDTH-1:0] addr,
  output [DATA_WIDTH-1:0] data_out,

  // UART I/O
  input serial_rx,
  output serial_tx

);

wire clock_baud_9600;

wire tx_fifo_full;
wire tx_fifo_empty;
wire tx_fifo_wr_rq;
wire tx_fifo_rd_rq;
wire [7:0] tx_fifo_read_data;

wire tx_start;
wire tx_busy;

wire rx_valid;
wire [7:0] rx_fifo_write_data;
wire [7:0] rx_fifo_read_data;
wire rx_fifo_full;
wire rx_fifo_empty;
wire rx_fifo_wr_rq;
wire rx_fifo_rd_rq;

mm_uart_control #(
    .DATA_WIDTH(DATA_WIDTH),
    .RX_ADDR(RX_ADDR),
    .TX_ADDR(TX_ADDR),
    .RX_READY_ADDR(RX_READY_ADDR),
    .TX_READY_ADDR(TX_READY_ADDR)
) mm_uart_ctrl_inst (
    .clock_baud_9600(clock_baud_9600),
    .reset(reset),

    .we(we),
    .addr(addr),
    .data_out(data_out),

    // Tx FIFO
    .tx_fifo_full(tx_fifo_full),
    .tx_fifo_empty(tx_fifo_empty),
    .tx_fifo_wr_rq(tx_fifo_wr_rq),
    .tx_fifo_rd_rq(tx_fifo_rd_rq),

    // UART Tx
    .tx_busy(tx_busy),
    .tx_start(tx_start),


    // Rx FIFO
    .rx_fifo_full(rx_fifo_full),
    .rx_fifo_empty(rx_fifo_empty),
    .rx_fifo_wr_rq(rx_fifo_wr_rq),
    .rx_fifo_rd_rq(rx_fifo_rd_rq),
    .rx_fifo_read_data(rx_fifo_read_data),

    // UART Rx
    .rx_valid(rx_valid)
);

baud_gen baud_gen_inst(
    .clock(clock_baud_gen),
    .reset(reset),
    .clock_baud_9600(clock_baud_9600)
);

/*******************************************************************************
* TX
*******************************************************************************/
fifo_1k tx_buffer(
	.data(data_in[7:0]),
	.rdclk(clock_baud_9600),
	.rdreq(tx_fifo_rd_rq),
	.wrclk(clock),
	.wrreq(tx_fifo_wr_rq),
	.q(tx_fifo_read_data),
	.rdempty(tx_fifo_empty),
	.wrfull(tx_fifo_full)
);

uart_tx tx(
    .clock_baud_9600(clock_baud_9600),
    .reset(reset),
    .tx_start(tx_start),
    .tx_data_in(tx_fifo_read_data),
    .serial_tx(serial_tx),
    .tx_busy(tx_busy)
);

/*******************************************************************************
* RX
*******************************************************************************/
// Normal FIFO for registered memory operations
/*
fifo_1k rx_buffer(
	.data(rx_fifo_write_data),
	.rdclk(clock),
	.rdreq(rx_fifo_rd_rq),
	.wrclk(clock_baud_9600),
	.wrreq(rx_fifo_wr_rq),
	.q(rx_fifo_read_data),
	.rdempty(rx_fifo_empty),
	.wrfull(rx_fifo_full)
);
*/

// Show-Ahead FIFO for single cycle memory operations
// TODO: Insert normal fifo when memory is registered
fifo_1k_show_ahead rx_buffer(
	.data(rx_fifo_write_data),
	.rdclk(clock),
	.rdreq(rx_fifo_rd_rq),
	.wrclk(clock_baud_9600),
	.wrreq(rx_fifo_wr_rq),
	.q(rx_fifo_read_data),
	.rdempty(rx_fifo_empty),
	.wrfull(rx_fifo_full)
);

uart_rx rx(
    .clock_25(clock_baud_gen), // a 25MHz or 25.125MHz clock.
    .clock_baud_9600(clock_baud_9600),
    .reset(reset),

    .serial_rx(serial_rx),
    .rx_valid(rx_valid),
    .rx_data(rx_fifo_write_data)
);

endmodule

