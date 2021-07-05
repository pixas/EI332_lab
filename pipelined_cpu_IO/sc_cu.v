module sc_cu (op, func, register_eq, wmem, wreg, regrt, m2reg, aluc, shift,
              aluimm, pcsource, jal, sext, wpcir, rs, rt, mrn, mm2reg, mwreg, 
				  ern, em2reg, ewreg, fw_data_a, fw_data_b, ebubble);
   input  [5:0] op,func;
   input        register_eq, mwreg, ewreg, mm2reg, em2reg, ebubble; 
	// register_eq 两个寄存器是否相等的零输出信号
	// mwreg ewreg 判断EX 和 MEM 极端的WB控制信号来确定regwrite信号是否有效
	// mm2reg em2reg EX和MEM阶段的lw指令信号（memory to register）
	input [4: 0] rs, rt, mrn, ern; // 本次decode的rs rt寄存器 以及MEM阶段的return和execute阶段的alu return 的寄存器（rt或者是rd）
	
   output       wreg, regrt, jal, m2reg, shift, aluimm, sext, wmem, wpcir;// wmem 写内存信号
   output [3:0] aluc;
   output [1:0] pcsource;
	output reg [1: 0] fw_data_a, fw_data_b; // 4选1选择器的s输入
   wire r_type = ~|op;
   wire i_add = r_type & func[5] & ~func[4] & ~func[3] &
                ~func[2] & ~func[1] & ~func[0];          //100000
   wire i_sub = r_type & func[5] & ~func[4] & ~func[3] &
                ~func[2] &  func[1] & ~func[0];          //100010
      
   //  please complete the deleted code.
   
   wire i_and =r_type & func[5] & ~func[4] & ~func[3] &
                func[2] & ~func[1] & ~func[0];           //100100
   wire i_or  =r_type & func[5] & ~func[4] & ~func[3] &
                func[2] & ~func[1] & func[0];          //100101

   wire i_xor = r_type & func[5] & ~func[4] & ~func[3] &
                func[2] & func[1] & ~func[0];         //100110 
   wire i_sll = r_type & ~func[5] & ~func[4] & ~func[3] &
                ~func[2] & ~func[1] & ~func[0];        //000000
   wire i_srl = r_type & ~func[5] & ~func[4] & ~func[3] &
                ~func[2] & func[1] & ~func[0];       //000010
   wire i_sra = r_type & ~func[5] & ~func[4] & ~func[3] &
                ~func[2] & func[1] & func[0];      //000011
   wire i_jr  = r_type & ~func[5] & ~func[4] & func[3] &
                ~func[2] & ~func[1] & ~func[0];     //001000
	/*wire i_hamming = r_type & func[5] & func[4] & ~func[3] & 
					 ~func[2] & ~func[1] & ~func[0]; // 110000*/
                
   wire i_addi = ~op[5] & ~op[4] &  op[3] & ~op[2] & ~op[1] & ~op[0]; //001000
   wire i_andi = ~op[5] & ~op[4] &  op[3] &  op[2] & ~op[1] & ~op[0]; //001100
   
   wire i_ori  = ~op[5] & ~op[4] &  op[3] &  op[2] & ~op[1] &  op[0]; //001101     
   wire i_xori = ~op[5] & ~op[4] &  op[3] &  op[2] &  op[1] & ~op[0]; //001110
   wire i_lw   =  op[5] & ~op[4] & ~op[3] & ~op[2] &  op[1] &  op[0]; //100011    
   wire i_sw   =  op[5] & ~op[4] &  op[3] & ~op[2] &  op[1] &  op[0]; //101011  
   wire i_beq  = ~op[5] & ~op[4] & ~op[3] &  op[2] & ~op[1] & ~op[0]; //000100
   wire i_bne  = ~op[5] & ~op[4] & ~op[3] &  op[2] & ~op[1] &  op[0]; //000101  
   wire i_lui  = ~op[5] & ~op[4] &  op[3] &  op[2] &  op[1] &  op[0]; //001111  
   wire i_j    = ~op[5] & ~op[4] & ~op[3] & ~op[2] &  op[1] & ~op[0]; //000010  
   wire i_jal  = ~op[5] & ~op[4] & ~op[3] & ~op[2] &  op[1] &  op[0]; //000011  
   assign wpcir = ~(em2reg & (ern == rs | ern == rt)); 
	// ex阶段有没有memory to register的信号（lw） 以及存入的寄存器是否是rs或者rt中的一个
	// 判断lw数据冒险 如果是mm2reg并不受影响
	wire signal_valid = wpcir & (~ebubble); // 信号没有数据冒险 并且 没有bubble（beq bne）
  
   assign pcsource[1] = i_jr | i_j | i_jal;
   assign pcsource[0] = ( i_beq & register_eq ) | (i_bne & ~register_eq) | i_j | i_jal ;
   
   assign wreg = i_add | i_sub | i_and | i_or   | i_xor  |
                 i_sll | i_srl | i_sra | i_addi | i_andi |
                 i_ori | i_xori | i_lw | i_lui  | i_jal;
					 
   assign aluc[3] = wpcir & i_sra ;    // 如果发生了数据冒险 就清空alu 控制信号 设置成0
   assign aluc[2] = wpcir & (i_sub | i_beq | i_bne |
						  i_or  | i_ori |
						  i_lui | i_srl | i_sra);
   assign aluc[1] = wpcir & (i_xor | i_xori |
						  i_lui | i_sll | i_srl | i_sra);
   assign aluc[0] = wpcir & (i_and | i_andi |
						  i_or  | i_ori |
						  i_sll | i_srl | i_sra) ;
   assign shift   = wpcir & (i_sll | i_srl | i_sra );

   assign aluimm  = wpcir & (i_addi | i_andi | i_ori | i_xori | i_lw | i_sw | i_lui);
   assign sext    = wpcir & (i_addi | i_lw | i_sw | i_beq | i_bne);
   assign wmem    = wpcir & i_sw;
   assign m2reg   = wpcir & i_lw;
   assign regrt   = wpcir & (i_addi | i_andi | i_ori | i_xori | i_lw | i_lui);
   assign jal     = wpcir & i_jal;					 
	
	// 设置forwarding
	always @ (*)
	begin
	if ((ern == rs) &(ern != 0) & ewreg & (~em2reg)) // 并不是从memory写到register里的指令，也就是不是lw指令
			fw_data_a = 2'b01;
		else
		// 这个数据冒险的格式是 add $1, $2, $3
		//                   add $4, $5, $6
		//                   add $7, $1, $2 还在write back阶段 没有写回寄存器的时候 用mrn的输出
			if (mwreg & (~mm2reg) & (mrn != 0) & (mrn == rs))
				fw_data_a = 2'b10;  
			else
				if (mwreg & (mrn != 0) & mm2reg & (mrn == rs)) // 中间那个可以换成mm2reg
					fw_data_a = 2'b11; // 这些条件参照书P210
				else
					fw_data_a = 2'b00; // 就是id/ex.rs本身
					
	end
	
	always @ (*)
	begin
	if ((ern == rt) & (ern != 0) & ewreg & (~em2reg))
		fw_data_b = 2'b01;
	else
		if (mwreg & (~mm2reg) & (mrn != 0) & (mrn == rt))
			fw_data_b = 2'b10;
		else
			if (mwreg & (mrn != 0) & mm2reg & (mrn == rt))
				fw_data_b = 2'b11;
			else
				fw_data_b = 2'b00;
	end

endmodule