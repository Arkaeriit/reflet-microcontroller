/*------------------------------------\
|This module is ment to let the user  |
|read configuation such as the clock  |
|frequency or which peripherals are   |
|on in registers. It should have the  |
|same parameterd as the periph module.|
\------------------------------------*/

module reflet_hardware_info #(
    parameter wordsize = 16,
    base_addr_size = 16,
    base_addr = 16'hFF00,
    enable_exti = 1,
    enable_gpio = 1,
    enable_timer = 1,
    enable_uart = 1,
    enable_pwm = 1,
    clk_freq=1000000
    )(
    input enable,
    input [base_addr_size-1:0] addr,
    output [wordsize-1:0] data_out
    );

    wire using_hwi = enable && addr >= base_addr && addr < base_addr + 4;
    wire [1:0] offset = addr - base_addr;

    //Info parameters
    integer clk_freq_MHz = clk_freq/1000000;
    wire [7:0] clk_freq_lsb = clk_freq_MHz & 32'h000000FF;
    wire [7:0] clk_freq_msb = (clk_freq_MHz & 32'h0000FF00) >> 8;
    wire [2:0] wordsize_info = ( wordsize == 8 ? 1 :
                               ( wordsize == 16 ? 2 : 
                               ( wordsize == 32 ? 3 :
                               ( wordsize == 64 ? 4 :
                               ( wordsize == 128 ? 5 :
                               0)))));
    //registers
    wire [7:0] dout_clk1;
    wire [7:0] dout_clk2;
    wire [7:0] dout_info1;
    wire [7:0] dout_info2;
    assign data_out = dout_clk1 | dout_clk2 | dout_info1 | dout_info2;
    reflet_ro_register #(.addr_size(2), .reg_addr(0)) reg_clk_lsb (
       .enable(using_hwi),
       .addr(offset),
       .data_out(dout_clk1),
       .data(clk_freq_lsb));
   reflet_ro_register #(.addr_size(2), .reg_addr(1)) reg_clk_msb (
       .enable(using_hwi),
       .addr(offset),
       .data_out(dout_clk2),
       .data(clk_freq_msb));
   reflet_ro_register #(.addr_size(2), .reg_addr(2)) reg_info1 (
       .enable(using_hwi),
       .addr(offset),
       .data_out(dout_info1),
       .data({|enable_pwm, |enable_uart, |enable_timer, |enable_gpio, |enable_exti, wordsize_info }));
   reflet_ro_register #(.addr_size(2), .reg_addr(3)) reg_info2 (
       .enable(using_hwi),
       .addr(offset),
       .data_out(dout_info2),
       .data(8'h0)); //data will be used when more peripherals will be made

endmodule
    
