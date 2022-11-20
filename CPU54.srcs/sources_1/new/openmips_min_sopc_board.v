`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/20 16:43:37
// Design Name: 
// Module Name: openmips_min_sopc_board
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

module openmips_min_sopc_board(
    input clk_in,
    input rst,
    output [7:0]o_sel,
    output [7:0]o_seg
    );
    wire clk;
    PIL PIL0(
        .clk_in(clk_in),
        .clk(clk)
    );
    wire [`__inst__address__bus__] inst_addr;
    wire [`__inst__data__bus__] inst;
    wire rom_ce;
    wire [`__regfile__data__bus__]i_ram_data;
    wire [`__regfile__data__bus__] ram_addr;
    wire [`__regfile__data__bus__] ram_data;
    wire ram_we;
    wire [3:0] ram_sel;
    wire ram_ce;
    
    wire [5:0] int;
    wire timer_int;

    assign int = {5'b00000,timer_int};
    
    openmips sccpu(
        .clk(clk),
        .rst(rst),
        .int(int),
        .rom_addr_o(inst_addr),
        .rom_data_i(inst),
        .rom_ce_o(rom_ce),
        .i_ram_data(i_ram_data),
        .o_ram_ce(ram_ce),
        .o_ram_sel(ram_sel),
        .o_ram_we(ram_we),
        .o_ram_data(ram_data),
        .o_ram_addr(ram_addr),
        .timer_int(timer_int)
    );
    
    imem imem0(
        .a(inst_addr[12:2]),
        .spo(inst)
    );
//    如要前仿真，放开下面的注释
//    inst_rom inst_rom0(
//        .ce(rom_ce),
//        .addr(inst_addr),
//        .inst(inst)
//    );
    
    data_ram data_ram0(
        .clk(clk),
        .ce(ram_ce),
        .we(ram_we),
        .addr(ram_addr),
        .sel(ram_sel),
        .i_data(ram_data),
        .o_data(i_ram_data)    
    );
    
    
    seg7x16 seg7x16_0(
        .clk(clk_in),
        .reset(rst),
        .cs(1'b1),
        .i_data(inst_addr + 32'h00400000),
        .o_seg(o_seg),
        .o_sel(o_sel)
    );
endmodule
