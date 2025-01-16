`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// MAC Unit for 4-bit Inputs
// Multiplies two 4-bit inputs and accumulates the result in a 12-bit register.
//////////////////////////////////////////////////////////////////////////////////

module test_mac (
    input wire clk,           // Clock signal
    input wire rst,           // Reset signal
    input wire en,            // Enable signal
    input wire [3:0] a,       // First 4-bit input
    input wire [3:0] b,       // Second 4-bit input
    output reg [9:0] result  // 12-bit accumulated result
);

    // Internal wire to store the product of inputs
    wire [7:0] product;

    // Multiply the inputs
    assign product = a * b;

    // Sequential logic for MAC operation
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset the accumulated result to zero
            result <= 12'd0;
        end else if (en) begin
            // Accumulate the product of inputs
            result <= result + product;
        end
    end

endmodule