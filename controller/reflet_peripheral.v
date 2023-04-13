/*---------------------------------------\
|This module combines all the peripherals|
|made for a reflet processor in order to |
|use them in a microcontroller.          |
\---------------------------------------*/

//memory map
//number of registers in each peripherals
`define hwi_size           4
`define interrupt_mux_size 4
`define gpio_size          8
`define timer_size         3
`define timer2size         3
`define uart_size          4
`define pwm_size           2
`define seg_size           3
`define power_size         2
`define synth_size         1
`define extio_size         2
`define vga_size           3
//assigning addresses
`define hwi_off   0
`define interrupt_mux_off (`hwi_off   + `hwi_size)
`define gpio_off          (`interrupt_mux_off  + `interrupt_mux_size)
`define timer_off         (`gpio_off  + `gpio_size)
`define timer2off         (`timer_off + `timer_size)
`define uart_off          (`timer2off + `timer2size)
`define pwm_off           (`uart_off  + `uart_size)
`define seg_off           (`pwm_off   + `pwm_size)
`define power_off         (`seg_off   + `seg_size)
`define synth_off         (`power_off + `power_size)
`define extio_off         (`synth_off + `synth_size)
`define vga_off           (`extio_off + `extio_size)
//sizes
`define total_size (`hwi_size + `interrupt_mux_size + `gpio_size + `timer_size + `uart_size + `pwm_size + `seg_size + `timer2size + `power_size + `synth_size + `extio_size + `vga_size)
`define offset_size ($clog2(`total_size))

module reflet_peripheral #(
    parameter wordsize = 16,
    base_addr_size = 16,
    base_addr = 16'hFF00,
    clk_freq = 1000000,
    mem_resetable = 0,
    enable_interrupt_mux = 1,
    enable_gpio = 1,
    enable_timer = 1,
    enable_timer2 = 1,
    enable_uart = 1,
    enable_pwm = 1,
    enable_segments = 1,
    enable_power_manager = 1,
    enable_synth = 1,
    enable_ext_io = 1,
    enable_vga = 1,
    ext_io_size = 128
    )(
    input clk,
    input reset,
    input enable,
    output [3:0] interrupt_request,
    output cpu_enable,
    //system bus
    input [base_addr_size-1:0] addr,
    input [7:0] data_in,
    output [7:0] data_out,
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
    output seg_colon,
    //Synth
    output synth_out,
    //extended IO
    input [ext_io_size-1:0] ext_io_in,
    output [ext_io_size-1:0] ext_io_out,
    //VGA output
    output h_sync,
    output v_sync,
    output [1:0] R_out,
    output [1:0] G_out,
    output [1:0] B_out
    );

    //data_out
    wire [7:0] dout_hwi;
    wire [7:0] dout_interrupt_mux;
    wire [7:0] dout_gpio;
    wire [7:0] dout_timer;
    wire [7:0] dout_timer2;
    wire [7:0] dout_uart;
    wire [7:0] dout_pwm;
    wire [7:0] dout_segments;
    wire [7:0] dout_power;
    wire [7:0] dout_synth;
    wire [7:0] dout_extio;
    wire [7:0] dout_vga;
    assign data_out = dout_hwi | dout_interrupt_mux | dout_gpio | dout_timer | dout_timer2 | dout_uart | dout_pwm | dout_segments | dout_power | dout_synth | dout_extio | dout_vga;

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
        .enable_interrupt_mux(enable_interrupt_mux),
        .enable_gpio(enable_gpio),
        .enable_timer(enable_timer),
        .enable_timer2(enable_timer2),
        .enable_uart(enable_uart),
        .enable_pwm(enable_pwm),
        .enable_segments(enable_segments),
        .enable_power_manager(enable_power_manager),
        .enable_synth(enable_synth),
        .enable_ext_io(enable_ext_io))
    hwi (
        .enable(using_peripherals),
        .addr(offset),
        .data_out(dout_hwi)); 
    
    generate
        if(enable_interrupt_mux)
            reflet_interrupt_mux #(.base_addr_size(`offset_size), .base_addr(`interrupt_mux_off)) interrupt_mux (
                .clk(clk),
                .reset(reset),
                .enable(using_peripherals),
                .addr(offset),
                .data_in(data_in[7:0]),
                .data_out(dout_interrupt_mux),
                .write_en(write_en),
                .cpu_int(interrupt_request),
                .gpio_int_in(int_gpio),
                .uart_int_in(int_uart),
                .timer_int_in(int_timer),
                .timer_2_int_in(int_timer2));
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
                .data_in(data_in[7:0]),
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
                .data_in(data_in[7:0]),
                .data_out(dout_timer),
                .write_en(write_en));
        else
        begin
            assign dout_timer = 0;
            assign int_timer = 0;
        end
    endgenerate

    generate
        if(enable_timer2)
            reflet_timer_2 #(.base_addr_size(`offset_size), .base_addr(`timer2off)) timer2 (
                .clk(clk),
                .reset(reset),
                .enable(using_peripherals),
                .interrupt(int_timer2),
                .addr(offset),
                .data_in(data_in[7:0]),
                .data_out(dout_timer2),
                .write_en(write_en),
                .timer_input(int_timer));
        else
        begin
            assign dout_timer2 = 0;
            assign int_timer2 = 0;
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
                .data_in(data_in[7:0]),
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

    generate
        if(enable_pwm)
            reflet_pwm #(.base_addr_size(`offset_size), .base_addr(`pwm_off)) pwm_generator (
                .clk(clk),
                .reset(reset),
                .enable(using_peripherals),
                .addr(offset),
                .data_in(data_in[7:0]),
                .data_out(dout_pwm),
                .write_en(write_en),
                .out(pwm));
        else
        begin
            assign dout_pwm = 0;
            assign pwm = 0;
        end
    endgenerate

    generate
        if(enable_segments)
            reflet_seven_segments #(.base_addr_size(`offset_size), .base_addr(`seg_off)) seg7 (
                .clk(clk),
                .reset(reset),
                .enable(using_peripherals),
                .addr(offset),
                .data_in(data_in[7:0]),
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
            assign dout_segments = 0;
        end
    endgenerate

    generate
        if(enable_power_manager)
            reflet_power_manager #(.base_addr_size(`offset_size), .base_addr(`power_off)) power_manager (
                .clk(clk),
                .reset(reset),
                .enable(using_peripherals),
                .addr(offset),
                .data_in(data_in[7:0]),
                .data_out(dout_power),
                .write_en(write_en),
                .cpu_enable(cpu_enable),
                .cpu_interrupts(interrupt_request));
        else
        begin
            assign cpu_enable = 1;
            assign dout_power = 0;
        end
    endgenerate

    generate 
        if(enable_synth)
            reflet_synth #(.base_addr_size(`offset_size), .base_addr(`synth_off), .clk_freq(clk_freq)) synth (
                .clk(clk),
                .reset(reset),
                .enable(using_peripherals),
                .addr(offset),
                .write_en(write_en),
                .data_in(data_in[7:0]),
                .data_out(dout_synth),
                .synth_out(synth_out));
        else
        begin
            assign synth_out = 0;
            assign dout_synth = 0;
        end
    endgenerate

    generate
        if(enable_ext_io)
            reflet_extended_io #(.base_addr_size(`offset_size), .base_addr(`extio_off), .number_of_io(ext_io_size)) ext_io (
                .clk(clk),
                .reset(reset),
                .enable(using_peripherals),
                .addr(offset),
                .data_in(data_in),
                .data_out(dout_extio),
                .write_en(write_en),
                .gpi(ext_io_in),
                .gpo(ext_io_out));
        else
        begin
            assign dout_extio = 0;
            assign ext_io_out = 0;
        end
    endgenerate

    generate
        if (enable_vga)
        reflet_vga_interface #(.base_addr_size(`offset_size), .base_addr(`vga_off), .clk_freq(clk_freq), .mem_resetable(mem_resetable)) vga (
            .clk(clk),
            .reset(reset),
            .enable(using_peripherals),
            .addr(offset),
            .data_in(data_in),
            .data_out(dout_vga),
            .write_en(write_en),
            .h_sync(h_sync),
            .v_sync(v_sync),
            .R_out(R_out),
            .G_out(G_out),
            .B_out(B_out));
        else
        begin
            assign h_sync   = 1'b0;
            assign v_sync   = 1'b0;
            assign R_out    = 2'b0;
            assign G_out    = 2'b0;
            assign B_out    = 2'b0;
            assign dout_vga = 8'b0;
        end
    endgenerate


endmodule

