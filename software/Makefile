
all : basicInt.bin clock.bin bootloader16.bin helloWorld.bin simuGPIO.bin uartLoopBack.bin primes.bin low_power_mode.bin uartLoopBack_16bits.bin keyboard_synth.bin test_instructions.bin vga_test.bin

DEFAULT_REFLET_ASM := ../submodules/reflet/assembler/reflet-asm.bin
REFLET_ASM ?= $(DEFAULT_REFLET_ASM)

$(DEFAULT_REFLET_ASM): $(dir $(DEFAULT_REFLET_ASM))/src/*
	cd $(dir $@) && \
		$(MAKE) $(notdir $@)

ROM_MAKER := ../submodules/ROM_maker/ROM_maker.lua

clean :
	rm -f *.bin
	rm -f *rom.v

basicInt.bin : basicInt.asm $(REFLET_ASM)
	$(REFLET_ASM) -word-size 8 -no-stack-init -ignore-start basicInt.asm -o basicInt.bin

clock.bin : clock.asm libs/ctrl16addrMap.asm $(REFLET_ASM)
	$(REFLET_ASM) -word-size 16 -no-stack-init clock.asm -o clock.bin # Note: there is the argument `no-stack-init` as the stack pointer is initialized in the program

bootloader16.bin : bootloader16.asm $(REFLET_ASM) # 4 sec timeout
	$(REFLET_ASM) -word-size 16 -no-prefix -no-stack-init -ignore-start -start-addr 32000 -ignore-compatibility-runtime $< -D TIMEOUT_CS=400 -o $@ #start addr set to 0x7D00

bootloader16_swift.bin : bootloader16.asm $(REFLET_ASM) # 50 ms timeout
	$(REFLET_ASM) -word-size 16 -no-prefix -no-stack-init -ignore-start -start-addr 32000 -ignore-compatibility-runtime $< -D TIMEOUT_CS=5 -o $@

reflet_bootloader16_rom.v : bootloader16.bin
	$(ROM_MAKER) -name reflet_bootloader16_rom -input_file $< -output_file $@ -wordsize 2 -start_addr 16000 -min_addr_size 14

reflet_bootloader16_swift_rom.v : bootloader16_swift.bin
	$(ROM_maker) -name reflet_bootloader16_swift_rom -input_file $< -output_file $@ -wordsize 2 -start_addr 16000 -min_addr_size 14

../controller/reflet_bootloader16_rom.v : reflet_bootloader16_rom.v reflet_bootloader16_swift_rom.v
	cat $^ > $@

helloWorld.bin : helloWorld.asm libs/ctrl16addrMap.asm libs/uart.asm libs/printing.asm libs/math.asm libs/string.asm $(REFLET_ASM)
	$(REFLET_ASM) helloWorld.asm -o helloWorld.bin -word-size 16 -set-stack-to 32768 #Note: stack starts at 0x8000

../simu/rom01.v : simuGPIO.bin
	$(ROM_MAKER) -name rom01 -input_file $< -output_file $@ -wordsize 1 -min_addr_size 6

../simu/rom02.v : helloWorld.bin
	$(ROM_MAKER) -name rom02 -input_file $< -output_file $@ -wordsize 2 -min_addr_size 14

../simu/rom03.v : basicInt.bin
	$(ROM_MAKER) -name rom03 -input_file $< -output_file $@ -wordsize 1 -min_addr_size 7

../simu/rom04.v : uartLoopBack.bin
	$(ROM_MAKER) -name rom04 -input_file $< -output_file $@ -wordsize 1 -min_addr_size 8

#../simu/rom05.v : clock.bin
	#$(ROM_MAKER) -name rom05 -input_file $< -output_file $@ -wordsize 2 -min_addr_size 14

../simu/rom06.v : low_power_mode.bin
	$(ROM_MAKER) -name rom06 -input_file $< -output_file $@ -wordsize 2 -min_addr_size 14

../simu/rom07.v : uartLoopBack_16bits.bin
	$(ROM_MAKER) -name rom07 -input_file $< -output_file $@ -wordsize 2 -min_addr_size 14

../simu/rom08.v : keyboard_synth.bin
	$(ROM_MAKER) -name rom08 -input_file $< -output_file $@ -wordsize 2 -min_addr_size 14

../simu/simu09_tb.vh : test_instructions.bin
	printf '`define test_instruction_bin_size %i\n' $$(wc --bytes < $<) > $@
	printf "\`define test_instruction_bin %i'h%s\n" $$(echo $$(wc --bytes < $<) 8 '*' n | dc) $$(xxd -p -c1 < $< | tac | tr -d '\n') >> $@

../simu/rom10.v : vga_test.bin
	$(ROM_MAKER) -name rom10 -input_file $< -output_file $@ -wordsize 2 -min_addr_size 14

simuGPIO.bin : simuGPIO.asm $(REFLET_ASM)
	$(REFLET_ASM) simuGPIO.asm -o simuGPIO.bin -no-stack-init -word-size 8 -ignore-start -ignore-compatibility-runtime

uartLoopBack.bin : uartLoopBack.asm $(REFLET_ASM)
	$(REFLET_ASM) -word-size 8 -no-stack-init uartLoopBack.asm -o uartLoopBack.bin

primes.bin : primes.asm libs/ctrl16addrMap.asm libs/uart.asm libs/printing.asm libs/math.asm libs/string.asm $(REFLET_ASM)
	$(REFLET_ASM) primes.asm -word-size 16 -o primes.bin

low_power_mode.bin : low_power_mode.asm libs/ctrl16addrMap.asm $(REFLET_ASM)
	$(REFLET_ASM) low_power_mode.asm -word-size 16 -o low_power_mode.bin

uartLoopBack_16bits.bin : uartLoopBack_16bits.asm libs/ctrl16addrMap.asm libs/uart.asm $(REFLET_ASM)
	$(REFLET_ASM) uartLoopBack_16bits.asm -word-size 16 -set-stack-to 32768 -o uartLoopBack_16bits.bin

keyboard_synth.bin : keyboard_synth.asm libs/ctrl16addrMap.asm libs/uart.asm libs/synth.asm $(REFLET_ASM)
	$(REFLET_ASM) $< -o $@ -word-size 16 -set-stack-to 32768

test_instructions.bin : test_instructions.asm $(REFLET_ASM)
	$(REFLET_ASM) test_instructions.asm -o test_instructions.bin -word-size 16 -no-stack-init

vga_test.bin : vga_test.asm libs/ctrl16addrMap.asm libs/math.asm libs/VGA/base_vga.asm libs/string.asm $(REFLET_ASM)
	$(REFLET_ASM) $< -o $@ -word-size 16 -set-stack-to 32768

vga_hello_world.bin : vga_hello_world.asm libs/ctrl16addrMap.asm libs/math.asm libs/VGA/base_vga.asm libs/string.asm $(REFLET_ASM)
	$(REFLET_ASM) $< -o $@ -word-size 16 -set-stack-to 32768

