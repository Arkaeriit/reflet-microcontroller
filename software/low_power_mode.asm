; This is a small demo to test the low-power mode of the processor

@import libs/ctrl16addrMap.asm

label start
    setlab data
    load WR
    cpy SP
    ;run a function in max-power mode
    callf loopOverWAD
    ;using the power_manager to reduce the speed of the processor
    setlab power_manager
    load WR
    cpy R9
    set 2  ;enabeling the low-power mode
    str8 R9
    set 1
    add R9
    cpy R1
    set+ 100 ;choosing the speed factor, a bit slower that 2x normal speed
    str8 R1
    ;runing the function again
    callf loopOverWAD
    ;reseting the max speed
    set 0
    str8 R9
    ;setting a timer
    setlab timer
    load WR
    cpy R1
    set+ 100
    str8 R1
    set 2
    add R1
    cpy R1
    set+ 100
    str8 R1
    ;enabeling the timer interrupt in the interupt manager
    setlab interrupt_manager
    load WR
    cpy R1
    set 4 ;enabeling the interupt
    str8 R1
    ;making the processor sleep until an interupt with level 0 is raised
    set+ 17 ; 0b0001 0001, int 0 and sleep mode
    str8 R9
    ;calling the function a last time
    callf loopOverWAD
    quit
    
;This function waits for 100 loop cycle and then does a debug instruction
label waitAndDebug
    set+ 100
    cpy R1
    setlab waitAndDebugLoop
    cpy R2
    label waitAndDebugLoop
        set 1
        cpy R3
        read R1
        sub R3
        cpy R1
        set 0
        eq R1
        cmpnot
        read R2
        jif
    debug
    ret

;this function runs waitAndDebug 10 times in a loop
label loopOverWAD
    set 10
    cpy R4
    setlab loopLOWAD
    cpy R5
    label loopLOWAD
        callf waitAndDebug
        set 1
        cpy R6
        read R4
        sub R6
        cpy R4
        set 0
        eq R4
        cmpnot
        read R5
        jif
    ret

