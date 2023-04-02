; This program simply set a few pixels on the VGA screen

@import libs/math.asm
@import libs/ctrl16addrMap.asm
@import libs/VGA/base_vga.asm

label start

    gpu_init_context

    set8 10
    cpy R2
    set8 10
    cpy R3
    setr R4 48
    callf gpu_draw_pixel
    inc R2
    callf gpu_draw_pixel
    inc R2
    callf gpu_draw_pixel
    inc R2
    callf gpu_draw_pixel
    inc R2
    callf gpu_draw_pixel
    inc R2
    callf gpu_draw_pixel
    inc R2
    callf gpu_draw_pixel
    
    quit

