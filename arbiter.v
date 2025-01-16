module arbiter #(
    parameter NUM_NODES = 4,           // Number of FIFO nodes
    parameter ADDR_WIDTH = 2,          // Address width for ROM
    parameter DATA_WIDTH = 16          // Data width for ROM and FIFOs
)(
    input                  clk,        // Clock
    input                  rst,        // Reset
    output reg [ADDR_WIDTH-1:0] addr,  // Address to fetch from ROM
    output reg             fetch_en,   // Fetch enable signal for ROM
    output reg [NUM_NODES-1:0] wr_en,  // Write enable for each FIFO  
    output reg             all_done,   // Signal indicating all ROM data is read
    input                  full        // Full signal from all FIFOs
);

    // State variables
    reg [1:0] current_node;            // Current node index (0 to NUM_NODES-1)
    reg [ADDR_WIDTH-1:0] addr_counter; // Address counter for ROM fetch

    // Total number of ROM addresses (assume 2^ADDR_WIDTH for simplicity)
    localparam TOTAL_ADDRESSES = 1 << ADDR_WIDTH;

    // Arbiter logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            addr <= 0;
            fetch_en <= 0;
            wr_en <= 0;
            current_node <= 0;
            addr_counter <= 0;
            all_done <= 0; // Reset "all done" signal
        end else begin
            // If all ROM addresses are read, set the all_done signal
            if (addr_counter == TOTAL_ADDRESSES && !all_done) begin
                all_done <= 1; // ROM completely read
                fetch_en <= 0; // Stop fetches
                wr_en <= 0;    // Stop writing to FIFOs
            end else if (!full && !all_done) begin
                // Enable fetch for ROM
                fetch_en <= 1;

                // Assign write enable for current FIFO
                wr_en <= (1 << current_node);  // Set the bit for the current node (e.g., 4'b0001, 4'b0010, ...)

                // Increment address and node index
                addr <= addr_counter;
                addr_counter <= addr_counter + 1;
                current_node <= current_node + 1;

                // Reset node index when all nodes are serviced
                if (current_node == NUM_NODES - 1) begin
                    current_node <= 0;
                end
            end else begin
                // Disable fetch when FIFOs are full
                fetch_en <= 0;
                wr_en <= 0;
            end
        end
    end
endmodule