`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/29 13:05:18
// Design Name: 
// Module Name: CTRL
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
module CTRL(
    input rst,
    input id_stall,
    input ex_stall,

    //MEMÄ£¿éµÄÊäÈë
    input [31:0] excepttype,
    input [`__regfile__data__bus__] cp0_epc,

    output reg [`__regfile__data__bus__] new_pc,
    output reg flush,

    output reg [5:0] stall
    );

    always @(*) begin
        if(rst == `RstEnable)begin
            stall <= 6'b000000;
            flush <= 1'b0;
            new_pc <= `zero;
        end
        else if(excepttype != `zero)begin
            flush <= 1'b1;
            stall <= 6'b000000;
            case(excepttype)
            32'h00000001:
                //new_pc <= 32'h00000004;
                new_pc <= 32'h00000020;
            32'h00000008:
                //new_pc <= 32'h00000004;
                new_pc <= 32'h00000040;
            32'h0000000a:
                //new_pc <= 32'h00000004;
                new_pc <= 32'h00000040;
            32'h0000000d:
                //new_pc <= 32'h00000004;
                new_pc <= 32'h00000040;
            32'h0000000c:
                //new_pc <= 32'h00000004;
                new_pc <= 32'h00000040;
            32'h0000000e:
                new_pc <= cp0_epc;
            32'h0000000f:
                //new_pc <= 32'h00000004;
                new_pc <= 32'h00000040;
            default:begin
            end
            endcase
        end
        else if(ex_stall == `STOP) begin
            stall <= 6'b001111;
            flush <= 1'b0;
        end
        else if(id_stall == `STOP)begin
            stall <= 6'b000111;
            flush <= 1'b0;
        end
        else begin
            stall <= 6'b000000;
            flush <= 1'b0;
            new_pc <= `zero;
        end
    end
    
endmodule
