/*---------------------------------------\
|This module combines all the peripherals|
|made for a reflet processor in order to |
|use them in a microcontroler.           |
\---------------------------------------*/

module reflet_peripheral #(
    parameter wordsize = 16,
    base_addr_size = 16,
    base_addr = 8'hFF00,
    clk_freq = 1000000,
    enable_exti = 1,
    enable_gpio = 1,
    enable_timer = 1,
    enable_uart = 1,
    enable_pwm = 1
    )(
    input clk,
    input reset,
    input enable,
    output [3:0] ext_int,
    //system bus
    input [base_addr_size-1:0] addr,
    input [wordsize-1:0] data_in,
    output [wordsize-1:0] data_out,
    input write_en,
    //External world connections
    input [15:0] gpi,
    output [15:0] gpo,
    input rx,
    output tx,
    output pwm
    );

    //data_out
    wire [7:0] dout_hwi;
    wire [7:0] dout_exti;
    wire [7:0] dout_gpio;
    wire [7:0] dout_timer;
    wire [7:0] dout_uart;
    wire [7:0] dout_pwm;
    assign data_out = dout_hwi | dout_exti | dout_gpio | dout_timer | dout_uart | dout_pwm;

    //interrupts signals
    wire int_gpio, int_timer, int_uart;

    //memory map
    //number of registers in each peripherals
    integer hwi_size = 4;
    integer exti_size = 3;
    integer gpio_size = 8;
    integer timer_size = 3;
    integer uart_size = 4;
    integer pwm_size = 2;
    integer total_size = hwi_size + exti_size + gpio_size + timer_size + uart_size + pwm_size;
    integer offset_size = $clog2(total_size);
    //assigning addresses
    integer hwi_off = 0;
    integer exti_off = hwi_off + hwi_size;
    integer gpio_off = exti_off + exti_size;
    integer timer_off = gpio_off + gpio_size;
    integer uart_off = timer_off + timer_size;
    integer pwm_off = uart_off + uart_size;

    //access control
    wire using_peripherals = enable && addr >= base_addr && addr < base_addr + total_size;
    wire [offset_size-1:0] offset = addr - base_addr;

    //peripherals
    reflet_hardware_info #(
        .wordsize(wordsize), 
        .base_addr_size(offset_size), 
        .base_addr(hwi_off), 
        .clk_freq(clk_freq),
        .enable_exti(enable_exti),
        .enable_gpio(enable_gpio),
        .enable_timer(enable_timer),
        .enable_uart(enable_uart),
        .enable_pwm(enable_pwm))
    hwi (
        .addr(offset),
        .data_out(dout_hwi)); 
    
    if(enable_exti)
        reflet_exti #(.wordsize(wordsize), .base_addr_size(offset_size), .base_addr(exti_off)) exti (
            .clk(clk),
            .reset(reset),
            .enable(using_peripherals),
            .addr(offset),
            .data_in(data_in),
            .data_out(dout_exti),
            .write_en(write_en),
            .cpu_int(ext_int),
            .gpio_int_in(int_gpio),
            .uart_int_in(int_uart),
            .timer_int_in(int_timer));
    else
    begin
        assign dout_exti = 0;
        assign ext_int = 0;
    end

    if(enable_gpio)
        reflet_gpio #(.wordsize(wordsize), .base_addr_size(offset_size), .base_addr(gpio_off)) gpio (
            .clk(clk),
            .reset(reset),
            .enable(using_peripherals),
            .interrupt(int_gpio),
            .addr(offset),
            .data_in(data_in),
            .data_out(dout_gpio),
            .write_en(write_en),
            .gpi(gpi),
            .gpo(gpo));
    else
    begin
        assign dout_gpio = 0;
        assign int_gpio = 0;
        assign gpo = 0;
    end

        
    if(enable_timer)
        reflet_timer #(.wordsize(wordsize), .base_addr_size(offset_size), .base_addr(timer_off)) timer (
            .clk(clk),
            .reset(reset),
            .enable(using_peripherals),
            .interrupt(int_timer),
            .addr(offset),
            .data_in(data_in),
            .data_out(dout_timer),
            .write_en(write_en));
    else
    begin
        assign dout_timer = 0;
        assign int_timer = 0;
    end

    if(enable_uart)
        reflet_uart #(.wordsize(wordsize), .base_addr_size(offset_size), .base_addr(uart_off), .clk_freq(clk_freq)) uart (
            .clk(clk),
            .reset(reset),
            .enable(using_peripherals),
            .interrupt(int_uart),
            .addr(offset),
            .data_in(data_in),
            .data_out(dout_uart),
            .write_en(write_en),
            .rx(rx),
            .tx(tx));
    else
    begin
        assign dout_uart = 0;
        assign int_uart = 0;
    end

    //pwm todo
    assign dout_pwm = 0;
    assign pwm = 0;

endmodule

