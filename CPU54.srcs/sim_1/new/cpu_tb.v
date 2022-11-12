`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/08/13 11:19:12
// Design Name: 
// Module Name: cpu_tb
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

`include "D:/digital_logic/project/CPU54/CPU54.srcs/sources_1/new/defines.v"
module cpu_tb();

    reg CLOCK_50; 
    reg rst;
    
    wire [7:0]o_sel;
    wire [7:0]o_seg;
    
    initial begin
        CLOCK_50 = 1'b0;
        forever #1 CLOCK_50 = ~CLOCK_50;
    end
    
    initial begin
        rst = `RstEnable;
        #49 rst = `RstDisable;
        // #1000 $stop;
    end
    
    cpu uut(
        .clk_in(CLOCK_50),
        .rst(rst),
        .o_sel(o_sel),
        .o_seg(o_seg)
    ); 
   
endmodule
