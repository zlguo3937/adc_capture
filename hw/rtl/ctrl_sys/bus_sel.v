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
//  2023-10-05    zlguo         1.0         apb_bus_sel
//  2024-06-20    zlguo         2.0         bus_sel
// --------------------------------------------------------------------
// --------------------------------------------------------------------

`timescale 1ns/1ns

module bus_sel
#(
    parameter ADDR_WIDTH = 21
)
(
    input   wire    [ADDR_WIDTH-1:0]    master_addr,
    
    output  wire    [ADDR_WIDTH-1:0]    top_sel_addr,
    output  wire    [ADDR_WIDTH-1:0]    bp_sel_addr,
    output  wire    [ADDR_WIDTH-1:0]    bw_sel_addr,
    output  wire    [ADDR_WIDTH-1:0]    analog_sel_addr,
    output  wire    [ADDR_WIDTH-1:0]    pma_sel_addr,
    output  wire    [ADDR_WIDTH-1:0]    dbg_sel_addr,
    output  wire    [ADDR_WIDTH-1:0]    pktbist_sel_addr,
    output  wire    [ADDR_WIDTH-1:0]    serdes_sel_addr,
    output  wire    [ADDR_WIDTH-1:0]    xmii_bdg_sel_addr,
    output  wire    [ADDR_WIDTH-1:0]    rgmii_sel_addr,
    output  wire    [ADDR_WIDTH-1:0]    ptp_sel_addr,
    output  wire    [ADDR_WIDTH-1:0]    xmii_rmtcg_sel_addr ,
    output  wire    [ADDR_WIDTH-1:0]    iopad_sel_addr,
    output  wire    [ADDR_WIDTH-1:0]    mem_sel_addr,

    output  wire                        top_sel,
    output  wire                        bp_sel,
    output  wire                        bw_sel,
    output  wire                        analog_sel,
    output  wire                        pma_sel,
    output  wire                        dbg_sel,
    output  wire                        pktbist_sel,
    output  wire                        serdes_sel,
    output  wire                        xmii_bdg_sel,
    output  wire                        rgmii_sel,
    output  wire                        ptp_sel,
    output  wire                        xmii_rmtcg_sel,
    output  wire                        iopad_sel,
    output  wire                        mem_sel
);

    assign  top_sel_addr        =   master_addr - {'h0      };  // top          : group base address: 0x0
    assign  bp_sel_addr         =   master_addr - {'h1f_1000};  // bp           : group base address: 0x1f_1000
    assign  bw_sel_addr         =   master_addr - {'h1f_1400};  // bw           : group base address: 0x1f_1400
    assign  analog_sel_addr     =   master_addr - {'h1f_1800};  // analog       : group base address: 0x1f_1800
    assign  pma_sel_addr        =   master_addr - {'h1f_1c00};  // pma          : group base address: 0x1f_1c00
    assign  dbg_sel_addr        =   master_addr - {'h1f_2000};  // dbg          : group base address: 0x1f_2000
    assign  pktbist_sel_addr    =   master_addr - {'h1f_2400};  // pktbist      : group base address: 0x1f_2400
    assign  serdes_sel_addr     =   master_addr - {'h1f_2c00};  // serdes       : group base address: 0x1f_2c00
    assign  xmii_bdg_sel_addr   =   master_addr - {'h1f_3000};  // xmii_bdg     : group base address: 0x1f_3000
    assign  rgmii_sel_addr      =   master_addr - {'h1f_3400};  // rgmii        : group base address: 0x1f_3400
    assign  ptp_sel_addr        =   master_addr - {'h1f_3800};  // ptp          : group base address: 0x1f_3800
    assign  xmii_rmtcg_sel_addr =   master_addr - {'h1f_3c00};  // xmii_rmtcg   : group base address: 0x1f_3c00
    assign  iopad_sel_addr      =   master_addr - {'h1f_4000};  // iopad        : group base address: 0x1f_4000
    assign  mem_sel_addr        =   master_addr - {'h1f_4400};  // iopad        : group base address: 0x1f_4000

    assign  top_sel             =   (master_addr >= {'h0      }) && (master_addr < {'h1f_1000}); // top        : address size: 0x1f_1000
    assign  bp_sel              =   (master_addr >= {'h1f_1000}) && (master_addr < {'h1f_1400}); // bp         : address size: 0x400
    assign  bw_sel              =   (master_addr >= {'h1f_1400}) && (master_addr < {'h1f_1800}); // bw         : address size: 0x400
    assign  analog_sel          =   (master_addr >= {'h1f_1800}) && (master_addr < {'h1f_1c00}); // analog     : address size: 0x400
    assign  pma_sel             =   (master_addr >= {'h1f_1c00}) && (master_addr < {'h1f_2000}); // pma        : address size: 0x400
    assign  dbg_sel             =   (master_addr >= {'h1f_2000}) && (master_addr < {'h1f_2400}); // dbg        : address size: 0x400
    assign  pktbist_sel         =   (master_addr >= {'h1f_2400}) && (master_addr < {'h1f_2c00}); // pktbist    : address size: 0x800
    assign  serdes_sel          =   (master_addr >= {'h1f_2c00}) && (master_addr < {'h1f_3000}); // serdes     : address size: 0x400
    assign  xmii_bdg_sel        =   (master_addr >= {'h1f_3000}) && (master_addr < {'h1f_3400}); // xmii_bdg   : address size: 0x400
    assign  rgmii_sel           =   (master_addr >= {'h1f_3400}) && (master_addr < {'h1f_3800}); // rgmii      : address size: 0x400
    assign  ptp_sel             =   (master_addr >= {'h1f_3800}) && (master_addr < {'h1f_3c00}); // ptp        : address size: 0x400
    assign  xmii_rmtcg_sel      =   (master_addr >= {'h1f_3c00}) && (master_addr < {'h1f_4000}); // xmii_rmtcg : address size: 0x400
    assign  iopad_sel           =   (master_addr >= {'h1f_4000}) && (master_addr < {'h1f_4400}); // iopad      : address size: 0x400
    assign  mem_sel             =   (master_addr >= {'h1f_4400}) && (master_addr < {'h1f_c400}); // mem        : address size: 0x8000

endmodule
