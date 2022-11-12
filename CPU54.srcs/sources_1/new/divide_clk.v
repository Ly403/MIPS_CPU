`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/08/09 09:52:49
// Design Name: 
// Module Name: divide_clk
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
`include "D:/digital_logic/project/CPU54/CPU54.srcs/sources_1/new/defines.v"
module divide_clk(
    input clk,
    input [5:0]stall,
    output reg clk1,
    output reg clk2,
    output reg clk3,
    output reg clk4,
    output reg clk5
    );


    integer i = 0;
    always@(posedge clk)begin
        if(stall == 6'b001111)begin
            clk3 <= ~clk3;
        end
        else if(stall == 6'b000111)begin
            clk2 <= ~clk2;
        end
        else begin
            if(i != 4'd9)begin
                i <= i + 1;
            end
            else begin
                i <= 0;
            end
            
            case (i)
                    0: clk1 <= 1; 
                    1: clk1 <= 0;
                    2: clk2 <= 1;
                    3: clk2 <= 0;
                    4: clk3 <= 1;
                    5: clk3 <= 0; 
                    6: clk4 <= 1;
                    7: clk4 <= 0;
                    8: clk5 <= 1;
                    9: clk5 <= 0;
                    default: begin
                    end
            endcase
        end
    end

endmodule
