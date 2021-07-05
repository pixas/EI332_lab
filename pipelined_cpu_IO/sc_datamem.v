module sc_datamem (
	malu, mb, mmo, mwmem, mem_clock, in_port0, in_port1, in_port2,
	out_port0, out_port1, out_port2, out_port3
); //添加了 3 个 32 位输入端口， 4 个 32 位输出端口

	input wire mwmem, mem_clock;
	input wire [31:0] malu, mb, in_port0, in_port1, in_port2;


	output [31:0] out_port0, out_port1, out_port2, out_port3, mmo;
	
	wire [31: 0] datain, mem_dataout, io_read_data;
	wire write_mem_enable, write_io_enable;
	
	assign datain = mb;
	assign write_mem_enable = mwmem & ~malu[7];
	assign write_io_enable = mwmem & malu[7]; // malu 其实是addr
	
	io_input io_input_reg(malu, mem_clock, io_read_data, in_port0, in_port1, in_port2);
	
	//添加子模块， 用于完成对 IO 地址空间的译码， 以及构成 IO 和 CPU 内部之间的数据输入通道
	//module io_input( addr,io_clk,io_read_data,in_port0,in_port1);
	
	io_output io_output_reg (malu, datain, write_io_enable, mem_clock, out_port0, out_port1,out_port2, out_port3);
	//添加子模块， 用于完成对 IO 地址空间的译码， 以及构成 IO 和 CPU 内部之间的数据输出通道
	//module io_output(addr,datain,write_io_enable,io_clk,out_port0,out_port1,out_port2 );
	
	lpm_ram_dq_dram dram (malu[6:2], mem_clock, datain, write_mem_enable, mem_dataout );
	mux2x32 io_data_mux(mem_dataout, io_read_data, malu[7], mmo); 
	//添加子模块， 用于选择输出数据来源于内部数据存储器还是 IO，
	//module mux2x32 (a0,a1,s,y);
	// when address[7]=0, means the access is to the datamem.
	// that is, the address space of datamem is from 000000 to 011111 word(4 bytes)
	// when address[7]=1, means the access is to the I/O space.
	// that is, the address space of I/O is from 100000 to 111111 word(4 bytes)
	
	
	
	
endmodule 
