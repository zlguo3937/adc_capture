
    reg clk_out3,clk_out4;

    wire  [(DIV_N-1)/2:0] cfg_phase_cnt;
    assign cfg_phase_cnt = rf_pktctrl_rclk_phase == 2'b00 ? 0 :
                            rf_pktctrl_rclk_phase == 2'b01 ? 4 :
                            rf_pktctrl_rclk_phase == 2'b10 ? 8 : 0;

    always @(posedge clk_in_pre or negedge rstn_out)
    begin
        if(~rstn_out)
            clk_out3 <= 1'b0;
        else if (cnt == cfg_phase_cnt)
            clk_out3 <= ~clk_out3;
        else
            clk_out3 <= clk_out3;
    end

    always @(negedge clk_in_pre or negedge rstn_out)
    begin
        if(~rstn_out)
            clk_out4 <= 1'b0;
        else if (cnt == cfg_phase_cnt + 13)
            clk_out4 <= ~clk_out4;
        else
            clk_out4 <= clk_out4;
    end

    assign clk_out_phase = (rf_pktctrl_rclk_phase == 2'b11) ? (~(clk_out1 ^ clk_out2)) : (clk_out3 ^ clk_out4);
