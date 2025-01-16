module relu (

    input clk,
    input rst,
    input [9:0]in,
    input act_fn_en,
    output reg out
);

always @(posedge clk) begin
    if(rst) begin
        out <= 0;
    end
    else if(act_fn_en) begin
        if(in > 1024) begin
            out <= 1024;
        end
        else if(in < 0) begin
            out <= 0;
        end
        else begin
            out <= in;
        end
    end
end
    
endmodule