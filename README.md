A micro-controller based on an Reflet CPU.

# The CPU
The CPU is an Reflet CPU . More information and the toolchain can be found here: https://github.com/Arkaeriit/reflet.

# Peripherals 
All the peripherals are controlled and monitored with 8-bits registers to make them compatible with any Reflet CPU. Each register is only accessible with its exact address (even in 16-bit mode, editing the register at address 0xFF00 will not impact the register at address 0xFF01). 

The peripherals are identified with a base address and are controled by edditing the register from the base address and a few bytes forwards. For exemple, with the 16 bit controler, the GPIO got 0xFF07 as its base address and is configured with register at address 0fFF07 to 0xFF11.

To minimise the synthesis time and size of a reflet microcontroler, peripherals can be enabled or disabled with Verilog parameters.

## Hardware info 
This peripheral is always active. It is used to read the frequency of the system clock and the which peripherals are enabled or not.
|Offset with base address|Type|Effect|
|------------------------|----|------|
|0|ro|Contain the 8 LSB of the frequency of the main clock in MHz.|
|1|ro|Contain the 8 MSB of the frequency of the main clock in MHz.|
|2|ro|Bits 0 to 2 contain info about the wordsize of the processor. 1 means that it is an 8 bit processor, 2 means a 16 bit, 3 a 32 bits, 4 a 64 bits, 5 a 128 bits and 0 means an other wordsize. Bit 3 tell if the interupt manager is enabled. Bit 4 tell if the GPIO is enabled. Bit 5 tell if the timer is enabled. Bit 6 tell if the second timer is enabled. Finaly, bit 7 tell if the UART is enabled.|
|3|ro|Bit 0 tell if the PWM is enabled. Bit 1 tell if the seven segment controler is enabled. Bits 2 to 7 are left to 0.|

## Interupt manager
The CPU got only 7 interrupt lines, but more than 4 peripherals can raise interrupts. This module let the user control which peripherals can use interrupts and the priority of each interrupt.
|Offset with base address|Type|Effect|
|------------------------|----|------|
|0|r/w|Bit 0 control if the interrupt from the GPIO is enabled. Bit 1 control if the interrupt from the UART is enabled. Bit 2 control if the interrupt from the timer is enabled. Bit 3 control if the interrupt from the timer 2 is enabled.|
|1|r/w|Bits 0 and 1 control the priorite of the GPIO interrupt. Bits 2 and 3 control the priority of the UART interrupt. Bits 4 and 5 control the priority of the timer interrupt. Bits 6 and 7 control the priority of the timer 2 interrupt.|
|2|r/w|This register tell wich interrupts are currentely raised. Whenever a new interrupt append, the related bit is raised to 1. To archnolege the interupt, its bit must be switched back to 0. Bit 0 tell the state of the GPIO interrupt. Bit 1 tell the state of the UART interrupt. Bit 2 tell the state of the timer interrupt. Bit 3 tell the state of the timer 2 interrupt.|


## GPIO
The most basic way to interract with the external world. It is made of a 16 bits parallel output and a 16 bits parallel input. The input can triger interupt on rising or falling edges of each input pins.
|Offset with base address|Type|Effect|
|------------------------|----|------|
|0|r/w|Control the 8 first pins of the parallel output.|
|1|r/w|Control the 8 last  pins of the parallel output.|
|2|ro |Contain the state of the 8 first pins of the parallel input.|
|3|ro |Contain the state of the 8 last  pins of the parallel input.|
|4|r/w|Control wich of the 8 first pins of the parallel input should raise an interrupt on a rising edge.|
|5|r/w|Control wich of the 8 last  pins of the parallel input should raise an interrupt on a rising edge.|
|6|r/w|Control wich of the 8 first pins of the parallel input should raise an interrupt on a faling edge.|
|7|r/w|Control wich of the 8 last  pins of the parallel input should raise an interrupt on a faling edge.|

## Timer
A 24 bits timer. This timer contain two prescalers (pre1 and pre2) and a main counter (mcnt). Each of these 3 values is on 8 bits. The timer raise an interrupt each `(pre1 + 1) * (pre2 + 1) * (mcnt)` cycles of the system clock.
|Offset with base address|Type|Effect|
|------------------------|----|------|
|0|r/w|Control the value of pre1.|
|1|r/w|Control the value of pre2.|
|2|r/w|Control the value of mcnt.|

## Timer 2
A 23 bits timer. This timer behave in a similar way than the main timer except that pre1 is on 7 bits instead of 8 and that we can select to use either the system clock or the output of the main timer as the input source. This make possible to chain timer and timer2 to have a resulting 47 bits timer.
|Offset with base address|Type|Effect|
|------------------------|----|------|
|0|r/w|Bit 0 should be set to 0 to use the system clock as input source and set to 1 to use timer 1 as the input source. Bits 1 to 7 ontrol the value of pre1.|
|1|r/w|Control the value of pre2.|
|2|r/w|Control the value of mcnt.|

