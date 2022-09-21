/*-------------------------------\
|This module is ment to test the |
|booting of a 16 bits contromler.|
\-------------------------------*/

module reflet_16bit_ctrl_tb ();
    
    reg clk = 0;
    always #1 clk = !clk;
    wire rx, quit;
    reg reset_uart_emmiter = 0;

    reflet_16bit_controller #(
        .clk_freq(1000000),
        .enable_exti(1),
        .enable_gpio(0),
        .enable_timer(1),
        .enable_timer2(1),
        .enable_uart(1),
        .enable_pwm(0),
        .enable_segments(0),
        .enable_power_manager(0))
    ctrl (
        .clk(clk),
        .reset(1'h1),
        .reset_limited(1'h1),
        .rx(rx),
        .gpi(16'h0),
        .quit(quit));

    uart_sending_msg #(.clk_freq(1000000), .msg_size_byte(5)) prg (
        .clk(clk),
        .reset(reset_uart_emmiter),
        .msg(40'h0E01020304),
        .rx(1'b1),
        .tx(rx));

    integer i;

    initial
    begin
        $dumpfile("reflet_16bit_ctrl_tb.vcd");
        $dumpvars(0, reflet_16bit_ctrl_tb);
        for(i = 0; i<16; i=i+1)
            $dumpvars(0, ctrl.cpu.registers[i]);
        #5000;
        reset_uart_emmiter <= 1;
        #10000000;
        $finish;
    end

endmodule    
    

