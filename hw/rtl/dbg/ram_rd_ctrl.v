// Copyright (c) 2024 by JLSemi Inc.
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
//  Date          By            Revision    Design Description
//---------------------------------------------------------------------
//  2024-07-06    mhyang        1.0         ram_rd_ctrl
// --------------------------------------------------------------------
// --------------------------------------------------------------------
`timescale 1ns/1ns
module ram_rd_ctrl
#(
    parameter DATA_WIDTH     = 32,
    parameter ADDR_WIDTH     = 14,
    parameter RAM_READ_DELAY = 2,
    parameter MODE_WIDTH     = 4
)
(
    input   wire                        clk             ,
    input   wire                        rst_n           ,

    // config interface
    input   wire    [MODE_WIDTH-1:0]    capture_mode    ,
    input   wire    [ADDR_WIDTH-1:0]    capture_max_addr,
    input   wire                        store_mode      ,
    input   wire                        dbg_in_rd_en    ,
    input   wire                        capture_rd_en   ,
    input   wire    [ADDR_WIDTH-1:0]    capture_rd_addr ,
    output  reg     [DATA_WIDTH-1:0]    capture_rd_data ,
    output  reg                         capture_rd_vld  ,

    // ge TODO TODO
    input   wire    [MODE_WIDTH-1:0]    cap_dbg_mode    ,
    output  reg                         dbg_in_rd_vld   ,
    output  reg     [DATA_WIDTH-2:0]    dbg_in_rd_data  ,

    // ram0 interface
    output  reg     [ADDR_WIDTH-2:0]    ram0_raddr      ,
    input   wire    [DATA_WIDTH/2-1:0]  ram0_rdata      ,
    output  reg                         ram0_rd_en      ,

    // ram1 interface
    output  reg     [ADDR_WIDTH-2:0]    ram1_raddr      ,
    input   wire    [DATA_WIDTH/2-1:0]  ram1_rdata      ,
    output  reg                         ram1_rd_en
);

    // rd_addr_ctrl, generate read addr
    reg     [ADDR_WIDTH-1:0]    dbg_in_rd_addr;
    reg     [ADDR_WIDTH-1:0]    ram_rd_addr;
    reg                         ram_rd_en;
    wire                        ram0_rvld;
    wire                        ram1_rvld;


    reg                         capture_rd_vld_tmp;
    reg     [DATA_WIDTH-1:0]    capture_rd_data_tmp;
    reg                         dbg_in_rd_en_d1;

    always @(posedge clk or posedge rst_n) begin
        if (~rst_n)
            dbg_in_rd_en_d1 <= 1'b0;
        else
            dbg_in_rd_en_d1 <= dbg_in_rd_en;
    end


    always @(posedge clk or posedge rst_n) begin
        if (~rst_n)
            dbg_in_rd_addr <= {ADDR_WIDTH{1'b0}};
        else if (~dbg_in_rd_en && dbg_in_rd_en_d1)
            dbg_in_rd_addr <= {ADDR_WIDTH{1'b0}};
        else if (dbg_in_rd_en && (capture_mode == cap_dbg_mode)) begin
            if (dbg_in_rd_addr == capture_max_addr)
                dbg_in_rd_addr <= {ADDR_WIDTH{1'b0}};
            else
                dbg_in_rd_addr <= dbg_in_rd_addr + 1;
        end
    end

    always @(posedge clk or posedge rst_n) begin
        if (~rst_n)
            ram_rd_addr <= {ADDR_WIDTH{1'b0}};
        else if (capture_mode == cap_dbg_mode)
            ram_rd_addr <= dbg_in_rd_addr;
        else
            ram_rd_addr <= capture_rd_addr;
    end

    always @(posedge clk or posedge rst_n) begin
        if (~rst_n)
            ram_rd_en <= 1'b0;
        else if (capture_mode == cap_dbg_mode)
            ram_rd_en <= dbg_in_rd_en;
        else
            ram_rd_en <= capture_rd_en;
    end

    always @(posedge clk or posedge rst_n) begin
        if (~rst_n)
            ram0_rd_en <= 1'b0;
        else if (store_mode) //8K
            ram0_rd_en <= ram_rd_en;
        else // 16K
            ram0_rd_en <= ram_rd_en & (~ram_rd_addr[ADDR_WIDTH-1]);
    end

    always @(posedge clk or posedge rst_n) begin
        if (~rst_n)
            ram0_raddr <= {(ADDR_WIDTH-1){1'b0}};
        else if (ram_rd_en)
            ram0_raddr <= ram_rd_addr[ADDR_WIDTH-2:0];
    end

    always @(posedge clk or posedge rst_n) begin
        if (~rst_n)
            ram1_rd_en <= 1'b0;
        else if (store_mode) //8K
            ram1_rd_en <= ram_rd_en;
        else // 16K
            ram1_rd_en <= ram_rd_en & ram_rd_addr[ADDR_WIDTH-1];
    end

    always @(posedge clk or posedge rst_n) begin
        if (~rst_n)
            ram1_raddr <= {(ADDR_WIDTH-1){1'b0}};
        else if (ram_rd_en)
            ram1_raddr <= ram_rd_addr[ADDR_WIDTH-2:0];
    end

    bus_delay #(
        .DELAY_CYCLES   (RAM_READ_DELAY ),
        .BUS_WIDTH      (1              ),
        .INIT_VAL       (1'b0           )
    ) u_ram0_rdb
    (
    .clk                (clk            ),
    .rst_n              (rst_n          ),
    .inbus              (ram0_rd_en     ),
    .outbus             (ram0_rvld      )
    );

    bus_delay #(
        .DELAY_CYCLES   (RAM_READ_DELAY ),
        .BUS_WIDTH      (1              ),
        .INIT_VAL       (1'b0           )
    ) u_ram1_rdb
    (
    .clk                (clk            ),
    .rst_n              (rst_n          ),
    .inbus              (ram1_rd_en     ),
    .outbus             (ram1_rvld      )
    );

    // rd_data_sel
    always @(posedge clk or posedge rst_n) begin
        if (~rst_n)
            dbg_in_rd_vld <= 1'b0;
        else if (capture_mode == cap_dbg_mode)
            dbg_in_rd_vld <= ram0_rvld | ram1_rvld;
        else
            dbg_in_rd_vld <= 1'b0;
    end

    always @(posedge clk or posedge rst_n) begin
        if (~rst_n)
            dbg_in_rd_data <= {DATA_WIDTH{1'b0}};
        else if (capture_mode == cap_dbg_mode) begin
            if (store_mode)
                dbg_in_rd_data <= { ram1_rdata[DATA_WIDTH/2-1:0], ram0_rdata[DATA_WIDTH/2-1:0] };
            else
                dbg_in_rd_data <= (ram0_rvld) ? { {(DATA_WIDTH/2){1'b0}}, ram0_rdata[DATA_WIDTH/2-1:0] }
                                              : { {(DATA_WIDTH/2){1'b0}}, ram1_rdata[DATA_WIDTH/2-1:0] };
        end
        else
            dbg_in_rd_data <= {DATA_WIDTH{1'b0}};
    end

    always @(posedge clk or posedge rst_n) begin
        if (~rst_n)
            capture_rd_vld_tmp <= 1'b0;
        else if (capture_mode == cap_dbg_mode)
            capture_rd_vld_tmp <= 1'b0;
        else
            capture_rd_vld_tmp <= ram0_rvld | ram1_rvld;
    end

    always @(posedge clk or posedge rst_n) begin
        if (~rst_n)
            capture_rd_data_tmp <= {DATA_WIDTH{1'b0}};
        else if (capture_mode == cap_dbg_mode)
            capture_rd_data_tmp <= {DATA_WIDTH{1'b0}};
        else if (store_mode)
            capture_rd_data_tmp <= { ram1_rdata[DATA_WIDTH/2-1:0], ram0_rdata[DATA_WIDTH/2-1:0] };
        else if (ram0_rvld)
            capture_rd_data_tmp <= { {(DATA_WIDTH/2){1'b0}}, ram0_rdata[DATA_WIDTH/2-1:0] };
        else if (ram1_rvld)
            capture_rd_data_tmp <= { {(DATA_WIDTH/2){1'b0}}, ram1_rdata[DATA_WIDTH/2-1:0] };
    end

    always @(posedge clk or posedge rst_n) begin
        if (~rst_n)
            capture_rd_data <= {DATA_WIDTH{1'b0}};
        else if (capture_rd_vld_tmp)
            capture_rd_data <= capture_rd_data_tmp;
    end

    always @(posedge clk or posedge rst_n) begin
        if (~rst_n)
            capture_rd_vld <= 1'b0;
        else
            capture_rd_vld <= capture_rd_vld_tmp;
    end

endmodule
