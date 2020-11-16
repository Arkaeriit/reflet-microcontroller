/*-----------------------------------\
|This module combines a small ammount|
|of asrm peripheral in order to use  |
|them in a 8-bit micro-controler.    |
\-----------------------------------*/

module reflet_peripheral_minimal #(
    parameter wordsize = 8,
    base_addr_size = 8,
    base_addr = 8'hEE,
    clk_freq = 1000000,
    enable_exti = 1,
    enable_gpio = 1,
    enable_timer = 1,
    enable_uart = 1
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
    output tx
    );

    //data_out
    wire [7:0] dout_exti;
    wire [7:0] dout_gpio;
    wire [7:0] dout_timer;
    wire [7:0] dout_uart;
    assign data_out = dout_exti | dout_gpio | dout_timer | dout_uart;

    //interrupts signals
    wire int_gpio, int_timer, int_uart;

    //access control
    wire using_peripherals = enable && addr >= base_addr && addr < base_addr + 18;
    wire [4:0] offset = addr - base_addr;

    if(enable_exti)
        reflet_exti #(.wordsize(wordsize), .base_addr_size(5), .base_addr(0)) exti (
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
        reflet_gpio #(.wordsize(wordsize), .base_addr_size(5), .base_addr(3)) gpio (
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
        reflet_timer #(.wordsize(wordsize), .base_addr_size(5), .base_addr(11)) timer (
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
        reflet_uart #(.wordsize(wordsize), .base_addr_size(5), .base_addr(14), .clk_freq(clk_freq)) uart (
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

endmodule

