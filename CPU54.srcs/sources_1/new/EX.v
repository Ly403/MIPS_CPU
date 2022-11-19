`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/27 20:04:11
// Design Name: 
// Module Name: EX
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
module EX(
    input rst,
    //译码阶段到执行阶段传入信息
    input [`ALUOP]aluop,
    input [`ALUSEL]alusel,
    input [`__regfile__data__bus__]rega,
    input [`__regfile__data__bus__]regb,
    input [`__regfile__address__bus__]wd,
    input wreg,
    //执行结果
    output reg [`__regfile__address__bus__]o_wd,
    output reg o_wreg,
    output reg [`__regfile__data__bus__]o_wdata,
    
    //为HI LO模块的接口
    //HILO模块给出的HI、LO寄存器的值
    input [`__regfile__data__bus__] _hi,
    input [`__regfile__data__bus__] _lo,
    
    //处理HI、LO寄存器带来的数据相关问题
    //WB模块
    input [`__regfile__data__bus__] i_wb_hi,
    input [`__regfile__data__bus__] i_wb_lo,
    input i_wb_w_hilo, //写信号

    //MEM模块
    input [`__regfile__data__bus__] i_mem_hi,
    input [`__regfile__data__bus__] i_mem_lo,
    input i_mem_w_hilo, //写信号

    input [`__regfile__twice__data__bus__] i_hilo,
    input [1:0] i_cnt,

    input [`__regfile__twice__data__bus__]div_result,
    input div_ready,

    input [`__regfile__data__bus__] link_addr,
    input is_in_dalay_slot,

    input [`__regfile__data__bus__]inst,

    input mem_cp0_reg_we,
    input[4:0] mem_cp0_reg_waddr,
    input[`__regfile__data__bus__] mem_cp0_reg_data,

    input wb_cp0_reg_we,
    input[4:0] wb_cp0_reg_waddr,
    input[`__regfile__data__bus__] wb_cp0_reg_data,

    input [`__regfile__data__bus__] cp0_reg_data,
    output reg [4:0] cp0_reg_read_addr,
    
    output reg cp0_reg_we,
    output reg [4:0] cp0_reg_waddr,
    output reg [`__regfile__data__bus__] o_cp0_reg_data,

    output reg[`__regfile__data__bus__] hi,
    output reg[`__regfile__data__bus__] lo,
    output reg w_hilo,//写信号
    
    output reg [`__regfile__twice__data__bus__] o_hilo,
    output reg [1:0]o_cnt,

    output reg [`__regfile__data__bus__]div_opdata1,
    output reg [`__regfile__data__bus__]div_opdata2,
    output reg div_start,
    output reg signed_div,
    output reg stall_req,

    output wire [`ALUOP] o_aluop,
    output wire [`__regfile__data__bus__] o_mem_addr,
    output wire [`__regfile__data__bus__] o_regb,

    input [31:0] excepttype,
    input [`__regfile__data__bus__] current_inst_addr,

    output [31:0] o_excepttype,
    output o_is_in_dalay_slot,
    output [`__regfile__data__bus__]o_current_inst_addr 
    );
    
    //需要传至访存阶段的信息
    assign o_aluop = aluop;
    assign o_mem_addr = rega + {{16{inst[15]}},inst[15:0]};
    assign o_regb = regb;

    reg [`__regfile__data__bus__] logic_out;  //逻辑运算结果
    reg [`__regfile__data__bus__] shift_res; //移位运算结果
    reg [`__regfile__data__bus__] move_res;
    reg [`__regfile__data__bus__] HI;
    reg [`__regfile__data__bus__] LO;
    reg [`__regfile__data__bus__]arithmetic_res;
    reg [`__regfile__twice__data__bus__] mul_res;

    wire overflow;
    wire rega_equal_regb;
    wire rega_less_regb;
    
    wire [`__regfile__data__bus__] regb_mux;
    wire [`__regfile__data__bus__] rega_not;
    wire [`__regfile__data__bus__] add_result;
    wire [`__regfile__data__bus__] mult_opdata1;
    wire [`__regfile__data__bus__] mult_opdata2;
    wire [`__regfile__twice__data__bus__] hilo;
    reg [`__regfile__twice__data__bus__] hilo1;
    reg stall_req_for_madd_msub;
    reg stall_req_for_div;

    reg trap_assert;
    reg overflow_assert;
    //在输入异常类型的基础上添加溢出异常、自陷异常
    assign o_excepttype = {excepttype[31:12],overflow_assert,trap_assert,excepttype[9:8],8'h00};

    assign o_is_in_dalay_slot = is_in_dalay_slot; //直接传出延迟信息

    assign o_current_inst_addr = current_inst_addr;//直接传出断点信息

    /***************根据aluop指示的运算子类型进行运算****************/
    //////////////////////////////////////////////////////////////////////////////////
    //逻辑运算
    always @(*) begin
        if(rst == `RstEnable) begin
            logic_out <= `zero;
        end
        else begin
            case(aluop)
                `__or__op__:begin
                  logic_out <= rega | regb;
                end
                `__and__op__:begin
                  logic_out <= rega & regb;
                end
                `__nor__op__:begin
                  logic_out <= ~ (rega | regb); 
                end
                `__xor__op__:begin
                  logic_out <= rega ^ regb;
                end
                default: begin
                  logic_out <= `zero;
                end
            endcase
        end
    end
    //////////////////////////////////////////////////////////////////////////////////
    //移位运算
    always @(*) begin
        if(rst == `RstEnable)begin
          shift_res <= `zero;
        end
        else begin
          case (aluop)
            `__sll__op__:begin
              shift_res <= regb << rega[4:0];
            end
            `__srl__op__:begin
              shift_res <= regb >> rega[4:0];
            end
            `__sra__op__:begin
              shift_res <= ({{32{regb[31]}}<<(6'd32 - {1'b0,rega[4:0]})}) | (regb >> rega[4:0]);
            end
            default:begin
              shift_res <= `zero;  
            end 
          endcase
        end
    end
    //////////////////////////////////////////////////////////////////////////////////
    //算术运算
    
    //减法或有符号运算，取补码
    assign regb_mux = (aluop == `__sub__op__ || aluop == `__subu__op__ || aluop == `__slt__op__
                      || aluop == `__tlt__op__ || aluop == `__tlti__op__ || aluop == `__tge__op__
                      || aluop == `__tgei__op__) ?
                      (~regb + 1) : regb;
    
    assign add_result = rega + regb_mux; //此法算出加减或slt指令结果

    //计算是否溢出
    //两正数相加为负数，两负数相加为正数
    assign overflow = (!rega[31] && !regb_mux[31] && add_result[31]) ||
                      (rega[31] && regb_mux[31] && !add_result[31]);
    
    //比较运算结果分有符号比较和无符号比较，即SLT和其他
    //SLT分为 正负数 两正数 两负数三种情况
    assign rega_less_regb = (aluop == `__slt__op__ || aluop == `__tlt__op__ || aluop == `__tlti__op__ ||
                            aluop == `__tge__op__ || aluop == `__tgei__op__) ?
                            ((rega[31] && !regb[31]) || (!rega[31] && !regb[31] && add_result[31]) 
                            || (rega[31] && regb[31] && add_result[31]))
                                    :(rega < regb);
    
    assign rega_not = ~rega;

    always @(*) begin
        if(rst == `RstEnable)begin
            arithmetic_res <= `zero;
        end
        else begin
          case(aluop)
              `__slt__op__,`__sltu__op__:begin
                  arithmetic_res <= rega_less_regb;
              end

              `__add__op__,`__addu__op__,`__addi__op__,`__addiu__op__:begin
                  arithmetic_res <= add_result;
              end

              `__sub__op__,`__subu__op__:begin
                  arithmetic_res <= add_result;
              end

              `__clz__op__:begin
                  arithmetic_res <= rega[31] ? 0 : rega[30] ? 1 :
                                    rega[29] ? 2 : rega[28] ? 3 :
                                    rega[27] ? 4 : rega[26] ? 5 :
                                    rega[25] ? 6 : rega[24] ? 7 :
                                    rega[23] ? 8 : rega[22] ? 9 :
                                    rega[21] ? 10 : rega[20] ? 11 :
                                    rega[19] ? 12 : rega[18] ? 13 :
                                    rega[17] ? 14 : rega[16] ? 15 :
                                    rega[15] ? 16 : rega[14] ? 17 :
                                    rega[13] ? 18 : rega[12] ? 19 :
                                    rega[11] ? 20 : rega[10] ? 21 :
                                    rega[9] ? 22 : rega[8] ? 23 :
                                    rega[7] ? 24 : rega[6] ? 25 :
                                    rega[5] ? 26 : rega[4] ? 27 :
                                    rega[3] ? 28 : rega[2] ? 29 :
                                    rega[1] ? 30 : rega[0] ? 31 : 32;
              end

              `__clo__op__:begin
                  arithmetic_res <= rega_not[31] ? 0 : rega_not[30] ? 1 :
                                    rega_not[29] ? 2 : rega_not[28] ? 3 :
                                    rega_not[27] ? 4 : rega_not[26] ? 5 :
                                    rega_not[25] ? 6 : rega_not[24] ? 7 :
                                    rega_not[23] ? 8 : rega_not[22] ? 9 :
                                    rega_not[21] ? 10 : rega_not[20] ? 11 :
                                    rega_not[19] ? 12 : rega_not[18] ? 13 :
                                    rega_not[17] ? 14 : rega_not[16] ? 15 :
                                    rega_not[15] ? 16 : rega_not[14] ? 17 :
                                    rega_not[13] ? 18 : rega_not[12] ? 19 :
                                    rega_not[11] ? 20 : rega_not[10] ? 21 :
                                    rega_not[9] ? 22 : rega_not[8] ? 23 :
                                    rega_not[7] ? 24 : rega_not[6] ? 25 :
                                    rega_not[5] ? 26 : rega_not[4] ? 27 :
                                    rega_not[3] ? 28 : rega_not[2] ? 29 :
                                    rega_not[1] ? 30 : rega_not[0] ? 31 : 32;
              end 

              default:begin
              end
          endcase
        end
    end

    /******************关于乘法运算********************/
    //先确定乘数，如果有符号乘法对负数要取补码
    assign mult_opdata1 = ((aluop == `__mul__op__ || aluop == `__mult__op__ || 
                            aluop == `__madd__op__ || aluop == `__msub__op__) 
                          && (rega[31] == 1'b1))
                              ? (~rega + 1) : rega;

    assign mult_opdata2 = ((aluop == `__mul__op__ || aluop == `__mult__op__ ||
                            aluop == `__madd__op__ || aluop == `__msub__op__) 
                          && (regb[31] == 1'b1))
                              ? (~regb + 1) : regb;    

    //计算临时乘法结果
    assign hilo = mult_opdata1 * mult_opdata2;

    //修正乘法结果作为最终结果
    always @(*) begin
        if(rst == `RstEnable) begin
            mul_res <= {`zero,`zero};
        end
        else if(aluop == `__mult__op__ || aluop == `__mul__op__ 
            || aluop == `__madd__op__ || aluop == `__msub__op__)begin
            //有符号乘法，需分两类：一者异号相乘，需做修正；一者同号相乘，不做修正
            if(rega[31] ^ regb[31]) //异号相乘
                mul_res <= ~hilo + 1;// 取补码
            else //同号相乘
                mul_res <= hilo;
        end
        else begin //无符号乘法不做修正
            mul_res <= hilo;
        end
    end

    //MADD、MADDU、MSUB、MSUBU指令
    always @(*) begin
        if(rst == `WriteEnable) begin
            o_hilo <= {`zero,`zero};
            o_cnt <= 2'b00;
            stall_req_for_madd_msub <= `UNSTOP;
        end
        else begin
            case(aluop)
                `__madd__op__,`__maddu__op__:begin
                    if(i_cnt == 2'b00)begin //执行阶段第一个时钟周期
                        o_hilo <= mul_res;
                        o_cnt <= 2'b01;  
                        hilo1 <= {`zero,`zero};
                        stall_req_for_madd_msub <= `STOP;
                    end
                    else if(i_cnt == 2'b01) begin//执行阶段第二个时钟周期
                        o_hilo <= {`zero,`zero};
                        o_cnt = 2'b10;
                        hilo1 <= i_hilo + {HI,LO};
                        stall_req_for_madd_msub <= `UNSTOP;
                    end
                end

                `__msub__op__,`__msubu__op__:begin
                    if(i_cnt == 2'b00)begin //执行阶段第一个时钟周期
                        o_hilo <= ~mul_res + 1;
                        o_cnt <= 2'b01;  
                        // hilo1 <= {`zero,`zero};
                        stall_req_for_madd_msub <= `STOP;
                    end
                    else if(i_cnt == 2'b01) begin//执行阶段第二个时钟周期
                        o_hilo <= {`zero,`zero};
                        o_cnt = 2'b10;
                        hilo1 <= i_hilo + {HI,LO};
                        stall_req_for_madd_msub <= `UNSTOP;
                    end
                end

                default:begin
                    o_hilo <= {`zero,`zero};
                    o_cnt <= 2'b00;
                    stall_req_for_madd_msub <= `UNSTOP;
                end
                
            endcase
        end
    end


    //DIV、DIVU指令	
    always @ (*) begin
      if(rst == `RstEnable) begin
        stall_req_for_div <= `UNSTOP;
        div_opdata1 <= `zero;
        div_opdata2 <= `zero;
        div_start <= `DivStop;
        signed_div <= 1'b0;
      end else begin
        stall_req_for_div <= `UNSTOP;
        div_opdata1 <= `zero;
        div_opdata2 <= `zero;
        div_start <= `DivStop;
        signed_div <= 1'b0;	
        case (aluop) 
          `__div__op__:		begin
            if(div_ready == `DivResultNotReady) begin
              div_opdata1 <= rega;
              div_opdata2 <= regb;
              div_start <= `DivStart;
              signed_div <= 1'b1;
              stall_req_for_div <= `STOP;
            end else if(div_ready == `DivResultReady) begin
              div_opdata1 <= rega;
              div_opdata2 <= regb;
              div_start <= `DivStop;
              signed_div <= 1'b1;
              stall_req_for_div <= `UNSTOP;
            end else begin						
              div_opdata1 <= `zero;
              div_opdata2 <= `zero;
              div_start <= `DivStop;
              signed_div <= 1'b0;
              stall_req_for_div <= `UNSTOP;
            end					
          end
          `__divu__op__:		begin
            if(div_ready == `DivResultNotReady) begin
              div_opdata1 <= rega;
              div_opdata2 <= regb;
              div_start <= `DivStart;
              signed_div <= 1'b0;
              stall_req_for_div <= `STOP;
            end else if(div_ready == `DivResultReady) begin
              div_opdata1 <= rega;
              div_opdata2 <= regb;
              div_start <= `DivStop;
              signed_div <= 1'b0;
              stall_req_for_div <= `UNSTOP;
            end else begin						
              div_opdata1 <= `zero;
              div_opdata2 <= `zero;
              div_start <= `DivStop;
              signed_div <= 1'b0;
              stall_req_for_div <= `UNSTOP;
            end					
          end
          default: begin
          end
        endcase
      end
    end	

    //////////////////////////////////////////////////////////////////////////////////
    //移动运算
    //MFHI、MFLO、MOVN、MOVZ指令
    always @(*) begin
        if(rst == `RstEnable)begin
            move_res <= `zero;
        end  
        else begin
            move_res <= `zero;
            case(aluop)
                `__mfhi__op__:begin
                    move_res <= HI;  
                end
                `__mflo__op__:begin
                    move_res <= LO;
                end
                `__movz__op__:begin
                    move_res <= rega;  
                end
                `__movn__op__:begin
                    move_res <= rega; 
                end
                 `__mfc0__op__:begin
                    //从CP0中读取的寄存器的地址
                    cp0_reg_read_addr <= inst[15:11];
                    move_res <= cp0_reg_data;

                    //数据相关
                    if(mem_cp0_reg_we == `WriteEnable && mem_cp0_reg_waddr == inst[15:11])begin
                        move_res <= mem_cp0_reg_data; //访存阶段数据相关
                    end
                    else if(wb_cp0_reg_we == `WriteEnable && wb_cp0_reg_waddr == inst[15:11])begin
                        move_res <= wb_cp0_reg_data;  //回写阶段数据相关
                    end
                end
                default:begin
                end
            endcase
        end 
    end
    //////////////////////////////////////////////////////////////////////////////////
    //相关结果寄存器的值
    /****************根据alusel指定的运算类型，选择一个运算结果作为最终结果****************/
    always @(*) begin
        o_wd <= wd;
        if((aluop == `__add__op__ || aluop == `__addi__op__ ||  aluop == `__sub__op__ ) && overflow == 1)begin
            o_wreg <= `WriteDisable;
            overflow_assert <= 1'b1;
        end
        else begin
            o_wreg <= wreg;
            overflow_assert <= 1'b0;
        end

        case(alusel)
          `__res__logic__:begin
            o_wdata <= logic_out;
          end
          `__res__shift__:begin
            o_wdata <= shift_res;
          end
          `__res__move__:begin
            o_wdata <= move_res;
          end
          `__res__arithmetic__:begin
            o_wdata <= arithmetic_res;
          end
          `__res__mul__:begin
            o_wdata <= mul_res[31:0];
          end
          `__res__jump__branch__:begin
            o_wdata <= link_addr;            
          end
          default:begin
            o_wdata <= `zero;
          end
        endcase
    end
    
    //HI LO寄存器处理，解决数据相关
    always @(*) begin
        if(rst == `RstEnable)begin
            {HI,LO} <= {`zero,`zero};
        end
        else if (i_mem_w_hilo == `WriteEnable)begin
            {HI,LO} <= {i_mem_hi,i_mem_lo};
        end
        else if (i_wb_w_hilo == `WriteEnable)begin
            {HI,LO} <= {i_wb_hi,i_wb_lo};  
        end
        else begin
            {HI,LO} <= {_hi,_lo};
        end
    end


    always @(*) begin
        if(rst == `RstEnable)begin
            w_hilo <= `WriteDisable;
            hi <= `zero;
            lo <= `zero;
        end
        else if(aluop == `__msub__op__ || aluop == `__msubu__op__)begin
            w_hilo <= `WriteEnable;
            hi <= hilo1[63:32];
            lo <= hilo1[31:0];
        end
        else if(aluop == `__madd__op__ || aluop == `__maddu__op__)begin
            w_hilo <= `WriteEnable;
            hi <= hilo1[63:32];
            lo <= hilo1[31:0];
        end       
        else if(aluop == `__mult__op__ || aluop == `__multu__op__) begin //乘法相关指令
            w_hilo <= `WriteEnable;
            hi <= mul_res[63:32];
            lo<= mul_res[31:0];
        end
        else if(aluop == `__mthi__op__)begin
            w_hilo <= `WriteEnable;
            hi <= rega;
            lo <= LO; 
        end
        else if(aluop == `__mtlo__op__)begin
            w_hilo <= `WriteEnable;
            hi <= HI;
            lo <= rega;  
        end
        else if(aluop == `__div__op__ || aluop == `__divu__op__)begin
            w_hilo <= `WriteEnable;
            hi <= div_result[63:32];
            lo <= div_result[31:0];
        end
        else begin
            w_hilo <= `WriteDisable;
            hi <= `zero;
            lo <= `zero;   
        end
    end

    //////////////////////////////////////////////////////////////////////////////////
    /*****************暂停控制******************/
    always @(*) begin
        stall_req <= stall_req_for_madd_msub || stall_req_for_div;
    end

	  always @ (*) begin
		  if(rst == `RstEnable) begin
			  cp0_reg_waddr <= 5'b00000;
			  cp0_reg_we <= `WriteDisable;
			  o_cp0_reg_data <= `zero;
		  end else if(aluop == `__mtc0__op__) begin
			  cp0_reg_waddr <= inst[15:11];
			  cp0_reg_we <= `WriteEnable;
			  o_cp0_reg_data <= rega;
	    end else begin
			  cp0_reg_waddr <= 5'b00000;
			  cp0_reg_we <= `WriteDisable;
			  o_cp0_reg_data <= `zero;
		end				
	end	

  //////////////////////////////////////////////////////////////////////////////////
  //异常处理

  //判断自陷异常
  always @(*) begin
      if(rst == `RstEnable)
          trap_assert <= `TrapNotAssert;
      else begin
          trap_assert <= `TrapNotAssert;
          case(aluop)
              `__teq__op__,`__teqi__op__:begin
                  if(rega == regb)
                      trap_assert <= `TrapAssert;
              end

              `__tge__op__,`__tgei__op__,`__tgeiu__op__,`__tgeu__op__:begin
                  if(~rega_less_regb)
                      trap_assert <= `TrapAssert;
              end

              `__tlt__op__,`__tlti__op__,`__tltiu__op__,`__tltu__op__:begin
                  if(rega_less_regb)
                      trap_assert <= `TrapAssert;
              end

              `__tne__op__,`__tnei__op__:begin
                  if(rega != regb)
                      trap_assert <= `TrapAssert;
              end

              default:begin
                  trap_assert <= `TrapNotAssert;
              end

          endcase
      end
  end

endmodule
