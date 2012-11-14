`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:46:46 04/17/2012 
// Design Name: 
// Module Name:    my_IP 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
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
