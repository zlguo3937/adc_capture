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
//  2023-10-06    zlguo         1.0         apb_mapper
// --------------------------------------------------------------------
// --------------------------------------------------------------------

`timescale 1ns/1ns

module apb_mapper
#(
    parameter ADDR_WIDTH    = 21,
    parameter DATA_WIDTH    = 16,
    parameter CFG_TIMEOUT   = 16
)
(
    input   wire                        clk,
    input   wire                        rstn,

    input   wire    [15:0]              cfg_timeout,

    input   wire    [ADDR_WIDTH-1:0]    mdio_paddr,
    input   wire                        mdio_penable,
    input   wire                        mdio_psel,
    input   wire                        mdio_pwrite,
    input   wire    [DATA_WIDTH-1:0]    mdio_pwdata,
    output  wire                        mdio_pslverr,
    output  wire                        mdio_pready,
    output  wire    [DATA_WIDTH-1:0]    mdio_prdata,

    input   wire    [31:0]              cpu_paddr,
    input   wire                        cpu_penable,
    input   wire                        cpu_psel,
    input   wire                        cpu_pwrite,
    input   wire    [31:0]              cpu_pwdata,
    output  wire                        cpu_pslverr,
    output  wire                        cpu_pready,
    output  wire    [31:0]              cpu_prdata,

    input   wire    [31:0]              apb_paddr,
    input   wire                        apb_penable,
    input   wire                        apb_psel,
    input   wire                        apb_pwrite,
    input   wire    [31:0]              apb_pwdata,
    output  wire                        apb_pready,
    output  wire    [31:0]              apb_prdata,

    output  wire    [ADDR_WIDTH-1:0]    top_req_addr ,
    input   wire                        top_req_ready,
    input   wire    [DATA_WIDTH-1:0]    top_req_rdata,
    output  wire                        top_req_write,
    output  wire                        top_req_sel  ,
    output  wire    [DATA_WIDTH-1:0]    top_req_wdata,

    output  wire    [ADDR_WIDTH-1:0]    bp_req_addr ,
    input   wire                        bp_req_ready,
    input   wire    [DATA_WIDTH-1:0]    bp_req_rdata,
    output  wire                        bp_req_write,
    output  wire                        bp_req_sel  ,
    output  wire    [DATA_WIDTH-1:0]    bp_req_wdata,

    output  wire    [ADDR_WIDTH-1:0]    bw_req_addr ,
    input   wire                        bw_req_ready,
    input   wire    [DATA_WIDTH-1:0]    bw_req_rdata,
    output  wire                        bw_req_write,
    output  wire                        bw_req_sel  ,
    output  wire    [DATA_WIDTH-1:0]    bw_req_wdata,

    output  wire    [ADDR_WIDTH-1:0]    mem_req_addr ,
    input   wire                        mem_req_ready,
    input   wire    [DATA_WIDTH-1:0]    mem_req_rdata,
    output  wire                        mem_req_write,
    output  wire                        mem_req_sel  ,
    output  wire    [DATA_WIDTH-1:0]    mem_req_wdata,

    output  wire    [ADDR_WIDTH-1:0]    pma_req_addr ,
    input   wire                        pma_req_ready,
    input   wire    [DATA_WIDTH-1:0]    pma_req_rdata,
    output  wire                        pma_req_write,
    output  wire                        pma_req_sel  ,
    output  wire    [DATA_WIDTH-1:0]    pma_req_wdata,

    output  wire    [ADDR_WIDTH-1:0]    dbg_req_addr ,
    input   wire                        dbg_req_ready,
    input   wire    [DATA_WIDTH-1:0]    dbg_req_rdata,
    output  wire                        dbg_req_write,
    output  wire                        dbg_req_sel  ,
    output  wire    [DATA_WIDTH-1:0]    dbg_req_wdata,

    output  wire    [ADDR_WIDTH-1:0]    pktbist_req_addr ,
    input   wire                        pktbist_req_ready,
    input   wire    [DATA_WIDTH-1:0]    pktbist_req_rdata,
    output  wire                        pktbist_req_write,
    output  wire                        pktbist_req_sel  ,
    output  wire    [DATA_WIDTH-1:0]    pktbist_req_wdata,

    output  wire    [ADDR_WIDTH-1:0]    serdes_req_addr ,
    input   wire                        serdes_req_ready,
    input   wire    [DATA_WIDTH-1:0]    serdes_req_rdata,
    output  wire                        serdes_req_write,
    output  wire                        serdes_req_sel  ,
    output  wire    [DATA_WIDTH-1:0]    serdes_req_wdata,

    output  wire    [ADDR_WIDTH-1:0]    xmii_bdg_req_addr ,
    input   wire                        xmii_bdg_req_ready,
    input   wire    [DATA_WIDTH-1:0]    xmii_bdg_req_rdata,
    output  wire                        xmii_bdg_req_write,
    output  wire                        xmii_bdg_req_sel  ,
    output  wire    [DATA_WIDTH-1:0]    xmii_bdg_req_wdata,

    output  wire    [ADDR_WIDTH-1:0]    rgmii_req_addr ,
    input   wire                        rgmii_req_ready,
    input   wire    [DATA_WIDTH-1:0]    rgmii_req_rdata,
    output  wire                        rgmii_req_write,
    output  wire                        rgmii_req_sel  ,
    output  wire    [DATA_WIDTH-1:0]    rgmii_req_wdata,

    output  wire    [ADDR_WIDTH-1:0]    ptp_req_addr ,
    input   wire                        ptp_req_ready,
    input   wire    [DATA_WIDTH-1:0]    ptp_req_rdata,
    output  wire                        ptp_req_write,
    output  wire                        ptp_req_sel  ,
    output  wire    [DATA_WIDTH-1:0]    ptp_req_wdata,

    output  wire    [ADDR_WIDTH-1:0]    xmii_rmtcg_req_addr ,
    input   wire                        xmii_rmtcg_req_ready,
    input   wire    [DATA_WIDTH-1:0]    xmii_rmtcg_req_rdata,
    output  wire                        xmii_rmtcg_req_write,
    output  wire                        xmii_rmtcg_req_sel  ,
    output  wire    [DATA_WIDTH-1:0]    xmii_rmtcg_req_wdata,

    output  wire    [ADDR_WIDTH-1:0]    iopad_req_addr ,
    input   wire                        iopad_req_ready,
    input   wire    [DATA_WIDTH-1:0]    iopad_req_rdata,
    output  wire                        iopad_req_write,
    output  wire                        iopad_req_sel  ,
    output  wire    [DATA_WIDTH-1:0]    iopad_req_wdata,

    output  wire    [ADDR_WIDTH-1:0]    analog_req_addr ,
    input   wire                        analog_req_ready,
    input   wire    [DATA_WIDTH-1:0]    analog_req_rdata,
    output  wire                        analog_req_write,
    output  wire                        analog_req_sel  ,
    output  wire    [DATA_WIDTH-1:0]    analog_req_wdata

);

    wire                        bus_mdio_sel;
    wire                        arb_in_mdio_pready;
    reg                         bus_sel_mdio_undefine;

    wire                        bus_cpu_sel;
    wire                        arb_in_cpu_pready;
    reg                         bus_sel_cpu_undefine;

    wire                        bus_apb_sel;
    wire                        arb_in_apb_pready;
    reg                         bus_sel_apb_undefine;

    wire                        top_mdio_pready;
    wire                        top_cpu_pready ;
    wire                        top_apb_pready ;
    wire    [DATA_WIDTH-1:0]    top_mdio_prdata;
    wire    [DATA_WIDTH-1:0]    top_cpu_prdata ;
    wire    [DATA_WIDTH-1:0]    top_apb_prdata ;

    wire                        bp_mdio_pready ;
    wire                        bp_cpu_pready  ;
    wire                        bp_apb_pready  ;
    wire    [DATA_WIDTH-1:0]    bp_mdio_prdata ;
    wire    [DATA_WIDTH-1:0]    bp_cpu_prdata  ;
    wire    [DATA_WIDTH-1:0]    bp_apb_prdata  ;

    wire                        bw_mdio_pready ;
    wire                        bw_cpu_pready  ;
    wire                        bw_apb_pready  ;
    wire    [DATA_WIDTH-1:0]    bw_mdio_prdata ;
    wire    [DATA_WIDTH-1:0]    bw_cpu_prdata  ;
    wire    [DATA_WIDTH-1:0]    bw_apb_prdata  ;

    wire                        mem_mdio_pready ;
    wire                        mem_cpu_pready  ;
    wire                        mem_apb_pready  ;
    wire    [DATA_WIDTH-1:0]    mem_mdio_prdata ;
    wire    [DATA_WIDTH-1:0]    mem_cpu_prdata  ;
    wire    [DATA_WIDTH-1:0]    mem_apb_prdata  ;

    wire                        pma_mdio_pready;
    wire                        pma_cpu_pready ;
    wire                        pma_apb_pready ;
    wire    [DATA_WIDTH-1:0]    pma_mdio_prdata;
    wire    [DATA_WIDTH-1:0]    pma_cpu_prdata ;
    wire    [DATA_WIDTH-1:0]    pma_apb_prdata ;

    wire                        dbg_mdio_pready;
    wire                        dbg_cpu_pready ;
    wire                        dbg_apb_pready ;
    wire    [DATA_WIDTH-1:0]    dbg_mdio_prdata;
    wire    [DATA_WIDTH-1:0]    dbg_cpu_prdata ;
    wire    [DATA_WIDTH-1:0]    dbg_apb_prdata ;

    wire                        pktbist_mdio_pready ;
    wire                        pktbist_cpu_pready  ;
    wire                        pktbist_apb_pready  ;
    wire    [DATA_WIDTH-1:0]    pktbist_mdio_prdata ;
    wire    [DATA_WIDTH-1:0]    pktbist_cpu_prdata  ;
    wire    [DATA_WIDTH-1:0]    pktbist_apb_prdata  ;

    wire                        serdes_mdio_pready  ;
    wire                        serdes_cpu_pready   ;
    wire                        serdes_apb_pready   ;
    wire    [DATA_WIDTH-1:0]    serdes_mdio_prdata  ;
    wire    [DATA_WIDTH-1:0]    serdes_cpu_prdata   ;
    wire    [DATA_WIDTH-1:0]    serdes_apb_prdata   ;

    wire                        xmii_bdg_mdio_pready;
    wire                        xmii_bdg_cpu_pready ;
    wire                        xmii_bdg_apb_pready ;
    wire    [DATA_WIDTH-1:0]    xmii_bdg_mdio_prdata;
    wire    [DATA_WIDTH-1:0]    xmii_bdg_cpu_prdata ;
    wire    [DATA_WIDTH-1:0]    xmii_bdg_apb_prdata ;

    wire                        rgmii_mdio_pready;
    wire                        rgmii_cpu_pready ;
    wire                        rgmii_apb_pready ;
    wire    [DATA_WIDTH-1:0]    rgmii_mdio_prdata;
    wire    [DATA_WIDTH-1:0]    rgmii_cpu_prdata ;
    wire    [DATA_WIDTH-1:0]    rgmii_apb_prdata ;

    wire                        ptp_mdio_pready  ;
    wire                        ptp_cpu_pready   ;
    wire                        ptp_apb_pready   ;
    wire    [DATA_WIDTH-1:0]    ptp_mdio_prdata  ;
    wire    [DATA_WIDTH-1:0]    ptp_cpu_prdata   ;
    wire    [DATA_WIDTH-1:0]    ptp_apb_prdata   ;

    wire                        xmii_rmtcg_mdio_pready  ;
    wire                        xmii_rmtcg_cpu_pready   ;
    wire                        xmii_rmtcg_apb_pready   ;
    wire    [DATA_WIDTH-1:0]    xmii_rmtcg_mdio_prdata  ;
    wire    [DATA_WIDTH-1:0]    xmii_rmtcg_cpu_prdata   ;
    wire    [DATA_WIDTH-1:0]    xmii_rmtcg_apb_prdata   ;

    wire                        iopad_mdio_pready;
    wire                        iopad_cpu_pready ;
    wire                        iopad_apb_pready ;
    wire    [DATA_WIDTH-1:0]    iopad_mdio_prdata;
    wire    [DATA_WIDTH-1:0]    iopad_cpu_prdata ;
    wire    [DATA_WIDTH-1:0]    iopad_apb_prdata ;

    wire                        analog_mdio_pready;
    wire                        analog_cpu_pready ;
    wire                        analog_apb_pready ;
    wire    [DATA_WIDTH-1:0]    analog_mdio_prdata;
    wire    [DATA_WIDTH-1:0]    analog_cpu_prdata ;
    wire    [DATA_WIDTH-1:0]    analog_apb_prdata ;

    wire    [ADDR_WIDTH-1:0]    top_arb_mdio_paddr  ;
    wire                        top_arb_mdio_penable;
    wire                        top_arb_mdio_psel   ;
    wire                        top_arb_mdio_pwrite ;
    wire    [DATA_WIDTH-1:0]    top_arb_mdio_pwdata ;
    wire                        top_arb_mdio_pready ;
    wire    [DATA_WIDTH-1:0]    top_arb_mdio_prdata ;

    wire    [ADDR_WIDTH-1:0]    top_arb_cpu_paddr   ;
    wire                        top_arb_cpu_penable ;
    wire                        top_arb_cpu_psel    ;
    wire                        top_arb_cpu_pwrite  ;
    wire    [DATA_WIDTH-1:0]    top_arb_cpu_pwdata  ;
    wire                        top_arb_cpu_pready  ;
    wire    [DATA_WIDTH-1:0]    top_arb_cpu_prdata  ;

    wire    [ADDR_WIDTH-1:0]    top_arb_apb_paddr   ;
    wire                        top_arb_apb_penable ;
    wire                        top_arb_apb_psel    ;
    wire                        top_arb_apb_pwrite  ;
    wire    [DATA_WIDTH-1:0]    top_arb_apb_pwdata  ;
    wire                        top_arb_apb_pready  ;
    wire    [DATA_WIDTH-1:0]    top_arb_apb_prdata  ;

    wire    [ADDR_WIDTH-1:0]    top_arb_req_addr    ;
    wire                        top_arb_req_ready   ;
    wire    [DATA_WIDTH-1:0]    top_arb_req_rdata   ;
    wire                        top_arb_req_write   ;
    wire                        top_arb_req_sel     ;
    wire    [DATA_WIDTH-1:0]    top_arb_req_wdata   ;


    wire    [ADDR_WIDTH-1:0]    bp_arb_mdio_paddr   ;
    wire                        bp_arb_mdio_penable ;
    wire                        bp_arb_mdio_psel    ;
    wire                        bp_arb_mdio_pwrite  ;
    wire    [DATA_WIDTH-1:0]    bp_arb_mdio_pwdata  ;
    wire                        bp_arb_mdio_pready  ;
    wire    [DATA_WIDTH-1:0]    bp_arb_mdio_prdata  ;

    wire    [ADDR_WIDTH-1:0]    bp_arb_cpu_paddr    ;
    wire                        bp_arb_cpu_penable  ;
    wire                        bp_arb_cpu_psel     ;
    wire                        bp_arb_cpu_pwrite   ;
    wire    [DATA_WIDTH-1:0]    bp_arb_cpu_pwdata   ;
    wire                        bp_arb_cpu_pready   ;
    wire    [DATA_WIDTH-1:0]    bp_arb_cpu_prdata   ;

    wire    [ADDR_WIDTH-1:0]    bp_arb_apb_paddr    ;
    wire                        bp_arb_apb_penable  ;
    wire                        bp_arb_apb_psel     ;
    wire                        bp_arb_apb_pwrite   ;
    wire    [DATA_WIDTH-1:0]    bp_arb_apb_pwdata   ;
    wire                        bp_arb_apb_pready   ;
    wire    [DATA_WIDTH-1:0]    bp_arb_apb_prdata   ;

    wire    [ADDR_WIDTH-1:0]    bp_arb_req_addr     ;
    wire                        bp_arb_req_ready    ;
    wire    [DATA_WIDTH-1:0]    bp_arb_req_rdata    ;
    wire                        bp_arb_req_write    ;
    wire                        bp_arb_req_sel      ;
    wire    [DATA_WIDTH-1:0]    bp_arb_req_wdata    ;


    wire    [ADDR_WIDTH-1:0]    bw_arb_mdio_paddr   ;
    wire                        bw_arb_mdio_penable ;
    wire                        bw_arb_mdio_psel    ;
    wire                        bw_arb_mdio_pwrite  ;
    wire    [DATA_WIDTH-1:0]    bw_arb_mdio_pwdata  ;
    wire                        bw_arb_mdio_pready  ;
    wire    [DATA_WIDTH-1:0]    bw_arb_mdio_prdata  ;

    wire    [ADDR_WIDTH-1:0]    bw_arb_cpu_paddr    ;
    wire                        bw_arb_cpu_penable  ;
    wire                        bw_arb_cpu_psel     ;
    wire                        bw_arb_cpu_pwrite   ;
    wire    [DATA_WIDTH-1:0]    bw_arb_cpu_pwdata   ;
    wire                        bw_arb_cpu_pready   ;
    wire    [DATA_WIDTH-1:0]    bw_arb_cpu_prdata   ;

    wire    [ADDR_WIDTH-1:0]    bw_arb_apb_paddr    ;
    wire                        bw_arb_apb_penable  ;
    wire                        bw_arb_apb_psel     ;
    wire                        bw_arb_apb_pwrite   ;
    wire    [DATA_WIDTH-1:0]    bw_arb_apb_pwdata   ;
    wire                        bw_arb_apb_pready   ;
    wire    [DATA_WIDTH-1:0]    bw_arb_apb_prdata   ;

    wire    [ADDR_WIDTH-1:0]    bw_arb_req_addr     ;
    wire                        bw_arb_req_ready    ;
    wire    [DATA_WIDTH-1:0]    bw_arb_req_rdata    ;
    wire                        bw_arb_req_write    ;
    wire                        bw_arb_req_sel      ;
    wire    [DATA_WIDTH-1:0]    bw_arb_req_wdata    ;


    wire    [ADDR_WIDTH-1:0]    mem_arb_mdio_paddr   ;
    wire                        mem_arb_mdio_penable ;
    wire                        mem_arb_mdio_psel    ;
    wire                        mem_arb_mdio_pwrite  ;
    wire    [DATA_WIDTH-1:0]    mem_arb_mdio_pwdata  ;
    wire                        mem_arb_mdio_pready  ;
    wire    [DATA_WIDTH-1:0]    mem_arb_mdio_prdata  ;

    wire    [ADDR_WIDTH-1:0]    mem_arb_cpu_paddr    ;
    wire                        mem_arb_cpu_penable  ;
    wire                        mem_arb_cpu_psel     ;
    wire                        mem_arb_cpu_pwrite   ;
    wire    [DATA_WIDTH-1:0]    mem_arb_cpu_pwdata   ;
    wire                        mem_arb_cpu_pready   ;
    wire    [DATA_WIDTH-1:0]    mem_arb_cpu_prdata   ;

    wire    [ADDR_WIDTH-1:0]    mem_arb_apb_paddr    ;
    wire                        mem_arb_apb_penable  ;
    wire                        mem_arb_apb_psel     ;
    wire                        mem_arb_apb_pwrite   ;
    wire    [DATA_WIDTH-1:0]    mem_arb_apb_pwdata   ;
    wire                        mem_arb_apb_pready   ;
    wire    [DATA_WIDTH-1:0]    mem_arb_apb_prdata   ;

    wire    [ADDR_WIDTH-1:0]    mem_arb_req_addr     ;
    wire                        mem_arb_req_ready    ;
    wire    [DATA_WIDTH-1:0]    mem_arb_req_rdata    ;
    wire                        mem_arb_req_write    ;
    wire                        mem_arb_req_sel      ;
    wire    [DATA_WIDTH-1:0]    mem_arb_req_wdata    ;


    wire    [ADDR_WIDTH-1:0]    pma_arb_mdio_paddr  ;
    wire                        pma_arb_mdio_penable;
    wire                        pma_arb_mdio_psel   ;
    wire                        pma_arb_mdio_pwrite ;
    wire    [DATA_WIDTH-1:0]    pma_arb_mdio_pwdata ;
    wire                        pma_arb_mdio_pready ;
    wire    [DATA_WIDTH-1:0]    pma_arb_mdio_prdata ;

    wire    [ADDR_WIDTH-1:0]    pma_arb_cpu_paddr   ;
    wire                        pma_arb_cpu_penable ;
    wire                        pma_arb_cpu_psel    ;
    wire                        pma_arb_cpu_pwrite  ;
    wire    [DATA_WIDTH-1:0]    pma_arb_cpu_pwdata  ;
    wire                        pma_arb_cpu_pready  ;
    wire    [DATA_WIDTH-1:0]    pma_arb_cpu_prdata  ;

    wire    [ADDR_WIDTH-1:0]    pma_arb_apb_paddr   ;
    wire                        pma_arb_apb_penable ;
    wire                        pma_arb_apb_psel    ;
    wire                        pma_arb_apb_pwrite  ;
    wire    [DATA_WIDTH-1:0]    pma_arb_apb_pwdata  ;
    wire                        pma_arb_apb_pready  ;
    wire    [DATA_WIDTH-1:0]    pma_arb_apb_prdata  ;

    wire    [ADDR_WIDTH-1:0]    pma_arb_req_addr    ;
    wire                        pma_arb_req_ready   ;
    wire    [DATA_WIDTH-1:0]    pma_arb_req_rdata   ;
    wire                        pma_arb_req_write   ;
    wire                        pma_arb_req_sel     ;
    wire    [DATA_WIDTH-1:0]    pma_arb_req_wdata   ;


    wire    [ADDR_WIDTH-1:0]    dbg_arb_mdio_paddr  ;
    wire                        dbg_arb_mdio_penable;
    wire                        dbg_arb_mdio_psel   ;
    wire                        dbg_arb_mdio_pwrite ;
    wire    [DATA_WIDTH-1:0]    dbg_arb_mdio_pwdata ;
    wire                        dbg_arb_mdio_pready ;
    wire    [DATA_WIDTH-1:0]    dbg_arb_mdio_prdata ;

    wire    [ADDR_WIDTH-1:0]    dbg_arb_cpu_paddr   ;
    wire                        dbg_arb_cpu_penable ;
    wire                        dbg_arb_cpu_psel    ;
    wire                        dbg_arb_cpu_pwrite  ;
    wire    [DATA_WIDTH-1:0]    dbg_arb_cpu_pwdata  ;
    wire                        dbg_arb_cpu_pready  ;
    wire    [DATA_WIDTH-1:0]    dbg_arb_cpu_prdata  ;

    wire    [ADDR_WIDTH-1:0]    dbg_arb_apb_paddr   ;
    wire                        dbg_arb_apb_penable ;
    wire                        dbg_arb_apb_psel    ;
    wire                        dbg_arb_apb_pwrite  ;
    wire    [DATA_WIDTH-1:0]    dbg_arb_apb_pwdata  ;
    wire                        dbg_arb_apb_pready  ;
    wire    [DATA_WIDTH-1:0]    dbg_arb_apb_prdata  ;

    wire    [ADDR_WIDTH-1:0]    dbg_arb_req_addr    ;
    wire                        dbg_arb_req_ready   ;
    wire    [DATA_WIDTH-1:0]    dbg_arb_req_rdata   ;
    wire                        dbg_arb_req_write   ;
    wire                        dbg_arb_req_sel     ;
    wire    [DATA_WIDTH-1:0]    dbg_arb_req_wdata   ;


    wire    [ADDR_WIDTH-1:0]    pktbist_arb_mdio_paddr  ;
    wire                        pktbist_arb_mdio_penable;
    wire                        pktbist_arb_mdio_psel   ;
    wire                        pktbist_arb_mdio_pwrite ;
    wire    [DATA_WIDTH-1:0]    pktbist_arb_mdio_pwdata ;
    wire                        pktbist_arb_mdio_pready ;
    wire    [DATA_WIDTH-1:0]    pktbist_arb_mdio_prdata ;

    wire    [ADDR_WIDTH-1:0]    pktbist_arb_cpu_paddr   ;
    wire                        pktbist_arb_cpu_penable ;
    wire                        pktbist_arb_cpu_psel    ;
    wire                        pktbist_arb_cpu_pwrite  ;
    wire    [DATA_WIDTH-1:0]    pktbist_arb_cpu_pwdata  ;
    wire                        pktbist_arb_cpu_pready  ;
    wire    [DATA_WIDTH-1:0]    pktbist_arb_cpu_prdata  ;

    wire    [ADDR_WIDTH-1:0]    pktbist_arb_apb_paddr   ;
    wire                        pktbist_arb_apb_penable ;
    wire                        pktbist_arb_apb_psel    ;
    wire                        pktbist_arb_apb_pwrite  ;
    wire    [DATA_WIDTH-1:0]    pktbist_arb_apb_pwdata  ;
    wire                        pktbist_arb_apb_pready  ;
    wire    [DATA_WIDTH-1:0]    pktbist_arb_apb_prdata  ;

    wire    [ADDR_WIDTH-1:0]    pktbist_arb_req_addr    ;
    wire                        pktbist_arb_req_ready   ;
    wire    [DATA_WIDTH-1:0]    pktbist_arb_req_rdata   ;
    wire                        pktbist_arb_req_write   ;
    wire                        pktbist_arb_req_sel     ;
    wire    [DATA_WIDTH-1:0]    pktbist_arb_req_wdata   ;


    wire    [ADDR_WIDTH-1:0]    serdes_arb_mdio_paddr   ;
    wire                        serdes_arb_mdio_penable ;
    wire                        serdes_arb_mdio_psel    ;
    wire                        serdes_arb_mdio_pwrite  ;
    wire    [DATA_WIDTH-1:0]    serdes_arb_mdio_pwdata  ;
    wire                        serdes_arb_mdio_pready  ;
    wire    [DATA_WIDTH-1:0]    serdes_arb_mdio_prdata  ;

    wire    [ADDR_WIDTH-1:0]    serdes_arb_cpu_paddr    ;
    wire                        serdes_arb_cpu_penable  ;
    wire                        serdes_arb_cpu_psel     ;
    wire                        serdes_arb_cpu_pwrite   ;
    wire    [DATA_WIDTH-1:0]    serdes_arb_cpu_pwdata   ;
    wire                        serdes_arb_cpu_pready   ;
    wire    [DATA_WIDTH-1:0]    serdes_arb_cpu_prdata   ;

    wire    [ADDR_WIDTH-1:0]    serdes_arb_apb_paddr    ;
    wire                        serdes_arb_apb_penable  ;
    wire                        serdes_arb_apb_psel     ;
    wire                        serdes_arb_apb_pwrite   ;
    wire    [DATA_WIDTH-1:0]    serdes_arb_apb_pwdata   ;
    wire                        serdes_arb_apb_pready   ;
    wire    [DATA_WIDTH-1:0]    serdes_arb_apb_prdata   ;

    wire    [ADDR_WIDTH-1:0]    serdes_arb_req_addr     ;
    wire                        serdes_arb_req_ready    ;
    wire    [DATA_WIDTH-1:0]    serdes_arb_req_rdata    ;
    wire                        serdes_arb_req_write    ;
    wire                        serdes_arb_req_sel      ;
    wire    [DATA_WIDTH-1:0]    serdes_arb_req_wdata    ;


    wire    [ADDR_WIDTH-1:0]    xmii_bdg_arb_mdio_paddr  ;
    wire                        xmii_bdg_arb_mdio_penable;
    wire                        xmii_bdg_arb_mdio_psel   ;
    wire                        xmii_bdg_arb_mdio_pwrite ;
    wire    [DATA_WIDTH-1:0]    xmii_bdg_arb_mdio_pwdata ;
    wire                        xmii_bdg_arb_mdio_pready ;
    wire    [DATA_WIDTH-1:0]    xmii_bdg_arb_mdio_prdata ;

    wire    [ADDR_WIDTH-1:0]    xmii_bdg_arb_cpu_paddr   ;
    wire                        xmii_bdg_arb_cpu_penable ;
    wire                        xmii_bdg_arb_cpu_psel    ;
    wire                        xmii_bdg_arb_cpu_pwrite  ;
    wire    [DATA_WIDTH-1:0]    xmii_bdg_arb_cpu_pwdata  ;
    wire                        xmii_bdg_arb_cpu_pready  ;
    wire    [DATA_WIDTH-1:0]    xmii_bdg_arb_cpu_prdata  ;

    wire    [ADDR_WIDTH-1:0]    xmii_bdg_arb_apb_paddr   ;
    wire                        xmii_bdg_arb_apb_penable ;
    wire                        xmii_bdg_arb_apb_psel    ;
    wire                        xmii_bdg_arb_apb_pwrite  ;
    wire    [DATA_WIDTH-1:0]    xmii_bdg_arb_apb_pwdata  ;
    wire                        xmii_bdg_arb_apb_pready  ;
    wire    [DATA_WIDTH-1:0]    xmii_bdg_arb_apb_prdata  ;

    wire    [ADDR_WIDTH-1:0]    xmii_bdg_arb_req_addr    ;
    wire                        xmii_bdg_arb_req_ready   ;
    wire    [DATA_WIDTH-1:0]    xmii_bdg_arb_req_rdata   ;
    wire                        xmii_bdg_arb_req_write   ;
    wire                        xmii_bdg_arb_req_sel     ;
    wire    [DATA_WIDTH-1:0]    xmii_bdg_arb_req_wdata   ;


    wire    [ADDR_WIDTH-1:0]    rgmii_arb_mdio_paddr     ;
    wire                        rgmii_arb_mdio_penable   ;
    wire                        rgmii_arb_mdio_psel      ;
    wire                        rgmii_arb_mdio_pwrite    ;
    wire    [DATA_WIDTH-1:0]    rgmii_arb_mdio_pwdata    ;
    wire                        rgmii_arb_mdio_pready    ;
    wire    [DATA_WIDTH-1:0]    rgmii_arb_mdio_prdata    ;

    wire    [ADDR_WIDTH-1:0]    rgmii_arb_cpu_paddr      ;
    wire                        rgmii_arb_cpu_penable    ;
    wire                        rgmii_arb_cpu_psel       ;
    wire                        rgmii_arb_cpu_pwrite     ;
    wire    [DATA_WIDTH-1:0]    rgmii_arb_cpu_pwdata     ;
    wire                        rgmii_arb_cpu_pready     ;
    wire    [DATA_WIDTH-1:0]    rgmii_arb_cpu_prdata     ;

    wire    [ADDR_WIDTH-1:0]    rgmii_arb_apb_paddr      ;
    wire                        rgmii_arb_apb_penable    ;
    wire                        rgmii_arb_apb_psel       ;
    wire                        rgmii_arb_apb_pwrite     ;
    wire    [DATA_WIDTH-1:0]    rgmii_arb_apb_pwdata     ;
    wire                        rgmii_arb_apb_pready     ;
    wire    [DATA_WIDTH-1:0]    rgmii_arb_apb_prdata     ;

    wire    [ADDR_WIDTH-1:0]    rgmii_arb_req_addr       ;
    wire                        rgmii_arb_req_ready      ;
    wire    [DATA_WIDTH-1:0]    rgmii_arb_req_rdata      ;
    wire                        rgmii_arb_req_write      ;
    wire                        rgmii_arb_req_sel        ;
    wire    [DATA_WIDTH-1:0]    rgmii_arb_req_wdata      ;


    wire    [ADDR_WIDTH-1:0]    ptp_arb_mdio_paddr  ;
    wire                        ptp_arb_mdio_penable;
    wire                        ptp_arb_mdio_psel   ;
    wire                        ptp_arb_mdio_pwrite ;
    wire    [DATA_WIDTH-1:0]    ptp_arb_mdio_pwdata ;
    wire                        ptp_arb_mdio_pready ;
    wire    [DATA_WIDTH-1:0]    ptp_arb_mdio_prdata ;

    wire    [ADDR_WIDTH-1:0]    ptp_arb_cpu_paddr   ;
    wire                        ptp_arb_cpu_penable ;
    wire                        ptp_arb_cpu_psel    ;
    wire                        ptp_arb_cpu_pwrite  ;
    wire    [DATA_WIDTH-1:0]    ptp_arb_cpu_pwdata  ;
    wire                        ptp_arb_cpu_pready  ;
    wire    [DATA_WIDTH-1:0]    ptp_arb_cpu_prdata  ;

    wire    [ADDR_WIDTH-1:0]    ptp_arb_apb_paddr   ;
    wire                        ptp_arb_apb_penable ;
    wire                        ptp_arb_apb_psel    ;
    wire                        ptp_arb_apb_pwrite  ;
    wire    [DATA_WIDTH-1:0]    ptp_arb_apb_pwdata  ;
    wire                        ptp_arb_apb_pready  ;
    wire    [DATA_WIDTH-1:0]    ptp_arb_apb_prdata  ;

    wire    [ADDR_WIDTH-1:0]    ptp_arb_req_addr    ;
    wire                        ptp_arb_req_ready   ;
    wire    [DATA_WIDTH-1:0]    ptp_arb_req_rdata   ;
    wire                        ptp_arb_req_write   ;
    wire                        ptp_arb_req_sel     ;
    wire    [DATA_WIDTH-1:0]    ptp_arb_req_wdata   ;


    wire    [ADDR_WIDTH-1:0]    xmii_rmtcg_arb_mdio_paddr  ;
    wire                        xmii_rmtcg_arb_mdio_penable;
    wire                        xmii_rmtcg_arb_mdio_psel   ;
    wire                        xmii_rmtcg_arb_mdio_pwrite ;
    wire    [DATA_WIDTH-1:0]    xmii_rmtcg_arb_mdio_pwdata ;
    wire                        xmii_rmtcg_arb_mdio_pready ;
    wire    [DATA_WIDTH-1:0]    xmii_rmtcg_arb_mdio_prdata ;

    wire    [ADDR_WIDTH-1:0]    xmii_rmtcg_arb_cpu_paddr   ;
    wire                        xmii_rmtcg_arb_cpu_penable ;
    wire                        xmii_rmtcg_arb_cpu_psel    ;
    wire                        xmii_rmtcg_arb_cpu_pwrite  ;
    wire    [DATA_WIDTH-1:0]    xmii_rmtcg_arb_cpu_pwdata  ;
    wire                        xmii_rmtcg_arb_cpu_pready  ;
    wire    [DATA_WIDTH-1:0]    xmii_rmtcg_arb_cpu_prdata  ;

    wire    [ADDR_WIDTH-1:0]    xmii_rmtcg_arb_apb_paddr   ;
    wire                        xmii_rmtcg_arb_apb_penable ;
    wire                        xmii_rmtcg_arb_apb_psel    ;
    wire                        xmii_rmtcg_arb_apb_pwrite  ;
    wire    [DATA_WIDTH-1:0]    xmii_rmtcg_arb_apb_pwdata  ;
    wire                        xmii_rmtcg_arb_apb_pready  ;
    wire    [DATA_WIDTH-1:0]    xmii_rmtcg_arb_apb_prdata  ;

    wire    [ADDR_WIDTH-1:0]    xmii_rmtcg_arb_req_addr    ;
    wire                        xmii_rmtcg_arb_req_ready   ;
    wire    [DATA_WIDTH-1:0]    xmii_rmtcg_arb_req_rdata   ;
    wire                        xmii_rmtcg_arb_req_write   ;
    wire                        xmii_rmtcg_arb_req_sel     ;
    wire    [DATA_WIDTH-1:0]    xmii_rmtcg_arb_req_wdata   ;

    wire    [ADDR_WIDTH-1:0]    iopad_arb_mdio_paddr  ;
    wire                        iopad_arb_mdio_penable;
    wire                        iopad_arb_mdio_psel   ;
    wire                        iopad_arb_mdio_pwrite ;
    wire    [DATA_WIDTH-1:0]    iopad_arb_mdio_pwdata ;
    wire                        iopad_arb_mdio_pready ;
    wire    [DATA_WIDTH-1:0]    iopad_arb_mdio_prdata ;

    wire    [ADDR_WIDTH-1:0]    iopad_arb_cpu_paddr   ;
    wire                        iopad_arb_cpu_penable ;
    wire                        iopad_arb_cpu_psel    ;
    wire                        iopad_arb_cpu_pwrite  ;
    wire    [DATA_WIDTH-1:0]    iopad_arb_cpu_pwdata  ;
    wire                        iopad_arb_cpu_pready  ;
    wire    [DATA_WIDTH-1:0]    iopad_arb_cpu_prdata  ;

    wire    [ADDR_WIDTH-1:0]    iopad_arb_apb_paddr   ;
    wire                        iopad_arb_apb_penable ;
    wire                        iopad_arb_apb_psel    ;
    wire                        iopad_arb_apb_pwrite  ;
    wire    [DATA_WIDTH-1:0]    iopad_arb_apb_pwdata  ;
    wire                        iopad_arb_apb_pready  ;
    wire    [DATA_WIDTH-1:0]    iopad_arb_apb_prdata  ;

    wire    [ADDR_WIDTH-1:0]    iopad_arb_req_addr    ;
    wire                        iopad_arb_req_ready   ;
    wire    [DATA_WIDTH-1:0]    iopad_arb_req_rdata   ;
    wire                        iopad_arb_req_write   ;
    wire                        iopad_arb_req_sel     ;
    wire    [DATA_WIDTH-1:0]    iopad_arb_req_wdata   ;

    wire    [ADDR_WIDTH-1:0]    analog_arb_mdio_paddr  ;
    wire                        analog_arb_mdio_penable;
    wire                        analog_arb_mdio_psel   ;
    wire                        analog_arb_mdio_pwrite ;
    wire    [DATA_WIDTH-1:0]    analog_arb_mdio_pwdata ;
    wire                        analog_arb_mdio_pready ;
    wire    [DATA_WIDTH-1:0]    analog_arb_mdio_prdata ;

    wire    [ADDR_WIDTH-1:0]    analog_arb_cpu_paddr   ;
    wire                        analog_arb_cpu_penable ;
    wire                        analog_arb_cpu_psel    ;
    wire                        analog_arb_cpu_pwrite  ;
    wire    [DATA_WIDTH-1:0]    analog_arb_cpu_pwdata  ;
    wire                        analog_arb_cpu_pready  ;
    wire    [DATA_WIDTH-1:0]    analog_arb_cpu_prdata  ;

    wire    [ADDR_WIDTH-1:0]    analog_arb_apb_paddr   ;
    wire                        analog_arb_apb_penable ;
    wire                        analog_arb_apb_psel    ;
    wire                        analog_arb_apb_pwrite  ;
    wire    [DATA_WIDTH-1:0]    analog_arb_apb_pwdata  ;
    wire                        analog_arb_apb_pready  ;
    wire    [DATA_WIDTH-1:0]    analog_arb_apb_prdata  ;

    wire    [ADDR_WIDTH-1:0]    analog_arb_req_addr    ;
    wire                        analog_arb_req_ready   ;
    wire    [DATA_WIDTH-1:0]    analog_arb_req_rdata   ;
    wire                        analog_arb_req_write   ;
    wire                        analog_arb_req_sel     ;
    wire    [DATA_WIDTH-1:0]    analog_arb_req_wdata   ;

    wire    [ADDR_WIDTH-1:0]    bus_sel_mdio_master_addr;
    wire    [ADDR_WIDTH-1:0]    bus_sel_mdio_top_sel_addr;
    wire    [ADDR_WIDTH-1:0]    bus_sel_mdio_bp_sel_addr;
    wire    [ADDR_WIDTH-1:0]    bus_sel_mdio_bw_sel_addr;
    wire    [ADDR_WIDTH-1:0]    bus_sel_mdio_mem_sel_addr;
    wire    [ADDR_WIDTH-1:0]    bus_sel_mdio_pma_sel_addr;
    wire    [ADDR_WIDTH-1:0]    bus_sel_mdio_dbg_sel_addr;
    wire    [ADDR_WIDTH-1:0]    bus_sel_mdio_pktbist_sel_addr;
    wire    [ADDR_WIDTH-1:0]    bus_sel_mdio_serdes_sel_addr;
    wire    [ADDR_WIDTH-1:0]    bus_sel_mdio_xmii_bdg_sel_addr;
    wire    [ADDR_WIDTH-1:0]    bus_sel_mdio_rgmii_sel_addr;
    wire    [ADDR_WIDTH-1:0]    bus_sel_mdio_ptp_sel_addr;
    wire    [ADDR_WIDTH-1:0]    bus_sel_mdio_xmii_rmtcg_sel_addr;
    wire    [ADDR_WIDTH-1:0]    bus_sel_mdio_iopad_sel_addr;
    wire    [ADDR_WIDTH-1:0]    bus_sel_mdio_analog_sel_addr;

    wire                        bus_sel_mdio_top_sel;
    wire                        bus_sel_mdio_bp_sel;
    wire                        bus_sel_mdio_bw_sel;
    wire                        bus_sel_mdio_mem_sel;
    wire                        bus_sel_mdio_pma_sel;
    wire                        bus_sel_mdio_dbg_sel;
    wire                        bus_sel_mdio_pktbist_sel;
    wire                        bus_sel_mdio_serdes_sel;
    wire                        bus_sel_mdio_xmii_bdg_sel;
    wire                        bus_sel_mdio_rgmii_sel;
    wire                        bus_sel_mdio_ptp_sel;
    wire                        bus_sel_mdio_xmii_rmtcg_sel;
    wire                        bus_sel_mdio_iopad_sel;
    wire                        bus_sel_mdio_analog_sel;

    wire    [ADDR_WIDTH-1:0]    bus_sel_cpu_master_addr;
    wire    [ADDR_WIDTH-1:0]    bus_sel_cpu_top_sel_addr;
    wire    [ADDR_WIDTH-1:0]    bus_sel_cpu_bp_sel_addr;
    wire    [ADDR_WIDTH-1:0]    bus_sel_cpu_bw_sel_addr;
    wire    [ADDR_WIDTH-1:0]    bus_sel_cpu_mem_sel_addr;
    wire    [ADDR_WIDTH-1:0]    bus_sel_cpu_pma_sel_addr;
    wire    [ADDR_WIDTH-1:0]    bus_sel_cpu_dbg_sel_addr;
    wire    [ADDR_WIDTH-1:0]    bus_sel_cpu_pktbist_sel_addr;
    wire    [ADDR_WIDTH-1:0]    bus_sel_cpu_serdes_sel_addr;
    wire    [ADDR_WIDTH-1:0]    bus_sel_cpu_xmii_bdg_sel_addr;
    wire    [ADDR_WIDTH-1:0]    bus_sel_cpu_rgmii_sel_addr;
    wire    [ADDR_WIDTH-1:0]    bus_sel_cpu_ptp_sel_addr;
    wire    [ADDR_WIDTH-1:0]    bus_sel_cpu_xmii_rmtcg_sel_addr;
    wire    [ADDR_WIDTH-1:0]    bus_sel_cpu_iopad_sel_addr;
    wire    [ADDR_WIDTH-1:0]    bus_sel_cpu_analog_sel_addr;

    wire                        bus_sel_cpu_top_sel;
    wire                        bus_sel_cpu_bp_sel;
    wire                        bus_sel_cpu_bw_sel;
    wire                        bus_sel_cpu_mem_sel;
    wire                        bus_sel_cpu_pma_sel;
    wire                        bus_sel_cpu_dbg_sel;
    wire                        bus_sel_cpu_pktbist_sel;
    wire                        bus_sel_cpu_serdes_sel;
    wire                        bus_sel_cpu_xmii_bdg_sel;
    wire                        bus_sel_cpu_rgmii_sel;
    wire                        bus_sel_cpu_ptp_sel;
    wire                        bus_sel_cpu_xmii_rmtcg_sel;
    wire                        bus_sel_cpu_iopad_sel;
    wire                        bus_sel_cpu_analog_sel;

    wire    [ADDR_WIDTH-1:0]    bus_sel_apb_master_addr;
    wire    [ADDR_WIDTH-1:0]    bus_sel_apb_top_sel_addr;
    wire    [ADDR_WIDTH-1:0]    bus_sel_apb_bp_sel_addr;
    wire    [ADDR_WIDTH-1:0]    bus_sel_apb_bw_sel_addr;
    wire    [ADDR_WIDTH-1:0]    bus_sel_apb_mem_sel_addr;
    wire    [ADDR_WIDTH-1:0]    bus_sel_apb_pma_sel_addr;
    wire    [ADDR_WIDTH-1:0]    bus_sel_apb_dbg_sel_addr;
    wire    [ADDR_WIDTH-1:0]    bus_sel_apb_pktbist_sel_addr;
    wire    [ADDR_WIDTH-1:0]    bus_sel_apb_serdes_sel_addr;
    wire    [ADDR_WIDTH-1:0]    bus_sel_apb_xmii_bdg_sel_addr;
    wire    [ADDR_WIDTH-1:0]    bus_sel_apb_rgmii_sel_addr;
    wire    [ADDR_WIDTH-1:0]    bus_sel_apb_ptp_sel_addr;
    wire    [ADDR_WIDTH-1:0]    bus_sel_apb_xmii_rmtcg_sel_addr;
    wire    [ADDR_WIDTH-1:0]    bus_sel_apb_iopad_sel_addr;
    wire    [ADDR_WIDTH-1:0]    bus_sel_apb_analog_sel_addr;

    wire                        bus_sel_apb_top_sel;
    wire                        bus_sel_apb_bp_sel;
    wire                        bus_sel_apb_bw_sel;
    wire                        bus_sel_apb_mem_sel;
    wire                        bus_sel_apb_pma_sel;
    wire                        bus_sel_apb_dbg_sel;
    wire                        bus_sel_apb_pktbist_sel;
    wire                        bus_sel_apb_serdes_sel;
    wire                        bus_sel_apb_xmii_bdg_sel;
    wire                        bus_sel_apb_rgmii_sel;
    wire                        bus_sel_apb_ptp_sel;
    wire                        bus_sel_apb_xmii_rmtcg_sel;
    wire                        bus_sel_apb_iopad_sel;
    wire                        bus_sel_apb_analog_sel;

    /* -----------------------------
     mdio interface
     ---------------------------- */
    assign  bus_sel_mdio_master_addr = mdio_paddr;

    assign  bus_mdio_sel       = bus_sel_mdio_top_sel | bus_sel_mdio_bp_sel | bus_sel_mdio_bw_sel | bus_sel_mdio_mem_sel |
                                 bus_sel_mdio_pma_sel | bus_sel_mdio_dbg_sel | bus_sel_mdio_pktbist_sel | bus_sel_mdio_serdes_sel |
                                 bus_sel_mdio_xmii_bdg_sel | bus_sel_mdio_rgmii_sel | bus_sel_mdio_ptp_sel | bus_sel_mdio_xmii_rmtcg_sel |
                                 bus_sel_mdio_iopad_sel | bus_sel_mdio_analog_sel;

    assign  arb_in_mdio_pready = top_mdio_pready | bp_mdio_pready | bw_mdio_pready | mem_mdio_pready | pma_mdio_pready |
                                 dbg_mdio_pready | pktbist_mdio_pready | serdes_mdio_pready | xmii_bdg_mdio_pready |
                                 rgmii_mdio_pready | ptp_mdio_pready | xmii_rmtcg_mdio_pready | iopad_mdio_pready | analog_mdio_pready;

    assign  mdio_pready        = bus_sel_mdio_undefine | arb_in_mdio_pready;

    assign  mdio_prdata        = top_mdio_pready       ? top_mdio_prdata       : 
                                 bp_mdio_pready        ? bp_mdio_prdata        :
                                 bw_mdio_pready        ? bw_mdio_prdata        :
                                 mem_mdio_pready       ? mem_mdio_prdata       :
                                 pma_mdio_pready       ? pma_mdio_prdata       :
                                 dbg_mdio_pready       ? dbg_mdio_prdata       :
                                 pktbist_mdio_pready   ? pktbist_mdio_prdata   :
                                 serdes_mdio_pready    ? serdes_mdio_prdata    :
                                 xmii_bdg_mdio_pready  ? xmii_bdg_mdio_prdata  :
                                 rgmii_mdio_pready     ? rgmii_mdio_prdata     :
                                 ptp_mdio_pready       ? ptp_mdio_prdata       :
                                 xmii_rmtcg_mdio_pready? xmii_rmtcg_mdio_prdata:
                                 iopad_mdio_pready     ? iopad_mdio_prdata     :
                                 analog_mdio_pready    ? analog_mdio_prdata    : {{DATA_WIDTH}{1'b0}};

    assign  mdio_pslverr = bus_sel_mdio_undefine;

    always @(posedge clk or negedge rstn)
    begin
        if(~rstn)
            bus_sel_mdio_undefine <= 1'b0;
        else
            bus_sel_mdio_undefine <= mdio_psel & ~bus_mdio_sel;
    end

    /* -----------------------------
     cpu interface
     ---------------------------- */
    assign  bus_sel_cpu_master_addr = cpu_paddr[22:2];

    assign  bus_cpu_sel       = bus_sel_cpu_top_sel | bus_sel_cpu_bp_sel | bus_sel_cpu_bw_sel | bus_sel_cpu_mem_sel |
                                bus_sel_cpu_pma_sel | bus_sel_cpu_dbg_sel | bus_sel_cpu_pktbist_sel | bus_sel_cpu_serdes_sel |
                                bus_sel_cpu_xmii_bdg_sel | bus_sel_cpu_rgmii_sel | bus_sel_cpu_ptp_sel | bus_sel_cpu_xmii_rmtcg_sel |
                                bus_sel_cpu_iopad_sel | bus_sel_cpu_analog_sel;

    assign  arb_in_cpu_pready = top_cpu_pready | bp_cpu_pready | bw_cpu_pready | mem_cpu_pready | pma_cpu_pready |
                                dbg_cpu_pready | pktbist_cpu_pready | serdes_cpu_pready | xmii_bdg_cpu_pready |
                                rgmii_cpu_pready | ptp_cpu_pready | xmii_rmtcg_cpu_pready | iopad_cpu_pready | analog_cpu_pready;

    assign  cpu_pready        = bus_sel_cpu_undefine | arb_in_cpu_pready;

    assign  cpu_prdata        = top_cpu_pready       ? top_cpu_prdata       : 
                                bp_cpu_pready        ? bp_cpu_prdata        :
                                bw_cpu_pready        ? bw_cpu_prdata        :
                                mem_cpu_pready       ? mem_cpu_prdata       :
                                pma_cpu_pready       ? pma_cpu_prdata       :
                                dbg_cpu_pready       ? dbg_cpu_prdata       :
                                pktbist_cpu_pready   ? pktbist_cpu_prdata   :
                                serdes_cpu_pready    ? serdes_cpu_prdata    :
                                xmii_bdg_cpu_pready  ? xmii_bdg_cpu_prdata  :
                                rgmii_cpu_pready     ? rgmii_cpu_prdata     :
                                ptp_cpu_pready       ? ptp_cpu_prdata       :
                                xmii_rmtcg_cpu_pready? xmii_rmtcg_cpu_prdata:
                                iopad_cpu_pready     ? iopad_cpu_prdata     :
                                analog_cpu_pready    ? analog_cpu_prdata    : {{DATA_WIDTH}{1'b0}};

    assign  cpu_pslverr = bus_sel_cpu_undefine;

    always @(posedge clk or negedge rstn)
    begin
        if(~rstn)
            bus_sel_cpu_undefine <= 1'b0;
        else
            bus_sel_cpu_undefine <= cpu_psel & ~bus_cpu_sel;
    end

    /* -----------------------------
     apb interface
     ---------------------------- */
    assign  bus_sel_apb_master_addr = apb_paddr[22:2];

    assign  bus_apb_sel       = bus_sel_apb_top_sel | bus_sel_apb_bp_sel | bus_sel_apb_bw_sel | bus_sel_apb_mem_sel |
                                bus_sel_apb_pma_sel | bus_sel_apb_dbg_sel | bus_sel_apb_pktbist_sel | bus_sel_apb_serdes_sel |
                                bus_sel_apb_xmii_bdg_sel | bus_sel_apb_rgmii_sel | bus_sel_apb_ptp_sel | bus_sel_apb_xmii_rmtcg_sel |
                                bus_sel_apb_iopad_sel | bus_sel_apb_analog_sel;

    assign  arb_in_apb_pready = top_apb_pready | bp_apb_pready | bw_apb_pready | mem_apb_pready | pma_apb_pready |
                                dbg_apb_pready | pktbist_apb_pready | serdes_apb_pready | xmii_bdg_apb_pready |
                                rgmii_apb_pready | ptp_apb_pready | xmii_rmtcg_apb_pready | iopad_apb_pready | analog_apb_pready;

    assign  apb_pready        = bus_sel_apb_undefine | arb_in_apb_pready;

    assign  apb_prdata        = top_apb_pready       ? top_apb_prdata       : 
                                bp_apb_pready        ? bp_apb_prdata        :
                                bw_apb_pready        ? bw_apb_prdata        :
                                mem_apb_pready       ? mem_apb_prdata       :
                                pma_apb_pready       ? pma_apb_prdata       :
                                dbg_apb_pready       ? dbg_apb_prdata       :
                                pktbist_apb_pready   ? pktbist_apb_prdata   :
                                serdes_apb_pready    ? serdes_apb_prdata    :
                                xmii_bdg_apb_pready  ? xmii_bdg_apb_prdata  :
                                rgmii_apb_pready     ? rgmii_apb_prdata     :
                                ptp_apb_pready       ? ptp_apb_prdata       :
                                xmii_rmtcg_apb_pready? xmii_rmtcg_apb_prdata:
                                iopad_apb_pready     ? iopad_apb_prdata     :
                                analog_apb_pready    ? analog_apb_prdata    : {{DATA_WIDTH}{1'b0}};

    always @(posedge clk or negedge rstn)
    begin
        if(~rstn)
            bus_sel_apb_undefine <= 1'b0;
        else
            bus_sel_apb_undefine <= apb_psel & ~bus_apb_sel;
    end

    //
    assign  top_mdio_pready =   top_arb_mdio_pready;
    assign  top_cpu_pready  =   top_arb_cpu_pready;
    assign  top_apb_pready  =   top_arb_apb_pready;

    assign  top_mdio_prdata =   top_arb_mdio_prdata;
    assign  top_cpu_prdata  =   {16'h0, top_arb_cpu_prdata};
    assign  top_apb_prdata  =   {16'h0, top_arb_apb_prdata};

    //
    assign  bp_mdio_pready  =   bp_arb_mdio_pready;
    assign  bp_cpu_pready   =   bp_arb_cpu_pready;
    assign  bp_apb_pready   =   bp_arb_apb_pready;

    assign  bp_mdio_prdata  =   bp_arb_mdio_prdata;
    assign  bp_cpu_prdata   =   {16'h0, bp_arb_cpu_prdata};
    assign  bp_apb_prdata   =   {16'h0, bp_arb_apb_prdata};

    //
    assign  bw_mdio_pready  =   bw_arb_mdio_pready;
    assign  bw_cpu_pready   =   bw_arb_cpu_pready;
    assign  bw_apb_pready   =   bw_arb_apb_pready;

    assign  bw_mdio_prdata  =   bw_arb_mdio_prdata;
    assign  bw_cpu_prdata   =   {16'h0, bw_arb_cpu_prdata};
    assign  bw_apb_prdata   =   {16'h0, bw_arb_apb_prdata};

    //
    assign  mem_mdio_pready =   mem_arb_mdio_pready;
    assign  mem_cpu_pready  =   mem_arb_cpu_pready;
    assign  mem_apb_pready  =   mem_arb_apb_pready;

    assign  mem_mdio_prdata =   mem_arb_mdio_prdata;
    assign  mem_cpu_prdata  =   {16'h0, mem_arb_cpu_prdata};
    assign  mem_apb_prdata  =   {16'h0, mem_arb_apb_prdata};

    //
    assign  pma_mdio_pready =   pma_arb_mdio_pready;
    assign  pma_cpu_pready  =   pma_arb_cpu_pready;
    assign  pma_apb_pready  =   pma_arb_apb_pready;

    assign  pma_mdio_prdata =   pma_arb_mdio_prdata;
    assign  pma_cpu_prdata  =   {16'h0, pma_arb_cpu_prdata};
    assign  pma_apb_prdata  =   {16'h0, pma_arb_apb_prdata};

    //
    assign  dbg_mdio_pready =   dbg_arb_mdio_pready;
    assign  dbg_cpu_pready  =   dbg_arb_cpu_pready;
    assign  dbg_apb_pready  =   dbg_arb_apb_pready;

    assign  dbg_mdio_prdata =   dbg_arb_mdio_prdata;
    assign  dbg_cpu_prdata  =   {16'h0, dbg_arb_cpu_prdata};
    assign  dbg_apb_prdata  =   {16'h0, dbg_arb_apb_prdata};

    //
    assign  pktbist_mdio_pready  =   pktbist_arb_mdio_pready;
    assign  pktbist_cpu_pready   =   pktbist_arb_cpu_pready;
    assign  pktbist_apb_pready   =   pktbist_arb_apb_pready;

    assign  pktbist_mdio_prdata  =   pktbist_arb_mdio_prdata;
    assign  pktbist_cpu_prdata   =   {16'h0, pktbist_arb_cpu_prdata};
    assign  pktbist_apb_prdata   =   {16'h0, pktbist_arb_apb_prdata};

    //
    assign  serdes_mdio_pready   =   serdes_arb_mdio_pready;
    assign  serdes_cpu_pready    =   serdes_arb_cpu_pready;
    assign  serdes_apb_pready    =   serdes_arb_apb_pready;

    assign  serdes_mdio_prdata   =   serdes_arb_mdio_prdata;
    assign  serdes_cpu_prdata    =   {16'h0, serdes_arb_cpu_prdata};
    assign  serdes_apb_prdata    =   {16'h0, serdes_arb_apb_prdata};

    //
    assign  xmii_bdg_mdio_pready =   xmii_bdg_arb_mdio_pready;
    assign  xmii_bdg_cpu_pready  =   xmii_bdg_arb_cpu_pready;
    assign  xmii_bdg_apb_pready  =   xmii_bdg_arb_apb_pready;

    assign  xmii_bdg_mdio_prdata =   xmii_bdg_arb_mdio_prdata;
    assign  xmii_bdg_cpu_prdata  =   {16'h0, xmii_bdg_arb_cpu_prdata};
    assign  xmii_bdg_apb_prdata  =   {16'h0, xmii_bdg_arb_apb_prdata};

    //
    assign  rgmii_mdio_pready    =   rgmii_arb_mdio_pready;
    assign  rgmii_cpu_pready     =   rgmii_arb_cpu_pready;
    assign  rgmii_apb_pready     =   rgmii_arb_apb_pready;

    assign  rgmii_mdio_prdata    =   rgmii_arb_mdio_prdata;
    assign  rgmii_cpu_prdata     =   {16'h0, rgmii_arb_cpu_prdata};
    assign  rgmii_apb_prdata     =   {16'h0, rgmii_arb_apb_prdata};

    //
    assign  ptp_mdio_pready      =   ptp_arb_mdio_pready;
    assign  ptp_cpu_pready       =   ptp_arb_cpu_pready;
    assign  ptp_apb_pready       =   ptp_arb_apb_pready;

    assign  ptp_mdio_prdata      =   ptp_arb_mdio_prdata;
    assign  ptp_cpu_prdata       =   {16'h0, ptp_arb_cpu_prdata};
    assign  ptp_apb_prdata       =   {16'h0, ptp_arb_apb_prdata};

    //
    assign  xmii_rmtcg_mdio_pready  =   xmii_rmtcg_arb_mdio_pready;
    assign  xmii_rmtcg_cpu_pready   =   xmii_rmtcg_arb_cpu_pready;
    assign  xmii_rmtcg_apb_pready   =   xmii_rmtcg_arb_apb_pready;

    assign  xmii_rmtcg_mdio_prdata  =   xmii_rmtcg_arb_mdio_prdata;
    assign  xmii_rmtcg_cpu_prdata   =   {16'h0, xmii_rmtcg_arb_cpu_prdata};
    assign  xmii_rmtcg_apb_prdata   =   {16'h0, xmii_rmtcg_arb_apb_prdata};

    //
    assign  iopad_mdio_pready       =   iopad_arb_mdio_pready;
    assign  iopad_cpu_pready        =   iopad_arb_cpu_pready;
    assign  iopad_apb_pready        =   iopad_arb_apb_pready;

    assign  iopad_mdio_prdata       =   iopad_arb_mdio_prdata;
    assign  iopad_cpu_prdata        =   {16'h0, iopad_arb_cpu_prdata};
    assign  iopad_apb_prdata        =   {16'h0, iopad_arb_apb_prdata};

    //
    assign  analog_mdio_pready       =   analog_arb_mdio_pready;
    assign  analog_cpu_pready        =   analog_arb_cpu_pready;
    assign  analog_apb_pready        =   analog_arb_apb_pready;

    assign  analog_mdio_prdata       =   analog_arb_mdio_prdata;
    assign  analog_cpu_prdata        =   {16'h0, analog_arb_cpu_prdata};
    assign  analog_apb_prdata        =   {16'h0, analog_arb_apb_prdata};

    // 
    assign  top_arb_mdio_paddr      =   bus_sel_mdio_top_sel_addr;
    assign  top_arb_mdio_penable    =   mdio_penable;
    assign  top_arb_mdio_psel       =   mdio_psel & bus_sel_mdio_top_sel;
    assign  top_arb_mdio_pwrite     =   mdio_pwrite;
    assign  top_arb_mdio_pwdata     =   mdio_pwdata;

    assign  top_arb_cpu_paddr       =   bus_sel_cpu_top_sel_addr;
    assign  top_arb_cpu_penable     =   cpu_penable;
    assign  top_arb_cpu_psel        =   cpu_psel & bus_sel_cpu_top_sel;
    assign  top_arb_cpu_pwrite      =   cpu_pwrite;
    assign  top_arb_cpu_pwdata      =   cpu_pwdata[15:0];

    assign  top_arb_apb_paddr       =   bus_sel_apb_top_sel_addr;
    assign  top_arb_apb_penable     =   apb_penable;
    assign  top_arb_apb_psel        =   apb_psel & bus_sel_apb_top_sel;
    assign  top_arb_apb_pwrite      =   apb_pwrite;
    assign  top_arb_apb_pwdata      =   apb_pwdata[15:0];

    // 
    assign  bp_arb_mdio_paddr       =   bus_sel_mdio_bp_sel_addr;
    assign  bp_arb_mdio_penable     =   mdio_penable;
    assign  bp_arb_mdio_psel        =   mdio_psel & bus_sel_mdio_bp_sel;
    assign  bp_arb_mdio_pwrite      =   mdio_pwrite;
    assign  bp_arb_mdio_pwdata      =   mdio_pwdata;

    assign  bp_arb_cpu_paddr        =   bus_sel_cpu_bp_sel_addr;
    assign  bp_arb_cpu_penable      =   cpu_penable;
    assign  bp_arb_cpu_psel         =   cpu_psel & bus_sel_cpu_bp_sel;
    assign  bp_arb_cpu_pwrite       =   cpu_pwrite;
    assign  bp_arb_cpu_pwdata       =   cpu_pwdata[15:0];

    assign  bp_arb_apb_paddr        =   bus_sel_apb_bp_sel_addr;
    assign  bp_arb_apb_penable      =   apb_penable;
    assign  bp_arb_apb_psel         =   apb_psel & bus_sel_apb_bp_sel;
    assign  bp_arb_apb_pwrite       =   apb_pwrite;
    assign  bp_arb_apb_pwdata       =   apb_pwdata[15:0];

    // 
    assign  bw_arb_mdio_paddr       =   bus_sel_mdio_bw_sel_addr;
    assign  bw_arb_mdio_penable     =   mdio_penable;
    assign  bw_arb_mdio_psel        =   mdio_psel & bus_sel_mdio_bw_sel;
    assign  bw_arb_mdio_pwrite      =   mdio_pwrite;
    assign  bw_arb_mdio_pwdata      =   mdio_pwdata;

    assign  bw_arb_cpu_paddr        =   bus_sel_cpu_bw_sel_addr;
    assign  bw_arb_cpu_penable      =   cpu_penable;
    assign  bw_arb_cpu_psel         =   cpu_psel & bus_sel_cpu_bw_sel;
    assign  bw_arb_cpu_pwrite       =   cpu_pwrite;
    assign  bw_arb_cpu_pwdata       =   cpu_pwdata[15:0];

    assign  bw_arb_apb_paddr        =   bus_sel_apb_bw_sel_addr;
    assign  bw_arb_apb_penable      =   apb_penable;
    assign  bw_arb_apb_psel         =   apb_psel & bus_sel_apb_bw_sel;
    assign  bw_arb_apb_pwrite       =   apb_pwrite;
    assign  bw_arb_apb_pwdata       =   apb_pwdata[15:0];

    // 
    assign  mem_arb_mdio_paddr       =   bus_sel_mdio_mem_sel_addr;
    assign  mem_arb_mdio_penable     =   mdio_penable;
    assign  mem_arb_mdio_psel        =   mdio_psel & bus_sel_mdio_mem_sel;
    assign  mem_arb_mdio_pwrite      =   mdio_pwrite;
    assign  mem_arb_mdio_pwdata      =   mdio_pwdata;

    assign  mem_arb_cpu_paddr        =   bus_sel_cpu_mem_sel_addr;
    assign  mem_arb_cpu_penable      =   cpu_penable;
    assign  mem_arb_cpu_psel         =   cpu_psel & bus_sel_cpu_mem_sel;
    assign  mem_arb_cpu_pwrite       =   cpu_pwrite;
    assign  mem_arb_cpu_pwdata       =   cpu_pwdata[15:0];

    assign  mem_arb_apb_paddr        =   bus_sel_apb_mem_sel_addr;
    assign  mem_arb_apb_penable      =   apb_penable;
    assign  mem_arb_apb_psel         =   apb_psel & bus_sel_apb_mem_sel;
    assign  mem_arb_apb_pwrite       =   apb_pwrite;
    assign  mem_arb_apb_pwdata       =   apb_pwdata[15:0];

    // 
    assign  pma_arb_mdio_paddr      =   bus_sel_mdio_pma_sel_addr;
    assign  pma_arb_mdio_penable    =   mdio_penable;
    assign  pma_arb_mdio_psel       =   mdio_psel & bus_sel_mdio_pma_sel;
    assign  pma_arb_mdio_pwrite     =   mdio_pwrite;
    assign  pma_arb_mdio_pwdata     =   mdio_pwdata;

    assign  pma_arb_cpu_paddr       =   bus_sel_cpu_pma_sel_addr;
    assign  pma_arb_cpu_penable     =   cpu_penable;
    assign  pma_arb_cpu_psel        =   cpu_psel & bus_sel_cpu_pma_sel;
    assign  pma_arb_cpu_pwrite      =   cpu_pwrite;
    assign  pma_arb_cpu_pwdata      =   cpu_pwdata[15:0];

    assign  pma_arb_apb_paddr       =   bus_sel_apb_pma_sel_addr;
    assign  pma_arb_apb_penable     =   apb_penable;
    assign  pma_arb_apb_psel        =   apb_psel & bus_sel_apb_pma_sel;
    assign  pma_arb_apb_pwrite      =   apb_pwrite;
    assign  pma_arb_apb_pwdata      =   apb_pwdata[15:0];

    // 
    assign  dbg_arb_mdio_paddr      =   bus_sel_mdio_dbg_sel_addr;
    assign  dbg_arb_mdio_penable    =   mdio_penable;
    assign  dbg_arb_mdio_psel       =   mdio_psel & bus_sel_mdio_dbg_sel;
    assign  dbg_arb_mdio_pwrite     =   mdio_pwrite;
    assign  dbg_arb_mdio_pwdata     =   mdio_pwdata;

    assign  dbg_arb_cpu_paddr       =   bus_sel_cpu_dbg_sel_addr;
    assign  dbg_arb_cpu_penable     =   cpu_penable;
    assign  dbg_arb_cpu_psel        =   cpu_psel & bus_sel_cpu_dbg_sel;
    assign  dbg_arb_cpu_pwrite      =   cpu_pwrite;
    assign  dbg_arb_cpu_pwdata      =   cpu_pwdata[15:0];

    assign  dbg_arb_apb_paddr       =   bus_sel_apb_dbg_sel_addr;
    assign  dbg_arb_apb_penable     =   apb_penable;
    assign  dbg_arb_apb_psel        =   apb_psel & bus_sel_apb_dbg_sel;
    assign  dbg_arb_apb_pwrite      =   apb_pwrite;
    assign  dbg_arb_apb_pwdata      =   apb_pwdata[15:0];

    // 
    assign  pktbist_arb_mdio_paddr      =   bus_sel_mdio_pktbist_sel_addr;
    assign  pktbist_arb_mdio_penable    =   mdio_penable;
    assign  pktbist_arb_mdio_psel       =   mdio_psel & bus_sel_mdio_pktbist_sel;
    assign  pktbist_arb_mdio_pwrite     =   mdio_pwrite;
    assign  pktbist_arb_mdio_pwdata     =   mdio_pwdata;

    assign  pktbist_arb_cpu_paddr       =   bus_sel_cpu_pktbist_sel_addr;
    assign  pktbist_arb_cpu_penable     =   cpu_penable;
    assign  pktbist_arb_cpu_psel        =   cpu_psel & bus_sel_cpu_pktbist_sel;
    assign  pktbist_arb_cpu_pwrite      =   cpu_pwrite;
    assign  pktbist_arb_cpu_pwdata      =   cpu_pwdata[15:0];

    assign  pktbist_arb_apb_paddr       =   bus_sel_apb_pktbist_sel_addr;
    assign  pktbist_arb_apb_penable     =   apb_penable;
    assign  pktbist_arb_apb_psel        =   apb_psel & bus_sel_apb_pktbist_sel;
    assign  pktbist_arb_apb_pwrite      =   apb_pwrite;
    assign  pktbist_arb_apb_pwdata      =   apb_pwdata[15:0];

    // 
    assign  serdes_arb_mdio_paddr      =   bus_sel_mdio_serdes_sel_addr;
    assign  serdes_arb_mdio_penable    =   mdio_penable;
    assign  serdes_arb_mdio_psel       =   mdio_psel & bus_sel_mdio_serdes_sel;
    assign  serdes_arb_mdio_pwrite     =   mdio_pwrite;
    assign  serdes_arb_mdio_pwdata     =   mdio_pwdata;

    assign  serdes_arb_cpu_paddr       =   bus_sel_cpu_serdes_sel_addr;
    assign  serdes_arb_cpu_penable     =   cpu_penable;
    assign  serdes_arb_cpu_psel        =   cpu_psel & bus_sel_cpu_serdes_sel;
    assign  serdes_arb_cpu_pwrite      =   cpu_pwrite;
    assign  serdes_arb_cpu_pwdata      =   cpu_pwdata[15:0];

    assign  serdes_arb_apb_paddr       =   bus_sel_apb_serdes_sel_addr;
    assign  serdes_arb_apb_penable     =   apb_penable;
    assign  serdes_arb_apb_psel        =   apb_psel & bus_sel_apb_serdes_sel;
    assign  serdes_arb_apb_pwrite      =   apb_pwrite;
    assign  serdes_arb_apb_pwdata      =   apb_pwdata[15:0];

    // 
    assign  xmii_bdg_arb_mdio_paddr      =   bus_sel_mdio_xmii_bdg_sel_addr;
    assign  xmii_bdg_arb_mdio_penable    =   mdio_penable;
    assign  xmii_bdg_arb_mdio_psel       =   mdio_psel & bus_sel_mdio_xmii_bdg_sel;
    assign  xmii_bdg_arb_mdio_pwrite     =   mdio_pwrite;
    assign  xmii_bdg_arb_mdio_pwdata     =   mdio_pwdata;

    assign  xmii_bdg_arb_cpu_paddr       =   bus_sel_cpu_xmii_bdg_sel_addr;
    assign  xmii_bdg_arb_cpu_penable     =   cpu_penable;
    assign  xmii_bdg_arb_cpu_psel        =   cpu_psel & bus_sel_cpu_xmii_bdg_sel;
    assign  xmii_bdg_arb_cpu_pwrite      =   cpu_pwrite;
    assign  xmii_bdg_arb_cpu_pwdata      =   cpu_pwdata[15:0];

    assign  xmii_bdg_arb_apb_paddr       =   bus_sel_apb_xmii_bdg_sel_addr;
    assign  xmii_bdg_arb_apb_penable     =   apb_penable;
    assign  xmii_bdg_arb_apb_psel        =   apb_psel & bus_sel_apb_xmii_bdg_sel;
    assign  xmii_bdg_arb_apb_pwrite      =   apb_pwrite;
    assign  xmii_bdg_arb_apb_pwdata      =   apb_pwdata[15:0];

    // 
    assign  rgmii_arb_mdio_paddr      =   bus_sel_mdio_rgmii_sel_addr;
    assign  rgmii_arb_mdio_penable    =   mdio_penable;
    assign  rgmii_arb_mdio_psel       =   mdio_psel & bus_sel_mdio_rgmii_sel;
    assign  rgmii_arb_mdio_pwrite     =   mdio_pwrite;
    assign  rgmii_arb_mdio_pwdata     =   mdio_pwdata;

    assign  rgmii_arb_cpu_paddr       =   bus_sel_cpu_rgmii_sel_addr;
    assign  rgmii_arb_cpu_penable     =   cpu_penable;
    assign  rgmii_arb_cpu_psel        =   cpu_psel & bus_sel_cpu_rgmii_sel;
    assign  rgmii_arb_cpu_pwrite      =   cpu_pwrite;
    assign  rgmii_arb_cpu_pwdata      =   cpu_pwdata[15:0];

    assign  rgmii_arb_apb_paddr       =   bus_sel_apb_rgmii_sel_addr;
    assign  rgmii_arb_apb_penable     =   apb_penable;
    assign  rgmii_arb_apb_psel        =   apb_psel & bus_sel_apb_rgmii_sel;
    assign  rgmii_arb_apb_pwrite      =   apb_pwrite;
    assign  rgmii_arb_apb_pwdata      =   apb_pwdata[15:0];

    // 
    assign  ptp_arb_mdio_paddr      =   bus_sel_mdio_ptp_sel_addr;
    assign  ptp_arb_mdio_penable    =   mdio_penable;
    assign  ptp_arb_mdio_psel       =   mdio_psel & bus_sel_mdio_ptp_sel;
    assign  ptp_arb_mdio_pwrite     =   mdio_pwrite;
    assign  ptp_arb_mdio_pwdata     =   mdio_pwdata;

    assign  ptp_arb_cpu_paddr       =   bus_sel_cpu_ptp_sel_addr;
    assign  ptp_arb_cpu_penable     =   cpu_penable;
    assign  ptp_arb_cpu_psel        =   cpu_psel & bus_sel_cpu_ptp_sel;
    assign  ptp_arb_cpu_pwrite      =   cpu_pwrite;
    assign  ptp_arb_cpu_pwdata      =   cpu_pwdata[15:0];

    assign  ptp_arb_apb_paddr       =   bus_sel_apb_ptp_sel_addr;
    assign  ptp_arb_apb_penable     =   apb_penable;
    assign  ptp_arb_apb_psel        =   apb_psel & bus_sel_apb_ptp_sel;
    assign  ptp_arb_apb_pwrite      =   apb_pwrite;
    assign  ptp_arb_apb_pwdata      =   apb_pwdata[15:0];

    // 
    assign  xmii_rmtcg_arb_mdio_paddr      =   bus_sel_mdio_xmii_rmtcg_sel_addr;
    assign  xmii_rmtcg_arb_mdio_penable    =   mdio_penable;
    assign  xmii_rmtcg_arb_mdio_psel       =   mdio_psel & bus_sel_mdio_xmii_rmtcg_sel;
    assign  xmii_rmtcg_arb_mdio_pwrite     =   mdio_pwrite;
    assign  xmii_rmtcg_arb_mdio_pwdata     =   mdio_pwdata;

    assign  xmii_rmtcg_arb_cpu_paddr       =   bus_sel_cpu_xmii_rmtcg_sel_addr;
    assign  xmii_rmtcg_arb_cpu_penable     =   cpu_penable;
    assign  xmii_rmtcg_arb_cpu_psel        =   cpu_psel & bus_sel_cpu_xmii_rmtcg_sel;
    assign  xmii_rmtcg_arb_cpu_pwrite      =   cpu_pwrite;
    assign  xmii_rmtcg_arb_cpu_pwdata      =   cpu_pwdata[15:0];

    assign  xmii_rmtcg_arb_apb_paddr       =   bus_sel_apb_xmii_rmtcg_sel_addr;
    assign  xmii_rmtcg_arb_apb_penable     =   apb_penable;
    assign  xmii_rmtcg_arb_apb_psel        =   apb_psel & bus_sel_apb_xmii_rmtcg_sel;
    assign  xmii_rmtcg_arb_apb_pwrite      =   apb_pwrite;
    assign  xmii_rmtcg_arb_apb_pwdata      =   apb_pwdata[15:0];

    // 
    assign  iopad_arb_mdio_paddr   =   bus_sel_mdio_iopad_sel_addr;
    assign  iopad_arb_mdio_penable =   mdio_penable;
    assign  iopad_arb_mdio_psel    =   mdio_psel & bus_sel_mdio_iopad_sel;
    assign  iopad_arb_mdio_pwrite  =   mdio_pwrite;
    assign  iopad_arb_mdio_pwdata  =   mdio_pwdata;

    assign  iopad_arb_cpu_paddr    =   bus_sel_cpu_iopad_sel_addr;
    assign  iopad_arb_cpu_penable  =   cpu_penable;
    assign  iopad_arb_cpu_psel     =   cpu_psel & bus_sel_cpu_iopad_sel;
    assign  iopad_arb_cpu_pwrite   =   cpu_pwrite;
    assign  iopad_arb_cpu_pwdata   =   cpu_pwdata[15:0];

    assign  iopad_arb_apb_paddr    =   bus_sel_apb_iopad_sel_addr;
    assign  iopad_arb_apb_penable  =   apb_penable;
    assign  iopad_arb_apb_psel     =   apb_psel & bus_sel_apb_iopad_sel;
    assign  iopad_arb_apb_pwrite   =   apb_pwrite;
    assign  iopad_arb_apb_pwdata   =   apb_pwdata[15:0];

    // 
    assign  analog_arb_mdio_paddr   =   bus_sel_mdio_analog_sel_addr;
    assign  analog_arb_mdio_penable =   mdio_penable;
    assign  analog_arb_mdio_psel    =   mdio_psel & bus_sel_mdio_analog_sel;
    assign  analog_arb_mdio_pwrite  =   mdio_pwrite;
    assign  analog_arb_mdio_pwdata  =   mdio_pwdata;

    assign  analog_arb_cpu_paddr    =   bus_sel_cpu_analog_sel_addr;
    assign  analog_arb_cpu_penable  =   cpu_penable;
    assign  analog_arb_cpu_psel     =   cpu_psel & bus_sel_cpu_analog_sel;
    assign  analog_arb_cpu_pwrite   =   cpu_pwrite;
    assign  analog_arb_cpu_pwdata   =   cpu_pwdata[15:0];

    assign  analog_arb_apb_paddr    =   bus_sel_apb_analog_sel_addr;
    assign  analog_arb_apb_penable  =   apb_penable;
    assign  analog_arb_apb_psel     =   apb_psel & bus_sel_apb_analog_sel;
    assign  analog_arb_apb_pwrite   =   apb_pwrite;
    assign  analog_arb_apb_pwdata   =   apb_pwdata[15:0];

    arbiter #(21,16,16)
    u_arb_top
    (
    .clk                        (clk                            ),
    .rstn                       (rstn                           ),
    .cfg_timeout                (cfg_timeout                    ),

    .mdio_paddr                 (top_arb_mdio_paddr             ),
    .mdio_penable               (top_arb_mdio_penable           ),
    .mdio_psel                  (top_arb_mdio_psel              ),
    .mdio_pwrite                (top_arb_mdio_pwrite            ),
    .mdio_pwdata                (top_arb_mdio_pwdata            ),
    .mdio_pready                (top_arb_mdio_pready            ),
    .mdio_prdata                (top_arb_mdio_prdata            ),

    .cpu_paddr                  (top_arb_cpu_paddr              ),
    .cpu_penable                (top_arb_cpu_penable            ),
    .cpu_psel                   (top_arb_cpu_psel               ),
    .cpu_pwrite                 (top_arb_cpu_pwrite             ),
    .cpu_pwdata                 (top_arb_cpu_pwdata             ),
    .cpu_pready                 (top_arb_cpu_pready             ),
    .cpu_prdata                 (top_arb_cpu_prdata             ),

    .apb_paddr                  (top_arb_apb_paddr              ),
    .apb_penable                (top_arb_apb_penable            ),
    .apb_psel                   (top_arb_apb_psel               ),
    .apb_pwrite                 (top_arb_apb_pwrite             ),
    .apb_pwdata                 (top_arb_apb_pwdata             ),
    .apb_pready                 (top_arb_apb_pready             ),
    .apb_prdata                 (top_arb_apb_prdata             ),

    .req_addr                   (top_req_addr                   ),
    .req_ready                  (top_req_ready                  ),
    .req_rdata                  (top_req_rdata                  ),
    .req_write                  (top_req_write                  ),
    .req_sel                    (top_req_sel                    ),
    .req_wdata                  (top_req_wdata                  )
    );

    arbiter #(21,16,16)
    u_arb_bp
    (
    .clk                        (clk                            ),
    .rstn                       (rstn                           ),
    .cfg_timeout                (cfg_timeout                    ),

    .mdio_paddr                 (bp_arb_mdio_paddr              ),
    .mdio_penable               (bp_arb_mdio_penable            ),
    .mdio_psel                  (bp_arb_mdio_psel               ),
    .mdio_pwrite                (bp_arb_mdio_pwrite             ),
    .mdio_pwdata                (bp_arb_mdio_pwdata             ),
    .mdio_pready                (bp_arb_mdio_pready             ),
    .mdio_prdata                (bp_arb_mdio_prdata             ),

    .cpu_paddr                  (bp_arb_cpu_paddr               ),
    .cpu_penable                (bp_arb_cpu_penable             ),
    .cpu_psel                   (bp_arb_cpu_psel                ),
    .cpu_pwrite                 (bp_arb_cpu_pwrite              ),
    .cpu_pwdata                 (bp_arb_cpu_pwdata              ),
    .cpu_pready                 (bp_arb_cpu_pready              ),
    .cpu_prdata                 (bp_arb_cpu_prdata              ),

    .apb_paddr                  (bp_arb_apb_paddr               ),
    .apb_penable                (bp_arb_apb_penable             ),
    .apb_psel                   (bp_arb_apb_psel                ),
    .apb_pwrite                 (bp_arb_apb_pwrite              ),
    .apb_pwdata                 (bp_arb_apb_pwdata              ),
    .apb_pready                 (bp_arb_apb_pready              ),
    .apb_prdata                 (bp_arb_apb_prdata              ),

    .req_addr                   (bp_req_addr                    ),
    .req_ready                  (bp_req_ready                   ),
    .req_rdata                  (bp_req_rdata                   ),
    .req_write                  (bp_req_write                   ),
    .req_sel                    (bp_req_sel                     ),
    .req_wdata                  (bp_req_wdata                   )
    );

    arbiter #(21,16,16)
    u_arb_bw
    (
    .clk                        (clk                            ),
    .rstn                       (rstn                           ),
    .cfg_timeout                (cfg_timeout                    ),

    .mdio_paddr                 (bw_arb_mdio_paddr              ),
    .mdio_penable               (bw_arb_mdio_penable            ),
    .mdio_psel                  (bw_arb_mdio_psel               ),
    .mdio_pwrite                (bw_arb_mdio_pwrite             ),
    .mdio_pwdata                (bw_arb_mdio_pwdata             ),
    .mdio_pready                (bw_arb_mdio_pready             ),
    .mdio_prdata                (bw_arb_mdio_prdata             ),

    .cpu_paddr                  (bw_arb_cpu_paddr               ),
    .cpu_penable                (bw_arb_cpu_penable             ),
    .cpu_psel                   (bw_arb_cpu_psel                ),
    .cpu_pwrite                 (bw_arb_cpu_pwrite              ),
    .cpu_pwdata                 (bw_arb_cpu_pwdata              ),
    .cpu_pready                 (bw_arb_cpu_pready              ),
    .cpu_prdata                 (bw_arb_cpu_prdata              ),

    .apb_paddr                  (bw_arb_apb_paddr               ),
    .apb_penable                (bw_arb_apb_penable             ),
    .apb_psel                   (bw_arb_apb_psel                ),
    .apb_pwrite                 (bw_arb_apb_pwrite              ),
    .apb_pwdata                 (bw_arb_apb_pwdata              ),
    .apb_pready                 (bw_arb_apb_pready              ),
    .apb_prdata                 (bw_arb_apb_prdata              ),

    .req_addr                   (bw_req_addr                    ),
    .req_ready                  (bw_req_ready                   ),
    .req_rdata                  (bw_req_rdata                   ),
    .req_write                  (bw_req_write                   ),
    .req_sel                    (bw_req_sel                     ),
    .req_wdata                  (bw_req_wdata                   )
    );

    arbiter #(21,16,16)
    u_arb_mem
    (
    .clk                        (clk                            ),
    .rstn                       (rstn                           ),
    .cfg_timeout                (cfg_timeout                    ),

    .mdio_paddr                 (mem_arb_mdio_paddr             ),
    .mdio_penable               (mem_arb_mdio_penable           ),
    .mdio_psel                  (mem_arb_mdio_psel              ),
    .mdio_pwrite                (mem_arb_mdio_pwrite            ),
    .mdio_pwdata                (mem_arb_mdio_pwdata            ),
    .mdio_pready                (mem_arb_mdio_pready            ),
    .mdio_prdata                (mem_arb_mdio_prdata            ),

    .cpu_paddr                  (mem_arb_cpu_paddr              ),
    .cpu_penable                (mem_arb_cpu_penable            ),
    .cpu_psel                   (mem_arb_cpu_psel               ),
    .cpu_pwrite                 (mem_arb_cpu_pwrite             ),
    .cpu_pwdata                 (mem_arb_cpu_pwdata             ),
    .cpu_pready                 (mem_arb_cpu_pready             ),
    .cpu_prdata                 (mem_arb_cpu_prdata             ),

    .apb_paddr                  (mem_arb_apb_paddr              ),
    .apb_penable                (mem_arb_apb_penable            ),
    .apb_psel                   (mem_arb_apb_psel               ),
    .apb_pwrite                 (mem_arb_apb_pwrite             ),
    .apb_pwdata                 (mem_arb_apb_pwdata             ),
    .apb_pready                 (mem_arb_apb_pready             ),
    .apb_prdata                 (mem_arb_apb_prdata             ),

    .req_addr                   (mem_req_addr                   ),
    .req_ready                  (mem_req_ready                  ),
    .req_rdata                  (mem_req_rdata                  ),
    .req_write                  (mem_req_write                  ),
    .req_sel                    (mem_req_sel                    ),
    .req_wdata                  (mem_req_wdata                  )
    );

    arbiter #(21,16,16)
    u_arb_pma
    (
    .clk                        (clk                            ),
    .rstn                       (rstn                           ),
    .cfg_timeout                (cfg_timeout                    ),

    .mdio_paddr                 (pma_arb_mdio_paddr             ),
    .mdio_penable               (pma_arb_mdio_penable           ),
    .mdio_psel                  (pma_arb_mdio_psel              ),
    .mdio_pwrite                (pma_arb_mdio_pwrite            ),
    .mdio_pwdata                (pma_arb_mdio_pwdata            ),
    .mdio_pready                (pma_arb_mdio_pready            ),
    .mdio_prdata                (pma_arb_mdio_prdata            ),

    .cpu_paddr                  (pma_arb_cpu_paddr              ),
    .cpu_penable                (pma_arb_cpu_penable            ),
    .cpu_psel                   (pma_arb_cpu_psel               ),
    .cpu_pwrite                 (pma_arb_cpu_pwrite             ),
    .cpu_pwdata                 (pma_arb_cpu_pwdata             ),
    .cpu_pready                 (pma_arb_cpu_pready             ),
    .cpu_prdata                 (pma_arb_cpu_prdata             ),

    .apb_paddr                  (pma_arb_apb_paddr              ),
    .apb_penable                (pma_arb_apb_penable            ),
    .apb_psel                   (pma_arb_apb_psel               ),
    .apb_pwrite                 (pma_arb_apb_pwrite             ),
    .apb_pwdata                 (pma_arb_apb_pwdata             ),
    .apb_pready                 (pma_arb_apb_pready             ),
    .apb_prdata                 (pma_arb_apb_prdata             ),

    .req_addr                   (pma_req_addr                   ),
    .req_ready                  (pma_req_ready                  ),
    .req_rdata                  (pma_req_rdata                  ),
    .req_write                  (pma_req_write                  ),
    .req_sel                    (pma_req_sel                    ),
    .req_wdata                  (pma_req_wdata                  )
    );

    arbiter #(21,16,16)
    u_arb_dbg
    (
    .clk                        (clk                            ),
    .rstn                       (rstn                           ),
    .cfg_timeout                (cfg_timeout                    ),

    .mdio_paddr                 (dbg_arb_mdio_paddr             ),
    .mdio_penable               (dbg_arb_mdio_penable           ),
    .mdio_psel                  (dbg_arb_mdio_psel              ),
    .mdio_pwrite                (dbg_arb_mdio_pwrite            ),
    .mdio_pwdata                (dbg_arb_mdio_pwdata            ),
    .mdio_pready                (dbg_arb_mdio_pready            ),
    .mdio_prdata                (dbg_arb_mdio_prdata            ),

    .cpu_paddr                  (dbg_arb_cpu_paddr              ),
    .cpu_penable                (dbg_arb_cpu_penable            ),
    .cpu_psel                   (dbg_arb_cpu_psel               ),
    .cpu_pwrite                 (dbg_arb_cpu_pwrite             ),
    .cpu_pwdata                 (dbg_arb_cpu_pwdata             ),
    .cpu_pready                 (dbg_arb_cpu_pready             ),
    .cpu_prdata                 (dbg_arb_cpu_prdata             ),

    .apb_paddr                  (dbg_arb_apb_paddr              ),
    .apb_penable                (dbg_arb_apb_penable            ),
    .apb_psel                   (dbg_arb_apb_psel               ),
    .apb_pwrite                 (dbg_arb_apb_pwrite             ),
    .apb_pwdata                 (dbg_arb_apb_pwdata             ),
    .apb_pready                 (dbg_arb_apb_pready             ),
    .apb_prdata                 (dbg_arb_apb_prdata             ),

    .req_addr                   (dbg_req_addr                   ),
    .req_ready                  (dbg_req_ready                  ),
    .req_rdata                  (dbg_req_rdata                  ),
    .req_write                  (dbg_req_write                  ),
    .req_sel                    (dbg_req_sel                    ),
    .req_wdata                  (dbg_req_wdata                  )
    );

    arbiter #(21,16,16)
    u_arb_pktbist
    (
    .clk                        (clk                            ),
    .rstn                       (rstn                           ),
    .cfg_timeout                (cfg_timeout                    ),

    .mdio_paddr                 (pktbist_arb_mdio_paddr         ),
    .mdio_penable               (pktbist_arb_mdio_penable       ),
    .mdio_psel                  (pktbist_arb_mdio_psel          ),
    .mdio_pwrite                (pktbist_arb_mdio_pwrite        ),
    .mdio_pwdata                (pktbist_arb_mdio_pwdata        ),
    .mdio_pready                (pktbist_arb_mdio_pready        ),
    .mdio_prdata                (pktbist_arb_mdio_prdata        ),

    .cpu_paddr                  (pktbist_arb_cpu_paddr          ),
    .cpu_penable                (pktbist_arb_cpu_penable        ),
    .cpu_psel                   (pktbist_arb_cpu_psel           ),
    .cpu_pwrite                 (pktbist_arb_cpu_pwrite         ),
    .cpu_pwdata                 (pktbist_arb_cpu_pwdata         ),
    .cpu_pready                 (pktbist_arb_cpu_pready         ),
    .cpu_prdata                 (pktbist_arb_cpu_prdata         ),

    .apb_paddr                  (pktbist_arb_apb_paddr          ),
    .apb_penable                (pktbist_arb_apb_penable        ),
    .apb_psel                   (pktbist_arb_apb_psel           ),
    .apb_pwrite                 (pktbist_arb_apb_pwrite         ),
    .apb_pwdata                 (pktbist_arb_apb_pwdata         ),
    .apb_pready                 (pktbist_arb_apb_pready         ),
    .apb_prdata                 (pktbist_arb_apb_prdata         ),

    .req_addr                   (pktbist_req_addr               ),
    .req_ready                  (pktbist_req_ready              ),
    .req_rdata                  (pktbist_req_rdata              ),
    .req_write                  (pktbist_req_write              ),
    .req_sel                    (pktbist_req_sel                ),
    .req_wdata                  (pktbist_req_wdata              )
    );

    arbiter #(21,16,16)
    u_arb_serdes
    (
    .clk                        (clk                            ),
    .rstn                       (rstn                           ),
    .cfg_timeout                (cfg_timeout                    ),

    .mdio_paddr                 (serdes_arb_mdio_paddr          ),
    .mdio_penable               (serdes_arb_mdio_penable        ),
    .mdio_psel                  (serdes_arb_mdio_psel           ),
    .mdio_pwrite                (serdes_arb_mdio_pwrite         ),
    .mdio_pwdata                (serdes_arb_mdio_pwdata         ),
    .mdio_pready                (serdes_arb_mdio_pready         ),
    .mdio_prdata                (serdes_arb_mdio_prdata         ),

    .cpu_paddr                  (serdes_arb_cpu_paddr           ),
    .cpu_penable                (serdes_arb_cpu_penable         ),
    .cpu_psel                   (serdes_arb_cpu_psel            ),
    .cpu_pwrite                 (serdes_arb_cpu_pwrite          ),
    .cpu_pwdata                 (serdes_arb_cpu_pwdata          ),
    .cpu_pready                 (serdes_arb_cpu_pready          ),
    .cpu_prdata                 (serdes_arb_cpu_prdata          ),

    .apb_paddr                  (serdes_arb_apb_paddr           ),
    .apb_penable                (serdes_arb_apb_penable         ),
    .apb_psel                   (serdes_arb_apb_psel            ),
    .apb_pwrite                 (serdes_arb_apb_pwrite          ),
    .apb_pwdata                 (serdes_arb_apb_pwdata          ),
    .apb_pready                 (serdes_arb_apb_pready          ),
    .apb_prdata                 (serdes_arb_apb_prdata          ),

    .req_addr                   (serdes_req_addr                ),
    .req_ready                  (serdes_req_ready               ),
    .req_rdata                  (serdes_req_rdata               ),
    .req_write                  (serdes_req_write               ),
    .req_sel                    (serdes_req_sel                 ),
    .req_wdata                  (serdes_req_wdata               )
    );

    arbiter #(21,16,16)
    u_arb_xmii_bdg
    (
    .clk                        (clk                            ),
    .rstn                       (rstn                           ),
    .cfg_timeout                (cfg_timeout                    ),

    .mdio_paddr                 (xmii_bdg_arb_mdio_paddr        ),
    .mdio_penable               (xmii_bdg_arb_mdio_penable      ),
    .mdio_psel                  (xmii_bdg_arb_mdio_psel         ),
    .mdio_pwrite                (xmii_bdg_arb_mdio_pwrite       ),
    .mdio_pwdata                (xmii_bdg_arb_mdio_pwdata       ),
    .mdio_pready                (xmii_bdg_arb_mdio_pready       ),
    .mdio_prdata                (xmii_bdg_arb_mdio_prdata       ),

    .cpu_paddr                  (xmii_bdg_arb_cpu_paddr         ),
    .cpu_penable                (xmii_bdg_arb_cpu_penable       ),
    .cpu_psel                   (xmii_bdg_arb_cpu_psel          ),
    .cpu_pwrite                 (xmii_bdg_arb_cpu_pwrite        ),
    .cpu_pwdata                 (xmii_bdg_arb_cpu_pwdata        ),
    .cpu_pready                 (xmii_bdg_arb_cpu_pready        ),
    .cpu_prdata                 (xmii_bdg_arb_cpu_prdata        ),

    .apb_paddr                  (xmii_bdg_arb_apb_paddr         ),
    .apb_penable                (xmii_bdg_arb_apb_penable       ),
    .apb_psel                   (xmii_bdg_arb_apb_psel          ),
    .apb_pwrite                 (xmii_bdg_arb_apb_pwrite        ),
    .apb_pwdata                 (xmii_bdg_arb_apb_pwdata        ),
    .apb_pready                 (xmii_bdg_arb_apb_pready        ),
    .apb_prdata                 (xmii_bdg_arb_apb_prdata        ),

    .req_addr                   (xmii_bdg_req_addr              ),
    .req_ready                  (xmii_bdg_req_ready             ),
    .req_rdata                  (xmii_bdg_req_rdata             ),
    .req_write                  (xmii_bdg_req_write             ),
    .req_sel                    (xmii_bdg_req_sel               ),
    .req_wdata                  (xmii_bdg_req_wdata             )
    );

    arbiter #(21,16,16)
    u_arb_rgmii
    (
    .clk                        (clk                            ),
    .rstn                       (rstn                           ),
    .cfg_timeout                (cfg_timeout                    ),

    .mdio_paddr                 (rgmii_arb_mdio_paddr           ),
    .mdio_penable               (rgmii_arb_mdio_penable         ),
    .mdio_psel                  (rgmii_arb_mdio_psel            ),
    .mdio_pwrite                (rgmii_arb_mdio_pwrite          ),
    .mdio_pwdata                (rgmii_arb_mdio_pwdata          ),
    .mdio_pready                (rgmii_arb_mdio_pready          ),
    .mdio_prdata                (rgmii_arb_mdio_prdata          ),

    .cpu_paddr                  (rgmii_arb_cpu_paddr            ),
    .cpu_penable                (rgmii_arb_cpu_penable          ),
    .cpu_psel                   (rgmii_arb_cpu_psel             ),
    .cpu_pwrite                 (rgmii_arb_cpu_pwrite           ),
    .cpu_pwdata                 (rgmii_arb_cpu_pwdata           ),
    .cpu_pready                 (rgmii_arb_cpu_pready           ),
    .cpu_prdata                 (rgmii_arb_cpu_prdata           ),

    .apb_paddr                  (rgmii_arb_apb_paddr            ),
    .apb_penable                (rgmii_arb_apb_penable          ),
    .apb_psel                   (rgmii_arb_apb_psel             ),
    .apb_pwrite                 (rgmii_arb_apb_pwrite           ),
    .apb_pwdata                 (rgmii_arb_apb_pwdata           ),
    .apb_pready                 (rgmii_arb_apb_pready           ),
    .apb_prdata                 (rgmii_arb_apb_prdata           ),

    .req_addr                   (rgmii_req_addr                 ),
    .req_ready                  (rgmii_req_ready                ),
    .req_rdata                  (rgmii_req_rdata                ),
    .req_write                  (rgmii_req_write                ),
    .req_sel                    (rgmii_req_sel                  ),
    .req_wdata                  (rgmii_req_wdata                )
    );

    arbiter #(21,16,16)
    u_arb_ptp
    (
    .clk                        (clk                            ),
    .rstn                       (rstn                           ),
    .cfg_timeout                (cfg_timeout                    ),

    .mdio_paddr                 (ptp_arb_mdio_paddr              ),
    .mdio_penable               (ptp_arb_mdio_penable            ),
    .mdio_psel                  (ptp_arb_mdio_psel               ),
    .mdio_pwrite                (ptp_arb_mdio_pwrite             ),
    .mdio_pwdata                (ptp_arb_mdio_pwdata             ),
    .mdio_pready                (ptp_arb_mdio_pready             ),
    .mdio_prdata                (ptp_arb_mdio_prdata             ),

    .cpu_paddr                  (ptp_arb_cpu_paddr               ),
    .cpu_penable                (ptp_arb_cpu_penable             ),
    .cpu_psel                   (ptp_arb_cpu_psel                ),
    .cpu_pwrite                 (ptp_arb_cpu_pwrite              ),
    .cpu_pwdata                 (ptp_arb_cpu_pwdata              ),
    .cpu_pready                 (ptp_arb_cpu_pready              ),
    .cpu_prdata                 (ptp_arb_cpu_prdata              ),

    .apb_paddr                  (ptp_arb_apb_paddr               ),
    .apb_penable                (ptp_arb_apb_penable             ),
    .apb_psel                   (ptp_arb_apb_psel                ),
    .apb_pwrite                 (ptp_arb_apb_pwrite              ),
    .apb_pwdata                 (ptp_arb_apb_pwdata              ),
    .apb_pready                 (ptp_arb_apb_pready              ),
    .apb_prdata                 (ptp_arb_apb_prdata              ),

    .req_addr                   (ptp_req_addr                    ),
    .req_ready                  (ptp_req_ready                   ),
    .req_rdata                  (ptp_req_rdata                   ),
    .req_write                  (ptp_req_write                   ),
    .req_sel                    (ptp_req_sel                     ),
    .req_wdata                  (ptp_req_wdata                   )
    );

    arbiter #(21,16,16)
    u_arb_xmii_rmtcg
    (
    .clk                        (clk                            ),
    .rstn                       (rstn                           ),
    .cfg_timeout                (cfg_timeout                    ),

    .mdio_paddr                 (xmii_rmtcg_arb_mdio_paddr      ),
    .mdio_penable               (xmii_rmtcg_arb_mdio_penable    ),
    .mdio_psel                  (xmii_rmtcg_arb_mdio_psel       ),
    .mdio_pwrite                (xmii_rmtcg_arb_mdio_pwrite     ),
    .mdio_pwdata                (xmii_rmtcg_arb_mdio_pwdata     ),
    .mdio_pready                (xmii_rmtcg_arb_mdio_pready     ),
    .mdio_prdata                (xmii_rmtcg_arb_mdio_prdata     ),

    .cpu_paddr                  (xmii_rmtcg_arb_cpu_paddr       ),
    .cpu_penable                (xmii_rmtcg_arb_cpu_penable     ),
    .cpu_psel                   (xmii_rmtcg_arb_cpu_psel        ),
    .cpu_pwrite                 (xmii_rmtcg_arb_cpu_pwrite      ),
    .cpu_pwdata                 (xmii_rmtcg_arb_cpu_pwdata      ),
    .cpu_pready                 (xmii_rmtcg_arb_cpu_pready      ),
    .cpu_prdata                 (xmii_rmtcg_arb_cpu_prdata      ),

    .apb_paddr                  (xmii_rmtcg_arb_apb_paddr       ),
    .apb_penable                (xmii_rmtcg_arb_apb_penable     ),
    .apb_psel                   (xmii_rmtcg_arb_apb_psel        ),
    .apb_pwrite                 (xmii_rmtcg_arb_apb_pwrite      ),
    .apb_pwdata                 (xmii_rmtcg_arb_apb_pwdata      ),
    .apb_pready                 (xmii_rmtcg_arb_apb_pready      ),
    .apb_prdata                 (xmii_rmtcg_arb_apb_prdata      ),

    .req_addr                   (xmii_rmtcg_req_addr            ),
    .req_ready                  (xmii_rmtcg_req_ready           ),
    .req_rdata                  (xmii_rmtcg_req_rdata           ),
    .req_write                  (xmii_rmtcg_req_write           ),
    .req_sel                    (xmii_rmtcg_req_sel             ),
    .req_wdata                  (xmii_rmtcg_req_wdata           )
    );

    arbiter #(21,16,16)
    u_arb_iopad
    (
    .clk                        (clk                            ),
    .rstn                       (rstn                           ),
    .cfg_timeout                (cfg_timeout                    ),

    .mdio_paddr                 (iopad_arb_mdio_paddr           ),
    .mdio_penable               (iopad_arb_mdio_penable         ),
    .mdio_psel                  (iopad_arb_mdio_psel            ),
    .mdio_pwrite                (iopad_arb_mdio_pwrite          ),
    .mdio_pwdata                (iopad_arb_mdio_pwdata          ),
    .mdio_pready                (iopad_arb_mdio_pready          ),
    .mdio_prdata                (iopad_arb_mdio_prdata          ),

    .cpu_paddr                  (iopad_arb_cpu_paddr            ),
    .cpu_penable                (iopad_arb_cpu_penable          ),
    .cpu_psel                   (iopad_arb_cpu_psel             ),
    .cpu_pwrite                 (iopad_arb_cpu_pwrite           ),
    .cpu_pwdata                 (iopad_arb_cpu_pwdata           ),
    .cpu_pready                 (iopad_arb_cpu_pready           ),
    .cpu_prdata                 (iopad_arb_cpu_prdata           ),

    .apb_paddr                  (iopad_arb_apb_paddr            ),
    .apb_penable                (iopad_arb_apb_penable          ),
    .apb_psel                   (iopad_arb_apb_psel             ),
    .apb_pwrite                 (iopad_arb_apb_pwrite           ),
    .apb_pwdata                 (iopad_arb_apb_pwdata           ),
    .apb_pready                 (iopad_arb_apb_pready           ),
    .apb_prdata                 (iopad_arb_apb_prdata           ),

    .req_addr                   (iopad_req_addr                 ),
    .req_ready                  (iopad_req_ready                ),
    .req_rdata                  (iopad_req_rdata                ),
    .req_write                  (iopad_req_write                ),
    .req_sel                    (iopad_req_sel                  ),
    .req_wdata                  (iopad_req_wdata                )
    );

    arbiter #(21,16,16)
    u_arb_analog
    (
    .clk                        (clk                            ),
    .rstn                       (rstn                           ),
    .cfg_timeout                (cfg_timeout                    ),

    .mdio_paddr                 (analog_arb_mdio_paddr          ),
    .mdio_penable               (analog_arb_mdio_penable        ),
    .mdio_psel                  (analog_arb_mdio_psel           ),
    .mdio_pwrite                (analog_arb_mdio_pwrite         ),
    .mdio_pwdata                (analog_arb_mdio_pwdata         ),
    .mdio_pready                (analog_arb_mdio_pready         ),
    .mdio_prdata                (analog_arb_mdio_prdata         ),

    .cpu_paddr                  (analog_arb_cpu_paddr           ),
    .cpu_penable                (analog_arb_cpu_penable         ),
    .cpu_psel                   (analog_arb_cpu_psel            ),
    .cpu_pwrite                 (analog_arb_cpu_pwrite          ),
    .cpu_pwdata                 (analog_arb_cpu_pwdata          ),
    .cpu_pready                 (analog_arb_cpu_pready          ),
    .cpu_prdata                 (analog_arb_cpu_prdata          ),

    .apb_paddr                  (analog_arb_apb_paddr           ),
    .apb_penable                (analog_arb_apb_penable         ),
    .apb_psel                   (analog_arb_apb_psel            ),
    .apb_pwrite                 (analog_arb_apb_pwrite          ),
    .apb_pwdata                 (analog_arb_apb_pwdata          ),
    .apb_pready                 (analog_arb_apb_pready          ),
    .apb_prdata                 (analog_arb_apb_prdata          ),

    .req_addr                   (analog_req_addr                ),
    .req_ready                  (analog_req_ready               ),
    .req_rdata                  (analog_req_rdata               ),
    .req_write                  (analog_req_write               ),
    .req_sel                    (analog_req_sel                 ),
    .req_wdata                  (analog_req_wdata               )
    );

    bus_sel #(21)
    u_bus_sel_mdio
    (
    .master_addr                (bus_sel_mdio_master_addr       ),
    .top_sel_addr               (bus_sel_mdio_top_sel_addr      ),
    .bp_sel_addr                (bus_sel_mdio_bp_sel_addr       ),
    .bw_sel_addr                (bus_sel_mdio_bw_sel_addr       ),
    .mem_sel_addr               (bus_sel_mdio_mem_sel_addr      ),
    .pma_sel_addr               (bus_sel_mdio_pma_sel_addr      ),
    .dbg_sel_addr               (bus_sel_mdio_dbg_sel_addr      ),
    .pktbist_sel_addr           (bus_sel_mdio_pktbist_sel_addr  ),
    .serdes_sel_addr            (bus_sel_mdio_serdes_sel_addr   ),
    .xmii_bdg_sel_addr          (bus_sel_mdio_xmii_bdg_sel_addr ),
    .rgmii_sel_addr             (bus_sel_mdio_rgmii_sel_addr    ),
    .ptp_sel_addr               (bus_sel_mdio_ptp_sel_addr      ),
    .xmii_rmtcg_sel_addr        (bus_sel_mdio_xmii_rmtcg_sel_addr),
    .iopad_sel_addr             (bus_sel_mdio_iopad_sel_addr    ),
    .analog_sel_addr            (bus_sel_mdio_analog_sel_addr   ),
    .top_sel                    (bus_sel_mdio_top_sel           ),
    .bp_sel                     (bus_sel_mdio_bp_sel            ),
    .bw_sel                     (bus_sel_mdio_bw_sel            ),
    .mem_sel                    (bus_sel_mdio_mem_sel           ),
    .pma_sel                    (bus_sel_mdio_pma_sel           ),
    .dbg_sel                    (bus_sel_mdio_dbg_sel           ),
    .pktbist_sel                (bus_sel_mdio_pktbist_sel       ),
    .serdes_sel                 (bus_sel_mdio_serdes_sel        ),
    .xmii_bdg_sel               (bus_sel_mdio_xmii_bdg_sel      ),
    .rgmii_sel                  (bus_sel_mdio_rgmii_sel         ),
    .ptp_sel                    (bus_sel_mdio_ptp_sel           ),
    .xmii_rmtcg_sel             (bus_sel_mdio_xmii_rmtcg_sel    ),
    .iopad_sel                  (bus_sel_mdio_iopad_sel         ),
    .analog_sel                 (bus_sel_mdio_analog_sel        )
    );

    bus_sel #(21)
    u_bus_sel_cpu
    (
    .master_addr                (bus_sel_cpu_master_addr        ),
    .top_sel_addr               (bus_sel_cpu_top_sel_addr       ),
    .bp_sel_addr                (bus_sel_cpu_bp_sel_addr        ),
    .bw_sel_addr                (bus_sel_cpu_bw_sel_addr        ),
    .mem_sel_addr               (bus_sel_cpu_mem_sel_addr       ),
    .pma_sel_addr               (bus_sel_cpu_pma_sel_addr       ),
    .dbg_sel_addr               (bus_sel_cpu_dbg_sel_addr       ),
    .pktbist_sel_addr           (bus_sel_cpu_pktbist_sel_addr   ),
    .serdes_sel_addr            (bus_sel_cpu_serdes_sel_addr    ),
    .xmii_bdg_sel_addr          (bus_sel_cpu_xmii_bdg_sel_addr  ),
    .rgmii_sel_addr             (bus_sel_cpu_rgmii_sel_addr     ),
    .ptp_sel_addr               (bus_sel_cpu_ptp_sel_addr       ),
    .xmii_rmtcg_sel_addr        (bus_sel_cpu_xmii_rmtcg_sel_addr),
    .iopad_sel_addr             (bus_sel_cpu_iopad_sel_addr     ),
    .analog_sel_addr            (bus_sel_cpu_analog_sel_addr    ),
    .top_sel                    (bus_sel_cpu_top_sel            ),
    .bp_sel                     (bus_sel_cpu_bp_sel             ),
    .bw_sel                     (bus_sel_cpu_bw_sel             ),
    .mem_sel                    (bus_sel_cpu_mem_sel            ),
    .pma_sel                    (bus_sel_cpu_pma_sel            ),
    .dbg_sel                    (bus_sel_cpu_dbg_sel            ),
    .pktbist_sel                (bus_sel_cpu_pktbist_sel        ),
    .serdes_sel                 (bus_sel_cpu_serdes_sel         ),
    .xmii_bdg_sel               (bus_sel_cpu_xmii_bdg_sel       ),
    .rgmii_sel                  (bus_sel_cpu_rgmii_sel          ),
    .ptp_sel                    (bus_sel_cpu_ptp_sel            ),
    .xmii_rmtcg_sel             (bus_sel_cpu_xmii_rmtcg_sel     ),
    .iopad_sel                  (bus_sel_cpu_iopad_sel          ),
    .analog_sel                 (bus_sel_cpu_analog_sel         )
    );

    bus_sel #(21)

    u_bus_sel_apb
    (
    .master_addr                (bus_sel_apb_master_addr        ),
    .top_sel_addr               (bus_sel_apb_top_sel_addr       ),
    .bp_sel_addr                (bus_sel_apb_bp_sel_addr        ),
    .bw_sel_addr                (bus_sel_apb_bw_sel_addr        ),
    .mem_sel_addr               (bus_sel_apb_mem_sel_addr       ),
    .pma_sel_addr               (bus_sel_apb_pma_sel_addr       ),
    .dbg_sel_addr               (bus_sel_apb_dbg_sel_addr       ),
    .pktbist_sel_addr           (bus_sel_apb_pktbist_sel_addr   ),
    .serdes_sel_addr            (bus_sel_apb_serdes_sel_addr    ),
    .xmii_bdg_sel_addr          (bus_sel_apb_xmii_bdg_sel_addr  ),
    .rgmii_sel_addr             (bus_sel_apb_rgmii_sel_addr     ),
    .ptp_sel_addr               (bus_sel_apb_ptp_sel_addr       ),
    .xmii_rmtcg_sel_addr        (bus_sel_apb_xmii_rmtcg_sel_addr),
    .iopad_sel_addr             (bus_sel_apb_iopad_sel_addr     ),
    .analog_sel_addr            (bus_sel_apb_analog_sel_addr    ),
    .top_sel                    (bus_sel_apb_top_sel            ),
    .bp_sel                     (bus_sel_apb_bp_sel             ),
    .bw_sel                     (bus_sel_apb_bw_sel             ),
    .mem_sel                    (bus_sel_apb_mem_sel            ),
    .pma_sel                    (bus_sel_apb_pma_sel            ),
    .dbg_sel                    (bus_sel_apb_dbg_sel            ),
    .pktbist_sel                (bus_sel_apb_pktbist_sel        ),
    .serdes_sel                 (bus_sel_apb_serdes_sel         ),
    .xmii_bdg_sel               (bus_sel_apb_xmii_bdg_sel       ),
    .rgmii_sel                  (bus_sel_apb_rgmii_sel          ),
    .ptp_sel                    (bus_sel_apb_ptp_sel            ),
    .xmii_rmtcg_sel             (bus_sel_apb_xmii_rmtcg_sel     ),
    .iopad_sel                  (bus_sel_apb_iopad_sel          ),
    .analog_sel                 (bus_sel_apb_analog_sel         )
    );

endmodule
