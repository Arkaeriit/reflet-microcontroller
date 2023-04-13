;-------------------------------------
;This file contains functions to use the UART for some basic IO

;---------------------
;Prints the char in R1
label printc
    pushr R2 ;addrs
    pushr R4 ;waiting loop pointer and tmp register for tx_data addr
    setlab UART ;UART tx_cmd addr
    load WR
    cpy R2
    setlab printcLoop
    cpy R4
    label printcLoop
        load8 R2 ;testing that R2 is not 0 to see if we are ready to print
        cpy R12
        set 0
        eq R12
        read R4 ;until ready, go back
        jif
    set 1    ;computing the data addr
    add R2
    cpy R4
    read R1 ;writing the char
    str8 R4
    set 0   ;sending command
    str8 R2
    popr R4 ;restoring registers
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

;------------------------------
;waits until a new char is received on the uart and the writes it to R1
label getc
    pushr R2 ; periph addr
    pushr R3 ; stores label
    setlab UART
    load WR
    cpy R2
    set 2
    add R2
    cpy R2 ;R2 now holds the rx_cmd address
    setlab getcLoop
    cpy R3
    set 1
    str8 R2 ;Now, there is a non-0 value in rx_cmd meaning that we know that when there will be a 0 back, we received a char
    cpy R1 ;Used to temporaly store the value expected to be in rx_cmd
    label getcLoop
        load8 R2
        eq R1
        read R3
        jif
    set 1  ;A byte have been written, we can get it in rx_data register
    add R2
    cpy R2
    load8 R2
    cpy R1
    popr R3 ;restauring stored value
    popr R2
    ret

