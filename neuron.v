module neuron (
    input [7:0]inputs[783:0],
    input [15:0]weight[783:0],
    input [7:0]bias,
    output reg [7:0]output
);
    
    reg [15:0]sum;
    reg [7:0]i;

    always @(*) begin
        sum = 0;
        for(i = 0; i < 784; i = i + 1) begin
            sum = sum + inputs[i] * weight[i];
        end
        sum = sum + bias;
        if(sum > 255) begin
            output = 255;
        end
        else if(sum < 0) begin
            output = 0;
        end
        else begin
            output = sum;
        end
    end 

endmodule