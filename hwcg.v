//module name 	:hwcg
//version :v1.0
//logan.chen
//2021.08.15

`timescale 1ns / 10ps

module hwcg(
	input 					clk,
	input 					en,
	output 				 	g_clk
	);


	reg 		q;
	always @( clk or en) begin
		if(clk)	
			q <= en;
	end

	assign g_clk = en & clk;

endmodule