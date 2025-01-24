`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

module test_mac #(
    parameter DATA_WIDTH = 8,
    parameter ACC_WIDTH = 18
) (
    input wire clk,           
    input wire rst,           
    input wire en,            
    input wire [DATA_WIDTH-1:0] a,       
    input wire [DATA_WIDTH:0] b,       
    output reg [ACC_WIDTH-1:0] result  
);

    initial begin
        result = 0;
    end
    reg [7:0] product;

    
   always @(*) begin
        product = a * b;
        if (product > 8'd255) begin
            product = 8'd255;
        end
    end

    
    always @(posedge clk ) begin
        if (rst) begin
            result <= 0;
            product <= 0;
        end else if (en) begin
            result <= result + product;
        end
    end

endmodule