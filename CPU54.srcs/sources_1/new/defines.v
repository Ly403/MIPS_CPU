`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/18 14:53:01
// Design Name: 
// Module Name: defines
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
/*****************相关宏定义***********************/
`ifndef DEFINE_V
`define DEFINE_V
/* 复位信号 */
`define RstEnable 1'b1
`define RstDisable 1'b0

/* 机器0 */
`define zero 32'h00000000

/* 写使能 */
`define WriteEnable 1'b1
`define WriteDisable 1'b0

/* 读使能 */
`define ReadEnable 1'b1
`define ReadDisable 1'b0

/* 译码后ALU的信号位宽 */
`define ALUOP 7:0
`define ALUSEL 2:0

/* 指令是否有效 */
`define __instruction__valid__ 1'b0
`define __instruction__invalid__ 1'b1

/* C风格的bool型常量 */
`define true 1'b1
`define false 1'b0

/* 芯片控制信号 */
`define __chip__enable__ 1'b1
`define __chip__disable__ 1'b0

/* 与具体指令相关的宏定义 */
//指令功能码
`define __nop__   6'b000000
`define __and__   6'b100100
`define __or__    6'b100101
`define __xor__   6'b100110
`define __nor__   6'b100111
`define __andi__  6'b001100
`define __ori__   6'b001101
`define __xori__  6'b001110
`define __lui__   6'b001111 

`define __sll__   6'b000000
`define __sllv__  6'b000100
`define __srl__   6'b000010
`define __srlv__  6'b000110
`define __sra__   6'b000011
`define __srav__  6'b000111

`define __sync__  6'b001111
`define __pref__  6'b110011
`define __ssnop__ 32'b00000000000000000000000001000000

`define __movz__  6'b001010
`define __movn__  6'b001011
`define __mfhi__  6'b010000
`define __mthi__  6'b010001
`define __mflo__  6'b010010
`define __mtlo__  6'b010011

`define __slt__   6'b101010
`define __sltu__  6'b101011
`define __slti__  6'b001010
`define __sltiu__ 6'b001011
`define __add__   6'b100000
`define __addu__  6'b100001
`define __sub__   6'b100010
`define __subu__  6'b100011
`define __addi__  6'b001000
`define __addiu__ 6'b001001
`define __clz__   6'b100000
`define __clo__   6'b100001
`define __mult__  6'b011000
`define __multu__ 6'b011001
`define __mul__   6'b000010

`define __madd__  6'b000000
`define __maddu__ 6'b000001
`define __msub__  6'b000100
`define __msubu__ 6'b000101

`define __div__  6'b011010
`define __divu__  6'b011011

`define __j__  6'b000010
`define __jal__  6'b000011
`define __jalr__  6'b001001
`define __jr__  6'b001000
`define __beq__  6'b000100
`define __bgez__  5'b00001
`define __bgezal__  5'b10001
`define __bgtz__  6'b000111
`define __blez__  6'b000110
`define __bltz__  5'b00000
`define __bltzal__  5'b10000
`define __bne__  6'b000101

`define __lb__  6'b100000
`define __lbu__  6'b100100
`define __lh__  6'b100001
`define __lhu__  6'b100101
`define __ll__  6'b110000
`define __lw__  6'b100011
`define __lwl__  6'b100010
`define __lwr__  6'b100110
`define __sb__  6'b101000
`define __sc__  6'b111000
`define __sh__  6'b101001
`define __sw__  6'b101011
`define __swl__  6'b101010
`define __swr__  6'b101110

`define __syscall__ 6'b001100

`define __teq__ 6'b110100
`define __break__ 6'b001101
`define __teqi__ 5'b01100
`define __tge__ 6'b110000
`define __tgei__ 5'b01000
`define __tgeiu__ 5'b01001
`define __tgeu__ 6'b110001
`define __tlt__ 6'b110010
`define __tlti__ 5'b01010
`define __tltiu__ 5'b01011
`define __tltu__ 6'b110011
`define __tne__ 6'b110110
`define __tnei__ 5'b01110
   
`define __eret__ 32'b01000010000000000000000000011000

`define __special__inst__  6'b000000
`define __regimm__inst__   6'b000001
`define __special2__inst__ 6'b011100

/////////////////////////////ALUOP/////////////////////////////////////
`define __and__op__   8'b00100100
`define __or__op__    8'b00100101
`define __xor__op__  8'b00100110
`define __nor__op__  8'b00100111
`define __andi__op__  8'b01011001
`define __ori__op__  8'b01011010
`define __xori__op__  8'b01011011
`define __lui__op__  8'b01011100   

`define __sll__op__  8'b01111100
`define __sllv__op__  8'b00000100
`define __srl__op__  8'b00000010
`define __srlv__op__  8'b00000110
`define __sra__op__  8'b00000011
`define __srav__op__  8'b00000111

`define __nop__op__    8'b00000000

`define __movz__op__  8'b00001010
`define __movn__op__  8'b00001011
`define __mfhi__op__  8'b00010000
`define __mthi__op__  8'b00010001
`define __mflo__op__  8'b00010010
`define __mtlo__op__  8'b00010011

`define __slt__op__  8'b00101010
`define __sltu__op__  8'b00101011
`define __slti__op__  8'b01010111
`define __sltiu__op__  8'b01011000   
`define __add__op__  8'b00100000
`define __addu__op__  8'b00100001
`define __sub__op__  8'b00100010
`define __subu__op__  8'b00100011
`define __addi__op__  8'b01010101
`define __addiu__op__  8'b01010110
`define __clz__op__  8'b10110000
`define __clo__op__  8'b10110001

`define __mult__op__  8'b00011000
`define __multu__op__  8'b00011001
`define __mul__op__  8'b10101001

//乘累加、乘累减
`define __madd__op__  8'b10100110
`define __maddu__op__  8'b10101000
`define __msub__op__  8'b10101010
`define __msubu__op__  8'b10101011

`define __div__op__  8'b00011010
`define __divu__op__  8'b00011011

`define __j__op__  8'b01001111
`define __jal__op__  8'b01010000
`define __jalr__op__  8'b00001001
`define __jr__op__  8'b00001000
`define __beq__op__  8'b01010001
`define __bgez__op__  8'b01000001
`define __bgezal__op__  8'b01001011
`define __bgtz__op__  8'b01010100
`define __blez__op__  8'b01010011
`define __bltz__op__  8'b01000000
`define __bltzal__op__  8'b01001010
`define __bne__op__  8'b01010010

//存储命令
`define __lb__op__  8'b11100000
`define __lbu__op__  8'b11100100
`define __lh__op__  8'b11100001
`define __lhu__op__  8'b11100101
`define __ll__op__  8'b11110000
`define __lw__op__  8'b11100011
`define __lwl__op__  8'b11100010
`define __lwr__op__  8'b11100110
`define __pref__op__  8'b11110011
`define __sb__op__  8'b11101000
`define __sc__op__  8'b11111000
`define __sh__op__  8'b11101001
`define __sw__op__  8'b11101011
`define __swl__op__  8'b11101010
`define __swr__op__  8'b11101110
`define __sync__op__  8'b00001111

//////////////////////////////ALUSEL/////////////////////////////////
`define __res__logic__ 3'b001
`define __res__shift__ 3'b010
`define __res__move__ 3'b011
`define __res__arithmetic__ 3'b100	
`define __res__mul__ 3'b101
`define __res__jump__branch__ 3'b110
`define __res__load__store__ 3'b111	

`define __mfc0__op__ 8'b01011101
`define __mtc0__op__ 8'b01100000


`define __syscall__op__ 8'b00001100

`define __teq__op__ 8'b00110100
`define __break__op__ 8'b00001101
`define __teqi__op__ 8'b01001000
`define __tge__op__ 8'b00110000
`define __tgei__op__ 8'b01000100
`define __tgeiu__op__ 8'b01000101
`define __tgeu__op__ 8'b00110001
`define __tlt__op__ 8'b00110010
`define __tlti__op__ 8'b01000110
`define __tltiu__op__ 8'b01000111
`define __tltu__op__ 8'b00110011
`define __tne__op__ 8'b00110110
`define __tnei__op__ 8'b01001001
   
`define __eret__op__ 8'b01101011

`define __res__nop__ 3'b000

/*********指令存储ROM相关宏定义**********/
/* 总线位宽 */
`define __inst__address__bus__  31:0
`define __inst__data__bus__  31:0

/* ROM大小 */
`define __inst__memory__num__ 65535 //128KB
`define __inst__memory__width__ 16 //位宽17

/**************寄存器堆Regfile相关定义*************/
/* 地址线、数据线位宽 */
`define __regfile__address__bus__ 4:0
`define __regfile__data__bus__ 31:0

/* 通用寄存器位宽 */
`define __regfile__width__ 32
`define __regfile__twice__width__ 64
`define __regfile__twice__data__bus__ 63:0

/* 通用寄存器堆基本信息 */
`define __regfile__number__ 32 // 32 个通用寄存器
`define __regfile__number__width__ 5
`define NOP 5'b00000

/* 暂停信息 */
`define STOP 1'b1
`define UNSTOP 1'b0  

/* 除法 */
`define DivFree 2'b00
`define DivByZero 2'b01
`define DivOn 2'b10
`define DivEnd 2'b11
`define DivResultReady 1'b1
`define DivResultNotReady 1'b0
`define DivStart 1'b1
`define DivStop 1'b0

/* 跳跃 */
`define __branch__ 1'b1
`define __not__branch__ 1'b0

`define InDelaySlot 1'b1
`define NotInDelaySlot 1'b0

/*********data memory相关数据***********/
`define __data__address__ 31:0
`define __data__bus__    31:0
`define __data__memnum__ 32767  
`define __data__memnum__width__ 15
`define byte_width 7:0    

/*    CP0中个寄存器的地址     */
`define __reg__count__  5'b01001
`define __reg__compare__ 5'b01011
`define __reg__status__  5'b01100
`define __reg__cause__   5'b01101
`define __reg__epc__  5'b01110
`define __reg__prid__ 5'b01111
`define __reg__config__ 5'b10000
`define __reg__badvaddr__ 5'b01000

`define InterruptAssert 1'b1
`define InterruptNotAssert 1'b0
`define TrapAssert 1'b1
`define TrapNotAssert 1'b0
`define BreakAssert 1'b1
`define BreakNotAssert 1'b0
`endif
