`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Description: 
// Control Unit for DLX processor
// Houses FSM for 5 stages of processor cycle
// 
// 
//////////////////////////////////////////////////////////////////////////////////

`include "opcodes.v"
`include "ALUsec.v"




localparam InsF = 0;
localparam ID = 1;
localparam EX = 2;
localparam MemST = 3;
localparam WB = 4;

module DLX_CTRL (
S2op,
Zflag,
ALUop,
Cload,
REGload,
Aload,
Aoe,
Bload,
Boe,
REGselect,
IRload,
IRoeS1,
IRoeS2,
opcode,
opcodeALU,
PCload,
PCoeS1,
IARload,
IARoeS1,
IARoeS2,
PCMARselect,
MARload,
MemRead,
MDRload,
MDRoeS2,
MemWrite,
MemOP,
MemWait,
clk,
rst
);


output reg [2:0] S2op;
input Zflag;
output reg [4:0] ALUop;
output reg Cload, REGload, Aload, Aoe, Bload, Boe;
output reg [1:0] REGselect;
output reg IRload, IRoeS1, IRoeS2;
input [5:0] opcode, opcodeALU;
output reg PCload, PCoeS1, IARload, IARoeS1, IARoeS2,
    PCMARselect, MARload, MemRead, MDRload, MDRoeS2, MemWrite;
output reg [1:0] MemOP;
input MemWait;
input clk, rst;

reg [2:0] state;
reg [2:0] next_state;

always @(posedge clk) begin
    if (rst == 1) begin //default startup values and reset
        state <= InsF;
        next_state <= InsF;
        S2op <= 0;
        ALUop <= 0;
        Cload <= 0;
        REGload <= 0;
        Aload <= 0;
        Aoe <= 0; 
        Bload <= 0; 
        Boe <= 0;
        REGselect <= 0;
        IRload <= 0; 
        IRoeS1 <= 0; 
        IRoeS2 <= 0;
        PCload <= 0; 
        PCoeS1 <= 0; 
        IARload <= 0; 
        IARoeS1 <= 0; 
        IARoeS2 <= 0;
        PCMARselect <= 0; 
        MARload <= 0; 
        MemRead <= 0; 
        MemRead <= 0; 
        MDRload <= 0; 
        MDRoeS2 <= 0; 
        MemWrite <= 0;
        MemOP <= 0;
    end else begin
    case(next_state) 
        InsF: begin  //fetch instruction
                if(MemWait == 0) begin
                    MDRoeS2 <= 0;
                    PCMARselect <= 0;
                    MemWrite <= 0;
                    REGload <= 0;
                    PCMARselect <= 0;
                    MemRead <= 1;
                    MemOP <= 0;
                    IRload <= 1;
                    next_state <= ID;
                    REGselect = 2;
                    PCoeS1 <= 0;
                    IRoeS2 <= 0;
                    PCload <= 0;
                end
            end
        ID: begin  //once mem read complete, finish load of instruction to reg and decode, increment PC
            if(MemWait == 0) begin
                //decoded instruction to next state
                MemRead <= 0;
                IRload <= 0;
                Aload <= 1;
                Bload <= 1;
                PCoeS1 <= 1;
                S2op <= CONST4;
                ALUop <= ADD;
                PCload <= 1;
                next_state <= EX;
            end
          end
       EX: begin  //execute instruction
            Aload <= 0;
            IRload <= 0;
            Bload <= 0;
            PCoeS1 <= 0;
            PCload <= 0;
            case(opcode)
                ALUprim: begin  //ALU Primary
                   Aoe <= 1;
                   Boe <= 1;
                   ALUop <= opcodeALU;
                   S2op <= PASS;
                   Cload <= 1;
                   next_state <= WB;
                   end
                    /*case(opcodeALU)
                        OP_ADD : begin //add signed
                            Aoe <= 1;
                            Boe <= 1;
                            ALUop = opcodeALU;
                            S2op = PASS;
                            Cload <= 1;
                            next_state <= MemST;
                            end
                       OP_ADDU : begin
                            Aoe <= 1;
                            Boe <= 1;
                            ALUop = opcodeALU;
                            S2op = PASS;
                            Cload <= 1;
                            next_state <= MemST;
                            end
                      OP_SUB : begin
                            Aoe <= 1;
                            Boe <= 1;
                            ALUop = opcodeALU;
                            S2op = PASS;
                            Cload <= 1;
                            next_state <= MemST;
                            end
                      OP_SUBU : begin
                            Aoe <= 1;
                            Boe <= 1;
                            ALUop = opcodeALU;
                            S2op = PASS;
                            Cload <= 1;
                            next_state <= MemST;
                            end
                    endcase*/
                //end
                ADDUI : begin
                   Aoe <= 1;
                   IRoeS2 <= 1;
                   ALUop <= ADD;
                   S2op <= IMM16ZXT;
                   Cload <= 1;
                   next_state <= WB;
                   end 
                ADDI : begin
                   Aoe <= 1;
                   IRoeS2 <= 1;
                   ALUop <= ADD;
                   S2op <= IMM16SXT;
                   Cload <= 1;
                   next_state <= WB;
                   end
                SUBUI : begin
                   Aoe <= 1;
                   IRoeS2 <= 1;
                   ALUop <= SUB;
                   S2op <= IMM16ZXT;
                   Cload <= 1;
                   next_state <= WB;
                   end 
                SUBI : begin
                   Aoe <= 1;
                   IRoeS2 <= 1;
                   ALUop <= SUB;
                   S2op <= IMM16SXT;
                   Cload <= 1;
                   next_state <= WB;
                   end                                         
               LHI : begin
                    IRoeS1 <= 1;
                    S2op <= CONST16;
                    ALUop <= SRA;
                    Cload <= 1;
                    next_state <= WB;
                    end 
               BEQZ : begin
                    Aoe <= 1;
                    ALUop <= 2;
                    next_state <= MemST;
                    end
               SW : begin 
                    Aoe <= 1;
                    IRoeS2 <= 1;
                    S2op <= IMM16SXT;
                    ALUop <= ADD;
                    MARload <= 1;
                    next_state <= MemST;
                    end
               LW : begin
                    Aoe <= 1;
                    IRoeS2 <= 1;
                    S2op <= IMM16SXT;
                    ALUop <= ADD;
                    MARload <= 1;
                    MemRead <= 1;
                    MemOP <= 0;
                    next_state <= MemST;
                    end
              SEQUI : begin
                    Aoe <= 1;
                    IRoeS2 <= 1;
                    ALUop <= SEQ;
                    S2op <= IMM16ZXT;
                    Cload <= 1;
                    next_state <= WB;
                    end
              JAL : begin
                    PCoeS1 <= 1;
                    ALUop <= PASS_S1;
                    Cload <= 1;
                    next_state <= MemST;
                    end                   
            endcase
         end
       MemST: begin //memory operations for LW and SW
            case (opcode)
            BEQZ : begin   //needs tested for transition to InsF
                if(Zflag == 0)
                    next_state <= InsF;
                else begin
                    IRoeS2 <= 1;
                    PCoeS1 <= 1;
                    PCload <= 1;
                    ALUop = ADD;
                    S2op = IMM16SXT;
                    next_state <= InsF;
                    end    
            end
            
            SW : begin
                    Aoe <= 0;
                    IRoeS2 <= 0;
                    MARload <= 0;
                    Boe <= 1;
                    S2op <= PASS;
                    ALUop <= PASS_S2;
                    MemRead <= 0;
                    MDRload <= 1;
                    next_state <= WB;
                    end
            LW : begin
                    if(MemWait == 0) begin
                        Aoe <= 0;
                        IRoeS2 <= 0;
                        MARload <= 0;
                        MemRead <= 0;
                        MemOP <= 0;
                        MDRoeS2 <= 1;
                        ALUop <= PASS_S2;
                        S2op <= PASS;
                        Cload <= 1;
                        next_state <= WB;
                    end
            end
                      
            default : begin
            //if(opcode != LW | opcode != SW) begin
                Aoe <= 0;
                Boe <= 0;
                Cload <= 0;
                IRoeS1 <= 0;
                IRoeS2 <= 0;
                next_state <= WB;             
            end
          endcase
        end
        
      WB: begin //writeback data into register
         Aoe <= 0;
         Boe <= 0;
         Cload <= 0;
         IRoeS1 <= 0;
         IRoeS2 <= 0;
         PCoeS1 <= 0;
         case(opcode)
                ALUprim : begin  //ALU Primary
                    REGload <= 1;
                    REGselect <= 0; //store to rd
                    end
                    
               ADDUI, ADDI, SUBI, SUBUI, SEQUI : begin
                    REGload <= 1;
                    REGselect <= 1; //stored to rs2
                    end 
               LHI : begin
                    REGload <= 1;
                    REGselect <= 1; //stored to rs2
                    end
               SW : begin
                    PCMARselect <= 1;
                    MemWrite <= 1;
                    MemOP = 0;
                    next_state <= InsF;
                    end
               LW : begin
                    MDRoeS2 <= 0;
                    REGload <= 1;
                    REGselect <= 1; //stored to rs2
                    end
               JAL : begin
                    REGselect = 2;
                    REGload <= 1;
                    PCoeS1 <= 1;
                    IRoeS2 <= 1;
                    S2op <= IMM26SXT;
                    ALUop <= ADD;
                    PCload <= 1;
                    end                   
            endcase
          next_state <= InsF;
         end       
       
        endcase
      end

 end
 
always @(*) begin
    state <= next_state;
end    

endmodule