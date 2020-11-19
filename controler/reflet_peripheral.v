/*---------------------------------------\
|This module combines all the peripherals|
|made for a reflet processor in order to |
|use them in a microcontroler.           |
\---------------------------------------*/

//memory map
//number of registers in each peripherals
`define hwi_size   4
`define exti_size  3
`define gpio_size  8
`define timer_size 3
`define timer2size 3
`define uart_size  4
`define pwm_size   2
`define seg_size   3
//assigning addresses
`define hwi_off   0
`define exti_off  (`hwi_off   + `hwi_size)
`define gpio_off  (`exti_off  + `exti_size)
`define timer_off (`gpio_off  + `gpio_size)
`define timer2off (`timer_off + `timer_size)
`define uart_off  (`timer2off + `timer2size)
`define pwm_off   (`uart_off  + `uart_size)
`define seg_off   (`pwm_off   + `pwm_size)
//sizes
`define total_size (`hwi_size + `exti_size + `gpio_size + `timer_size + `uart_size + `pwm_size + `seg_size + `timer2size)
`define offset_size ($clog2(`total_size))

module reflet_peripheral #(
    parameter wordsize = 16,
    base_addr_size = 16,
    base_addr = 16'hFF00,
    clk_freq = 1000000,
    enable_exti = 1,
    enable_gpio = 1,
    enable_timer = 1,
    enable_timer2 = 1,
    enable_uart = 1,
    enable_pwm = 1,
    enable_segments = 1
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
    //GPIO
    input [15:0] gpi,
    output [15:0] gpo,
    //UART
    input rx,
    output tx,
    //PWM
    output pwm,
    //Seven segments
    output [6:0] segments,
    output [3:0] seg_select,
    output seg_dot,
    output seg_colon
    );

    //data_out
    wire [7:0] dout_hwi;
    wire [7:0] dout_exti;
    wire [7:0] dout_gpio;
    wire [7:0] dout_timer;
    wire [7:0] dout_timer2;
    wire [7:0] dout_uart;
    wire [7:0] dout_pwm;
    wire [7:0] dout_segments;
    assign data_out = dout_hwi | dout_exti | dout_gpio | dout_timer | dout_uart | dout_pwm | dout_segments;

    //interrupts signals
    wire int_gpio, int_timer, int_uart, int_timer2;
    //access control
    wire using_peripherals = enable && addr >= base_addr && addr < base_addr + `total_size;
    wire [`offset_size-1:0] offset = addr - base_addr;

    //peripherals
    reflet_hardware_info #(
        .wordsize(wordsize),
        .base_addr_size(`offset_size), 
        .base_addr(`hwi_off), 
        .clk_freq(clk_freq),
        .enable_exti(enable_exti),
        .enable_gpio(enable_gpio),
        .enable_timer(enable_timer),
        .enable_timer2(enable_timer2),
        .enable_uart(enable_uart),
        .enable_pwm(enable_pwm),
        .enable_segments(enable_segments))
    hwi (
        .enable(using_peripherals),
        .addr(offset),
        .data_out(dout_hwi)); 
    
    if(enable_exti)
        reflet_exti #(.base_addr_size(`offset_size), .base_addr(`exti_off)) exti (
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
            .timer_int_in(int_timer),
            .timer_2_int_in(int_timer2));
    else
    begin
        assign dout_exti = 0;
        assign ext_int = 0;
    end

    if(enable_gpio)
        reflet_gpio #(.base_addr_size(`offset_size), .base_addr(`gpio_off)) gpio (
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
        reflet_timer #(.base_addr_size(`offset_size), .base_addr(`timer_off)) timer (
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

    if(enable_timer2)
        reflet_timer_2 #(.base_addr_size(`offset_size), .base_addr(`timer2off)) timer2 (
            .clk(clk),
            .reset(reset),
            .enable(using_peripherals),
            .interrupt(int_timer2),
            .addr(offset),
            .data_in(data_in),
            .data_out(dout_timer2),
            .write_en(write_en),
            .timer_input(int_timer));
    else
    begin
        assign dout_timer2 = 0;
        assign int_timer2 = 0;
    end

    if(enable_uart)
        reflet_uart #(.base_addr_size(`offset_size), .base_addr(`uart_off), .clk_freq(clk_freq)) uart (
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

    if(enable_pwm)
        reflet_pwm #(.base_addr_size(`offset_size), .base_addr(`pwm_off)) pwm (
            .clk(clk),
            .reset(reset),
            .enable(using_peripherals),
            .addr(offset),
            .data_in(data_in),
            .data_out(dout_pwm),
            .write_en(write_en),
            .out(pwm));
    else
    begin
        assign dout_pwm = 0;
        assign pwm = 0;
    end

    if(enable_segments)
        reflet_seven_segments #(.base_addr_size(`offset_size), .base_addr(`seg_off)) seg7 (
            .clk(clk),
            .reset(reset),
            .enable(using_peripherals),
            .addr(offset),
            .data_in(data_in),
            .data_out(dout_segments),
            .write_en(write_en),
            .segments(segments),
            .selection(seg_select),
            .dot(seg_dot),
            .colon(seg_colon));
    else
    begin
        assign segments = 0;
        assign seg_select = 0;
        assign seg_dot = 0;
        assign seg_colon = 0;
    end

endmodule

