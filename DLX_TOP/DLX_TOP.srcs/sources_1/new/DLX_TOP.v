`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Reith Nolan
// 
// Create Date: 11/16/2019 12:56:12 PM
// Design Name: DLX Processor
// Module Name: DLX_TOP
// Project Name: Simulation
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Top level for DLX processor
// Contains connections between modules and processor registers
// Provides muxes for data flow since data must flow through here
// Interfaces with testbench which provides memory controller and data
//
//////////////////////////////////////////////////////////////////////////////////


module DLX_TOP(
clk,
rst,
MemData,
MemAddr,
MemWait,
MemOP,
MemWrite,
MemRead
);

input clk, rst, MemWait;
output [31:0] MemAddr;
inout [31:0] MemData;
output [1:0] MemOP;
output MemRead, MemWrite;



wire [31:0] Data;   
wire [31:0] Addr;
//wires
wire [31:0] MDRWire;
wire [31:0] Amux;
wire [31:0] Bmux;
wire [31:0] S1;
wire [31:0] S2;
wire [31:0] DEST;
wire [4:0] ALUop;
wire [2:0] S2op;
wire [32:0] Areg;
wire [32:0] Breg;
wire [5:0] opcode;
wire [5:0] opcodeALU;
wire [1:0] REGselect;
wire Zflag;
//Registers   
reg [31:0] IR;
reg [31:0] PC;
reg [31:0] IAR;
reg [31:0] MAR;
reg [31:0] MDR;
reg [31:0] A;
reg [31:0] B;
reg [31:0] C;

//Instantiations     
DLX_ALU DLX_ALU1 (
.S2op(S2op),
.Zflag(Zflag),
.S1(S1),
.S2(S2),
.ALUop(ALUop),
.DEST(DEST),
.clk(clk),
.rst(rst)
);

DLX_CTRL DLX_CTRL1 (
.S2op(S2op),
.Zflag(Zflag),
.ALUop(ALUop),
.Cload(Cload),
.REGload(REGload),
.Aload(Aload),
.Aoe(Aoe),
.Bload(Bload),
.Boe(Boe),
.REGselect(REGselect),
.IRload(IRload),
.IRoeS1(IRoeS1),
.IRoeS2(IRoeS2),
.opcode(opcode),
.opcodeALU(opcodeALU),
.PCload(PCload),
.PCoeS1(PCoeS1),
.IARload(IARload),
.IARoeS1(IARoeS1),
.IARoeS2(IARoeS2),
.PCMARselect(PCMARselect),
.MARload(MARload),
.MemRead(MemRead),
.MDRload(MDRload),
.MDRoeS2(MDRoeS2),
.MemWrite(MemWrite),
.MemOP(MemOP),
.MemWait(MemWait),
.clk(clk),
.rst(rst)
);

GPR GPR1 (
.C(C),
.REGload(REGload),
.IR(IR),
.REGselect(REGselect),
.A(Areg),
.B(Breg),
.clk(clk),
.rst(rst)
);

//Muxes
//MAR Mux
 mux2tri MARmux (
 .in0(PC),
 .in1(MAR),
 .sel(PCMARselect),
 .out(MemAddr)
 );  


//MDR POST ALU side Mux
mux2tri MDRmux(
 .in0(DEST),
 .in1(MemData),
 .sel(MemRead),
 .out(MDRWire)
 );


//Control Flow for S1 and S2 with tristate high z

assign S2 = (MDRoeS2 == 1'b1) ? MDR : 32'bz;
assign S1 = (IARoeS1 == 1'b1) ? IAR : 32'bz;
assign S2 = (IARoeS2 == 1'b1) ? IAR : 32'bz;
assign S1 = (PCoeS1 == 1'b1) ? PC : 32'bz;
assign S1 = (IRoeS1 == 1'b1) ? IR : 32'bz;
assign S2 = (IRoeS2 == 1'b1) ? IR : 32'bz;
assign S1 = (Aoe == 1'b1) ? A : 32'bz;
assign S2 = (Boe == 1'b1) ? B : 32'bz;

//OP Code Handling
assign opcode = IR[31:26];
assign opcodeALU = IR[5:0]; //as per routing diagram


//Register loads

always @(posedge clk or posedge rst) begin
       if(rst == 1) begin
           IR <= 32'b0;
           PC <= 32'b0;
           IAR <= 32'b0;
           MAR <= 32'b0;
           MDR <= 32'b0;
           A <= 32'b0;
           B <= 32'b0;
           C <= 32'b0;
        end else begin
        if(MDRload) MDR <= MDRWire;
        if(MARload) MAR <= DEST;
        if(IARload) IAR <= DEST;
        if (IRload) IR <= MemData;;
        if (PCload) PC <= DEST;
        if (Aload) A <= Areg;
        if (Bload) B <= Breg;
        if (Cload) C <= DEST;
    
    end
end
//Memory Connections


endmodule
