/*---------------------------------------------------------\
|This module is ment to multiplex the interrupt signals    |
|comming from all the peripherals into the 4 interrupt     |
|lines of the CPU. It can also be used to enable or disable|
|the various interruptions.                                |
\---------------------------------------------------------*/

module asrm_exti #(
    parameter wordsize = 16,
    base_addr_size = 16,
    base_addr = 16'hFF0C,
    number_of_periph = 2
    )(
    input clk,
    input reset,
    input enable,
    //system bus
    input [base_addr_size-1:0] addr,
    input write_en,
    input [wordsize-1:0] data_in,
    input [wordsize-1:0] data_out,
    //interrupts to the CPU
    output [3:0] cpu_int,
    //interrupts from the peripherals
    input gpio_int_out,
    input uart_int_out
    );

    wire using_exti = enable && addr >= base_addr && addr < base_addr + 2;
    wire offset = addr - base_addr;

    //Controling interrupts
    wire gpio_int, uart_int;
    wire gpio_int_en;
    wire [1:0] gpio_int_level;
    wire [3:0] gpio_int_exti;
    asrm_int_mapper gpio_mapper(.enable(gpio_int_en & gpio_int), .level(gpio_int_level), .out(gpio_int_exti));
    wire uart_int_en;
    wire [1:0] uart_int_level;
    wire [3:0] uart_int_exti;
    asrm_int_mapper uart_mapper(.enable(uart_int_en & uart_int), .level(uart_int_level), .out(uart_int_exti));

    //gestion of status register
    wire [7:0] int_list = {6'h0, uart_int, gpio_int}
    reg [7:0] previous_int;
    wire int_update = int_list & !previous_int;

     
    //registers
    //the first register is the enable register. bit 0 enable the gpio
    //interrup and bit 1 enable the uart interrupt
    //the second register is used to control the interrupt numbers of
    //the gpio and uart interrupts. Bits 0 and 1 are used to controll
    //the number of the GPIO; 2 and 3 the number of the UART interrupt
    wire [7:0] dout_enable;
    wire [7:0] dout_level;
    wire [7:0] int_en;
    wire [7:0] int_level;
    asrm_rw_register #(.addr_size(1), .reg_addr(0), .default_value(0)) reg_en(
        .clk(clk),
        .reset(reset),
        .enable(using_exti),
        .addr(offset),
        .write_en(write_en),
        .data_in(data_in[7:0]),
        .data_out(dout_enable),
        .data(int_en));
    asrm_rw_register #(.addr_size(1), .reg_addr(0), .default_value(0)) reg_level(
        .clk(clk),
        .reset(reset),
        .enable(using_exti),
        .addr(offset),
        .write_en(write_en),
        .data_in(data_in[7:0]),
        .data_out(dout_level),
        .data(int_level));
    assign gpio_int_en = int_en[0];
    assign gpio_int_level = int_level[1:0];
    assign uart_int_en = int_en[1];
    assign uart_int_level = int_level[3:2];



endmodule



/*---------------------------------------------\
|This module map an interrupt on exti depending|
|on the level of the interrupt.                |
\---------------------------------------------*/

module asrm_int_mapper(
    input enable,
    input [1:0] level,
    output [3:0] out
    );

    wire map = ( level == 0 ? 4'b0001 :
                ( level == 1 ? 4'b0010 :
                 ( level == 2 ? 4'b0100 :
                  4'b1000 )));
    assign out = ( enable : map ? 4'b0000 );

endmodule

