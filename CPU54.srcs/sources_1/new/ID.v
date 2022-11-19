`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/19 16:24:17
// Design Name: 
// Module Name: ID
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
//ָ������ģ��
module ID(
    //��λ
    input rst,
    //��ȡָ��ĵ�ַpc�Ͷ�ȡ��ָ��inst
    input[`__inst__address__bus__] pc,
    input[`__inst__data__bus__] inst,
    
    input is_pipeline,
    //regfile�������˿ڵ�����
    input[`__regfile__data__bus__] reg_dataa,
    input[`__regfile__data__bus__] reg_datab,
    
    //����ִ�н׶�ָ�����н��
    input ex_wreg,
    input [`__regfile__data__bus__]ex_wdata,
    input [`__regfile__address__bus__]ex_wd,
    input [`ALUOP] ex_aluop,

    //���ڷô�׶ε�ָ��������
    input mem_wreg,
    input [`__regfile__data__bus__]mem_wdata,
    input [`__regfile__address__bus__]mem_wd,

    input is_in_dalay_slot,
    
    //a��b�˿ڶ�ʹ��
    output reg reg_reada,
    output reg reg_readb,
    
    //a��b�˿ڶ���ַ
    output reg [`__regfile__address__bus__]reg_addra,
    output reg [`__regfile__address__bus__]reg_addrb,
    
    //ָ��Ҫ���е����������
    output reg [`ALUOP]alu_op,
    output reg [`ALUSEL]alu_sel,
    
    //����Դ������
    output reg [`__regfile__data__bus__]rega,
    output reg [`__regfile__data__bus__]regb,
    
    //д��Ĵ����ĵ�ַ��д��ʹ���ź�
    output reg [`__regfile__address__bus__]wd,//��ַ
    output reg wreg,//ʹ��

    output wire stall_req,

    output reg next_inst_in_delay_slot,

    output reg branch_flag,
    output reg [`__regfile__data__bus__]branch_address,
    output reg [`__regfile__data__bus__]link_addr,
    output reg o_is_in_dalay_slot,

    output wire [`__regfile__data__bus__]o_inst,

    output wire [31:0] excepttype,
    output wire [`__regfile__data__bus__] current_inst_addr
    );
    

    // assign inst = is_in_dalay_slot == `InDelaySlot ? `zero : inst; //������ӳٲ�ָ�ֱ�ӿ�һ��nopָ���ȥ
    //ָ��Ĳ�����
    /*
    wire [5:0] op1 = inst[31:26];
    wire [4:0] op2 = inst[10:6];
    wire [5:0] op3 = inst[5:0];
    wire [4:0] op4 = inst[20:16];
    */
    
    //�˴���Ϊ����ˮ��CPU��������������һ��nopָ��ӳٲ�֮�У�����Ծָ�����
    wire [5:0] op1 = is_pipeline ? (is_in_dalay_slot == `InDelaySlot ? 6'b000000 :inst[31:26]) : inst[31:26];
    wire [4:0] op2 = is_pipeline ? (is_in_dalay_slot == `InDelaySlot ? 5'b00000 :inst[10:6]) : inst[10:6];
    wire [5:0] op3 = is_pipeline ? (is_in_dalay_slot == `InDelaySlot ? 6'b000000 :inst[5:0]) : inst[5:0];
    wire [4:0] op4 = is_pipeline ? (is_in_dalay_slot == `InDelaySlot ? 5'b00000 :inst[20:16]) : inst[20:16];
    
    //ָ��ִ�е�������
    reg [`__regfile__data__bus__] imm;
    //ָ���Ƿ���Ч
    reg inst_valid;
    
    wire [`__regfile__data__bus__]pc_plus_8;
    wire [`__regfile__data__bus__]pc_plus_4;

    wire [`__regfile__data__bus__] imm_ext;
    
    reg stall_req_for_rega_load;
    reg stall_req_for_regb_load;
    //��һ��ָ���Ƿ��Ǽ���ָ��
    wire pre_inst_is_load;

    //�����쳣
    reg excepttype_is_syscall;//ϵͳ�����쳣
    reg excepttype_is_eret;//�쳣����
    reg excepttype_is_break;
    
    assign stall_req = stall_req_for_rega_load | stall_req_for_regb_load;
    assign o_inst = inst; 
    
    assign pc_plus_8 = pc + 8;
    assign pc_plus_4 = pc + 4;

    assign imm_ext = {{14{inst[15]}},inst[15:0],2'b00}; 
    
    assign pre_inst_is_load = (ex_aluop == `__lb__op__ || ex_aluop ==`__lbu__op__ ||
                                ex_aluop == `__lh__op__ || ex_aluop == `__lhu__op__ ||
                                ex_aluop == `__lw__op__ || ex_aluop == `__lwr__op__ ||
                                ex_aluop == `__lwl__op__  || ex_aluop == `__ll__op__ ||
                                ex_aluop == `__sc__op__) && (is_pipeline == 1'b1) ? 1'b1 : 1'b0; 
    
    // excepttype 
    // ��8 bit�����Ƿ�Ϊϵͳ�����쳣
    // ��9 bit�����Ƿ�Ϊ��Чָ����ɵ��쳣
    // ��12 bit��ʾ�Ƿ�Ϊ�쳣���أ�������Ϊ��һ��������쳣��
    assign excepttype = {18'b0,excepttype_is_break,excepttype_is_eret,2'b0,inst_valid,excepttype_is_syscall,8'b0};
    
    //��ǰָ���ַ������ϵ���
    assign current_inst_addr = pc;

    /*
        ���regfile���˿�1Ҫ��ȡ�ļĴ�������ִ�н׶�Ҫд�ļĴ�����
        ��ôֱ�Ӱ�ִ�н׶ε�ex_wdata��Ϊrega��ֵ
        ���regfile���˿�1Ҫ��ȡ�ļĴ������Ƿô�׶�Ҫд�ļĴ�����
        ��ôֱ�Ӱѷô�׶ε�mem_wdata��Ϊrega��ֵ
        ͬ��Զ��˿�2
    */

    /********************��ʼ����**********************/
    always @(*)begin
        if(rst == `RstEnable)begin
            alu_op <= `__nop__op__;
            alu_sel <= `__res__nop__;
            wd <= `NOP;
            wreg <= `WriteDisable;
            inst_valid <= `__instruction__valid__;
            reg_reada <= 1'b0;
            reg_readb <= 1'b0;
            reg_addra <= `NOP;
            reg_addrb <= `NOP;
            imm <= `zero;
            link_addr <= `zero;
            branch_address <= `zero;
            branch_flag <= `__not__branch__;
            next_inst_in_delay_slot <= `NotInDelaySlot;
            excepttype_is_syscall <= `false;
            excepttype_is_eret <= `false;
            excepttype_is_break <= `false;
        end
        else begin
            alu_op <= `__nop__op__;
            alu_sel <= `__res__nop__;
            wd <= inst[15:11];
            wreg <= `WriteDisable;
            inst_valid <=`__instruction__invalid__;
            reg_reada <= 1'b0;
            reg_readb <= 1'b0;
            reg_addra <= inst[25:21]; //Ĭ��ͨ��regfile���˿�1��ȡ�ļĴ�����ַ
            reg_addrb <= inst[20:16];  //Ĭ��ͨ��regfile���˿�2��ȡ�ļĴ�����ַ
            imm <= `zero;
            link_addr <= `zero;
            branch_address <= `zero;
            branch_flag <= `__not__branch__;
            next_inst_in_delay_slot <= `NotInDelaySlot;
            excepttype_is_syscall <= `false;
            excepttype_is_eret <= `false;
            excepttype_is_break <= `false;
            
            case(op1)
                `__special__inst__: begin
                    case(op2)
                        5'b00000:begin
                            case(op3)
                                `__or__: begin
                                    wreg <= `WriteEnable;
                                    alu_op <= `__or__op__;
                                    alu_sel <= `__res__logic__;
                                    reg_reada <= 1'b1;
                                    reg_readb <= 1'b1;
                                    inst_valid <= `__instruction__valid__;
                                end
                                
                                `__and__: begin
                                    wreg <= `WriteEnable;
                                    alu_op <= `__and__op__;
                                    alu_sel <= `__res__logic__;
                                    reg_reada <= 1'b1;
                                    reg_readb <= 1'b1;
                                    inst_valid <= `__instruction__valid__;
                                end

                                `__xor__: begin
                                    wreg <= `WriteEnable;
                                    alu_op <= `__xor__op__;
                                    alu_sel <= `__res__logic__;
                                    reg_reada <= 1'b1;
                                    reg_readb <= 1'b1;
                                    inst_valid <= `__instruction__valid__;
                                end

                                `__nor__: begin
                                    wreg <= `WriteEnable;
                                    alu_op <= `__nor__op__;
                                    alu_sel <= `__res__logic__;
                                    reg_reada <= 1'b1;
                                    reg_readb <= 1'b1;
                                    inst_valid <= `__instruction__valid__;
                                end

                                `__sllv__: begin
                                    wreg <= `WriteEnable;
                                    alu_op <= `__sll__op__;
                                    alu_sel <= `__res__shift__;
                                    reg_reada <= 1'b1;
                                    reg_readb <= 1'b1;
                                    inst_valid <= `__instruction__valid__;
                                end

                                `__srlv__: begin
                                    wreg <= `WriteEnable;
                                    alu_op <= `__srl__op__;
                                    alu_sel <= `__res__shift__;
                                    reg_reada <= 1'b1;
                                    reg_readb <= 1'b1;
                                    inst_valid <= `__instruction__valid__;
                                end

                                `__srav__: begin
                                    wreg <= `WriteEnable;
                                    alu_op <= `__sra__op__;
                                    alu_sel <= `__res__shift__;
                                    reg_reada <= 1'b1;
                                    reg_readb <= 1'b1;
                                    inst_valid <= `__instruction__valid__;
                                end

                                `__sync__: begin
                                    wreg <= `WriteDisable;
                                    alu_op <= `__nop__op__;
                                    alu_sel <= `__res__nop__;
                                    reg_reada <= 1'b0;
                                    reg_readb <= 1'b1;
                                    inst_valid <= `__instruction__valid__;
                                end

                                `__mfhi__:begin
                                    wreg <= `WriteEnable;
                                    alu_op <= `__mfhi__op__;
                                    alu_sel <= `__res__move__;
                                    reg_reada <= 1'b0;
                                    reg_readb <= 1'b0;
                                    inst_valid <= `__instruction__valid__;
                                end 

                                `__mflo__:begin
                                    wreg <= `WriteEnable;
                                    alu_op <= `__mflo__op__;
                                    alu_sel <= `__res__move__;
                                    reg_reada <= 1'b0;
                                    reg_readb <= 1'b0;
                                    inst_valid <= `__instruction__valid__; 
                                end

                                `__mthi__:begin
                                    wreg <= `WriteDisable;
                                    alu_op <= `__mthi__op__;
                                    reg_reada <= 1'b1;
                                    reg_readb <= 1'b0;
                                    inst_valid <= `__instruction__valid__; 
                                end

                                `__mtlo__:begin
                                    wreg <= `WriteDisable;
                                    alu_op <= `__mtlo__op__;
                                    reg_reada <= 1'b1;
                                    reg_readb <= 1'b0;
                                    inst_valid <= `__instruction__valid__;
                                end
                                
                                `__movn__:begin
                                    alu_op <= `__movn__op__;
                                    alu_sel <= `__res__move__;
                                    reg_reada <= 1'b1;
                                    reg_readb <= 1'b1;
                                    inst_valid <= `__instruction__valid__;
                                    //regb��ֵ���ǵ�ַΪrt��ͨ�üĴ�����ֵ
                                    //���ݶ�ȡ��ַΪrt��ͨ�üĴ�����ֵ�Ƿ�Ϊ0���ж��Ƿ�Ҫд��Ŀ�ļĴ���
                                    if(regb != `zero)begin
                                        wreg <= `WriteEnable;
                                    end
                                    else begin
                                        wreg <= `WriteDisable;
                                    end
                                end

                                `__movz__:begin
                                    alu_op <= `__movz__op__;
                                    alu_sel <= `__res__move__;
                                    reg_reada <= 1'b1;
                                    reg_readb <= 1'b1;
                                    inst_valid <= `__instruction__valid__;
                                    //regb��ֵ���ǵ�ַΪrt��ͨ�üĴ�����ֵ
                                    //���ݶ�ȡ��ַΪrt��ͨ�üĴ�����ֵ�Ƿ�Ϊ0���ж��Ƿ�Ҫд��Ŀ�ļĴ���
                                    //�жϷ�����movn��ȫ�෴
                                    if(regb == `zero)begin
                                        wreg <= `WriteEnable;
                                    end
                                    else begin
                                        wreg <= `WriteDisable;
                                    end                                        
                                end

                                `__slt__:begin
                                    wreg <= `WriteEnable;
                                    alu_op <= `__slt__op__;
                                    alu_sel <= `__res__arithmetic__;
                                    reg_reada <= 1'b1;
                                    reg_readb <= 1'b1;
                                    inst_valid <= `__instruction__valid__; 
                                end

                                `__sltu__:begin
                                    wreg <= `WriteEnable;
                                    alu_op <= `__sltu__op__;
                                    alu_sel <= `__res__arithmetic__;
                                    reg_reada <= 1'b1;
                                    reg_readb <= 1'b1;
                                    inst_valid <= `__instruction__valid__;
                                end

                                `__add__:begin
                                    wreg <= `WriteEnable;
                                    alu_op <= `__add__op__;
                                    alu_sel <= `__res__arithmetic__;
                                    reg_reada <= 1'b1;
                                    reg_readb <= 1'b1;
                                    inst_valid <= `__instruction__valid__;
                                end

                                `__addu__:begin
                                    wreg <= `WriteEnable;
                                    alu_op <= `__addu__op__;
                                    alu_sel <= `__res__arithmetic__;
                                    reg_reada <= 1'b1;
                                    reg_readb <= 1'b1;
                                    inst_valid <= `__instruction__valid__;
                                end

                                `__sub__:begin
                                    wreg <= `WriteEnable;
                                    alu_op <= `__sub__op__;
                                    alu_sel <= `__res__arithmetic__;
                                    reg_reada <= 1'b1;
                                    reg_readb <= 1'b1;
                                    inst_valid <= `__instruction__valid__; 
                                end

                                `__subu__:begin
                                    wreg <= `WriteEnable;
                                    alu_op <= `__subu__op__;
                                    alu_sel <= `__res__arithmetic__;
                                    reg_reada <= 1'b1;
                                    reg_readb <= 1'b1;
                                    inst_valid <= `__instruction__valid__;
                                end

                                `__mult__:begin
                                    wreg <= `WriteDisable;
                                    alu_op <= `__mult__op__;
                                    reg_reada <= 1'b1;
                                    reg_readb <= 1'b1;
                                    inst_valid <= `__instruction__valid__;
                                end

                                `__multu__:begin
                                    wreg <= `WriteDisable;
                                    alu_op <= `__multu__op__;
                                    reg_reada <= 1'b1;
                                    reg_readb <= 1'b1;
                                    inst_valid <= `__instruction__valid__;
                                end
                                
                                `__div__:begin
                                    wreg <= `WriteDisable;
                                    alu_op <= `__div__op__;
                                    reg_reada <= 1'b1;
                                    reg_readb <= 1'b1;
                                    inst_valid <= `__instruction__valid__;
                                end

                                `__divu__:begin
                                    wreg <= `WriteDisable;
                                    alu_op <= `__divu__op__;
                                    reg_reada <= 1'b1;
                                    reg_readb <= 1'b1;
                                    inst_valid <= `__instruction__valid__;                                  
                                end

                                `__jr__:begin
                                    wreg <= `WriteDisable;
                                    alu_op <= `__jr__op__;
                                    alu_sel <= `__res__jump__branch__;
                                    reg_reada <= 1'b1;
                                    reg_readb <= 1'b0;
                                    link_addr <= `zero;
                                    branch_address <= rega - 32'h00400000;
                                    branch_flag <= `__branch__;
                                    next_inst_in_delay_slot <= `InDelaySlot;
                                    inst_valid <= `__instruction__valid__;
                                end

                                `__jalr__:begin
                                    wreg <= `WriteEnable;
                                    alu_op <= `__jalr__op__;
                                    alu_sel <= `__res__jump__branch__;
                                    reg_reada <= 1'b1;
                                    reg_readb <= 1'b0;
                                    wd <= inst[15:11];
                                    link_addr <= pc_plus_4 + 32'h00400000;
                                    branch_address <= rega - 32'h00400000;
                                    branch_flag <= `__branch__;
                                    next_inst_in_delay_slot <= `InDelaySlot;
                                    inst_valid <= `__instruction__valid__;
                                end

                                
                                default:begin
                                end
                            endcase
                        end


                        default:begin
                        end
                    endcase

                    case(op3)
                        `__teq__:begin
                            wreg <= `WriteDisable;
                            alu_op <= `__teq__op__;
                            alu_sel <= `__res__nop__;
                            reg_reada <= 1'b0;
                            reg_readb <= 1'b0;
                            inst_valid <= `__instruction__valid__;
                        end
                        
                        `__break__:begin
                            wreg <= `WriteDisable;
                            alu_op <= `__break__op__;
                            alu_sel <= `__res__nop__;
                            reg_reada <= 1'b0;
                            reg_readb <= 1'b0;
                            inst_valid <= `__instruction__valid__;   
                            excepttype_is_break <= `true;                     
                        end

                        `__tge__:begin
                            wreg <= `WriteDisable;
                            alu_op <= `__tge__op__;
                            alu_sel <= `__res__nop__;
                            reg_reada <= 1'b1;
                            reg_readb <= 1'b1;
                            inst_valid <= `__instruction__valid__;
                        end

                        `__tgeu__:begin
                            wreg <= `WriteDisable;
                            alu_op <= `__tgeu__op__;
                            alu_sel <= `__res__nop__;
                            reg_reada <= 1'b1;
                            reg_readb <= 1'b1;
                            inst_valid <= `__instruction__valid__;                          
                        end

                        `__tlt__:begin
                            wreg <= `WriteDisable;
                            alu_op <= `__tlt__op__;
                            alu_sel <= `__res__nop__;
                            reg_reada <= 1'b1;
                            reg_readb <= 1'b1;
                            inst_valid <= `__instruction__valid__;                              
                        end

                        `__tltu__:begin
                            wreg <= `WriteDisable;
                            alu_op <= `__tltu__op__;
                            alu_sel <= `__res__nop__;
                            reg_reada <= 1'b1;
                            reg_readb <= 1'b1;
                            inst_valid <= `__instruction__valid__;                              
                        end

                        `__tne__:begin
                            wreg <= `WriteDisable;
                            alu_op <= `__tne__op__;
                            alu_sel <= `__res__nop__;
                            reg_reada <= 1'b1;
                            reg_readb <= 1'b1;
                            inst_valid <= `__instruction__valid__;                              
                        end

                        `__syscall__:begin
                            wreg <= `WriteDisable;
                            alu_op <= `__syscall__op__;
                            alu_sel <= `__res__nop__;
                            reg_reada <= 1'b0;
                            reg_readb <= 1'b0;
                            inst_valid <= `__instruction__valid__; 
                            excepttype_is_syscall <= `true;                             
                        end

                        default:begin
                        end
                    endcase
                end

                `__ori__:begin
                    wreg <= `WriteEnable;
                    alu_op <= `__or__op__;
                    alu_sel <= `__res__logic__;
                    reg_reada <= 1'b1;
                    reg_readb <= 1'b0;
                    imm <= {16'h0,inst[15:0]};
                    wd <= inst[20:16];
                    inst_valid <= `__instruction__valid__;
                end

                `__andi__: begin
                    wreg <= `WriteEnable;
                    alu_op <= `__and__op__;
                    alu_sel <= `__res__logic__;
                    reg_reada <= 1'b1;
                    reg_readb <= 1'b0;
                    imm <= {16'h0,inst[15:0]};
                    wd <= inst[20:16];
                    inst_valid <= `__instruction__valid__;
                end

                `__xori__: begin
                    wreg <= `WriteEnable;
                    alu_op <= `__xor__op__;
                    alu_sel <= `__res__logic__;
                    reg_reada <= 1'b1;
                    reg_readb <= 1'b0;
                    imm <= {16'h0,inst[15:0]};
                    wd <= inst[20:16];
                    inst_valid <= `__instruction__valid__; 
                end

                `__lui__: begin
                    wreg <= `WriteEnable;
                    alu_op <= `__or__op__;
                    alu_sel <= `__res__logic__;
                    reg_reada <= 1'b1;
                    reg_readb <= 1'b0;
                    imm <= {inst[15:0],16'h0};
                    wd <= inst[20:16];
                    inst_valid <= `__instruction__valid__;
                end

                `__pref__: begin
                    wreg <= `WriteDisable;
                    alu_op <= `__nop__op__;
                    alu_sel <= `__res__nop__;
                    reg_reada <= 1'b0;
                    reg_readb <= 1'b0;
                    inst_valid <= `__instruction__valid__;
                end

                `__slti__:begin
                    wreg <= `WriteEnable;
                    alu_op <= `__slt__op__;
                    alu_sel <= `__res__arithmetic__;
                    reg_reada <= 1'b1;
                    reg_readb <= 1'b0;
                    imm <= {{16{inst[15]}},inst[15:0]};
                    wd <= inst[20:16];
                    inst_valid <= `__instruction__valid__;
                end

                `__sltiu__:begin
                    wreg <= `WriteEnable;
                    alu_op <= `__sltu__op__;
                    alu_sel <= `__res__arithmetic__;
                    reg_reada <= 1'b1;
                    reg_readb <= 1'b0;
                    imm <= {{16{inst[15]}},inst[15:0]};
                    wd <= inst[20:16];
                    inst_valid <= `__instruction__valid__;
                end

                `__addi__:begin
                    wreg <= `WriteEnable;
                    alu_op <= `__addi__op__;
                    alu_sel <= `__res__arithmetic__;
                    reg_reada <= 1'b1;
                    reg_readb <= 1'b0;
                    imm <= {{16{inst[15]}},inst[15:0]};
                    wd <= inst[20:16];
                    inst_valid <= `__instruction__valid__;                            
                end

                `__addiu__:begin
                    wreg <= `WriteEnable;
                    alu_op <= `__addiu__op__;
                    alu_sel <= `__res__arithmetic__;
                    reg_reada <= 1'b1;
                    reg_readb <= 1'b0;
                    imm <= {{16{inst[15]}},inst[15:0]};
                    wd <= inst[20:16];
                    inst_valid <= `__instruction__valid__;                                 
                end

                `__j__:begin
                    wreg <= `WriteDisable;
                    alu_op <= `__j__op__;
                    alu_sel <= `__res__jump__branch__;
                    reg_reada <= 1'b0;
                    reg_readb <= 1'b0;
                    wd <= inst[15:11];
                    link_addr <= `zero;
                    branch_flag <= `__branch__;
                    next_inst_in_delay_slot <= `InDelaySlot;
                    inst_valid <= `__instruction__valid__;
                    branch_address <= {pc_plus_4[31:28],inst[25:0],2'b00} - 32'h00400000; //ƴ�յ�ת��ַ                 
                end

                `__jal__:begin
                    wreg <= `WriteEnable;
                    alu_op <= `__jal__op__;
                    alu_sel <= `__res__jump__branch__;
                    reg_reada <= 1'b0;
                    reg_readb <= 1'b0;
                    wd <= 5'b11111;
                    link_addr <= pc_plus_4 + 32'h00400000;
                    branch_flag <= `__branch__;
                    next_inst_in_delay_slot <= `InDelaySlot;
                    inst_valid <= `__instruction__valid__;
                    branch_address <= {pc_plus_4[31:28],inst[25:0],2'b00} - 32'h00400000; //ƴ�յ�ת��ַ                     
                end

                `__beq__:begin
                    wreg <= `WriteDisable;
                    alu_op <= `__beq__op__;
                    alu_sel <= `__res__jump__branch__;
                    reg_reada <= 1'b1;
                    reg_readb <= 1'b1;
                    inst_valid <= `__instruction__valid__;
                    if(rega == regb)begin
                        branch_flag <= `__branch__;
                        next_inst_in_delay_slot <= `InDelaySlot;
                        branch_address <= pc_plus_4 + imm_ext; //ƴ�յ�ת��ַ    
                    end                 
                end

                `__bgtz__:begin
                    wreg <= `WriteDisable;
                    alu_op <= `__bgtz__op__;
                    alu_sel <= `__res__jump__branch__;
                    reg_reada <= 1'b1;
                    reg_readb <= 1'b0;
                    inst_valid <= `__instruction__valid__;
                    if(rega[31] == 1'b0 && rega !=`zero)begin
                        branch_flag <= `__branch__;
                        next_inst_in_delay_slot <= `InDelaySlot;
                        branch_address <= pc_plus_4 + imm_ext; //ƴ�յ�ת��ַ    
                    end                 
                end

                `__blez__:begin
                    wreg <= `WriteDisable;
                    alu_op <= `__blez__op__;
                    alu_sel <= `__res__jump__branch__;
                    reg_reada <= 1'b1;
                    reg_readb <= 1'b0;
                    inst_valid <= `__instruction__valid__;
                    if(rega[31] == 1'b0 && rega ==`zero)begin
                        branch_flag <= `__branch__;
                        next_inst_in_delay_slot <= `InDelaySlot;
                        branch_address <= pc_plus_4 + imm_ext; //ƴ�յ�ת��ַ    
                    end                 
                end

                `__bne__:begin
                    wreg <= `WriteDisable;
                    alu_op <= `__blez__op__;
                    alu_sel <= `__res__jump__branch__;
                    reg_reada <= 1'b1;
                    reg_readb <= 1'b1;
                    inst_valid <= `__instruction__valid__;
                    if(rega != regb)begin
                        branch_flag <= `__branch__;
                        next_inst_in_delay_slot <= `InDelaySlot;
                        branch_address <= pc_plus_4 + imm_ext; //ƴ�յ�ת��ַ    
                    end                 
                end

                `__lb__:begin
                    wreg <= `WriteEnable;
                    alu_op <= `__lb__op__;
                    alu_sel <= `__res__load__store__;
                    reg_reada <= 1'b1;
                    reg_readb <= 1'b0;
                    wd <= inst[20:16];
                    inst_valid <= `__instruction__valid__;
                end
                
                `__lbu__:begin
                    wreg <= `WriteEnable;
                    alu_op <= `__lbu__op__;
                    alu_sel <= `__res__load__store__;
                    reg_reada <= 1'b1;
                    reg_readb <= 1'b0;
                    wd <= inst[20:16];
                    inst_valid <= `__instruction__valid__;
                end

                `__lh__:begin
                    wreg <= `WriteEnable;
                    alu_op <= `__lh__op__;
                    alu_sel <= `__res__load__store__;
                    reg_reada <= 1'b1;
                    reg_readb <= 1'b0;
                    wd <= inst[20:16];
                    inst_valid <= `__instruction__valid__;
                end

                `__lhu__:begin
                    wreg <= `WriteEnable;
                    alu_op <= `__lhu__op__;
                    alu_sel <= `__res__load__store__;
                    reg_reada <= 1'b1;
                    reg_readb <= 1'b0;
                    wd <= inst[20:16];
                    inst_valid <= `__instruction__valid__;
                end

                `__lw__:begin
                    wreg <= `WriteEnable;
                    alu_op <= `__lw__op__;
                    alu_sel <= `__res__load__store__;
                    reg_reada <= 1'b1;
                    reg_readb <= 1'b0;
                    wd <= inst[20:16];
                    inst_valid <= `__instruction__valid__;
                end

                `__lwl__:begin
                    wreg <= `WriteEnable;
                    alu_op <= `__lwl__op__;
                    alu_sel <= `__res__load__store__;
                    reg_reada <= 1'b1;
                    reg_readb <= 1'b1;
                    wd <= inst[20:16];
                    inst_valid <= `__instruction__valid__;
                end                

                `__lwr__:begin
                    wreg <= `WriteEnable;
                    alu_op <= `__lwr__op__;
                    alu_sel <= `__res__load__store__;
                    reg_reada <= 1'b1;
                    reg_readb <= 1'b1;
                    wd <= inst[20:16];
                    inst_valid <= `__instruction__valid__;
                end

                `__sb__:begin
                    wreg <= `WriteDisable; //��д�Ĵ���
                    alu_op <= `__sb__op__;
                    alu_sel <= `__res__load__store__;
                    reg_reada <= 1'b1;
                    reg_readb <= 1'b1;
                    inst_valid <= `__instruction__valid__;
                end
                
                `__sh__:begin
                    wreg <= `WriteDisable; //��д�Ĵ���
                    alu_op <= `__sh__op__;
                    alu_sel <= `__res__load__store__;
                    reg_reada <= 1'b1;
                    reg_readb <= 1'b1;
                    inst_valid <= `__instruction__valid__;
                end

                `__sw__:begin
                    wreg <= `WriteDisable; //��д�Ĵ���
                    alu_op <= `__sw__op__;
                    alu_sel <= `__res__load__store__;
                    reg_reada <= 1'b1;
                    reg_readb <= 1'b1;
                    inst_valid <= `__instruction__valid__;
                end

                `__swl__:begin
                    wreg <= `WriteDisable; //��д�Ĵ���
                    alu_op <= `__swl__op__;
                    alu_sel <= `__res__load__store__;
                    reg_reada <= 1'b1;
                    reg_readb <= 1'b1;
                    inst_valid <= `__instruction__valid__;
                end

                `__swr__:begin
                    wreg <= `WriteDisable; //��д�Ĵ���
                    alu_op <= `__swr__op__;
                    alu_sel <= `__res__load__store__;
                    reg_reada <= 1'b1;
                    reg_readb <= 1'b1;
                    inst_valid <= `__instruction__valid__;
                end

                `__regimm__inst__:begin
                    case(op4)
                        `__bgez__:begin
                            wreg <= `WriteDisable;
                            alu_op <= `__bgez__op__;
                            alu_sel <= `__res__jump__branch__;
                            reg_reada <= 1'b1;
                            reg_readb <= 1'b0;
                            inst_valid <= `__instruction__valid__;
                            if(rega[31] == 1'b0)begin
                                branch_flag <= `__branch__;
                                next_inst_in_delay_slot <= `InDelaySlot;
                                branch_address <= pc_plus_4 + imm_ext; //ƴ�յ�ת��ַ    
                            end                              
                        end

                        `__bgezal__:begin
                            wreg <= `WriteEnable;
                            alu_op <= `__bgezal__op__;
                            alu_sel <= `__res__jump__branch__;
                            reg_reada <= 1'b1;
                            reg_readb <= 1'b0;
                            link_addr <= pc_plus_4;
                            wd <= 5'b11111;
                            inst_valid <= `__instruction__valid__;
                            if(rega[31] == 1'b0)begin
                                branch_flag <= `__branch__;
                                next_inst_in_delay_slot <= `InDelaySlot;
                                branch_address <= pc_plus_4 + imm_ext; //ƴ�յ�ת��ַ    
                            end                              
                        end

                        `__bltz__:begin
                            wreg <= `WriteDisable;
                            alu_op <= `__bgezal__op__;
                            alu_sel <= `__res__jump__branch__;
                            reg_reada <= 1'b1;
                            reg_readb <= 1'b0;
                            inst_valid <= `__instruction__valid__;
                            if(rega[31] == 1'b1)begin
                                branch_flag <= `__branch__;
                                next_inst_in_delay_slot <= `InDelaySlot;
                                branch_address <= pc_plus_4 + imm_ext; //ƴ�յ�ת��ַ    
                            end                              
                        end

                        `__bltzal__:begin
                            wreg <= `WriteEnable;
                            alu_op <= `__bgezal__op__;
                            alu_sel <= `__res__jump__branch__;
                            reg_reada <= 1'b1;
                            reg_readb <= 1'b0;
                            link_addr <= pc_plus_4;
                            wd <= 5'b11111;
                            inst_valid <= `__instruction__valid__;
                            if(rega[31] == 1'b1)begin
                                branch_flag <= `__branch__;
                                next_inst_in_delay_slot <= `InDelaySlot;
                                branch_address <= pc_plus_4 + imm_ext; //ƴ�յ�ת��ַ    
                            end                              
                        end
                        
                        `__teqi__:begin
                            wreg <= `WriteDisable;
                            alu_op <= `__teqi__op__;
                            alu_sel <= `__res__nop__;
                            reg_reada <= 1'b1;
                            reg_readb <= 1'b0;
                            imm <= {{16{inst[15]}},inst[15:0]};
                            inst_valid <= `__instruction__valid__;
                        end

                        `__tgei__:begin
                            wreg <= `WriteDisable;
                            alu_op <= `__tgei__op__;
                            alu_sel <= `__res__nop__;
                            reg_reada <= 1'b1;
                            reg_readb <= 1'b0;
                            imm <= {{16{inst[15]}},inst[15:0]};
                            inst_valid <= `__instruction__valid__;
                        end

                        `__tgeiu__:begin
                            wreg <= `WriteDisable;
                            alu_op <= `__tgeiu__op__;
                            alu_sel <= `__res__nop__;
                            reg_reada <= 1'b1;
                            reg_readb <= 1'b0;
                            imm <= {{16{inst[15]}},inst[15:0]};
                            inst_valid <= `__instruction__valid__;
                        end

                        `__tlti__:begin
                            wreg <= `WriteDisable;
                            alu_op <= `__tlti__op__;
                            alu_sel <= `__res__nop__;
                            reg_reada <= 1'b1;
                            reg_readb <= 1'b0;
                            imm <= {{16{inst[15]}},inst[15:0]};
                            inst_valid <= `__instruction__valid__;
                        end

                        `__tltiu__:begin
                            wreg <= `WriteDisable;
                            alu_op <= `__tltiu__op__;
                            alu_sel <= `__res__nop__;
                            reg_reada <= 1'b1;
                            reg_readb <= 1'b0;
                            imm <= {{16{inst[15]}},inst[15:0]};
                            inst_valid <= `__instruction__valid__;
                        end

                        `__tnei__:begin
                            wreg <= `WriteDisable;
                            alu_op <= `__tnei__op__;
                            alu_sel <= `__res__nop__;
                            reg_reada <= 1'b1;
                            reg_readb <= 1'b0;
                            imm <= {{16{inst[15]}},inst[15:0]};
                            inst_valid <= `__instruction__valid__;
                        end

                        default:begin
                        end
                    endcase
                end

                `__special2__inst__:begin
                    case(op3)
                        `__clz__:begin
                            wreg <= `WriteEnable;
                            alu_op <= `__clz__op__;
                            alu_sel <= `__res__arithmetic__;
                            reg_reada <= 1'b1;
                            reg_readb <= 1'b0;
                            inst_valid <= `__instruction__valid__;
                        end

                        `__clo__:begin
                            wreg <= `WriteEnable;
                            alu_op <= `__clo__op__;
                            alu_sel <= `__res__arithmetic__;
                            reg_reada <= 1'b1;
                            reg_readb <= 1'b0;
                            inst_valid <= `__instruction__valid__;
                        end
                        
                        `__mul__:begin
                            wreg <= `WriteEnable;
                            alu_op <= `__mul__op__;
                            alu_sel <= `__res__mul__;
                            reg_reada <= 1'b1;
                            reg_readb <= 1'b1;
                            inst_valid <= `__instruction__valid__;                            
                        end

                        `__madd__:begin
                            wreg <= `WriteDisable;
                            alu_op <= `__madd__op__;
                            alu_sel <= `__res__mul__;
                            reg_reada <= 1'b1;
                            reg_readb <= 1'b1;
                            inst_valid <= `__instruction__valid__;                              
                        end

                        `__maddu__:begin
                            wreg <= `WriteDisable;
                            alu_op <= `__maddu__op__;
                            alu_sel <= `__res__mul__;
                            reg_reada <= 1'b1;
                            reg_readb <= 1'b1;
                            inst_valid <= `__instruction__valid__;                              
                        end

                        `__msub__:begin
                            wreg <= `WriteDisable;
                            alu_op <= `__msub__op__;
                            alu_sel <= `__res__mul__;
                            reg_reada <= 1'b1;
                            reg_readb <= 1'b1;
                            inst_valid <= `__instruction__valid__;                              
                        end

                        `__msubu__:begin
                            wreg <= `WriteDisable;
                            alu_op <= `__msubu__op__;
                            alu_sel <= `__res__mul__;
                            reg_reada <= 1'b1;
                            reg_readb <= 1'b1;
                            inst_valid <= `__instruction__valid__;                              
                        end

                        default:begin
                        end
                    endcase    
                end

                default:begin
                end
            endcase

            if(inst[31:21] == 11'b00000000000)begin
                if(op3 == `__sll__)begin
                    wreg <= `WriteEnable;
                    alu_op <= `__sll__op__;
                    alu_sel <= `__res__shift__;
                    reg_reada <= 1'b0;
                    reg_readb <= 1'b1;
                    imm[4:0] <= inst[10:6];
                    wd <= inst[15:11];
                    inst_valid <= `__instruction__valid__;
                end
                else if(op3 == `__srl__)begin
                    wreg <= `WriteEnable;
                    alu_op <= `__srl__op__;
                    alu_sel <= `__res__shift__;
                    reg_reada <= 1'b0;
                    reg_readb <= 1'b1;
                    imm[4:0] <= inst[10:6];
                    wd <= inst[15:11];
                    inst_valid <= `__instruction__valid__;
                end
                else if(op3 == `__sra__)begin
                    wreg <= `WriteEnable;
                    alu_op <= `__sra__op__;
                    alu_sel <= `__res__shift__;
                    reg_reada <= 1'b0;
                    reg_readb <= 1'b1;
                    imm[4:0] <= inst[10:6];
                    wd <= inst[15:11];
                    inst_valid <= `__instruction__valid__;
                end
            end           

            if(inst[31:21] == 11'b01000000000 && inst[10:0] == 11'b00000000000)begin
                alu_op <= `__mfc0__op__;
                alu_sel <= `__res__move__;
                wd <= inst [20:16];
                wreg <= `WriteEnable;
                inst_valid <= `__instruction__valid__;
                reg_reada <= 1'b0;
                reg_readb <= 1'b0;
            end
            else if(inst[31:21] == 11'b01000000100 && inst[10:0] == 11'b00000000000)begin
                alu_op <= `__mtc0__op__;
                alu_sel <= `__res__nop__;
                wreg <= `WriteDisable;
                inst_valid <= `__instruction__valid__;
                reg_reada <= 1'b1;
                reg_readb <= 1'b0;       
                reg_addra <= inst[20:16];     
            end

            if(inst == `__eret__)begin
                alu_op <= `__eret__op__;
                alu_sel <= `__res__nop__;
                wreg <= `WriteDisable;
                inst_valid <= `__instruction__valid__;
                reg_reada <= 1'b0;
                reg_readb <= 1'b0;       
                excepttype_is_eret <= `true;                   
            end
        end
    end
    
    /*****************ȷ�����������Դ������1******************/
    always@ (*) begin
        if(rst == `RstEnable)begin
            rega <= `zero;
        end
        else if(reg_reada == 1'b1 && ex_wreg == 1'b1 && ex_wd == reg_addra)begin
            if(ex_wd == `NOP)
                rega <= `zero;
            else
                rega <= ex_wdata;
        end
        else if(reg_reada == 1'b1 && mem_wreg == 1'b1 && mem_wd == reg_addra)begin
            if(mem_wd == `NOP)
                rega <= `zero;
            else
                rega <= mem_wdata;
        end
        else if(reg_reada == 1'b1)begin
            rega <=  reg_dataa;
        end
        else if(reg_reada == 1'b0)begin
            rega <= imm; //������
        end
        else begin
            rega <= `zero;
        end
    end
    
    /*****************ȷ�����������Դ������2******************/ 
    always@ (*) begin
        if(rst == `RstEnable)begin
            regb <= `zero;
        end
        else if(reg_readb == 1'b1 && ex_wreg == 1'b1 && ex_wd == reg_addrb)begin
            if(ex_wd ==  `NOP)
                regb <= `zero;
            else
                regb <= ex_wdata;
        end
        else if(reg_readb == 1'b1 && mem_wreg == 1'b1 && mem_wd == reg_addrb)begin
            if(mem_wd == `NOP)
                regb <= `zero;
            else
                regb <= mem_wdata;
        end
        else if(reg_readb == 1'b1)begin
            regb <=  reg_datab;
        end
        else if(reg_readb == 1'b0)begin
            regb <= imm; //������
        end
        else begin
            regb <= `zero;
        end
    end

    //����һ��ָ���Ǽ���ָ��Ҹü���ָ��Ҫ���ص���Ŀ�ļĴ��� ���ǵ�ǰָ��Ҫͨ��regfile
    //���˿�1��ȡ��ͨ�üĴ����������load���
    always @(*) begin
        stall_req_for_rega_load <= `UNSTOP;
        if(rst == `RstEnable)begin
            //rega <= `zero;
        end
        else if(pre_inst_is_load == 1'b1 && ex_wd == reg_addra && reg_reada == 1'b1)
            stall_req_for_rega_load <= `STOP;
    end

    //���˿�2ͬ��
    always @(*) begin
        stall_req_for_regb_load <= `UNSTOP;
        if(rst == `RstEnable)begin
            //regb <= `zero;
        end
        else if(pre_inst_is_load == 1'b1 && ex_wd == reg_addrb && reg_readb == 1'b1)
            stall_req_for_regb_load <= `STOP;
    end

    always @(*) begin
        if(rst == `ReadEnable)
            o_is_in_dalay_slot <= `NotInDelaySlot;
        else    
            o_is_in_dalay_slot <= is_in_dalay_slot;
    end

endmodule
