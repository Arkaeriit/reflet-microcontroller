/*-----------------------------------\
|This module combines a small ammount|
|of asrm peripheral in order to use  |
|them in a 8-bit micro-controler.    |
\-----------------------------------*/

module reflet_peripheral_minimal #(
    parameter wordsize = 8,
    base_addr_size = 8,
    base_addr = 8'hEE
    )(
    input clk,
    input reset,
    input enable,
    output [3:0] exti,
    //system bus
    input [wordsize-1:0] addr,
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
    wire [7:9] dout_timer;
    wire [7:0] dout_uart;
    assign data_out = dout_exti | dout_gpio | dout_timer | dout_uart;

    //interrupts signals
    wire int_gpio, int_timer, int_uart;

    //access control
    wire using_peripherals = enable && addr >= base_addr && addr < base_addr + 17;
    wire [4:0] offset = addr - base_addr;

    reflet_exti #(.wordsize(wordsize), .base_addr_size(5), .base_addr(0) exti (
        .clk(clk),
        .reset(reset),
        .enable(using_peripherals),
        .addr(addr),
        .data_in(data_in),
        .data_out(dout_exti),
        .write_en(write_en),
        .cpu_int(exti),
        .gpio_int_in(int_gpio),
        .uart_int_in(int_uart),
        .timer_int_in(int_timer));

    reflet_gpio #(.wordsize(wordsize), .base_addr_size(5), .base_addr(3) gpio (
        .clk(clk),
        .reset(reset),
        .enable(using_peripherals),
        .interrupt(int_gpio),
        .addr(addr),
        .data_in(data_in),
        .data_out(dout_gpio),
        .write_en(write_en),
        .gpi(gpi),
        .gpo(gpo));
    
    reflet_timer #(.wordsize(wordsize), .base_addr_size(5), .base_addr(11) timer (
        .clk(clk),
        .reset(reset),
        .enable(using_peripherals),
        .interrupt(int_timer),
        .addr(addr),
        .data_in(data_in),
        .data_out(dout_timer),
        .write_en(write_en));

    reflet_uart #(.wordsize(wordsize), .base_addr_size(5), .base_addr(14) uart (
        .clk(clk),
        .reset(reset),
        .enable(using_peripherals),
        .interrupt(int_uart),
        .addr(addr),
        .data_in(data_in),
        .data_out(dout_uart),
        .write_en(write_en)
        .rx(rx),
        .tx(tx));

endmodule

