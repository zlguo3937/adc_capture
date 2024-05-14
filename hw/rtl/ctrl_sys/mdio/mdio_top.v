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

module mdio_top
(
    input   wire            clk_200m,
    input   wire            clk_100m,
    input   wire            rstn_200m,
    input   wire            rstn_100m,

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
    input   wire    [15:0]  req_prdata,
    input   wire            req_pslverr
);

    wire            out_valid;
    wire            out_we;
    wire    [20:0]  out_addr;
    wire    [15:0]  out_wdata;
    wire            in_ready;
    wire    [15:0]  in_rdata;
    wire            mdio_oe;

    wire            time_out_flag;
    wire            time_out_flag_100m;
    
    wire            mdio_out_async;
    wire            mdio_oe_async;

    wire            enable_async;
    wire    [15:0]  resp_rdata_async;
    wire            resp_ready_async;
    wire            legal_async;
    wire    [31:0]  rx_data_async;
    wire            info_done_pos_async;
    wire            data_done_pos_async;
    wire            phyaddr_done_pos_async;

    wire    [15:0]  reg_if_rdata_async;
    wire            reg_if_ready_async;
    wire    [20:0]  reg_if_addr_async;
    wire    [15:0]  reg_if_wdata_async;
    wire            reg_if_valid_async;
    wire            reg_if_we_async;

    wire    [20:0]  out_addr_100m;
    wire    [15:0]  out_wdata_100m;
    wire            out_valid_100m;
    wire            out_we_100m;

    wire            mdio_out_sync;
    wire            mdio_oe_sync;
    wire            enable_sync;
    wire    [15:0]  resp_rdata_sync;
    wire            resp_ready_sync;
    wire            legal_sync;
    wire    [31:0]  rx_data_sync;
    wire            phyaddr_done_pos_sync;
    wire            data_done_pos_sync;
    wire            info_done_pos_sync;

    wire    [20:0]  reg_if_addr_sync;
    wire    [15:0]  reg_if_wdata_sync;
    wire            reg_if_valid_sync;
    wire            reg_if_we_sync;   

    assign req_psel     = out_valid;
    assign req_penable  = out_valid;
    assign reg_pwrite   = out_we;
    assign reg_paddr    = out_addr;
    assign req_pwdata   = out_wdata;

    assign in_ready     = req_pready;
    assign in_rdata     = req_prdata;

    assign mdio_oen     = ~mdio_oe;

    assign mdio_oe      = sync_select ? mdio_oe_sync : mdio_oe_async;
    assign mdio_out     = sync_select ? mdio_out_sync : mdio_out_async;

    assign enable_async = sync_select ? 1'b0 : 1'b1;
    assign enable_sync  = sync_select ? 1'b1 : 1'b0;

    assign out_addr     = sync_select ? reg_if_addr_sync : out_addr_100m;
    assign out_wdata    = sync_select ? reg_if_wdata_sync : out_wdata_100m;
    assign out_valid    = sync_select ? reg_if_valid_sync : out_valid_100m;
    assign out_we       = sync_select ? reg_if_we_sync : out_we_100m;

    mdio_slave_22_45_frontend_async
    u_async_frontend_unit(
    .clk_25m                ( clk_200m                  ),
    .rst_n                  ( rstn_200m                 ),
    .mdc                    ( mdc                       ),
    .mdio_in                ( mdio_in                   ),
    .mdio_out               ( mdio_out_async            ),
    .mdio_oe                ( mdio_oe_async             ),
    .legal_phy_addr         ( legal_phy_addr            ),
    .legal_phy_addr_mask    ( legal_phy_addr_mask       ),
    .non_zero_detect        ( non_zero_detect           ),
    .broadcast_mode         ( broadcast_mode            ),
    .broadcast_addr         ( broadcast_addr            ),
    .opendrain_mode         ( opendrain_mode            ),
    .enable                 ( enable_async              ),
    .resp_rdata             ( resp_rdata_async          ),
    .resp_ready             ( resp_ready_async          ),
    .legal                  ( legal_async               ),
    .rx_data                ( rx_data_async             ),
    .info_done              ( info_done_pos_async       ),
    .data_done              ( data_done_pos_async       ),
    .phyaddr_done           ( phyaddr_done_pos_async    )
    );

    mdio_slave_22_45_backend
    u_async_backend_unit(
    .clk_25m                ( clk_200m                  ),
    .rst_n                  ( rstn_200m                 ),
    .time_out_flag          ( time_out_flag             ),
    .rx_data                ( rx_data_async             ),
    .info_done_pos          ( info_done_pos_async       ),
    .data_done_pos          ( data_done_pos_async       ),
    .phyaddr_done_pos       ( phyaddr_done_pos_async    ),
    .resp_rdata             ( resp_rdata_async          ),
    .resp_ready             ( resp_ready_async          ),
    .legal                  ( legal_async               ),
    .reg_if_rdata           ( reg_if_rdata_async        ),
    .reg_if_ready           ( reg_if_ready_async        ),
    .reg_if_addr            ( reg_if_addr_async         ),
    .reg_if_wdata           ( reg_if_wdata_async        ),
    .reg_if_valid           ( reg_if_valid_async        ),
    .reg_if_we              ( reg_if_we_async           )
    );

    cdc_200m_100m
    u_cdc_unit(
    .clk_200m               ( clk_200m                  ),
    .clk_100m               ( clk_100m                  ),
    .rstn_200m              ( rstn_200m                 ),
    .rstn_100m              ( rstn_100m                 ),
    .reg_if_addr_200m       ( reg_if_addr_async         ),
    .reg_if_wdata_200m      ( reg_if_wdata_async        ),
    .reg_if_valid_200m      ( reg_if_valid_async        ),
    .reg_if_we_200m         ( reg_if_we_async           ),
    .reg_if_rdata_200m      ( reg_if_rdata_async        ),
    .reg_if_ready_200m      ( reg_if_ready_async        ),
    .time_out_flag_200m     ( time_out_flag             ),
    .reg_if_addr_100m       ( out_addr_100m             ),
    .reg_if_wdata_100m      ( out_wdata_100m            ),
    .reg_if_valid_100m      ( out_valid_100m            ),
    .reg_if_we_100m         ( out_we_100m               ),
    .reg_if_rdata_100m      ( in_rdata                  ),
    .reg_if_ready_100m      ( in_ready                  ),
    .time_out_flag_100m     ( time_out_flag_100m        )
    );

    watchdog_mdio
    u_watch_dog_unit(
    .clk_25m                ( clk_200m                  ),
    .rst_n                  ( rstn_200m                 ),
    .mdio                   ( mdio_in                   ),
    .watchdog_enable        ( watchdog_enable           ),
    .time_out_flag          ( time_out_flag             )
    );

    mdio_slave_22_45_frontend_sync
    u_sync_frontend_unit(
    .clk_25m                ( clk_100m                  ),
    .rst_n                  ( rstn_100m                 ),
    .mdc                    ( mdc                       ),
    .mdio_in                ( mdio_in                   ),
    .mdio_out               ( mdio_out_sync             ),
    .mdio_oe                ( mdio_oe_sync              ),
    .legal_phy_addr         ( legal_phy_addr            ),
    .legal_phy_addr_mask    ( legal_phy_addr_mask       ),
    .broadcast_mode         ( broadcast_mode            ),
    .broadcast_addr         ( broadcast_addr            ),
    .opendrain_mode         ( opendrain_mode            ),
    .enable                 ( enable_sync               ),
    .resp_rdata             ( resp_rdata_sync           ),
    .resp_ready             ( resp_ready_sync           ),
    .legal                  ( legal_sync                ),
    .req_data               ( rx_data_sync              ),
    .req_phyaddr_done       ( phyaddr_done_pos_sync     ),
    .req_frame_done         ( data_done_pos_sync        ),
    .req_regaddr_done       ( info_done_pos_sync        )
    );

    mdio_slave_22_45_backend
    u_sync_backend_unit(
    .clk_25m                ( clk_100m                  ),
    .rst_n                  ( rstn_100m                 ),
    .time_out_flag          ( time_out_flag_100m        ),
    .rx_data                ( rx_data_sync              ),
    .info_done_pos          ( info_done_pos_sync        ),
    .data_done_pos          ( data_done_pos_sync        ),
    .phyaddr_done_pos       ( phyaddr_done_pos_sync     ),
    .resp_rdata             ( resp_rdata_sync           ),
    .resp_ready             ( resp_ready_sync           ),
    .legal                  ( legal_sync                ),
    .reg_if_rdata           ( in_rdata                  ),
    .reg_if_ready           ( in_ready                  ),
    .reg_if_addr            ( reg_if_addr_sync          ),
    .reg_if_wdata           ( reg_if_wdata_sync         ),
    .reg_if_valid           ( reg_if_valid_sync         ),
    .reg_if_we              ( reg_if_we_sync            )
    );

endmodule
