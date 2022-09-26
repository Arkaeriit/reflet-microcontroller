;This program is ment to be a bootloader for the 16 bits microcontroller
;It wait for 4 seconds for an UART message and if there is, it load it in RAM.
;This bootloader never uses the RAM, only peripherals (uart, exti, timer, timer2) and registers

;R1 contain the UART timeout
;R2 contain the target RAM addr for loading the program
;R3 contail the status register
;R4 and R5 is used to store the WR in interupt for the UART and the timer, respectively
;R6 contain 400, the timer timeout reset
;R7 contain 0xFF15, the rx_data register
;R8 contain the endBoot label
;R9 is ised as a scratch register for timHandle
;R10 contain the addr of the infinite loop

label init ;The label will probabely be unused...
set 0 ;init registers
cpy R2
set 4 
cpy R1
setlab hardware_info ;Getting H I addr
load WR
cpy R3
tbm ;Set byte mode as all we are going to read from HI and timer
load R3
cpy R4
set 1
add R3
cpy R3
load R3
cpy R5 ;R4 is clk_lsb R5 is clk_msb


;timer config
set 15
add R3
cpy R3 ;base addr for timer 1
tbm
set+ 99
tbm
str R3
cpy R6 ;pre1 is set to 99
set 1
add R3 
cpy R3
read R6
str R3 ;pre2 is set to 99
set 1
add R3
cpy R3
set 1
str R3 ; mcnt is set to 1
set 0
eq R5
cmpnot
tbm
setlab timerHF ;if there is a high frequency clock
tbm
jif

;low freq clock
set 1
add R3
cpy R3
set 1
str R3 ;enable timer links
set 2
add R3
cpy R3
read R4
str R3
tbm ;finished reading from HI and timer
goto endTimer

label timerHF
tbm ;more timer config
set 1
add R3
cpy R3 ; timer2
set 1
str R3 ;enable timer linking
set 1
add R3
cpy R3
tbm
set+ 255
tbm
str R3 ;pre2 is now 255 to divide the clock speed by 256
set 1
add R3
cpy R3
read R5
str R3
tbm ;end timer config

label endTimer
; interupt manager config
setlab interrupt_manager
load WR
tbm ;Starting to manipulate EXTI
cpy R3
set 10
str R3 ;enable tim2 int and UART int
set 1
add R3
cpy R3
tbm
set+ 64
tbm
str R3 ;set tim2 int to level 1
tbm ;finished EXTI config
set 2
add R3
cpy R3 ;R3 is now the status register

;here, we configure the interrupt on the CPU level
set+ 400
cpy R6
cpy R1
set+ 65305 ;TX data register
cpy R7
setlab endBoot
cpy R8
setlab uartHandle
setint 0
setlab timHandle
setint 1
set+ 24
cpy SR ;we enable int 0 and 1
setlab bootLoop
cpy R10
label bootLoop
slp
set 0 ;Testing for the end of the timeout
eq R1
read R8
jif
read R10 ;going back up
jmp

label endBoot
;clean the peripherals, reset the register and jump back to addr 4
set 1
cpy SR
set+ 65284 ;0xFF04
tbm ;about to reset peripherals
cpy R1
set 0 
str R1
set 1
add R1
cpy R1
set 0
str R1
set 1
add R1
cpy R1
set 0
str R1 ;exti is clear
set 9
add R1
cpy R1
set 0 
str R1
set 1
add R1
cpy R1
set 0 
str R1
set 1
add R1
cpy R1
set 0 
str R1
set 1
add R1
cpy R1
set 0 
str R1
set 1
add R1
cpy R1
set 0 
str R1
set 1
add R1
cpy R1
set 0 
str R1 ;timer and timer2 are cleared
tbm ;finished reset periph
cpy R1
cpy R2
cpy R3
cpy R4
cpy R5
cpy R6
cpy R7
cpy R8
cpy R9
cpy R10
cpy R11
cpy R12
;cpy R13 SR is already set
cpy R15
set 4
jmp ;jmp back to the start

label uartHandle
tbm
cpy R4 ;protect WR
read R6 ;Reset timeout
cpy R1 
set 0 ;clear int
str R3
load R7 ;reading the char
str R2
;cpy R12 ;Uncomment this section for UART loop back.
;set 2
;cc2
;add R7
;cpy R11
;read R12
;str R11
;set 1
;cc2
;add R11
;cpy R11
;set 0
;str R11
set 1 ;update the target addr
add R2
cpy R2
read R4 ;reset WR
tbm
retint

label timHandle
tbm
cpy R5 ;protect WR
set 0
str R3 ;clear int
set 1 ;sub 1 from the timeout
cpy R9
read R1
sub R9
cpy R1
read R5
tbm
retint

;Importing symbols with needed address
@import libs/ctrl16addrMap.asm

