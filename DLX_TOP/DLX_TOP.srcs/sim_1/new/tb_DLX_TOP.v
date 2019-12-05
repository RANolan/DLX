`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Description: 
// Top level of testbench which interfaces memory contoller to instance of 
// DLX_TOP.
//  
// 
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_DLX_TOP(
clk,
rst
);
    
output reg rst, clk;
wire [1:0] MemOP;
wire [31:0] MemData;
wire [31:0] MemAddr;
wire MemWait;
wire MemRead;
wire MemWrite;

initial begin
rst = 0;
clk = 0;
#1;
rst = 1;
#20;  //release reset on falling edge of clock
rst = 0;
end

always 
    #5 clk = !clk;    //toggle clock



    DLX_TOP DLX_TOP1(
    .clk(clk),
    .rst(rst),
    .MemData(MemData),
    .MemAddr(MemAddr),
    .MemWait(MemWait),
    .MemOP(MemOP),
    .MemWrite(MemWrite),
    .MemRead(MemRead)
    );
    
    memory mem1(
    .clk(clk),
    .rst(rst),
    .MemData(MemData),
    .MemAddr(MemAddr),
    .MemWait(MemWait),
    .MemOP(MemOP),
    .MemWrite(MemWrite),
    .MemRead(MemRead)
    );

endmodule
