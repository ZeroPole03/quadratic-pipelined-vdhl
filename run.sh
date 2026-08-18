#!/bin/bash

set -e

echo "Cleaning previous simulation files..."

ghdl --clean

rm -f *.o
rm -f *.cf
rm -f waves.vcd
rm -f salida_y.txt
rm -f tb_cuadratic_pipelining

echo "Analyzing VHDL files..."

ghdl -a src/reg_8b.vhdl
ghdl -a src/reg_16b.vhdl
ghdl -a src/reg_24b.vhdl
ghdl -a src/cuadratic_pipelining.vhdl
ghdl -a tb/tb_cuadratic_pipelining.vhdl

echo "Elaborating testbench..."

ghdl -e tb_cuadratic_pipelining

echo "Running simulation..."

ghdl -r tb_cuadratic_pipelining \
    --stop-time=2us \
    --vcd=waves.vcd

echo "Simulation completed successfully."

echo "Opening waveform viewer..."

gtkwave waves.vcd