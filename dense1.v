module dense1 #(
    
    NO_IPN = 4,
    NO_NPL = 4,


) (
    input clk,
    input rst,
    input fetch_en,
    input mac_en,
    input act_fn_en,
    input feed_through

);

reg [3:0] x;
wire [15:0] data_out_n1,data_out_n2,data_out_n3,data_out_n4;
wire [15:0] data_out_f_n1,data_out_f_n2,data_out_f_n3,data_out_f_n4,;
wire empty_n1, empty_n2, empty_n3, empty_n4;
wire full_n1, full_n2,full_n3, full_n4;


/////////////      NODE_MEMORY          ///////////////////

rom_weights #(
    .ADDR_WIDTH(2),
    .DATA_OUT_WIDTH(16),
    .MEM_FILE("weights.mem")         
) rom_weights_inst (
    .clk(clk),
    .rst(rst),
    .addr(addr),
    .data_out(data_out),
    .r_en(fetch_en)
);
                                          
fifo_memory #(
    .DATA_IN_WIDTH(16),                 //NODE 1
    .DATA_OUT_WIDTH(4),
    .DEPTH(4)
) fifo_memory_node1 (
    .clk(clk),
    .rst(rst),
    .wr_en(fetch_en),
    .rd_en(mac_en),
    .data_in(data_out),
    .data_out(data_out_f),
    .empty(empty),
    .full(full)
);

fifo_memory #(
    .DATA_IN_WIDTH(16),                 //NODE 2
    .DATA_OUT_WIDTH(4),
    .DEPTH(4)
) fifo_memory_node1 (
    .clk(clk),
    .rst(rst),
    .wr_en(fetch_en),
    .rd_en(mac_en),
    .data_in(data_out),
    .data_out(data_out_f),
    .empty(empty),
    .full(full)
);


rom_weights #(
    .ADDR_WIDTH(2),
    .DATA_OUT_WIDTH(4),
    .MEM_FILE("bias.mem")
) rom_bias_inst (
    .clk(clk),
    .rst(rst),
    .addr(addr),
    .data_out(data_out),
    .r_en(r_en)
);



rom_weights #(
    .ADDR_WIDTH(2),
    .DATA_OUT_WIDTH(16),
    .MEM_FILE("input.mem")
) rom_input_inst (
    .clk(clk),
    .rst(rst),
    .addr(addr),
    .data_out(data_out),
    .r_en(r_en)
);

test_mac #(
    .NO_IPN(NO_IPN),
    .NO_NPL(NO_NPL)
) test_mac_inst (
    .clk(clk),
    .rst(rst),
    .mac_en(mac_en),
    .data_in(data_in),
    .data_out(data_out)
);





    
endmodule