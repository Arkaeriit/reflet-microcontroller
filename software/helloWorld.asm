wordsize 16
;This is the code used to make the rom2 used in sim2_tb. This should be compiled with reflet-masm
;This program prints "Hello, world!\r\n" with the UART
;The base address for the UART is Ox8000. This addres is stored in R9

label string
data "Hello, world!"
rawbytes 13 10 0

;This function prints the byte stored in R3
label printc
set 1  ;Preparyng address 0x8001
add R9
cpy R4
read R3 ;Puting R3 into 0x8001
str R4
set 0 ;Putting 0 into 0x8000 to start the transmission
str R9
setlab waitForEndTx ;putting the start of the loop waitForEndTx into R3
cpy R3
    label waitForEndTx
    load R9
    cpy R4
    set 0  ;comparing the content of tx_cmd whith 0, because it will be set to 1 once the character will be send
    eq R4
    read R3
    jif
ret
    
;This function print a string whith a pointer in R1 until it is a null terminator
label prints
    cpy R2 ;R2 stores the begining of the function
    load R1
    cpy R3 ;R3 stores the current char
    set 0
    eq R3
    setlab endprint ;if we find null char, we jump to the end
    jif
    callf printc 
    set 1 ;we increment the pointer
    add R1
    cpy R1
    read R2 ;we go back on top of the loop
    jmp
label endprint
ret

label start
set 6
cpy SR
set+ 32768 ;0x8000
cpy R9
set 4 ;We put the stack just after the memory of the UART
add R9
cpy SP
setlab string
cpy R1
callf prints
quit

