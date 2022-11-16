; This is a very basic driver for the synth module

; Sets the note in R1 with the shape in R2
; All the values are masked in this function
label synth_set_note
    pushr R1
    pushr R2

    ; Masking values
    set8 0x3F ; tone mask
    and R1
    cpy R1
    set 3 ; shape mask
    and R2
    cpy R2

    ; Creating the 8 bit config for the synth
    set 6
    cpy R12
    read R2
    lsl R12
    or  R1
    cpy R1

    ; Writing the config
    setlab synth
    load WR
    cpy R2
    read R1
    tbm
    str R2
    tbm

    ; Cleanup
    popr R2
    popr R1
    ret

