// --------------------------------------------------------------------
// Copyright (c) 2023 by JLSemi Inc.
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
//  Date          By            Revision    Change Description
//---------------------------------------------------------------------
//  2023-10-06    zlguo         1.0         ApbArbBus
// --------------------------------------------------------------------
// --------------------------------------------------------------------

module ApbArbBus
(
    input           clk,
    input           rstn,
    input   [15:0]  cfg_timeout,
    input           in_use_mdio,
    input           in_use_cpu,

    /* -----------------------------
     mdio apb interface
     ---------------------------- */
    input   [31:0]  mdio_paddr,
    input           mdio_penable,
    input           mdio_psel,
    input           mdio_pwrite,
    input   [31:0]  mdio_pwdata,
    output          mdio_pslverr,
    output          mdio_pready,
    output  [31:0]  mdio_prdata,

    /* -----------------------------
     cpu apb interface
     ---------------------------- */
    input   [31:0]  cpu_paddr,
    input           cpu_penable,
    input           cpu_psel,
    input           cpu_pwrite,
    input   [31:0]  cpu_pwdata,
    output          cpu_pslverr,
    output          cpu_pready,
    output  [31:0]  cpu_prdata,

    /* -----------------------------
     group apb interface
     ---------------------------- */
    output  [20:0]  ieee_paddr,
    output          ieee_psel,
    output          ieee_pwrite,
    output  [15:0]  ieee_pwdata,
    input   [15:0]  ieee_prdata,
    input           ieee_pready,

    output  [18:0]  top_paddr,
    output          top_psel,
    output          top_pwrite,
    output  [15:0]  top_pwdata,
    input   [15:0]  top_prdata,
    input           top_pready,

    output  [18:0]  xgmii_bridge_paddr,
    output          xgmii_bridge_psel,
    output          xgmii_bridge_pwrite,
    output          xgmii_bridge_penable,
    output  [15:0]  xgmii_bridge_pwdata,
    input   [15:0]  xgmii_bridge_prdata,
    input           xgmii_pready,

    output  [18:0]  frontend_paddr,
    output          frontend_psel,
    output          frontend_pwrite,
    output          frontend_penable,
    output  [15:0]  frontend_pwdata,
    input   [15:0]  frontend_prdata,
    input           frontend_pready,

    output  [7 :0]  flash_paddr,
    output          flash_psel,
    output          flash_pwrite,
    output          flash_penable,
    output  [15:0]  flash_pwdata,
    input   [15:0]  flash_prdata,
    input           flash_pready,

    output  [1 :0]  uart_paddr,
    output          uart_psel,
    output          uart_pwrite,
    output          uart_penable,
    output  [15:0]  uart_pwdata,
    input   [15:0]  uart_prdata,
    input           uart_pready,

    output  [7 :0]  debug_paddr,
    output          debug_psel,
    output          debug_pwrite,
    output          debug_penable,
    output  [15:0]  debug_pwdata,
    input   [15:0]  debug_prdata,
    input           debug_pready,

    output  [18:0]  serdes_paddr,
    output          serdes_psel,
    output          serdes_pwrite,
    output          serdes_penable,
    output  [15:0]  serdes_pwdata,
    input   [15:0]  serdes_prdata,
    input           serdes_pready,

    output  [18:0]  gephy_paddr,
    output          gephy_psel,
    output          gephy_pwrite,
    output          gephy_penable,
    output  [15:0]  gephy_pwdata,
    input   [15:0]  gephy_prdata,
    input           gephy_pready,

    output  [18:0]  _2p5g_pcs_paddr,
    output          _2p5g_pcs_psel,
    output          _2p5g_pcs_pwrite,
    output          _2p5g_pcs_penable,
    output  [15:0]  _2p5g_pcs_pwdata,
    input   [15:0]  _2p5g_pcs_prdata,
    input           _2p5g_pcs_pready,
    input           _2p5g_pcs_clk,
    input           _2p5g_pcs_rstn,

    output  [18:0]  _2p5g_pma_paddr,
    output          _2p5g_pma_psel,
    output          _2p5g_pma_pwrite,
    output          _2p5g_pma_penable,
    output  [15:0]  _2p5g_pma_pwdata,
    input   [15:0]  _2p5g_pma_prdata,
    input           _2p5g_pma_pready,
    input           _2p5g_pma_clk,
    input           _2p5g_pma_rstn,

    output  [18:0]  new_analog_paddr,
    output          new_analog_psel,
    output          new_analog_pwrite,
    output          new_analog_penable,
    output  [15:0]  new_analog_pwdata,
    input   [15:0]  new_analog_prdata,
    input           new_analog_pready
);

    /* -----------------------------
     mdio apb interface
     ---------------------------- */
    reg             bus_sel_mdio_undefine;

    reg             in_mdio_latch;
    reg             in_mdio_latch_addr;
    reg             in_mdio_latch_we;
    reg             in_mdio_latch_wdata;

    wire            bus_mdio_sel;

    wire            arb_in_mdio_pready;

    wire            ieee_mdio_prdata_sel;
    wire            top_mdio_prdata_sel;
    wire            xgmii_bridge_mdio_prdata_sel;
    wire            frontend_mdio_prdata_sel; 
    wire            flash_mdio_prdata_sel; 
    wire            uart_mdio_prdata_sel;
    wire            debug_mdio_prdata_sel;
    wire            serdes_mdio_prdata_sel;
    wire            gephy_mdio_prdata_sel;
    wire            _2p5g_pcs_mdio_prdata_sel;
    wire            _2p5g_pma_mdio_prdata_sel;
    wire            new_analog_mdio_prdata_sel;

    wire            arb_in_mdio_err;

    wire    [31:0]  bus_sel_mdio_master_addr;

    wire    [31:0]  bus_sel_mdio_ieee_sel_addr;
    wire    [31:0]  bus_sel_mdio_top_sel_addr;
    wire    [31:0]  bus_sel_mdio_xgmii_bridge_sel_addr;
    wire    [31:0]  bus_sel_mdio_frontend_sel_addr;
    wire    [31:0]  bus_sel_mdio_flash_sel_addr;
    wire    [31:0]  bus_sel_mdio_uart_sel_addr;
    wire    [31:0]  bus_sel_mdio_debug_sel_addr;
    wire    [31:0]  bus_sel_mdio_serdes_sel_addr;
    wire    [31:0]  bus_sel_mdio_gephy_sel_addr;
    wire    [31:0]  bus_sel_mdio__2p5g_pcs_sel_addr;
    wire    [31:0]  bus_sel_mdio__2p5g_pma_sel_addr;
    wire    [31:0]  bus_sel_mdio_new_analog_sel_addr;

    wire            bus_sel_mdio_ieee_sel;
    wire            bus_sel_mdio_top_sel;
    wire            bus_sel_mdio_xgmii_bridge_sel;
    wire            bus_sel_mdio_frontend_sel;
    wire            bus_sel_mdio_flash_sel;
    wire            bus_sel_mdio_uart_sel;
    wire            bus_sel_mdio_debug_sel;
    wire            bus_sel_mdio_serdes_sel;
    wire            bus_sel_mdio_gephy_sel;
    wire            bus_sel_mdio__2p5g_pcs_sel;
    wire            bus_sel_mdio__2p5g_pma_sel;
    wire            bus_sel_mdio_new_analog_sel;

    /* -----------------------------
     cpu apb interface
     ---------------------------- */
    reg             bus_sel_cpu_undefine;

    reg             in_cpu_latch;
    reg             in_cpu_latch_addr;
    reg             in_cpu_latch_we;
    reg             in_cpu_latch_wdata;

    wire            bus_cpu_sel;

    wire            arb_in_cpu_pready;
    
    wire            ieee_cpu_prdata_sel;
    wire            top_cpu_prdata_sel;
    wire            xgmii_bridge_cpu_prdata_sel;
    wire            frontend_cpu_prdata_sel; 
    wire            flash_cpu_prdata_sel; 
    wire            uart_cpu_prdata_sel;
    wire            debug_cpu_prdata_sel;
    wire            serdes_cpu_prdata_sel;
    wire            gephy_cpu_prdata_sel;
    wire            _2p5g_pcs_cpu_prdata_sel;
    wire            _2p5g_pma_cpu_prdata_sel;
    wire            new_analog_cpu_prdata_sel;

    wire            arb_in_cpu_err;

    wire    [31:0]  bus_sel_cpu_master_addr;

    wire    [31:0]  bus_sel_cpu_ieee_sel_addr;
    wire    [31:0]  bus_sel_cpu_top_sel_addr;
    wire    [31:0]  bus_sel_cpu_xgmii_bridge_sel_addr;
    wire    [31:0]  bus_sel_cpu_frontend_sel_addr;
    wire    [31:0]  bus_sel_cpu_flash_sel_addr;
    wire    [31:0]  bus_sel_cpu_uart_sel_addr;
    wire    [31:0]  bus_sel_cpu_debug_sel_addr;
    wire    [31:0]  bus_sel_cpu_serdes_sel_addr;
    wire    [31:0]  bus_sel_cpu_gephy_sel_addr;
    wire    [31:0]  bus_sel_cpu__2p5g_pcs_sel_addr;
    wire    [31:0]  bus_sel_cpu__2p5g_pma_sel_addr;
    wire    [31:0]  bus_sel_cpu_new_analog_sel_addr;

    wire            bus_sel_cpu_ieee_sel;
    wire            bus_sel_cpu_top_sel;
    wire            bus_sel_cpu_xgmii_bridge_sel;
    wire            bus_sel_cpu_frontend_sel;
    wire            bus_sel_cpu_flash_sel;
    wire            bus_sel_cpu_uart_sel;
    wire            bus_sel_cpu_debug_sel;
    wire            bus_sel_cpu_serdes_sel;
    wire            bus_sel_cpu_gephy_sel;
    wire            bus_sel_cpu__2p5g_pcs_sel;
    wire            bus_sel_cpu__2p5g_pma_sel;
    wire            bus_sel_cpu_new_analog_sel;

    /* -----------------------------
     group mdio apb interface
     ---------------------------- */    
    wire    [20:0]  ieee_arb_mdio_paddr;
    wire            ieee_arb_mdio_penable;
    wire            ieee_arb_mdio_psel;
    wire            ieee_arb_mdio_pwrite;
    wire    [31:0]  ieee_arb_mdio_pwdata;
    wire            ieee_arb_mdio_pready;
    wire            ieee_arb_mdio_prdata;
    
    wire    [31:0]  ieee_mdio_paddr;
    wire            ieee_mdio_penable;
    wire            ieee_mdio_psel;
    wire            ieee_mdio_pwrite;
    wire    [31:0]  ieee_mdio_pwdata;
    wire            ieee_mdio_pready;
    wire            ieee_mdio_prdata;

    wire    [20:0]  top_arb_mdio_paddr;
    wire            top_arb_mdio_penable;
    wire            top_arb_mdio_psel;
    wire            top_arb_mdio_pwrite;
    wire    [31:0]  top_arb_mdio_pwdata;
    wire            top_arb_mdio_pready;
    wire            top_arb_mdio_prdata;
    
    wire    [31:0]  top_mdio_paddr;
    wire            top_mdio_penable;
    wire            top_mdio_psel;
    wire            top_mdio_pwrite;
    wire    [31:0]  top_mdio_pwdata;
    wire            top_mdio_pready;
    wire            top_mdio_prdata;

    wire    [20:0]  xgmii_bridge_arb_mdio_paddr;
    wire            xgmii_bridge_arb_mdio_penable;
    wire            xgmii_bridge_arb_mdio_psel;
    wire            xgmii_bridge_arb_mdio_pwrite;
    wire    [31:0]  xgmii_bridge_arb_mdio_pwdata;
    wire            xgmii_bridge_arb_mdio_pready;
    wire            xgmii_bridge_arb_mdio_prdata;
    
    wire    [31:0]  xgmii_bridge_mdio_paddr;
    wire            xgmii_bridge_mdio_penable;
    wire            xgmii_bridge_mdio_psel;
    wire            xgmii_bridge_mdio_pwrite;
    wire    [31:0]  xgmii_bridge_mdio_pwdata;
    wire            xgmii_bridge_mdio_pready;
    wire            xgmii_bridge_mdio_prdata;

    wire    [20:0]  frontend_arb_mdio_paddr;
    wire            frontend_arb_mdio_penable;
    wire            frontend_arb_mdio_psel;
    wire            frontend_arb_mdio_pwrite;
    wire    [31:0]  frontend_arb_mdio_pwdata;
    wire            frontend_arb_mdio_pready;
    wire            frontend_arb_mdio_prdata;
    
    wire    [31:0]  frontend_mdio_paddr;
    wire            frontend_mdio_penable;
    wire            frontend_mdio_psel;
    wire            frontend_mdio_pwrite;
    wire    [31:0]  frontend_mdio_pwdata;
    wire            frontend_mdio_pready;
    wire            frontend_mdio_prdata;

    wire    [20:0]  flash_arb_mdio_paddr;
    wire            flash_arb_mdio_penable;
    wire            flash_arb_mdio_psel;
    wire            flash_arb_mdio_pwrite;
    wire    [31:0]  flash_arb_mdio_pwdata;
    wire            flash_arb_mdio_pready;
    wire            flash_arb_mdio_prdata;
    
    wire    [31:0]  flash_mdio_paddr;
    wire            flash_mdio_penable;
    wire            flash_mdio_psel;
    wire            flash_mdio_pwrite;
    wire    [31:0]  flash_mdio_pwdata;
    wire            flash_mdio_pready;
    wire            flash_mdio_prdata;

    wire    [20:0]  uart_arb_mdio_paddr;
    wire            uart_arb_mdio_penable;
    wire            uart_arb_mdio_psel;
    wire            uart_arb_mdio_pwrite;
    wire    [31:0]  uart_arb_mdio_pwdata;
    wire            uart_arb_mdio_pready;
    wire            uart_arb_mdio_prdata;
    
    wire    [31:0]  uart_mdio_paddr;
    wire            uart_mdio_penable;
    wire            uart_mdio_psel;
    wire            uart_mdio_pwrite;
    wire    [31:0]  uart_mdio_pwdata;
    wire            uart_mdio_pready;
    wire            uart_mdio_prdata;

    wire    [20:0]  debug_arb_mdio_paddr;
    wire            debug_arb_mdio_penable;
    wire            debug_arb_mdio_psel;
    wire            debug_arb_mdio_pwrite;
    wire    [31:0]  debug_arb_mdio_pwdata;
    wire            debug_arb_mdio_pready;
    wire            debug_arb_mdio_prdata;
    
    wire    [31:0]  debug_mdio_paddr;
    wire            debug_mdio_penable;
    wire            debug_mdio_psel;
    wire            debug_mdio_pwrite;
    wire    [31:0]  debug_mdio_pwdata;
    wire            debug_mdio_pready;
    wire            debug_mdio_prdata;

    wire    [20:0]  serdes_arb_mdio_paddr;
    wire            serdes_arb_mdio_penable;
    wire            serdes_arb_mdio_psel;
    wire            serdes_arb_mdio_pwrite;
    wire    [31:0]  serdes_arb_mdio_pwdata;
    wire            serdes_arb_mdio_pready;
    wire            serdes_arb_mdio_prdata;
    
    wire    [31:0]  serdes_mdio_paddr;
    wire            serdes_mdio_penable;
    wire            serdes_mdio_psel;
    wire            serdes_mdio_pwrite;
    wire    [31:0]  serdes_mdio_pwdata;
    wire            serdes_mdio_pready;
    wire            serdes_mdio_prdata;

    wire    [20:0]  gephy_arb_mdio_paddr;
    wire            gephy_arb_mdio_penable;
    wire            gephy_arb_mdio_psel;
    wire            gephy_arb_mdio_pwrite;
    wire    [31:0]  gephy_arb_mdio_pwdata;
    wire            gephy_arb_mdio_pready;
    wire            gephy_arb_mdio_prdata;
    
    wire    [31:0]  gephy_mdio_paddr;
    wire            gephy_mdio_penable;
    wire            gephy_mdio_psel;
    wire            gephy_mdio_pwrite;
    wire    [31:0]  gephy_mdio_pwdata;
    wire            gephy_mdio_pready;
    wire            gephy_mdio_prdata;

    wire    [20:0]  _2p5g_pcs_arb_mdio_paddr;
    wire            _2p5g_pcs_arb_mdio_penable;
    wire            _2p5g_pcs_arb_mdio_psel;
    wire            _2p5g_pcs_arb_mdio_pwrite;
    wire    [31:0]  _2p5g_pcs_arb_mdio_pwdata;
    wire            _2p5g_pcs_arb_mdio_pready;
    wire            _2p5g_pcs_arb_mdio_prdata;
    wire            _2p5g_pcs_arb_mdio_pslverr;

    wire    [31:0]  _2p5g_pcs_mdio_paddr;
    wire            _2p5g_pcs_mdio_penable;
    wire            _2p5g_pcs_mdio_psel;
    wire            _2p5g_pcs_mdio_pwrite;
    wire    [31:0]  _2p5g_pcs_mdio_pwdata;
    wire            _2p5g_pcs_mdio_pready;
    wire            _2p5g_pcs_mdio_prdata;
    wire            _2p5g_pcs_mdio_pslverr;

    wire    [20:0]  _2p5g_pma_arb_mdio_paddr;
    wire            _2p5g_pma_arb_mdio_penable;
    wire            _2p5g_pma_arb_mdio_psel;
    wire            _2p5g_pma_arb_mdio_pwrite;
    wire    [31:0]  _2p5g_pma_arb_mdio_pwdata;
    wire            _2p5g_pma_arb_mdio_pready;
    wire            _2p5g_pma_arb_mdio_prdata;
    wire            _2p5g_pma_arb_mdio_pslverr;

    wire    [31:0]  _2p5g_pma_mdio_paddr;
    wire            _2p5g_pma_mdio_penable;
    wire            _2p5g_pma_mdio_psel;
    wire            _2p5g_pma_mdio_pwrite;
    wire    [31:0]  _2p5g_pma_mdio_pwdata;
    wire            _2p5g_pma_mdio_pready;
    wire            _2p5g_pma_mdio_prdata;
    wire            _2p5g_pma_mdio_pslverr;

    wire    [20:0]  new_analog_arb_mdio_paddr;
    wire            new_analog_arb_mdio_penable;
    wire            new_analog_arb_mdio_psel;
    wire            new_analog_arb_mdio_pwrite;
    wire    [31:0]  new_analog_arb_mdio_pwdata;
    wire            new_analog_arb_mdio_pready;
    wire            new_analog_arb_mdio_prdata;
    
    wire    [31:0]  new_analog_mdio_paddr;
    wire            new_analog_mdio_penable;
    wire            new_analog_mdio_psel;
    wire            new_analog_mdio_pwrite;
    wire    [31:0]  new_analog_mdio_pwdata;
    wire            new_analog_mdio_pready;
    wire            new_analog_mdio_prdata;

    /* -----------------------------
     group cpu apb interface
     ---------------------------- */    
    wire    [20:0]  ieee_arb_cpu_paddr;
    wire            ieee_arb_cpu_penable;
    wire            ieee_arb_cpu_psel;
    wire            ieee_arb_cpu_pwrite;
    wire    [31:0]  ieee_arb_cpu_pwdata;
    wire            ieee_arb_cpu_pready;
    wire            ieee_arb_cpu_prdata;
    
    wire    [31:0]  ieee_cpu_paddr;
    wire            ieee_cpu_penable;
    wire            ieee_cpu_psel;
    wire            ieee_cpu_pwrite;
    wire    [31:0]  ieee_cpu_pwdata;
    wire            ieee_cpu_pready;
    wire            ieee_cpu_prdata;

    wire    [20:0]  top_arb_cpu_paddr;
    wire            top_arb_cpu_penable;
    wire            top_arb_cpu_psel;
    wire            top_arb_cpu_pwrite;
    wire    [31:0]  top_arb_cpu_pwdata;
    wire            top_arb_cpu_pready;
    wire            top_arb_cpu_prdata;
    
    wire    [31:0]  top_cpu_paddr;
    wire            top_cpu_penable;
    wire            top_cpu_psel;
    wire            top_cpu_pwrite;
    wire    [31:0]  top_cpu_pwdata;
    wire            top_cpu_pready;
    wire            top_cpu_prdata;

    wire    [20:0]  xgmii_bridge_arb_cpu_paddr;
    wire            xgmii_bridge_arb_cpu_penable;
    wire            xgmii_bridge_arb_cpu_psel;
    wire            xgmii_bridge_arb_cpu_pwrite;
    wire    [31:0]  xgmii_bridge_arb_cpu_pwdata;
    wire            xgmii_bridge_arb_cpu_pready;
    wire            xgmii_bridge_arb_cpu_prdata;
    
    wire    [31:0]  xgmii_bridge_cpu_paddr;
    wire            xgmii_bridge_cpu_penable;
    wire            xgmii_bridge_cpu_psel;
    wire            xgmii_bridge_cpu_pwrite;
    wire    [31:0]  xgmii_bridge_cpu_pwdata;
    wire            xgmii_bridge_cpu_pready;
    wire            xgmii_bridge_cpu_prdata;

    wire    [20:0]  frontend_arb_cpu_paddr;
    wire            frontend_arb_cpu_penable;
    wire            frontend_arb_cpu_psel;
    wire            frontend_arb_cpu_pwrite;
    wire    [31:0]  frontend_arb_cpu_pwdata;
    wire            frontend_arb_cpu_pready;
    wire            frontend_arb_cpu_prdata;
    
    wire    [31:0]  frontend_cpu_paddr;
    wire            frontend_cpu_penable;
    wire            frontend_cpu_psel;
    wire            frontend_cpu_pwrite;
    wire    [31:0]  frontend_cpu_pwdata;
    wire            frontend_cpu_pready;
    wire            frontend_cpu_prdata;

    wire    [20:0]  flash_arb_cpu_paddr;
    wire            flash_arb_cpu_penable;
    wire            flash_arb_cpu_psel;
    wire            flash_arb_cpu_pwrite;
    wire    [31:0]  flash_arb_cpu_pwdata;
    wire            flash_arb_cpu_pready;
    wire            flash_arb_cpu_prdata;
    
    wire    [31:0]  flash_cpu_paddr;
    wire            flash_cpu_penable;
    wire            flash_cpu_psel;
    wire            flash_cpu_pwrite;
    wire    [31:0]  flash_cpu_pwdata;
    wire            flash_cpu_pready;
    wire            flash_cpu_prdata;

    wire    [20:0]  uart_arb_cpu_paddr;
    wire            uart_arb_cpu_penable;
    wire            uart_arb_cpu_psel;
    wire            uart_arb_cpu_pwrite;
    wire    [31:0]  uart_arb_cpu_pwdata;
    wire            uart_arb_cpu_pready;
    wire            uart_arb_cpu_prdata;
    
    wire    [31:0]  uart_cpu_paddr;
    wire            uart_cpu_penable;
    wire            uart_cpu_psel;
    wire            uart_cpu_pwrite;
    wire    [31:0]  uart_cpu_pwdata;
    wire            uart_cpu_pready;
    wire            uart_cpu_prdata;

    wire    [20:0]  debug_arb_cpu_paddr;
    wire            debug_arb_cpu_penable;
    wire            debug_arb_cpu_psel;
    wire            debug_arb_cpu_pwrite;
    wire    [31:0]  debug_arb_cpu_pwdata;
    wire            debug_arb_cpu_pready;
    wire            debug_arb_cpu_prdata;
    
    wire    [31:0]  debug_cpu_paddr;
    wire            debug_cpu_penable;
    wire            debug_cpu_psel;
    wire            debug_cpu_pwrite;
    wire    [31:0]  debug_cpu_pwdata;
    wire            debug_cpu_pready;
    wire            debug_cpu_prdata;

    wire    [20:0]  serdes_arb_cpu_paddr;
    wire            serdes_arb_cpu_penable;
    wire            serdes_arb_cpu_psel;
    wire            serdes_arb_cpu_pwrite;
    wire    [31:0]  serdes_arb_cpu_pwdata;
    wire            serdes_arb_cpu_pready;
    wire            serdes_arb_cpu_prdata;
    
    wire    [31:0]  serdes_cpu_paddr;
    wire            serdes_cpu_penable;
    wire            serdes_cpu_psel;
    wire            serdes_cpu_pwrite;
    wire    [31:0]  serdes_cpu_pwdata;
    wire            serdes_cpu_pready;
    wire            serdes_cpu_prdata;

    wire    [20:0]  gephy_arb_cpu_paddr;
    wire            gephy_arb_cpu_penable;
    wire            gephy_arb_cpu_psel;
    wire            gephy_arb_cpu_pwrite;
    wire    [31:0]  gephy_arb_cpu_pwdata;
    wire            gephy_arb_cpu_pready;
    wire            gephy_arb_cpu_prdata;
    
    wire    [31:0]  gephy_cpu_paddr;
    wire            gephy_cpu_penable;
    wire            gephy_cpu_psel;
    wire            gephy_cpu_pwrite;
    wire    [31:0]  gephy_cpu_pwdata;
    wire            gephy_cpu_pready;
    wire            gephy_cpu_prdata;

    wire    [20:0]  _2p5g_pcs_arb_cpu_paddr;
    wire            _2p5g_pcs_arb_cpu_penable;
    wire            _2p5g_pcs_arb_cpu_psel;
    wire            _2p5g_pcs_arb_cpu_pwrite;
    wire    [31:0]  _2p5g_pcs_arb_cpu_pwdata;
    wire            _2p5g_pcs_arb_cpu_pready;
    wire            _2p5g_pcs_arb_cpu_prdata;
    wire            _2p5g_pcs_arb_cpu_pslverr;

    wire    [31:0]  _2p5g_pcs_cpu_paddr;
    wire            _2p5g_pcs_cpu_penable;
    wire            _2p5g_pcs_cpu_psel;
    wire            _2p5g_pcs_cpu_pwrite;
    wire    [31:0]  _2p5g_pcs_cpu_pwdata;
    wire            _2p5g_pcs_cpu_pready;
    wire            _2p5g_pcs_cpu_prdata;
    wire            _2p5g_pcs_cpu_pslverr;

    wire    [20:0]  _2p5g_pma_arb_cpu_paddr;
    wire            _2p5g_pma_arb_cpu_penable;
    wire            _2p5g_pma_arb_cpu_psel;
    wire            _2p5g_pma_arb_cpu_pwrite;
    wire    [31:0]  _2p5g_pma_arb_cpu_pwdata;
    wire            _2p5g_pma_arb_cpu_pready;
    wire            _2p5g_pma_arb_cpu_prdata;
    wire            _2p5g_pma_arb_cpu_pslverr;

    wire    [31:0]  _2p5g_pma_cpu_paddr;
    wire            _2p5g_pma_cpu_penable;
    wire            _2p5g_pma_cpu_psel;
    wire            _2p5g_pma_cpu_pwrite;
    wire    [31:0]  _2p5g_pma_cpu_pwdata;
    wire            _2p5g_pma_cpu_pready;
    wire            _2p5g_pma_cpu_prdata;
    wire            _2p5g_pma_cpu_pslverr;

    wire    [20:0]  new_analog_arb_cpu_paddr;
    wire            new_analog_arb_cpu_penable;
    wire            new_analog_arb_cpu_psel;
    wire            new_analog_arb_cpu_pwrite;
    wire    [31:0]  new_analog_arb_cpu_pwdata;
    wire            new_analog_arb_cpu_pready;
    wire            new_analog_arb_cpu_prdata;
    
    wire    [31:0]  new_analog_cpu_paddr;
    wire            new_analog_cpu_penable;
    wire            new_analog_cpu_psel;
    wire            new_analog_cpu_pwrite;
    wire    [31:0]  new_analog_cpu_pwdata;
    wire            new_analog_cpu_pready;
    wire            new_analog_cpu_prdata;

    /* -----------------------------
     mdio apb interface
     ---------------------------- */
    assign  bus_mdio_sel = bus_sel_mdio_ieee_sel           | bus_sel_mdio_top_sel 
                           | bus_sel_mdio_xgmii_bridge_sel | bus_sel_mdio_frontend_sel
                           | bus_sel_mdio_flash_sel        | bus_sel_mdio_uart_sel
                           | bus_sel_mdio_debug_sel        | bus_sel_mdio_serdes_sel
                           | bus_sel_mdio_gephy_sel        | bus_sel_mdio__2p5g_pcs_sel
                           | bus_sel_mdio__2p5g_pma_sel    | bus_sel_mdio_new_analog_sel;

    assign  mdio_pready = bus_sel_mdio_undefine | arb_in_mdio_pready;
    assign  arb_in_mdio_pready = ieee_mdio_pready            | top_mdio_pready
                                | xgmii_bridge_mdio_pready  | frontend_mdio_pready
                                | flash_mdio_pready         | uart_mdio_pready
                                | debug_mdio_pready         | serdes_mdio_pready
                                | gephy_mdio_pready         | _2p5g_pcs_mdio_pready
                                | _2p5g_pma_mdio_pready     | new_analog_mdio_pready;

    assign  mdio_prdata = ieee_mdio_prdata_sel         ? ieee_mdio_prdata             :
                          top_mdio_prdata_sel          ? top_mdio_prdata_sel          :
                          xgmii_bridge_mdio_prdata_sel ? xgmii_bridge_mdio_prdata_sel :
                          frontend_mdio_prdata_sel     ? frontend_mdio_prdata_sel     :
                          flash_mdio_prdata_sel        ? flash_mdio_prdata_sel        :
                          uart_mdio_prdata_sel         ? uart_mdio_prdata_sel         :
                          debug_mdio_prdata_sel        ? debug_mdio_prdata_sel        :
                          serdes_mdio_prdata_sel       ? serdes_mdio_prdata_sel       :
                          gephy_mdio_prdata_sel        ? gephy_mdio_prdata_sel        :
                          _2p5g_pcs_mdio_prdata_sel    ? _2p5g_pcs_mdio_prdata_sel    :
                          _2p5g_pma_mdio_prdata_sel    ? _2p5g_pma_mdio_prdata_sel    :
                          new_analog_mdio_prdata_sel   ? new_analog_mdio_prdata_sel   : 32'h0;

    assign  ieee_mdio_prdata_sel         =   ieee_mdio_pready         & bus_sel_mdio_ieee_sel;
    assign  top_mdio_prdata_sel          =   top_mdio_pready          & bus_sel_mdio_top_sel;
    assign  xgmii_bridge_mdio_prdata_sel =   xgmii_bridge_mdio_pready & bus_sel_mdio_xgmii_bridge_sel;
    assign  frontend_mdio_prdata_sel     =   frontend_mdio_pready     & bus_sel_mdio_frontend_sel;
    assign  flash_mdio_prdata_sel        =   flash_mdio_pready        & bus_sel_mdio_flash_sel;
    assign  uart_mdio_prdata_sel         =   uart_mdio_pready         & bus_sel_mdio_uart_sel;
    assign  debug_mdio_prdata_sel        =   debug_mdio_pready        & bus_sel_mdio_debug_sel;
    assign  serdes_mdio_prdata_sel       =   serdes_mdio_pready       & bus_sel_mdio_serdes_sel;
    assign  gephy_mdio_prdata_sel        =   gephy_mdio_pready        & bus_sel_mdio_gephy_sel;
    assign  _2p5g_pcs_mdio_prdata_sel    =   _2p5g_pcs_mdio_pready    & bus_sel_mdio__2p5g_pcs_sel;
    assign  _2p5g_pma_mdio_prdata_sel    =   _2p5g_pma_mdio_pready    & bus_sel_mdio__2p5g_pma_sel;
    assign  new_analog_mdio_prdata_sel   =   new_analog_mdio_pready   & bus_sel_mdio_new_analog_sel;

    assign  mdio_pslverr = bus_sel_mdio_undefine | arb_in_mdio_err;
    assign  arb_in_mdio_err = _2p5g_pcs_mdio_pslverr | _2p5g_pma_mdio_pslverr;

    assign  bus_sel_mdio_master_addr = in_mdio_latch ? in_mdio_latch_addr : mdio_paddr;

    always @(posedge clk or negedge rstn)
    begin
        if(~rstn)
            bus_sel_mdio_undefine <= 1'b0;
        else
            bus_sel_mdio_undefine <= mdio_psel & ~bus_mdio_sel;
    end

    always @(posedge clk or negedge rstn)
    begin
        if(~rstn)
            in_mdio_latch <= 1'b0;
        else if (mdio_pready)
            in_mdio_latch <= 1'b0;
        else
            in_mdio_latch <= mdio_penable & mdio_psel | in_mdio_latch;
    end

    always @(posedge clk or negedge rstn)
    begin
        if(~rstn) begin
            in_mdio_latch_addr  <= 32'h0;
            in_mdio_latch_we    <= 1'b0;
            in_mdio_latch_wdata <= 32'h0;
        end
        else if (mdio_pready) begin
            in_mdio_latch_addr  <= 32'h0;
            in_mdio_latch_we    <= 1'b0;
            in_mdio_latch_wdata <= 32'h0;
        end
        else if (mdio_penable & mdio_psel) begin
            in_mdio_latch_addr  <= mdio_paddr;
            in_mdio_latch_we    <= mdio_pwrite;
            in_mdio_latch_wdata <= mdio_pwdata;
        end
    end

    /* -----------------------------
     cpu apb interface
     ---------------------------- */
    assign  bus_cpu_sel = bus_sel_cpu_ieee_sel           | bus_sel_cpu_top_sel 
                           | bus_sel_cpu_xgmii_bridge_sel | bus_sel_cpu_frontend_sel
                           | bus_sel_cpu_flash_sel        | bus_sel_cpu_uart_sel
                           | bus_sel_cpu_debug_sel        | bus_sel_cpu_serdes_sel
                           | bus_sel_cpu_gephy_sel        | bus_sel_cpu__2p5g_pcs_sel
                           | bus_sel_cpu__2p5g_pma_sel    | bus_sel_cpu_new_analog_sel;

    assign  cpu_pready = bus_sel_cpu_undefine | arb_in_cpu_pready;
    assign  arb_in_cpu_pready = ieee_cpu_pready            | top_cpu_pready
                               | xgmii_bridge_cpu_pready  | frontend_cpu_pready
                               | flash_cpu_pready         | uart_cpu_pready
                               | debug_cpu_pready         | serdes_cpu_pready
                               | gephy_cpu_pready         | _2p5g_pcs_cpu_pready
                               | _2p5g_pma_cpu_pready     | new_analog_cpu_pready;

    assign  cpu_prdata = ieee_cpu_prdata_sel         ? ieee_cpu_prdata             :
                          top_cpu_prdata_sel          ? top_cpu_prdata_sel          :
                          xgmii_bridge_cpu_prdata_sel ? xgmii_bridge_cpu_prdata_sel :
                          frontend_cpu_prdata_sel     ? frontend_cpu_prdata_sel     :
                          flash_cpu_prdata_sel        ? flash_cpu_prdata_sel        :
                          uart_cpu_prdata_sel         ? uart_cpu_prdata_sel         :
                          debug_cpu_prdata_sel        ? debug_cpu_prdata_sel        :
                          serdes_cpu_prdata_sel       ? serdes_cpu_prdata_sel       :
                          gephy_cpu_prdata_sel        ? gephy_cpu_prdata_sel        :
                          _2p5g_pcs_cpu_prdata_sel    ? _2p5g_pcs_cpu_prdata_sel    :
                          _2p5g_pma_cpu_prdata_sel    ? _2p5g_pma_cpu_prdata_sel    :
                          new_analog_cpu_prdata_sel   ? new_analog_cpu_prdata_sel   : 32'h0;

    assign  ieee_cpu_prdata_sel         =   ieee_cpu_pready         & bus_sel_cpu_ieee_sel;
    assign  top_cpu_prdata_sel          =   top_cpu_pready          & bus_sel_cpu_top_sel;
    assign  xgmii_bridge_cpu_prdata_sel =   xgmii_bridge_cpu_pready & bus_sel_cpu_xgmii_bridge_sel;
    assign  frontend_cpu_prdata_sel     =   frontend_cpu_pready     & bus_sel_cpu_frontend_sel;
    assign  flash_cpu_prdata_sel        =   flash_cpu_pready        & bus_sel_cpu_flash_sel;
    assign  uart_cpu_prdata_sel         =   uart_cpu_pready         & bus_sel_cpu_uart_sel;
    assign  debug_cpu_prdata_sel        =   debug_cpu_pready        & bus_sel_cpu_debug_sel;
    assign  serdes_cpu_prdata_sel       =   serdes_cpu_pready       & bus_sel_cpu_serdes_sel;
    assign  gephy_cpu_prdata_sel        =   gephy_cpu_pready        & bus_sel_cpu_gephy_sel;
    assign  _2p5g_pcs_cpu_prdata_sel    =   _2p5g_pcs_cpu_pready    & bus_sel_cpu__2p5g_pcs_sel;
    assign  _2p5g_pma_cpu_prdata_sel    =   _2p5g_pma_cpu_pready    & bus_sel_cpu__2p5g_pma_sel;
    assign  new_analog_cpu_prdata_sel   =   new_analog_cpu_pready   & bus_sel_cpu_new_analog_sel;

    assign  cpu_pslverr = bus_sel_cpu_undefine | arb_in_cpu_err;
    assign  arb_in_cpu_err = _2p5g_pcs_cpu_pslverr | _2p5g_pma_cpu_pslverr;

    assign  bus_sel_cpu_master_addr = in_cpu_latch ? in_cpu_latch_addr : cpu_paddr;

    always @(posedge clk or negedge rstn)
    begin
        if(~rstn)
            bus_sel_cpu_undefine <= 1'b0;
        else
            bus_sel_cpu_undefine <= cpu_psel & ~bus_cpu_sel;
    end

    always @(posedge clk or negedge rstn)
    begin
        if(~rstn)
            in_cpu_latch <= 1'b0;
        else if (cpu_pready)
            in_cpu_latch <= 1'b0;
        else
            in_cpu_latch <= cpu_penable & cpu_psel | in_cpu_latch;
    end

    always @(posedge clk or negedge rstn)
    begin
        if(~rstn) begin
            in_cpu_latch_addr  <= 32'h0;
            in_cpu_latch_we    <= 1'b0;
            in_cpu_latch_wdata <= 32'h0;
        end
        else if (cpu_pready) begin
            in_cpu_latch_addr  <= 32'h0;
            in_cpu_latch_we    <= 1'b0;
            in_cpu_latch_wdata <= 32'h0;
        end
        else if (cpu_penable & cpu_psel) begin
            in_cpu_latch_addr  <= cpu_paddr;
            in_cpu_latch_we    <= cpu_pwrite;
            in_cpu_latch_wdata <= cpu_pwdata;
        end
    end

    /* -----------------------------
     group apb mdio interface
     ---------------------------- */    
    assign  ieee_arb_mdio_paddr     =   ieee_mdio_paddr[20:0];
    assign  ieee_arb_mdio_penable   =   ieee_mdio_penable;
    assign  ieee_arb_mdio_psel      =   ieee_mdio_psel;
    assign  ieee_arb_mdio_pwrite    =   ieee_mdio_pwrite;
    assign  ieee_arb_mdio_pwdata    =   ieee_mdio_pwdata;

    assign  ieee_mdio_paddr     =   in_mdio_latch ? in_mdio_latch_addr : bus_sel_cpu_ieee_sel_addr;
    assign  ieee_mdio_penable   =   in_mdio_latch | mdio_penable;
    assign  ieee_mdio_psel      =   (in_mdio_latch | mdio_psel) & bus_sel_cpu_ieee_sel;
    assign  ieee_mdio_pwrite    =   in_mdio_latch ? in_mdio_latch_we : mdio_pwrite;
    assign  ieee_mdio_pwdata    =   in_mdio_latch ? in_mdio_latch_wdata : mdio_pwdata;
    assign  ieee_mdio_pready    =   ieee_arb_mdio_pready;
    assign  ieee_mdio_prdata    =   ieee_arb_mdio_prdata;

    assign  top_arb_mdio_paddr     =   top_mdio_paddr[20:0];
    assign  top_arb_mdio_penable   =   top_mdio_penable;
    assign  top_arb_mdio_psel      =   top_mdio_psel;
    assign  top_arb_mdio_pwrite    =   top_mdio_pwrite;
    assign  top_arb_mdio_pwdata    =   top_mdio_pwdata;

    assign  top_mdio_paddr     =   in_mdio_latch ? in_mdio_latch_addr : bus_sel_cpu_top_sel_addr;
    assign  top_mdio_penable   =   in_mdio_latch | mdio_penable;
    assign  top_mdio_psel      =   (in_mdio_latch | mdio_psel) & bus_sel_cpu_top_sel;
    assign  top_mdio_pwrite    =   in_mdio_latch ? in_mdio_latch_we : mdio_pwrite;
    assign  top_mdio_pwdata    =   in_mdio_latch ? in_mdio_latch_wdata : mdio_pwdata;
    assign  top_mdio_pready    =   top_arb_mdio_pready;
    assign  top_mdio_prdata    =   top_arb_mdio_prdata;

    assign  xgmii_bridge_arb_mdio_paddr     =   xgmii_bridge_mdio_paddr[20:0];
    assign  xgmii_bridge_arb_mdio_penable   =   xgmii_bridge_mdio_penable;
    assign  xgmii_bridge_arb_mdio_psel      =   xgmii_bridge_mdio_psel;
    assign  xgmii_bridge_arb_mdio_pwrite    =   xgmii_bridge_mdio_pwrite;
    assign  xgmii_bridge_arb_mdio_pwdata    =   xgmii_bridge_mdio_pwdata;

    assign  xgmii_bridge_mdio_paddr     =   in_mdio_latch ? in_mdio_latch_addr : bus_sel_cpu_xgmii_bridge_sel_addr;
    assign  xgmii_bridge_mdio_penable   =   in_mdio_latch | mdio_penable;
    assign  xgmii_bridge_mdio_psel      =   (in_mdio_latch | mdio_psel) & bus_sel_cpu_xgmii_bridge_sel;
    assign  xgmii_bridge_mdio_pwrite    =   in_mdio_latch ? in_mdio_latch_we : mdio_pwrite;
    assign  xgmii_bridge_mdio_pwdata    =   in_mdio_latch ? in_mdio_latch_wdata : mdio_pwdata;
    assign  xgmii_bridge_mdio_pready    =   xgmii_bridge_arb_mdio_pready;
    assign  xgmii_bridge_mdio_prdata    =   xgmii_bridge_arb_mdio_prdata;

    assign  frontend_arb_mdio_paddr     =   frontend_mdio_paddr[20:0];
    assign  frontend_arb_mdio_penable   =   frontend_mdio_penable;
    assign  frontend_arb_mdio_psel      =   frontend_mdio_psel;
    assign  frontend_arb_mdio_pwrite    =   frontend_mdio_pwrite;
    assign  frontend_arb_mdio_pwdata    =   frontend_mdio_pwdata;

    assign  frontend_mdio_paddr     =   in_mdio_latch ? in_mdio_latch_addr : bus_sel_cpu_frontend_sel_addr;
    assign  frontend_mdio_penable   =   in_mdio_latch | mdio_penable;
    assign  frontend_mdio_psel      =   (in_mdio_latch | mdio_psel) & bus_sel_cpu_frontend_sel;
    assign  frontend_mdio_pwrite    =   in_mdio_latch ? in_mdio_latch_we : mdio_pwrite;
    assign  frontend_mdio_pwdata    =   in_mdio_latch ? in_mdio_latch_wdata : mdio_pwdata;
    assign  frontend_mdio_pready    =   frontend_arb_mdio_pready;
    assign  frontend_mdio_prdata    =   frontend_arb_mdio_prdata;

    assign  flash_arb_mdio_paddr     =   flash_mdio_paddr[20:0];
    assign  flash_arb_mdio_penable   =   flash_mdio_penable;
    assign  flash_arb_mdio_psel      =   flash_mdio_psel;
    assign  flash_arb_mdio_pwrite    =   flash_mdio_pwrite;
    assign  flash_arb_mdio_pwdata    =   flash_mdio_pwdata;

    assign  flash_mdio_paddr     =   in_mdio_latch ? in_mdio_latch_addr : bus_sel_cpu_flash_sel_addr;
    assign  flash_mdio_penable   =   in_mdio_latch | mdio_penable;
    assign  flash_mdio_psel      =   (in_mdio_latch | mdio_psel) & bus_sel_cpu_flash_sel;
    assign  flash_mdio_pwrite    =   in_mdio_latch ? in_mdio_latch_we : mdio_pwrite;
    assign  flash_mdio_pwdata    =   in_mdio_latch ? in_mdio_latch_wdata : mdio_pwdata;
    assign  flash_mdio_pready    =   flash_arb_mdio_pready;
    assign  flash_mdio_prdata    =   flash_arb_mdio_prdata;

    assign  uart_arb_mdio_paddr     =   uart_mdio_paddr[20:0];
    assign  uart_arb_mdio_penable   =   uart_mdio_penable;
    assign  uart_arb_mdio_psel      =   uart_mdio_psel;
    assign  uart_arb_mdio_pwrite    =   uart_mdio_pwrite;
    assign  uart_arb_mdio_pwdata    =   uart_mdio_pwdata;

    assign  uart_mdio_paddr     =   in_mdio_latch ? in_mdio_latch_addr : bus_sel_cpu_uart_sel_addr;
    assign  uart_mdio_penable   =   in_mdio_latch | mdio_penable;
    assign  uart_mdio_psel      =   (in_mdio_latch | mdio_psel) & bus_sel_cpu_uart_sel;
    assign  uart_mdio_pwrite    =   in_mdio_latch ? in_mdio_latch_we : mdio_pwrite;
    assign  uart_mdio_pwdata    =   in_mdio_latch ? in_mdio_latch_wdata : mdio_pwdata;
    assign  uart_mdio_pready    =   uart_arb_mdio_pready;
    assign  uart_mdio_prdata    =   uart_arb_mdio_prdata;

    assign  debug_arb_mdio_paddr     =   debug_mdio_paddr[20:0];
    assign  debug_arb_mdio_penable   =   debug_mdio_penable;
    assign  debug_arb_mdio_psel      =   debug_mdio_psel;
    assign  debug_arb_mdio_pwrite    =   debug_mdio_pwrite;
    assign  debug_arb_mdio_pwdata    =   debug_mdio_pwdata;

    assign  debug_mdio_paddr     =   in_mdio_latch ? in_mdio_latch_addr : bus_sel_cpu_debug_sel_addr;
    assign  debug_mdio_penable   =   in_mdio_latch | mdio_penable;
    assign  debug_mdio_psel      =   (in_mdio_latch | mdio_psel) & bus_sel_cpu_debug_sel;
    assign  debug_mdio_pwrite    =   in_mdio_latch ? in_mdio_latch_we : mdio_pwrite;
    assign  debug_mdio_pwdata    =   in_mdio_latch ? in_mdio_latch_wdata : mdio_pwdata;
    assign  debug_mdio_pready    =   debug_arb_mdio_pready;
    assign  debug_mdio_prdata    =   debug_arb_mdio_prdata;

    assign  serdes_arb_mdio_paddr     =   serdes_mdio_paddr[20:0];
    assign  serdes_arb_mdio_penable   =   serdes_mdio_penable;
    assign  serdes_arb_mdio_psel      =   serdes_mdio_psel;
    assign  serdes_arb_mdio_pwrite    =   serdes_mdio_pwrite;
    assign  serdes_arb_mdio_pwdata    =   serdes_mdio_pwdata;

    assign  serdes_mdio_paddr     =   in_mdio_latch ? in_mdio_latch_addr : bus_sel_cpu_serdes_sel_addr;
    assign  serdes_mdio_penable   =   in_mdio_latch | mdio_penable;
    assign  serdes_mdio_psel      =   (in_mdio_latch | mdio_psel) & bus_sel_cpu_serdes_sel;
    assign  serdes_mdio_pwrite    =   in_mdio_latch ? in_mdio_latch_we : mdio_pwrite;
    assign  serdes_mdio_pwdata    =   in_mdio_latch ? in_mdio_latch_wdata : mdio_pwdata;
    assign  serdes_mdio_pready    =   serdes_arb_mdio_pready;
    assign  serdes_mdio_prdata    =   serdes_arb_mdio_prdata;

    assign  gephy_arb_mdio_paddr     =   gephy_mdio_paddr[20:0];
    assign  gephy_arb_mdio_penable   =   gephy_mdio_penable;
    assign  gephy_arb_mdio_psel      =   gephy_mdio_psel;
    assign  gephy_arb_mdio_pwrite    =   gephy_mdio_pwrite;
    assign  gephy_arb_mdio_pwdata    =   gephy_mdio_pwdata;

    assign  gephy_mdio_paddr     =   in_mdio_latch ? in_mdio_latch_addr : bus_sel_cpu_gephy_sel_addr;
    assign  gephy_mdio_penable   =   in_mdio_latch | mdio_penable;
    assign  gephy_mdio_psel      =   (in_mdio_latch | mdio_psel) & bus_sel_cpu_gephy_sel;
    assign  gephy_mdio_pwrite    =   in_mdio_latch ? in_mdio_latch_we : mdio_pwrite;
    assign  gephy_mdio_pwdata    =   in_mdio_latch ? in_mdio_latch_wdata : mdio_pwdata;
    assign  gephy_mdio_pready    =   gephy_arb_mdio_pready;
    assign  gephy_mdio_prdata    =   gephy_arb_mdio_prdata;

    assign  _2p5g_pcs_arb_mdio_paddr     =   _2p5g_pcs_mdio_paddr[20:0];
    assign  _2p5g_pcs_arb_mdio_penable   =   _2p5g_pcs_mdio_penable;
    assign  _2p5g_pcs_arb_mdio_psel      =   _2p5g_pcs_mdio_psel;
    assign  _2p5g_pcs_arb_mdio_pwrite    =   _2p5g_pcs_mdio_pwrite;
    assign  _2p5g_pcs_arb_mdio_pwdata    =   _2p5g_pcs_mdio_pwdata;

    assign  _2p5g_pcs_mdio_paddr     =   in_mdio_latch ? in_mdio_latch_addr : bus_sel_cpu__2p5g_pcs_sel_addr;
    assign  _2p5g_pcs_mdio_penable   =   in_mdio_latch | mdio_penable;
    assign  _2p5g_pcs_mdio_psel      =   (in_mdio_latch | mdio_psel) & bus_sel_cpu__2p5g_pcs_sel;
    assign  _2p5g_pcs_mdio_pwrite    =   in_mdio_latch ? in_mdio_latch_we : mdio_pwrite;
    assign  _2p5g_pcs_mdio_pwdata    =   in_mdio_latch ? in_mdio_latch_wdata : mdio_pwdata;
    assign  _2p5g_pcs_mdio_pready    =   _2p5g_pcs_arb_mdio_pready;
    assign  _2p5g_pcs_mdio_prdata    =   _2p5g_pcs_arb_mdio_prdata;
    assign  _2p5g_pcs_mdio_pslverr   =   _2p5g_pcs_arb_mdio_pslverr;

    assign  _2p5g_pma_arb_mdio_paddr     =   _2p5g_pma_mdio_paddr[20:0];
    assign  _2p5g_pma_arb_mdio_penable   =   _2p5g_pma_mdio_penable;
    assign  _2p5g_pma_arb_mdio_psel      =   _2p5g_pma_mdio_psel;
    assign  _2p5g_pma_arb_mdio_pwrite    =   _2p5g_pma_mdio_pwrite;
    assign  _2p5g_pma_arb_mdio_pwdata    =   _2p5g_pma_mdio_pwdata;

    assign  _2p5g_pma_mdio_paddr     =   in_mdio_latch ? in_mdio_latch_addr : bus_sel_cpu__2p5g_pma_sel_addr;
    assign  _2p5g_pma_mdio_penable   =   in_mdio_latch | mdio_penable;
    assign  _2p5g_pma_mdio_psel      =   (in_mdio_latch | mdio_psel) & bus_sel_cpu__2p5g_pma_sel;
    assign  _2p5g_pma_mdio_pwrite    =   in_mdio_latch ? in_mdio_latch_we : mdio_pwrite;
    assign  _2p5g_pma_mdio_pwdata    =   in_mdio_latch ? in_mdio_latch_wdata : mdio_pwdata;
    assign  _2p5g_pma_mdio_pready    =   _2p5g_pma_arb_mdio_pready;
    assign  _2p5g_pma_mdio_prdata    =   _2p5g_pma_arb_mdio_prdata;
    assign  _2p5g_pma_mdio_pslverr   =   _2p5g_pma_arb_mdio_pslverr;

    assign  new_analog_arb_mdio_paddr     =   new_analog_mdio_paddr[20:0];
    assign  new_analog_arb_mdio_penable   =   new_analog_mdio_penable;
    assign  new_analog_arb_mdio_psel      =   new_analog_mdio_psel;
    assign  new_analog_arb_mdio_pwrite    =   new_analog_mdio_pwrite;
    assign  new_analog_arb_mdio_pwdata    =   new_analog_mdio_pwdata;

    assign  new_analog_mdio_paddr     =   in_mdio_latch ? in_mdio_latch_addr : bus_sel_cpu_new_analog_sel_addr;
    assign  new_analog_mdio_penable   =   in_mdio_latch | mdio_penable;
    assign  new_analog_mdio_psel      =   (in_mdio_latch | mdio_psel) & bus_sel_cpu_new_analog_sel;
    assign  new_analog_mdio_pwrite    =   in_mdio_latch ? in_mdio_latch_we : mdio_pwrite;
    assign  new_analog_mdio_pwdata    =   in_mdio_latch ? in_mdio_latch_wdata : mdio_pwdata;
    assign  new_analog_mdio_pready    =   new_analog_arb_mdio_pready;
    assign  new_analog_mdio_prdata    =   new_analog_arb_mdio_prdata;

    /* -----------------------------
     group apb cpu interface
     ---------------------------- */    
    assign  ieee_arb_cpu_paddr     =   ieee_cpu_paddr[20:0];
    assign  ieee_arb_cpu_penable   =   ieee_cpu_penable;
    assign  ieee_arb_cpu_psel      =   ieee_cpu_psel;
    assign  ieee_arb_cpu_pwrite    =   ieee_cpu_pwrite;
    assign  ieee_arb_cpu_pwdata    =   ieee_cpu_pwdata;

    assign  ieee_cpu_paddr     =   in_cpu_latch ? in_cpu_latch_addr : bus_sel_cpu_ieee_sel_addr;
    assign  ieee_cpu_penable   =   in_cpu_latch | cpu_penable;
    assign  ieee_cpu_psel      =   (in_cpu_latch | cpu_psel) & bus_sel_cpu_ieee_sel;
    assign  ieee_cpu_pwrite    =   in_cpu_latch ? in_cpu_latch_we : cpu_pwrite;
    assign  ieee_cpu_pwdata    =   in_cpu_latch ? in_cpu_latch_wdata : cpu_pwdata;
    assign  ieee_cpu_pready    =   ieee_arb_cpu_pready;
    assign  ieee_cpu_prdata    =   ieee_arb_cpu_prdata;

    assign  top_arb_cpu_paddr     =   top_cpu_paddr[20:0];
    assign  top_arb_cpu_penable   =   top_cpu_penable;
    assign  top_arb_cpu_psel      =   top_cpu_psel;
    assign  top_arb_cpu_pwrite    =   top_cpu_pwrite;
    assign  top_arb_cpu_pwdata    =   top_cpu_pwdata;

    assign  top_cpu_paddr     =   in_cpu_latch ? in_cpu_latch_addr : bus_sel_cpu_top_sel_addr;
    assign  top_cpu_penable   =   in_cpu_latch | cpu_penable;
    assign  top_cpu_psel      =   (in_cpu_latch | cpu_psel) & bus_sel_cpu_top_sel;
    assign  top_cpu_pwrite    =   in_cpu_latch ? in_cpu_latch_we : cpu_pwrite;
    assign  top_cpu_pwdata    =   in_cpu_latch ? in_cpu_latch_wdata : cpu_pwdata;
    assign  top_cpu_pready    =   top_arb_cpu_pready;
    assign  top_cpu_prdata    =   top_arb_cpu_prdata;

    assign  xgmii_bridge_arb_cpu_paddr     =   xgmii_bridge_cpu_paddr[20:0];
    assign  xgmii_bridge_arb_cpu_penable   =   xgmii_bridge_cpu_penable;
    assign  xgmii_bridge_arb_cpu_psel      =   xgmii_bridge_cpu_psel;
    assign  xgmii_bridge_arb_cpu_pwrite    =   xgmii_bridge_cpu_pwrite;
    assign  xgmii_bridge_arb_cpu_pwdata    =   xgmii_bridge_cpu_pwdata;

    assign  xgmii_bridge_cpu_paddr     =   in_cpu_latch ? in_cpu_latch_addr : bus_sel_cpu_xgmii_bridge_sel_addr;
    assign  xgmii_bridge_cpu_penable   =   in_cpu_latch | cpu_penable;
    assign  xgmii_bridge_cpu_psel      =   (in_cpu_latch | cpu_psel) & bus_sel_cpu_xgmii_bridge_sel;
    assign  xgmii_bridge_cpu_pwrite    =   in_cpu_latch ? in_cpu_latch_we : cpu_pwrite;
    assign  xgmii_bridge_cpu_pwdata    =   in_cpu_latch ? in_cpu_latch_wdata : cpu_pwdata;
    assign  xgmii_bridge_cpu_pready    =   xgmii_bridge_arb_cpu_pready;
    assign  xgmii_bridge_cpu_prdata    =   xgmii_bridge_arb_cpu_prdata;

    assign  frontend_arb_cpu_paddr     =   frontend_cpu_paddr[20:0];
    assign  frontend_arb_cpu_penable   =   frontend_cpu_penable;
    assign  frontend_arb_cpu_psel      =   frontend_cpu_psel;
    assign  frontend_arb_cpu_pwrite    =   frontend_cpu_pwrite;
    assign  frontend_arb_cpu_pwdata    =   frontend_cpu_pwdata;

    assign  frontend_cpu_paddr     =   in_cpu_latch ? in_cpu_latch_addr : bus_sel_cpu_frontend_sel_addr;
    assign  frontend_cpu_penable   =   in_cpu_latch | cpu_penable;
    assign  frontend_cpu_psel      =   (in_cpu_latch | cpu_psel) & bus_sel_cpu_frontend_sel;
    assign  frontend_cpu_pwrite    =   in_cpu_latch ? in_cpu_latch_we : cpu_pwrite;
    assign  frontend_cpu_pwdata    =   in_cpu_latch ? in_cpu_latch_wdata : cpu_pwdata;
    assign  frontend_cpu_pready    =   frontend_arb_cpu_pready;
    assign  frontend_cpu_prdata    =   frontend_arb_cpu_prdata;

    assign  flash_arb_cpu_paddr     =   flash_cpu_paddr[20:0];
    assign  flash_arb_cpu_penable   =   flash_cpu_penable;
    assign  flash_arb_cpu_psel      =   flash_cpu_psel;
    assign  flash_arb_cpu_pwrite    =   flash_cpu_pwrite;
    assign  flash_arb_cpu_pwdata    =   flash_cpu_pwdata;

    assign  flash_cpu_paddr     =   in_cpu_latch ? in_cpu_latch_addr : bus_sel_cpu_flash_sel_addr;
    assign  flash_cpu_penable   =   in_cpu_latch | cpu_penable;
    assign  flash_cpu_psel      =   (in_cpu_latch | cpu_psel) & bus_sel_cpu_flash_sel;
    assign  flash_cpu_pwrite    =   in_cpu_latch ? in_cpu_latch_we : cpu_pwrite;
    assign  flash_cpu_pwdata    =   in_cpu_latch ? in_cpu_latch_wdata : cpu_pwdata;
    assign  flash_cpu_pready    =   flash_arb_cpu_pready;
    assign  flash_cpu_prdata    =   flash_arb_cpu_prdata;

    assign  uart_arb_cpu_paddr     =   uart_cpu_paddr[20:0];
    assign  uart_arb_cpu_penable   =   uart_cpu_penable;
    assign  uart_arb_cpu_psel      =   uart_cpu_psel;
    assign  uart_arb_cpu_pwrite    =   uart_cpu_pwrite;
    assign  uart_arb_cpu_pwdata    =   uart_cpu_pwdata;

    assign  uart_cpu_paddr     =   in_cpu_latch ? in_cpu_latch_addr : bus_sel_cpu_uart_sel_addr;
    assign  uart_cpu_penable   =   in_cpu_latch | cpu_penable;
    assign  uart_cpu_psel      =   (in_cpu_latch | cpu_psel) & bus_sel_cpu_uart_sel;
    assign  uart_cpu_pwrite    =   in_cpu_latch ? in_cpu_latch_we : cpu_pwrite;
    assign  uart_cpu_pwdata    =   in_cpu_latch ? in_cpu_latch_wdata : cpu_pwdata;
    assign  uart_cpu_pready    =   uart_arb_cpu_pready;
    assign  uart_cpu_prdata    =   uart_arb_cpu_prdata;

    assign  debug_arb_cpu_paddr     =   debug_cpu_paddr[20:0];
    assign  debug_arb_cpu_penable   =   debug_cpu_penable;
    assign  debug_arb_cpu_psel      =   debug_cpu_psel;
    assign  debug_arb_cpu_pwrite    =   debug_cpu_pwrite;
    assign  debug_arb_cpu_pwdata    =   debug_cpu_pwdata;

    assign  debug_cpu_paddr     =   in_cpu_latch ? in_cpu_latch_addr : bus_sel_cpu_debug_sel_addr;
    assign  debug_cpu_penable   =   in_cpu_latch | cpu_penable;
    assign  debug_cpu_psel      =   (in_cpu_latch | cpu_psel) & bus_sel_cpu_debug_sel;
    assign  debug_cpu_pwrite    =   in_cpu_latch ? in_cpu_latch_we : cpu_pwrite;
    assign  debug_cpu_pwdata    =   in_cpu_latch ? in_cpu_latch_wdata : cpu_pwdata;
    assign  debug_cpu_pready    =   debug_arb_cpu_pready;
    assign  debug_cpu_prdata    =   debug_arb_cpu_prdata;

    assign  serdes_arb_cpu_paddr     =   serdes_cpu_paddr[20:0];
    assign  serdes_arb_cpu_penable   =   serdes_cpu_penable;
    assign  serdes_arb_cpu_psel      =   serdes_cpu_psel;
    assign  serdes_arb_cpu_pwrite    =   serdes_cpu_pwrite;
    assign  serdes_arb_cpu_pwdata    =   serdes_cpu_pwdata;

    assign  serdes_cpu_paddr     =   in_cpu_latch ? in_cpu_latch_addr : bus_sel_cpu_serdes_sel_addr;
    assign  serdes_cpu_penable   =   in_cpu_latch | cpu_penable;
    assign  serdes_cpu_psel      =   (in_cpu_latch | cpu_psel) & bus_sel_cpu_serdes_sel;
    assign  serdes_cpu_pwrite    =   in_cpu_latch ? in_cpu_latch_we : cpu_pwrite;
    assign  serdes_cpu_pwdata    =   in_cpu_latch ? in_cpu_latch_wdata : cpu_pwdata;
    assign  serdes_cpu_pready    =   serdes_arb_cpu_pready;
    assign  serdes_cpu_prdata    =   serdes_arb_cpu_prdata;

    assign  gephy_arb_cpu_paddr     =   gephy_cpu_paddr[20:0];
    assign  gephy_arb_cpu_penable   =   gephy_cpu_penable;
    assign  gephy_arb_cpu_psel      =   gephy_cpu_psel;
    assign  gephy_arb_cpu_pwrite    =   gephy_cpu_pwrite;
    assign  gephy_arb_cpu_pwdata    =   gephy_cpu_pwdata;

    assign  gephy_cpu_paddr     =   in_cpu_latch ? in_cpu_latch_addr : bus_sel_cpu_gephy_sel_addr;
    assign  gephy_cpu_penable   =   in_cpu_latch | cpu_penable;
    assign  gephy_cpu_psel      =   (in_cpu_latch | cpu_psel) & bus_sel_cpu_gephy_sel;
    assign  gephy_cpu_pwrite    =   in_cpu_latch ? in_cpu_latch_we : cpu_pwrite;
    assign  gephy_cpu_pwdata    =   in_cpu_latch ? in_cpu_latch_wdata : cpu_pwdata;
    assign  gephy_cpu_pready    =   gephy_arb_cpu_pready;
    assign  gephy_cpu_prdata    =   gephy_arb_cpu_prdata;

    assign  _2p5g_pcs_arb_cpu_paddr     =   _2p5g_pcs_cpu_paddr[20:0];
    assign  _2p5g_pcs_arb_cpu_penable   =   _2p5g_pcs_cpu_penable;
    assign  _2p5g_pcs_arb_cpu_psel      =   _2p5g_pcs_cpu_psel;
    assign  _2p5g_pcs_arb_cpu_pwrite    =   _2p5g_pcs_cpu_pwrite;
    assign  _2p5g_pcs_arb_cpu_pwdata    =   _2p5g_pcs_cpu_pwdata;

    assign  _2p5g_pcs_cpu_paddr     =   in_cpu_latch ? in_cpu_latch_addr : bus_sel_cpu__2p5g_pcs_sel_addr;
    assign  _2p5g_pcs_cpu_penable   =   in_cpu_latch | cpu_penable;
    assign  _2p5g_pcs_cpu_psel      =   (in_cpu_latch | cpu_psel) & bus_sel_cpu__2p5g_pcs_sel;
    assign  _2p5g_pcs_cpu_pwrite    =   in_cpu_latch ? in_cpu_latch_we : cpu_pwrite;
    assign  _2p5g_pcs_cpu_pwdata    =   in_cpu_latch ? in_cpu_latch_wdata : cpu_pwdata;
    assign  _2p5g_pcs_cpu_pready    =   _2p5g_pcs_arb_cpu_pready;
    assign  _2p5g_pcs_cpu_prdata    =   _2p5g_pcs_arb_cpu_prdata;
    assign  _2p5g_pcs_cpu_pslverr   =   _2p5g_pcs_arb_cpu_pslverr;

    assign  _2p5g_pma_arb_cpu_paddr     =   _2p5g_pma_cpu_paddr[20:0];
    assign  _2p5g_pma_arb_cpu_penable   =   _2p5g_pma_cpu_penable;
    assign  _2p5g_pma_arb_cpu_psel      =   _2p5g_pma_cpu_psel;
    assign  _2p5g_pma_arb_cpu_pwrite    =   _2p5g_pma_cpu_pwrite;
    assign  _2p5g_pma_arb_cpu_pwdata    =   _2p5g_pma_cpu_pwdata;

    assign  _2p5g_pma_cpu_paddr     =   in_cpu_latch ? in_cpu_latch_addr : bus_sel_cpu__2p5g_pma_sel_addr;
    assign  _2p5g_pma_cpu_penable   =   in_cpu_latch | cpu_penable;
    assign  _2p5g_pma_cpu_psel      =   (in_cpu_latch | cpu_psel) & bus_sel_cpu__2p5g_pma_sel;
    assign  _2p5g_pma_cpu_pwrite    =   in_cpu_latch ? in_cpu_latch_we : cpu_pwrite;
    assign  _2p5g_pma_cpu_pwdata    =   in_cpu_latch ? in_cpu_latch_wdata : cpu_pwdata;
    assign  _2p5g_pma_cpu_pready    =   _2p5g_pma_arb_cpu_pready;
    assign  _2p5g_pma_cpu_prdata    =   _2p5g_pma_arb_cpu_prdata;
    assign  _2p5g_pma_cpu_pslverr   =   _2p5g_pma_arb_cpu_pslverr;

    assign  new_analog_arb_cpu_paddr     =   new_analog_cpu_paddr[20:0];
    assign  new_analog_arb_cpu_penable   =   new_analog_cpu_penable;
    assign  new_analog_arb_cpu_psel      =   new_analog_cpu_psel;
    assign  new_analog_arb_cpu_pwrite    =   new_analog_cpu_pwrite;
    assign  new_analog_arb_cpu_pwdata    =   new_analog_cpu_pwdata;

    assign  new_analog_cpu_paddr     =   in_cpu_latch ? in_cpu_latch_addr : bus_sel_cpu_new_analog_sel_addr;
    assign  new_analog_cpu_penable   =   in_cpu_latch | cpu_penable;
    assign  new_analog_cpu_psel      =   (in_cpu_latch | cpu_psel) & bus_sel_cpu_new_analog_sel;
    assign  new_analog_cpu_pwrite    =   in_cpu_latch ? in_cpu_latch_we : cpu_pwrite;
    assign  new_analog_cpu_pwdata    =   in_cpu_latch ? in_cpu_latch_wdata : cpu_pwdata;
    assign  new_analog_cpu_pready    =   new_analog_arb_cpu_pready;
    assign  new_analog_cpu_prdata    =   new_analog_arb_cpu_prdata;

    ApbArbitrator #(21,32,16)
    ApbArb_ieee
    (
    .clk            (clk                            ),
    .rstn           (rstn                           ),
    .cfg_timeout    (cfg_timeout                    ),
    .in_use_mdio    (in_use_mdio                    ),
    .in_use_cpu     (in_use_cpu                     ),

    .mdio_paddr     (ieee_arb_mdio_paddr            ),
    .mdio_penable   (ieee_arb_mdio_penable          ),
    .mdio_psel      (ieee_arb_mdio_psel             ),
    .mdio_pwrite    (ieee_arb_mdio_pwrite           ),
    .mdio_pwdata    (ieee_arb_mdio_pwdata           ),
    .mdio_pready    (ieee_arb_mdio_pready           ),
    .mdio_prdata    (ieee_arb_mdio_prdata           ),

    .cpu_paddr      (ieee_arb_cpu_paddr             ),
    .cpu_penable    (ieee_arb_cpu_penable           ),
    .cpu_psel       (ieee_arb_cpu_psel              ),
    .cpu_pwrite     (ieee_arb_cpu_pwrite            ),
    .cpu_pwdata     (ieee_arb_cpu_pwdata            ),
    .cpu_pready     (ieee_arb_cpu_pready            ),
    .cpu_prdata     (ieee_arb_cpu_prdata            ),

    .paddr          (ieee_paddr                     ),
    .pready         (ieee_pready                    ),
    .prdata         ({{16'h0}, ieee_prdata}         ),
    .pwrite         (ieee_pwrite                    ),
    .psel           (ieee_psel                      ),
    .penable        (ieee_penable                   ),
    .pwdata         ({{16'h0}, ieee_pwdata}         )
    );

    ApbArbitrator
    ApbArb_top
    (
    .clk            (clk                            ),
    .rstn           (rstn                           ),
    .cfg_timeout    (cfg_timeout                    ),
    .in_use_mdio    (in_use_mdio                    ),
    .in_use_cpu     (in_use_cpu                     ),

    .mdio_paddr     (top_arb_mdio_paddr             ),
    .mdio_penable   (top_arb_mdio_penable           ),
    .mdio_psel      (top_arb_mdio_psel              ),
    .mdio_pwrite    (top_arb_mdio_pwrite            ),
    .mdio_pwdata    (top_arb_mdio_pwdata            ),
    .mdio_pready    (top_arb_mdio_pready            ),
    .mdio_prdata    (top_arb_mdio_prdata            ),

    .cpu_paddr      (top_arb_cpu_paddr              ),
    .cpu_penable    (top_arb_cpu_penable            ),
    .cpu_psel       (top_arb_cpu_psel               ),
    .cpu_pwrite     (top_arb_cpu_pwrite             ),
    .cpu_pwdata     (top_arb_cpu_pwdata             ),
    .cpu_pready     (top_arb_cpu_pready             ),
    .cpu_prdata     (top_arb_cpu_prdata             ),

    .paddr          (top_paddr                      ),
    .pready         (top_pready                     ),
    .prdata         ({{16'h0}, top_prdata}          ),
    .pwrite         (top_pwrite                     ),
    .psel           (top_psel                       ),
    .penable        (top_penable                    ),
    .pwdata         ({{16'h0}, top_pwdata}          )
    );

    ApbArbitrator
    ApbArb_xgmii_bridge
    (
    .clk            (clk                            ),
    .rstn           (rstn                           ),
    .cfg_timeout    (cfg_timeout                    ),
    .in_use_mdio    (in_use_mdio                    ),
    .in_use_cpu     (in_use_cpu                     ),

    .mdio_paddr     (xgmii_bridge_arb_mdio_paddr    ),
    .mdio_penable   (xgmii_bridge_arb_mdio_penable  ),
    .mdio_psel      (xgmii_bridge_arb_mdio_psel     ),
    .mdio_pwrite    (xgmii_bridge_arb_mdio_pwrite   ),
    .mdio_pwdata    (xgmii_bridge_arb_mdio_pwdata   ),
    .mdio_pready    (xgmii_bridge_arb_mdio_pready   ),
    .mdio_prdata    (xgmii_bridge_arb_mdio_prdata   ),

    .cpu_paddr      (xgmii_bridge_arb_cpu_paddr     ),
    .cpu_penable    (xgmii_bridge_arb_cpu_penable   ),
    .cpu_psel       (xgmii_bridge_arb_cpu_psel      ),
    .cpu_pwrite     (xgmii_bridge_arb_cpu_pwrite    ),
    .cpu_pwdata     (xgmii_bridge_arb_cpu_pwdata    ),
    .cpu_pready     (xgmii_bridge_arb_cpu_pready    ),
    .cpu_prdata     (xgmii_bridge_arb_cpu_prdata    ),

    .paddr          (xgmii_bridge_paddr             ),
    .pready         (xgmii_bridge_pready            ),
    .prdata         ({{16'h0}, xgmii_bridge_prdata} ),
    .pwrite         (xgmii_bridge_pwrite            ),
    .psel           (xgmii_bridge_psel              ),
    .penable        (xgmii_bridge_penable           ),
    .pwdata         ({{16'h0}, xgmii_bridge_pwdata} )
    );

    ApbArbitrator
    ApbArb_frontend
    (
    .clk            (clk                            ),
    .rstn           (rstn                           ),
    .cfg_timeout    (cfg_timeout                    ),
    .in_use_mdio    (in_use_mdio                    ),
    .in_use_cpu     (in_use_cpu                     ),

    .mdio_paddr     (frontend_arb_mdio_paddr        ),
    .mdio_penable   (frontend_arb_mdio_penable      ),
    .mdio_psel      (frontend_arb_mdio_psel         ),
    .mdio_pwrite    (frontend_arb_mdio_pwrite       ),
    .mdio_pwdata    (frontend_arb_mdio_pwdata       ),
    .mdio_pready    (frontend_arb_mdio_pready       ),
    .mdio_prdata    (frontend_arb_mdio_prdata       ),

    .cpu_paddr      (frontend_arb_cpu_paddr         ),
    .cpu_penable    (frontend_arb_cpu_penable       ),
    .cpu_psel       (frontend_arb_cpu_psel          ),
    .cpu_pwrite     (frontend_arb_cpu_pwrite        ),
    .cpu_pwdata     (frontend_arb_cpu_pwdata        ),
    .cpu_pready     (frontend_arb_cpu_pready        ),
    .cpu_prdata     (frontend_arb_cpu_prdata        ),

    .paddr          (frontend_paddr                 ),
    .pready         (frontend_pready                ),
    .prdata         ({{16'h0}, frontend_prdata}     ),
    .pwrite         (frontend_pwrite                ),
    .psel           (frontend_psel                  ),
    .penable        (frontend_penable               ),
    .pwdata         ({{16'h0}, frontend_pwdata}     )
    );

    ApbArbitrator #(8,32,16)
    ApbArb_flash
    (
    .clk            (clk                            ),
    .rstn           (rstn                           ),
    .cfg_timeout    (cfg_timeout                    ),
    .in_use_mdio    (in_use_mdio                    ),
    .in_use_cpu     (in_use_cpu                     ),

    .mdio_paddr     (flash_arb_mdio_paddr           ),
    .mdio_penable   (flash_arb_mdio_penable         ),
    .mdio_psel      (flash_arb_mdio_psel            ),
    .mdio_pwrite    (flash_arb_mdio_pwrite          ),
    .mdio_pwdata    (flash_arb_mdio_pwdata          ),
    .mdio_pready    (flash_arb_mdio_pready          ),
    .mdio_prdata    (flash_arb_mdio_prdata          ),

    .cpu_paddr      (flash_arb_cpu_paddr            ),
    .cpu_penable    (flash_arb_cpu_penable          ),
    .cpu_psel       (flash_arb_cpu_psel             ),
    .cpu_pwrite     (flash_arb_cpu_pwrite           ),
    .cpu_pwdata     (flash_arb_cpu_pwdata           ),
    .cpu_pready     (flash_arb_cpu_pready           ),
    .cpu_prdata     (flash_arb_cpu_prdata           ),

    .paddr          (flash_paddr                    ),
    .pready         (flash_pready                   ),
    .prdata         ({{16'h0}, flash_prdata}        ),
    .pwrite         (flash_pwrite                   ),
    .psel           (flash_psel                     ),
    .penable        (flash_penable                  ),
    .pwdata         ({{16'h0}, flash_pwdata}        )
    );

    ApbArbitrator #(2,32,16)
    ApbArb_uart
    (
    .clk            (clk                            ),
    .rstn           (rstn                           ),
    .cfg_timeout    (cfg_timeout                    ),
    .in_use_mdio    (in_use_mdio                    ),
    .in_use_cpu     (in_use_cpu                     ),

    .mdio_paddr     (uart_arb_mdio_paddr            ),
    .mdio_penable   (uart_arb_mdio_penable          ),
    .mdio_psel      (uart_arb_mdio_psel             ),
    .mdio_pwrite    (uart_arb_mdio_pwrite           ),
    .mdio_pwdata    (uart_arb_mdio_pwdata           ),
    .mdio_pready    (uart_arb_mdio_pready           ),
    .mdio_prdata    (uart_arb_mdio_prdata           ),

    .cpu_paddr      (uart_arb_cpu_paddr             ),
    .cpu_penable    (uart_arb_cpu_penable           ),
    .cpu_psel       (uart_arb_cpu_psel              ),
    .cpu_pwrite     (uart_arb_cpu_pwrite            ),
    .cpu_pwdata     (uart_arb_cpu_pwdata            ),
    .cpu_pready     (uart_arb_cpu_pready            ),
    .cpu_prdata     (uart_arb_cpu_prdata            ),

    .paddr          (uart_paddr                     ),
    .pready         (uart_pready                    ),
    .prdata         ({{16'h0}, uart_prdata}         ),
    .pwrite         (uart_pwrite                    ),
    .psel           (uart_psel                      ),
    .penable        (uart_penable                   ),
    .pwdata         ({{16'h0}, uart_pwdata}         )
    );

    ApbArbitrator #(8,32,16)
    ApbArb_debug
    (
    .clk            (clk                            ),
    .rstn           (rstn                           ),
    .cfg_timeout    (cfg_timeout                    ),
    .in_use_mdio    (in_use_mdio                    ),
    .in_use_cpu     (in_use_cpu                     ),

    .mdio_paddr     (debug_arb_mdio_paddr           ),
    .mdio_penable   (debug_arb_mdio_penable         ),
    .mdio_psel      (debug_arb_mdio_psel            ),
    .mdio_pwrite    (debug_arb_mdio_pwrite          ),
    .mdio_pwdata    (debug_arb_mdio_pwdata          ),
    .mdio_pready    (debug_arb_mdio_pready          ),
    .mdio_prdata    (debug_arb_mdio_prdata          ),

    .cpu_paddr      (debug_arb_cpu_paddr            ),
    .cpu_penable    (debug_arb_cpu_penable          ),
    .cpu_psel       (debug_arb_cpu_psel             ),
    .cpu_pwrite     (debug_arb_cpu_pwrite           ),
    .cpu_pwdata     (debug_arb_cpu_pwdata           ),
    .cpu_pready     (debug_arb_cpu_pready           ),
    .cpu_prdata     (debug_arb_cpu_prdata           ),

    .paddr          (debug_paddr                    ),
    .pready         (debug_pready                   ),
    .prdata         ({{16'h0}, debug_prdata}        ),
    .pwrite         (debug_pwrite                   ),
    .psel           (debug_psel                     ),
    .penable        (debug_penable                  ),
    .pwdata         ({{16'h0}, debug_pwdata}        )
    );

    ApbArbitrator
    ApbArb_serdes
    (
    .clk            (clk                            ),
    .rstn           (rstn                           ),
    .cfg_timeout    (cfg_timeout                    ),
    .in_use_mdio    (in_use_mdio                    ),
    .in_use_cpu     (in_use_cpu                     ),

    .mdio_paddr     (serdes_arb_mdio_paddr          ),
    .mdio_penable   (serdes_arb_mdio_penable        ),
    .mdio_psel      (serdes_arb_mdio_psel           ),
    .mdio_pwrite    (serdes_arb_mdio_pwrite         ),
    .mdio_pwdata    (serdes_arb_mdio_pwdata         ),
    .mdio_pready    (serdes_arb_mdio_pready         ),
    .mdio_prdata    (serdes_arb_mdio_prdata         ),

    .cpu_paddr      (serdes_arb_cpu_paddr           ),
    .cpu_penable    (serdes_arb_cpu_penable         ),
    .cpu_psel       (serdes_arb_cpu_psel            ),
    .cpu_pwrite     (serdes_arb_cpu_pwrite          ),
    .cpu_pwdata     (serdes_arb_cpu_pwdata          ),
    .cpu_pready     (serdes_arb_cpu_pready          ),
    .cpu_prdata     (serdes_arb_cpu_prdata          ),

    .paddr          (serdes_paddr                   ),
    .pready         (serdes_pready                  ),
    .prdata         ({{16'h0}, serdes_prdata}       ),
    .pwrite         (serdes_pwrite                  ),
    .psel           (serdes_psel                    ),
    .penable        (serdes_penable                 ),
    .pwdata         ({{16'h0}, serdes_pwdata}       )
    );

    ApbArbitrator
    ApbArb_gephy
    (
    .clk            (clk                            ),
    .rstn           (rstn                           ),
    .cfg_timeout    (cfg_timeout                    ),
    .in_use_mdio    (in_use_mdio                    ),
    .in_use_cpu     (in_use_cpu                     ),

    .mdio_paddr     (gephy_arb_mdio_paddr           ),
    .mdio_penable   (gephy_arb_mdio_penable         ),
    .mdio_psel      (gephy_arb_mdio_psel            ),
    .mdio_pwrite    (gephy_arb_mdio_pwrite          ),
    .mdio_pwdata    (gephy_arb_mdio_pwdata          ),
    .mdio_pready    (gephy_arb_mdio_pready          ),
    .mdio_prdata    (gephy_arb_mdio_prdata          ),

    .cpu_paddr      (gephy_arb_cpu_paddr            ),
    .cpu_penable    (gephy_arb_cpu_penable          ),
    .cpu_psel       (gephy_arb_cpu_psel             ),
    .cpu_pwrite     (gephy_arb_cpu_pwrite           ),
    .cpu_pwdata     (gephy_arb_cpu_pwdata           ),
    .cpu_pready     (gephy_arb_cpu_pready           ),
    .cpu_prdata     (gephy_arb_cpu_prdata           ),

    .paddr          (gephy_paddr                    ),
    .pready         (gephy_pready                   ),
    .prdata         ({{16'h0}, gephy_prdata}        ),
    .pwrite         (gephy_pwrite                   ),
    .psel           (gephy_psel                     ),
    .penable        (gephy_penable                  ),
    .pwdata         ({{16'h0}, gephy_pwdata}        )
    );

    ApbArbit_Hand
    ApbArb_2p5g_pcs
    (
    .clk            (clk                            ),
    .rstn           (rstn                           ),
    .dev_clk        (_2p5g_pcs_clk                  ),
    .dev_rstn       (_2p5g_pcs_rstn                 ),
    .cfg_timeout    (cfg_timeout                    ),
    .in_use_mdio    (in_use_mdio                    ),
    .in_use_cpu     (in_use_cpu                     ),

    .mdio_paddr     (_2p5g_pcs_arb_mdio_paddr       ),
    .mdio_penable   (_2p5g_pcs_arb_mdio_penable     ),
    .mdio_psel      (_2p5g_pcs_arb_mdio_psel        ),
    .mdio_pwrite    (_2p5g_pcs_arb_mdio_pwrite      ),
    .mdio_pwdata    (_2p5g_pcs_arb_mdio_pwdata      ),
    .mdio_pready    (_2p5g_pcs_arb_mdio_pready      ),
    .mdio_prdata    (_2p5g_pcs_arb_mdio_prdata      ),
    .mdio_pslverr   (_2p5g_pcs_arb_mdio_pslverr     ),

    .cpu_paddr      (_2p5g_pcs_arb_cpu_paddr        ),
    .cpu_penable    (_2p5g_pcs_arb_cpu_penable      ),
    .cpu_psel       (_2p5g_pcs_arb_cpu_psel         ),
    .cpu_pwrite     (_2p5g_pcs_arb_cpu_pwrite       ),
    .cpu_pwdata     (_2p5g_pcs_arb_cpu_pwdata       ),
    .cpu_pready     (_2p5g_pcs_arb_cpu_pready       ),
    .cpu_prdata     (_2p5g_pcs_arb_cpu_prdata       ),
    .cpu_pslverr    (_2p5g_pcs_arb_cpu_pslverr      ),

    .paddr          (_2p5g_pcs_paddr                ),
    .pready         (_2p5g_pcs_pready               ),
    .prdata         ({{16'h0}, _2p5g_pcs_prdata}    ),
    .pwrite         (_2p5g_pcs_pwrite               ),
    .psel           (_2p5g_pcs_psel                 ),
    .penable        (_2p5g_pcs_penable              ),
    .pwdata         ({{16'h0}, _2p5g_pcs_pwdata}    )
    );

    ApbArbit_Hand
    ApbArb_2p5g_pma
    (
    .clk            (clk                            ),
    .rstn           (rstn                           ),
    .dev_clk        (_2p5g_pma_clk                  ),
    .dev_rstn       (_2p5g_pma_rstn                 ),
    .cfg_timeout    (cfg_timeout                    ),
    .in_use_mdio    (in_use_mdio                    ),
    .in_use_cpu     (in_use_mdio                    ),

    .mdio_paddr     (_2p5g_pma_arb_mdio_paddr       ),
    .mdio_penable   (_2p5g_pma_arb_mdio_penable     ),
    .mdio_psel      (_2p5g_pma_arb_mdio_psel        ),
    .mdio_pwrite    (_2p5g_pma_arb_mdio_pwrite      ),
    .mdio_pwdata    (_2p5g_pma_arb_mdio_pwdata      ),
    .mdio_pready    (_2p5g_pma_arb_mdio_pready      ),
    .mdio_prdata    (_2p5g_pma_arb_mdio_prdata      ),
    .mdio_pslverr   (_2p5g_pma_arb_mdio_pslverr     ),

    .cpu_paddr      (_2p5g_pma_arb_cpu_paddr        ),
    .cpu_penable    (_2p5g_pma_arb_cpu_penable      ),
    .cpu_psel       (_2p5g_pma_arb_cpu_psel         ),
    .cpu_pwrite     (_2p5g_pma_arb_cpu_pwrite       ),
    .cpu_pwdata     (_2p5g_pma_arb_cpu_pwdata       ),
    .cpu_pready     (_2p5g_pma_arb_cpu_pready       ),
    .cpu_prdata     (_2p5g_pma_arb_cpu_prdata       ),
    .cpu_pslverr    (_2p5g_pma_arb_cpu_pslverr      ),

    .paddr          (_2p5g_pma_paddr                ),
    .pready         (_2p5g_pma_pready               ),
    .prdata         ({{16'h0}, _2p5g_pma_prdata}    ),
    .pwrite         (_2p5g_pma_pwrite               ),
    .psel           (_2p5g_pma_psel                 ),
    .penable        (_2p5g_pma_penable              ),
    .pwdata         ({{16'h0}, _2p5g_pma_pwdata}    )
    );

    ApbArbitrator
    ApbArb_new_analog
    (
    .clk            (clk                            ),
    .rstn           (rstn                           ),
    .cfg_timeout    (cfg_timeout                    ),
    .in_use_mdio    (in_use_mdio                    ),
    .in_use_cpu     (in_use_cpu                     ),

    .mdio_paddr     (new_analog_arb_mdio_paddr      ),
    .mdio_penable   (new_analog_arb_mdio_penable    ),
    .mdio_psel      (new_analog_arb_mdio_psel       ),
    .mdio_pwrite    (new_analog_arb_mdio_pwrite     ),
    .mdio_pwdata    (new_analog_arb_mdio_pwdata     ),
    .mdio_pready    (new_analog_arb_mdio_pready     ),
    .mdio_prdata    (new_analog_arb_mdio_prdata     ),

    .cpu_paddr      (new_analog_arb_cpu_paddr       ),
    .cpu_penable    (new_analog_arb_cpu_penable     ),
    .cpu_psel       (new_analog_arb_cpu_psel        ),
    .cpu_pwrite     (new_analog_arb_cpu_pwrite      ),
    .cpu_pwdata     (new_analog_arb_cpu_pwdata      ),
    .cpu_pready     (new_analog_arb_cpu_pready      ),
    .cpu_prdata     (new_analog_arb_cpu_prdata      ),

    .paddr          (new_analog_paddr               ),
    .pready         (new_analog_pready              ),
    .prdata         ({{16'h0}, new_analog_prdata}   ),
    .pwrite         (new_analog_pwrite              ),
    .psel           (new_analog_psel                ),
    .penable        (new_analog_penable             ),
    .pwdata         ({{16'h0}, new_analog_pwdata}   )
    );

    ApbBusSel
    ApbBusSel_mdio
    (
    .master_addr              (bus_sel_mdio_master_addr             ),

    .ieee_sel_addr            (bus_sel_mdio_ieee_sel_addr           ),
    .top_sel_addr             (bus_sel_mdio_top_sel_addr            ),
    .xgmii_bridge_sel_addr    (bus_sel_mdio_xgmii_bridge_sel_addr   ),
    .frontend_sel_addr        (bus_sel_mdio_frontend_sel_addr       ),
    .flash_sel_addr           (bus_sel_mdio_flash_sel_addr          ),
    .uart_sel_addr            (bus_sel_mdio_uart_sel_addr           ),
    .debug_sel_addr           (bus_sel_mdio_debug_sel_addr          ),
    .serdes_sel_addr          (bus_sel_mdio_serdes_sel_addr         ),
    .gephy_sel_addr           (bus_sel_mdio_gephy_sel_addr          ),
    ._2p5g_pcs_sel_addr       (bus_sel_mdio__2p5g_pcs_sel_addr      ),
    ._2p5g_pma_sel_addr       (bus_sel_mdio__2p5g_pma_sel_addr      ),
    .new_analog_sel_addr      (bus_sel_mdio_new_analog_sel_addr     ),

    .ieee_sel                 (bus_sel_mdio_ieee_sel                ),
    .top_sel                  (bus_sel_mdio_top_sel                 ),
    .xgmii_bridge_sel         (bus_sel_mdio_xgmii_bridge_sel        ),
    .frontend_sel             (bus_sel_mdio_frontend_sel            ),
    .flash_sel                (bus_sel_mdio_flash_sel               ),
    .uart_sel                 (bus_sel_mdio_uart_sel                ),
    .debug_sel                (bus_sel_mdio_debug_sel               ),
    .serdes_sel               (bus_sel_mdio_serdes_sel              ),
    .gephy_sel                (bus_sel_mdio_gephy_sel               ),
    ._2p5g_pcs_sel            (bus_sel_mdio__2p5g_pcs_sel           ),
    ._2p5g_pma_sel            (bus_sel_mdio__2p5g_pma_sel           ),
    .new_analog_sel           (bus_sel_mdio_new_analog_sel          )
    );

    ApbBusSel
    ApbBusSel_cpu
    (
    .master_addr              (bus_sel_cpu_master_addr              ),

    .ieee_sel_addr            (bus_sel_cpu_ieee_sel_addr            ),
    .top_sel_addr             (bus_sel_cpu_top_sel_addr             ),
    .xgmii_bridge_sel_addr    (bus_sel_cpu_xgmii_bridge_sel_addr    ),
    .frontend_sel_addr        (bus_sel_cpu_frontend_sel_addr        ),
    .flash_sel_addr           (bus_sel_cpu_flash_sel_addr           ),
    .uart_sel_addr            (bus_sel_cpu_uart_sel_addr            ),
    .debug_sel_addr           (bus_sel_cpu_debug_sel_addr           ),
    .serdes_sel_addr          (bus_sel_cpu_serdes_sel_addr          ),
    .gephy_sel_addr           (bus_sel_cpu_gephy_sel_addr           ),
    ._2p5g_pcs_sel_addr       (bus_sel_cpu__2p5g_pcs_sel_addr       ),
    ._2p5g_pma_sel_addr       (bus_sel_cpu__2p5g_pma_sel_addr       ),
    .new_analog_sel_addr      (bus_sel_cpu_new_analog_sel_addr      ),

    .ieee_sel                 (bus_sel_cpu_ieee_sel                 ),
    .top_sel                  (bus_sel_cpu_top_sel                  ),
    .xgmii_bridge_sel         (bus_sel_cpu_xgmii_bridge_sel         ),
    .frontend_sel             (bus_sel_cpu_frontend_sel             ),
    .flash_sel                (bus_sel_cpu_flash_sel                ),
    .uart_sel                 (bus_sel_cpu_uart_sel                 ),
    .debug_sel                (bus_sel_cpu_debug_sel                ),
    .serdes_sel               (bus_sel_cpu_serdes_sel               ),
    .gephy_sel                (bus_sel_cpu_gephy_sel                ),
    ._2p5g_pcs_sel            (bus_sel_cpu__2p5g_pcs_sel            ),
    ._2p5g_pma_sel            (bus_sel_cpu__2p5g_pma_sel            ),
    .new_analog_sel           (bus_sel_cpu_new_analog_sel           )
    );

endmodule
