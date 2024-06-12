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
//  2024-05-06    zlguo         1.0         iopad_top
// --------------------------------------------------------------------
// --------------------------------------------------------------------
`timescale 1ns/1ns
module iopad_top
(
    input   wire    [17:0]  ADC_DATA,
    input   wire            ADC_DATA_VALID,
    input   wire            CLK_RD,
    input   wire            MDIO_I,

    input   wire            mdio_oen,

    output  wire            RSTN,
    output  wire            MDC,
    output  wire            MDIO,

`ifndef FPGA
    inout   wire            PAD1_ADC_DATA_1,
    inout   wire            PAD2_ADC_DATA_2,
    inout   wire            PAD3_ADC_DATA_3,
    inout   wire            PAD4_ADC_DATA_4,
    inout   wire            PAD5_ADC_DATA_5,
    inout   wire            PAD6_ADC_DATA_6,
    inout   wire            PAD7_ADC_DATA_7,
    inout   wire            PAD8_ADC_DATA_8,
    inout   wire            PAD9_ADC_DATA_9,
    inout   wire            PAD10_ADC_DATA_10,
    inout   wire            PAD11_ADC_DATA_11,
    inout   wire            PAD12_ADC_DATA_12,
    inout   wire            PAD13_ADC_DATA_13,
    inout   wire            PAD14_ADC_DATA_14,
    inout   wire            PAD15_ADC_DATA_15,
    inout   wire            PAD16_ADC_DATA_16,
    inout   wire            PAD17_ADC_DATA_17,
    inout   wire            PAD18_ADC_DATA_18,
    inout   wire            PAD19_ADC_DATA_VALID,
    inout   wire            PAD20_RSTN,
    inout   wire            PAD21_CLK_RD,
    inout   wire            PAD22_MDC,
    inout   wire            PAD23_MDIO
`else
    output  wire            PAD1_ADC_DATA_1,
    output  wire            PAD2_ADC_DATA_2,
    output  wire            PAD3_ADC_DATA_3,
    output  wire            PAD4_ADC_DATA_4,
    output  wire            PAD5_ADC_DATA_5,
    output  wire            PAD6_ADC_DATA_6,
    output  wire            PAD7_ADC_DATA_7,
    output  wire            PAD8_ADC_DATA_8,
    output  wire            PAD9_ADC_DATA_9,
    output  wire            PAD10_ADC_DATA_10,
    output  wire            PAD11_ADC_DATA_11,
    output  wire            PAD12_ADC_DATA_12,
    output  wire            PAD13_ADC_DATA_13,
    output  wire            PAD14_ADC_DATA_14,
    output  wire            PAD15_ADC_DATA_15,
    output  wire            PAD16_ADC_DATA_16,
    output  wire            PAD17_ADC_DATA_17,
    output  wire            PAD18_ADC_DATA_18,
    output  wire            PAD19_ADC_DATA_VALID,
    input   wire            PAD20_RSTN,
    output  wire            PAD21_CLK_RD,
    input   wire            PAD22_MDC,
    inout   wire            PAD23_MDIO
`endif
);

`ifndef FPGA

    wire PAD1_C;
    wire PAD2_C;
    wire PAD3_C;
    wire PAD4_C;
    wire PAD5_C;
    wire PAD6_C;
    wire PAD7_C;
    wire PAD8_C;
    wire PAD9_C;
    wire PAD10_C;
    wire PAD11_C;
    wire PAD12_C;
    wire PAD13_C;
    wire PAD14_C;
    wire PAD15_C;
    wire PAD16_C;
    wire PAD17_C;
    wire PAD18_C;
    wire PAD19_C;
    wire PAD21_C;

    wire PAD20_I;
    wire PAD22_I;

    iopad_pdd_inst
    u_PAD1_ADC_DATA_1
    (
    .I              (ADC_DATA[0]            ),
    .OEN            (1'b0                   ),
    .REN            (1'b1                   ),
    .PAD            (PAD1_ADC_DATA_1        ),
    .C              (PAD1_C                 )
    );

    iopad_pdd_inst
    u_PAD2_ADC_DATA_2
    (
    .I              (ADC_DATA[1]            ),
    .OEN            (1'b0                   ),
    .REN            (1'b1                   ),
    .PAD            (PAD2_ADC_DATA_2        ),
    .C              (PAD2_C                 )
    );

    iopad_pdd_inst
    u_PAD3_ADC_DATA_3
    (
    .I              (ADC_DATA[2]            ),
    .OEN            (1'b0                   ),
    .REN            (1'b1                   ),
    .PAD            (PAD3_ADC_DATA_3        ),
    .C              (PAD3_C                 )
    );

    iopad_pdd_inst
    u_PAD4_ADC_DATA_4
    (
    .I              (ADC_DATA[3]            ),
    .OEN            (1'b0                   ),
    .REN            (1'b1                   ),
    .PAD            (PAD4_ADC_DATA_4        ),
    .C              (PAD4_C                 )
    );

    iopad_pdd_inst
    u_PAD5_ADC_DATA_5
    (
    .I              (ADC_DATA[4]            ),
    .OEN            (1'b0                   ),
    .REN            (1'b1                   ),
    .PAD            (PAD5_ADC_DATA_5        ),
    .C              (PAD5_C                 )
    );

    iopad_pdd_inst
    u_PAD6_ADC_DATA_6
    (
    .I              (ADC_DATA[5]            ),
    .OEN            (1'b0                   ),
    .REN            (1'b1                   ),
    .PAD            (PAD6_ADC_DATA_6        ),
    .C              (PAD6_C                 )
    );

    iopad_pdd_inst
    u_PAD7_ADC_DATA_7
    (
    .I              (ADC_DATA[6]            ),
    .OEN            (1'b0                   ),
    .REN            (1'b1                   ),
    .PAD            (PAD7_ADC_DATA_7        ),
    .C              (PAD7_C                 )
    );

    iopad_pdd_inst
    u_PAD8_ADC_DATA_8
    (
    .I              (ADC_DATA[7]            ),
    .OEN            (1'b0                   ),
    .REN            (1'b1                   ),
    .PAD            (PAD8_ADC_DATA_8        ),
    .C              (PAD8_C                 )
    );

    iopad_pdd_inst
    u_PAD9_ADC_DATA_9
    (
    .I              (ADC_DATA[8]            ),
    .OEN            (1'b0                   ),
    .REN            (1'b1                   ),
    .PAD            (PAD9_ADC_DATA_9        ),
    .C              (PAD9_C                 )
    );

    iopad_pdd_inst
    u_PAD10_ADC_DATA_10
    (
    .I              (ADC_DATA[9]            ),
    .OEN            (1'b0                   ),
    .REN            (1'b1                   ),
    .PAD            (PAD10_ADC_DATA_10      ),
    .C              (PAD10_C                )
    );

    iopad_pdd_inst
    u_PAD11_ADC_DATA_11
    (
    .I              (ADC_DATA[10]           ),
    .OEN            (1'b0                   ),
    .REN            (1'b1                   ),
    .PAD            (PAD11_ADC_DATA_11      ),
    .C              (PAD11_C                )
    );

    iopad_pdd_inst
    u_PAD12_ADC_DATA_12
    (
    .I              (ADC_DATA[11]           ),
    .OEN            (1'b0                   ),
    .REN            (1'b1                   ),
    .PAD            (PAD12_ADC_DATA_12      ),
    .C              (PAD12_C                )
    );

    iopad_pdd_inst
    u_PAD13_ADC_DATA_13
    (
    .I              (ADC_DATA[12]           ),
    .OEN            (1'b0                   ),
    .REN            (1'b1                   ),
    .PAD            (PAD13_ADC_DATA_13      ),
    .C              (PAD13_C                )
    );

    iopad_pdd_inst
    u_PAD14_ADC_DATA_14
    (
    .I              (ADC_DATA[13]           ),
    .OEN            (1'b0                   ),
    .REN            (1'b1                   ),
    .PAD            (PAD14_ADC_DATA_14      ),
    .C              (PAD14_C                )
    );

    iopad_pdd_inst
    u_PAD15_ADC_DATA_15
    (
    .I              (ADC_DATA[14]           ),
    .OEN            (1'b0                   ),
    .REN            (1'b1                   ),
    .PAD            (PAD15_ADC_DATA_15      ),
    .C              (PAD15_C                )
    );

    iopad_pdd_inst
    u_PAD16_ADC_DATA_16
    (
    .I              (ADC_DATA[15]           ),
    .OEN            (1'b0                   ),
    .REN            (1'b1                   ),
    .PAD            (PAD16_ADC_DATA_16      ),
    .C              (PAD16_C                )
    );

    iopad_pdd_inst
    u_PAD17_ADC_DATA_17
    (
    .I              (ADC_DATA[16]           ),
    .OEN            (1'b0                   ),
    .REN            (1'b1                   ),
    .PAD            (PAD17_ADC_DATA_17      ),
    .C              (PAD17_C                )
    );

    iopad_pdd_inst
    u_PAD18_ADC_DATA_18
    (
    .I              (ADC_DATA[17]           ),
    .OEN            (1'b0                   ),
    .REN            (1'b1                   ),
    .PAD            (PAD18_ADC_DATA_18      ),
    .C              (PAD18_C                )
    );

    iopad_pdd_inst
    u_PAD19_ADC_DATA_VALID
    (
    .I              (ADC_DATA_VALID         ),
    .OEN            (1'b0                   ),
    .REN            (1'b1                   ),
    .PAD            (PAD19_ADC_DATA_VALID   ),
    .C              (PAD19_C                )
    );

    iopad_pdu_inst
    u_PAD20_RSTN
    (
    .I              (PAD20_I                ),
    .OEN            (1'b1                   ),
    .REN            (1'b0                   ),
    .PAD            (PAD20_RSTN             ),
    .C              (RSTN                   )
    );

    iopad_pdd_inst
    u_PAD21_CLK_RD
    (
    .I              (CLK_RD                 ),
    .OEN            (1'b0                   ),
    .REN            (1'b1                   ),
    .PAD            (PAD21_CLK_RD           ),
    .C              (PAD21_C                )
    );

    iopad_pdu_inst
    u_PAD22_MDC
    (
    .I              (PAD22_I                ),
    .OEN            (1'b1                   ),
    .REN            (1'b0                   ),
    .PAD            (PAD22_MDC              ),
    .C              (MDC                    )
    );

    iopad_pdu_inst
    u_PAD23_MDIO
    (
    .I              (MDIO_I                 ),
    .OEN            (mdio_oen               ),
    .REN            (1'b0                   ),
    .PAD            (PAD23_MDIO             ),
    .C              (MDIO                   )
    );

`else

    assign PAD1_ADC_DATA_1 = ADC_DATA[0];
    assign PAD2_ADC_DATA_2 = ADC_DATA[1];
    assign PAD3_ADC_DATA_3 = ADC_DATA[2];
    assign PAD4_ADC_DATA_4 = ADC_DATA[3];
    assign PAD5_ADC_DATA_5 = ADC_DATA[4];
    assign PAD6_ADC_DATA_6 = ADC_DATA[5];
    assign PAD7_ADC_DATA_7 = ADC_DATA[6];
    assign PAD8_ADC_DATA_8 = ADC_DATA[7];
    assign PAD9_ADC_DATA_9 = ADC_DATA[8];
    assign PAD10_ADC_DATA_10 = ADC_DATA[9];
    assign PAD11_ADC_DATA_11 = ADC_DATA[10];
    assign PAD12_ADC_DATA_12 = ADC_DATA[11];
    assign PAD13_ADC_DATA_13 = ADC_DATA[12];
    assign PAD14_ADC_DATA_14 = ADC_DATA[13];
    assign PAD15_ADC_DATA_15 = ADC_DATA[14];
    assign PAD16_ADC_DATA_16 = ADC_DATA[15];
    assign PAD17_ADC_DATA_17 = ADC_DATA[16];
    assign PAD18_ADC_DATA_18 = ADC_DATA[17];
    assign PAD19_ADC_DATA_VALID = ADC_DATA_VALID;

    assign RSTN = PAD20_RSTN;
    assign PAD21_CLK_RD = CLK_RD;
    assign MDC = PAD22_MDC;

    IOBUF #(
        .DRIVE      (12         ),
        .IOSTANDARD ("DEFAULT"  ),
        .SLEW       ("SLOW"     )
    )
    IOBUF_inst_MDIO
    (
    .O          (MDIO       ),
    .IO         (PAD23_MDIO ),
    .I          (MDIO_I     ),
    .T          (mdio_oen   )
    );

`endif

endmodule
