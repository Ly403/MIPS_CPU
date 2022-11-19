`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/27 17:03:33
// Design Name: 
// Module Name: ID_EX
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
//等一个时钟周期后，将源操作数、运算类型、写控制信号、写地址等信息传递到EX模块
module ID_EX(
    input rst,
    input clk,
    //译码阶段传入信息
    input [`ALUSEL]id_alusel,
    input [`ALUOP]id_aluop,
    input [`__regfile__data__bus__]id_rega,
    input [`__regfile__data__bus__]id_regb,
    input [`__regfile__address__bus__]id_wd,
    input id_wreg,
    
    input [5:0] stall,
    
    input [`__regfile__data__bus__] id_link_addr,
    input id_is_in_delay_slot,
    input next_inst_in_delay_slot,

    input [`__regfile__data__bus__] id_inst,

    input flush,//异常信号

    input [`__regfile__data__bus__ ] id_current_inst_addr,
    input [31:0] id_excepttype,
    //传递给执行阶段的信息
    output reg [`ALUSEL]ex_alusel,
    output reg [`ALUOP]ex_aluop,
    output reg [`__regfile__data__bus__]ex_rega,
    output reg [`__regfile__data__bus__]ex_regb,
    output reg [`__regfile__address__bus__]ex_wd,
    output reg ex_wreg,
    
    output reg [`__regfile__data__bus__] ex_link_addr,
    output reg ex_in_delay_slot,
    output reg o_is_in_dalay_slot,
    output reg [`__regfile__data__bus__] ex_inst,

    output reg [`__regfile__data__bus__ ] ex_current_inst_addr,
    output reg [31:0] ex_excepttype
    );
    
    always @(posedge clk)begin
        if(rst == `RstEnable)begin
            ex_aluop <= `__nop__op__;
            ex_alusel <= `__res__nop__;
            ex_rega <= `zero;
            ex_regb <= `zero;
            ex_wd <= `NOP;
            ex_wreg <= `WriteDisable;
            ex_link_addr <= `zero;
            ex_in_delay_slot <= `NotInDelaySlot;
            o_is_in_dalay_slot <= `NotInDelaySlot;
            ex_inst <= `zero;
            ex_current_inst_addr <= `zero;
            ex_excepttype <= `zero;
        end
        else if(flush == 1'b1)begin
            ex_aluop <= `__nop__op__;
            ex_alusel <= `__res__nop__;
            ex_rega <= `zero;
            ex_regb <= `zero;
            ex_wd <= `NOP;
            ex_wreg <= `WriteDisable;
            ex_link_addr <= `zero;
            ex_in_delay_slot <= `NotInDelaySlot;
            o_is_in_dalay_slot <= `NotInDelaySlot;
            ex_inst <= `zero;
            ex_current_inst_addr <= `zero;
            ex_excepttype <= `zero;            
        end
        else if(stall[2] == `STOP && stall[3] == `UNSTOP)begin
            ex_aluop <= `__nop__op__;
            ex_alusel <= `__res__nop__;
            ex_rega <= `zero;
            ex_regb <= `zero;
            ex_wd <= `NOP;
            ex_wreg <= `WriteDisable; 
            ex_link_addr <= `zero;
            ex_in_delay_slot <= `NotInDelaySlot;  
            ex_inst <= `zero;   
            ex_current_inst_addr <= `zero;
            ex_excepttype <= `zero;         
        end
        else if(stall[2] == `UNSTOP)begin
            ex_aluop <= id_aluop;
            ex_alusel <= id_alusel;
            ex_rega <= id_rega;
            ex_regb <= id_regb;
            ex_wd <= id_wd;
            ex_wreg <= id_wreg;
            ex_link_addr <= id_link_addr;
            ex_in_delay_slot <= id_is_in_delay_slot;
            o_is_in_dalay_slot <= next_inst_in_delay_slot;      
            ex_inst <= id_inst;
            ex_current_inst_addr <= id_current_inst_addr;
            ex_excepttype <= id_excepttype;    
        end
    end
    
endmodule
