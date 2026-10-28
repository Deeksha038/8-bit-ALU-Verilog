`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.08.2026 10:55:24
// Design Name: 
// Module Name: ALU_8bit
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

module ALU_8bit (
    input  [7:0] A,
    input  [7:0] B,
    input  [3:0] opcode,

    output reg [7:0] result,
    output reg       carry,
    output reg       borrow,
    output reg       zero,
    output reg       overflow,
    output reg       negative
);

    reg [8:0] temp;

    always @(*) begin

        // Default values
        result   = 8'b0;
        carry    = 1'b0;
        borrow   = 1'b0;
        overflow = 1'b0;
        temp     = 9'b0;

        case (opcode)

            // 0000 : ADD
            4'b0000: begin
                temp   = A + B;
                result = temp[7:0];
                carry  = temp[8];

                overflow = (~(A[7] ^ B[7])) &
                           (result[7] ^ A[7]);
            end

            // 0001 : SUB
            4'b0001: begin
                result = A - B;

                borrow = (A < B);

                overflow = (A[7] ^ B[7]) &
                           (result[7] ^ A[7]);
            end

            // 0010 : INC
            4'b0010: begin
                temp   = A + 1;
                result = temp[7:0];
                carry  = temp[8];

                // Signed overflow: +127 + 1
                overflow = (~A[7]) & result[7];
            end

            // 0011 : DEC
            4'b0011: begin
                result = A - 1;
                borrow = (A == 0);

                // Signed overflow: -128 - 1
                overflow = A[7] & ~result[7];
            end

            // 0100 : AND
            4'b0100: begin
                result = A & B;
            end

            // 0101 : OR
            4'b0101: begin
                result = A | B;
            end

            // 0110 : XOR
            4'b0110: begin
                result = A ^ B;
            end

            // 0111 : NOT
            4'b0111: begin
                result = ~A;
            end

            // 1000 : NAND
            4'b1000: begin
                result = ~(A & B);
            end

            // 1001 : NOR
            4'b1001: begin
                result = ~(A | B);
            end

            // 1010 : XNOR
            4'b1010: begin
                result = ~(A ^ B);
            end

            // 1011 : Shift Left
            4'b1011: begin
                result = A << 1;
                carry  = A[7];
            end

            // 1100 : Logical Shift Right
            4'b1100: begin
                result = A >> 1;
                carry  = A[0];
            end

            // 1101 : Arithmetic Shift Right
            4'b1101: begin
                result = $signed(A) >>> 1;
                carry  = A[0];
            end

            // 1110 : MODULO
            4'b1110: begin
                if (B != 0)
                    result = A % B;
                else
                    result = 8'b0;
            end

            // 1111 : Pass-through
            4'b1111: begin
                result = A;
            end

            default: begin
                result = 8'b0;
            end

        endcase

        // Common flags
        zero     = (result == 8'b0);
        negative = result[7];

    end

endmodule
