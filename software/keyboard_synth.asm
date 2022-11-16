; This small program uses the UART to get notes and feed them into the synth
; It is assumed that the stack pointer is set by the assembler

; The tone is read from the GPIOs

@import libs/uart.asm
@import libs/synth.asm
@import libs/ctrl16addrMap.asm

label start
    ; Read tone
    callf getc
    callf printc ; UART loopback
    ; Read shape
    setlab GPIO
    load WR
    cpy R2
    set 2
    add R2
    cpy R2
    load R2
    cpy R2
    ; set not and loop back
    callf synth_set_note
    goto start

