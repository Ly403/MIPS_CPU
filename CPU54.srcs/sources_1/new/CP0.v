`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/30 10:38:53
// Design Name: 
// Module Name: CP0
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
//协处理器
module CP0(
    input clk,
    input rst,
    
    input we,
    input[4:0] waddr,
    input[4:0] raddr,
    input[`__regfile__data__bus__] data,
    
    input[5:0] int,
    input [31:0]excepttype,
    input [`__regfile__data__bus__] current_inst_addr,
    input is_in_delay_slot,
    
    output reg [`__regfile__data__bus__] o_data,
    output reg [`__regfile__data__bus__] o_count,
    output reg [`__regfile__data__bus__] o_compare,
    output reg [`__regfile__data__bus__] o_status,
    output reg [`__regfile__data__bus__] o_cause,
    output reg [`__regfile__data__bus__] o_epc,
    output reg [`__regfile__data__bus__] o_config,
    output reg [`__regfile__data__bus__] o_prid,
    output reg [`__regfile__data__bus__] o_badVAddr,
    output reg o_timer_int //是否定时中断
    );

    //对CP0写操作
    always @(posedge clk) begin
        if(rst == `RstEnable)begin
          o_count <= `zero;
          o_compare <= `zero;
          //status寄存器的CU为0001，表示协处理器CP0存在
          o_status <= 32'b00010000000000000000000000000000;
          o_cause <= `zero;
          o_epc <= `zero;
          //config寄存器的BE为1，表示Big-Endian；MT为00，表示没有MMU
          o_config <= 32'b00000000000000001000000000000000;
          o_prid <= 32'b00000000010011000000000100000010;
          
          o_badVAddr <= `zero;
          o_timer_int <= `InterruptNotAssert;
        end
        else begin
            o_count <= o_count + 1;
            o_cause[15:10] <= int;

            if(o_compare != `zero && o_count == o_compare)
                o_timer_int <= `InterruptAssert; //定时器中断
        
            if(we == `WriteEnable) begin
                case(waddr)
                    `__reg__count__:
                        o_count <= data;
                    `__reg__compare__:begin
                        o_compare <= data;
                        o_timer_int <= `InterruptNotAssert;
                    end
                    `__reg__status__:begin
                        o_status <= data;
                    end
                    `__reg__epc__:
                        o_epc <= data;
                    `__reg__cause__:begin
                        o_cause[9:8] <= data[9:8];
                        o_cause[23] <= data[23];
                        o_cause[22] <= data[22];
                    end
                    `__reg__badvaddr__ :begin
                        o_badVAddr <= data;
                    end
                    
                    default:begin
                    end
                endcase
            end

            case(excepttype)
                32'h00000001:begin
                    if(is_in_delay_slot == `InDelaySlot)begin
                        o_epc <= current_inst_addr - 4;
                        o_cause[31] <= 1'b1;// BD字段
                    end
                    else begin
                        o_epc <=current_inst_addr;
                        o_cause[31] <= 1'b0; 
                    end
                    o_status[1] <= 1'b1;
                    o_cause[6:2] <= 5'b00000; 
                end
                32'h00000008:begin
                    if(o_status[1] == 1'b0)begin
                        if(is_in_delay_slot == `InDelaySlot)begin
                            o_epc <= current_inst_addr - 4;
                            o_cause[31] <= 1'b1;// BD字段
                        end
                        else begin
                            o_epc <=current_inst_addr;
                            o_cause[31] <= 1'b0; 
                        end
                    end
                    o_status[1] <= 1'b1;
                    o_cause[6:2] <= 5'b01000; 
                end 
                32'h0000000a:begin
                    if(o_status[1] == 1'b0)begin
                        if(is_in_delay_slot == `InDelaySlot)begin
                            o_epc <= current_inst_addr - 4;
                            o_cause[31] <= 1'b1;// BD字段
                        end
                        else begin
                            o_epc <=current_inst_addr;
                            o_cause[31] <= 1'b0; 
                        end
                    end
                    o_status[1] <= 1'b1;
                    o_cause[6:2] <= 5'b01010; 
                end                
                32'h0000000d:begin
                    if(o_status[1] == 1'b0)begin
                        if(is_in_delay_slot == `InDelaySlot)begin
                            o_epc <= current_inst_addr - 4;
                            o_cause[31] <= 1'b1;// BD字段
                        end
                        else begin
                            o_epc <=current_inst_addr;
                            o_cause[31] <= 1'b0; 
                        end
                    end
                    o_status[1] <= 1'b1;
                    o_cause[6:2] <= 5'b01101; 
                end 
                32'h0000000c:begin
                    if(o_status[1] == 1'b0)begin
                        if(is_in_delay_slot == `InDelaySlot)begin
                            o_epc <= current_inst_addr - 4;
                            o_cause[31] <= 1'b1;// BD字段
                        end
                        else begin
                            o_epc <=current_inst_addr;
                            o_cause[31] <= 1'b0; 
                        end
                    end
                    o_status[1] <= 1'b1;
                    o_cause[6:2] <= 5'b01100; 
                end
                32'h0000000e:
                    o_status[1] <= 1'b0;
                32'h0000000f:begin
                    if(o_status[1] == 1'b0)begin
                        if(is_in_delay_slot == `InDelaySlot)begin
                            o_epc <= current_inst_addr - 4;
                            o_cause[31] <= 1'b1;// BD字段
                        end
                        else begin
                            o_epc <=current_inst_addr;
                            o_cause[31] <= 1'b0; 
                        end
                    end
                    o_status[1] <= 1'b1;
                    o_cause[6:2] <= 5'b01001;                     
                end
                default:begin
                  //o_status[1] <= 1'b0;
                end
            endcase
        end
    end

    //对CP0的读操作
    always @(*) begin
        if(rst == `RstEnable)begin
            o_data <= `zero;
        end
        else begin
            case(raddr)
                `__reg__count__:
                    o_data <= o_count;
                `__reg__compare__:
                    o_data <= o_compare;
                `__reg__status__:
                    o_data <= o_status;
                `__reg__cause__:
                    o_data <= o_cause;
                `__reg__epc__:
                    o_data <= o_epc;
                `__reg__prid__:
                    o_data <= o_prid;
                `__reg__config__:
                    o_data <= o_config;
                `__reg__badvaddr__:
                    o_data <= o_badVAddr;
                default:begin
                end
            endcase
        end
    end
endmodule
