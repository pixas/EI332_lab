module sc_computer(
	clk, reset, SW0,SW1,SW2,SW3,SW4,SW5,SW6,SW7,SW8,SW9, SW10, SW11, SW12, SW13, SW14, SW15, SW16, HEX0,HEX1,HEX2,HEX3,HEX4,HEX5, HEX6, HEX7,
	pc,instruction,aluout,memout,imem_clk,dmem_clk
);
	input clk, reset, SW0, SW1, SW2, SW3, SW4, SW5, SW6, SW7, SW8, SW9, SW10, SW11, SW12, SW13, SW14, SW15, SW16;
	output imem_clk, dmem_clk;
	output[31:0] aluout, memout, pc, instruction;
	output wire [6:0]  HEX0, HEX1, HEX2, HEX5, HEX6, HEX7;
	output wire [6: 0] HEX3, HEX4;
	wire         cpu_clock;
	wire  [31:0] in_port0, in_port1;
	wire  [31:0] out_port0, out_port1, out_port2;
	wire [31: 0] out_port3;
	
	
	clock_and_mem_clock inst(clk, cpu_clock);
	in_port inst1(SW9, SW10, SW11, SW12, SW13, SW14, SW15, SW16, in_port1);
	in_port inst2(SW1, SW2, SW3, SW4, SW5, SW6, SW7, SW8, in_port0);
	sc_computer_main inst4(reset,cpu_clock,clk,pc,instruction,aluout,memout,imem_clk,dmem_clk,
									in_port0,in_port1,out_port0,out_port1,out_port2);
	
	//out_port_seg inst5(out_port0, HEX1, HEX0);
	//out_port_seg inst6(out_port1, HEX3, HEX2);
	assign HEX0 = 7'b1111111;
	assign HEX1 = 7'b1111111;
	assign HEX2 = 7'b1111111;
	assign HEX3 = 7'b1111111;
	//out_port_seg inst7(out_port2, HEX7, HEX6);
	//reg [3:0] ten;
	//ten=10;
	hex_out_port_seg inst7(out_port2, HEX7, HEX6);
	
	//sevenseg hex3(ten, HEX3);
	assign HEX4 = 7'b1111111;
	assign HEX5 = 7'b1111111;
	//sevenseg hex2(.data(10), HEX2);
	//out_port_seg inst8(out_port3, HEX3, HEX2);
	
endmodule