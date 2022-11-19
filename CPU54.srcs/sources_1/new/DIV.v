`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/29 19:13:18
// Design Name: 
// Module Name: DIV
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
//除法模块
module DIV(
    input clk,
    input rst,
    input signed_div,
    input [31:0]opdata1,
    input [31:0]opdata2,
    input start,
    input annul,
    output reg[63:0] result,
    output reg ready
    );

    wire [32:0] div_temp;
    reg [5:0] cnt; //记录除了几轮，等于32就结束了
    reg [64:0] dividend; 
    reg [1:0] state;
    reg [31:0] divisor;
    reg [31:0] op1;
    reg [31:0] op2;

    assign div_temp = {1'b0,dividend[63:32]} - {1'b0,divisor};

    always @(posedge clk) begin
        if(rst == `RstEnable)begin
            state <= `DivFree;
            ready <= `DivResultNotReady;
            result <= {`zero,`zero};
        end
        else begin
            case(state)
                `DivFree:begin
                    if(start == `DivStart && annul == 1'b0)begin
                        if(opdata2 == `zero)
                            state <= `DivByZero;
                        else begin
                            state <= `DivOn;
                            cnt <= 6'b000000;
                            
                            if(signed_div == 1'b1 && opdata1[31] == 1'b1)
                                op1 = ~opdata1 + 1;//负数取补码
                            else
                                op1 = opdata1;
                            
                            if(signed_div == 1'b1 && opdata2[31] == 1'b1)
                                op2 = ~opdata2 + 1;
                            else
                                op2 = opdata2;
                            
                            dividend <= {`zero,`zero};
                            dividend[32:1] <= op1;
                            divisor <= op2;
                        end
                    end else begin
                        ready <= `DivResultNotReady;
                        result <= {`zero,`zero};
                    end
                end

                `DivByZero:begin
                    dividend <= {`zero,`zero};
                    state <= `DivEnd;
                end

                `DivOn:begin
                    if(annul == 1'b0)begin
                        if(cnt != 6'b100000)begin
                            if(div_temp[32] == 1'b1)begin
                                dividend <= {dividend[63:0],1'b0};//左移
                            end
                            else begin
                                dividend <= {div_temp[31:0],dividend[31:0],1'b1};
                            end
                            cnt <= cnt + 1;
                        end
                        else begin
                            if(signed_div == 1'b1 && (1'b1 == opdata1[31] ^ opdata2[31]))begin
                                dividend[31:0] <= ~dividend[31:0] + 1;
                            end
                            if(signed_div == 1'b1 && (opdata1[31] ^ dividend[64] == 1'b1))begin
                                dividend[64:33] <= ~dividend[64:33] + 1;
                            end
                            state <= `DivEnd;
                            cnt <= 6'b000000;
                        end
                    end 
                    else begin
                        state <= `DivFree;
                    end
                end

                `DivEnd:begin
                    result <= {dividend[64:33],dividend[31:0]};
                    ready <= `DivResultReady;
                    if(start == `DivStop)begin
                        state <= `DivFree;
                        ready <= `DivResultNotReady;
                        result <= {`zero,`zero};
                    end
                end

            endcase
        end
    end
endmodule
