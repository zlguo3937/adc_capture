//#*********************************************************************************************************************/
//# Software       : TSMC MEMORY COMPILER tsn28hpcpd127spsram_2012.02.00.d.180a						*/
//# Technology     : TSMC 28nm CMOS LOGIC High Performance Compact Mobile Computing Plus 1P10M HKMG CU_ELK 0.9V				*/
//#  Memory Type    : TSMC 28nm High Performance Compact Mobile Computing Plus Single Port SRAM with d127 bit cell SVT periphery */
//# Library Name   : ts1n28hpcpsvtb32768x36m16swso (user specify : TS1N28HPCPSVTB32768X36M16SWSO)				*/
//# Library Version: 180a												*/
//# Generated Time : 2024/05/13, 17:41:17										*/
//#*********************************************************************************************************************/
//#															*/
//# STATEMENT OF USE													*/
//#															*/
//# This information contains confidential and proprietary information of TSMC.					*/
//# No part of this information may be reproduced, transmitted, transcribed,						*/
//# stored in a retrieval system, or translated into any human or computer						*/
//# language, in any form or by any means, electronic, mechanical, magnetic,						*/
//# optical, chemical, manual, or otherwise, without the prior written permission					*/
//# of TSMC. This information was prepared for informational purpose and is for					*/
//# use by TSMC's customers only. TSMC reserves the right to make changes in the					*/
//# information at any time and without notice.									*/
//#															*/
//#*********************************************************************************************************************/
//* Template Version : S_05_53301                                               */
//****************************************************************************** */
`resetall
`celldefine

`timescale 1ns/1ps

module TS1N28HPCPSVTB32768X36M16SWSO (
            CLK, CEB, WEB,
            SLP,
            SD,
            A, D, 
            BWEB,    
            Q);

parameter numWord = 32768;
parameter numBit = 36;
parameter numWordAddr = 15;

//=== IO Ports ===//
// Normal Mode Input
input CLK;
input CEB;
input WEB;
input SLP;
input SD;

input [numWordAddr-1:0] A;
input [numBit-1:0] D;
input [numBit-1:0] BWEB;

// BIST Mode Input

// Test Mode

// Data Output
output [numBit-1:0] Q;


//=== Data Structure ===//
wire [numBit-1:0] Q_bistx;
wire [numBit-1:0] Q_ram;
wire [numBit-1:0] Q_tmp;

wire [numWordAddr-1:0] iA = A;
wire [numBit-1:0] iBWEB = BWEB;
wire iCEB = CEB;
wire iWEB = WEB;
wire [numBit-1:0] iD = D;

//=== Operation ===//
TS1N28HPCPSVTB32768X36M16SWSO_RAM_1bit sram_IO0 (
	SD,
	SLP,
	CLK,
	iCEB,
	iWEB,
	iBWEB[0],
	iA,
	iD[0],
	Q_ram[0]);
TS1N28HPCPSVTB32768X36M16SWSO_RAM_1bit sram_IO1 (
	SD,
	SLP,
	CLK,
	iCEB,
	iWEB,
	iBWEB[1],
	iA,
	iD[1],
	Q_ram[1]);
TS1N28HPCPSVTB32768X36M16SWSO_RAM_1bit sram_IO2 (
	SD,
	SLP,
	CLK,
	iCEB,
	iWEB,
	iBWEB[2],
	iA,
	iD[2],
	Q_ram[2]);
TS1N28HPCPSVTB32768X36M16SWSO_RAM_1bit sram_IO3 (
	SD,
	SLP,
	CLK,
	iCEB,
	iWEB,
	iBWEB[3],
	iA,
	iD[3],
	Q_ram[3]);
TS1N28HPCPSVTB32768X36M16SWSO_RAM_1bit sram_IO4 (
	SD,
	SLP,
	CLK,
	iCEB,
	iWEB,
	iBWEB[4],
	iA,
	iD[4],
	Q_ram[4]);
TS1N28HPCPSVTB32768X36M16SWSO_RAM_1bit sram_IO5 (
	SD,
	SLP,
	CLK,
	iCEB,
	iWEB,
	iBWEB[5],
	iA,
	iD[5],
	Q_ram[5]);
TS1N28HPCPSVTB32768X36M16SWSO_RAM_1bit sram_IO6 (
	SD,
	SLP,
	CLK,
	iCEB,
	iWEB,
	iBWEB[6],
	iA,
	iD[6],
	Q_ram[6]);
TS1N28HPCPSVTB32768X36M16SWSO_RAM_1bit sram_IO7 (
	SD,
	SLP,
	CLK,
	iCEB,
	iWEB,
	iBWEB[7],
	iA,
	iD[7],
	Q_ram[7]);
TS1N28HPCPSVTB32768X36M16SWSO_RAM_1bit sram_IO8 (
	SD,
	SLP,
	CLK,
	iCEB,
	iWEB,
	iBWEB[8],
	iA,
	iD[8],
	Q_ram[8]);
TS1N28HPCPSVTB32768X36M16SWSO_RAM_1bit sram_IO9 (
	SD,
	SLP,
	CLK,
	iCEB,
	iWEB,
	iBWEB[9],
	iA,
	iD[9],
	Q_ram[9]);
TS1N28HPCPSVTB32768X36M16SWSO_RAM_1bit sram_IO10 (
	SD,
	SLP,
	CLK,
	iCEB,
	iWEB,
	iBWEB[10],
	iA,
	iD[10],
	Q_ram[10]);
TS1N28HPCPSVTB32768X36M16SWSO_RAM_1bit sram_IO11 (
	SD,
	SLP,
	CLK,
	iCEB,
	iWEB,
	iBWEB[11],
	iA,
	iD[11],
	Q_ram[11]);
TS1N28HPCPSVTB32768X36M16SWSO_RAM_1bit sram_IO12 (
	SD,
	SLP,
	CLK,
	iCEB,
	iWEB,
	iBWEB[12],
	iA,
	iD[12],
	Q_ram[12]);
TS1N28HPCPSVTB32768X36M16SWSO_RAM_1bit sram_IO13 (
	SD,
	SLP,
	CLK,
	iCEB,
	iWEB,
	iBWEB[13],
	iA,
	iD[13],
	Q_ram[13]);
TS1N28HPCPSVTB32768X36M16SWSO_RAM_1bit sram_IO14 (
	SD,
	SLP,
	CLK,
	iCEB,
	iWEB,
	iBWEB[14],
	iA,
	iD[14],
	Q_ram[14]);
TS1N28HPCPSVTB32768X36M16SWSO_RAM_1bit sram_IO15 (
	SD,
	SLP,
	CLK,
	iCEB,
	iWEB,
	iBWEB[15],
	iA,
	iD[15],
	Q_ram[15]);
TS1N28HPCPSVTB32768X36M16SWSO_RAM_1bit sram_IO16 (
	SD,
	SLP,
	CLK,
	iCEB,
	iWEB,
	iBWEB[16],
	iA,
	iD[16],
	Q_ram[16]);
TS1N28HPCPSVTB32768X36M16SWSO_RAM_1bit sram_IO17 (
	SD,
	SLP,
	CLK,
	iCEB,
	iWEB,
	iBWEB[17],
	iA,
	iD[17],
	Q_ram[17]);
TS1N28HPCPSVTB32768X36M16SWSO_RAM_1bit sram_IO18 (
	SD,
	SLP,
	CLK,
	iCEB,
	iWEB,
	iBWEB[18],
	iA,
	iD[18],
	Q_ram[18]);
TS1N28HPCPSVTB32768X36M16SWSO_RAM_1bit sram_IO19 (
	SD,
	SLP,
	CLK,
	iCEB,
	iWEB,
	iBWEB[19],
	iA,
	iD[19],
	Q_ram[19]);
TS1N28HPCPSVTB32768X36M16SWSO_RAM_1bit sram_IO20 (
	SD,
	SLP,
	CLK,
	iCEB,
	iWEB,
	iBWEB[20],
	iA,
	iD[20],
	Q_ram[20]);
TS1N28HPCPSVTB32768X36M16SWSO_RAM_1bit sram_IO21 (
	SD,
	SLP,
	CLK,
	iCEB,
	iWEB,
	iBWEB[21],
	iA,
	iD[21],
	Q_ram[21]);
TS1N28HPCPSVTB32768X36M16SWSO_RAM_1bit sram_IO22 (
	SD,
	SLP,
	CLK,
	iCEB,
	iWEB,
	iBWEB[22],
	iA,
	iD[22],
	Q_ram[22]);
TS1N28HPCPSVTB32768X36M16SWSO_RAM_1bit sram_IO23 (
	SD,
	SLP,
	CLK,
	iCEB,
	iWEB,
	iBWEB[23],
	iA,
	iD[23],
	Q_ram[23]);
TS1N28HPCPSVTB32768X36M16SWSO_RAM_1bit sram_IO24 (
	SD,
	SLP,
	CLK,
	iCEB,
	iWEB,
	iBWEB[24],
	iA,
	iD[24],
	Q_ram[24]);
TS1N28HPCPSVTB32768X36M16SWSO_RAM_1bit sram_IO25 (
	SD,
	SLP,
	CLK,
	iCEB,
	iWEB,
	iBWEB[25],
	iA,
	iD[25],
	Q_ram[25]);
TS1N28HPCPSVTB32768X36M16SWSO_RAM_1bit sram_IO26 (
	SD,
	SLP,
	CLK,
	iCEB,
	iWEB,
	iBWEB[26],
	iA,
	iD[26],
	Q_ram[26]);
TS1N28HPCPSVTB32768X36M16SWSO_RAM_1bit sram_IO27 (
	SD,
	SLP,
	CLK,
	iCEB,
	iWEB,
	iBWEB[27],
	iA,
	iD[27],
	Q_ram[27]);
TS1N28HPCPSVTB32768X36M16SWSO_RAM_1bit sram_IO28 (
	SD,
	SLP,
	CLK,
	iCEB,
	iWEB,
	iBWEB[28],
	iA,
	iD[28],
	Q_ram[28]);
TS1N28HPCPSVTB32768X36M16SWSO_RAM_1bit sram_IO29 (
	SD,
	SLP,
	CLK,
	iCEB,
	iWEB,
	iBWEB[29],
	iA,
	iD[29],
	Q_ram[29]);
TS1N28HPCPSVTB32768X36M16SWSO_RAM_1bit sram_IO30 (
	SD,
	SLP,
	CLK,
	iCEB,
	iWEB,
	iBWEB[30],
	iA,
	iD[30],
	Q_ram[30]);
TS1N28HPCPSVTB32768X36M16SWSO_RAM_1bit sram_IO31 (
	SD,
	SLP,
	CLK,
	iCEB,
	iWEB,
	iBWEB[31],
	iA,
	iD[31],
	Q_ram[31]);
TS1N28HPCPSVTB32768X36M16SWSO_RAM_1bit sram_IO32 (
	SD,
	SLP,
	CLK,
	iCEB,
	iWEB,
	iBWEB[32],
	iA,
	iD[32],
	Q_ram[32]);
TS1N28HPCPSVTB32768X36M16SWSO_RAM_1bit sram_IO33 (
	SD,
	SLP,
	CLK,
	iCEB,
	iWEB,
	iBWEB[33],
	iA,
	iD[33],
	Q_ram[33]);
TS1N28HPCPSVTB32768X36M16SWSO_RAM_1bit sram_IO34 (
	SD,
	SLP,
	CLK,
	iCEB,
	iWEB,
	iBWEB[34],
	iA,
	iD[34],
	Q_ram[34]);
TS1N28HPCPSVTB32768X36M16SWSO_RAM_1bit sram_IO35 (
	SD,
	SLP,
	CLK,
	iCEB,
	iWEB,
	iBWEB[35],
	iA,
	iD[35],
	Q_ram[35]);

wire power_down = SD | SLP ;


//  Q bypass
assign Q_tmp = Q_ram;
assign Q_bistx = Q_tmp;
//  Output Q
assign Q = power_down ? {numBit{1'b0}} : Q_bistx;

endmodule



// 1 bit SRAM 
module TS1N28HPCPSVTB32768X36M16SWSO_RAM_1bit (
	SD_i,
	SLP_i,
	CLK_i,
	CEB_i,
	WEB_i,
	BWEB_i,
	A_i,
	D_i,
	Q_i);

parameter numWord = 32768;
parameter numWordAddr = 15;

input SD_i;
input SLP_i;
input CLK_i;
input CEB_i;
input WEB_i;
input BWEB_i;
input [numWordAddr-1:0] A_i;
input D_i;

output Q_i;

reg Q_i;
reg MEMORY [numWord-1:0];

// Write Mode
and u_w_0 (	WB,
		!SD_i,
		!SLP_i,
		!BWEB_i,
		!WEB_i,
		!CEB_i) ;


always @ (posedge CLK_i)
  if (WB) begin
    MEMORY[A_i] = D_i;
  end

// READ Mode
and u_r_0 (	RB,
		!SD_i,
		!SLP_i,
		WEB_i,
		!CEB_i) ;

always @ (posedge CLK_i)
  if (RB) begin
     Q_i = MEMORY[A_i];
  end

endmodule
`endcelldefine
