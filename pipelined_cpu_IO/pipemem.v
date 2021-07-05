module pipemem(mwmem, malu, mb, clock, mem_clock, mmo,
	real_in_port0, real_in_port1, real_in_port2, real_out_port0, real_out_port1,
	real_out_port2, real_out_port3);
	input wire mwmem, clock,mem_clock;
	input wire [31:0] malu, mb, real_in_port0, real_in_port1, real_in_port2;

	output wire [31:0] mmo, real_out_port0, real_out_port1, real_out_port2, real_out_port3;
	
	sc_datamem dmem(malu, mb, mmo, mwmem, mem_clock, real_in_port0, real_in_port1, real_in_port2, real_out_port0, real_out_port1, real_out_port2, real_out_port3);
endmodule