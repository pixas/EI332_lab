module pipemwreg(mwreg, mm2reg, mmo, malu, mrn, clock, resetn,
	wwreg, wm2reg, wmo, walu, wrn);
	input mwreg, mm2reg, clock, resetn;
	input [31: 0] malu, mmo;
	input [4: 0] mrn;
	output reg wwreg, wm2reg;
	output reg [4: 0] wrn;
	output reg [31: 0] wmo, walu;
	
	always @ (posedge clock or negedge resetn)
	begin
	if (resetn == 0)
		begin
			wwreg <= 0;
			wm2reg <= 0;
			wrn <= 0;
			wmo <= 0;
			walu <= 0;
		
		end
	else
		begin
			wwreg <= mwreg;
			wm2reg <= mm2reg;
			wrn <= mrn;
			wmo <= mmo;
			walu <= malu;
		end
	end
endmodule