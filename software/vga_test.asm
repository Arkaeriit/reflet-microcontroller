; This program simply set a few pixels on the VGA screen

@import libs/math.asm
@import libs/ctrl16addrMap.asm
@import libs/VGA/base_vga.asm

@import libs/uart.asm
@import libs/printing.asm
@import libs/string.asm

label start

    gpu_init_context

    ;setr R1 1
    ;callf gpu_fill

    set 5
    cpy R2
    set 5
    cpy R3
    setr R4 0xF0
    setr R5 0xFF
    set 2
    cpy R6
    callf gpu_draw_pixel
    callf gpu_draw_letter
    inc R2
    gpu_call_draw_pixel
    callf gpu_draw_letter
    inc R2
    set 0
    cpy R6
    gpu_call_draw_pixel
    callf gpu_draw_letter
    inc R2
    gpu_call_draw_pixel
    callf gpu_draw_letter
    inc R2
    gpu_call_draw_pixel
    callf gpu_draw_letter
    inc R2
    gpu_call_draw_pixel
    callf gpu_draw_letter
    inc R2
    gpu_call_draw_pixel
    callf gpu_draw_letter
    
    set8 10
    cpy R2
    set8 10
    cpy R3
    setr R4 0xFF
    gpu_call_draw_pixel


    quit

