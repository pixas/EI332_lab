module pipeif(
	input [1:0] pcsource,
	input [31: 0] pc,
	input [31: 0] bpc,
	input [31: 0] da, // jr指令对应的寄存器的值
	input [31: 0] jpc,
	output [31: 0] npc,
	output [31: 0] pc4,
	output [31: 0] ins,
	input mem_clock
);
	// npc pc4 ins缺省是wire
	assign pc4 = pc + 4;
	mux4x32 mux1(pc4, bpc, da, jpc, pcsource, npc); // 10->da 11-> jpc
	
	
	sc_instmem inst(pc, ins, mem_clock);


endmodule