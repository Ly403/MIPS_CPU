`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/27 21:28:46
// Design Name: 
// Module Name: MEM_WB
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
//将信号从MEM模块传递到WB模块
module MEM_WB(
    input rst,
    input clk,
    //MEM模块的信息
    input [`__regfile__address__bus__] mem_wd,
    input mem_wreg,
    input [`__regfile__data__bus__]mem_wdata,

    input [`__regfile__data__bus__]mem_hi,
    input [`__regfile__data__bus__]mem_lo,
    input mem_w_hilo,

    input mem_cp0_reg_we,
    input [4:0]mem_cp0_reg_waddr,
    input [`__regfile__data__bus__]mem_cp0_reg_data,

    input [5:0] stall,
    input flush,
    //WB模块的信息
    output reg[`__regfile__address__bus__] wb_wd,
    output reg wb_wreg,
    output reg[`__regfile__data__bus__] wb_wdata,

    output reg [`__regfile__data__bus__]wb_hi,
    output reg [`__regfile__data__bus__]wb_lo,
    output reg wb_w_hilo,

    output reg wb_cp0_reg_we,
    output reg [4:0]wb_cp0_reg_waddr,
    output reg [`__regfile__data__bus__]wb_cp0_reg_data
    );

    always @(posedge clk) begin
        if(rst == `RstEnable)begin
          wb_wd <= `NOP;
          wb_wreg <= `WriteDisable;
          wb_wdata <= `zero;
          wb_hi <= `zero;
          wb_lo <= `zero;
          wb_w_hilo <= `WriteDisable;    
          wb_cp0_reg_we <= `WriteDisable;
          wb_cp0_reg_waddr <= 5'b00000;
          wb_cp0_reg_data <= `zero;
        end 
        else if(flush == 1'b1)begin
          wb_wd <= `NOP;
          wb_wreg <= `WriteDisable;
          wb_wdata <= `zero;
          wb_hi <= `zero;
          wb_lo <= `zero;
          wb_w_hilo <= `WriteDisable;
          wb_cp0_reg_we <= `WriteDisable;
          wb_cp0_reg_waddr <= 5'b00000;
          wb_cp0_reg_data <= `zero;                
        end
        else if(stall[4] == `STOP && stall[5] == `UNSTOP)begin
          wb_wd <= `NOP;
          wb_wreg <= `WriteDisable;
          wb_wdata <= `zero;
          wb_hi <= `zero;
          wb_lo <= `zero;
          wb_w_hilo <= `WriteDisable;
          wb_cp0_reg_we <= `WriteDisable;
          wb_cp0_reg_waddr <= 5'b00000;
          wb_cp0_reg_data <= `zero;          
        end
        else if(stall[4] == `UNSTOP)begin
          wb_wd <= mem_wd;
          wb_wreg <= mem_wreg;
          wb_wdata <= mem_wdata;
          wb_hi <= mem_hi;
          wb_lo <= mem_lo;
          wb_w_hilo <= mem_w_hilo;
          wb_cp0_reg_we <= mem_cp0_reg_we;
          wb_cp0_reg_waddr <= mem_cp0_reg_waddr;
          wb_cp0_reg_data <= mem_cp0_reg_data;
        end
    end
    
    
endmodule
