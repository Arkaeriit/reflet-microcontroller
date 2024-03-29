/*---------------------------------------------------------\
|This module is ment to multiplex the interrupt signals    |
|comming from all the peripherals into the 4 interrupt     |
|lines of the CPU. It can also be used to enable or disable|
|the various interruptions.                                |
\---------------------------------------------------------*/

module reflet_interrupt_mux #(
    parameter base_addr_size = 16,
    base_addr = 16'hFF04
    )(
    input clk,
    input reset,
    input enable,
    //system bus
    input [base_addr_size-1:0] addr,
    input write_en,
    input [7:0] data_in,
    output [7:0] data_out,
    //interrupts to the CPU
    output [3:0] cpu_int,
    //interrupts from the peripherals
    input gpio_int_in,
    input uart_int_in,
    input timer_int_in,
    input timer_2_int_in
    );

    wire using_interrupt_mux = enable && addr >= base_addr && addr < base_addr + 4;
    wire [1:0] offset = addr - base_addr;

    //Controling interrupts
    wire gpio_int, uart_int, timer_int, timer_2_int;
    wire gpio_int_en;
    wire [1:0] gpio_int_level;
    wire [3:0] gpio_int_interrupt_mux;
    reflet_int_mapper gpio_mapper(.enable(gpio_int_en & gpio_int), .level(gpio_int_level), .out(gpio_int_interrupt_mux));
    wire uart_int_en;
    wire [1:0] uart_int_level;
    wire [3:0] uart_int_interrupt_mux;
    reflet_int_mapper uart_mapper(.enable(uart_int_en & uart_int), .level(uart_int_level), .out(uart_int_interrupt_mux));
    wire timer_int_en;
    wire [1:0] timer_int_level;
    wire [3:0] timer_int_interrupt_mux;
    reflet_int_mapper timer_mapper(.enable(timer_int_en & timer_int), .level(timer_int_level), .out(timer_int_interrupt_mux));
    wire [1:0] timer_2_int_level;
    wire [3:0] timer_2_int_interrupt_mux;
    wire timer_2_int_en;
    reflet_int_mapper timer_2_mapper(.enable(timer_2_int_en & timer_2_int), .level(timer_2_int_level), .out(timer_2_int_interrupt_mux));
    assign cpu_int = gpio_int_interrupt_mux | uart_int_interrupt_mux | timer_int_interrupt_mux | timer_2_int_interrupt_mux;

    //gestion of status register
    wire [7:0] int_list = {4'h0, timer_2_int_in & timer_2_int_en, timer_int_in & timer_int_en, uart_int_in & uart_int_en, gpio_int_in & gpio_int_en};
    wire int_updating = |int_list;
    wire [7:0] status_register;
    assign gpio_int = status_register[0];
    assign uart_int = status_register[1];
    assign timer_int = status_register[2];
    assign timer_2_int = status_register[3];
     
    //registers
    //the first register is the enable register. bit 0 enable the gpio
    //interrup and bit 1 enable the uart interrupt
    //the second register is used to control the interrupt numbers of
    //the gpio and uart interrupts. Bits 0 and 1 are used to controll
    //the number of the GPIO; 2 and 3 the number of the UART interrupt
    //for timer: bit 2 of en and 4 and 5 of level
    wire [7:0] dout_enable;
    wire [7:0] dout_level;
    wire [7:0] dout_reserved;
    wire [7:0] dout_status;
    wire [7:0] int_en;
    wire [7:0] int_level;
    assign data_out = dout_enable | dout_status | dout_reserved | dout_level;
    reflet_rw_register #(.addr_size(2), .reg_addr(0), .default_value(0)) reg_en(
        .clk(clk),
        .reset(reset),
        .enable(using_interrupt_mux),
        .addr(offset),
        .write_en(write_en),
        .data_in(data_in[7:0]),
        .data_out(dout_enable),
        .data(int_en));
    reflet_rw_register #(.addr_size(2), .reg_addr(1), .default_value(0)) reg_level(
        .clk(clk),
        .reset(reset),
        .enable(using_interrupt_mux),
        .addr(offset),
        .write_en(write_en),
        .data_in(data_in[7:0]),
        .data_out(dout_level),
        .data(int_level));
    reflet_ro_register #(.addr_size(2), .reg_addr(2)) reg_reserved (
        .enable(using_interrupt_mux),
        .addr(offset),
        .data_out(dout_reserved),
        .data(8'h0));
    reflet_rwe_register #(.addr_size(2), .reg_addr(3), .default_value(0)) reg_status(
        .clk(clk),
        .reset(reset),
        .enable(using_interrupt_mux),
        .addr(offset),
        .write_en(write_en),
        .data_in(data_in[7:0]),
        .data_out(dout_status),
        .data(status_register),
        .data_override(status_register | int_list),
        .override(int_updating));
    assign gpio_int_en = int_en[0];
    assign gpio_int_level = int_level[1:0];
    assign uart_int_en = int_en[1];
    assign uart_int_level = int_level[3:2];
    assign timer_int_en = int_en[2];
    assign timer_int_level = int_level[5:4];
    assign timer_2_int_en = int_en[3];
    assign timer_2_int_level = int_level[7:6];

endmodule



/*---------------------------------------------\
|This module map an interrupt on interrupt_mux |
|depending on the level of the interrupt.      |
\---------------------------------------------*/

module reflet_int_mapper(
    input enable,
    input [1:0] level,
    output [3:0] out
    );

    wire [3:0] map = ( level == 0 ? 4'b0001 :
                ( level == 1 ? 4'b0010 :
                 ( level == 2 ? 4'b0100 :
                  4'b1000 )));
    assign out = ( enable ? map : 4'b0000 );

endmodule

