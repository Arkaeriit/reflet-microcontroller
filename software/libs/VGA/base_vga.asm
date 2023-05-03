;-------------------------------------
; This is the lower level functions of the reflet_GPU VGA controller

; To swiften memory access, a context with addresses to functions or hardware
; is used all along the driver and should be put in R10
; Context content:
;   - field access function
;   - GPU hardware base address
;   - Set pixel function
;   - Screen width
;   - Screen height
@define set_gpu_context_size 0
    set 5
@end

;---------------------------------------
; R1 <- 2 * R1 + R10
; Used to get an offset to the context struct
label gpu_get_field_from_context_16_bits
    read R1
    add R1
    add R10
    cpy R1
    ret

;---------------------------------------
; Write in the working register the data at the offset from the context given in argument
@define gpu_read_from_context 1
    pushr. R1
    set $1
    cpy R1
    load R10
    call
    load R1
    popr R1
@end

;----------------------------------------
; Call the function at the given offset in the context
@define gpu_call_from_context 1
    gpu_read_from_context $1
    call
@end

;---------------------------------------
; Draw at coords width = R2 and height = R3 a pixel of color in R4
label gpu_draw_pixel
    ; hardware address
    pushr. r1
    set 1
    cpy r1
    load r10
    call
    load r1
    cpy r1
    ; status register
    pushr. sr
    set 6
    cpy sr
    ; Writing horizontal position
    read R2
    str R1
    ; Writing vertical position
    inc. R1
    read R3
    str R1
    ; Setting char to 0 to ensure that the bitmap layer is used and not the text one
    inc. R1
    set 0
    str R1
    ; Writing color
    set 2
    addup. R1
    read R4
    str R1
    ; Restoring registers
    popr. SR
    popr. R1
    ret

;-----------------------------------------
; Draw a letter at coords width = R2, height = R3
; The letter is of fg = R4, bg = R5, char = R6
label gpu_draw_letter
    ; Hardware address
    pushr. R1
    set 1
    cpy R1
    load R10
    call
    load R1
    cpy R1
    ; status register
    pushr. sr
    set 6
    cpy sr
    ; Writing horizontal position
    read R2
    str R1
    ; Writing vertical position
    inc. R1
    read R3
    str R1
    ; char
    inc. R1
    read R6
    str R1
    ; background color
    inc. R1
    read R5
    str R1
    ; foreground color
    inc. R1
    read R4
    str R1
    ; Restoring registers
    popr. SR
    popr. R1
    ret

;----------------------------------
; Fetches the address of draw_pixel and calls it
@define gpu_call_draw_pixel 0
    gpu_call_from_context 2
@end
    
;----------------------------------
; Initializes the GPU context in the memory in R10
label _gpu_init_context
    pushr. R1
    read R10
    cpy R1
    ; Field access function
    setlab gpu_get_field_from_context_16_bits
    str R1
    ; Hardware address
    inc_ws. R1
    set+ 0xFF24 ; TODO: cleanup
    str R1
    ; Set pixel function
    inc_ws. R1
    setlab gpu_draw_pixel
    str R1
    ; Screen width
    inc_ws. R1
    set8 160 ; TODO: cleanup
    str R1
    ; Screen height
    inc_ws. R1
    set8 120 ; TODO: cleanup
    str R1
    ; Cleanup
    popr R1
    ret

;----------------------------
; Allocate a bit of stack and initialize the context there
; This macro trashes R1 and R2
@define gpu_init_context 0
    ; Compute stack size needed
    @set_wordsize_byte
    cpy R1
    set_gpu_context_size
    cpy R2
    callf intMult
    ; Store SP and update it
    read SP
    cpy R10
    add R1
    cpy SP
    ; Init function
    callf _gpu_init_context
@end

;----------------------------
; Fills the screen with the color in R1 on the bitmap layer
label gpu_fill
    ; Init registers
    pushr. R2
    pushr. R3
    pushr. R4
    pushr. R5
    pushr. R6
    mov. R4 R1
    set 0
    cpy R2
    setlab gpu_fill_width_loop
    cpy R5
    setlab gpu_fill_height_loop
    cpy R6
    label gpu_fill_width_loop
        set 0
        cpy R3
        label gpu_fill_height_loop
            gpu_call_draw_pixel
            inc. R3
            gpu_read_from_context 4
            eq R3
            cmpnot
            read R6
            jif
        inc. R2
        gpu_read_from_context 3
        eq R2
        cmpnot
        read R5
        jif
    ; cleanup
    popr. R6
    popr. R5
    popr. R4
    popr. R3
    popr. R2
    ret

;------------------------------------------
; Fill the line at height R3 with the letter
; of fg = R4, bg = R5, char = R6
label gpu_write_line
    pushr. R1
    pushr. R2
    set 3
    cpy R1
    gpu_read_from_context 3 ; Screen width
    lsr R1 ; Divide by 8 to have the number of char in a line
    cpy R1
    set 0
    cpy R2 ; loop counter
    label gpu_write_line_loop
        callf gpu_draw_letter
        inc. R2
        read R1
        eq R2
        cmpnot
        jifl gpu_write_line_loop
    popr. R2
    popr. R1
    ret

;------------------------------------------
; Fill the screen with the letter
; of fg = R4, bg = R5, char = R6
label gpu_write_screen
    pushr. R1
    pushr. R3
    set 3
    cpy R1
    gpu_read_from_context 4 ; Screen height
    lsr R1 ; Divide by 8 to have the number of char in a column
    cpy R1
    set 0
    cpy R3 ; loop counter
    label gpu_write_screen_loop
        callf gpu_write_line
        inc. R3
        read R1
        eq R3
        cmpnot
        jifl gpu_write_screen_loop
    popr. R3
    popr. R1
    ret

;----------------------------
; Fills the screen with the color in R1 on the text layer
label gpu_fill_txt
    pushr. R4
    pushr. R5
    pushr. R6
    mov. R4 R1
    mov. R5 R1
    set 1 ; Any non 0 value works
    cpy R6
    callf gpu_write_screen
    popr. R6
    popr. R5
    popr. R4
    ret

;---------------------------
; Starting from width = R2 and height = R3, with letters of color fg = R4
; bg = R5, write the text in R1 of length in R6
label (gpu_print)
    pushr. R1
    pushr. R2 ; R2 will be used as the position to write and will thus be modified
    pushr. R6
    read R2
    addup. R6 ; R6 is used as the end of loop value, it correspond to the position at which to stop to print
    label (gpu_print)_loop
        pushr. R6
        load8 R1
        cpy R6
        callf gpu_draw_letter
        popr. R6
        inc. R1
        inc. R2
        read R2
        eq R6
        cmpnot
        jifl (gpu_print)_loop
    popr. R6
    popr. R2
    popr. R1
    ret
        
;-------------------------
; Same as (gpu_print) but compute the length of text
label gpu_print
    pushr. R6
    pushr. R1
    callf strlen
    mov. R6 R1
    popr. R1
    callf (gpu_print)
    popr. R6
    ret

;-------------------------
; Fill the text layer with black and the bitmap layer with transparent pixels
label gpu_black
    pushr. R1
    set 0
    cpy R1
    callf gpu_fill
    callf gpu_fill_txt
    popr. R1
    ret

