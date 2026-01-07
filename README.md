# Calculator Transactor Project (calculator_xtor)

## Overview
This project demonstrates a software-driven hardware verification environment using SystemVerilog DPI (Direct Programming Interface) to interface between C++ and a SystemVerilog calculator DUT (Design Under Test).

## Project Structure
```
calculator_xtor/
├── Makefile           # Build automation
├── README             # This file
├── api/               # C++ DPI interface
│   ├── main.cc        # DPI implementation
│   └── main.hh        # DPI declarations
└── dut/               # SystemVerilog design
    ├── dut.sv         # Calculator hardware module
    ├── tb.sv          # DPI-enabled testbench
    └── top.sv         # Top-level module
```

## Design Description

### Hardware (SystemVerilog)
- **dut.sv**: 8-bit calculator supporting 4 operations (add, subtract, multiply, divide)
- **tb.sv**: Software-driven testbench with DPI exports/imports for C++ control
- **top.sv**: Top-level module instantiating both DUT and testbench

### Software (C++)
- **main.cc**: Contains test logic driven from C++
- **main.hh**: Header with DPI function declarations

## DPI Interface

### C++ → SystemVerilog (Exports from C++, Imports to SV)
- `status_print()` - Print status from C++ side
- `send_traffic()` - Main test driver function
- `receive_result()` - Receive result callback from SystemVerilog

### SystemVerilog → C++ (Exports from SV, Imports to C++)
- `set_inputs_negedge_sv()` - Set inputs (A, B, opcode, reset) on clock negedge and read result on posedge
- `status_print_sv()` - Print status from SystemVerilog side
- `callback_sv()` - Callback for test completion notification

## Timing Model
- **Inputs**: Set on falling edge (negedge) of clock
- **Outputs**: Read on rising edge (posedge) of clock (with 1ns delay)
- **Result Callback**: SystemVerilog calls `receive_result()` to send results back to C++
- **Clock Period**: 20ns (10ns high, 10ns low)

## Build Instructions

### Prerequisites
- VCS (Synopsys Verilog Compiler Simulator)
- g++ compiler
- Verdi (for waveform viewing)

### Compilation
```bash
# Compile everything (C++ shared library + VCS simulation)
make all

# Or step by step:
make compile     # Compile only
```

### Running Simulation
```bash
make sim         # Run simulation
```

### Viewing Waveforms
```bash
make wave        # Launch Verdi with waveforms
```

### Clean Build
```bash
make clean       # Remove all generated files
```

## Test Flow

1. **Initialization**: Testbench initializes at time 0
2. **C++ Control**: After 100ns, testbench calls `send_traffic()` in C++
3. **Test Execution**: C++ drives tests via DPI calls:
   - C++ calls `set_inputs_negedge_sv()` with test inputs
   - SystemVerilog sets inputs on negedge, reads result on posedge
   - SystemVerilog calls `receive_result()` to send result back to C++
   - C++ receives and verifies result via callback
   - Test sequence:
     - Reset sequence (reset high → reset low)
     - Addition: 10 + 5 = 15
     - Subtraction: 10 - 5 = 5
     - Multiplication: 10 * 5 = 50
     - Division: 10 / 5 = 2
4. **Completion**: Callback notification and simulation finish

## Operation Codes
| Opcode | Operation      |
|--------|----------------|
| 3'd1   | Addition (+)   |
| 3'd2   | Subtraction (-)|
| 3'd3   | Multiplication (*)|
| 3'd4   | Division (/)   |

## Key Features
- Software-driven verification using DPI
- Bidirectional DPI communication (C++ ↔ SystemVerilog)
- Result callback mechanism via `receive_result()` import
- Synchronous clock-based timing (negedge input set, posedge result read)
- Modular design with clean separation
- Shared library compilation for C++ code
- Waveform dumping (FSDB format)
- Automatic test sequencing

## Output Files
- `simv` - Compiled simulation executable
- `libcalculator_dpi.so` - C++ DPI shared library
- `simv.daidir/` - VCS simulation database
- `novas.fsdb` - Waveform database for Verdi

## Notes
- Firstly run the command to load VCS and VERDI into environment(module load zebu).
- The testbench is fully software-driven from C++
- All timing is controlled through DPI task calls
- Results flow back to C++ via `receive_result()` callback from SystemVerilog
- Results are verified and printed from C++ side using global operation tracking
- Clock is generated in top module only
- 32-bit operands with 33-bit result to handle overflow

## Author
Developed for Zebu Transactor training
