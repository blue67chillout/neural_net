`timescale 1ns / 1ps

module tb_arbiter;

    // Parameters
    parameter NUM_NODES = 4;
    parameter ADDR_WIDTH = 2;
    parameter DATA_WIDTH = 16;

    // Inputs to the DUT
    reg clk;
    reg rst;
    reg full;

    // Outputs from the DUT
    wire [ADDR_WIDTH-1:0] addr;
    wire fetch_en;
    wire [NUM_NODES-1:0] wr_en;
    wire all_done;

    // Instantiate the DUT (Device Under Test)
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

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Generate a clock with a period of 10ns
    end

    // Test sequence
    initial begin
        // Initialize signals
        rst = 1;
        full = 0;

        // Hold reset for a few cycles
        #20 rst = 0;

        // Test Case 1: Normal operation, no full signal
        $display("Starting Test Case 1: Normal operation");
        repeat(10) @(posedge clk); // Let the arbiter run for a while

        // Test Case 2: FIFOs become full
        $display("Starting Test Case 2: FIFOs full");
        full = 1;
        repeat(5) @(posedge clk);
        full = 0; // FIFOs are no longer full
        repeat(10) @(posedge clk);

        // Test Case 3: Verify all_done signal
        $display("Starting Test Case 3: ROM completely read");
        wait(all_done); // Wait for all_done signal to go high
        $display("All data read from ROM, Test Case 3 passed");

        // End of simulation
        $stop;
    end

    // Monitor signals
    initial begin
        $monitor("Time=%0t | addr=%0d | fetch_en=%b | wr_en=%b | all_done=%b | full=%b",
                 $time, addr, fetch_en, wr_en, all_done, full);
    end

endmodule