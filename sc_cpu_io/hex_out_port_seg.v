module hex_out_port_seg(out_port, ten, one);

	input [31: 0] out_port;
	output [6: 0] ten, one;
	
	reg [3: 0] res_ten, res_one;
	sevenseg led_ten(.data(res_ten), .data_out(ten));
	sevenseg led_one(.data(res_one), .data_out(one));
	always @(out_port)
	begin
		res_one = out_port % 16;
		res_ten = out_port / 16;
	end


endmodule


