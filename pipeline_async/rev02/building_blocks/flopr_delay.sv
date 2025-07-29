`timescale 1ns/100ps
module Flopr_1d(
	clk,
	n_rst,
	d,
	q
);
	input clk, n_rst,d;

	output reg q;	

	always@(posedge clk or negedge n_rst) begin 
		if(!n_rst) begin
			q <= 0;
		end
		else if(d) begin
			q <= 1;
		end
		else begin
			q <= 0;
		end
	end

endmodule
