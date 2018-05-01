/* Generate a pulse that lasts a single clock cycle */
module pulse #(
  parameter COUNT_MAX = 9600
) (
  input clock,
  input reset,

  input button, // pressed = 1, not pressed = 0

  output reg pulse
);

reg [31:0] count;


always@(posedge clock) begin
    if(reset)
        count <= 0;
    else if (button)
        count <= count + 1;
    else
        count <= 0;
end

always@(posedge clock) begin
    if(reset)
        pulse <= 1'b0;
    else if(count == COUNT_MAX)
        pulse <= 1'b1;
    else
        pulse <= 1'b0;
end

endmodule
