//module name : si.v
//version 1.0
//logan.chen
//2021.08.15

`timescale 1ns / 10ps

module si #(
	parameter 		SLV_NUM 	= 3,
	parameter		DATA_WIDTH 	= 32,
	parameter		ADDR_WIDTH 	= 16

	)(
	input 								clk, 			//
	input 								rst_b,			//
	// frpm config register
	input 		[SLV_NUM-1:0] 			way_en,

	// from mi
	input 		[DATA_WIDTH-1:0]		pwdata_mi,
	input 		[ADDR_WIDTH-1:0]  		paddr_mi,
	input 								pwrite_mi,
	input 								psel_arb, 		// from mi arb, only 1 bit 
	input 								penable_arb,

	//from apb slave
	input 		[DATA_WIDTH-1:0] 		prdata_s0,
	input 		[DATA_WIDTH-1:0] 		prdata_s1,
	input 		[DATA_WIDTH-1:0] 		prdata_s2,
	input 		 						pready_s0,
	input 		 						pready_s1,
	input 		 						pready_s2,

	// to si
	output 	 							pclk_s0,
	output 	 							pclk_s1,
	output 	 							pclk_s2,
	output 								psel_s0,
	output 								psel_s1,
	output 								psel_s2,	
	output 								penable_s0,
	output 								penable_s1,
	output 								penable_s2,	
	output 								pwrite_s,
	output 		[DATA_WIDTH-1:0] 		pwdata_s,
	output 		[ADDR_WIDTH-1:0] 		paddr_s,

	//to mi	
	output 		[DATA_WIDTH-1:0] 		prdata_s,
	output 								pready_s


	);


	parameter 							SLV_MASK_CODE 		= 32'h10101010;
	parameter							REVERSE_ADDR_CODE 	= 32'h01010101;


	wire 								reserve_flag;
	wire 		[SLV_NUM-1:0] 			psel_dec;
	wire 								slv_mask;


	assign pwrite_s 	= pwrite_mi;
	assign pwdata_s 	= pwdata_mi;
	assign paddr_s 		= paddr_mi;

	assign psel_dec[0]	= (psel_arb && (paddr_mi >= 16'h0000 && paddr_mi < 16'h4000))? 1'b1:1'b0;
	assign psel_dec[1] 	= (psel_arb && (paddr_mi >= 16'h4000 && paddr_mi < 16'h8000))? 1'b1:1'b0;
	assign psel_dec[2]	= (psel_arb && (paddr_mi >= 16'h8000 && paddr_mi < 16'hc000))? 1'b1:1'b0;
	assign reserve_flag = (psel_arb && (paddr_mi >= 16'hc000 && paddr_mi <=16'hffff))? 1'b1:1'b0; 

	assign slv_mask = ~(|(way_en  & psel_dec));

	assign psel_s0 = psel_dec[0] & (~slv_mask);
	assign psel_s1 = psel_dec[1] & (~slv_mask);
	assign psel_s2 = psel_dec[2] & (~slv_mask);

	assign penable_s0 = psel_s0 & penable_arb;
	assign penable_s1 = psel_s1 & penable_arb;
	assign penable_s2 = psel_s2 & penable_arb;

	assign pready_s = 	(slv_mask && penable_arb)? 1'b1:
						(reserve_flag && penable_arb)? 1'b1:
						(psel_s0)? pready_s0 :
						(psel_s1)? pready_s1 :
						(psel_s2)? pready_s2 : 1'b0;

	assign prdata_s = 	(slv_mask && penable_arb)? SLV_MASK_CODE:
						(reserve_flag && penable_arb)? REVERSE_ADDR_CODE:
						(psel_s0)? prdata_s0 :
						(psel_s1)? prdata_s1 :
						(psel_s2)? prdata_s2 : 32'd0;




	hwcg hwcg_inst0(
		.clk 			(	clk			),
		.en 			(	psel_s0 	),
		.g_clk			(	pclk_s0 	)

		);

	hwcg hwcg_inst1(
		.clk 			(	clk			),
		.en 	 		(	psel_s1 	),
		.g_clk 			(	pclk_s1 	)

		);
 
	hwcg hwcg_inst2(
		.clk 			(	clk			),
		.en 	 		(	psel_s2 	),
		.g_clk 			(	pclk_s2 	)

		);



endmodule