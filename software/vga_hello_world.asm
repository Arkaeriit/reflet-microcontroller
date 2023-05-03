; This program writes "Hello, world!" along with an hearth on the screen

@import libs/math.asm
@import libs/ctrl16addrMap.asm
@import libs/VGA/base_vga.asm
@import libs/string.asm

label hello
@string-0 Hello, world!

; Pairs of x-y coordinates used to draw a hearth. 1-indexed, 0-terminated
label hearth
@rawbytes         1 3 1 4     1 6 1 7
@rawbytes     2 2 2 3 2 4 2 5 2 6 2 7 2 8
@rawbytes 3 1 3 2 3 3 3 4 3 5 3 6 3 7 3 8 3 9
@rawbytes 4 1 4 2 4 3 4 4 4 5 4 6 4 7 4 8 4 9
@rawbytes 5 1 5 2 5 3 5 4 5 5 5 6 5 7 5 8 5 9
@rawbytes     6 2 6 3 6 4 6 5 6 6 6 7 6 8
@rawbytes         7 3 7 4 7 5 7 6 7 7
@rawbytes             8 4 8 5 8 6
@rawbytes                 9 5
@rawbytes 0 0

label start
    gpu_init_context
    callf gpu_black

    setlab hello
    cpy R1
    setr R2 2
    setr R3 2
    setr R4 0x07
    setr R5 0x00
    callf gpu_print

    callf draw_hearth

    quit

; Draw a hearth at coords 30 30
label draw_hearth
    ; Initialize useful constants such as pointer, color, and offset
    setlab hearth
    cpy R1
    setr R4 0xC3
    setr R5 29
    setr R6 29
    ; Prepare first pixel
    load8 R1
    cpy R3
    inc R1
    load8 R1
    cpy R2
    label hearth_loop
        ; Draw current pixel
        read R5
        addup R2
        read R6
        addup R3
        callf gpu_draw_pixel
        ; Move pointer R1 and update target coords
        inc R1
        load8 R1
        cpy R3
        inc R1
        load8 R1
        cpy R2
        ; Check for null termination
        set 0
        eq R2
        cmpnot
        jifl hearth_loop
    ret

