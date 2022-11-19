
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/27 20:26:38
// Design Name: 
// Module Name: EX_MEM
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
//一个时钟周期后，将EX模块的信息传递到MEM模块
module EX_MEM(
    input rst,
    input clk,
    //EX模块传入的信息
    input [`__regfile__address__bus__]ex_wd,
    input ex_wreg,
    input [`__regfile__data__bus__]ex_wdata,
    
    input [`__regfile__data__bus__]ex_hi,
    input [`__regfile__data__bus__]ex_lo,
    input ex_w_hilo,

    input [5:0] stall,
    input flush,
    input [`__regfile__twice__data__bus__]i_hilo,
    input [1:0] i_cnt,

    input [`ALUOP] ex_aluop,
    input [`__regfile__data__bus__] ex_mem_addr,
    input [`__regfile__data__bus__] ex_regb,

    input ex_cp0_reg_we,
    input [4:0] ex_cp0_reg_waddr,
    input [`__regfile__data__bus__] ex_cp0_reg_data,

    input [31:0]ex_excepttype,
    input ex_in_delay_slot,
    input [`__regfile__data__bus__] ex_current_inst_addr,


    //传进MEM模块的信息
    output reg [`__regfile__address__bus__] mem_wd,
    output reg mem_wreg,
    output reg [`__regfile__data__bus__] mem_wdata,
    
    output reg [`__regfile__data__bus__]mem_hi,
    output reg [`__regfile__data__bus__]mem_lo,
    output reg mem_w_hilo,

    output reg [`__regfile__twice__data__bus__]o_hilo,
    output reg [1:0] o_cnt,

    output reg [`ALUOP] mem_aluop,
    output reg [`__regfile__data__bus__] mem_mem_addr,
    output reg [`__regfile__data__bus__] mem_regb,

    output reg mem_cp0_reg_we,
    output reg [4:0] mem_cp0_reg_waddr,
    output reg [`__regfile__data__bus__] mem_cp0_reg_data,

    output reg [31:0]mem_excepttype,
    output reg mem_is_in_delay_slot,
    output reg [`__regfile__data__bus__] mem_current_inst_addr
    );
    
    //流水线暂停的时候，把i_hilo送出
    //其余时刻，都送0出去
    always @(posedge clk) begin
        if(rst == `RstEnable)begin
          mem_wd <= `NOP;
          mem_wreg <= `WriteDisable;
          mem_wdata <= `zero;
          mem_hi <= `zero;
          mem_lo <= `zero;
          mem_w_hilo <= `WriteDisable;
          o_hilo <= {`zero,`zero};
          o_cnt <= 2'b00;
          mem_aluop <= `__nop__op__;
          mem_mem_addr <= `zero;
          mem_regb <= `zero;
          mem_cp0_reg_we <= `WriteDisable;
          mem_cp0_reg_waddr <= 5'b00000;
          mem_cp0_reg_data <= `zero;
          mem_excepttype <= `zero;
          mem_is_in_delay_slot <= `NotInDelaySlot;
          mem_current_inst_addr <= `zero;
        end
        else if(flush == 1'b1)begin
          mem_wd <= `NOP;
          mem_wreg <= `WriteDisable;
          mem_wdata <= `zero;
          mem_hi <= `zero;
          mem_lo <= `zero;
          mem_w_hilo <= `WriteDisable;          
          o_hilo <= {`zero,`zero};
          o_cnt <= 2'b00;
          mem_aluop <= `__nop__op__;
          mem_mem_addr <= `zero;
          mem_regb <= `zero;
          mem_cp0_reg_we <= `WriteDisable;
          mem_cp0_reg_waddr <= 5'b00000;
          mem_cp0_reg_data <= `zero;
          mem_excepttype <= `zero;
          mem_is_in_delay_slot <= `NotInDelaySlot;
          mem_current_inst_addr <= `zero;          
        end
        else if(stall[3] == `STOP && stall[4] == `UNSTOP)begin
          mem_wd <= `NOP;
          mem_wreg <= `WriteDisable;
          mem_wdata <= `zero;
          mem_hi <= `zero;
          mem_lo <= `zero;
          mem_w_hilo <= `WriteDisable;          
          o_hilo <= i_hilo;
          o_cnt <= i_cnt;
          mem_aluop <= `__nop__op__;
          mem_mem_addr <= `zero;
          mem_regb <= `zero;
          mem_cp0_reg_we <= `WriteDisable;
          mem_cp0_reg_waddr <= 5'b00000;
          mem_cp0_reg_data <= `zero;
          mem_excepttype <= `zero;
          mem_is_in_delay_slot <= `NotInDelaySlot;
          mem_current_inst_addr <= `zero;
        end
        else if(stall[3] == `UNSTOP)begin
          mem_wd <= ex_wd;
          mem_wreg <= ex_wreg;
          mem_wdata <= ex_wdata;
          mem_hi <= ex_hi;
          mem_lo <= ex_lo;
          mem_w_hilo <= ex_w_hilo;
          o_hilo <= {`zero,`zero};
          o_cnt <= 2'b00;
          mem_aluop <= ex_aluop;
          mem_mem_addr <= ex_mem_addr;
          mem_regb <= ex_regb;
          mem_cp0_reg_we <= ex_cp0_reg_we;
          mem_cp0_reg_waddr <= ex_cp0_reg_waddr;
          mem_cp0_reg_data <= ex_cp0_reg_data;
          mem_excepttype <= ex_excepttype;
          mem_is_in_delay_slot <= ex_in_delay_slot;
          mem_current_inst_addr <= ex_current_inst_addr;
        end
        else begin
          o_hilo <= i_hilo;
          o_cnt <= i_cnt;         
        end
    end

endmodule
