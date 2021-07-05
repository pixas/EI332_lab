module sevenseg(
	input [3:0] data,
	output reg [6: 0] data_out);
	// 七段译码器
	always @ *
	begin
		case (data)
			0:          data_out = 7'b100_0000;
         1:          data_out = 7'b111_1001;
         2:          data_out = 7'b010_0100;
         3:          data_out = 7'b011_0000;
         4:          data_out = 7'b001_1001;
         5:          data_out = 7'b001_0010;
         6:          data_out = 7'b000_0010;
         7:          data_out = 7'b111_1000;
         8:          data_out = 7'b000_0000;
         9:          data_out = 7'b001_0000;
			
         default:    data_out = 7'b111_1111; 
		endcase
	end
endmodule