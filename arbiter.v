module arbiter #(
    parameter NUM_NODES = 4,           
    parameter ADDR_WIDTH =8 ,          
    parameter DATA_WIDTH = 16          
)(
    input                  clk,        
    input                  rst,        
    output reg [ADDR_WIDTH-1:0] addr,  
    output reg             fetch_en,   
    output reg [NUM_NODES-1:0] wr_en,   
    output reg             all_done,   
    input                  full        
);

   
    reg [1:0] current_node;            
    reg [ADDR_WIDTH-1:0] addr_counter; 


    localparam TOTAL_ADDRESSES = 1 << ADDR_WIDTH;

    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            addr <= 0;
            fetch_en <= 0;
            wr_en <= 0;
            current_node <= 0;
            addr_counter <= 0;
            all_done <= 0; 
        end else begin
            if (addr_counter == TOTAL_ADDRESSES && !all_done) begin
                all_done <= 1; 
                fetch_en <= 0;
                wr_en <= 0;   
            end else if (!full && !all_done) begin
                
                fetch_en <= 1;

                
                wr_en <= (1 << current_node);  

                
                addr <= addr_counter;
                addr_counter <= addr_counter + 1;
                current_node <= current_node + 1;

                
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