`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Description: 
// ALU interface for processor
//  
// 
// 
//////////////////////////////////////////////////////////////////////////////////


`include "ALUop.v"
`include "S2op.v"

module DLX_ALU(
S2op,
S1,
S2,
ALUop,
DEST,
Zflag,
clk,
rst
    );

input clk;
input rst;
input [2:0] S2op;
input [4:0] ALUop;    
input [31:0] S1;
input [31:0] S2;
output reg [31:0] DEST;
output reg Zflag;

reg [31:0] S2s;
//S2 op handling
always @(*) begin

        //signed and unsigned bit entension and const values
        case (S2op)
        PASS : S2s <= S2;
        IMM8SXT  : S2s <= {{24{S2[7]}}, S2[7:0]};
        IMM8ZXT  : S2s <= {{24{1'b0}}, S2[7:0]};
        IMM16SXT : S2s <= {{16{S2[15]}}, S2[15:0]};
        IMM16ZXT : S2s <= {{16{1'b0}}, S2[15:0]};
        IMM26SXT : S2s <= {{8{S2[25]}}, S2[25:0]};
        CONST16  : S2s <= 32'd16;
        CONST4   : S2s <= 32'd4;//S2s <= 4;
        endcase
    
end

always @(rst) begin
        if(rst) begin
            DEST <= 32'bz;
            Zflag <= 0;
            S2s <= 0;
        end 
 end
 
 always @(*) begin  //Always performing operations regardless if they are used
       case(ALUop)
        
        ADD       : DEST <= S1 + S2s;//S2s;
        SUB       : DEST <= S1 - S2s;
        PASS_S1   : DEST <= S1;
        PASS_S2   : DEST <= S2s;
        ANDd      : DEST <= S1 & S2s;
        ORd       : DEST <= S1 | S2s;
        XORd      : DEST <= S1 ^ S2s;
        SLL       : DEST <= S1 >> S2s;
        SRL       : DEST <= S1 << S2s;
        SRA       : DEST <= S1 <<< S2s;
        SEQ       : DEST <= (S1 & S2s) ? 32'h1 : 32'h0;
        SNE       : DEST <= ~(S1 & S2s) ? 32'h1 : 32'h0;
        SLT       : DEST <= ($signed(S1) < $signed(S2s)) ? 32'h1 : 32'h0;
        SLTU      : DEST <= ($unsigned(S1) < $unsigned(S2s)) ? 32'h1 : 32'h0; 
        SGE       : DEST <= ($signed(S1) >= $signed(S2s)) ? 32'h1 : 32'h0;
        SGEU      : DEST <= ($unsigned(S1) >= $unsigned(S2s)) ? 32'h1 : 32'h0; 
        SGT       : DEST <= ($signed(S1) > $signed(S2s)) ? 32'h1 : 32'h0;
        SGTU      : DEST <= ($unsigned(S1) > $unsigned(S2s)) ? 32'h1 : 32'h0; 
        SLE       : DEST <= ($signed(S1) <= $signed(S2s)) ? 32'h1 : 32'h0;
        SLEU      : DEST <= ($unsigned(S1) <= $unsigned(S2s)) ? 32'h1 : 32'h0;  
                       
        endcase
        
      if(DEST == 0) Zflag <= 1;
      else  Zflag <= 0;
end

endmodule
