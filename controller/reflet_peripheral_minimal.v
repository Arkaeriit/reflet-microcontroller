/*-----------------------------------\
|This module combines a small ammount|
|of reflet peripheral in order to use|
|them in a 8-bit micro-controller.   |
\-----------------------------------*/

//memory map
//number of registers in each peripherals
`define interrupt_mux_size  4
`define gpio_size  8
`define timer_size 3
`define uart_size  4
//assigning addresses
`define interrupt_mux_off  0
`define gpio_off  (`interrupt_mux_off  + `interrupt_mux_size)
`define timer_off (`gpio_off  + `gpio_size)
`define uart_off  (`timer_off + `timer_size)
//sizes
`define total_size (`interrupt_mux_size + `gpio_size + `timer_size + `uart_size)
`define offset_size ($clog2(`total_size))

module reflet_peripheral_minimal #(
    parameter wordsize = 8,
    base_addr_size = 8,
    base_addr = 8'hEE,
    clk_freq = 1000000,
    enable_interrupt_mux = 1,
    enable_gpio = 1,
    enable_timer = 1,
    enable_uart = 1
    )(
    input clk,
    input reset,
    input enable,
    output [3:0] interrupt_request,
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
    wire [7:0] dout_interrupt_mux;
    wire [7:0] dout_gpio;
    wire [7:0] dout_timer;
    wire [7:0] dout_uart;
    assign data_out = dout_interrupt_mux | dout_gpio | dout_timer | dout_uart;

    //interrupts signals
    wire int_gpio, int_timer, int_uart;

    //access control
    wire using_peripherals = enable && addr >= base_addr && addr < base_addr + `total_size;
    wire [`offset_size-1:0] offset = addr - base_addr;

    generate
        if(enable_interrupt_mux)
            reflet_interrupt_mux #(.base_addr_size(`offset_size), .base_addr(`interrupt_mux_off)) interrupt_mux (
                .clk(clk),
                .reset(reset),
                .enable(using_peripherals),
                .addr(offset),
                .data_in(data_in),
                .data_out(dout_interrupt_mux),
                .write_en(write_en),
                .cpu_int(interrupt_request),
                .gpio_int_in(int_gpio),
                .uart_int_in(int_uart),
                .timer_int_in(int_timer),
                .timer_2_int_in(1'b0));
        else
        begin
            assign dout_interrupt_mux = 0;
            assign interrupt_request = 0;
        end
    endgenerate

    generate
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
    endgenerate

        
    generate
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
    endgenerate

    generate
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
    endgenerate

endmodule

