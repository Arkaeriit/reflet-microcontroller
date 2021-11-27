;This file is ment to be compiled with reflet-masm
;It is used to make a stopwatch out of a reflet processor
;hooked up to a seven segment display

@import libs/ctrl16addrMap.asm

label start
setlab data ;0x8000, the beguining of the RAM
load WR
cpy SP
setlab seven_segments ;0xFF1C, the base address for the seven segment
load WR
cpy R1
set 3
str8 R1 ;enable it and activate the colon
setlab timer ;0xFF10, the base address for the timer
load WR
cpy R2
set+ 99 ; need to be changed to the correct value ;getting a division of 1 000 000 with the three prescalers
str8 R2
push
set 1
add R2
cpy R2
pop
str8 R2
push
set 1
add R2
cpy R2 ;R2 now contain the last register of the timer
setlab hardware_info ;0xFF00, base address of the hadware info
load WR
cpy R3
load8 R3
str8 R2 ;set the last timer value to the clock. The timer 1 now ticks 1/100 of a seconds
set 1
add R2
cpy R2 ;R2 now contain the first register of timer2
set 1
str8 R2 ;We enabled the chaining of timers
add R2
cpy R2
pop
str8 R2
set 1
add R2
cpy R2
set 1
str8 R2 ;Timer 2 is now active, ticking once a second
setlab interrupt_manager
load WR ;We now have 0xFF04, the base address of the exti
cpy R3
set 8
str8 R3 ;We ennabled the timer 2 interrupt
set 3
add R3
cpy R3 ;R3 now have the address of the status register of exti
setlab updateTime
setint 0
set 8
cpy SR ;We enable int0 with updateTime as the routine
set 4
cpy R2 ;R2 contain 4
setlab loop
label loop
slp
slp
jmp


label updateTime
push
set 0 ;we clear the interrupt
str8 R3
set 1
add R1 ;address for the 2 first digits
cpy R4
callf editNum
load8 R4 
cpy R5 
set+ 96 ;x59 Test if we need to update the minutes
eq R5
setlab editMin
jif 
label retTime
pop
retint

label editMin
set 0
str8 R4
set 1
add R4
cpy R4
callf editNum
goto retTime


;This function edits the value of the number stored at address in R4 and update it in a decimal format compatible withe the seven segment display driver
label editNum
load8 R4
cpy R5
set 1
add R5
cpy R5 ;R5 contain the updated units of seconds
set 15
and R5
cpy R6 ;Test if got to 10 
set 10
eq R6
setlab edit10
jif
label retUnit
read R5
str8 R4
ret

label edit10
set 4
cpy R6
load8 R4
lsr R6
cpy R5
set 1 
add R5
lsl R6
cpy R5
goto retUnit

