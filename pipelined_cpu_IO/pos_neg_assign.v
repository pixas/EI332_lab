module pos_neg_assign(out_port3, HEX7, HEX6);
	input [31: 0] out_port3;
	output wire [6: 0] HEX7, HEX6;
	assign HEX7 = 7'b1111111;
	assign HEX6 = out_port3 ? 7'b0111111 : 7'b1111111;

	
endmodule