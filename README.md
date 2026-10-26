# FIR
This repository contains the implementation of a FIR (finite impulse response) filter in VHDL for a Zynq SoC FPGA. 

The filter has 8-point impulse response, 8-bit resolution (coefficient array of length 8) and 8 input signals of 8-bit data length each.

The RTL architecture of the filter is based on 4 structural components: the MAC (multiplier accumulator unit) for the calculation of the convolution, the ROM for the permanent storage of the coefficients, the RAM for storing the last 8 inputs that constitute the convolution input signals and the control unit for the initialization and sychronization of the units (by changing their states accordingly).

In this code, the accum signal (the register for the convolution) has size 19 bits because the convolution involves two 8-point signals with an 8-bit data length. For a random data size N and number of points M, the size of the convolution accumulator in bits must be:

𝑙𝑜𝑔(2𝑁 · 2𝑁 · 𝑀) = 2 · 𝑁 + 𝑙𝑜𝑔(𝑀)

to cover the maximum possible inputs and coefficients.
