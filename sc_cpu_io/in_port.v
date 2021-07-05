module in_port(sw1, sw2, sw3, sw4,sw5, sw6, sw7, sw8, res);
	input sw1, sw2, sw3, sw4, sw5, sw6, sw7, sw8;
	output [31: 0] res;
	assign res = {24'b0, sw8, sw7, sw6, sw5, sw4, sw3, sw2, sw1};
endmodule