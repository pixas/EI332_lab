module pipepc(
	input [31: 0]npc,
	input wpcir, 
	input clock,
	input resetn,
	output reg [31: 0] pc
);

	always @ (posedge clock or negedge resetn)
	if (resetn == 0)
		pc <= -4; // 接下来pc会加4
	else
		if (wpcir != 0) // 如果流水线阻塞，那么pc维持原值
			pc <= npc;
			
endmodule