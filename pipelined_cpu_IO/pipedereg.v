module pipedereg(dbubble, drs, drt, dwreg, dm2reg, dwmem,
	daluc, daluimm, da, db, dimm, dsa, drn, dshift, djal,
	dpc4, clock, resetn, ebubble, ers, ert, ewreg, em2reg,
	ewmem, ealuc, ealuimm, ea, eb, eimm, esa, ern0, eshift, ejal, epc4);
						
	input [31: 0] dimm, dpc4, da, db, dsa;
	input dbubble, dwreg, dm2reg, dwmem, djal, dshift, daluimm;
	input [4: 0] drn, drs, drt;
	input [3: 0] daluc;
	input clock, resetn;
	
	output reg [31: 0] esa, eimm, epc4, ea, eb;
	output reg ebubble, ewreg, em2reg, ewmem, ejal, eshift, ealuimm;
	output reg [4: 0] ern0, ers, ert;
	output reg [3: 0] ealuc;


	always @(posedge clock or negedge resetn)
	begin
		if (resetn == 0)
		begin
			ewreg <= 0;
			em2reg <= 0;
			ewmem <= 0;
			ealuimm <= 0;
			eshift <= 0;
			ejal <= 0;
			ea <= 0;
			eb <= 0;
			eimm <= 0;
			epc4 <= 0;
			ern0 <= 0;
			ealuc <= 0;
			ers <= 0;
			ert <= 0;
			esa <= 0;
			ebubble <= 0;
		end
		else
		begin
			ewreg <= dwreg;
			em2reg <= dm2reg;
			ewmem <= dwmem;
			ealuimm <= daluimm;
			eshift <= dshift;
			ejal <= djal;
			ea <= da;
			eb <= db;
			eimm <= dimm;
			epc4 <= dpc4;
			ern0 <= drn;
			ealuc <= daluc;
			ers <= drs;
			ert <= drt;
			esa <= dsa;
			ebubble <= dbubble;
		end
	end
endmodule