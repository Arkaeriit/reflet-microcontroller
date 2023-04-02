// This is a test of the keyboard_synth.asm program

module simu08_tb ();

    reg clk = 0;
    always #1 clk <= !clk;
    reg reset_cpu = 0;
    reg reset_uart = 0;
    wire rx, tx, synth_out;

    simu8_mcu #(.clk_freq(2_000_000)) mcu (
        .clk(clk),
        .reset_in(reset_cpu),
        .synth_out(synth_out),
        .rx(rx),
        .tx(tx));
    
    uart_sending #(.clk_freq(2_000_000), .baud_rate(9600), .wait_time(100000)) uart_s (
        .clk(clk),
        .reset(reset_uart),
        .rx(tx),
        .tx(rx));

    integer i;
    initial
    begin
        $dumpfile("simu08_tb.vcd");
        $dumpvars(0, simu08_tb);
        //for(i = 0; i<16; i=i+1)
            //$dumpvars(0, mcu.cpu.registers[i]);
        #20;
        reset_cpu <= 1;
        #8000;
        reset_uart <= 1;
        #8000000;
        $finish;
    end

endmodule


module simu8_mcu #(
    parameter clk_freq = 1000000
    )(
    input clk,
    input reset_in,
    output synth_out,
    input rx,
    output tx
    );

    //reset control
    wire reset, blink;
    reflet_blink reset_bootstrap(.clk(clk), .out(blink));
    assign reset = reset_in & !blink;

    //system bus and interrupt request
    wire [15:0] addr;
    wire [15:0] data_out_cpu;
    wire [15:0] data_in_cpu;
    wire write_en;
    wire [3:0] interrupt_request;
    wire cpu_enable;

    //cpu
    reflet_cpu #(.wordsize(16)) cpu (
        .clk(clk),
        .reset(reset),
        .enable(cpu_enable),
        .data_in(data_in_cpu),
        .data_out(data_out_cpu),
        .addr(addr),
        .write_en(write_en),
        .quit(quit),
        .debug(debug),
        .interrupt_request(interrupt_request));

    //memory map
    wire [15:0] dout_inst;
    wire [15:0] dout_data;
    wire [7:0] dout_periph;
    wire [7:0] din_periph = (addr[0] ? data_out_cpu[15:8] : data_out_cpu[7:0]);
    wire [15:0] dout_periph_shift = (addr[0] ? {dout_periph, 8'h0} : {8'h0, dout_periph});
    assign data_in_cpu = dout_inst | dout_data | dout_periph_shift;
    //0x00 to 0x7FFF: instruction.
    rom08 rom (
        .clk(clk),
        .enable(!addr[15]),
        .addr(addr[14:1]),
        .data(dout_inst));

    //0x8000 to 0xFEFF: data. Should stay as a regular RAM
    reflet_ram #(.addrSize(14), .dataSize(16), .size(100)) mem_data (
        .clk(clk),
        .reset(reset),
        .enable(addr[15]),
        .addr(addr[14:1]),
        .data_in(data_out_cpu),
        .data_out(dout_data),
        .write_en(write_en));

    //0xFF00 to 0xFFFF: peripherals
    reflet_peripheral #(
        .wordsize(16), 
        .base_addr_size(15), 
        .base_addr(15'h7F00), 
        .clk_freq(clk_freq),
        .enable_interrupt_mux(0),
        .enable_gpio(1),
        .enable_timer(0),
        .enable_timer2(0),
        .enable_uart(1),
        .enable_pwm(0),
        .enable_synth(1),
        .enable_segments(0),
        .enable_synth(0),
        .enable_ext_io(0),
        .enable_vga(0),
        .enable_power_manager(0)) 
    periph (
        .clk(clk),
        .reset(reset),
        .enable(addr[15]),
        .interrupt_request(interrupt_request),
        .cpu_enable(cpu_enable),
        .addr(addr[14:0]),
        .data_in(din_periph),
        .data_out(dout_periph),
        .write_en(write_en),
        .gpi(16'h1),
        .synth_out(synth_out),
        .tx(tx),
        .rx(rx));

endmodule

