# RISC-V CPU Core

This project implements a 32-bit RISC-V CPU core adhering to the RV32I base integer instruction set architecture (ISA). The CPU is written in VHDL and designed for synthesis on an FPGA.

## Architecture

- 32-bit RISC-V core with RV32I ISA support
- Harvard architecture - separate instruction and data memories
- Single cycle implementation

## Components

The CPU core consists of the following main components:

- **Program Counter** - Holds the current address of the instruction being executed
- **Instruction Memory** - Read-only memory storing RISC-V instructions  
- **Register File** - Holds 32 x 32-bit general-purpose registers
- **Data Memory** - Read/Write memory for storing data
- **ALU** - Arithmetic Logic Unit for performing computations  
- **Control Unit** - Decoder generating control signals from instructions

## Instruction Support

The CPU implements the RV32I base integer instruction set:

- Integer ALU operations (add, sub, and, or, etc.)
- Load and Store instructions  
- Conditional branching
- Unconditional jumps

## Simulation  

The CPU core has been tested by writing a VHDL testbench to simulate functionality. Sample assembly code snippets were converted to machine code and fed to the instruction memory to validate execution.

## Synthesis

The VHDL code is designed to be synthesizable for FPGAs. It can be synthesized and programmed onto an FPGA development board.  

## Authors

- Mario Ivanov
- Muhammad Khan Lodhi
- Kamran Rashidov
- Orkhan Elchuev

## Acknowledgements

- [RISC-V International](https://riscv.org/) for the open RISC-V ISA
- Reference textbooks and online resources on RISC-V and VHDL
