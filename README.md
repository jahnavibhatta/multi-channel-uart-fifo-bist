# Multi-Channel UART Communication System with FIFO and BIST
A Verilog HDL based multi-channel UART communication system with FIFO buffering and Built-In Self-Test (BIST), designed and functionally verified using Xilinx Vivado.

## Project Overview
This project implements a multi-channel UART communication system designed to transmit and receive data reliably across multiple UART channels.
The system includes:
- Multi-channel UART communication
- UART transmitter and receiver
- Configurable baud-rate generation
- FIFO-based data buffering
- Built-In Self-Test (BIST)
- Self-checking testbenches
- Functional verification using Vivado simulation

## Main Modules
| Module | Description |
|---|---|
| `uart_tx.v` | UART transmitter |
| `uart_rx.v` | UART receiver |
| `uart_channel.v` | UART channel integration |
| `baud_generator.v` | Generates baud-rate timing |
| `async_fifo.v` | Asynchronous FIFO |
| `uart_fifo_channel.v` | UART channel with FIFO |
| `bist_controller.v` | Controls BIST operation |
| `tb_uart_multi.v` | Multi-UART testbench |
| `tb_fifo.v` | FIFO testbench |
| `tb_bist.v` | BIST testbench |

## Verification
The design was functionally verified using Vivado behavioral simulation.

### Multi-UART Verification
Multiple UART channels were tested with different data patterns and the received data was compared with the transmitted data.

### BIST Verification
The BIST controller was tested using the following patterns:

- `AA`
- `55`
- `CC`
- `33`

All tested patterns were successfully received and the BIST result was:
**PASS**

### FIFO Verification
The FIFO was verified for data write and read operations using separate write and read clock domains.

## Simulation Results
Waveform screenshots are included in this repository to demonstrate:
1. Multi-UART communication
2. UART channel operation
3. BIST operation and PASS result
4. FIFO write/read operation

## Tools Used
- Verilog HDL
- Xilinx Vivado 2024.1
- XSim Simulator
  

## Project Features
- Multi-channel UART communication
- Serial data transmission and reception
- FIFO buffering for reliable data handling
- BIST-based functional testing
- Behavioral simulation and verification
- Timing constraints using XDC

