//module name : 	config_register_tb.v
//version 		: v1.0
//logan.chen


`timescale 1ns / 10ps


module config_register_tb;

	reg 			pclk;
	reg 			rst_b;
	reg 			psel;
	reg 			penable;
	reg 			pwrite;
	reg [31:0] 		pwdata;
	reg [9:0] 		paddr;


	wire 			pready;
	wire [31:0] 	prdata;
	wire [2:0] 		way_en;
	wire 			qos_en;


	config_register uut (
		.pclk(pclk), 
		.rst_b(rst_b), 
		.psel(psel), 
		.penable(penable), 
		.pwrite(pwrite), 
		.pwdata(pwdata), 
		.paddr(paddr), 
		.pready(pready), 
		.prdata(prdata), 
		.way_en(way_en), 
		.qos_en(qos_en)
	);

	initial begin
		rst_b = 0;
		#20;
		rst_b = 1;
       
	end

	initial begin
		apb_ist(20);
		#100;
		$display("********************* apb_inst task done ********************************");
		$finish;
	end


	initial begin
		#100000
		$display("****************** time out **********************");
	end

/*
	initial begin
		$fsdbDumpfile("config_register.fsdb");
		$fsdbDumpvars(0,config_register_tb);
	end
*/
	task apb_ist(cnt);
		integer 	cnt,delay;
		begin
			delay = 0;
			psel = 0;
			penable = 0;
			pwrite = 0;
			pwdata = 0;
			paddr = 0;
			#50;
			repeat(cnt) begin
				psel = 1;
				pwrite = {$random}%2;
				pwdata = {$random};
				paddr  = {$random}%2;
				#10;
				penable = 1;
				#10;
				psel = 0;
				penable = 0;
				delay = {$random}%50 + 10;
				#delay;
			end
		end
	endtask


	initial begin
		pclk = 1;
		forever #5 pclk = ~pclk;
	end
      
endmodule

