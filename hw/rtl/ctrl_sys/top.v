
`timescale 1ns/1ns

module top
(
    input   wire            clk             ,
    input   wire            rstn            ,
    input   wire            pcs_clk         ,
    input   wire            pcs_rstn        ,

    input   wire    [15:0]  cfg_timeout     ,
    input   wire            in_use_mdio     ,
    input   wire            in_use_cpu      ,

    /* -----------------------------
     mdio apb interface
     ---------------------------- */
    input   wire    [31:0]  mdio_paddr      ,
    input   wire            mdio_penable    ,
    input   wire            mdio_psel       ,
    input   wire            mdio_pwrite     ,
    input   wire    [31:0]  mdio_pwdata     ,
    output  wire            mdio_pslverr    ,
    output  wire            mdio_pready     ,
    output  wire    [31:0]  mdio_prdata     ,

    /* -----------------------------
     cpu apb interface
     ---------------------------- */
    input   wire    [31:0]  cpu_paddr       ,
    input   wire            cpu_penable     ,
    input   wire            cpu_psel        ,
    input   wire            cpu_pwrite      ,
    input   wire    [31:0]  cpu_pwdata      ,
    output  wire            cpu_pslverr     ,
    output  wire            cpu_pready      ,
    output  wire    [31:0]  cpu_prdata
);

    wire            top_rf_clk              ;
    wire            top_rf_rstn             ;
    wire            top_rf_sw_rstn          ;
    wire    [31:0]  top_rf_paddr            ;
    wire            top_rf_pwrite           ;
    wire            top_rf_psel             ;
    wire    [31:0]  top_rf_pwdata           ;
    wire    [31:0]  top_rf_prdata           ;
    wire            top_rf_pready           ;
    wire    [7:0]   top_rf_REG1_15_8_rdata  ;
    wire    [3:0]   top_rf_REG1_7_4_rdata   ;
    wire    [7:0]   top_rf_REG2_15_8_rdata  ;
    wire    [3:0]   top_rf_REG2_7_4_rdata   ;
    wire    [7:0]   top_rf_REG3_15_8_rdata  ;
    wire    [3:0]   top_rf_REG3_7_4_rdata   ;
    wire    [7:0]   top_rf_REG4_15_8_rdata  ;
    wire    [3:0]   top_rf_REG4_7_4_rdata   ;
    wire    [7:0]   top_rf_REG5_15_8_rdata  ;
    wire    [3:0]   top_rf_REG5_7_4_rdata   ;
    wire    [7:0]   top_rf_REG6_15_8_rdata  ;
    wire    [3:0]   top_rf_REG6_7_4_rdata   ;
    wire            top_rf_REG1_1_rdata     ;
    wire            top_rf_REG2_1_rdata     ;
    wire            top_rf_REG3_1_rdata     ;
    wire            top_rf_REG4_1_rdata     ;
    wire            top_rf_REG5_1_rdata     ;
    wire            top_rf_REG6_1_rdata     ;
    
    wire            pcs_rf_clk              ;
    wire            pcs_rf_rstn             ;
    wire            pcs_rf_sw_rstn          ;
    wire    [31:0]  pcs_rf_paddr            ;
    wire            pcs_rf_pwrite           ;
    wire            pcs_rf_psel             ;
    wire    [31:0]  pcs_rf_pwdata           ;
    wire    [31:0]  pcs_rf_prdata           ;
    wire            pcs_rf_pready           ;
    wire    [7:0]   pcs_rf_REG1_15_8_rdata  ;
    wire    [3:0]   pcs_rf_REG1_7_4_rdata   ;
    wire    [7:0]   pcs_rf_REG2_15_8_rdata  ;
    wire    [3:0]   pcs_rf_REG2_7_4_rdata   ;
    wire    [7:0]   pcs_rf_REG3_15_8_rdata  ;
    wire    [3:0]   pcs_rf_REG3_7_4_rdata   ;
    wire    [7:0]   pcs_rf_REG4_15_8_rdata  ;
    wire    [3:0]   pcs_rf_REG4_7_4_rdata   ;
    wire    [7:0]   pcs_rf_REG5_15_8_rdata  ;
    wire    [3:0]   pcs_rf_REG5_7_4_rdata   ;
    wire    [7:0]   pcs_rf_REG6_15_8_rdata  ;
    wire    [3:0]   pcs_rf_REG6_7_4_rdata   ;
    wire            pcs_rf_REG1_1_rdata     ;
    wire            pcs_rf_REG2_1_rdata     ;
    wire            pcs_rf_REG3_1_rdata     ;
    wire            pcs_rf_REG4_1_rdata     ;
    wire            pcs_rf_REG5_1_rdata     ;
    wire            pcs_rf_REG6_1_rdata     ;
    
    wire            ctrl_sys_clk          ;
    wire            ctrl_sys_rstn         ;
    wire    [15:0]  ctrl_sys_cfg_timeout  ;
    
    wire    [31:0]  ctrl_sys_top_rf_paddr    ;
    wire            ctrl_sys_top_rf_psel     ;
    wire            ctrl_sys_top_rf_pwrite   ;
    wire    [31:0]  ctrl_sys_top_rf_pwdata   ;
    wire    [31:0]  ctrl_sys_top_rf_prdata   ;
    wire            ctrl_sys_top_rf_pready   ;
    
    wire    [31:0]  ctrl_sys_pcs_rf_paddr    ;
    wire            ctrl_sys_pcs_rf_psel     ;
    wire            ctrl_sys_pcs_rf_pwrite   ;
    wire    [31:0]  ctrl_sys_pcs_rf_pwdata   ;
    wire    [31:0]  ctrl_sys_pcs_rf_prdata   ;
    wire            ctrl_sys_pcs_rf_pready   ;
    wire            ctrl_sys_pcs_clk      ;
    wire            ctrl_sys_pcs_rstn     ;
    
    assign ctrl_sys_clk           = clk;
    assign ctrl_sys_rstn          = rstn;
    assign ctrl_sys_cfg_timeout   = cfg_timeout;
    
    assign top_rf_clk             = clk;
    assign top_rf_rstn            = rstn;
    assign top_rf_paddr           = ctrl_sys_top_rf_paddr ;
    assign top_rf_psel            = ctrl_sys_top_rf_psel  ;
    assign top_rf_pwrite          = ctrl_sys_top_rf_pwrite;
    assign top_rf_pwdata          = ctrl_sys_top_rf_pwdata;
    
    assign ctrl_sys_top_rf_prdata    = top_rf_prdata;
    assign ctrl_sys_top_rf_pready    = top_rf_pready;
    
    assign pcs_rf_clk             = pcs_clk;
    assign pcs_rf_rstn            = pcs_rstn;
    assign pcs_rf_paddr           = ctrl_sys_pcs_rf_paddr ;
    assign pcs_rf_psel            = ctrl_sys_pcs_rf_psel  ;
    assign pcs_rf_pwrite          = ctrl_sys_pcs_rf_pwrite;
    assign pcs_rf_pwdata          = ctrl_sys_pcs_rf_pwdata;
    
    assign ctrl_sys_pcs_rf_prdata    = pcs_rf_prdata;
    assign ctrl_sys_pcs_rf_pready    = pcs_rf_pready;


    pcs_regfile
    u_pcs_regfile(
    .clk                        (pcs_rf_clk                     ),
    .rstn                       (pcs_rf_rstn                    ),
    .paddr                      (pcs_rf_paddr                   ),
    .pwrite                     (pcs_rf_pwrite                  ),
    .psel                       (pcs_rf_psel                    ),
    .pwdata                     (pcs_rf_pwdata                  ),
    .prdata                     (pcs_rf_prdata                  ),
    .pready                     (pcs_rf_pready                  ),
    .REG1_15_8_rdata            (pcs_rf_REG1_15_8_rdata         ),
    .REG1_7_4_rdata             (pcs_rf_REG1_7_4_rdata          ),
    .REG2_15_8_rdata            (pcs_rf_REG2_15_8_rdata         ),
    .REG2_7_4_rdata             (pcs_rf_REG2_7_4_rdata          ),
    .REG3_15_8_rdata            (pcs_rf_REG3_15_8_rdata         ),
    .REG3_7_4_rdata             (pcs_rf_REG3_7_4_rdata          ),
    .REG4_15_8_rdata            (pcs_rf_REG4_15_8_rdata         ),
    .REG4_7_4_rdata             (pcs_rf_REG4_7_4_rdata          ),
    .REG5_15_8_rdata            (pcs_rf_REG5_15_8_rdata         ),
    .REG5_7_4_rdata             (pcs_rf_REG5_7_4_rdata          ),
    .REG6_15_8_rdata            (pcs_rf_REG6_15_8_rdata         ),
    .REG6_7_4_rdata             (pcs_rf_REG6_7_4_rdata          ),
    .REG1_1_rdata               (pcs_rf_REG1_1_rdata            ),
    .REG2_1_rdata               (pcs_rf_REG2_1_rdata            ),
    .REG3_1_rdata               (pcs_rf_REG3_1_rdata            ),
    .REG4_1_rdata               (pcs_rf_REG4_1_rdata            ),
    .REG5_1_rdata               (pcs_rf_REG5_1_rdata            ),
    .REG6_1_rdata               (pcs_rf_REG6_1_rdata            )
    );
    
    top_regfile
    u_top_regfile(
    .clk                        (top_rf_clk                     ),
    .rstn                       (top_rf_rstn                    ),
    .paddr                      (top_rf_paddr                   ),
    .pwrite                     (top_rf_pwrite                  ),
    .psel                       (top_rf_psel                    ),
    .pwdata                     (top_rf_pwdata                  ),
    .prdata                     (top_rf_prdata                  ),
    .pready                     (top_rf_pready                  ),
    .REG1_15_8_rdata            (top_rf_REG1_15_8_rdata         ),
    .REG1_7_4_rdata             (top_rf_REG1_7_4_rdata          ),
    .REG2_15_8_rdata            (top_rf_REG2_15_8_rdata         ),
    .REG2_7_4_rdata             (top_rf_REG2_7_4_rdata          ),
    .REG3_15_8_rdata            (top_rf_REG3_15_8_rdata         ),
    .REG3_7_4_rdata             (top_rf_REG3_7_4_rdata          ),
    .REG4_15_8_rdata            (top_rf_REG4_15_8_rdata         ),
    .REG4_7_4_rdata             (top_rf_REG4_7_4_rdata          ),
    .REG5_15_8_rdata            (top_rf_REG5_15_8_rdata         ),
    .REG5_7_4_rdata             (top_rf_REG5_7_4_rdata          ),
    .REG6_15_8_rdata            (top_rf_REG6_15_8_rdata         ),
    .REG6_7_4_rdata             (top_rf_REG6_7_4_rdata          ),
    .REG1_1_rdata               (top_rf_REG1_1_rdata            ),
    .REG2_1_rdata               (top_rf_REG2_1_rdata            ),
    .REG3_1_rdata               (top_rf_REG3_1_rdata            ),
    .REG4_1_rdata               (top_rf_REG4_1_rdata            ),
    .REG5_1_rdata               (top_rf_REG5_1_rdata            ),
    .REG6_1_rdata               (top_rf_REG6_1_rdata            )
    );
    
    ctrl_sys
    u_ctrl_sys(
    .clk                        (ctrl_sys_clk                   ),
    .rstn                       (ctrl_sys_rstn                  ),
    .pcs_clk                    (ctrl_sys_pcs_clk               ),
    .pcs_rstn                   (ctrl_sys_pcs_rstn              ),
    .cfg_timeout                (ctrl_sys_cfg_timeout           ),
    
    .top_rf_paddr               (ctrl_sys_top_rf_paddr          ),
    .top_rf_psel                (ctrl_sys_top_rf_psel           ),
    .top_rf_pwrite              (ctrl_sys_top_rf_pwrite         ),
    .top_rf_pwdata              (ctrl_sys_top_rf_pwdata         ),
    .top_rf_prdata              (ctrl_sys_top_rf_prdata         ),
    .top_rf_pready              (ctrl_sys_top_rf_pready         ),
    
    .pcs_rf_paddr               (ctrl_sys_pcs_rf_paddr          ),
    .pcs_rf_psel                (ctrl_sys_pcs_rf_psel           ),
    .pcs_rf_pwrite              (ctrl_sys_pcs_rf_pwrite         ),
    .pcs_rf_pwdata              (ctrl_sys_pcs_rf_pwdata         ),
    .pcs_rf_prdata              (ctrl_sys_pcs_rf_prdata         ),
    .pcs_rf_pready              (ctrl_sys_pcs_rf_pready         )
    );
    
    phy_100baset1
    u_phy_100baset1(
    .top_rf_REG1_15_8_rdata     (top_rf_REG1_15_8_rdata         ),
    .top_rf_REG1_7_4_rdata      (top_rf_REG1_7_4_rdata          ),
    .top_rf_REG2_15_8_rdata     (top_rf_REG2_15_8_rdata         ),
    .top_rf_REG2_7_4_rdata      (top_rf_REG2_7_4_rdata          ),
    .top_rf_REG3_15_8_rdata     (top_rf_REG3_15_8_rdata         ),
    .top_rf_REG3_7_4_rdata      (top_rf_REG3_7_4_rdata          ),
    .top_rf_REG4_15_8_rdata     (top_rf_REG4_15_8_rdata         ),
    .top_rf_REG4_7_4_rdata      (top_rf_REG4_7_4_rdata          ),
    .top_rf_REG5_15_8_rdata     (top_rf_REG5_15_8_rdata         ),
    .top_rf_REG5_7_4_rdata      (top_rf_REG5_7_4_rdata          ),
    .top_rf_REG6_15_8_rdata     (top_rf_REG6_15_8_rdata         ),
    .top_rf_REG6_7_4_rdata      (top_rf_REG6_7_4_rdata          ),
    .top_rf_REG1_1_rdata        (top_rf_REG1_1_rdata            ),
    .top_rf_REG2_1_rdata        (top_rf_REG2_1_rdata            ),
    .top_rf_REG3_1_rdata        (top_rf_REG3_1_rdata            ),
    .top_rf_REG4_1_rdata        (top_rf_REG4_1_rdata            ),
    .top_rf_REG5_1_rdata        (top_rf_REG5_1_rdata            ),
    .top_rf_REG6_1_rdata        (top_rf_REG6_1_rdata            ),
    .pcs_rf_REG1_15_8_rdata     (pcs_rf_REG1_15_8_rdata         ),
    .pcs_rf_REG1_7_4_rdata      (pcs_rf_REG1_7_4_rdata          ),
    .pcs_rf_REG2_15_8_rdata     (pcs_rf_REG2_15_8_rdata         ),
    .pcs_rf_REG2_7_4_rdata      (pcs_rf_REG2_7_4_rdata          ),
    .pcs_rf_REG3_15_8_rdata     (pcs_rf_REG3_15_8_rdata         ),
    .pcs_rf_REG3_7_4_rdata      (pcs_rf_REG3_7_4_rdata          ),
    .pcs_rf_REG4_15_8_rdata     (pcs_rf_REG4_15_8_rdata         ),
    .pcs_rf_REG4_7_4_rdata      (pcs_rf_REG4_7_4_rdata          ),
    .pcs_rf_REG5_15_8_rdata     (pcs_rf_REG5_15_8_rdata         ),
    .pcs_rf_REG5_7_4_rdata      (pcs_rf_REG5_7_4_rdata          ),
    .pcs_rf_REG6_15_8_rdata     (pcs_rf_REG6_15_8_rdata         ),
    .pcs_rf_REG6_7_4_rdata      (pcs_rf_REG6_7_4_rdata          ),
    .pcs_rf_REG1_1_rdata        (pcs_rf_REG1_1_rdata            ),
    .pcs_rf_REG2_1_rdata        (pcs_rf_REG2_1_rdata            ),
    .pcs_rf_REG3_1_rdata        (pcs_rf_REG3_1_rdata            ),
    .pcs_rf_REG4_1_rdata        (pcs_rf_REG4_1_rdata            ),
    .pcs_rf_REG5_1_rdata        (pcs_rf_REG5_1_rdata            ),
    .pcs_rf_REG6_1_rdata        (pcs_rf_REG6_1_rdata            )
    );

endmodule

