`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/17 21:41:13
// Design Name: 
// Module Name: _regfile
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

module _regfile(
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
    output reg [`__regfile__data__bus__]datab,
    
    output[`__regfile__data__bus__] regfile0,
    output[`__regfile__data__bus__] regfile1,
    output[`__regfile__data__bus__] regfile2,
    output[`__regfile__data__bus__] regfile3,
    output[`__regfile__data__bus__] regfile4,
    output[`__regfile__data__bus__] regfile5,
    output[`__regfile__data__bus__] regfile6,
    output[`__regfile__data__bus__] regfile7,
    output[`__regfile__data__bus__] regfile8,
    output[`__regfile__data__bus__] regfile9,
    output[`__regfile__data__bus__] regfile10,
    output[`__regfile__data__bus__] regfile11,
    output[`__regfile__data__bus__] regfile12,
    output[`__regfile__data__bus__] regfile13,
    output[`__regfile__data__bus__] regfile14,
    output[`__regfile__data__bus__] regfile15,
    output[`__regfile__data__bus__] regfile16,
    output[`__regfile__data__bus__] regfile17,
    output[`__regfile__data__bus__] regfile18,
    output[`__regfile__data__bus__] regfile19,
    output[`__regfile__data__bus__] regfile20,
    output[`__regfile__data__bus__] regfile21,
    output[`__regfile__data__bus__] regfile22,
    output[`__regfile__data__bus__] regfile23,
    output[`__regfile__data__bus__] regfile24,
    output[`__regfile__data__bus__] regfile25,
    output[`__regfile__data__bus__] regfile26,
    output[`__regfile__data__bus__] regfile27,
    output[`__regfile__data__bus__] regfile28,
    output[`__regfile__data__bus__] regfile29,
    output[`__regfile__data__bus__] regfile30,
    output[`__regfile__data__bus__] regfile31
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
    
    assign regfile0=array_reg[0];
    assign regfile1=array_reg[1];
    assign regfile2=array_reg[2];
    assign regfile3=array_reg[3];
    assign regfile4=array_reg[4];
    assign regfile5=array_reg[5];
    assign regfile6=array_reg[6];
    assign regfile7=array_reg[7];
    assign regfile8=array_reg[8];
    assign regfile9=array_reg[9];
    assign regfile10=array_reg[10];
    assign regfile11=array_reg[11];
    assign regfile12=array_reg[12];
    assign regfile13=array_reg[13];
    assign regfile14=array_reg[14];
    assign regfile15=array_reg[15];
    assign regfile16=array_reg[16];
    assign regfile17=array_reg[17];
    assign regfile18=array_reg[18];
    assign regfile19=array_reg[19];
    assign regfile20=array_reg[20];
    assign regfile21=array_reg[21];
    assign regfile22=array_reg[22];
    assign regfile23=array_reg[23];
    assign regfile24=array_reg[24];
    assign regfile25=array_reg[25];
    assign regfile26=array_reg[26];
    assign regfile27=array_reg[27];
    assign regfile28=array_reg[28];
    assign regfile29=array_reg[29];
    assign regfile30=array_reg[30];
    assign regfile31=array_reg[31];
    
endmodule
