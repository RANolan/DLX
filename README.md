# DLX
DLX Processor

Coded using Vivado 2019.2 Using Verilog 200x.

The approach for the hardware design of this processor is to have a modular structure which can be scaled as more instructions from the instruction set are added. The instructions required for a complete program will be added first with the goal of implementing the entire DLX instruction. The design will be implemented in steps by first designing a framework with the hardwired control signals based on the DLX routing handout given in class. The ALU will be the next module implemented with a single operation (AND). The control unit will be designed and included with all the relevant control signals present. Each operation will be added to the control unit and ALU after the previous instruction has been tested in simulation. Testing will be done by using a DLX compiler to compile assembly code into machine code which will be hard-coded into the testbench as test cases with associated memory location.
The programming language using to implement the processor will be Verilog and simulation will be done using Modelsim.

The implementation can be found on GitHub under the username RANolan. The project name is DLX.

The design of the processor is based off of the handout for a datapath of a DLX processor. Currently implemented in control logic are all ALU primary opcode 0, LW, SW, BEQZ, ADDI, ADDUI, SUBI, SUBUI, LHI, JAR, and SEQUI which provide enough functions for simulation. Not all have been fully tested in simulation.
The implementation requires steps beyond the handout in class. The key difference is that muxes with outputs attached to any bus needs to be tri-stated to prevent races conditions from multiple driving sources. These include the MAR and the MDR muxes as well as the memory interface. Other implementation design notes include ensuring that the ALU operations and muxes are combinatorial and not dependent on the clock as this adds many more clock cycles required to perform operation. 

The design consists of multiple file which work together to create the DLX processor. DLX_TOP.v ties together all the lower level modules, provides data paths and control for data flow between them and provides main CPU instruction registers. The DLX_CTRL provides the mealy FSM which controls the operation in the processor and the flow of data through the processor. DLX_ALU is the ALU unit in the design to perform math operation. GPR provides the general purpose register file which stores temporary data as the processor operation. Mux2tri provides a 2 to 1 mux in which the outputs are not driven when it is not being used. While this is not necessary depending on synthesis of the design, it provides an easier means for simulation and ensures that there are not bus contentions.
The simulation of the design was performed by creating a memory controller (tb_memory.v) and a memory file (tb_test_mem.mem) which provide stimulus for the processor. Tb_memory provides the controller which loads and stores data from the memory location in reg rf. Tb_test_mem is a memory file which contains instructions converted from assembly to hexadecimal and are loaded into the rf file on initialization. These are the instructions for the processor to run.
