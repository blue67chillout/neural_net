module rom_weights #(
                    
    ADDR_WIDTH = 8,
    DATA_OUT_WIDTH = 16,
    MEM_FILE = "weights.mem") (

    input clk,
    input rst,
    input [ADDR_WIDTH-1:0]addr,
    output reg [DATA_OUT_WIDTH-1:0]data_out,
    input r_en
                    
    );

    reg [DATA_OUT_WIDTH-1:0]mem[ADDR_WIDTH-1:0];

    initial begin
        $readmemh(MEM_FILE, mem);
    end

    always@(posedge clk) begin
        if(rst) begin
            data_out <= 0;
            for (int i = 0; i < 8; i = i + 1) begin
                mem[i] <= 0;
            end
        end
        else if(r_en ) begin
            data_out <= mem[addr];
        end
    end


    
endmodule