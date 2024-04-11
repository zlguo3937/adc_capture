// --------------------------------------------------------------------
// Copyright (c) 2023 by JLSemi Inc.
// --------------------------------------------------------------------
//
//                     JLSemi
//                     Shanghai, China
//                     Name :
//                     Email:
//
// --------------------------------------------------------------------
// --------------------------------------------------------------------
//  Revision History:1.0
//  Date          By            Revision    Change Description
//---------------------------------------------------------------------
//  2024-03-08                  1.0         sram_ctrl
// --------------------------------------------------------------------
// --------------------------------------------------------------------

module sram_ctrl
(
    // Input-Output declarations
    input   wire          wclk            ,
    input   wire          wrstn           ,
    input   wire          rclk            ,
    input   wire          rrstn           ,
    input   wire          mdio_rclk       ,
    input   wire          mdio_rrstn      ,

    input   wire          mdio_read       ,
    input   wire  [14:0]  mdio_raddr      ,
    input   wire  [3:0]   cfg_mdio_rd_cnt ,
    input   wire          write_pls       ,
    input   wire          read_pls        ,
    input   wire  [8:0]   din[0:95]       ,

    output  reg           write_done      ,
    output  reg           read_done       ,
    output  reg           mdio_read_done  ,
    output  reg           mdio_data_vld   ,
    output  reg   [8:0]   mdio_dout[0:95] ,
    output  reg   [17:0]  dout[0:47]

);
    
    wire          clk;

    reg           write_pls_r;
    reg   [1:0]   write_pls_dly;
    wire          write_pos;
    reg           read_pls_r;
    reg   [1:0]   read_pls_dly;
    wire          read_pos;

    reg           wen;
    reg           ren;
    reg           wcen;
    reg           rcen;

    reg   [3:0]   mdio_rd_cnt;

    wire  [14:0]  addr;

    reg   [14:0]  waddr;
    reg   [14:0]  raddr;
    reg   [8:0]   Q[0:95];

    assign clk = wen ? wclk : ren ? rclk : mdio_rclk;

    always @(posedge wclk or negedge wrstn)
    begin
        if(~wrstn)
            write_pls_r <= 1'b0;
        else
            write_pls_r <= write_pls;
    end

    always @(posedge wclk or negedge wrstn)
    begin
        if(~wrstn)
            write_pls_dly <= 2'b00;
        else
            write_pls_dly <= { write_pls_dly[0], write_pls_r};
    end

    always @(posedge rclk or negedge rrstn)
    begin
        if(~wrstn)
            read_pls_r <= 1'b0;
        else
            read_pls_r <= read_pls;
    end

    always @(posedge rclk or negedge rrstn)
    begin
        if(~wrstn)
            read_pls_dly <= 2'b00;
        else
            read_pls_dly <= { read_pls_dly[0], read_pls_r};
    end

    assign write_pos = ~write_pls_dly[1] & write_pls_dly[0];
    assign read_pos = ~read_pls_dly[1] & read_pls_dly[0];

    always @(posedge wclk or negedge wrstn)
    begin
        if(~wrstn)
            wcen <= 1'b0;
        else if ( &waddr )
            wcen <= 1'b0;
        else if (write_pos)
            wcen <= 1'b1;
    end

    always @(posedge rclk or negedge rrstn)
    begin
        if(~rrstn)
            rcen <= 1'b0;
        else if ( &raddr )
            rcen <= 1'b0;
        else if (read_pos)
            rcen <= 1'b1;
    end

    always @(posedge wclk or negedge wrstn)
    begin
        if(~wrstn)
            wen <= 1'b0;
        else if ( &waddr )
            wen <= 1'b0;
        else if ( write_pos )
            wen <= 1'b1;
    end

    always @(posedge rclk or negedge rrstn)
    begin
        if(~rrstn)
            ren <= 1'b0;
        else if ( &raddr )
            ren <= 1'b0;
        else if ( read_pos )
            ren <= 1'b1;
    end

    always @(posedge wclk or negedge wrstn)
    begin
        if(~wrstn)
            waddr<= 15'b0;
        else if ( &waddr )
            waddr<= 15'b0;
        else if (write_pos)
            waddr<= 15'b0;
        else if ( wcen & wen )
            waddr<= waddr + 1'b1;
        else
            waddr<= 15'b0;
    end

    always @(posedge rclk or negedge rrstn)
    begin
        if(~rrstn)
            raddr<= 15'b0;
        else if ( &raddr )
            raddr<= 15'b0;
        else if (read_pos)
            raddr<= 15'b0;
        else if ( wcen & ren )
            raddr<= raddr + 1'b1;
        else
            raddr<= 15'b0;
    end

    assign addr = wen ? waddr : ren ? raddr : mdio_read ? mdio_raddr : 15'b0;

    always @(posedge mdio_rclk or negedge mdio_rrstn)
    begin
        if(~mdio_rrstn)
            mdio_data_vld <= 1'b0;
        else if (mdio_read)
            mdio_data_vld <= 1'b1;
        else
            mdio_data_vld <= 1'b0;
    end

    genvar k;
    generate
        for (k=0;k<96;k=k+1)
        begin: mdio_data_out
            always @(posedge mdio_rclk or mdio_rrstn)
            begin
                if (~mdio_rrstn)
                    mdio_dout[k] <= 18'b0;
                else if (mdio_read)
                    mdio_dout[k] <= { Q[k] };
            end
        end
    endgenerate

    genvar i;
    generate
        for (i=0;i<96;i=i+2)
        begin: sram_dout
            always @(posedge rclk or rrstn)
            begin
                if (~rrstn)
                    dout[i>>1] <= 18'b0;
                else if ( rcen & ren )
                    dout[i>>1] <= { Q[i], Q[i+1] };
                else
                    dout[i>>1] <= 18'b0;
            end
        end
    endgenerate

    always @(posedge wclk or negedge wrstn)
    begin
        if(~wrstn)
            write_done <= 1'b0;
        else if ( &waddr )
            write_done <= 1'b1;
        else if (write_pos)
            write_done <= 1'b0;
    end

    always @(posedge rclk or negedge rrstn)
    begin
        if(~rrstn)
            read_done <= 1'b0;
        else if ( &raddr || &mdio_raddr )
            read_done <= 1'b1;
        else if (read_pos)
            read_done <= 1'b0;
    end

    always @(posedge mdio_rclk or negedge mdio_rrstn)
    begin
        if(~mdio_rrstn)
            mdio_read_done <= 1'b0;
        else if ( &mdio_raddr )
            mdio_read_done <= 1'b1;
        else if (mdio_read)
            mdio_read_done <= 1'b0;
    end

    genvar j;
    generate
        for (j=0;j<96;j=j+1)
        begin: inst_sram
            spsram32768x9_wrapper
            u_spsram32768x9_wrapper
            (
            .CLK      ( clk                   ),
            .CEB      ( ~(wcen|rcen|mdio_read)),
            .WEB      ( ~wen|ren|mdio_read    ),
            .A        ( addr                  ),
            .D        ( din[j]                ),
            .Q        ( Q[j]                  )
            );
        end
    endgenerate

endmodule
