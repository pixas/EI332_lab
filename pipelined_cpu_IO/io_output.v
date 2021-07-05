module io_output(addr, datain, write_io_enable, clock, 
						out_port0, out_port1,out_port2, out_port3);
	input [31: 0] addr, datain;
	input write_io_enable, clock;
	output reg [31: 0] out_port0, out_port1, out_port2, out_port3;
	
	
	always @ (posedge clock)
	begin
		if (write_io_enable == 1)
		case (addr[7:2])
			6'b100000: out_port0 = datain; // 80h
			6'b100001: out_port1 = datain; // 84h
			6'b100010: // 88H
				begin
					if (datain[31] == 1)
						begin
							out_port3 <= 1;
							out_port2 <= ~datain + 1;
						end
					else
						begin
							out_port3 <= 0;
							out_port2 <= datain;
						end
				
				end
			// more ports，可根据需要设计更多的输出端口
		endcase
	end
	

endmodule