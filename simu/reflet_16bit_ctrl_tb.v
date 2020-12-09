/*------------------------------\
|This module is ment to test the|
|booting of a 16 bits controler.|
\------------------------------*/

module reflet_16bit_ctrl_tb ();
    
    reg clk = 0;
    always #1 clk = !clk;
    reflet_16bit_controler #(
        .clk_freq(1000000),
        .enable_exti(1),
        .enable_gpio(0),
        .enable_timer(1),
        .enable_timer2(1),
        .enable_uart(1),
        .enable_pwm(0),
        .enable_segments(0))
    ctrl (
        .clk(clk),
        .reset(1),
        .reset_limited(1),
        .rx(1));

endmodule    
    
