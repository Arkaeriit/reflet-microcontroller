;This is the code used to make the rom2 used in sim2_tb. This should be compiled with reflet-asm as showed in the makefile
;This program prints "Hello, world!\r\n" with the UART
;This program depends on the library printing.asm to work, read the
;Makefile to see how to compile it.

@import libs/uart.asm
;@import libs/basicIO.asm
@import libs/ctrl16addrMap.asm
@import libs/printing.asm
@import libs/math.asm
@import libs/string.asm

@align_word
label string
@string "Hello, world!"
@rawbytes D A 0

label start
    setlab string
    cpy R1
    callf print
    quit

