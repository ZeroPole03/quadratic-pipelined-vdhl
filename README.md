# Pipelined Quadratic Function Evaluator in VHDL

## Project Description

This project implements a pipelined hardware architecture in VHDL for evaluating a quadratic polynomial of the form:

\[
y = ax^2 + bx + c
\]

The implementation uses a multi-stage pipeline to distribute arithmetic operations across several clock cycles. Registers are used between processing stages to synchronize intermediate results and allow continuous data processing.

The project was developed as part of a Digital Systems Design examination during the Master's Program in Electronics Engineering.

The design was simulated using **GHDL** on macOS, and the resulting timing behavior and signal propagation were analyzed using **GTKWave**.

## Architecture

The quadratic expression is implemented using the equivalent form:

\[
y = (ax + b)x + c
\]

This representation allows the polynomial to be evaluated using two multiplication stages and intermediate addition stages.

The pipeline architecture includes:

1. First multiplication: `x × a`
2. Pipeline register
3. Addition of coefficient `b`
4. Pipeline register
5. Second multiplication with delayed `x`
6. Pipeline register
7. Addition of coefficient `c`
8. Output register

Additional pipeline registers are used to delay the `x`, `b`, and `c` signals so that all operands arrive at the appropriate pipeline stage at the correct clock cycle.

## Project Structure

```text
cuadratic_pipelining/
│
├── README.md
├── run.sh
├── .gitignore
│
├── src/
│   ├── reg_8b.vhdl
│   ├── reg_16b.vhdl
│   ├── reg_24b.vhdl
│   └── cuadratic_pipelining.vhdl
│
├── tb/
│   └── tb_cuadratic_pipelining.vhdl
│
├── scripts/
│   └── graphs.m
│
├── docs/
│
└── results/
```

## Features

- VHDL implementation of a quadratic polynomial evaluator
- Multi-stage pipelined architecture
- Signed arithmetic using `IEEE.numeric_std`
- 8-bit input and coefficient representation
- 16-bit output
- Intermediate 16-bit and 24-bit arithmetic stages
- Feedforward pipeline synchronization
- Register-based timing alignment
- Functional verification using a VHDL testbench
- Waveform generation using GHDL
- Timing visualization using GTKWave

## Mathematical Model

The implemented function is:

```text
y = ax² + bx + c
```

The hardware architecture evaluates the equivalent expression:

```text
y = (ax + b)x + c
```

This formulation allows the polynomial to be implemented using two multiplication stages and intermediate addition stages.

## Pipeline Architecture

Instead of performing all arithmetic operations within a single clock cycle, the computation is divided into multiple stages separated by registers.

The main processing stages are:

1. First multiplication: `x × a`
2. Pipeline register
3. Addition of coefficient `b`
4. Pipeline register
5. Second multiplication: `(ax + b) × x`
6. Pipeline register
7. Addition of coefficient `c`
8. Output register

Additional registers are used to delay the `x` and `c` signals so that all operands remain synchronized with the intermediate pipeline results.

Conceptually, the architecture can be represented as:

```text
             ┌───────────┐
x ──────────►│   x × a   │
             └─────┬─────┘
                   │
                Register
                   │
                   ▼
             ┌───────────┐
b ──────────►│  ax + b   │
             └─────┬─────┘
                   │
                Register
                   │
                   ▼
             ┌────────────┐
x delayed ──►│ (ax + b)×x │
             └─────┬──────┘
                   │
                Register
                   │
                   ▼
             ┌───────────┐
c delayed ──►│ + c       │
             └─────┬─────┘
                   │
                Register
                   │
                   ▼
                   y
```

## Simulation

The project can be compiled and simulated using the included Bash script:

```bash
chmod +x run.sh
bash run.sh
```

The script performs the following operations:

1. Cleans previous simulation files.
2. Analyzes the VHDL source files.
3. Elaborates the testbench.
4. Runs the simulation.
5. Generates a VCD waveform file.
6. Opens the waveform using GTKWave.

## Requirements

The project requires:

- GHDL
- GTKWave
- Bash shell
- A compatible VHDL simulation environment

On macOS, GHDL and GTKWave can be installed using Homebrew:

```bash
brew install ghdl
brew install gtkwave
```

## Verification

The included testbench evaluates the quadratic function using multiple signed input values.

The simulation uses the following coefficients:

```text
a = 2
b = 3
c = 1
```

Therefore, the evaluated function is:

```text
y = 2x² + 3x + 1
```

Example simulation results:

```text
x = -8 → y = 105
x = -4 → y = 21
x = -1 → y = 0
x =  0 → y = 1
x =  1 → y = 6
x =  4 → y = 45
x =  8 → y = 153
```

These results were verified through the VHDL testbench simulation.

## Technologies

- VHDL
- IEEE `std_logic_1164`
- IEEE `numeric_std`
- GHDL
- GTKWave
- Bash
- MATLAB/Octave for optional result visualization

## Author

**Alan Rodríguez Bojorjes**

Master's Program in Electronics Engineering  
Science Faculty  
Universidad Autónoma de San Luis Potosí

## Academic Context

This project was developed as part of a Digital Systems Design examination during the Master's Program in Electronics Engineering.

The objective was to implement and simulate a pipelined digital architecture capable of evaluating a quadratic function while applying concepts such as:

- Pipeline design
- Register synchronization
- Feedforward signal alignment
- Signed arithmetic
- Hardware-oriented data processing
- RTL design
- Functional verification using simulation
