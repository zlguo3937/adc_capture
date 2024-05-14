// ------------------------------------------------------------------------
//
//                     JLSemi
//                     Shanghai, China
//                     Name :
//                     Email:
//
// ------------------------------------------------------------------------
// ------------------------------------------------------------------------
//  Revision History:1.0
//  Date          By            Revision    Change Description
//-------------------------------------------------------------------------
//  2024-02-08                  1.0         cdc_200m_100m
// ------------------------------------------------------------------------
// ------------------------------------------------------------------------

module cdc_200m_100m
(
    input   wire        clk_200m,
    input   wire        clk_100m,
    input   wire        rstn_200m,
    input   wire        rstn_100m,

    input   wire        time_out_flag_200m,
    input   wire [20:0] reg_if_addr_200m,
    input   wire [15:0] reg_if_wdata_200m,
    input   wire        reg_if_valid_200m,
    input   wire        reg_if_we_200m,
    output  wire [15:0] reg_if_rdata_200m,
    output  wire        reg_if_ready_200m,

    output  wire        time_out_flag_100m,
    output  wire [20:0] reg_if_addr_100m,
    output  wire [15:0] reg_if_wdata_100m,
    output  wire        reg_if_valid_100m,
    output  wire        reg_if_we_100m,
    input   wire [15:0] reg_if_rdata_100m,
    input   wire        reg_if_ready_100m

);

    reg [15:0]  rdata_r;
    reg [20:0]  addr_r;
    reg [15:0]  wdata_r;

    always @(posedge clk_100m or negedge rstn_100m)
    begin
        if (!rstn_100m)
            rdata_r <= 16'b0;
        else if (reg_if_ready_100m)
            rdata_r <= reg_if_rdata_100m;
    end

    always @(posedge clk_200m or negedge rstn_200m)
    begin
        if (!rstn_200m)
            addr_r <= 21'b0;
        else if (reg_if_valid_200m)
            addr_r <= reg_if_addr_200m;
    end

    always @(posedge clk_200m or negedge rstn_200m)
    begin
        if (!rstn_200m)
            wdata_r <= 16'b0;
        else if (reg_if_valid_200m)
            wdata_r <= reg_if_wdata_200m;
    end

    assign reg_if_addr_100m  = addr_r;
    assign reg_if_wdata_100m = reg_if_wdata_200m;
    assign reg_if_rdata_200m = rdata_r;

    cdc_1clk_signal
    u_valid_cdc
    (
    .clka       (clk_200m           ),
    .clkb       (clk_100m           ),
    .rstn_clka  (rstn_200m          ),
    .rstn_clkb  (rstn_100m          ),
    .sig_in     (reg_if_valid_200m  ),
    .sig_out    (reg_if_valid_100m  )
    );

    cdc_1clk_signal
    u_we_cdc
    (
    .clka       (clk_200m           ),
    .clkb       (clk_100m           ),
    .rstn_clka  (rstn_200m          ),
    .rstn_clkb  (rstn_100m          ),
    .sig_in     (reg_if_we_200m     ),
    .sig_out    (reg_if_we_100m     )
    );

    cdc_1clk_signal
    u_ready_cdc
    (
    .clka       (clk_200m           ),
    .clkb       (clk_100m           ),
    .rstn_clka  (rstn_200m          ),
    .rstn_clkb  (rstn_100m          ),
    .sig_in     (reg_if_ready_100m  ),
    .sig_out    (reg_if_ready_200m  )
    );

    cdc_1clk_signal
    u_time_out_flag_cdc
    (
    .clka       (clk_200m           ),
    .clkb       (clk_100m           ),
    .rstn_clka  (rstn_200m          ),
    .rstn_clkb  (rstn_100m          ),
    .sig_in     (time_out_flag_200m ),
    .sig_out    (time_out_flag_100m )
    );


endmodule
