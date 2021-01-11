/*-------------------------------\
|This module is ment to test the |
|booting of a 16 bits contromler.|
\-------------------------------*/

module reflet_16bit_ctrl_tb ();
    
    reg clk = 0;
    always #1 clk = !clk;
    reg rx = 1;
    wire quit;

    reflet_16bit_controller #(
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
        .reset(1'h1),
        .reset_limited(1'h1),
        .rx(rx),
        .gpi(16'h0),
        .quit(quit));

    initial
    begin
        $dumpfile("reflet_16bit_ctrl_tb.vcd");
        $dumpvars(0, reflet_16bit_ctrl_tb);
        #5000;
        rx = 0;
        #208;
        rx = 1;
        #1875;
        rx = 0;
        #208;
        rx = 1;
        #1875;
        rx = 0;
        #208;
        rx = 1;
        #1875;
        rx = 0;
        #208;
        rx = 1;
        #1875;
        rx = 0; //Quit start bit
        #208;
        rx = 0;
        #208;
        rx = 1;
        #208;
        rx = 1;
        #208;
        rx = 1;
        #208;
        rx = 0;
        #208;
        rx = 0;
        #208;
        rx = 0;
        #208;
        rx = 0;
        #208;
        rx = 1; //End bit
        #208;
        #10000000;
        $finish;
    end

endmodule    
    

