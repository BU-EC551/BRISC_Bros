module hex_decoder #(
  parameter invert = 0
) (
  input [3:0] hex,
  output [6:0] display
);

reg [6:0] led;

assign display = invert ? ~led : led;

always @(*) begin
	case(hex)
		4'h1: led = 7'b1111001;	  // ---t----
		4'h2: led = 7'b0100100; 	// |	  |
		4'h3: led = 7'b0110000; 	// lt	 rt
		4'h4: led = 7'b0011001; 	// |	  |
		4'h5: led = 7'b0010010; 	// ---m----
		4'h6: led = 7'b0000010; 	// |	  |
		4'h7: led = 7'b1111000; 	// lb	 rb
		4'h8: led = 7'b0000000; 	// |	  |
		4'h9: led = 7'b0011000; 	// ---b----
		4'ha: led = 7'b0001000;
		4'hb: led = 7'b0000011;
		4'hc: led = 7'b1000110;
		4'hd: led = 7'b0100001;
		4'he: led = 7'b0000110;
		4'hf: led = 7'b0001110;
		4'h0: led = 7'b1000000;
		default: led = 7'b1000000;
  endcase
end

endmodule
