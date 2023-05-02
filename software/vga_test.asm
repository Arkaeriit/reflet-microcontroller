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

    set8 10
    cpy R2
    set8 10
    cpy R3
    setr R4 0xF1
    callf gpu_draw_pixel
    inc R2
    gpu_call_draw_pixel
    inc R2
    gpu_call_draw_pixel
    inc R2
    gpu_call_draw_pixel
    inc R2
    gpu_call_draw_pixel
    inc R2
    gpu_call_draw_pixel
    inc R2
    gpu_call_draw_pixel
    
    set8 10
    cpy R2
    set8 10
    cpy R3
    setr R4 0xFF
    gpu_call_draw_pixel


    quit

