`timescale 1ns / 1ps


module si_tb;

	reg clk;
	reg rst_b;
	reg [2:0] way_en;
	reg [31:0] pwdata_mi;
	reg [15:0] paddr_mi;
	reg pwrite_mi;
	reg psel_arb;
	reg penable_arb;
	reg [31:0] prdata_s0;
	reg [31:0] prdata_s1;
	reg [31:0] prdata_s2;
	reg  pready_s0;
	reg  pready_s1;
	reg  pready_s2;

	wire pclk_s0;
	wire pclk_s1;
	wire pclk_s2;
	wire psel_s0;
	wire psel_s1;
	wire psel_s2;
	wire penable_s0;
	wire penable_s1;
	wire penable_s2;
	wire pwrite_s;
	wire [31:0] pwdata_s;
	wire [15:0] paddr_s;
	wire [31:0] prdata_s;
	wire pready_s;

	si uut (
		.clk(clk), 
		.rst_b(rst_b), 
		.way_en(way_en), 
		.pwdata_mi(pwdata_mi), 
		.paddr_mi(paddr_mi), 
		.pwrite_mi(pwrite_mi), 
		.psel_arb(psel_arb), 
		.penable_arb(penable_arb), 
		.prdata_s0(prdata_s0), 
		.prdata_s1(prdata_s1), 
		.prdata_s2(prdata_s2), 
		.pready_s0(pready_s0), 
		.pready_s1(pready_s1), 
		.pready_s2(pready_s2), 
		.pclk_s0(pclk_s0), 
		.pclk_s1(pclk_s1), 
		.pclk_s2(pclk_s2), 
		.psel_s0(psel_s0), 
		.psel_s1(psel_s1), 
		.psel_s2(psel_s2), 
		.penable_s0(penable_s0), 
		.penable_s1(penable_s1), 
		.penable_s2(penable_s2), 
		.pwrite_s(pwrite_s), 
		.pwdata_s(pwdata_s), 
		.paddr_s(paddr_s), 
		.prdata_s(prdata_s), 
		.pready_s(pready_s)
	);

	initial begin
		rst_b = 0;
		#30;
		rst_b = 1;
	end

	initial begin
		pwdata_mi = 0;
		paddr_mi = 0;
		pwrite_mi = 0;
		psel_arb = 0;
		penable_arb = 0;
		way_en = 0;
		#100;
		mi_inst(20);
		#100;
		$finish;
	end

	initial begin
		#1000000;
		$finish;
	end


	initial begin
		#10;
		slv_inst(20);
		#100;
		$finish;
	end


	task mi_inst (cnt);
		integer cnt;
		begin
			way_en = 3'b111;
			psel_arb = 1;
			pwrite_mi = 1;
			paddr_mi = 1;
			pwdata_mi = 1;
			#10;
			penable_arb = 1;
			repeat(cnt)@(posedge pready_s2 or posedge pready_s1 or pready_s0 or pready_s) begin
				#10;
				psel_arb = 0;
				penable_arb = 0;
				#50;
				psel_arb = 1;
				pwrite_mi = {$random}%2;
				paddr_mi = {$random};
				pwdata_mi = {$random};
				way_en = {$random}%8;
				#10;
				penable_arb = 1;
			end
		end
	endtask


	task slv_inst(cnt1);
		integer cnt1;
		integer i = 0;
		begin
			prdata_s0 = 0;
			prdata_s1 = 0;
			prdata_s2 = 0;
			pready_s0 = 0;
			pready_s1 = 0;
			pready_s2 = 0;
			#10;
			repeat(cnt1)@(posedge penable_arb) begin
				i = i + 1;
				prdata_s0 = 32'd1;
				prdata_s1 = 32'd2;
				prdata_s2 = 32'd3;
				case({psel_s2,psel_s1,psel_s0})
					3'b001: pready_s0 	= 1'd1;
					3'b010: pready_s1 	= 1'd1;
					3'b100: pready_s2 	= 1'd1;	
					default:begin
						pready_s0 = 0;
						pready_s1 = 0;
						pready_s2 = 0;
					end
				endcase
				#10;
				pready_s0 = 0;
				pready_s1 = 0;
				pready_s2 = 0;
			end
		end
	endtask

	initial begin
		clk  = 1;
		forever #5 clk = ~clk;

	end
      
endmodule

