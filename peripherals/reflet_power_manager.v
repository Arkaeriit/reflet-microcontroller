/*-----------------------------------------------------\
|This module is ment to put the processor in sleep mode|
|periodicaly or until an interruption is raised.       |
\-----------------------------------------------------*/

module reflet_power_manager #(
    parameter base_addr_size = 16,
    base_addr = 16'hFF1F
    )(
    input clk,
    input reset,
    input enable,
    //system bus 
    input [base_addr_size-1:0] addr,
    input write_en,
    input [7:0] data_in,
    output [7:0] data_out,
    //interupt lines and power
    input [3:0] cpu_interrupts,
    output cpu_enable
    );

    wire using_pm = enable && addr >= base_addr && addr < base_addr + 2;
    wire offset = addr - base_addr;

    //Listening for interupts
    wire [3:0] awakening_ints;
    wire int_detected = |{awakening_ints & cpu_interrupts};

    //generating the enable signal
    wire [7:0] power_value;
    wire pwm_out, using_lowpower, sleeping;
    reflet_pwm_pwm #(.size(9)) power_pwm(
        .clk(clk),
        .reset(reset),
        .enable(1'b1),
        .duty_cycle(power_value + 9'h1),
        .max(9'h100),
        .out(pwm_out));
    assign cpu_enable = (sleeping ? 0 : (using_lowpower ? pwm_out : 1));

    //Registers
    wire [7:0] dout_sleep;
    wire [7:0] dout_lowpower;
    wire [7:0] sleep_value;
    assign data_out = dout_sleep | dout_lowpower;
    reflet_rwe_register #(.addr_size(1), .reg_addr(0), .default_value(0)) sleep_reg (
        .clk(clk),
        .reset(reset),
        .enable(using_pm),
        .addr(offset),
        .write_en(write_en),
        .data_in(data_in),
        .data_out(dout_sleep),
        .data(sleep_value),
        .data_override({sleep_value[7:1], 1'b0}),
        .override(int_detected));
    reflet_rw_register #(.addr_size(1), .reg_addr(1), .default_value(8'hFF)) power_reg (
        .clk(clk),
        .reset(reset),
        .enable(using_pm),
        .addr(offset),
        .write_en(write_en),
        .data_in(data_in),
        .data_out(dout_lowpower),
        .data(power_value));
    assign using_lowpower = sleep_value[1];
    assign sleeping = sleep_value[0];
    assign awakening_ints = sleep_value[7:4];

endmodule    

