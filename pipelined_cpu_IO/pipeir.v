module pipeir(
	input [31: 0] pc4,
	input [31: 0] ins,
	input wpcir,
	input clock,
	input resetn,
	output reg [31: 0] dpc4,
	output reg [31: 0] inst,
	input dbubble
);


always @ (posedge clock or negedge resetn)
begin
	if (resetn == 0)
		begin
			dpc4 <= 0;
			inst <= 0; // 流水线阻塞
		end
	else
		begin
			if (wpcir != 0)
				begin
					dpc4 <= pc4;
					inst <= ins; // 寄存器存储从IF阶段到ID阶段的指令内容和pc内容（pc由pipepc得到）
				end
			if (dbubble)
				begin
					dpc4 <= 0;
					inst <= 0;
				end
		end
			

end



endmodule