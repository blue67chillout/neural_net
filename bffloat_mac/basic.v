module basic #(
) (
    input [15:0] a,
    input [15:0] b,
    output [15:0] result
);

    always@(*) begin
        result = a + b;
    end
    
endmodule