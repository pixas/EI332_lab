/////////////////////////////////////////////////////////////
//                                                         //
// School of Software of SJTU                              //
//                                                         //
/////////////////////////////////////////////////////////////

module sc_computer (resetn,clock,mem_clk,pc,inst,aluout,memout,imem_clk,dmem_clk);
   // sc_computer serves as the entry of project
   input resetn,clock,mem_clk;
	// resetn: 复位信号
	// clock: 时钟信号
	// mem_clk: 频率是clock两倍的信号
   output [31:0] pc,inst,aluout,memout; // wire型输出
   output        imem_clk,dmem_clk;  // 用于观察指令存储器和数据存储器的读写时序
   wire   [31:0] data;
   wire          wmem; // all these "wire"s are used to connect or interface the cpu,dmem,imem and so on.
   
   sc_cpu cpu (clock,resetn,inst,memout,pc,wmem,aluout,data);          // CPU module.
   sc_instmem  imem (pc,inst,clock,mem_clk,imem_clk);                  // instruction memory.
   sc_datamem  dmem (aluout,data,memout,wmem,clock,mem_clk,dmem_clk ); // data memory.

endmodule



