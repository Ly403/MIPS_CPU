`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/28 13:14:34
// Design Name: 
// Module Name: openmips_min_sopc
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

module openmips_min_sopc(
    input wire clk,
    input wire rst
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

        .iwishbone_data_i(inst),
        .iwishbone_ack_i(1'b1),
        .iwishbone_addr_o(inst_addr),
        .iwishbone_data_o(),
        .iwishbone_we_o(),
        .iwishbone_sel_o(),
        .iwishbone_stb_o(rom_ce),
        .iwishbone_cyc_o(),
        
        .dwishbone_data_i(i_ram_data),
        .dwishbone_ack_i(1'b1),
        .dwishbone_addr_o(ram_addr),
        .dwishbone_data_o(ram_data),
        .dwishbone_we_o(ram_we),
        .dwishbone_sel_o(ram_sel),
        .dwishbone_stb_o(ram_ce),
        .dwishbone_cyc_o(),

        .timer_int(timer_int)
    );
    
/*    imem imem0(
        .a(inst_addr[12:2]),
        .spo(inst)
    );*/
    //如要前仿真，放开下面的注释
    inst_rom inst_rom0(
        .ce(1'b1),
        .addr(inst_addr),
        .inst(inst)
    );
    
    data_ram data_ram0(
        .clk(clk),
        .ce(1'b1),
        .we(ram_we),
        .addr(ram_addr),
        .sel(ram_sel),
        .i_data(ram_data),
        .o_data(i_ram_data)    
    );
    
endmodule
