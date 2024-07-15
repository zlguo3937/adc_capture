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
//  2024-07-06    mhyang        1.0         wr_addr_ctrl
// --------------------------------------------------------------------
// --------------------------------------------------------------------
`timescale 1ns/1ns
module wr_addr_ctrl
#(
    parameter DATA_WIDTH     = 32,
    parameter ADDR_WIDTH     = 14
)
(
    input   wire                        clk             ,
    input   wire                        rst_n           ,

    // config interface
    input   wire                        capture_enable  ,
    input   wire                        capture_start   ,
    input   wire    [ADDR_WIDTH-1:0]    capture_max_addr,
    input   wire    [ADDR_WIDTH-1:0]    pre_trigger_num ,
    input   wire                        cap_mode_vld    ,

    // match
    input   wire    [DATA_WIDTH-1:0]    tri_data        ,
    input   wire                        tri_data_vld    ,
    input   wire                        tri_succeed     ,

    // ram_wr
    output  reg                         tri_wr_vld      ,
    output  reg     [ADDR_WIDTH-1:0]    tri_wr_addr     ,
    output  reg     [DATA_WIDTH-1:0]    tri_wr_data     ,
    output  reg     [ADDR_WIDTH-1:0]    read_start_addr ,
    output  reg     [ADDR_WIDTH-1:0]    tri_addr        ,

    // dbg
    input   wire                        tri_done_rd     ,
    output  reg                         tri_done        ,
    output  reg                         trigger_enable
);

    wire                        capture_start_enable;
    wire                        capture_start_d4;
    reg                         capture_start_d1;
    reg                         capture_start_p;

    wire                        capture_enable_d4;
    reg                         capture_enable_d5;
    reg                         capture_enable_n;

    reg                         aft_tri_suc;
    reg     [ADDR_WIDTH-1:0]    cap_addr;
    reg     [ADDR_WIDTH-1:0]    end_addr;

    reg                         first_write;

    bus_delay #(
        .DELAY_CYCLES           (4),
        .BUS_WIDTH              (1)
    ) u_trigger_start_delay
    (
    .clk    (clk                ),
    .rst_n  (rst_n              ),
    .inbus  (capture_start      ),
    .outbus (capture_start_d4   )
    );

    bus_delay #(
        .DELAY_CYCLES           (4),
        .BUS_WIDTH              (1)
    ) u_trigger_enable_delay
    (
    .clk    (clk                ),
    .rst_n  (rst_n              ),
    .inbus  (capture_enable     ),
    .outbus (capture_enable_d4  )
    );

    assign capture_start_enable = capture_enable_d4 & capture_start_d4;

    always @(posedge clk or posedge rst_n) begin
        if (~rst_n)
            capture_start_d1 <= 1'b0;
        else
            capture_start_d1 <= capture_start_enable;
    end

    always @(posedge clk or posedge rst_n) begin
        if (~rst_n)
            capture_start_p <= 1'b0;
        else
            capture_start_p <= capture_start_enable & (~capture_start_d1);
    end

    always @(posedge clk or posedge rst_n) begin
        if (~rst_n)
            capture_enable_d5 <= 1'b0;
        else
            capture_enable_d5 <= capture_enable_d4;
    end

    always @(posedge clk or posedge rst_n) begin
        if (~rst_n)
            capture_enable_n <= 1'b0;
        else
            capture_enable_n <= ~capture_enable_d4 & capture_enable_d5;
    end

    always @(posedge clk or posedge rst_n) begin
        if (~rst_n)
            trigger_enable <= 1'b0;
        else if (capture_enable_n && (~cap_mode_vld))
            trigger_enable <= 1'b0;
        else if (capture_start_p)
            trigger_enable <= 1'b1;
        else if (tri_data_vld && (cap_addr == end_addr) && aft_tri_suc)
            trigger_enable <= 1'b0;
    end

    always @(posedge clk or posedge rst_n) begin
        if (~rst_n)
            aft_tri_suc <= 1'b0;
        else if (trigger_enable && tri_data_vld && tri_succeed && (~aft_tri_suc))
            aft_tri_suc <= 1'b1;
        else if (tri_data_vld && (cap_addr == end_addr) && aft_tri_suc)
            aft_tri_suc <= 1'b0;
    end

    always @(posedge clk or posedge rst_n) begin
        if (~rst_n)
            tri_done <= 1'b0;
        else if (tri_data_vld && (cap_addr == end_addr) && aft_tri_suc)
            tri_done <= 1'b1;
        else if (capture_start_p || tri_done_rd)
            tri_done <= 1'b0;
    end

    // Generate trigger address
    always @(posedge clk or posedge rst_n) begin
        if (~rst_n)
            tri_addr <= {ADDR_WIDTH{1'b0}};
        else if (tri_data_vld && tri_succeed)
            tri_addr <= cap_addr;
    end

    always @(posedge clk or posedge rst_n) begin
        if (~rst_n)
            cap_addr <= {ADDR_WIDTH{1'b0}};
        else if (capture_start_p)
            cap_addr <= {ADDR_WIDTH{1'b0}};
        else if (trigger_enable && tri_data_vld) begin
            if (cap_addr == capture_max_addr)
                cap_addr <= {ADDR_WIDTH{1'b0}};
            else
                cap_addr <= cap_addr + 1'b1;
        end
    end

    always @(posedge clk or posedge rst_n) begin
        if (~rst_n)
            first_write <= 1'b0;
        else if (capture_start_p)
            first_write <= 1'b1;
        else if (tri_data_vld && (cap_addr == capture_max_addr))
            first_write <= 1'b0;
    end

    // Compare and minus
    always @(posedge clk or posedge rst_n) begin
        if (~rst_n) begin
            end_addr        <= {ADDR_WIDTH{1'b0}};
            read_start_addr <= {ADDR_WIDTH{1'b0}};
        end
        else if (trigger_enable && tri_data_vld && tri_succeed) begin
            if (cap_addr < pre_trigger_num) begin
                if (first_write) begin
                    end_addr        <= capture_max_addr;
                    read_start_addr <= {ADDR_WIDTH{1'b0}};
                end
                else begin
                    end_addr        <= capture_max_addr + 1 - pre_trigger_num + cap_addr;
                    read_start_addr <= capture_max_addr + 1 - pre_trigger_num + cap_addr + 1;
                end
            end
            else if (cap_addr > pre_trigger_num) begin
                end_addr        <= cap_addr - pre_trigger_num - 1;
                read_start_addr <= cap_addr - pre_trigger_num;
            end
            else begin
                end_addr        <= capture_max_addr;
                read_start_addr <= {ADDR_WIDTH{1'b0}};
            end
        end
    end

    // Generate ram write interface
    always @(posedge clk or posedge rst_n) begin
        if (~rst_n)
            tri_wr_vld <= 1'b0;
        else
            tri_wr_vld <= trigger_enable & tri_data_vld;
    end

    always @(posedge clk or posedge rst_n) begin
        if (~rst_n)
            tri_wr_addr <= {ADDR_WIDTH{1'b0}};
        else if (tri_data_vld)
            tri_wr_addr <= cap_addr;
    end

    always @(posedge clk or posedge rst_n) begin
        if (~rst_n)
            tri_wr_data <= {DATA_WIDTH{1'b0}};
        else if (tri_data_vld)
            tri_wr_data <= tri_data;
    end

endmodule
