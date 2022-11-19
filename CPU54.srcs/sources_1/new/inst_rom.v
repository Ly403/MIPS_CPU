`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/28 10:57:04
// Design Name: 
// Module Name: inst_rom
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
//指令存储器
module inst_rom(
    input ce,
    input [`__inst__address__bus__]addr,
    output reg [`__inst__data__bus__]inst
    );

    reg [`__inst__data__bus__] inst_mem [0:`__inst__memory__num__ - 1];

    initial begin 
        $readmemh ("D:/desktop/MIPS_CPU/CPU54.srcs/sources_1/new/inst_rom.data",inst_mem);
    end
    //当复位信号无效，依据输入地址，给出指定存储器中ROM对应的元素
    always @(*) begin
        if(ce == `__chip__disable__)begin
          inst <= `zero;
        end
        else begin
          inst <= inst_mem[addr[`__inst__memory__width__ + 1:2]]; //以4为倍数，最后两位不要
        end
    end
    
endmodule
