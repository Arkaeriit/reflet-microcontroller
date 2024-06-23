/*------------------------------------------\
|This test bench tests the effect of loading|
|test_instructions.asm and running it.      |
\------------------------------------------*/

`include "simu09_tb.vh"

module simu09_tb ();

    reg clk = 0;
    always #1 clk <= !clk;
    reg reset_uart = 0;

    wire rx, quit, debug, debug_tx;

    reflet_16bit_controller #(
        .clk_freq(1000000),
        .debug_output(1),
        .swift_bootloader(1),
        .data_size('h2000),
        .inst_size(8192),
        .enable_interrupt_mux(1),
        .enable_gpio(0),
        .enable_timer(1),
        .enable_timer2(1),
        .enable_uart(1),
        .enable_pwm(0),
        .enable_segments(0),
        .enable_synth(0),
        .enable_ext_io(0),
        .enable_vga(0),
        .enable_power_manager(0))
    ctrl (
        .clk(clk),
        .reset(1'h1),
        .reset_limited(1'h1),
        .rx(rx),
        .debug(debug),
        .debug_tx(debug_tx),
        .gpi(16'h0),
        .quit(quit));

    uart_sending_msg #(.clk_freq(1000000), .msg_size_byte(`test_instruction_bin_size)) prg (
        .clk(clk),
        .reset(reset_uart),
        .msg(`test_instruction_bin),
        .rx(1'b1),
        .tx(rx));

    integer i;
    initial
    begin
        $dumpfile("simu09_tb.vcd");
        $dumpvars(0, simu09_tb);
        for(i = 0; i<16; i=i+1)
        begin
            $dumpvars(0, ctrl.cpu.registers[i]);
            $dumpvars(0, ctrl.mem_inst.ram.memory_ram[i]);
            $dumpvars(0, ctrl.mem_data.memory_ram[i]);
        end
        for(i = 16; i<20; i=i+1)
            $dumpvars(0, ctrl.mem_data.memory_ram[i]);
        #5000;
        reset_uart <= 1;
        #3000000;
        $finish;
    end

endmodule    
    

