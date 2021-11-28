;This softaware is ment to do an echo on the UART
;It should work with the 16 bit microcontroller
;It is used to test the `uart.asm` lib

@import libs/ctrl16addrMap.asm
@import libs/uart.asm

label start
    callf getc
    callf printc
    goto start

