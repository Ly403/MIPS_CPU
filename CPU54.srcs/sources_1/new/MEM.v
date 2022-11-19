`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/27 20:40:52
// Design Name: 
// Module Name: MEM
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
//访存
module MEM(
    input rst,
    //来自执行阶段的信息
    input [`__regfile__address__bus__]wd,
    input wreg,
    input [`__regfile__data__bus__]wdata,

    input [`__regfile__data__bus__] i_hi,
    input [`__regfile__data__bus__] i_lo,
    input i_w_hilo,

    input [`ALUOP] i_aluop,
    input [`__regfile__data__bus__] i_mem_addr,
    input [`__regfile__data__bus__] i_regb,

    input [`__regfile__data__bus__] i_mem_data,

    input cp0_reg_we,
    input [4:0]cp0_reg_waddr,
    input [`__regfile__data__bus__]cp0_reg_data,

    input [31:0] excepttype,
    input is_in_dalay_slot,
    input [`__regfile__data__bus__]current_inst_addr,

    //CP0模块给入输入
    input [`__regfile__data__bus__] cp0_status,
    input [`__regfile__data__bus__] cp0_cause,
    input [`__regfile__data__bus__] cp0_epc,
  
    input wb_cp0_reg_we,
    input [4:0]wb_cp0_reg_waddr,
    input [`__regfile__data__bus__]wb_cp0_reg_data,
    //访存阶段的结果
    output reg [`__regfile__address__bus__] o_wd,
    output reg o_wreg,
    output reg [`__regfile__data__bus__]o_wdata,

    output reg [`__regfile__data__bus__] o_hi,
    output reg [`__regfile__data__bus__] o_lo,
    output reg o_w_hilo,
    
    output reg [`__regfile__data__bus__] o_mem_addr,
    output wire o_mem_we,
    output reg [3:0] o_mem_sel,
    output reg [`__regfile__data__bus__] o_mem_data,
    output reg o_mem_ce,

    output reg o_cp0_reg_we,
    output reg [4:0]o_cp0_reg_waddr,
    output reg [`__regfile__data__bus__]o_cp0_reg_data,

    output reg [31:0] o_excepttype,
    output wire [`__regfile__data__bus__] o_cp0_epc,
    output wire o_is_in_dalay_slot,
    output wire [`__regfile__data__bus__] o_current_inst_addr
    );

    wire [`__regfile__data__bus__] zero32;
    reg mem_we;

    reg [`__regfile__data__bus__] t_cp0_status;
    reg [`__regfile__data__bus__] t_cp0_cause;
    reg [`__regfile__data__bus__] t_cp0_epc;


    assign zero32 = `zero;

    assign o_is_in_dalay_slot = is_in_dalay_slot;
    assign o_current_inst_addr = current_inst_addr;
    
    always @(*) begin
        if(rst == `RstEnable)begin
          o_wd <= `NOP;
          o_wreg <= `WriteDisable;
          o_wdata <= `zero;
          o_hi <= `zero;
          o_lo <= `zero;
          o_w_hilo <= `WriteDisable;
          o_mem_addr <= `zero;
          mem_we <= `WriteDisable;
          o_mem_sel <= 4'b0000;
          o_mem_data <= `zero;
          o_mem_ce <= `__chip__disable__;
          o_cp0_reg_we <= `WriteDisable;
          o_cp0_reg_waddr <= 5'b00000;
          o_cp0_reg_data <= `zero;
        end        
        else begin
          o_wd <= wd;
          o_wreg <= wreg;
          o_wdata <= wdata;
          o_hi <= i_hi;
          o_lo <= i_lo;
          o_w_hilo <= i_w_hilo;
          o_mem_addr <= `zero;
          mem_we <= `WriteDisable;
          o_mem_sel <= 4'b1111;
          o_mem_data <= `zero;
          o_mem_ce <= `__chip__disable__;
          o_cp0_reg_we <= cp0_reg_we;
          o_cp0_reg_waddr <= cp0_reg_waddr;
          o_cp0_reg_data <= cp0_reg_data;          

          case (i_aluop)
            `__lb__op__:begin
                o_mem_addr <= i_mem_addr;  
                mem_we <= `WriteDisable;
                o_mem_ce <= `__chip__enable__;

                case(i_mem_addr[1:0])
                  2'b00:begin
                    o_wdata <= {{24{i_mem_data[31]}},i_mem_data[31:24]};
                    o_mem_sel <= 4'b1000;
                  end
                  2'b01:begin
                    o_wdata <= {{24{i_mem_data[23]}},i_mem_data[23:16]};
                    o_mem_sel <= 4'b0100;
                  end
                  2'b10:begin
                    o_wdata <= {{24{i_mem_data[15]}},i_mem_data[15:8]};
                    o_mem_sel <= 4'b0010;
                  end
                  2'b11:begin
                    o_wdata <= {{24{i_mem_data[7]}},i_mem_data[7:0]};
                    o_mem_sel <= 4'b0001;
                  end
                  default:begin
                    o_wdata <= `zero;
                  end   
                endcase 
            end

            `__lbu__op__:begin
                o_mem_addr <= i_mem_addr;  
                mem_we <= `WriteDisable;
                o_mem_ce <= `__chip__enable__;

                case(i_mem_addr[1:0])
                  2'b00:begin
                    o_wdata <= {{24{1'b0}},i_mem_data[31:24]};
                    o_mem_sel <= 4'b1000;
                  end
                  2'b01:begin
                    o_wdata <= {{24{1'b0}},i_mem_data[23:16]};
                    o_mem_sel <= 4'b0100;
                  end
                  2'b10:begin
                    o_wdata <= {{24{1'b0}},i_mem_data[15:8]};
                    o_mem_sel <= 4'b0010;
                  end
                  2'b11:begin
                    o_wdata <= {{24{1'b0}},i_mem_data[7:0]};
                    o_mem_sel <= 4'b0001;
                  end
                  default:begin
                    o_wdata <= `zero;
                  end   
                endcase 
            end

            `__lh__op__:begin
                o_mem_addr <= i_mem_addr;  
                mem_we <= `WriteDisable;
                o_mem_ce <= `__chip__enable__;

                case(i_mem_addr[1:0])
                  2'b00:begin
                    o_wdata <= {{16{i_mem_data[31]}},i_mem_data[31:16]};
                    o_mem_sel <= 4'b1100;
                  end
                  2'b10:begin
                    o_wdata <= {{16{i_mem_data[15]}},i_mem_data[15:0]};
                    o_mem_sel <= 4'b0011;
                  end
                  default:begin
                    o_wdata <= `zero;
                  end   
                endcase 
            end

            `__lhu__op__:begin
                o_mem_addr <= i_mem_addr;  
                mem_we <= `WriteDisable;
                o_mem_ce <= `__chip__enable__;

                case(i_mem_addr[1:0])
                  2'b00:begin
                    o_wdata <= {{16{1'b0}},i_mem_data[31:16]};
                    o_mem_sel <= 4'b1100;
                  end
                  2'b10:begin
                    o_wdata <= {{16{1'b0}},i_mem_data[15:0]};
                    o_mem_sel <= 4'b0011;
                  end
                  default:begin
                    o_wdata <= `zero;
                  end   
                endcase 
            end

            `__lw__op__:begin
                o_mem_addr <= i_mem_addr;
                mem_we <= `WriteDisable;
                o_wdata <= i_mem_data;
                o_mem_sel <= 4'b1111;
                o_mem_ce <= `__chip__enable__;
            end

            `__lwl__op__:begin
                o_mem_addr <= {i_mem_addr[31:2],2'b00};
                mem_we <= `WriteDisable;
                o_mem_sel <= 4'b1111;
                o_mem_ce <= `__chip__enable__;

                case (i_mem_addr[1:0])
                  2'b00:begin
                    o_wdata <= i_mem_addr[31:0];
                  end
                  2'b01:begin
                    o_wdata <= {i_mem_addr[23:0],i_mem_addr[7:0]};
                  end
                  2'b10:begin
                    o_wdata <= {i_mem_addr[15:0],i_mem_addr[15:0]};
                  end
                  2'b11:begin
                    o_wdata <= {i_mem_addr[7:0],i_mem_addr[23:0]};
                  end                   
                  default:begin
                    o_wdata <= `zero;
                  end
                endcase                
            end

            `__lwr__op__:begin
                o_mem_addr <= {i_mem_addr[31:2],2'b00};
                mem_we <= `WriteDisable;
                o_mem_sel <= 4'b1111;
                o_mem_ce <= `__chip__enable__;

                case (i_mem_addr[1:0])
                  2'b00:begin
                    o_wdata <= {i_mem_addr[31:8],i_mem_addr[31:24]};
                  end
                  2'b01:begin
                    o_wdata <= {i_mem_addr[31:16],i_mem_addr[31:16]};
                  end
                  2'b10:begin
                    o_wdata <= {i_mem_addr[31:24],i_mem_addr[31:8]};
                  end
                  2'b11:begin
                    o_wdata <= i_mem_addr;
                  end                   
                  default:begin
                    o_wdata <= `zero;
                  end
                endcase                  
            end

            `__sb__op__:begin
                o_mem_addr <= i_mem_addr;
                mem_we <= `WriteEnable;
                o_mem_data <= {i_regb[7:0],i_regb[7:0],i_regb[7:0],i_regb[7:0]};
                o_mem_ce <= `__chip__enable__;
                case (i_mem_addr[1:0])
                  2'b00:begin
                    o_mem_sel <= 4'b1000;
                  end 
                  2'b01:begin
                    o_mem_sel <= 4'b0100;
                  end 
                  2'b10:begin
                    o_mem_sel <= 4'b0010;
                  end 
                  2'b11:begin
                    o_mem_sel <= 4'b0001;
                  end 
                  default: begin
                    o_mem_sel <= 4'b0000;
                  end
                endcase
            end

            `__sh__op__:begin
                o_mem_addr <= i_mem_addr;
                mem_we <= `WriteEnable;
                o_mem_data <= {i_regb[15:0],i_regb[15:0]};
                o_mem_ce <= `__chip__enable__;
                case (i_mem_addr[1:0])
                  2'b00:begin
                    o_mem_sel <= 4'b1100;
                  end 

                  2'b10:begin
                    o_mem_sel <= 4'b0011;
                  end 
 
                  default: begin
                    o_mem_sel <= 4'b0000;
                  end
                endcase
            end

            `__sw__op__:begin
                o_mem_addr <= i_mem_addr;
                mem_we <= `WriteEnable;
                o_mem_data <= i_regb[31:0];
                o_mem_sel <= 4'b1111;
                o_mem_ce <= `__chip__enable__;
            end

            `__swl__op__:begin
                o_mem_addr <= {i_mem_addr[31:2],2'b00};
                mem_we <= `WriteEnable;
                o_mem_ce <= `__chip__enable__;
                case (i_mem_addr[1:0])
                  2'b00:begin
                    o_mem_data <= i_regb;
                    o_mem_sel <= 4'b1111;
                  end 
                  2'b01:begin
                    o_mem_data <= {i_regb[7:0],i_regb[31:8]};
                    o_mem_sel <= 4'b0111;
                  end 
                  2'b10:begin
                    o_mem_data <= {i_regb[15:0],i_regb[31:16]};
                    o_mem_sel <= 4'b0011;
                  end 
                  2'b11:begin
                    o_mem_data <= {i_regb[23:0],i_regb[31:24]};
                    o_mem_sel <= 4'b0001;
                  end 
                  default: begin
                    o_mem_sel <= 4'b0000;
                  end
                endcase
            end

            `__swr__op__:begin
                o_mem_addr <= {i_mem_addr[31:2],2'b00};
                mem_we <= `WriteEnable;
                o_mem_ce <= `__chip__enable__;
                case (i_mem_addr[1:0])
                  2'b00:begin
                    o_mem_data <= {i_regb[7:0],i_regb[23:0]};
                    o_mem_sel <= 4'b1000;
                  end 
                  2'b01:begin
                    o_mem_data <= {i_regb[15:0],i_regb[15:0]};
                    o_mem_sel <= 4'b1100;
                  end 
                  2'b10:begin
                    o_mem_data <= {i_regb[23:0],i_regb[7:0]};
                    o_mem_sel <= 4'b1110;
                  end 
                  2'b11:begin
                    o_mem_data <= i_regb;
                    o_mem_sel <= 4'b1111;
                  end 
                  default: begin
                    o_mem_sel <= 4'b0000;
                  end
                endcase
            end

            default: begin
            end
          endcase
        end
    end

    assign o_cp0_epc = t_cp0_epc;


    always @(*) begin
        if(rst == `RstEnable)
          t_cp0_status <= `zero;
        else if(wb_cp0_reg_we == `WriteEnable && wb_cp0_reg_waddr == `__reg__status__)
          t_cp0_status <= wb_cp0_reg_data;
        else 
          t_cp0_status <= cp0_status;
    end

    always @(*) begin
        if(rst == `RstEnable)
          t_cp0_epc <= `zero;
        else if(wb_cp0_reg_we == `WriteEnable && wb_cp0_reg_waddr == `__reg__epc__)
          t_cp0_epc <= wb_cp0_reg_data;
        else 
          t_cp0_epc <= cp0_epc;
    end

    assign o_cp0_epc = t_cp0_epc;

    always @(*) begin
        if(rst == `RstEnable)
          t_cp0_cause <= `zero;
        else if(wb_cp0_reg_we == `WriteEnable && wb_cp0_reg_waddr == `__reg__epc__) begin
          //只写可写的部分
          t_cp0_cause[9:8] <=wb_cp0_reg_data[9:8];
          t_cp0_cause[22] <=wb_cp0_reg_data[22];
          t_cp0_cause[23] <=wb_cp0_reg_data[23];
        end
        else 
          t_cp0_cause <= cp0_cause;
    end

    always @(*) begin
        if(rst == `RstEnable)
          o_excepttype <= `zero;
        else begin
          o_excepttype <= `zero;
          if(current_inst_addr != `zero)begin
              if((t_cp0_cause[15:8] & t_cp0_status[15:8] != 8'h00) && t_cp0_status[1] == 1'b0 && t_cp0_status[0] == 1'b1)
                o_excepttype <= 32'h00000001; //interrupt 0001
              else if(excepttype[8] == 1'b1 && t_cp0_status[8] == 1'b1)
                o_excepttype <= 32'h00000008; //syscall  1000
              else if(excepttype[9] == 1'b1)
                o_excepttype <= `zero;
                //o_excepttype <= 32'h0000000a; //inst_invalid  1010 放开这条注释，处理非法指令异常
              else if(excepttype[10] == 1'b1 && t_cp0_status[9] == 1'b1)
                o_excepttype <= 32'h0000000d; //trap  1101
              else if(excepttype[11] == 1'b1)
                o_excepttype <= 32'h0000000c; //overflow 1100
              else if(excepttype[12] == 1'b1)
                o_excepttype <= 32'h0000000e; //eret 1110
              else if(excepttype[13] == 1'b1 && t_cp0_status[10] == 1'b1)
                o_excepttype <= 32'h0000000f; //break 存疑 1111
            end
        end
    end
    
        //如果发生了异常，那么必须取消对数据存储器的写操作
    assign o_mem_we = mem_we & (~(|o_excepttype));
    //assign o_mem_we = mem_we && (o_excepttype == `zero); //必须
    
endmodule
