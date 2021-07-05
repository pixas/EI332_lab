module io_input(addr, clock, io_read_data, in_port0, in_port1, in_port2);
	input clock;
	input [31: 0] addr;
	input [31: 0] in_port0, in_port1, in_port2;
	
	output [31: 0] io_read_data;
	
	reg [31: 0] in_reg0, in_reg1, in_reg2;
	
	io_input_mux io_mux(in_reg0, in_reg1, in_reg2, addr[7: 2], io_read_data);
	
	always @(posedge clock)
	begin
		in_reg0 <= in_port0;
		in_reg1 <= in_port1;
		in_reg2 <= in_port2;
	end
	

endmodule


module io_input_mux(a0, a1, a2, sel_addr, y);
	input [31:0] a0, a1, a2;
	input [ 5:0] sel_addr;
	output [31:0] y;
	reg [31:0] y;
	always @ *
		case (sel_addr)
			6'b100000: y = a0;
			6'b100001: y = a1;
			// more ports， 可根据需要设计更多的端口
			6'b110010: y = a2;
			default: y = 32'h0;
	endcase
endmodule 