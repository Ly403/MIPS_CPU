`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/09 16:01:39
// Design Name: 
// Module Name: LLbit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "D:/desktop/MIPS_CPU/CPU54.srcs/sources_1/new/defines.v"

module LLbit(
    input clk,
    input rst,
    input flush,
    input LLbit_i,
    input we,
    output reg LLbit_o
    );
    
    always @(posedge clk)begin
        if(rst == `RstEnable)begin
            LLbit_o <= 1'b0;
        end
        else if(flush == 1'b1)begin
            LLbit_o <= 1'b0;
        end
        else if(we == `WriteEnable)begin
            LLbit_o <= LLbit_i;
        end
    end
endmodule
