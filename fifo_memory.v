module fifo #(
    parameter DATA_IN_WIDTH = 16,   
    parameter DATA_OUT_WIDTH = 4,  
    parameter DEPTH = 4
) (
    input clk,
    input rst,

    input [DATA_IN_WIDTH-1:0]din,
    input rd_en,
    input wr_en,
    output reg [DATA_OUT_WIDTH-1:0]dout,
    
    output reg full,
    output reg empty
    
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam CHUNK_COUNT = DATA_IN_WIDTH/DATA_OUT_WIDTH;

    reg [DATA_IN_WIDTH-1:0]mem[0:DEPTH-1];
    reg [ADDR_WIDTH-1:0]rd_ptr, wr_ptr;
    reg [($clog2(CHUNK_COUNT)-1):0]chunk_ptr;

    always @(posedge clk) begin
        if(rst) begin
            wr_ptr <= 0;
            rd_ptr <= 0;
            chunk_ptr <= 0;
            full <= 1'b0;
            empty <= 1'b1;
        end
        else begin
            if(wr_en && !full) begin
                mem[wr_ptr] <= din;
                wr_ptr <= wr_ptr + 1;
                if(wr_ptr == DEPTH-1) begin
                    wr_ptr <= 0;
                end
                if(wr_ptr + 1 == rd_ptr) begin
                    full <= 1'b1;
                end
                empty <= 1'b0;
            end
            if(rd_en && !empty) begin
                dout <= memory[rd_ptr][DATA_OUT_WIDTH * (chunk_ptr) +: DATA_OUT_WIDTH];
                chunk_ptr <= chunk_ptr + 1;

                if(chunk_ptr == CHUNK_COUNT-1) begin
                    rd_ptr <= rd_ptr + 1;
                    chunk_ptr <= 0;
                    if(rd_ptr == DEPTH-1) begin
                        rd_ptr <= 0;
                    end
                    if(rd_ptr == wr_ptr) begin
                        empty <= 1'b1;
                    end
                    full <= 1'b0;
            end
        end
    end
    end

   

    
endmodule