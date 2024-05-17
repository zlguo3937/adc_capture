// ------------------------------------------------------------------------
//
//                     JLSemi
//                     Shanghai, China
//                     Name :
//                     Email:
//
// ------------------------------------------------------------------------
// ------------------------------------------------------------------------
//  Revision History:1.0
//  Date          By            Revision    Change Description
//-------------------------------------------------------------------------
//  2024-02-08                  1.0         mdio_slave_22_45_backend
// ------------------------------------------------------------------------
// ------------------------------------------------------------------------

module mdio_slave_22_45_backend
(
    input           clk_25m,
    input           rst_n,

    //frontend
    input           legal, // driven by mdc
    input   [31:0]  rx_data,
    input           info_done_pos,
    input           data_done_pos,
    input           phyaddr_done_pos,
    input           time_out_flag,
    output  [15:0]  resp_rdata,
    output          resp_ready,

    // reg interface
    input   [15:0]  reg_if_rdata,
    input           reg_if_ready,
    output  [20:0]  reg_if_addr,
    output  [15:0]  reg_if_wdata,
    output          reg_if_valid,
    output          reg_if_we

);
    
    wire    [13:0]  in_info;
    wire            in_info_en;
    wire    [15:0]  in_data;
    wire            in_data_en;
    
    reg             cl45;
    wire            cl45_reg_if_valid;
    wire    [15:0]  cl45_reg_if_wdata;
    wire    [20:0]  cl45_reg_if_addr;
    wire            cl45_reg_if_we;
    wire    [15:0]  cl45_resp_rdata;
    wire            cl45_resp_ready;

    reg             cl22;
    wire            cl22_reg_if_valid;
    wire    [15:0]  cl22_reg_if_wdata;
    wire    [20:0]  cl22_reg_if_addr;
    wire            cl22_reg_if_we;
    wire    [15:0]  cl22_resp_rdata;
    wire            cl22_resp_ready;

    always @(posedge clk_25m or negedge rst_n)
    begin
        if (!rst_n) begin
            cl45 <= 1'b0;
            cl22 <= 1'b0;
        end
        else if (time_out_flag) begin
            cl45 <= 1'b0;
            cl22 <= 1'b0;
        end
        else if (phyaddr_done_pos) begin
            cl45 <= (rx_data[31:30] == 2'b00);
            cl22 <= (rx_data[31:30] == 2'b01);
        end
    end

    assign resp_rdata   =   cl45 ? cl45_resp_rdata :
                            cl22 ? cl22_resp_rdata : 16'h0;

    assign resp_ready   =   cl45 ? cl45_resp_ready :
                            cl22 ? cl22_resp_ready : 1'b0;

    assign reg_if_wdata =   cl45 ? cl45_reg_if_wdata :
                            cl22 ? cl22_reg_if_wdata : 16'h0;

    assign reg_if_valid =   cl45 ? cl45_reg_if_valid :
                            cl22 ? cl22_reg_if_valid : 1'b0;

    assign reg_if_we    =   cl45 ? cl45_reg_if_we :
                            cl22 ? cl22_reg_if_we : 1'b0;

    assign reg_if_addr  =   cl45 ? cl45_reg_if_addr :
                            cl22 ? cl22_reg_if_addr : 16'h0;

    /* -----------------------------
      seperated backend
     ---------------------------- */
    assign in_info_en   = info_done_pos;
    assign in_info      = rx_data[31:18];
    assign in_data_en   = data_done_pos;
    assign in_data      = rx_data[15:0];

    mdio_slave_45_backend
    u_cl45
    (
    .clk_25m            (clk_25m            ),  
    .rst_n              (rst_n              ),
    .enable             (cl45 & legal       ),
    .in_info            (in_info            ),
    .in_info_en         (in_info_en         ),
    .in_data            (in_data            ),
    .in_data_en         (in_data_en         ),
    .reg_if_rdata       (reg_if_rdata       ),
    .reg_if_ready       (reg_if_ready       ),
    .reg_if_valid       (cl45_reg_if_valid  ),
    .reg_if_wdata       (cl45_reg_if_wdata  ),
    .reg_if_addr        (cl45_reg_if_addr   ),
    .reg_if_we          (cl45_reg_if_we     ),
    .resp_rdata         (cl45_resp_rdata    ),
    .resp_ready         (cl45_resp_ready    )
    );

    mdio_slave_22_backend
    u_cl22
    (
    .clk_25m            (clk_25m            ),  
    .rst_n              (rst_n              ),
    .enable             (cl22 & legal       ),
    .in_info            (in_info            ),
    .in_info_en         (in_info_en         ),
    .in_data            (in_data            ),
    .in_data_en         (in_data_en         ),
    .reg_if_rdata       (reg_if_rdata       ),
    .reg_if_ready       (reg_if_ready       ),
    .reg_if_valid       (cl22_reg_if_valid  ),
    .reg_if_wdata       (cl22_reg_if_wdata  ),
    .reg_if_addr        (cl22_reg_if_addr   ),
    .reg_if_we          (cl22_reg_if_we     ),
    .resp_rdata         (cl22_resp_rdata    ),
    .resp_ready         (cl22_resp_ready    )
    );

endmodule
