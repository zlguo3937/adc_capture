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
//  2024-02-08                  1.0         watchdog_mdio
// ------------------------------------------------------------------------
// ------------------------------------------------------------------------
`timescale 1ns/1ns
module watchdog_mdio
(
    input   wire            clk_25m,            // work clock
    input   wire            rst_n,

    input   wire            mdio,
    input   wire            watchdog_enable,
    output  wire            time_out_flag
);
    reg [2:0]   mdio_cdc;
    reg         mdio_filted;
    reg         mdio_filted_r;

    wire        mdio_pos;
    wire        mdio_neg;

    reg [30:0]  time_out_cnt;
    wire        time_out_flag_tmp;

    always @(posedge clk_25m or negedge rst_n)
    begin
        if (!rst_n)
            mdio_cdc <= 3'b0;
        else
            mdio_cdc <= { mdio_cdc[1:0], mdio };
    end

    always @(posedge clk_25m or negedge rst_n)
    begin
        if (!rst_n)
            mdio_filted <= 1'b0;
        else if ( (mdio_cdc[1] ^ mdio_cdc[2]) && (mdio_cdc[2] ^ mdio_filted) )
            mdio_filted <= mdio_cdc[1];
        else
            mdio_filted <= mdio_cdc[2];
    end

    always @(posedge clk_25m or negedge rst_n)
    begin
        if (!rst_n)
            mdio_filted_r <= 1'b0;
        else
            mdio_filted_r <= mdio_filted;
    end

    assign mdio_pos = mdio_filted & ~mdio_filted_r;
    assign mdio_neg = ~mdio_filted & mdio_filted_r;

    always @(posedge clk_25m or negedge rst_n)
    begin
        if (!rst_n)
            time_out_cnt <= 31'b0;
        else if ( time_out_flag || mdio_pos || mdio_neg )
            time_out_cnt <= 31'b0;
        else
            time_out_cnt <= time_out_cnt + 1'd1;
    end

    assign time_out_flag_tmp = &time_out_cnt;
    assign time_out_flag = watchdog_enable ? time_out_flag_tmp : 1'b0;

endmodule
