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
//  2024-05-06    zlguo         1.0         memory_wrapper
// --------------------------------------------------------------------
// --------------------------------------------------------------------
`timescale 1ns/1ns
module memory_wrapper
(
    input   wire            clk,

    input   wire            chip_en_0,
    input   wire            chip_en_1,
    input   wire            chip_en_2,
    input   wire            chip_en_3,
    input   wire            chip_en_4,
    input   wire            chip_en_5,
    input   wire            chip_en_6,
    input   wire            chip_en_7,
    input   wire            chip_en_8,
    input   wire            chip_en_9,
    input   wire            chip_en_10,
    input   wire            chip_en_11,
    input   wire            chip_en_12,
    input   wire            chip_en_13,
    input   wire            chip_en_14,
    input   wire            chip_en_15,
    input   wire            chip_en_16,
    input   wire            chip_en_17,
    input   wire            chip_en_18,
    input   wire            chip_en_19,
    input   wire            chip_en_20,
    input   wire            chip_en_21,
    input   wire            chip_en_22,
    input   wire            chip_en_23,

    input   wire            wr_en_0,
    input   wire            wr_en_1,
    input   wire            wr_en_2,
    input   wire            wr_en_3,
    input   wire            wr_en_4,
    input   wire            wr_en_5,
    input   wire            wr_en_6,
    input   wire            wr_en_7,
    input   wire            wr_en_8,
    input   wire            wr_en_9,
    input   wire            wr_en_10,
    input   wire            wr_en_11,
    input   wire            wr_en_12,
    input   wire            wr_en_13,
    input   wire            wr_en_14,
    input   wire            wr_en_15,
    input   wire            wr_en_16,
    input   wire            wr_en_17,
    input   wire            wr_en_18,
    input   wire            wr_en_19,
    input   wire            wr_en_20,
    input   wire            wr_en_21,
    input   wire            wr_en_22,
    input   wire            wr_en_23,

    input   wire    [14:0]  addr_0,
    input   wire    [14:0]  addr_1,
    input   wire    [14:0]  addr_2,
    input   wire    [14:0]  addr_3,
    input   wire    [14:0]  addr_4,
    input   wire    [14:0]  addr_5,
    input   wire    [14:0]  addr_6,
    input   wire    [14:0]  addr_7,
    input   wire    [14:0]  addr_8,
    input   wire    [14:0]  addr_9,
    input   wire    [14:0]  addr_10,
    input   wire    [14:0]  addr_11,
    input   wire    [14:0]  addr_12,
    input   wire    [14:0]  addr_13,
    input   wire    [14:0]  addr_14,
    input   wire    [14:0]  addr_15,
    input   wire    [14:0]  addr_16,
    input   wire    [14:0]  addr_17,
    input   wire    [14:0]  addr_18,
    input   wire    [14:0]  addr_19,
    input   wire    [14:0]  addr_20,
    input   wire    [14:0]  addr_21,
    input   wire    [14:0]  addr_22,
    input   wire    [14:0]  addr_23,

    input   wire    [35:0]  din_0,
    input   wire    [35:0]  din_1,
    input   wire    [35:0]  din_2,
    input   wire    [35:0]  din_3,
    input   wire    [35:0]  din_4,
    input   wire    [35:0]  din_5,
    input   wire    [35:0]  din_6,
    input   wire    [35:0]  din_7,
    input   wire    [35:0]  din_8,
    input   wire    [35:0]  din_9,
    input   wire    [35:0]  din_10,
    input   wire    [35:0]  din_11,
    input   wire    [35:0]  din_12,
    input   wire    [35:0]  din_13,
    input   wire    [35:0]  din_14,
    input   wire    [35:0]  din_15,
    input   wire    [35:0]  din_16,
    input   wire    [35:0]  din_17,
    input   wire    [35:0]  din_18,
    input   wire    [35:0]  din_19,
    input   wire    [35:0]  din_20,
    input   wire    [35:0]  din_21,
    input   wire    [35:0]  din_22,
    input   wire    [35:0]  din_23,

    output  wire    [35:0]  dout_0,
    output  wire    [35:0]  dout_1,
    output  wire    [35:0]  dout_2,
    output  wire    [35:0]  dout_3,
    output  wire    [35:0]  dout_4,
    output  wire    [35:0]  dout_5,
    output  wire    [35:0]  dout_6,
    output  wire    [35:0]  dout_7,
    output  wire    [35:0]  dout_8,
    output  wire    [35:0]  dout_9,
    output  wire    [35:0]  dout_10,
    output  wire    [35:0]  dout_11,
    output  wire    [35:0]  dout_12,
    output  wire    [35:0]  dout_13,
    output  wire    [35:0]  dout_14,
    output  wire    [35:0]  dout_15,
    output  wire    [35:0]  dout_16,
    output  wire    [35:0]  dout_17,
    output  wire    [35:0]  dout_18,
    output  wire    [35:0]  dout_19,
    output  wire    [35:0]  dout_20,
    output  wire    [35:0]  dout_21,
    output  wire    [35:0]  dout_22,
    output  wire    [35:0]  dout_23

);

    memory_inst
    u_memory_0
    (
    .CLK    (clk        ),
    .CEB    (~chip_en_0 ),
    .WEB    (~wr_en_0   ),
    .A      (addr_0     ),
    .D      (din_0      ),
    .Q      (dout_0     )
    );

    memory_inst
    u_memory_1
    (
    .CLK    (clk        ),
    .CEB    (~chip_en_1 ),
    .WEB    (~wr_en_1   ),
    .A      (addr_1     ),
    .D      (din_1      ),
    .Q      (dout_1     )
    );

    memory_inst
    u_memory_2
    (
    .CLK    (clk        ),
    .CEB    (~chip_en_2 ),
    .WEB    (~wr_en_2   ),
    .A      (addr_2     ),
    .D      (din_2      ),
    .Q      (dout_2     )
    );

    memory_inst
    u_memory_3
    (
    .CLK    (clk        ),
    .CEB    (~chip_en_3 ),
    .WEB    (~wr_en_3   ),
    .A      (addr_3     ),
    .D      (din_3      ),
    .Q      (dout_3     )
    );

    memory_inst
    u_memory_4
    (
    .CLK    (clk        ),
    .CEB    (~chip_en_4 ),
    .WEB    (~wr_en_4   ),
    .A      (addr_4     ),
    .D      (din_4      ),
    .Q      (dout_4     )
    );

    memory_inst
    u_memory_5
    (
    .CLK    (clk        ),
    .CEB    (~chip_en_5 ),
    .WEB    (~wr_en_5   ),
    .A      (addr_5     ),
    .D      (din_5      ),
    .Q      (dout_5     )
    );

    memory_inst
    u_memory_6
    (
    .CLK    (clk        ),
    .CEB    (~chip_en_6 ),
    .WEB    (~wr_en_6   ),
    .A      (addr_6     ),
    .D      (din_6      ),
    .Q      (dout_6     )
    );

    memory_inst
    u_memory_7
    (
    .CLK    (clk        ),
    .CEB    (~chip_en_7 ),
    .WEB    (~wr_en_7   ),
    .A      (addr_7     ),
    .D      (din_7      ),
    .Q      (dout_7     )
    );

    memory_inst
    u_memory_8
    (
    .CLK    (clk        ),
    .CEB    (~chip_en_8 ),
    .WEB    (~wr_en_8   ),
    .A      (addr_8     ),
    .D      (din_8      ),
    .Q      (dout_8     )
    );

    memory_inst
    u_memory_9
    (
    .CLK    (clk        ),
    .CEB    (~chip_en_9 ),
    .WEB    (~wr_en_9   ),
    .A      (addr_9     ),
    .D      (din_9      ),
    .Q      (dout_9     )
    );

    memory_inst
    u_memory_10
    (
    .CLK    (clk        ),
    .CEB    (~chip_en_10),
    .WEB    (~wr_en_10  ),
    .A      (addr_10    ),
    .D      (din_10     ),
    .Q      (dout_10    )
    );

    memory_inst
    u_memory_11
    (
    .CLK    (clk        ),
    .CEB    (~chip_en_11),
    .WEB    (~wr_en_11  ),
    .A      (addr_11    ),
    .D      (din_11     ),
    .Q      (dout_11    )
    );

    memory_inst
    u_memory_12
    (
    .CLK    (clk        ),
    .CEB    (~chip_en_12),
    .WEB    (~wr_en_12  ),
    .A      (addr_12    ),
    .D      (din_12     ),
    .Q      (dout_12    )
    );

    memory_inst
    u_memory_13
    (
    .CLK    (clk        ),
    .CEB    (~chip_en_13),
    .WEB    (~wr_en_13  ),
    .A      (addr_13    ),
    .D      (din_13     ),
    .Q      (dout_13    )
    );

    memory_inst
    u_memory_14
    (
    .CLK    (clk        ),
    .CEB    (~chip_en_14),
    .WEB    (~wr_en_14  ),
    .A      (addr_14    ),
    .D      (din_14     ),
    .Q      (dout_14    )
    );

    memory_inst
    u_memory_15
    (
    .CLK    (clk        ),
    .CEB    (~chip_en_15),
    .WEB    (~wr_en_15  ),
    .A      (addr_15    ),
    .D      (din_15     ),
    .Q      (dout_15    )
    );

    memory_inst
    u_memory_16
    (
    .CLK    (clk        ),
    .CEB    (~chip_en_16),
    .WEB    (~wr_en_16  ),
    .A      (addr_16    ),
    .D      (din_16     ),
    .Q      (dout_16    )
    );

    memory_inst
    u_memory_17
    (
    .CLK    (clk        ),
    .CEB    (~chip_en_17),
    .WEB    (~wr_en_17  ),
    .A      (addr_17    ),
    .D      (din_17     ),
    .Q      (dout_17    )
    );

    memory_inst
    u_memory_18
    (
    .CLK    (clk        ),
    .CEB    (~chip_en_18),
    .WEB    (~wr_en_18  ),
    .A      (addr_18    ),
    .D      (din_18     ),
    .Q      (dout_18    )
    );

    memory_inst
    u_memory_19
    (
    .CLK    (clk        ),
    .CEB    (~chip_en_19),
    .WEB    (~wr_en_19  ),
    .A      (addr_19    ),
    .D      (din_19     ),
    .Q      (dout_19    )
    );

    memory_inst
    u_memory_20
    (
    .CLK    (clk        ),
    .CEB    (~chip_en_20),
    .WEB    (~wr_en_20  ),
    .A      (addr_20    ),
    .D      (din_20     ),
    .Q      (dout_20    )
    );

    memory_inst
    u_memory_21
    (
    .CLK    (clk        ),
    .CEB    (~chip_en_21),
    .WEB    (~wr_en_21  ),
    .A      (addr_21    ),
    .D      (din_21     ),
    .Q      (dout_21    )
    );

    memory_inst
    u_memory_22
    (
    .CLK    (clk        ),
    .CEB    (~chip_en_22),
    .WEB    (~wr_en_22  ),
    .A      (addr_22    ),
    .D      (din_22     ),
    .Q      (dout_22    )
    );

    memory_inst
    u_memory_23
    (
    .CLK    (clk        ),
    .CEB    (~chip_en_23),
    .WEB    (~wr_en_23  ),
    .A      (addr_23    ),
    .D      (din_23     ),
    .Q      (dout_23    )
    );


endmodule
