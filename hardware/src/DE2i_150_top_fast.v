//`define ENABLE_PCIE
module DE2i_150_top_fast(
    ///////////CLOCK2/////////////
    input                       CLOCK2_50,

    ///////// CLOCK3 /////////
    input                       CLOCK3_50,

    ///////// CLOCK /////////
    input                       CLOCK_50,

    ///////// DRAM /////////
    /*
    output [12:0]               DRAM_ADDR,
    output [1:0]                DRAM_BA,
    output                      DRAM_CAS_N,
    output                      DRAM_CKE,
    output                      DRAM_CLK,
    output                      DRAM_CS_N,
    inout  [31:0]               DRAM_DQ,
    output [3:0]                DRAM_DQM,
    output                      DRAM_RAS_N,
    output                      DRAM_WE_N,
    */

    ///////// EEP /////////
    output                      EEP_I2C_SCLK,
    inout                       EEP_I2C_SDAT,

    ///////// ENET /////////
    output                      ENET_GTX_CLK,
    input                       ENET_INT_N,
    input                       ENET_LINK100,
    output                      ENET_MDC,
    inout                       ENET_MDIO,
    output                      ENET_RST_N,
    input                       ENET_RX_CLK,
    input                       ENET_RX_COL,
    input                       ENET_RX_CRS,
    input  [3:0]                ENET_RX_DATA,
    input                       ENET_RX_DV,
    input                       ENET_RX_ER,
    input                       ENET_TX_CLK,
    output [3:0]                ENET_TX_DATA,
    output                      ENET_TX_EN,
    output                      ENET_TX_ER,

    ///////// FAN /////////
    inout                       FAN_CTRL,

    ///////// FL /////////
    output                      FL_CE_N,
    output                      FL_OE_N,
    input                       FL_RY,
    output                      FL_WE_N,
    output                      FL_WP_N,
    output                                             FL_RESET_N,
    ///////// FS /////////
    inout  [31:0]               FS_DQ,
    output [26:0]               FS_ADDR,
    ///////// GPIO /////////
    inout  [35:0]               GPIO,

    ///////// G /////////
    input                       G_SENSOR_INT1,
    output                      G_SENSOR_SCLK,
    inout                       G_SENSOR_SDAT,

    ///////// HEX /////////
    output [6:0]                HEX0,
    output [6:0]                HEX1,
    output [6:0]                HEX2,
    output [6:0]                HEX3,
    output [6:0]                HEX4,
    output [6:0]                HEX5,
    output [6:0]                HEX6,
    output [6:0]                HEX7,

    ///////// HSMC /////////
    input                       HSMC_CLKIN0,
    input                       HSMC_CLKIN_N1,
    input                       HSMC_CLKIN_N2,
    input                       HSMC_CLKIN_P1,
    input                       HSMC_CLKIN_P2,
    output                      HSMC_CLKOUT0,
    inout                       HSMC_CLKOUT_N1,
    inout                       HSMC_CLKOUT_N2,
    inout                       HSMC_CLKOUT_P1,
    inout                       HSMC_CLKOUT_P2,
    inout  [3:0]                HSMC_D,
    output                      HSMC_I2C_SCLK,
    inout                       HSMC_I2C_SDAT,
    inout  [16:0]               HSMC_RX_D_N,
    inout  [16:0]               HSMC_RX_D_P,
    inout  [16:0]               HSMC_TX_D_N,
    inout  [16:0]               HSMC_TX_D_P,

    ///////// I2C /////////
    output                      I2C_SCLK,
    inout                       I2C_SDAT,

    ///////// IRDA /////////
    input                       IRDA_RXD,

    ///////// KEY /////////
    input [3:0]                KEY,

    /////////     LCD /////////
    inout  [7:0]                LCD_DATA,
    output                      LCD_EN,
    output                      LCD_ON,
    output                      LCD_RS,
    output                      LCD_RW,

    ///////// LEDG /////////
    output [8:0]                LEDG,

    ///////// LEDR /////////
    output [17:0]               LEDR,

    ///////// PCIE /////////
    `ifdef ENABLE_PCIE
    input                       PCIE_PERST_N,
    input                       PCIE_REFCLK_P,
    input  [1:0]                PCIE_RX_P,
    output [1:0]                PCIE_TX_P,
    output                      PCIE_WAKE_N,
    `endif 
    ///////// SD /////////
    output                      SD_CLK,
    inout                       SD_CMD,
    inout  [3:0]                SD_DAT,
    input                       SD_WP_N,

    ///////// SMA /////////
    input                       SMA_CLKIN,
    output                      SMA_CLKOUT,

    ///////// SSRAM /////////
    output                      SSRAM_ADSC_N,
    output                      SSRAM_ADSP_N,
    output                      SSRAM_ADV_N,
    output [3:0]                SSRAM_BE,
    output                      SSRAM_CLK,
    output                      SSRAM_GW_N,
    output                      SSRAM_OE_N,
    output                      SSRAM_WE_N,
    output                      SSRAM0_CE_N,
    output                      SSRAM1_CE_N,

    ///////// SW /////////
    input  [17:0]               SW,

    ///////// TD /////////
    input                       TD_CLK27,
    input  [7:0]                TD_DATA,
    input                       TD_HS,
    output                      TD_RESET_N,
    input                       TD_VS,

    ///////// UART /////////
    input                       UART_CTS,
    output                      UART_RTS,
    input                       UART_RXD,
    output                      UART_TXD,

    ///////// VGA /////////
    output [7:0]                VGA_B,
    output                      VGA_BLANK_N,
    output                      VGA_CLK,
    output [7:0]                VGA_G,
    output                      VGA_HS,
    output [7:0]                VGA_R,
    output                      VGA_SYNC_N,
    output                      VGA_VS

);

parameter CORE = 0;
parameter DATA_WIDTH = 32;
parameter INDEX_BITS = 6;
parameter OFFSET_BITS = 3;
parameter ADDRESS_BITS = 32;

wire clock;
wire pixel_clock;
wire reset;
wire pll_reset;

// PLL clocks
wire clock_25;
wire clock_50;

wire [DATA_WIDTH-1:0] red;
wire [DATA_WIDTH-1:0] green;
wire [DATA_WIDTH-1:0] blue;
wire [DATA_WIDTH-1:0] status;
wire [DATA_WIDTH-1:0] current_pc;

wire locked;
wire request; // VGA request signal

wire [21:0] fb_read_addr;


assign pixel_clock = clock_25; // Fast clock
assign pll_reset = ~KEY[0];
assign reset = KEY[3] & locked;
assign LEDR[0] = locked;
assign LEDR[17] = status[0];
assign LEDG[3:0] = KEY;

/* No need for debouncer when using fast clock
debounce (
  .clock_25(clock_25),
  .reset(reset),
  .button(KEY[1]),
  .debounce(pixel_clock)
);
*/


RISC_V_Core #(
    .CORE(CORE),
    .DATA_WIDTH(DATA_WIDTH),
    .INDEX_BITS(INDEX_BITS),
    .OFFSET_BITS(OFFSET_BITS),
    .ADDRESS_BITS(ADDRESS_BITS)
) core0 (

    // INPUT PORTS
    .clock(pixel_clock),
    .clock_baud_gen(clock_25),
    .reset(~reset), // Active High reset
    .stall_in(1'b0),

    //.start(0),
    .start(~KEY[2]),
    .prog_address({14'd0, SW}),

    /*
    .from_peripheral(),
    .from_peripheral_data(),
    .from_peripheral_valid(),
    .to_peripheral(),
    .to_peripheral_data(),
    .to_peripheral_valid(),
    */

    .report(0),
    .current_pc(current_pc),

    // I/O Ports
    .mm_reg(status),

    .pixel_clock(pixel_clock),
    .fb_read_addr(fb_read_addr[18:0]),
    .red(red[0]),
    .green(green[0]),
    .blue(blue[0]),

    .serial_rx(UART_RXD),
    .serial_tx(UART_TXD)

);

vga_ctrl    vga_ctrl_inst(  //  Host Side

    .iRed( {8{red[0]}} ),
    .iGreen( {8{green[0]}} ),
    .iBlue( {8{blue[0]}} ),

    //.iRed( {8{red[0]}} ),
    //.iRed( 8'h00 ),
    //.iGreen( cy[8:1]),
    //.iBlue( cx[8:1] ),

    .oCurrent_X(),
    .oCurrent_Y(),
    .oAddress(fb_read_addr),
    .oRequest(),
    //  VGA Side
    .oVGA_R(VGA_R),
    .oVGA_G(VGA_G),
    .oVGA_B(VGA_B),
    .oVGA_HS(VGA_HS),
    .oVGA_VS(VGA_VS),
    .oVGA_SYNC(VGA_SYNC_N),
    .oVGA_BLANK(VGA_BLANK_N),
    .oVGA_CLOCK(VGA_CLK),
    //  Control Signal
    .iCLK(pixel_clock),
    //.iRST_N(reset)
    .iRST_N(locked)
);

pll_25_125 pll_inst(
	.areset(pll_reset),
	.inclk0(CLOCK_50),
	.c0(clock_25),
	.locked(locked)
);

hex_decoder h0(
    .hex(current_pc[3:0]),
    .display(HEX0)
);

hex_decoder h1(
    .hex(current_pc[7:4]),
    .display(HEX1)
);

hex_decoder h2(
    .hex(current_pc[11:8]),
    .display(HEX2)
);

hex_decoder h3(
    .hex(current_pc[15:12]),
    .display(HEX3)
);

hex_decoder h4(
    .hex(current_pc[19:16]),
    .display(HEX4)
);

hex_decoder h5(
    .hex(current_pc[23:20]),
    .display(HEX5)
);

hex_decoder h6(
    .hex(current_pc[27:24]),
    .display(HEX6)
);

hex_decoder h7(
    .hex(current_pc[31:28]),
    .display(HEX7)
);




endmodule
