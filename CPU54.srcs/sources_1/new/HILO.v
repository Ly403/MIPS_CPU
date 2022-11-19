`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/28 21:22:47
// Design Name: 
// Module Name: HILO
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
//`include "defines.v"
`include "D:/desktop/MIPS_CPU/CPU54.srcs/sources_1/new/defines.v"
//³Ë·¨×¨ÓÃ¼Ä´æÆ÷HI LO
module HILO(
    input clk,
    input rst,
    input we,
    input [`__regfile__data__bus__]i_hi,
    input [`__regfile__data__bus__]i_lo,
    output reg [`__regfile__data__bus__]o_hi,
    output reg [`__regfile__data__bus__]o_lo
    );

    always @(posedge clk) begin
        if(rst == `RstEnable)begin
            o_hi <= `zero;
            o_lo <= `zero;
        end
        else if(we == `WriteEnable)begin
            o_hi <= i_hi;
            o_lo <= i_lo;
        end
    end

endmodule
