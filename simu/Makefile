# This makefile is used to use the various tesbenches vith icarus verilog
# And then show graphs with gtkwave

CPU = ../cpu/reflet.vh ../cpu/reflet_addr.v ../cpu/reflet_addr_reduced_behavior.v ../cpu/reflet_alu.v ../cpu/reflet_cpu.v ../cpu/reflet_interrupt.v ../cpu/reflet_stack.v
CTRL = ../controller/reflet_16bit_controller.v ../controller/reflet_8bit_controller.v ../controller/reflet_blink.v ../controller/reflet_bootloader16_rom.v ../controller/reflet_inst16.v ../controller/reflet_peripheral_minimal.v ../controller/reflet_peripheral.v ../controller/reflet_ram8.v ../controller/reflet_ram16.v
REGISTERS = ../peripherals/reflet_ro_register.v ../peripherals/reflet_rwe_register.v ../peripherals/reflet_rw_register.v
PERIPH = ../peripherals/reflet_counter.v ../peripherals/reflet_exti.v ../peripherals/reflet_gpio.v ../peripherals/reflet_hardware_info.v ../peripherals/reflet_pwm.v ../peripherals/reflet_seven_segment.v ../peripherals/reflet_synth.v ../peripherals/reflet_timer_2.v ../peripherals/reflet_timer.v ../peripherals/reflet_uart.v ../peripherals/reflet_basics.v ../peripherals/reflet_power_manager.v $(REGISTERS)
REFLET = $(CPU) $(CTRL) $(PERIPH)

all : pwm_tb.vcd reflet_16bit_ctrl_tb.vcd reflet_8bit_ctrl_tb.vcd reflet_gpio_tb.vcd simu1_tb.vcd simu2_tb.vcd simu3_tb.vcd simu5_tb.vcd simu_boot.vcd synth_tb.vcd uart_tb.vcd simu6_tb.vcd

pwm_tb.vvp : pwm_tb.v ../peripherals/reflet_pwm.v ../peripherals/reflet_counter.v $(REGISTERS)
	iverilog pwm_tb.v ../peripherals/reflet_pwm.v ../peripherals/reflet_counter.v $(REGISTERS) -o pwm_tb.vvp

reflet_gpio_tb.vvp : reflet_gpio_tb.v $(PERIPH)
	iverilog reflet_gpio_tb.v $(PERIPH) -o reflet_gpio_tb.vvp

seven_seg_tb.vvp : seven_seg_tb.v $(PERIPH) ../controller/reflet_blink.v
	iverilog seven_seg_tb.v $(PERIPH) ../controller/reflet_blink.v -o seven_seg_tb.vvp

synth_tb.vvp : synth_tb.v $(PERIPH)
	iverilog synth_tb.v $(PERIPH) -o synth_tb.vvp

timer_tb.vvp : timer_tb.v $(PERIPH)
	iverilog timer_tb.v $(PERIPH) -o timer_tb.vvp

uart_tb.vvp : uart_tb.v $(PERIPH)
	iverilog $(PERIPH) uart_tb.v -o uart_tb.vvp

reflet_16bit_ctrl_tb.vvp : $(REFLET) reflet_16bit_ctrl_tb.v
	cp ../cpu/reflet.vh ./
	iverilog reflet_16bit_ctrl_tb.v $(REFLET) -o reflet_16bit_ctrl_tb.vvp
	rm ./reflet.vh

reflet_8bit_ctrl_tb.vvp : $(REFLET) reflet_8bit_ctrl_tb.v reflet_8bit_ctrl_with_rom.v rom4.v
	cp ../cpu/reflet.vh ./
	iverilog reflet_8bit_ctrl_tb.v reflet_8bit_ctrl_with_rom.v rom4.v $(REFLET) -o reflet_8bit_ctrl_tb.vvp
	rm ./reflet.vh

simu1_tb.vvp : $(REFLET) simu1_tb.v rom1.v
	cp ../cpu/reflet.vh ./
	iverilog simu1_tb.v rom1.v $(REFLET) -o simu1_tb.vvp
	rm ./reflet.vh

simu2_tb.vvp : $(REFLET) simu2_tb.v rom2.v
	cp ../cpu/reflet.vh ./
	iverilog simu2_tb.v rom2.v $(REFLET) -o simu2_tb.vvp
	rm ./reflet.vh

simu3_tb.vvp : $(REFLET) simu3_tb.v rom3.v
	cp ../cpu/reflet.vh ./
	iverilog simu3_tb.v rom3.v $(REFLET) -o simu3_tb.vvp
	rm ./reflet.vh

simu5_tb.vvp : $(REFLET) simu5_tb.v rom5.v clock_cpu.v
	cp ../cpu/reflet.vh ./
	iverilog simu5_tb.v rom5.v clock_cpu.v $(REFLET) -o simu5_tb.vvp
	rm ./reflet.vh

simu6_tb.vvp : $(REFLET) simu6_tb.v rom6.v
	cp ../cpu/reflet.vh ./
	iverilog simu6_tb.v rom6.v $(REFLET) -o simu6_tb.vvp
	rm ./reflet.vh

pwm_tb.vcd : pwm_tb.vvp
	vvp pwm_tb.vvp

pwm_tb : pwm_tb.vcd
	gtkwave pwm_tb.vcd

reflet_16bit_ctrl_tb.vcd : reflet_16bit_ctrl_tb.vvp
	vvp reflet_16bit_ctrl_tb.vvp

reflet_16bit_ctrl_tb : reflet_16bit_ctrl_tb.vcd
	gtkwave reflet_16bit_ctrl_tb.vcd

reflet_8bit_ctrl_tb.vcd : reflet_8bit_ctrl_tb.vvp
	vvp reflet_8bit_ctrl_tb.vvp

reflet_8bit_ctrl_tb : reflet_8bit_ctrl_tb.vcd
	gtkwave reflet_8bit_ctrl_tb.vcd

reflet_gpio_tb.vcd : reflet_gpio_tb.vvp
	vvp reflet_gpio_tb.vvp

reflet_gpio_tb : reflet_gpio_tb.vcd
	gtkwave reflet_gpio_tb.vcd

simu1_tb.vcd : simu1_tb.vvp
	vvp simu1_tb.vvp

simu1_tb : simu1_tb.vcd
	gtkwave simu1_tb.vcd

simu2_tb.vcd : simu2_tb.vvp
	vvp simu2_tb.vvp

simu2_tb : simu2_tb.vcd
	gtkwave simu2_tb.vcd

simu3_tb.vcd : simu3_tb.vvp
	vvp simu3_tb.vvp

simu3_tb : simu3_tb.vcd
	gtkwave simu3_tb.vcd

simu5_tb.vcd : simu5_tb.vvp
	vvp simu5_tb.vvp

simu5_tb : simu5_tb.vcd
	gtkwave simu5_tb.vcd

synth_tb.vcd : synth_tb.vvp
	vvp synth_tb.vvp

synth_tb : synth_tb.vcd
	gtkwave synth_tb.vcd

timer_tb.vcd : timer_tb.vvp
	vvp timer_tb.vvp

timer_tb : timer_tb.vcd
	gtkwave timer_tb.vcd

uart_tb.vcd : uart_tb.vvp
	vvp uart_tb.vvp

uart_tb : uart_tb.vcd
	gtkwave uart_tb.vcd

simu6_tb.vcd : simu6_tb.vvp
	vvp simu6_tb.vvp

simu6_tb : simu6_tb.vcd
	gtkwave simu6_tb.vcd

clean :
	rm -f *.vvp
	rm -f *.vcd

