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
//  2024-05-06    zlguo         1.0         gen_mdio_read_logic
// --------------------------------------------------------------------
// --------------------------------------------------------------------
module gen_mdio_read_logic
(
    // Mdio read
    input   wire                clk,
    input   wire                rstn,
    input   wire                rf_mdio_read_en,    // pulse
    input   wire    [6:0]       rf_mdio_which_memory_sel,
    input   wire    [14:0]      rf_mdio_memory_addr,
    input   wire                mdio_rd_en,
    input   wire    [96*9-1:0]  data_out,
    output  reg     [95:0]      mdio_rd_chip_en,
    output  reg     [96*15-1:0] mdio_rd_raddr,
    output  reg     [8:0]       rf_mdio_pkt_data,
    output  reg                 mdio_rd_done
);

    reg [8:0] mdio_pkt_data;
    reg       rf_mdio_read_en_r;

    genvar i;
    generate
        for (i=0;i<96;i=i+1) begin: Gen_mdio_read
            always @(*) begin
                if (mdio_rd_en) begin
                    if (rf_mdio_read_en)
                        mdio_rd_chip_en[i] = rf_mdio_which_memory_sel == i;
                    else
                        mdio_rd_chip_en[i] = 1'b0;
                end
                else
                    mdio_rd_chip_en[i] = 1'b0;
            end

            always @(*) begin
                if (mdio_rd_en) begin
                    if (rf_mdio_read_en)
                        mdio_rd_raddr[i*15+:15] = (rf_mdio_which_memory_sel == i) ? rf_mdio_memory_addr : 15'h0;
                    else
                        mdio_rd_raddr[i*15+:15] = 15'h0;
                end
                else
                    mdio_rd_raddr[i*15+:15] = 15'h0;
            end
        end
    endgenerate

    always @(*) begin
        case(rf_mdio_which_memory_sel)
            0:  mdio_pkt_data = data_out[0*9+:9];  1:  mdio_pkt_data = data_out[1*9+:9];  2:  mdio_pkt_data = data_out[2*9+:9];  3:  mdio_pkt_data = data_out[3*9+:9];
            4:  mdio_pkt_data = data_out[4*9+:9];  5:  mdio_pkt_data = data_out[5*9+:9];  6:  mdio_pkt_data = data_out[6*9+:9];  7:  mdio_pkt_data = data_out[7*9+:9];
            8:  mdio_pkt_data = data_out[8*9+:9];  9:  mdio_pkt_data = data_out[9*9+:9];  10: mdio_pkt_data = data_out[10*9+:9]; 11: mdio_pkt_data = data_out[11*9+:9];
            12: mdio_pkt_data = data_out[12*9+:9]; 13: mdio_pkt_data = data_out[13*9+:9]; 14: mdio_pkt_data = data_out[14*9+:9]; 15: mdio_pkt_data = data_out[15*9+:9];
            16: mdio_pkt_data = data_out[16*9+:9]; 17: mdio_pkt_data = data_out[17*9+:9]; 18: mdio_pkt_data = data_out[18*9+:9]; 19: mdio_pkt_data = data_out[19*9+:9];
            20: mdio_pkt_data = data_out[20*9+:9]; 21: mdio_pkt_data = data_out[21*9+:9]; 22: mdio_pkt_data = data_out[22*9+:9]; 23: mdio_pkt_data = data_out[23*9+:9];
            24: mdio_pkt_data = data_out[24*9+:9]; 25: mdio_pkt_data = data_out[25*9+:9]; 26: mdio_pkt_data = data_out[26*9+:9]; 27: mdio_pkt_data = data_out[27*9+:9];
            28: mdio_pkt_data = data_out[28*9+:9]; 29: mdio_pkt_data = data_out[29*9+:9]; 30: mdio_pkt_data = data_out[30*9+:9]; 31: mdio_pkt_data = data_out[31*9+:9];
            32: mdio_pkt_data = data_out[32*9+:9]; 33: mdio_pkt_data = data_out[33*9+:9]; 34: mdio_pkt_data = data_out[34*9+:9]; 35: mdio_pkt_data = data_out[35*9+:9];
            36: mdio_pkt_data = data_out[36*9+:9]; 37: mdio_pkt_data = data_out[37*9+:9]; 38: mdio_pkt_data = data_out[38*9+:9]; 39: mdio_pkt_data = data_out[39*9+:9];
            40: mdio_pkt_data = data_out[40*9+:9]; 41: mdio_pkt_data = data_out[41*9+:9]; 42: mdio_pkt_data = data_out[42*9+:9]; 43: mdio_pkt_data = data_out[43*9+:9];
            44: mdio_pkt_data = data_out[44*9+:9]; 45: mdio_pkt_data = data_out[45*9+:9]; 46: mdio_pkt_data = data_out[46*9+:9]; 47: mdio_pkt_data = data_out[47*9+:9];
            48: mdio_pkt_data = data_out[48*9+:9]; 49: mdio_pkt_data = data_out[49*9+:9]; 50: mdio_pkt_data = data_out[50*9+:9]; 51: mdio_pkt_data = data_out[51*9+:9];
            52: mdio_pkt_data = data_out[52*9+:9]; 53: mdio_pkt_data = data_out[53*9+:9]; 54: mdio_pkt_data = data_out[54*9+:9]; 55: mdio_pkt_data = data_out[55*9+:9];
            56: mdio_pkt_data = data_out[56*9+:9]; 57: mdio_pkt_data = data_out[57*9+:9]; 58: mdio_pkt_data = data_out[58*9+:9]; 59: mdio_pkt_data = data_out[59*9+:9];
            60: mdio_pkt_data = data_out[60*9+:9]; 61: mdio_pkt_data = data_out[61*9+:9]; 62: mdio_pkt_data = data_out[62*9+:9]; 63: mdio_pkt_data = data_out[63*9+:9];
            64: mdio_pkt_data = data_out[64*9+:9]; 65: mdio_pkt_data = data_out[65*9+:9]; 66: mdio_pkt_data = data_out[66*9+:9]; 67: mdio_pkt_data = data_out[67*9+:9];
            68: mdio_pkt_data = data_out[68*9+:9]; 69: mdio_pkt_data = data_out[69*9+:9]; 70: mdio_pkt_data = data_out[70*9+:9]; 71: mdio_pkt_data = data_out[71*9+:9];
            72: mdio_pkt_data = data_out[72*9+:9]; 73: mdio_pkt_data = data_out[73*9+:9]; 74: mdio_pkt_data = data_out[74*9+:9]; 75: mdio_pkt_data = data_out[75*9+:9];
            76: mdio_pkt_data = data_out[76*9+:9]; 77: mdio_pkt_data = data_out[77*9+:9]; 78: mdio_pkt_data = data_out[78*9+:9]; 79: mdio_pkt_data = data_out[79*9+:9];
            80: mdio_pkt_data = data_out[80*9+:9]; 81: mdio_pkt_data = data_out[81*9+:9]; 82: mdio_pkt_data = data_out[82*9+:9]; 83: mdio_pkt_data = data_out[83*9+:9];
            84: mdio_pkt_data = data_out[84*9+:9]; 85: mdio_pkt_data = data_out[85*9+:9]; 86: mdio_pkt_data = data_out[86*9+:9]; 87: mdio_pkt_data = data_out[87*9+:9];
            88: mdio_pkt_data = data_out[88*9+:9]; 89: mdio_pkt_data = data_out[89*9+:9]; 90: mdio_pkt_data = data_out[90*9+:9]; 91: mdio_pkt_data = data_out[91*9+:9];
            92: mdio_pkt_data = data_out[92*9+:9]; 93: mdio_pkt_data = data_out[93*9+:9]; 94: mdio_pkt_data = data_out[94*9+:9]; 95: mdio_pkt_data = data_out[95*9+:9];
        endcase
    end

    always @(posedge clk or negedge rstn) begin
        if (!rstn)
            rf_mdio_read_en_r <= 1'b0;
        else
            rf_mdio_read_en_r <= rf_mdio_read_en;
    end

    always @(posedge clk or negedge rstn) begin
        if (!rstn)
            rf_mdio_pkt_data <= 9'h0;
        else if (mdio_rd_en) begin
            if (rf_mdio_read_en_r)
                rf_mdio_pkt_data <= mdio_pkt_data;
        end
        else
            rf_mdio_pkt_data <= 9'h0;
    end

    always @(posedge clk or negedge rstn) begin
        if (!rstn)
            mdio_rd_done <= 1'b0;
        else if (mdio_rd_en) begin
            if (rf_mdio_read_en_r && (rf_mdio_which_memory_sel == 7'd95) && (&rf_mdio_memory_addr))
                mdio_rd_done <= 1'b1;
        end
    end

endmodule
