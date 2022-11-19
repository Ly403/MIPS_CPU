`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/29 23:38:08
// Design Name: 
// Module Name: data_ram
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
//Êý¾Ý´æ´¢Æ÷
module data_ram(
    input clk,
    input ce,
    input we,
    input [`__data__address__]addr,
    input [3:0] sel,
    input [`__data__bus__]i_data,
    output reg [`__data__bus__] o_data
    );

    reg [`byte_width] data_mem0 [0:`__data__memnum__ - 1];
    reg [`byte_width] data_mem1 [0:`__data__memnum__ - 1];
    reg [`byte_width] data_mem2 [0:`__data__memnum__ - 1];
    reg [`byte_width] data_mem3 [0:`__data__memnum__ - 1];
    
    always @(posedge clk) begin
        if(ce == `__chip__disable__)begin
        end    
        else if(we == `WriteEnable)begin
            if(sel[3] == 1'b1)
                data_mem3[addr[`__data__memnum__width__ + 1 : 2]] <= i_data[31:24];            
            if(sel[2] == 1'b1)
                data_mem2[addr[`__data__memnum__width__ + 1 : 2]] <= i_data[23:16];    
            if(sel[1] == 1'b1)
                data_mem1[addr[`__data__memnum__width__ + 1 : 2]] <= i_data[15:8];
            if(sel[0] == 1'b1)
                data_mem0[addr[`__data__memnum__width__ + 1 : 2]] <= i_data[7:0];          
        end 
    end

    always @(*) begin
        if(ce == `__chip__disable__)begin
            o_data <= `zero;
        end
        else if(we == `WriteDisable)begin
            o_data <= {
                data_mem3[addr[`__data__memnum__width__ + 1 : 2]],
                data_mem2[addr[`__data__memnum__width__ + 1 : 2]],
                data_mem1[addr[`__data__memnum__width__ + 1 : 2]],
                data_mem0[addr[`__data__memnum__width__ + 1 : 2]]
            };
        end
        else 
            o_data <= `zero;
    end
    
endmodule
