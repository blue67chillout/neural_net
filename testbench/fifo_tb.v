`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/11/2025 07:00:05 PM
// Design Name: 
// Module Name: tb
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

module tb_fifo_memory;

    // Testbench signals
    reg clk;
    reg rst;
    reg wr_en;
    reg rd_en;
    reg [15:0] data_in;  // 16-bit input data (as per your DATA_IN_WIDTH)
    wire [3:0] data_out; // 4-bit output data (as per your DATA_OUT_WIDTH)
    wire empty;
    wire full;

   
    fifo_memory #(
        .DATA_IN_WIDTH(16),
        .DATA_OUT_WIDTH(4),
        .DEPTH(8)
    ) uut (
        .clk(clk),
        .rst(rst),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .data_in(data_in),
        .data_out(data_out),
        .empty(empty),
        .full(full)
    );

    // Clock generation
    always begin
        #5 clk = ~clk; // 100 MHz clock
    end

    // Stimulus
    initial begin
        // Initialize signals
        clk = 1;
        rst = 0;
        wr_en = 0;
        rd_en = 0;
        data_in = 0;

        // Apply reset
        rst = 1;
        #10;
        rst = 0;

        // Test writing to the FIFO
        // Write some data to FIFO
        wr_en = 1;
        data_in = 16'hABCD; // Input data 1
        #10;
        wr_en = 0;
        data_in = 0;

        // Write more data
        wr_en = 1;
        data_in = 16'h1234; // Input data 2
        #10;
        wr_en = 0;
        data_in = 0;

        // Test reading from the FIFO
        // Start reading from FIFO
        rd_en = 1;
       // #10;  // Wait for data to be read
       // rd_en = 1;

        // Check for empty and full flags
        $display("Empty: %b, Full: %b", empty, full);

//        // Write data again to test full condition
//        wr_en = 0;
//        rd_en = 1;
//        data_in = 16'hFFFF; // Input data 3
//        #10;
//        wr_en = 0;
//        data_in = 0;
#10
        wr_en = 1;
       data_in = 16'hAFE9; // Input data 4
        #10;
//      
  data_in = 16'h8765; // Input data 4
        #10;
     wr_en = 0;

//        // Now read the data back and check FIFO status
//        rd_en = 1;
//        #10;
//        rd_en = 0;
        
//        // More reads
//        rd_en = 1;
//        #10;
//        rd_en = 0;

//        // Test for full condition by filling the FIFO
//        wr_en = 1;
//        data_in = 16'h5678; // Input data 5
//        #10;
//        wr_en = 0;
//        data_in = 0;

//        wr_en = 1;
//        data_in = 16'h9ABC; // Input data 6
//        #10;
//        wr_en = 0;
//        data_in = 0;

//        wr_en = 1;
//        data_in = 16'h1111; // Input data 7
//        #10;
//        wr_en = 0;
//        data_in = 0;

//        // Check the FIFO full condition
//        $display("Full: %b", full);

//        // Reset FIFO again
////        rst = 1;
////        #10;
////        rst = 0;

//        // After reset, check empty condition
//        $display("Empty after reset: %b", empty);
//        $display("Full after reset: %b", full);
//    end
end
    // Monitor the outputs
    initial begin
        $monitor("Time: %0t, data_out: %h, empty: %b, full: %b", $time, data_out, empty, full);
    end

endmodule

