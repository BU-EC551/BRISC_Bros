module mm_vga_reg #(
  parameter N = 32,
  parameter R_ADDR = 32'h80000000,
  parameter G_ADDR = 32'h80000001,
  parameter B_ADDR = 32'h80000002
) (
  input clock,
  input reset,

  input we,
  input [N-1:0] data,
  input [N-1:0] addr,

  output [N-1:0] q,
  output reg [N-1:0] red,
  output reg [N-1:0] green,
  output reg [N-1:0] blue
);

assign q = (addr == R_ADDR) ? red
         : (addr == G_ADDR) ? green
         : (addr == B_ADDR) ? blue
         : {N{1'b0}};

always@(posedge clock) begin
  if (reset) begin
    red <= {N{1'b0}};
    green <= {N{1'b0}};
    blue <= {N{1'b0}};
  end else if(we) begin
    red <= (addr == R_ADDR) ? data : red;
    green <= (addr == G_ADDR) ? data : green;
    blue <= (addr == B_ADDR) ? data : blue;
  end else begin
    red <= red;
    green <= green;
    blue <= blue;
  end
end // always

endmodule

