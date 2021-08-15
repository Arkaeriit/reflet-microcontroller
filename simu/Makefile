# This makefile is used to use the various tesbenches vith icarus verilog
# And then show graphs with gtkwave

CPU := ../cpu/reflet_addr.v ../cpu/reflet_alignement_fixer.v ../cpu/reflet_alu.v ../cpu/reflet_cpu.v ../cpu/reflet_interrupt.v ../cpu/reflet_stack.v
CTRL := ../controller/reflet_16bit_controller.v ../controller/reflet_8bit_controller.v ../controller/reflet_blink.v ../controller/reflet_bootloader16_rom.v ../controller/reflet_inst16.v ../controller/reflet_peripheral_minimal.v ../controller/reflet_peripheral.v ../controller/reflet_ram.v
SIM_TOOLS := rom1.v rom2.v rom3.v rom4.v rom5.v rom6.v ./reflet_8bit_ctrl_with_rom.v ./clock_cpu.v
REGISTERS := ../peripherals/reflet_ro_register.v ../peripherals/reflet_rwe_register.v ../peripherals/reflet_rw_register.v
PERIPH := ../peripherals/reflet_counter.v ../peripherals/reflet_exti.v ../peripherals/reflet_gpio.v ../peripherals/reflet_hardware_info.v ../peripherals/reflet_pwm.v ../peripherals/reflet_seven_segment.v ../peripherals/reflet_synth.v ../peripherals/reflet_timer_2.v ../peripherals/reflet_timer.v ../peripherals/reflet_uart.v ../peripherals/reflet_basics.v ../peripherals/reflet_power_manager.v ../peripherals/reflet_extened_io.v  $(REGISTERS) 
REFLET := $(CPU) $(CTRL) $(PERIPH)
HEADERS := ./reflet.vh
TEST_BENCHES := pwm_tb reflet_8bit_ctrl_tb reflet_gpio_tb simu1_tb simu2_tb simu3_tb simu5_tb synth_tb uart_tb simu6_tb timer_tb ext_gpio_tb reflet_16bit_ctrl_tb


all : pwm_tb.vcd reflet_8bit_ctrl_tb.vcd reflet_gpio_tb.vcd simu1_tb.vcd simu2_tb.vcd simu3_tb.vcd simu5_tb.vcd synth_tb.vcd uart_tb.vcd simu6_tb.vcd timer_tb.vcd ext_gpio_tb.vcd # reflet_16bit_ctrl_tb.vcd # reflet_16bit_ctrl_tb.vcd can be left out in order not to wait for the very long simulation

define test_bench_template
$(1).vvp: $$(REFLET) $$(SIM_TOOLS) $$(HEADERS) $(1).v
	@echo "[IVERILOG] $(1).v"
	@iverilog $$(REFLET) $$(SIM_TOOLS) $(1).v -o $(1).vvp

$(1).vcd: $(1).vvp
	@echo "[VDC]      $(1).vvp"
	@vvp $$<

.PHONY: $(1).vcd
$(1): $(1).vcd
	@echo "[GTKWAVE]  $(1).vcd"
	@gtkwave $$<

ALL_VCD += $(1).vcd

.PHONY: $(1)_clean
$(1)_clean:
	rm -f $(1).vcd
	rm -f $(1).vvp

ALL_CLEAN += $(1)_clean

endef

$(foreach tb, $(TEST_BENCHES), $(eval $(call test_bench_template, $(tb))))

clean : $(ALL_CLEAN)

