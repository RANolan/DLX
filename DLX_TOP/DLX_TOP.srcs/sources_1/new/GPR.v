`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Description: 
// General Purpose Register File interface
// 
// 
// 
//////////////////////////////////////////////////////////////////////////////////


module GPR(
C,
REGload,
IR,
REGselect,
A,
B,
clk,
rst
);

input [31:0] C, IR;
input REGload, clk, rst;
input [1:0] REGselect;
output [31:0] A, B;

//Register File
reg [31:0] GPR[31:0];  //32 registers 32 bits wide
reg [4:0] RegSelMux; //which register to store into after ALU op




always @(*) begin
    //demux
    if(REGload) GPR[RegSelMux] <= C; //load data from C into the GPR location it is needed in
    
    //select register
    if(REGselect==1'd0)
        RegSelMux <= IR[15:11];
    else if (REGselect==1'd1)
        RegSelMux <= IR[20:16];
    else if (REGselect==1'd2)
        RegSelMux <= 5'b11111;
    else
        RegSelMux = 5'bzzzzz;
end

always @(posedge rst) begin
    if(rst == 1) begin //random data loaded in at start
        GPR[0] <= 32'h00000000;
        GPR[1] <= 32'h10dd0234;
        GPR[2] <= 32'h338cc4f6;
        GPR[3] <= 32'h66c9f111;
        GPR[4] <= 32'h2ec93d44;
        GPR[5] <= 32'h0ab40345;
        GPR[6] <= 32'hde451d56;
        GPR[7] <= 32'h6ad93d67;
    end
end
//Load from GPR - r0 always 0
assign A = IR[25:21] > 0 ? GPR[IR[25:21]] : 32'h00000000;    //rs1
assign B = IR[20:16] > 0 ? GPR[IR[20:16]] : 32'h00000000;    //rs2


endmodule