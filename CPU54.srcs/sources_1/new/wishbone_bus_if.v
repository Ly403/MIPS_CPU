`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/09 20:33:28
// Design Name: 
// Module Name: wishbone_bus_if
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

module wishbone_bus_if(
    input clk,
    input rst,
    input [5:0] stall,
    input flush,
    input cpu_ce,
    input [`__regfile__data__bus__]cpu_data,
    input [`__regfile__data__bus__]cpu_addr,
    input cpu_we,
    input [3:0]cpu_sel,
    output reg [`__regfile__data__bus__]o_cpu_data,
    
    output reg [`__regfile__data__bus__]o_wishbone_addr,
    output reg [`__regfile__data__bus__]o_wishbone_data,
    output reg o_wishbone_we,
    output reg[3:0] o_wishbone_sel,
    output reg o_wishbone_stb,
    output reg o_wishbone_cyc,
    
    input [`__regfile__data__bus__]wishbone_data,
    input wishbone_ack,
    
    output reg stallreq
    );
    
    reg [1:0] wishbone_state;
    reg [`__regfile__data__bus__] rdbuf;
    
    always@(posedge clk)begin
        if(rst == `RstEnable)begin
            wishbone_state <= `WB_IDLE;
            o_wishbone_addr <= `zero;
            o_wishbone_data <= `zero;
            o_wishbone_we <= `WriteDisable;
            o_wishbone_sel <= 4'b0000;
            o_wishbone_stb <= 1'b0;
            o_wishbone_cyc <= 1'b0;
            rdbuf <= `zero;
        end
        else begin
            case(wishbone_state)
                `WB_IDLE:begin
                    if((cpu_ce == 1'b1)&&(flush == `false))begin
                        o_wishbone_stb <= 1'b1;
                        o_wishbone_cyc <= 1'b1;
                        o_wishbone_addr <= cpu_addr;
                        o_wishbone_data <= cpu_data;
                        o_wishbone_we <= cpu_we; 
                        o_wishbone_sel <= cpu_sel;
                        wishbone_state <= `WB_BUSY;
                        rdbuf <= `zero; 
                    end
                end
                
                `WB_BUSY : begin
                    if(wishbone_ack == 1'b1)begin
                        o_wishbone_stb <= 1'b0;
                        o_wishbone_cyc <= 1'b0;
                        o_wishbone_addr <= `zero;
                        o_wishbone_data <= `zero;
                        o_wishbone_we <= `WriteDisable; 
                        o_wishbone_sel <= 4'b0000;
                        wishbone_state <= `WB_IDLE;
                        if(stall != 6'b000000)
                            wishbone_state <= `WB_WAIT_FOR_STALL;              
                    end
                    else if(flush == `true) begin
                        wishbone_state <= `WB_IDLE;
                        o_wishbone_addr <= `zero;
                        o_wishbone_data <= `zero;
                        o_wishbone_we <= `WriteDisable;
                        o_wishbone_sel <= 4'b0000;
                        o_wishbone_stb <= 1'b0;
                        o_wishbone_cyc <= 1'b0;
                        rdbuf <= `zero;                        
                    end  
                end
                
                `WB_WAIT_FOR_STALL:begin
                    if(stall != 6'b000000)
                        wishbone_state <= `WB_IDLE;                     
                end
                               
                default:begin
                end
            endcase
        end
    end
    
    always @(*)begin
        if(rst == `RstEnable)begin
            stallreq <= `UNSTOP;
            o_cpu_data <= `zero;
        end
        else begin
            stallreq <= `UNSTOP;
            case(wishbone_state)
                `WB_IDLE:   begin
                    if((cpu_ce == 1'b1)&&(flush == `false))begin
                        stallreq <= `STOP;
                        o_cpu_data <= `zero;
                    end
                end
                
                `WB_BUSY : begin
                    if(wishbone_ack == 1'b1)begin
                        stallreq <= `UNSTOP;
                        if(o_wishbone_we == `WriteDisable)begin
                            o_cpu_data <= wishbone_data; 
                        end
                        else begin
                            o_cpu_data <= `zero;
                        end
                    end
                    else begin
                        stallreq <= `STOP;
                        o_cpu_data <= `zero;
                    end
                end
                
                `WB_WAIT_FOR_STALL:begin
                    stallreq <= `UNSTOP;
                    o_cpu_data <= rdbuf;
                end
                
                default:begin
                end
            endcase
        end
    end
endmodule
