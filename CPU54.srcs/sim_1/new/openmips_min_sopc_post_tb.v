`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/17 16:39:45
// Design Name: 
// Module Name: openmips_min_sopc_post_tb
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
// �����Ǻ����Ĳ���ģ��
module openmips_min_sopc_post_tb();
    reg CLOCK_50; //50MHz��ʱ��
    reg rst;

    integer counter;
    integer file_out;

    initial begin
        CLOCK_50 = 1'b0;
        forever #1 CLOCK_50 = ~CLOCK_50;
    end

    initial begin
        file_out = $fopen("D:/desktop/MIPS_CPU/CPU54.srcs/result.txt","w+");
        counter = 0;
        rst = `RstEnable;
        #49 rst = `RstDisable;
        // #1000 $stop;
    end

    openmips_min_sopc_post uut(
        .clk(CLOCK_50),
        .rst(rst)
    );
    
    
    always @(posedge CLOCK_50) begin
        if(rst == `RstEnable)
            counter <= 0;
        else if(rst == `RstDisable)begin
            if(counter == `__inst__memory__num__)begin
                $fclose(file_out);
            end
            else begin
                counter = counter + 1;
                if(counter > 0)begin
                     $fdisplay(file_out,"pc: %h",uut.inst_addr + 32'h00400000);
                     $fdisplay(file_out,"instr: %h",uut.inst);
                     $fdisplay(file_out,"regfile0: %h",uut.sccpu.cpu_ref.array_reg[0]); 
                     $fdisplay(file_out,"regfile1: %h",uut.sccpu.cpu_ref.array_reg[1]); 
                     $fdisplay(file_out,"regfile2: %h",uut.sccpu.cpu_ref.array_reg[2]); 
                     $fdisplay(file_out,"regfile3: %h",uut.sccpu.cpu_ref.array_reg[3]); 
                     $fdisplay(file_out,"regfile4: %h",uut.sccpu.cpu_ref.array_reg[4]); 
                     $fdisplay(file_out,"regfile5: %h",uut.sccpu.cpu_ref.array_reg[5]); 
                     $fdisplay(file_out,"regfile6: %h",uut.sccpu.cpu_ref.array_reg[6]); 
                     $fdisplay(file_out,"regfile7: %h",uut.sccpu.cpu_ref.array_reg[7]); 
                     $fdisplay(file_out,"regfile8: %h",uut.sccpu.cpu_ref.array_reg[8]); 
                     $fdisplay(file_out,"regfile9: %h",uut.sccpu.cpu_ref.array_reg[9]); 
                     $fdisplay(file_out,"regfile10: %h",uut.sccpu.cpu_ref.array_reg[10]); 
                     $fdisplay(file_out,"regfile11: %h",uut.sccpu.cpu_ref.array_reg[11]); 
                     $fdisplay(file_out,"regfile12: %h",uut.sccpu.cpu_ref.array_reg[12]); 
                     $fdisplay(file_out,"regfile13: %h",uut.sccpu.cpu_ref.array_reg[13]); 
                     $fdisplay(file_out,"regfile14: %h",uut.sccpu.cpu_ref.array_reg[14]); 
                     $fdisplay(file_out,"regfile15: %h",uut.sccpu.cpu_ref.array_reg[15]); 
                     $fdisplay(file_out,"regfile16: %h",uut.sccpu.cpu_ref.array_reg[16]); 
                     $fdisplay(file_out,"regfile17: %h",uut.sccpu.cpu_ref.array_reg[17]); 
                     $fdisplay(file_out,"regfile18: %h",uut.sccpu.cpu_ref.array_reg[18]); 
                     $fdisplay(file_out,"regfile19: %h",uut.sccpu.cpu_ref.array_reg[19]); 
                     $fdisplay(file_out,"regfile20: %h",uut.sccpu.cpu_ref.array_reg[20]); 
                     $fdisplay(file_out,"regfile21: %h",uut.sccpu.cpu_ref.array_reg[21]); 
                     $fdisplay(file_out,"regfile22: %h",uut.sccpu.cpu_ref.array_reg[22]); 
                     $fdisplay(file_out,"regfile23: %h",uut.sccpu.cpu_ref.array_reg[23]); 
                     $fdisplay(file_out,"regfile24: %h",uut.sccpu.cpu_ref.array_reg[24]); 
                     $fdisplay(file_out,"regfile25: %h",uut.sccpu.cpu_ref.array_reg[25]); 
                     $fdisplay(file_out,"regfile26: %h",uut.sccpu.cpu_ref.array_reg[26]); 
                     $fdisplay(file_out,"regfile27: %h",uut.sccpu.cpu_ref.array_reg[27]); 
                     $fdisplay(file_out,"regfile28: %h",uut.sccpu.cpu_ref.array_reg[28]); 
                     $fdisplay(file_out,"regfile29: %h",uut.sccpu.cpu_ref.array_reg[29]); 
                     $fdisplay(file_out,"regfile30: %h",uut.sccpu.cpu_ref.array_reg[30]); 
                     $fdisplay(file_out,"regfile31: %h",uut.sccpu.cpu_ref.array_reg[31]); 
                end
            end  
       end  
    end
endmodule
