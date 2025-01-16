
// npl -> nodes per layer
// ipn -> inputs per node


module layer_ctrl #(NO_NPL = 4, NO_IPN =4 )(

    input clk,
    input rst,
    input start,
    output reg arb_en,
    output mac_en,
    output act_fn_en,
    output bias_add_en,
    output feed_through

);
    localparam  IDLE  = 4'b0000 ;
    localparam  MEM   = 4'b0001 ;
    localparam  MAC   = 4'b0010 ;
    localparam  BIAS  = 4'b0100 ;
    localparam  ACT   = 4'b1000 ;

    reg [3:0] ps, ns;
    reg [$clog2(NO_IPN):0] fetch_mem_cyc_counter,mac_cyc_counter;
    reg [$clog2(NO_NPL):0] bias_cyc_counter,act_cyc_counter;

    always@(posedge clk) begin
        if(rst) begin
            ps <= IDLE;
            arb_en <=0;
        end

        else if(start && !rst) begin 
            ps <= ns;           
        end
    end


    
    always @(*) begin
        case (ps)
            IDLE: begin if (!feed_through)
                        begin ns = MEM; arb_en =1 ;end
                    else
                        begin ns = IDLE;arb_en = 0 ; end
                  end
            MEM:  ns = (fetch_mem_cyc_counter == NO_IPN-1) ? MAC : MEM;
            MAC:  ns = (mac_cyc_counter == NO_IPN-1) ? BIAS : MAC;   
            BIAS: ns = (bias_cyc_counter == NO_NPL-1) ? ACT : BIAS;
            ACT:  ns = (act_cyc_counter == NO_NPL-1) ? IDLE : ACT;
            default: ns = IDLE;
        endcase
    end

    always @(posedge clk) begin
        if (rst) begin
            mac_cyc_counter <= 0;
            fetch_mem_cyc_counter <= 0;
            bias_cyc_counter <= 0;
            act_cyc_counter <= 0;
        end

        else if (start) begin
            case (ps)
                MEM: begin
                    bias_cyc_counter <= 0;
                    if (fetch_mem_cyc_counter == NO_IPN-1) begin
                        fetch_mem_cyc_counter <= NO_IPN;
                    end
                    else begin
                        fetch_mem_cyc_counter <= fetch_mem_cyc_counter + 1;
                    end
                end

                MAC: begin
                    act_cyc_counter <=0;
                    if (mac_cyc_counter == NO_IPN-1) begin
                        mac_cyc_counter <= NO_IPN;
                    end
                    else begin
                        mac_cyc_counter <= mac_cyc_counter + 1;
                    end
                end

                BIAS: begin
                    fetch_mem_cyc_counter <= 0;
                    if (bias_cyc_counter == NO_NPL) begin
                        bias_cyc_counter <= NO_NPL;
                    end
                    else begin
                        bias_cyc_counter <= bias_cyc_counter + 1;
                    end
                end

                ACT: begin
                    mac_cyc_counter <= 0;
                    
                    if (act_cyc_counter == NO_NPL) begin
                        act_cyc_counter <= NO_NPL;
                    end
                    else begin
                        act_cyc_counter <= act_cyc_counter + 1;
                    end
                end
            endcase
        end 
    end

assign  mac_en = ( ps ==MAC && fetch_mem_cyc_counter  == NO_IPN ) ? 1 : 0;
assign  bias_add_en = (ps == BIAS && mac_cyc_counter  == NO_IPN ) ? 1 : 0;   
assign  act_fn_en = ( ps == ACT && bias_cyc_counter  == NO_NPL ) ? 1 : 0;
assign  feed_through = (ps == IDLE && act_cyc_counter == NO_NPL ) ? 1 : 0;  

endmodule