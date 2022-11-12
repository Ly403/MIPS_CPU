
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/18 16:30:25
// Design Name: 
// Module Name: IF_ID
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
//暂存指令数据，等待译码
module IF_ID(
    input clk,
    input rst,
    //取指得到的信号，pc和指令inst
    input [`__inst__address__bus__]if_pc,
    input [`__inst__data__bus__]if_inst,
    //暂停信号
    input [5:0] stall,
    input flush, //异常信号
    //译码阶段的信号
    output reg [`__inst__address__bus__]id_pc,
    output reg [`__inst__data__bus__]id_inst
    );
    
    always@(posedge clk)begin
        if(rst == `RstEnable)begin //禁用
            id_pc <= `zero;
            id_inst <= `zero;
        end
        else if(flush == 1'b1)begin //发生异常
            id_pc <= `zero;
            id_inst <= `zero;          
        end
        else if(stall[1] == `STOP && stall[2] == `UNSTOP)begin
            id_pc <= `zero;
            id_inst <= `zero;
        end
        else if (stall[1] == `UNSTOP)begin //启用
            id_pc <= if_pc;
            id_inst <=  if_inst;
        end
    end
    
endmodule
