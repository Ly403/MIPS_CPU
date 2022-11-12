`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/18 16:51:15
// Design Name: 
// Module Name: regfile
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

module regfile(
    input clk,
    input rst,
    
    /* 写数据相关信号 */
    input write,
    input [`__regfile__address__bus__]write_addr,
    input [`__regfile__data__bus__]write_data,
    
    /* 读取端口a相关信号 */
    input ra,
    input [`__regfile__address__bus__]addra,
    output reg [`__regfile__data__bus__]dataa,
    
    /* 读取端口b相关信号 */
    input rb,
    input [`__regfile__address__bus__]addrb,
    output reg [`__regfile__data__bus__]datab
    );
    
    reg [`__regfile__data__bus__] array_reg [0:`__regfile__number__ - 1] ;
    
    //写端口
    integer i;
    always@(posedge clk)begin
        if(rst == `RstEnable)begin
            for(i=0;i<`__regfile__number__;i=i+1)begin
                array_reg[i] <= `zero;
            end
        end
        else if(rst == `RstDisable)begin
            if(write == `WriteEnable && (write_addr != `__regfile__number__width__'h0))begin
                //此处，$0寄存器不能被写入，$0值一直是0
                array_reg[write_addr] <= write_data;
            end
        end
    end
    
    //第一读端口
    always@(*)begin
        if(rst == `RstEnable)begin
            dataa <= `zero;
        end
        else if (addra ==  `__regfile__number__width__'h0)begin
            //此处，读$0，直接给出值为0
            dataa <= `zero;
        end
        else if(addra == write_addr && write == `WriteEnable && ra == `ReadEnable)begin
            //此处，读写同时操作了一个寄存器，就把写入的值直接读出
            dataa <= write_data;
        end
        else if(ra == `ReadEnable)begin
            dataa <= array_reg[addra]; 
        end
        else begin
            dataa <= `zero;
        end
    end
    
    //第二读端口
    always@(*)begin
        if(rst == `RstEnable)begin
            datab <= `zero;
        end
        else if (addrb ==  `__regfile__number__width__'h0)begin
            //此处，读$0，直接给出值为0
            datab <= `zero;
        end
        else if(addrb == write_addr && write == `WriteEnable && rb == `ReadEnable)begin
            //此处，读写同时操作了一个寄存器，就把写入的值直接读出
            datab <= write_data;
        end
        else if(rb == `ReadEnable)begin
            datab <= array_reg[addrb];
        end
        else begin
            datab <= `zero;
        end
    end
    
endmodule
