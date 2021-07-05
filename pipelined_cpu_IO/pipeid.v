module pipeid(mwreg, mrn, ern, ewreg, em2reg, mm2reg, dpc4, inst, ins,
	wrn, wdi, ealu, malu, mmo, wwreg, mem_clock, resetn,
	bpc, jpc, pcsource, wpcir, dwreg, dm2reg, dwmem, daluc,
	daluimm, da, db, dimm, dsa, drn, dshift, djal,
	drs, drt/*,npc*/, ebubble, dbubble
);
	input wire [4: 0] mrn, ern, wrn;
	input wire mm2reg, em2reg, mwreg, ewreg, wwreg, mem_clock, resetn; 
	// wwreg 写寄存器使能信号
	
	input wire [31: 0]  dpc4, ins, inst, wdi, ealu, malu, mmo; // mmo MEM stage memory output 
	input wire ebubble;
	
	output wire [31: 0] bpc, dimm, jpc, da, db, dsa;// dimm是提前分支中的立即数
	output wire [1:0] pcsource; // 同样是译码信号
	output wpcir, dwreg, dm2reg, dwmem, daluimm, dshift, djal; // 译码阶段sc_cu的译码信号
	// wpcir是 是否stall的标志
	output wire [3: 0] daluc;
	output wire [4: 0] drn, drs, drt;
	output wire dbubble;
	
	wire [31: 0] reada, readb; // 读寄存器得到的值reada readb
	wire [1: 0] fw_data_a, fw_data_b; // forward指示信号
	wire register_eq = (da == db); // 判断是否相等 用来提前beq bne
	wire reg_rt, sext; // register rt 是否使用rt还是rd作为输出寄存器 这个是R和I指令的一个区别标志
	
	
	// 通过选择器得到寄存器输出的值是来自于 读到的寄存器地址，ex阶段的alu输出 mem阶段的alu输出 还是mem阶段的mmo值
	// fw_data_a fw_data_b
	// 00 -- rs=ID/EX
	// 01 -- rs=上一条指令的EX/MEM alu return
	// 10 -- rs=上两条指令的EX/MEM alu return
	// 11 -- rs=MEM/WB的结果
	mux4x32 reada_mux(reada, ealu, malu, mmo, fw_data_a, da);
	mux4x32 readb_mux(readb, ealu, malu, mmo, fw_data_b, db); 
	
	assign drs = inst[25: 21];
	assign drt = inst[20: 16];
	assign dsa = {27'b0, inst[10: 6]}; // 指令中的sa字段 进行32位的扩展
	assign dbubble = (pcsource != 2'b00); // 控制冒险的时候 我默认都产生bubble 也就是不进行分支预测
	
	
	wire splenish = sext & inst[15]; // 判断是否是正数来决定偏移量前面的数是0还是1
	assign dimm = {{16{splenish}}, inst[15: 0]}; // 用来获取立即数字段的值
	assign jpc = {dpc4[31: 28], inst[25: 0], 2'b0};
	wire [31: 0] offset = {{14{splenish}}, inst[15: 0], 2'b0};
	assign bpc = dpc4 + offset;
	mux2x5 muxrn(inst[15: 11], inst[20: 16], reg_rt, drn); // 通过regrt判断写寄存器是rt还是rd regrt 为0是rd
	
	
	// 译码器的输出	
	sc_cu cu(inst[31: 26], inst[5: 0], register_eq, dwmem, dwreg, reg_rt, dm2reg, daluc, dshift, daluimm, pcsource,
				djal, sext, wpcir, inst[25: 21], inst[20: 16], mrn, mm2reg, mwreg, ern, em2reg, ewreg, fw_data_a, fw_data_b, ebubble);
	
	regfile rf(drs, drt, wdi, wrn, wwreg, mem_clock, resetn, reada, readb);

endmodule