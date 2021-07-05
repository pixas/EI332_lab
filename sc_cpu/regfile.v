module regfile (rna, rnb, d, wn, we, clk, clrn, qa, qb);
// 寄存器文件 上面那些都是译码信号

   input [4:0] rna, rnb, wn; // wn 写寄存器的地址
   input [31:0] d; // 要写道寄存器的数据
   input we,clk,clrn; // we: 写使能信号
   
   output [31:0] qa,qb; // 读到的寄存器值rs rt（如果存在）
   
   reg [31:0] register [1:31]; // r1 - r31 32个32位寄存器
   
   assign qa = (rna == 0)? 0 : register[rna]; // read
   assign qb = (rnb == 0)? 0 : register[rnb]; // read

   always @(posedge clk or negedge clrn) begin
      if (clrn == 0) begin // reset
         integer i;
         for (i=1; i<32; i=i+1)
				register[i] <= 0; // 寄存器复位
      end else begin
         if ((wn != 0) && (we == 1))          // write
            register[wn] <= d;
      end
   end
endmodule