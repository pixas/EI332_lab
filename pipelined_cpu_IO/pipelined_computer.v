module pipelined_computer(resetn, clock, mem_clock, SW0, SW1, SW2, SW3, SW4, SW5, SW6, SW7, SW8, SW9, SW10,
HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7, opc, oinst, oins, oealu, omalu, owalu,
onpc);
	input resetn, clock, SW0, SW1, SW2, SW3, SW4, SW5, SW6, SW7, SW8, SW9, SW10;
	output mem_clock;
	output [31: 0] opc, oinst, oins, oealu, omalu, owalu, onpc;
	output wire [6: 0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7;
	wire [31: 0] in_port0, in_port1, in_port2;
	wire [31: 0] out_port0, out_port1, out_port2, out_port3;
	
	in_port inst1(SW5, SW6, SW7, SW8, SW9, in_port1);
	in_port inst2(SW0, SW1, SW2, SW3, SW4, in_port0);
	assign in_port2 = {31'b0, SW10};
	pipelined_computer_main inst4(resetn, clock, mem_clock, opc, oinst, oins, oealu, omalu, owalu,
onpc, in_port0, in_port1, in_port2, out_port0, out_port1, out_port2, out_port3);
	
	out_port_seg inst5(out_port0, HEX1, HEX0);
	out_port_seg inst6(out_port1, HEX3, HEX2);
	out_port_seg inst7(out_port2, HEX5, HEX4);
	
	pos_neg_assign inst8(out_port3, HEX7, HEX6);
	
	

endmodule
