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
    
    /* д��������ź� */
    input write,
    input [`__regfile__address__bus__]write_addr,
    input [`__regfile__data__bus__]write_data,
    
    /* ��ȡ�˿�a����ź� */
    input ra,
    input [`__regfile__address__bus__]addra,
    output reg [`__regfile__data__bus__]dataa,
    
    /* ��ȡ�˿�b����ź� */
    input rb,
    input [`__regfile__address__bus__]addrb,
    output reg [`__regfile__data__bus__]datab
    );
    
    reg [`__regfile__data__bus__] array_reg [0:`__regfile__number__ - 1] ;
    
    //д�˿�
    integer i;
    always@(posedge clk)begin
        if(rst == `RstEnable)begin
            for(i=0;i<`__regfile__number__;i=i+1)begin
                array_reg[i] <= `zero;
            end
        end
        else if(rst == `RstDisable)begin
            if(write == `WriteEnable && (write_addr != `__regfile__number__width__'h0))begin
                //�˴���$0�Ĵ������ܱ�д�룬$0ֵһֱ��0
                array_reg[write_addr] <= write_data;
            end
        end
    end
    
    //��һ���˿�
    always@(*)begin
        if(rst == `RstEnable)begin
            dataa <= `zero;
        end
        else if (addra ==  `__regfile__number__width__'h0)begin
            //�˴�����$0��ֱ�Ӹ���ֵΪ0
            dataa <= `zero;
        end
        else if(addra == write_addr && write == `WriteEnable && ra == `ReadEnable)begin
            //�˴�����дͬʱ������һ���Ĵ������Ͱ�д���ֱֵ�Ӷ���
            dataa <= write_data;
        end
        else if(ra == `ReadEnable)begin
            dataa <= array_reg[addra]; 
        end
        else begin
            dataa <= `zero;
        end
    end
    
    //�ڶ����˿�
    always@(*)begin
        if(rst == `RstEnable)begin
            datab <= `zero;
        end
        else if (addrb ==  `__regfile__number__width__'h0)begin
            //�˴�����$0��ֱ�Ӹ���ֵΪ0
            datab <= `zero;
        end
        else if(addrb == write_addr && write == `WriteEnable && rb == `ReadEnable)begin
            //�˴�����дͬʱ������һ���Ĵ������Ͱ�д���ֱֵ�Ӷ���
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
