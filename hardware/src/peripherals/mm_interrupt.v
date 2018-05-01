module mm_interrupt #(
  parameter DATA_WIDTH = 32,
  parameter INT_PC_ADDR = 32'h90000030,
  parameter INT_TRIGGER_ADDR = 32'h90000034
) (
  input clock,
  input reset,
  input stall,

  input we,
  input [DATA_WIDTH-1:0] data,
  input [DATA_WIDTH-1:0] addr, // TODO: Use ADDR_BITS instead of DATA_WIDTH

  output reg [DATA_WIDTH-1:0] PC_reg,
  output reg [DATA_WIDTH-1:0] trigger_reg
);

always@(posedge clock) begin
  if (reset) begin
    PC_reg <= {DATA_WIDTH{1'b0}};
  end else if(we) begin
    PC_reg <= (addr == INT_PC_ADDR) ? data : PC_reg;
  end else begin
    PC_reg <= PC_reg;
  end
end // always

always@(posedge clock) begin
  if (reset) begin
    trigger_reg <= {DATA_WIDTH{1'b0}};
  end else if(we) begin
    // Do not allow triggers to be reset once set
    trigger_reg <= (addr == INT_TRIGGER_ADDR) ? (data | trigger_reg) : trigger_reg;
  end else if(stall) begin
    // hold until stall is over
    trigger_reg <= trigger_reg;
  end else begin
    // Do not leave the trigger high for more than 1 (non-stalled) cycle
    trigger_reg <= {DATA_WIDTH{1'b0}};
  end
end // always




endmodule

