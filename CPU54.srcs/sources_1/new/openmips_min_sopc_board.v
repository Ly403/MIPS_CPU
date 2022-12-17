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
    input [5:0]choice,
    input stall,
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

    wire [`__regfile__data__bus__] regfile0;
    wire [`__regfile__data__bus__] regfile1;
    wire [`__regfile__data__bus__] regfile2;
    wire [`__regfile__data__bus__] regfile3;
    wire [`__regfile__data__bus__] regfile4;
    wire [`__regfile__data__bus__] regfile5;
    wire [`__regfile__data__bus__] regfile6;
    wire [`__regfile__data__bus__] regfile7;
    wire [`__regfile__data__bus__] regfile8;
    wire [`__regfile__data__bus__] regfile9;
    wire [`__regfile__data__bus__] regfile10;
    wire [`__regfile__data__bus__] regfile11;
    wire [`__regfile__data__bus__] regfile12;
    wire [`__regfile__data__bus__] regfile13;
    wire [`__regfile__data__bus__] regfile14;
    wire [`__regfile__data__bus__] regfile15;
    wire [`__regfile__data__bus__] regfile16;
    wire [`__regfile__data__bus__] regfile17;
    wire [`__regfile__data__bus__] regfile18;
    wire [`__regfile__data__bus__] regfile19;
    wire [`__regfile__data__bus__] regfile20;
    wire [`__regfile__data__bus__] regfile21;
    wire [`__regfile__data__bus__] regfile22;
    wire [`__regfile__data__bus__] regfile23;
    wire [`__regfile__data__bus__] regfile24;
    wire [`__regfile__data__bus__] regfile25;
    wire [`__regfile__data__bus__] regfile26;
    wire [`__regfile__data__bus__] regfile27;
    wire [`__regfile__data__bus__] regfile28;
    wire [`__regfile__data__bus__] regfile29;
    wire [`__regfile__data__bus__] regfile30;
    wire [`__regfile__data__bus__] regfile31;
        
    _openmips sccpu(
        .clk(clk),
        .rst(rst),
        .int(int),
        .stallreq_from_if(stall),
        
        .rom_addr_o(inst_addr),
        .rom_data_i(inst),
        .rom_ce_o(rom_ce),
        .dwishbone_data_i(i_ram_data),
        .dwishbone_ack_i(1'b1),
        .dwishbone_addr_o(ram_addr),
        .dwishbone_data_o(ram_data),
        .dwishbone_we_o(ram_we),
        .dwishbone_sel_o(ram_sel),
        .dwishbone_stb_o(ram_ce),
        .dwishbone_cyc_o(),
        
        .regfile7(regfile7),
        .regfile8(regfile8),
        .regfile9(regfile9),
        .regfile10(regfile10),
        .regfile11(regfile11),
        .regfile12(regfile12),
        .regfile13(regfile13),
        .regfile14(regfile14),
        .regfile15(regfile15),
        .regfile16(regfile16),
        .regfile17(regfile17),
        .regfile18(regfile18),
        .regfile19(regfile19),
        .regfile20(regfile20),
        .regfile21(regfile21),
        .regfile22(regfile22),
        .regfile23(regfile23),
        .regfile24(regfile24),
        .regfile25(regfile25),
        .regfile26(regfile26),
        .regfile27(regfile27),
        .regfile28(regfile28),
        .regfile29(regfile29),
        .regfile30(regfile30),
        .regfile31(regfile31),
        
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
    
    reg [`__regfile__data__bus__] data;
    always @(*)begin
        case(choice)
        6'b100000:begin
            data <= inst_addr + 32'h00400000;
        end
        6'b010000:begin // a
            data <= regfile2;
        end
        6'b001000:begin// b
            data <= regfile3;
        end
        6'b000100:begin// c
            data <= regfile9;
        end
        6'b000010:begin// d
            data <= regfile17;
        end
        6'b000001:begin// e
            data <= regfile21;
        end
        default:begin
            data <= `zero;
        end
        endcase
    end 
        
    seg7x16 seg7x16_0(
        .clk(clk_in),
        .reset(rst),
        .cs(1'b1),
        .i_data(data),
        .o_seg(o_seg),
        .o_sel(o_sel)
    );
endmodule
