;This is the code used in the rom1, used in sim1_tb. This should be compiled with reflet-asm as shown in the makefile
;What it does is it copies the 15 first pins of the GPI to the GPO and
;it make the 16th bit of the GPO blink. The base address for the GPIO is 0x80
set 6  ;setting in 8 bit mode
cpy SR 
set 10 ;Getting the value 0x7F and 26
jmp
rawbyte 7F ;compiles to 0x7F
rawbyte 1A ;compiles to 0x1A = 26
set 8
cpy R1
load R1 ;getting 0x7F in the working register
cpy R1 ;0x7F to 0x83 in R1 to R5
set 1
add R1
cpy R2
set 1
add R2
cpy R3
set 1 
add R3
cpy R4
set 1
add R4
cpy R5
slp ;start of the routine 
load R4 ;copy of the 8 LSB of the GPIO
str R2
load R5 ;getting the 7 next bits into R7 for future use
and R1
cpy R7
load R3 ;getting the MSB of the GPO
and R2 
cpy R8
not R8
and R2 ;we isolated the opposito the the MSB of the GPIO in the WR
or R7  ;we combine with the bit 8 to 14 of the GPI
str R3 ; we use the combined value to update the 8 MSB of the GPO
set 9 ;we jump back to address 26
cpy R9
load R9
jmp
slp ;inaccessible
slp
quit

