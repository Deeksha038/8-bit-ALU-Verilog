`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.08.2026 07:26:36
// Design Name: 
// Module Name: ALU_8bit_tb
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
///////////////////////////////////////////////////////////////////////////////////


module ALU_8bit_tb;

    reg [7:0] A;
    reg [7:0] B;
    reg [3:0] opcode;

    wire [7:0] result;
    wire       carry;
    wire       borrow;
    wire       zero;
    wire       overflow;
    wire       negative;

    // ALU instance
    ALU_8bit dut(A,B,opcode,result,carry,borrow,zero,overflow,negative);

    initial begin

        // 1. ADD - Carry
        // FF + 01 = 00, Carry = 1
        A = 8'hFF;
        B = 8'h01;
        opcode = 4'b0000;
        #10;

        // 2. ADD - Positive Overflow
        // 127 + 1 = 128
        A = 8'h7F;
        B = 8'h01;
        opcode = 4'b0000;
        #10;

        // 3. ADD - Negative Overflow
        // -128 + (-1) = 127
        A = 8'h80;
        B = 8'hFF;
        opcode = 4'b0000;
        #10;

        // 4. SUB - Borrow
        // 3 - 5 = FE
        A = 8'd3;
        B = 8'd5;
        opcode = 4'b0001;
        #10;

        // 5. SUB - Positive Overflow
        // 127 - (-1) = 128
        A = 8'h7F;
        B = 8'hFF;
        opcode = 4'b0001;
        #10;

        // 6. SUB - Negative Overflow
        // -128 - 1 = 127
        A = 8'h80;
        B = 8'h01;
        opcode = 4'b0001;
        #10;

        // 7. INC - Carry
        // FF + 1 = 00
        A = 8'hFF;
        B = 8'd0;
        opcode = 4'b0010;
        #10;

        // 8. INC - Overflow
        // 127 + 1 = 128
        A = 8'h7F;
        B = 8'd0;
        opcode = 4'b0010;
        #10;

        // 9. DEC - Borrow
        // 0 - 1 = FF
        A = 8'h00;
        B = 8'd0;
        opcode = 4'b0011;
        #10;

        // 10. DEC - Overflow
        // -128 - 1 = 127
        A = 8'h80;
        B = 8'd0;
        opcode = 4'b0011;
        #10;

        // 11. ZERO FLAG
        // 5 - 5 = 0
        A = 8'd5;
        B = 8'd5;
        opcode = 4'b0001;
        #10;

        // 12. NEGATIVE FLAG
        // 0 - 1 = FF (-1)
        A = 8'd0;
        B = 8'd1;
        opcode = 4'b0001;
        #10;

        $finish;

    end

endmodule
