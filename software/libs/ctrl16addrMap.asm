; This file contain labels to the base addresses of the various
; peipherals or memory space of the 16-bit controller

@align_word

label data
@rawbytes 00 80

label hardware_info
@rawbytes 00 FF ;0xFF00

label interrupt_manager
@rawbytes 04 FF ;0xFF04

label GPIO
@rawbytes 08 FF ;0xFF08

label timer
@rawbytes 10 FF ;0xFF10

label timer_2
@rawbytes 13 FF ;0xFF13

label UART
@rawbytes 16 FF ;0xFF16

label PWM
@rawbytes 1A FF ;0xFF1A

label seven_segments
@rawbytes 1C FF ;0xFF1C

label power_manager
@rawbytes 1F FF ;0xFF1F

label synth
@rawbytes 21 FF ;0xFF21

label ext_io
@rawbytes 22 FF ;0xFF22

