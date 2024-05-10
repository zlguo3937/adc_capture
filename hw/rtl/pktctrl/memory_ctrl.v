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
//  2024-05-06    zlguo         1.0         memory_ctrl
// --------------------------------------------------------------------
// --------------------------------------------------------------------
module memory_ctrl
(
    input   wire                clk,
    input   wire                rstn,
    input   wire                write_en,
    input   wire    [9*96-1:0]  data_in
);

    wire    [95:0]      cen;
    wire    [95:0]      wen;

    wire    [95:0]      rd_cen;
    wire    [95:0]      rd_wen;

    wire    [15*96-1:0] addr;
    wire    [15*96-1:0] raddr;

    wire    [9*96-1:0]  data_out;

    wire                wr_wen = {96{1'b1}};
    wire                wr_cen = {96{1'b1}};
    
    reg     [14:0]      waddr;

    always @(posedge clk or negedge rstn) begin
        if(!rstn)
            waddr <= 15'b0;
        else if(&waddr)
            waddr <= 15'b0;
        else if(write_en)
            waddr <= waddr + 1'b1;
    end

    assign wen = write_en ? wr_wen : rd_wen;
    assign cen = write_en ? wr_cen : rd_cen;
    assign addr = write_en ? {96{waddr}} : raddr;

    memory_wrapper
    u_memory_wrapper
    (
    .clk            (clk            ),
    .cen            (cen            ),
    .wen            (wen            ),
    .addr           (addr           ),
    .data_in        (data_in        ),
    .data_out       (data_out       )
    );

endmodule
