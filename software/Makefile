
all : basicInt.bin clock.bin bootloader16.bin helloWorld.bin simuGPIO.bin uartLoopBack.bin primes.bin low_power_mode.bin uartLoopBack_16bits.bin keyboard_synth.bin test_instructions.bin vga_test.bin

clean :
	rm -f *.bin

basicInt.bin : basicInt.asm
	reflet-asm -word-size 8 -no-stack-init -ignore-start basicInt.asm -o basicInt.bin

clock.bin : clock.asm libs/ctrl16addrMap.asm
	reflet-asm -word-size 16 -no-stack-init clock.asm -o clock.bin # Note: there is the argument `no-stack-init` as the stack pointer is initialized in the program

bootloader16.bin : bootloader16.asm
	reflet-asm -word-size 16 -no-prefix -no-stack-init -ignore-start -start-addr 32000 bootloader16.asm -o bootloader16.bin #start addr set to 0x7D00

../controller/reflet_bootloader16_rom.v : bootloader16.bin
	ROM_maker -name reflet_bootloader16_rom -input_file $< -output_file $@ -wordsize 2 -start_addr 16000 -min_addr_size 14

helloWorld.bin : helloWorld.asm libs/ctrl16addrMap.asm libs/uart.asm libs/printing.asm libs/math.asm libs/string.asm
	reflet-asm helloWorld.asm -o helloWorld.bin -word-size 16 -set-stack-to 32768 #Note: stack starts at 0x8000

../simu/rom02.v : helloWorld.bin
	ROM_maker -name rom02 -input_file $< -output_file $@ -wordsize 2 -min_addr_size 14

../simu/rom04.v : uartLoopBack.bin
	ROM_maker -name rom04 -input_file $< -output_file $@ -wordsize 1 -min_addr_size 7

../simu/rom08.v : keyboard_synth.bin
	ROM_maker -name rom08 -input_file $< -output_file $@ -wordsize 2 -min_addr_size 14

simuGPIO.bin : simuGPIO.asm
	reflet-asm simuGPIO.asm -o simuGPIO.bin -no-stack-init -word-size 8 -ignore-start

uartLoopBack.bin : uartLoopBack.asm
	reflet-asm -word-size 8 -no-stack-init uartLoopBack.asm -o uartLoopBack.bin

primes.bin : primes.asm libs/ctrl16addrMap.asm libs/uart.asm libs/printing.asm libs/math.asm libs/string.asm
	reflet-asm primes.asm -word-size 16 -o primes.bin

low_power_mode.bin : low_power_mode.asm libs/ctrl16addrMap.asm
	reflet-asm low_power_mode.asm -word-size 16 -o low_power_mode.bin

uartLoopBack_16bits.bin : uartLoopBack_16bits.asm libs/ctrl16addrMap.asm libs/uart.asm
	reflet-asm uartLoopBack_16bits.asm -word-size 16 -set-stack-to 32768 -o uartLoopBack_16bits.bin

keyboard_synth.bin : keyboard_synth.asm libs/ctrl16addrMap.asm libs/uart.asm libs/synth.asm
	reflet-asm $< -o $@ -word-size 16 -set-stack-to 32768

test_instructions.bin : test_instructions.asm
	reflet-asm test_instructions.asm -o test_instructions.bin -word-size 16 -no-stack-init

../simu/simu9_tb.vh : test_instructions.bin
	printf '`define test_instruction_bin_size %i\n' $$(wc --bytes < $<) > $@
	printf "\`define test_instruction_bin %i'h%s\n" $$(echo $$(wc --bytes < $<) 8 '*' n | dc) $$(xxd -p -c1 < $< | tac | tr -d '\n') >> $@

vga_test.bin : vga_test.asm libs/ctrl16addrMap.asm libs/math.asm libs/VGA/base_vga.asm libs/string.asm
	reflet-asm $< -o $@ -word-size 16 -set-stack-to 32768

../simu/rom10.v : vga_test.bin
	ROM_maker -name rom10 -input_file $< -output_file $@ -wordsize 2 -min_addr_size 14

vga_hello_world.bin : vga_hello_world.asm libs/ctrl16addrMap.asm libs/math.asm libs/VGA/base_vga.asm libs/string.asm
	reflet-asm $< -o $@ -word-size 16 -set-stack-to 32768

