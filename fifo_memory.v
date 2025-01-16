`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/12/2025 02:16:23 PM
// Design Name: 
// Module Name: fifo_memory
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

module fifo_memory #(
    parameter DATA_IN_WIDTH = 16,   // Width of input data
    parameter DATA_OUT_WIDTH = 4,  // Width of output data
    parameter DEPTH = 8            // Number of words in the FIFO
)(
    input                       clk,
    input                       rst,
    input                       wr_en,       // Write enable
    input                       rd_en,       // Read enable
    input   [DATA_IN_WIDTH-1:0] data_in,     // Input data
    output  reg [DATA_OUT_WIDTH-1:0] data_out,   // Output data
    output                      empty,       // FIFO empty flag
    output                      full         // FIFO full flag
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam CHUNK_COUNT = DATA_IN_WIDTH / DATA_OUT_WIDTH;

    // Internal FIFO memory to store input data
    reg [DATA_IN_WIDTH-1:0] memory [0:DEPTH-1];

    // Read and write pointers
    reg [ADDR_WIDTH-1:0] wr_ptr;
    reg [ADDR_WIDTH-1:0] rd_ptr;

    // Chunk index for slicing output
    reg [$clog2(CHUNK_COUNT)-1:0] chunk_index ;

    // Internal flags
    reg empty_reg, full_reg;
    reg [DATA_IN_WIDTH-1:0] current_data;

   

    // Sequential logic for read and write operations
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            wr_ptr <= 0;
            rd_ptr <= 0;
            empty_reg <= 1;
            full_reg <= 0;
            chunk_index <= 0;
        end else begin
            // Write logic
            if (wr_en && !full_reg) begin
                memory[wr_ptr] <= data_in;
                wr_ptr <= wr_ptr + 1;
                empty_reg <= 0;
                if (wr_ptr + 1 == rd_ptr) // Check for full condition
                    full_reg <= 1;
            end

            // Read logic
            if (rd_en && !empty_reg) begin
            
               data_out <= memory[rd_ptr][DATA_OUT_WIDTH * (chunk_index) +: DATA_OUT_WIDTH];
               chunk_index <= chunk_index + 1;
               
             end
            
            if (chunk_index == CHUNK_COUNT-1) begin
                    rd_ptr <= rd_ptr + 1;
                    chunk_index <= 0;
                    if (rd_ptr + 1 == wr_ptr) // Check for empty condition
                        empty_reg <= 1;
                    full_reg <= 0;
                end
               
            end 
               
               
        
    
    end
     // Assign outputs
   
    assign empty = empty_reg;
    assign full = full_reg;

endmodule