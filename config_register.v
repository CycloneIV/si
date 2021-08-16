//module name : config_register
//version: v1.0
//logan.chen
//2021.08.15

`timescale 1ns / 1ps

module config_register #(
	parameter 			DATA_WIDTH = 32,
	parameter			ADDR_WIDTH = 10,
	parameter			SLV_NUM    = 3
	)(
	input 							pclk,
	input 							rst_b,
	input 							psel,
	input 							penable,
	input 							pwrite,
	input 		[DATA_WIDTH-1:0] 	pwdata,
	input 		[ADDR_WIDTH-1:0] 	paddr,

	output reg						pready,
	output reg	[DATA_WIDTH-1:0] 	prdata,

	output reg 	[SLV_NUM-1:0] 		way_en,
	output reg 						qos_en

	);

	wire 		apb_read;
	wire 		apb_write;

	assign apb_write = psel & penable & pwrite;
	assign apb_read  = psel & (~pwrite);

	always @(posedge pclk or negedge rst_b) begin
		if (!rst_b) begin
			prdata 	<= 32'd0;
			way_en 	<= 3'd0;
			qos_en 	<= 1'd0;
			pready 	<= 1'd0;
		end
		else if (apb_write) begin
			pready 	<= 1'd1;
			case(paddr)
				10'd0: 		qos_en 	<= pwdata[0];
				10'd1: 		way_en 	<= pwdata[2:0];
				default: 	begin
							qos_en 	<= qos_en;
							way_en 	<= way_en;
				end
			endcase
		end
		else if (apb_read) begin
			pready 	<= 1'd1;
			case(paddr)
				10'd0: 		prdata	<= {31'b0,qos_en};
				10'd1: 		prdata	<= {29'b0,way_en};
				default: 	prdata 	<= prdata;
			endcase
		end
		else begin
			pready 	<= 1'd0;
		end
	end





endmodule