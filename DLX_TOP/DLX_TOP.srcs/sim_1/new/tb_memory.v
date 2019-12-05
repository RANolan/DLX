`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Description: 
// Memory controller and memory file.
// Memory file is indexed by increments of 1 so MemAddr is divided by 4.
// 
// 
//////////////////////////////////////////////////////////////////////////////////


module memory(
clk,
rst,
MemData,
MemAddr,
MemWait,
MemOP,
MemWrite,
MemRead
);
    
input clk, rst; 
output reg MemWait;
input [31:0] MemAddr;
inout [31:0] MemData;
input [1:0] MemOP;
input MemRead, MemWrite;

//register file
reg [31:0] rf [0:255];
reg [31:0] data;
reg MemWait0;
integer i;
//memory controller
initial begin
    data <= 32'b0;
    MemWait <= 0;

/*    for (i=0; i<255; i= i+1) begin
         rf = i;
    end
    $readmemh("tb_test_mem.mem", rf);*/
    
    
    $readmemh("tb_test_mem.mem", rf);
/*        rf[0] = 32'h3C06DDDD; //lhi r6,0xdddd
        rf[1] = 32'h24C6DDDD; ///addui r6,r6,0xddd
        rf[2] = 32'h3C630a01;  //lhi r3,0x0a01
        rf[3] = 32'h246310A0;  //addui r3,r3,0x10a0
        rf[4] = 32'h3C040A01;  //lhi r4,0x0a01
        rf[5] = 32'h24840CB8;  //addui r4,r4, 0x0cb8 
        rf[6] = 32'h00832822; //sub r5,r4,r3  
        rf[7] = 32'hACA70000;  //sw (r5), r6  = dec 1000 or mem 250
        rf[8] = 32'h8CA80000;  //lw r8, (r5)  = dec 1000 or mem 250
        rf[9] = 32'hC1084810;  //sequi r9, r8,r6
        rf[10] = 32'h1120000C;  //beqz r9, 0x0 //location + 12 or mem 14
        rf[11] = 32'h25EF0CB8;  //addui r15,r15, 0x0cb8  
        rf[12] = 32'h26100C89;  //addui r16,r16, 0x0cb9
        rf[13] = 32'h2484ffff;  //addui r4,r4, 0x0cb8*/
end


always @(negedge clk)
begin
    if(MemRead) begin
        MemWait <= 1;
        if(MemOP == 0)
            data <= rf[MemAddr/4]; //divide by 4 since memory file is indexed by increments of 1
        else if(MemOP == 1) 
            data <= {16'b0,rf[MemAddr/4][31:16]};
        else if(MemOP == 2)
             data <= {32'b0,rf[MemAddr/4][31:24]};
    end else if(MemWrite) begin
        MemWait <= 1;
        if(MemOP == 0)
            rf[MemAddr/4] <= data;
        else if(MemOP == 1)
            rf[MemAddr/4][31:16] <= data[15:0]; 
        else if(MemOP == 2)
            rf[MemAddr/4][31:24] <= data[7:0];
    end
    if(MemWait !== 0) // 1 clock delay for wait
      MemWait <= 0;     
end


//Read operation
assign MemData = (MemRead & !MemWrite) ? data : 32'bz; //high-z buffer
//assign data = (MemWrite) ? MemData : 32'bz;
   
endmodule
