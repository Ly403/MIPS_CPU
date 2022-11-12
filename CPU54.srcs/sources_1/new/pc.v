`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/18 15:18:17
// Design Name: 
// Module Name: PC
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
`include "D:/digital_logic/project/CPU54/CPU54.srcs/sources_1/new/defines.v"
//`include "./CPU54.srcs/sources_1/new/defines.v"

module PC(
    input clk,
    input rst,
    input [5:0] stall,

    input branch_flag,
    input [`__regfile__data__bus__]branch_address,

    input flush,
    input [`__regfile__data__bus__] new_pc,

    output reg [`__inst__address__bus__]pc,
    output reg cs
    );
    
    always @(posedge clk) begin
        if(rst == `RstEnable) 
            cs <= `__chip__disable__; //复位就禁用芯片
        else
            cs <= `__chip__enable__; //不复位就启用芯片
    end
    
    always @(posedge clk)begin
        if(cs == `__chip__disable__) //禁用
            pc <= 32'h00000000;     
        else if(flush == 1'b1)
            pc <= new_pc;
        else if(stall[0] == `UNSTOP)begin //启用
            if(branch_flag == `__branch__)
                pc <= branch_address;
            else
                pc <= pc + 4'd4;
        end
    end
    
endmodule
