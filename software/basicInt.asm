;this is the code used to make rom3 used in simu3_tb. This should be compiled with reflet-masm.
;This program run a debug instruction wil level 2 each time a bit in the GPIO is flipped
;The base address for the GPIO in 0x80 and the address for the interrupt_mux is 0x88

label start
;configuring the GPIO
set8 132 ;address of the GPIO interupt controll
cpy R1
set 0
not WR ;settinf 0xFF to enable all interrupts
cpy R2
str R1
set 1 
add R1
cpy R1
read R2
str R1
set 1 
add R1
cpy R1
read R2
str R1
set 1 
add R1
cpy R1
read R2
str R1

;configuring the interrupt manager
set 1
add R1
cpy R1
set 1
str R1
add R1 
cpy R1
set 2
str R1
set 1
add R1
cpy R1 ;setting the status register in R1

;configuring the interruption on the cpu side
set 1
add R1
cpy R1 ;storing the value of the interrupt_mux status register in R1
setlab intRoutine
setint 2
set 8 ;enable the int2 flag
cpy SR

;infinite loop
setlab loop
label loop
slp
slp
jmp
quit ;unreachable

label intRoutine
cpy R2 ;saving the value of the WR
debug
set 0
str R1 ;clearing the status register of the interupt manager
read R2
retint

