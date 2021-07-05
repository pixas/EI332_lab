module pipeexe(ealuc, ealuimm, ea, eb, eimm, esa, eshift, ern0,
	epc4, ejal, ern, ealu, ezero, ert, wrn, wdi, malu, wwreg,a,b,r);
	input ealuimm,eshift,ejal;
	input [4:0] ert, esa, ern0 ; 
	input [3:0] ealuc;
	input [31:0] ea,eb,eimm,epc4;
	input [4:0] wrn;
	input [31:0] wdi;
	input [31:0] malu;
	input wwreg;
	
	output [31:0] ealu;
	output [4:0] ern;
	output ezero;
	
	output wire [31:0] a,b,r;
	assign ern = ern0 | {5{ejal}};
	
	mux2x32 a_mux(ea, esa, eshift, a);
	mux2x32 b_mux(eb, eimm, ealuimm, b);
	
	mux2x32 ealumux(r, epc4, ejal, ealu);
	alu alu_module(a, b, ealuc, r, ezero);

endmodule