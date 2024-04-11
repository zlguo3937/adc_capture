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
//  2024-03-08                  1.0         adc_regfile
// --------------------------------------------------------------------
// --------------------------------------------------------------------

module adc_regfile
(
    input  wire         clk,
    input  wire         rstn,
    input  wire [20:0]  paddr,
    input  wire         pwrite,
    input  wire         psel,
    input  wire [15:0]  pwdata,
    output wire [15:0]  prdata,
    output wire         pready,

    output reg          mdio_read,
    output reg  [14:0]  mdio_raddr,
    output wire [3:0]   cfg_mdio_rd_cnt,
    output wire         write_pls,
    output wire         read_pls,

    input  wire         write_done,
    input  wire         read_done,
    input  wire         mdio_data_vld,
    input  wire         mdio_read_done,
    input  wire  [8:0]  mdio_dout[0:95]

);
    
    wire  rf_addr_0_sel    = psel && (paddr == 16'h0   );
    wire  rf_addr_1_sel    = psel && (paddr == 16'h1   );
    wire  rf_addr_2_sel    = psel && (paddr == 16'h2   );
    wire  rf_addr_3_sel    = psel && (paddr == 16'h3   );
    wire  rf_addr_7fff_sel = psel && (paddr == 16'h7fff);

    wire  cfg_mdio_rd_cnt_bus_we = rf_addr_0_sel && pwrite;
    wire  write_pls_bus_we       = rf_addr_1_sel && pwrite;
    wire  read_pls_bus_we        = rf_addr_2_sel && pwrite;

    wire  cfg_mdio_rd_cnt_bus_wdata = pwdata[3:0];
    wire  write_pls_bus_wdata       = pwdata[0];
    wire  read_pls_bus_wdata        = pwdata[0];  

    // Generate mdio read adc data from memory
    wire  mdio_read_vld = rf_addr_7fff_sel && ~pwrite;

    always @(posedge clk or negedge rstn)
    begin
        if(~rstn)
            mdio_raddr_cnt <= 7'd0;
        else if (mdio_raddr_cnt == 7'd95)
            mdio_raddr_cnt <= 7'd0;
        else if (mdio_read_vld)
            mdio_raddr_cnt <= mdio_raddr_cnt + 1'b1;
    end

    always @(posedge clk or negedge rstn)
    begin
        if(~rstn)
            mdio_read <= 1'b0;
        else if (mdio_raddr_cnt == 7'd95)
            mdio_read <= 1'b1;
        else
            mdio_read <= 1'b0;
    end

    always @(posedge clk or negedge rstn)
    begin
        if(~rstn)
            mdio_raddr <= 15'b0;
        else if ( &mdio_raddr )
            mdio_raddr <= 15'b0;
        else if (mdio_raddr_cnt == 7'd95)
            mdio_raddr <= mdio_raddr + 1'b1;
    end

    // pready
    always @(posedge clk or negedge rstn)
    begin
        if(~rstn)
            mdio_rd_pready <= 1'h0;
        else if(mdio_read_vld)
            mdio_rd_pready <= 1'b1;
        else
            mdio_rd_pready <= 1'h0;
    end

    // prdata
    always @(posedge clk or negedge rstn)
    begin
        if(~rstn)
            mdio_rdata <= 16'h0;
        else if(mdio_read_vld)
            mdio_rdata = { 7'b0, mdio_dout[mdio_raddr_cnt] };
    end

    assign prdata = (rf_addr_0_sel && (~pwrite)) ? {12'b0, cfg_mdio_rd_cnt_bus_rdata} :
                    (rf_addr_1_sel && (~pwrite)) ? {15'b0, write_done_bus_rdata     } :
                    (rf_addr_2_sel && (~pwrite)) ? {15'b0, read_done_bus_rdata      } :
                    (rf_addr_3_sel && (~pwrite)) ? {15'b0, mdio_read_done_bus_rdata } :
                    (rf_addr_7fff_sel && (~pwrite)) ? mdio_rdata : 16'hffff;

    assign pready = mdio_rd_pready | rf_addr_0_sel | rf_addr_1_sel | rf_addr_2_sel | rf_addr_3_sel;

    Cell_RWR u_cfg_mdio_rd_cnt(
        .clk       (clk),
        .rstn      (rstn),
        .bus_we    (cfg_mdio_rd_cnt_bus_we),
        .bus_wdata (cfg_mdio_rd_cnt_bus_wdata),
        .bus_rdata (cfg_mdio_rd_cnt_bus_rdata),
        .dev_rdata (cfg_mdio_rd_cnt)
    );

    Cell_ROR u_write_done(
        .clk       (clk),
        .rstn      (rstn),
        .bus_rdata (write_done_bus_rdata),
        .dev_wdata (write_done)
    );

    Cell_ROR u_read_done(
        .clk       (clk),
        .rstn      (rstn),
        .bus_rdata (read_done_bus_rdata),
        .dev_wdata (read_done)
    );

    Cell_ROR u_mdio_read_done(
        .clk       (clk),
        .rstn      (rstn),
        .bus_rdata (mdio_read_done_bus_rdata),
        .dev_wdata (mdio_read_done)
    );

    Cell_SC u_write_pls(
        .clk       (clk),
        .rstn      (rstn),
        .bus_we    (write_pls_bus_we),
        .bus_wdata (write_pls_bus_wdata),
        .dev_rdata (write_pls)
    );

    Cell_SC u_read_pls(
        .clk       (clk),
        .rstn      (rstn),
        .bus_we    (read_pls_bus_we),
        .bus_wdata (read_pls_bus_wdata),
        .dev_rdata (read_pls)
    );

endmodule

module Cell_RWR(
    input         clk,
    input         rstn,
    output [3:0]  bus_rdata,
    input  [3:0]  bus_wdata,
    input         bus_we,
    output [3:0]  dev_rdata
);
    reg [3:0] cell_data;
    assign bus_rdata = cell_data;
    assign dev_rdata = cell_data;
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            cell_data <= 4'h0;
        end
        else if (bus_we) begin
            cell_data <= bus_wdata;
        end
    end
endmodule

module Cell_SC(
    input  clk,
    input  rstn,
    input  bus_wdata,
    input  bus_we,
    output dev_rdata
);
    reg    cell_data;
    reg    sc_out;
    assign dev_rdata = sc_out;
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            cell_data <= 1'h0;
        end else begin
            cell_data <= bus_we & bus_wdata;
        end
    end
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            sc_out <= 1'h0;
        end else begin
            sc_out <= bus_wdata & bus_we & ~cell_data;
        end
    end
endmodule

module Cell_ROR
(
    input       clk,
    input       rstn,
    output      bus_rdata,
    input       dev_wdata
);
    reg         cell_data;
    assign  bus_rdata = cell_data;
    always @(posedge clk or negedge rstn)
        if (~rstn)
            cell_data   <=  1'b0;
        else
            cell_data   <=  dev_wdata;
endmodule
