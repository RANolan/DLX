`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/16/2019 01:59:42 PM
// Design Name: 
// Module Name: mux2-1tri
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module mux2tri(
in0,
in1,
sel,
out
    );
    
input [31:0] in0, in1;
input sel;
output [31:0] out;

    
    assign out = (sel==1'd0) ? in0 : 32'bz, 
           out = (sel==1'd1) ? in1 : 32'bz;
           
    
endmodule
