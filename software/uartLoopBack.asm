;This software is ment to be used to create a loopback on the UART
;It is went to be used with an 8 bit processor and the minimal set of peripherals
;R2 should contain the base address for the UART
;R1 should contain the base address for the interrupt manager

label start
;configuring the interrupt manager, enable the UART int and leaves it at level 0
set8 237
cpy R1 ;interrupt multiplexer base address
set 2
str R1
;cofiguring the interrupt on the CPU
setlab uart_int_routine
setint 0
set 8
cpy SR
;getting the base address of the UART
set8 252 
cpy R2
;infinite loop
setlab loop
label loop
slp
slp
jmp

label uart_int_routine
cpy R4 ;storing the working register
set 3 ;reading rx_data
add R2
cpy R5
load R5
cpy R3
set 1 ;storing it to tx_data
add R2
cpy R5
read R3
str R5
set 0 ;putting 0 in tx_cmd to 
str R2
set 3 ;clearing the interrupt
add R1
cpy R3
set 0
str R3
read R4 ;getting the working register back
retint

