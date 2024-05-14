// Copyright (c) 2024 by JLSemi Inc.
// --------------------------------------------------------------------
//
//                     JLSemi
//                     Shanghai, China
//                     Name : Zhiling Guo
//                     Email: zlguo@jlsemi.com
//
// --------------------------------------------------------------------
// --------------------------------------------------------------------
//  Revision History:1.0
//  Date          By            Revision    Design Description
//---------------------------------------------------------------------
//  2024-05-06    zlguo         1.0         ctrl_sys
// --------------------------------------------------------------------
// --------------------------------------------------------------------
module ctrl_sys
(
    input   wire            clk,
    input   wire            rstn,

    input   wire            mdio_in,
    input   wire            mdc,
    output  wire            mdio_out,
    output  wire            mdio_oen
);

    wire    [4 :0]  legal_phy_addr;
    wire    [4 :0]  legal_phy_addr_mask;
    wire    [4 :0]  broadcast_addr;
    wire            broadcast_mode;
    wire            non_zero_detect;
    wire            opendrain_mode;
    wire            watchdog_enable;
    wire            sync_select;

    wire    [20:0]  req_paddr;
    wire            req_pwrite;
    wire            req_psel;
    wire            req_penable;
    wire    [15:0]  req_pwdata;

    wire            req_pready;
    wire    [15:0]  req_prdata;
    wire            req_pslverr;

    mdio_top
    u_mdio
    (
    .clk_200m             (clk                  ),
    .rstn_200m            (rstn                 ),
                                                
    .mdio_in              (mdio_in              ),
    .mdc                  (mdc                  ),
    .mdio_out             (mdio_out             ),
    .mdio_oen             (mdio_oen             ),

    .legal_phy_addr       (legal_phy_addr       ),
    .legal_phy_addr_mask  (legal_phy_addr_mask  ),
    .broadcast_addr       (broadcast_addr       ),
    .broadcast_mode       (broadcast_mode       ),
    .non_zero_detect      (non_zero_detect      ),
    .opendrain_mode       (opendrain_mode       ),
    .watchdog_enable      (watchdog_enable      ),
    .sync_select          (sync_select          ),

    .req_paddr            (req_paddr            ),
    .req_pwrite           (req_pwrite           ),
    .req_psel             (req_psel             ),
    .req_penable          (req_penable          ),
    .req_pwdata           (req_pwdata           ),
    .req_pready           (req_pready           ),
    .req_prdata           (req_prdata           ),
    .req_pslverr          (req_pslverr          )
    );

    top_regfile
    u_top_regfile
    (
    .req_paddr            (req_paddr            ),
    .req_pwrite           (req_pwrite           ),
    .req_psel             (req_psel             ),
    .req_penable          (req_penable          ),
    .req_pwdata           (req_pwdata           ),
    .req_pready           (req_pready           ),
    .req_prdata           (req_prdata           ),
    .req_pslverr          (req_pslverr          ),

    .legal_phy_addr       (legal_phy_addr       ),
    .legal_phy_addr_mask  (legal_phy_addr_mask  ),
    .broadcast_addr       (broadcast_addr       ),
    .broadcast_mode       (broadcast_mode       ),
    .non_zero_detect      (non_zero_detect      ),
    .opendrain_mode       (opendrain_mode       ),
    .watchdog_enable      (watchdog_enable      ),
    .sync_select          (sync_select          )
    );

endmodule
