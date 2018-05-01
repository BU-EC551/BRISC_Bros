module DE1_SOC_top(

      ///////// ADC /////////
      output             ADC_CONVST,
      output             ADC_DIN,
      input              ADC_DOUT,
      output             ADC_SCLK,

      ///////// AUD /////////
      input              AUD_ADCDAT,
      inout              AUD_ADCLRCK,
      inout              AUD_BCLK,
      output             AUD_DACDAT,
      inout              AUD_DACLRCK,
      output             AUD_XCK,

      ///////// CLOCK2 /////////
      input              CLOCK2_50,

      ///////// CLOCK3 /////////
      input              CLOCK3_50,

      ///////// CLOCK4 /////////
      input              CLOCK4_50,

      ///////// CLOCK /////////
      input              CLOCK_50,

      ///////// DRAM /////////
      output      [12:0] DRAM_ADDR,
      output      [1:0]  DRAM_BA,
      output             DRAM_CAS_N,
      output             DRAM_CKE,
      output             DRAM_CLK,
      output             DRAM_CS_N,
      inout       [15:0] DRAM_DQ,
      output             DRAM_LDQM,
      output             DRAM_RAS_N,
      output             DRAM_UDQM,
      output             DRAM_WE_N,

      ///////// FAN /////////
      output             FAN_CTRL,

      ///////// FPGA /////////
      output             FPGA_I2C_SCLK,
      inout              FPGA_I2C_SDAT,

      ///////// GPIO /////////
      inout     [35:0]         GPIO_0,
      inout     [35:0]         GPIO_1,
 

      ///////// HEX0 /////////
      output      [6:0]  HEX0,

      ///////// HEX1 /////////
      output      [6:0]  HEX1,

      ///////// HEX2 /////////
      output      [6:0]  HEX2,

      ///////// HEX3 /////////
      output      [6:0]  HEX3,

      ///////// HEX4 /////////
      output      [6:0]  HEX4,

      ///////// HEX5 /////////
      output      [6:0]  HEX5,

      ///////// IRDA /////////
      input              IRDA_RXD,
      output             IRDA_TXD,

      ///////// KEY /////////
      input       [3:0]  KEY,

      ///////// LEDR /////////
      output      [9:0]  LEDR,

      ///////// PS2 /////////
      inout              PS2_CLK,
      inout              PS2_CLK2,
      inout              PS2_DAT,
      inout              PS2_DAT2,

      ///////// SW /////////
      input       [9:0]  SW,

      ///////// TD /////////
      input              TD_CLK27,
      input      [7:0]  TD_DATA,
      input             TD_HS,
      output             TD_RESET_N,
      input             TD_VS,

      ///////// VGA /////////
      output      [7:0]  VGA_B,
      output             VGA_BLANK_N,
      output             VGA_CLK,
      output      [7:0]  VGA_G,
      output             VGA_HS,
      output      [7:0]  VGA_R,
      output             VGA_SYNC_N,
      output             VGA_VS
);

parameter CORE = 0;
parameter DATA_WIDTH = 32;
parameter INDEX_BITS = 6;
parameter OFFSET_BITS = 3;
parameter ADDRESS_BITS = 32;

wire clock;
wire pixel_clock;
wire reset;
wire stall;

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

assign GPIO_0[0] = locked;

assign pixel_clock = clock_25;
assign reset = KEY[3] & locked;
assign LEDR[0] = locked;
assign LEDR[9] = status[0];
assign stall = KEY[1];

//assign fb_addr = { 13'd0, SW};
//assign fb_addr = (22'd640*cy) + cx;
//assign LEDR[9:7] = { red[0], green[0], blue[0] };

RISC_V_Core #(
    .CORE(CORE),
    .DATA_WIDTH(DATA_WIDTH),
    .INDEX_BITS(INDEX_BITS),
    .OFFSET_BITS(OFFSET_BITS),
    .ADDRESS_BITS(ADDRESS_BITS)
) core0 (

    // INPUT PORTS
    .clock(pixel_clock),
    .reset(~reset), // Active High reset

    //.start(0),
    .start(~KEY[2]), // only for simulation
    .prog_address(0),

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
    .blue(blue[0])

);

vga_ctrl	vga_ctrl_inst(	//	Host Side

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
    //	VGA Side
    .oVGA_R(VGA_R),
    .oVGA_G(VGA_G),
    .oVGA_B(VGA_B),
    .oVGA_HS(VGA_HS),
    .oVGA_VS(VGA_VS),
    .oVGA_SYNC(VGA_SYNC_N),
    .oVGA_BLANK(VGA_BLANK_N),
    .oVGA_CLOCK(VGA_CLK),
    //	Control Signal
    .iCLK(pixel_clock),
    //.iRST_N(reset)
    .iRST_N(locked)
);

//assign clock_25 = CLOCK_50;
pll_25_125  pll_25_inst (
		.refclk(CLOCK_50),   //  refclk.clk
		.rst(~KEY[0]), // reset.reset // Active High
		.outclk_0(clock_25), // outclk0.clk
		.outclk_1(clock_50), // outclk1.clk
		.locked(locked)    //  locked.export
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

endmodule
