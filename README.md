A micro-controller based on an ASRM CPU.

# The CPU
The CPU is an ASRM CPU (16 bits one by default). More information and the toolchain can be found here: https://github.com/Arkaeriit/asrm.

# Peripherals 
All the peripherals are controlled and monitored with 8-bits registers to make them compatible with any ASRM CPU. Each register is only accessible with its exact address (even in 16-bit mode, editing the register at address 0xFF00 will not impact the register at address 0xFF01). 

## GPIO
The most basic peripheral. It is made of a 16 bits parallel output and a 16 bits parallel input. The register at the base address for the peripheral controls the 8 first outputs. At the next address is the 8 last output. At the next address is the 8 first inputs and at the 4th address, the 8 last inputs.

