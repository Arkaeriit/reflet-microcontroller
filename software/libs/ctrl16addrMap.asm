; This file contain labels to the base addresses of the various
; peipherals or memory space of the 16-bit controller

label data
rawbytes 00 128 ;0x8000

label hardware_info
rawbytes 00 255 ;0xFF00

label interrupt_manager
rawbytes 04 255 ;0xFF04

label GPIO
rawbytes 08 255 ;0xFF08

label timer
rawbytes 16 255 ;0xFF10

label timer_2
rawbytes 19 255 ;0xFF13

label UART
rawbytes 22 255 ;0xFF16

label PWM
rawbytes 26 255 ;0xFF1A

label seven_segments
rawbytes 28 255 ;0xFF1C

