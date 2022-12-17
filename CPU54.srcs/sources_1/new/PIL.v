`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/08/12 23:31:08
// Design Name: 
// Module Name: PIL
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
`define NUM_DIVIDE 2000000

//`define NUM_DIVIDE 1
module PIL(
    input clk_in,
    output reg clk
    );
    
    integer i = 0;
    always @(posedge clk_in)begin
        i = i + 1;
        i = i % (2 * `NUM_DIVIDE);
        if(i < `NUM_DIVIDE && i >= 0)begin
            clk <= 0;
        end 
        else if (`NUM_DIVIDE <= i && i < 2 * `NUM_DIVIDE)begin
            clk <= 1;
        end
    end
endmodule
