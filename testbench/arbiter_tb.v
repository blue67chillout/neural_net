`timescale 1ns / 1ps

module tb_arbiter;

    
    parameter NUM_NODES = 4;
    parameter ADDR_WIDTH = 2;
    parameter DATA_WIDTH = 16;

    
    reg clk;
    reg rst;
    reg full;

   
    wire [ADDR_WIDTH-1:0] addr;
    wire fetch_en;
    wire [NUM_NODES-1:0] wr_en;
    wire all_done;

    
    arbiter #(
        .NUM_NODES(NUM_NODES),
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) uut (
        .clk(clk),
        .rst(rst),
        .addr(addr),
        .fetch_en(fetch_en),
        .wr_en(wr_en),
        .all_done(all_done),
        .full(full)
    );

    
    initial begin
        clk = 0;
        forever #5 clk = ~clk; 
    end

   
    initial begin
       
        rst = 1;
        full = 0;

        
        #20 rst = 0;

       
        $display("Starting Test Case 1: Normal operation");
        repeat(10) @(posedge clk); 

       
        $display("Starting Test Case 2: FIFOs full");
        full = 1;
        repeat(5) @(posedge clk);
        full = 0; 
        repeat(10) @(posedge clk);

       
        $display("Starting Test Case 3: ROM completely read");
        wait(all_done); 
        $display("All data read from ROM, Test Case 3 passed");

       
        $stop;
    end

   
    initial begin
        $monitor("Time=%0t | addr=%0d | fetch_en=%b | wr_en=%b | all_done=%b | full=%b",
                 $time, addr, fetch_en, wr_en, all_done, full);
    end

endmodule