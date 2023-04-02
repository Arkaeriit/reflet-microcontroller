;------------------------------
; This file constains function used to reset the processor with software
; Those functions only restart the CPU and not the peripherals

;------------------------------
; Restart the processor and run the current software (you don't nedd a lib for
; that, lol)
label reset
    set 4
    jmp

;-----------------------------
; Reset the processor to the bootloader
; Made for a 16 bit processor
label reset_to_bootloader
    ; No need to save registers, lol
    setlab 16_bit_por_routine
    cpy R1 ; Read address
    setlab end_16_bit_por_routine
    cpy R2 ; End of reading address
    set 0
    cpy R3 ; Write address
    set 6
    cpy SR ; Byte mode
    label copy_por_routine_loop
        load R1
        str R3
        ; Increment addresses
        set 1
        add R3
        cpy R3
        set 1
        add R1
        cpy R1
        ; Jump back if not done
        eq R2
        cmpnot
        setlab copy_por_routine_loop
        jif
    set 1
    cpy SR
    goto reset
    
    ; This is the small routine written at the start of the instruction memory
    ; on the first boot of the 16 bit controller
    @align 2
    label 16_bit_por_routine
        @rawbytes 00 7D 00 00 ; The bootloader address and a padding word
        set 0
        load WR
        jmp
    label end_16_bit_por_routine

