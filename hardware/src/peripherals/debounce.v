module debounce (
  input clock_25,
  input reset,

  input button,

  output reg debounce
);

//parameter COUNT_MAX = 32'd5000000; // 0.2 seconds with 25MHz clock
//parameter COUNT_MAX = 32'd2500000; // 0.1 seconds with 25MHz clock
parameter COUNT_MAX = 32'd1250000; // 0.05 seconds with 25MHz clock

reg current;
reg last;
reg state;
reg [31:0] counter;

wire transition;


assign transition = current != last;

always@(posedge clock_25 or negedge reset) begin
  if (reset == 1'b0 ) begin

  end else begin
    last <= current;
    current <= button;

    case(state)
      1'b0: // wait for button to change
      begin
        if(transition) state <= 1'b1;
        else state <= 1'b0;
        debounce <= debounce;
        counter <= 32'd0;
      end
      1'b1: // wait for counter
      begin
        if(counter == COUNT_MAX) begin
          state <= 1'b0;
          debounce <= button;
        end else begin
          state <= 1'b1;
          debounce <= debounce;
        end
        counter <= counter + 32'd1;
      end
    endcase
  end // reset
end // always


endmodule
