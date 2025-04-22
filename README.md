# Synchronous Network-on-Chip (NoC): RTL-to-GDSII Implementation

This project implements a synchronous Network-on-Chip (NoC) with a 2D Torus topology, featuring a 4-stage pipelined processor and custom Network Interface Controllers (NICs). The full digital design flow is completed from RTL to GDSII using industry-standard EDA tools.

## Project Highlights
- RTL design in Verilog, simulated and debugged using **SimVision**
- Synthesized with **Synopsys Design Compiler** using custom constraints and Tcl automation
- Static Timing Analysis (STA) performed in **PrimeTime**, achieving timing closure with positive slack and zero violations
- Place-and-route (PnR) executed in **Cadence Innovus**, achieving 61.512% utilization with clean DRC results
- Packet transmission performance improved by 6% due to optimized Torus routing and handshake-based flow control

## Repository Structure
