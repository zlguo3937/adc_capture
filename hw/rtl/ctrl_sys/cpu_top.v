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
//  2023-10-20    zlguo         1.0         pico_soc_system
// --------------------------------------------------------------------
// --------------------------------------------------------------------


module cpu_top
#(
    parameter integer ROM_WIDTH    = 13
)
(
    input   wire            te,
    input   wire            hfclk_i,
    input   wire            scan_rstn,
    input   wire            erst_n_i,

    // irq pc jump
    input   wire    [31:0]  irq_pc_match,
    input   wire    [31:0]  progaddr_irq,


    // APB
    output  reg     [31:0]  req_paddr,
    output  reg             req_pwrite,
    output  reg             req_psel,
    output  reg             req_penable,
    output  reg     [31:0]  req_pwdata,
    input   wire            req_pready,
    input   wire    [31:0]  req_prdata,
    input   wire            req_pslverr,

    output  wire    [31:0]  dump_pc,
    output  wire    [31:0]  latch_sp,
    input   wire            latch_sp_clr

);

wire    [21:0]   rom_addr;
wire    [31:0]  rom_rdata;

wire            ram_wen;
wire    [21:0]   ram_addr;
wire    [31:0]  ram_wdata;
wire    [31:0]  ram_rdata;

rom u_rom(
.clk    (hfclk_i    ),
.addr   (rom_addr   ),
.rdata  (rom_rdata  )
);

ram u_ram(
.clk    (hfclk_i    ),
.wen    (ram_wen    ),
.addr   (ram_addr   ),
.wdata  (ram_wdata  ),
.rdata  (ram_rdata  )
);

endmodule
