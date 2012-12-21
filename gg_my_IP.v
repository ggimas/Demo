`timescale 1ns / 1ps

module gg_my_IP(
    input [7:0] a,
    input [7:0] b,
    input clk,
    input reset,
    output reg [15:0] sum,
    output reg [15:0] prod
    );

//

always @ (posedge clk)
	begin
		if (!reset)
			begin
				sum <= 0;
				prod <= 0;
			end
		else
			begin
				sum <= a+b;
				prod <= a*b;
			end
	end

endmodule
