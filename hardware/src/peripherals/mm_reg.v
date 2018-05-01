module mm_reg #(
  parameter DATA_WIDTH = 32,
  parameter ADDR = 32'h90000000
) (
  input clock,
  input reset,

  input we,
  input [DATA_WIDTH-1:0] data,
  input [DATA_WIDTH-1:0] addr,

  output reg [DATA_WIDTH-1:0] r
);

always@(posedge clock) begin
  if (reset) begin
    r <= {DATA_WIDTH{1'b0}};
  end else if(we) begin
    r <= (addr == ADDR) ? data : r;
  end else begin
    r <= r;
  end
end // always

endmodule

