# Software for the Reflet microcontroller

This folder contains software meant to be run on a Reflet microcontroller. The makefile gives examples on how to compiles the programs.

Most of the programs here are used in the simulation folder as ROM.

The `libs` folder contain all the libraries from the original Reflet repository with a few additions.

* `uart.asm` implement the functions from `basicIO.asm` but meant to be used on the 16 bit microcontroller instead of the simulator.
* `ctrl16addrMap.asm` contain the addresses of the peripherals of the 16 bits microcontroller.

