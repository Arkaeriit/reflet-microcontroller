
all : basicInt.bin clock.bin bootloader16.bin helloWorld.bin simuGPIO.bin uartLoopBack.bin

clean :
	rm -f *.bin

basicInt.bin : basicInt.asm
	reflet-masm basicInt.asm -o basicInt.bin

clock.bin : clock.asm libs/ctrl16addrMap.asm
	reflet-masm clock.asm libs/ctrl16addrMap.asm -o clock.bin

bootloader16.bin : bootloader16.asm
	reflet-masm -no-prefix -no-stack-init -ignore-start -start-addr 32256 bootloader16.asm -o bootloader16.bin #start addr set to 0x7E00

helloWorld.bin : helloWorld.asm libs/ctrl16addrMap.asm libs/uart.asm libs/printing.asm libs/math.asm libs/string.asm
	reflet-masm helloWorld.asm libs/ctrl16addrMap.asm libs/uart.asm libs/math.asm libs/string.asm libs/printing.asm -o helloWorld.bin

simuGPIO.bin : simuGPIO.asm
	reflet-pasm simuGPIO.asm simuGPIO.bin

uartLoopBack.bin : uartLoopBack.asm
	reflet-masm uartLoopBack.asm -o uartLoopBack.bin

