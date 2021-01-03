;-------------------------------------
;This file contains functions to use the UART for some basic IO

;---------------------
;Prints the char in R1
label printc
    pushr R2 ;addrs
    pushr R4 ;waiting loop pointer
    pushr R5 ;copy of the status register
    setlab UART ;UART tx_cmd addr
    load WR
    cpy R2
    setlab printcLoop
    cpy R4
    label printcLoop
        load R2 ;testing that R2 is not 0 to see if we are ready to print
        cpy R12
        set 0
        eq R12
        read R4 ;until ready, go back
        jif
    set 1    ;computing the data addr
    add R2
    cpy R12
    read R1 ;writing the char
    str R12
    set 0   ;sending command
    str R2
    popr R5 ;restoring registers
    popr R4 
    popr R2
    ret
        
;----------------------------
;print \n\r
label CR
    pushr R1
    set 10
    cpy R1
    callf printc
    set 13
    cpy R1
    callf printc
    popr R1
    ret

