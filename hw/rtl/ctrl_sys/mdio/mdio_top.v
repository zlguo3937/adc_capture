// --------------------------------------------------------------------
//
//                     JLSemi
//                     Shanghai, China
//                     Name :
//                     Email:
//
// --------------------------------------------------------------------
// --------------------------------------------------------------------
//  Revision History:1.0
//  Date          By            Revision    Change Description
//---------------------------------------------------------------------
//  2023-10-08                  1.0         mdio_top
// --------------------------------------------------------------------
// --------------------------------------------------------------------
`timescale 1ns/1ns
module mdio_top
(
    input   wire            clk_200m,
    input   wire            rstn_200m,

    input   wire            mdio_in,
    input   wire            mdc,
    output  wire            mdio_out,
    output  wire            mdio_oen,

    input   wire    [4 :0]  legal_phy_addr,
    input   wire    [4 :0]  legal_phy_addr_mask,
    input   wire    [4 :0]  broadcast_addr,
    input   wire            broadcast_mode,
    input   wire            non_zero_detect,
    input   wire            opendrain_mode,
    input   wire            watchdog_enable,
    input   wire            sync_select,

    output  wire    [20:0]  req_paddr,
    output  wire            req_pwrite,
    output  wire            req_psel,
    output  wire            req_penable,
    output  wire    [15:0]  req_pwdata,

    input   wire            req_pready,
    input   wire    [15:0]  req_prdata
);

    wire            mdio_oe;

    wire            time_out_flag;

    wire            enable_async;
    wire    [15:0]  resp_rdata;
    wire            resp_ready;
    wire            legal;
    wire    [31:0]  rx_data;
    wire            info_done_pos;
    wire            data_done_pos;
    wire            phyaddr_done_pos;

    assign mdio_oen     = ~mdio_oe;

    assign enable_async = ~sync_select;

    assign req_penable  = req_psel;

    mdio_slave_22_45_frontend_async
    u_async_frontend_unit(
    .clk_25m                ( clk_200m                  ),
    .rst_n                  ( rstn_200m                 ),
    .mdc                    ( mdc                       ),
    .mdio_in                ( mdio_in                   ),
    .mdio_out               ( mdio_out                  ),
    .mdio_oe                ( mdio_oe                   ),
    .legal_phy_addr         ( legal_phy_addr            ),
    .legal_phy_addr_mask    ( legal_phy_addr_mask       ),
    .non_zero_detect        ( non_zero_detect           ),
    .broadcast_mode         ( broadcast_mode            ),
    .broadcast_addr         ( broadcast_addr            ),
    .opendrain_mode         ( opendrain_mode            ),
    .enable                 ( enable_async              ),
    .resp_rdata             ( resp_rdata                ),
    .resp_ready             ( resp_ready                ),
    .legal                  ( legal                     ),
    .rx_data                ( rx_data                   ),
    .info_done              ( info_done_pos             ),
    .data_done              ( data_done_pos             ),
    .phyaddr_done           ( phyaddr_done_pos          )
    );

    mdio_slave_22_45_backend
    u_async_backend_unit(
    .clk_25m                ( clk_200m                  ),
    .rst_n                  ( rstn_200m                 ),
    .time_out_flag          ( time_out_flag             ),
    .rx_data                ( rx_data                   ),
    .info_done_pos          ( info_done_pos             ),
    .data_done_pos          ( data_done_pos             ),
    .phyaddr_done_pos       ( phyaddr_done_pos          ),
    .resp_rdata             ( resp_rdata                ),
    .resp_ready             ( resp_ready                ),
    .legal                  ( legal                     ),
    .reg_if_rdata           ( req_prdata                ),
    .reg_if_ready           ( req_pready                ),
    .reg_if_addr            ( req_paddr                 ),
    .reg_if_wdata           ( req_pwdata                ),
    .reg_if_valid           ( req_psel                  ),
    .reg_if_we              ( req_pwrite                )
    );

    watchdog_mdio
    u_watch_dog_unit(
    .clk_25m                ( clk_200m                  ),
    .rst_n                  ( rstn_200m                 ),
    .mdio                   ( mdio_in                   ),
    .watchdog_enable        ( watchdog_enable           ),
    .time_out_flag          ( time_out_flag             )
    );

endmodule
