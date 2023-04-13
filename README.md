# Reflet microcontroller
A micro-controller based on a Reflet CPU.

Part of the system are included as submodules, so you should run `git submodule update --init --recursive` after cloning this repository.

# The CPU
The CPU is a Reflet CPU. More information and the toolchain can be found here: https://github.com/Arkaeriit/reflet.

# Peripherals 
All the Verilog files describing the peripherals and their submodules are in the peripheral folder.

All the peripherals are controlled and monitored with 8-bits registers to make them compatible with any Reflet CPU. Each register is only accessible with its exact address (even in 16-bit mode, editing the register at address 0xFF00 will not impact the register at address 0xFF01). 

The peripherals are identified with a base address and are controlled by editing the register from the base address and a few bytes forwards. For example, with the 16-bit controller, the GPIO got 0xFF07 as its base address and is configured with the register at address 0xFF07 to 0xFF11.

To minimize the synthesis time and size of a reflet microcontroller, peripherals can be enabled or disabled with Verilog parameters.

## Hardware info 
This peripheral is always active. It is used to read the frequency of the system clock and which peripherals are enabled or not.

|Offset with base address|Type|Register name|Effect|
|------------------------|----|-------------|------|
|0|ro|clk\_lsb|Contain the 8 LSB of the frequency of the main clock in MHz.|
|1|ro|clk\_msb|Contain the 8 MSB of the frequency of the main clock in MHz.|
|2|ro|periph\_1|Bits 0 to 2 contain info about the wordsize of the processor. 1 means that it is an 8-bit processor, 2 means a 16 bit, 3 32 bits, 4 64 bits, 5 128 bits, and 0 means any other wordsize. Bit 3 tells if the interrupt multiplexer is enabled. Bit 4 tells if the GPIO is enabled. Bit 5 tells if the timer is enabled. Bit 6 tells if the second timer is enabled. Finally, bit 7 tells if the UART is enabled.|
|3|ro|periph\_2|Bit 0 tells if the PWM is enabled. Bit 1 tells if the seven-segment controller is enabled. Bit 2 tells if the power manager is enabled. Bit 3 tells if the synthesizer is enabled. Bit 4 tells if the extended io is enabled. Bits 5 to 7 are left to 0.|

## Interrupt multiplexer
The CPU got only 4 interrupt lines, but more than 4 peripherals can raise interrupts. This module lets the user control which peripherals can use interrupts and the priority of each interrupt.

|Offset with base address|Type|Register name|Effect|
|------------------------|----|-------------|------|
|0|r/w|int\_en|Bit 0 control if the interrupt from the GPIO is enabled. Bit 1 control if the interrupt from the UART is enabled. Bit 2 control if the interrupt from the timer is enabled. Bit 3 control if the interrupt from timer 2 is enabled.|
|1|r/w|int\_level|Bits 0 and 1 control the priority of the GPIO interrupt. Bits 2 and 3 control the priority of the UART interrupt. Bits 4 and 5 control the priority of the timer interrupt. Bits 6 and 7 control the priority of the timer 2 interrupt.|
|2|ro |reserved|Reserved for future used. Locked to 0 for now.|
|3|r/w|status|This register tells which interrupts are currently raised. Whenever a new interrupt appends, the related bit is raised to 1. To acknowledge the interrupt, its bit must be switched back to 0. Bit 0 tell the state of the GPIO interrupt. Bit 1 tells the state of the UART interrupt. Bit 2 tells the state of the timer interrupt. Bit 3 tells the state of the timer 2 interrupt.|


## GPIO
The most basic way to interact with the external world. It is made of a 16 bits parallel output and a 16 bits parallel input. The input can trigger an interrupt on the rising or falling edges of each input pin.

|Offset with base address|Type|Register name|Effect|
|------------------------|----|-------------|------|
|0|r/w|gpo\_lsb|Control the 8 first pins of the parallel output.|
|1|r/w|gpo\_msb|Control the 8 last pins of the parallel output.|
|2|ro |gpi\_lsb|Contain the state of the 8 first pins of the parallel input.|
|3|ro |gpi\_msb|Contain the state of the 8 last pins of the parallel input.|
|4|r/w|rise\_int\_lsb|Control which of the 8 first pins of the parallel input should raise an interrupt on a rising edge.|
|5|r/w|rise\_int\_msb|Control which of the 8 last pins of the parallel input should raise an interrupt on a rising edge.|
|6|r/w|fall\_int\_lsb|Control which of the 8 first pins of the parallel input should raise an interrupt on a falling edge.|
|7|r/w|fall\_int\_msb|Control which of the 8 last pins of the parallel input should raise an interrupt on a falling edge.|

## Timer
A 24 bits timer. This timer contains two prescalers (pre1 and pre2) and the main counter (mcnt). Each of these 3 values is on 8 bits. The timer raise an interrupt each `(pre1 + 1) * (pre2 + 1) * (mcnt)` cycles of the system clock.

|Offset with base address|Type|Register name|Effect|
|------------------------|----|-------------|------|
|0|r/w|pre1|Control the value of pre1.|
|1|r/w|pre2|Control the value of pre2.|
|2|r/w|mcnt|Control the value of mcnt.|

## Timer 2
A 23 bits timer. This timer behaves in a similar way to the main timer except that pre1 is on 7 bits instead of 8 and that we can select to use either the system clock or the output of the main timer as the input source. This makes it possible to chain timer and timer2 to have a resulting 47 bits timer.

|Offset with base address|Type|Register name|Effect|
|------------------------|----|-------------|------|
|0|r/w|pre1|Bit 0 should be set to 0 to use the system clock as an input source and set to 1 to use timer 1 as the input source. Bits 1 to 7 control the value of pre1.|
|1|r/w|pre2|Control the value of pre2.|
|2|r/w|mcnt|Control the value of mcnt.|

## UART
A UART module with a baud rate locked at 9600. Its behavior is very similar to the IO functions of the Reflet simulator. To send a message, write its value in the `tx_data` register and put a 0 in `tx_cmd`. To receive a message, either enable the interrupt in the interrupt multiplexer or wait for the value in the `rx_cmd` register to be set to 0. The data will then be readable in the `rx_data` register.

|Offset with base address|Type|Register name|Effect|
|------------------------|----|-------------|------|
|0|r/w|tx\_cmd |Set to 0 to send a message.|
|1|r/w|tx\_data|Write here the message to send.|
|2|r/w|rx\_cmd |This register is automatically set to 0 when a byte is received.|
|3|r/w|rx\_data|The byte received is readable here.|

## PWM
A PWM module with up to 8 bits of resolution. Its frequency is configurable but the higher the frequency, the smaller the resolution. Its period is controllable with the `freq` register and its duty cycle with the `duty` register. The resulting duty cycle will be duty/freq.

|Offset with base address|Type|Register name|Effect|
|------------------------|----|-------------|------|
|0|r/w|freq|Set the period of the PWM.|
|1|r/w|duty|Set the duty-cycle.|

## Seven segments display controller
Even if this could be done with GPIO and a timer, a controller for seven segments display could be useful. This module is made to control 4 digits displays with colons and dots. In the selection bits, a 1 indicates that the digit is active. In the segments bits, 0 indicates that the segments must be lit.

|Offset with base address|Type|Register name|Effect|
|------------------------|----|-------------|------|
|0|r/w|ctrl |Bit 0 is used to enable or disable the display. Bit 1 is used to enable the colon. Bits 4 to 7 are used to select which dots must be turned on. Bits 2 and 3 are unused.|
|1|r/w|num01|Bits 0 to 3 are used to set the value of the first number. Bits 4 to 7 are used to set the value of the second number.|
|2|r/w|num23|Bits 0 to 3 are used to set the value of the third number. Bits 4 to 7 are used to set the value of the fourth number.|

## Power manager 
This module is meant to either reduce the speed of the processor or disable it until an interrupt happens. To reduce the speed, a PWM signal is sent to the enable pin of the CPU.

|Offset with base address|Type|Register name|Effect|
|------------------------|----|-------------|------|
|0|r/w|sleep|When bit 0 is set to 1, the processor is disabled until a detected interrupt is raised. When bit 1 is set to 1, the processor is slowed down by a factor controlled in the power register. Bits 2 and 3 are unused. Bit 4 to 7 are used to tell if interrupts 0 to 3  are watched. If bit 4 is set to 1, the module will watch for interrupt 0 and unlock the processor if interrupt 0 is raised. Bit 5 will enable interrupt 1 and so on. |
|1|r/w|power| This register will let you choose the duty cycle to send to the enable pin of the CPU. The duty cycle is (the content of this register + 1)/256.|

## Frequency synthesizer
The documentation will come when the module will be done

## Extended IO
If you need more than the 16 inputs and 16 outputs of the GPIO module, you can use this one to have up to 256 additional inputs and 256 output. The IOs can be selected with an address on a register and controlled with the other one. The inputs can not raise interrupt. The actual number of IO is chosen with a parameter of the controller module. 

|Offset with base address|Type|Register name|Effect|
|------------------------|----|-------------|------|
|0|r/w|address|Select which IO is selected.|
|1|r/w|control|Bit 0 contains the value in the selected input. Bit 1 contains the actual value of the selected output. To set the output, write the value you want in bit 2 and set bit 3 to 1. Bits 4 to 7 are unused.|

## Debug Helper
This module helps in debugging by printing over an UART line the content of the working register whenever a `debug` instruction is encountered. The data is sent at 9600 bauds in a little-endian fashion. When sending those data, the CPU is disabled to ensure that no debug instructions will be missed.

# Controllers
The folder controller contains files used to make 8 bits or a 16 bits microcontroller with a Reflet CPU. As of now, for the 8-bit controller, you must copy the `reflet_?bits_controller.v` file and replace the data memory with a ROM with a valid Reflet program. For the 16-bit one, you can do so or choose to use the included bootloader instead.

## 8 bits controller
The 8 bits controller is very limited by its addressable space and thus, is only equipped with a limited amount of peripherals.

The memory map is the following:

|Start|End |Content|
|-----|----|-------|
|0x00 |0x7F|Instructions|
|0x80 |0xEC|Data|
|0xED |0xFF|Peripherals|
|-----|----|-------|
|0xED |0xF0|Interrupt multiplexer|
|0xF1 |0xF8|GPIO|
|0xF9 |0xFB|Timer|
|0xFC |0xFF|UART|

### Top-level module
The top-level module is in the `controller` folder and is named reflet\_8bit\_controller. It can not be used as-is because there is no way to fill its instruction memory. To use it, you must copy the top-level module and replace the mem\_inst module with a ROM.

The parameters for this module are the following:

|Name | Description | Default value|
|------|------|-------| 
|clk\_freq|The frequency of the main clock in Hertz.|1 000 000|
|debug\_output|When set to 1, enable the debug helper module.|0|
|enable\_interrupt\_mux|If equal to 0, the interrupt multiplexer is disabled. |1|
|enable\_gpio|If equal to 0, the GPIOs are disabled. |1|
|enable\_timer|If equal to 0, the timer is disabled. |1|
|enable\_uart|If equal to 0, the UART is disabled. |1|
|mem\_resetable| If not set to 0, the memories are reset to 0 when the reset signal is pulled down. This can be incompatible with some FPGA's memory blocks. |0|

The ports of this module are the following:

|Name |Type   |Description|
|------|------|-------|
|clk     |input|The main clock.|
|reset |input|Reset the controller when flipped to low.|
|debug|output|Turned on for a clock cycle when the CPU executes a `debug` instruction.|
|debug\_tx|output|When `debug_output` is enabled, this line prints the content of the working register on `debug` instructions.|
|quit|output|Is turned on from the moment the CPU executes a quit instruction and stops itself.|
|gpi| 16-bit input | The input of the GPIO.|
|gpo| 16-bit output | The output of the GPIO.|
|rx|input| The rx line of the UART.|
|tx|output| The tx line of the UART.|

## 16 bits controller
The 16 bits controller is equipped with all the peripherals and its bigger addressable space makes it way easier to program for.

The memory map is the following:

|Start |End   |Content|
|------|------|-------|
|0x0000|0x7CFF|Instructions|
|0x7D00|0x7FFF|Bootloader|
|0x8000|0xFEFF|Data|
|0xFF00|0xFFFF|Peripherals|
|------|------|-------|
|0xFF00|0xFF03|Hardware info|
|0xFF04|0xFF07|Interrupt multiplexer|
|0xFF08|0xFF0F|GPIO|
|0xFF10|0xFF12|Timer|
|0xFF13|0xFF15|Timer 2|
|0xFF16|0xFF19|UART|
|0xFF1A|0xFF1B|PWM|
|0xFF1C|0xFF1E|Seven segments controller|
|0xFF1F|0xFF20|Power manager|
|0xFF21|0xFF21|Frequency synthesizer|
|0xFF22|0xFF23|Extended IO|

### Top-level module
The top-level module is in the `controller` folder and is named reflet\_16bit\_controller. Unlike its 8-bit counterpart, it can be used on its own as it is equipped with a bootloader that can be used to load a program in the data memory. Of course, if it is needed to only use a single program with an implementation, the mem\_inst module can be replaced with a ROM.

The parameters for this module are the following:

|Name | Description | Default value|
|------|------|-------| 
|clk\_freq|The frequency of the main clock in Hertz.|1 000 000|
|debug\_output|When set to 1, enable the debug helper module.|0|
|enable\_interrupt\_mux|If equal to 0, the interrupt multiplexer is disabled. |1|
|enable\_gpio|If equal to 0, the GPIOs are disabled. |1|
|enable\_timer|If equal to 0, the timer is disabled. |1|
|enable\_timer2|If equal to 0, the timer2 is disabled. |1|
|enable\_uart|If equal to 0, the UART is disabled. |1|
|enable\_pwm|If equal to 0, the PWM is disabled. |1|
|enable\_segments|If equal to 0, the seven segments display controller is disabled. |1|
|enable\_power\_manager|If equal to 0, the power manager is disabled. |1|
|enable\_synth|If equal to 0, the frequency synthesizer is disabled. |1|
|enable\_ext\_io|If equal to 0, the extended IO is disabled. |1|
|data\_size| Size in bytes of the data memory.|100| 
|inst\_size| Size in bytes of the instruction memory.|128|
|mem\_resetable| If not set to 0, the memories are reset to 0 when the reset signal is pulled down. This can be incompatible with some FPGA's memory blocks. |0|
|ext\_io\_size|The size of the extended io ports.|128|

The ports of this module are the following:

|Name |Type   |Description|
|------|------|-------|
|clk     |input|The main clock.|
|reset |input|Reset the controller when flipped to low.|
|reset\_limited|input|Reset the CPU, peripherals, and data memory but preserves the instruction memory.|
|debug|output|Turned on for a clock cycle when the CPU executes a `debug` instruction.|
|debug\_tx|output|When `debug_output` is enabled, this line prints the content of the working register on `debug` instructions.|
|quit|output|Is turned on from the moment the CPU executes a quit instruction and stops itself.|
|gpi| 16-bit input | The input of the GPIO.|
|gpo| 16-bit output | The output of the GPIO.|
|rx|input| The rx line of the UART.|
|tx|output| The tx line of the UART.|
|pwm|output|Output of the PWM.|
|segments|7-bit output| Seven-segment control, an output value of 0 means that the segment is on. |
|seg\_select| 4-bit output | Seven segments digit selection, an output value of 1 means that the digit is selected. |
|seg\_colon| output | Control of the colon indicator of the seven-segment display, a value of 0 means that the colon is turned on. |
|seg\_dot| output | Control of the decimal dot indicator of the seven-segment display, a value of 0 means that the dot is turned on. |
|synth\_out| output | Output of the frequency synthesizer. |
|ext\_io\_in | selectable size input | Input of the extended IO module. |
| ext\_io\_out | selectable size output | Output of the extended IO module. |

### Using the bootloader
The bootloader is very easy to use. After the processor started, transmit the program through the UART connection and wait 4 seconds for the program to start.

