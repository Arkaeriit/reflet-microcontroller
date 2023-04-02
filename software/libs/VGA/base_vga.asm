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
; Draw at coords width = R2 and height = R3 a pixel of color in R4
label gpu_draw_pixel
    ; Hardware address
    pushr. R1
    set 1
    cpy R1
    load R10
    debug
    call
    load R1
    cpy R1
    debug
    ; Status register
    pushr. SR
    set 6
    cpy SR
    ; Writing horizontal position
    read R2
    str R1
    ; Writing vertical position
    inc. R1
    read R3
    str R1
    ; Writing color
    inc. R1
    read R4
    str R1
    ; Restoring registers
    popr. SR
    popr. R1
    ret
    
;----------------------------------
; Initializes the GPU context in the memory in R10
label _gpu_init_context
    pushr. R1
    read R10
    cpy R1
    ; Field access function
    debug
    setlab gpu_get_field_from_context_16_bits
    str R1
    ; Hardware address
    inc_ws. R1
    debug
    set+ 0xFF24 ; TODO: cleanup
    str R1
    ; Set pixel function
    inc_ws. R1
    debug
    setlab gpu_draw_pixel
    str R1
    ; Screen width
    inc_ws. R1
    debug
    set8 160 ; TODO: cleanup
    str R1
    ; Screen height
    inc_ws. R1
    debug
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


