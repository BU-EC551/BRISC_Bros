module interrupt_controller #(
  parameter DATA_WIDTH = 32,
  parameter ADDRESS_BITS = 20,
  parameter NUM_CORES = 2
) (
  input clock,
  input reset,
  input [NUM_CORES-1:0] stall,

  input [ADDRESS_BITS-1:0] interrupt_PC_in,
  input [DATA_WIDTH-1:0] interrupt_trigger_in,
  output reg [ADDRESS_BITS-1:0] interrupt_PC_out,
  output reg [DATA_WIDTH-1:0] interrupt_trigger_out

);

always@(posedge clock) begin
    if(reset) begin
        interrupt_PC_out      <= {ADDRESS_BITS{1'b0}};
    end else begin
        interrupt_PC_out      <= interrupt_PC_in;
    end
end

genvar i;
generate
for (i=0; i<NUM_CORES; i=i+1) begin : trigger_hold
    always@(posedge clock) begin
        if(reset) begin
            interrupt_trigger_out[i] <= 1'b0;
        end else if(stall[i] & interrupt_trigger_out[i]) begin
            // Hold trigger high while Core i is stalled
            interrupt_trigger_out[i] <= 1'b1;
        end else begin
            interrupt_trigger_out[i] <= interrupt_trigger_in[i];
        end
    end // always
end
endgenerate

endmodule
