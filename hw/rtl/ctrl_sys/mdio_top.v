
module mdio_top
(
    input   wire            dft_tpi_clk,
    input   wire            dft_mdio2sync_clk_sel,

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

endmodule
