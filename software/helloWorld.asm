wordsize 16
;This is the code used to make the rom2 used in sim2_tb. This should be compiled with reflet-masm
;This program prints "Hello, world!\r\n" with the UART
;This program depends on the library printing.asm to work, read the
;Makefile to see how to compile it.

label string
data "Hello, world!"
rawbytes 13 10 0

label start
    setlab data
    load WR
    cpy SP
    setlab string
    cpy R1
    callf print
    quit

