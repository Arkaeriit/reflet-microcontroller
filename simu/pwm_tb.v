
module pwm_tb ();

    reg clk = 0;
    always #1 clk = !clk;
    reg reset = 0;
    
    reg [7:0] max = 10;
    reg [7:0] duty_cycle = 1;
    wire out;

    reflet_pwm_pwm pwm(
        .clk(clk),
        .reset(reset),
        .duty_cycle(duty_cycle),
        .max(max),
        .out(out));

    initial
    begin
        #4;
        reset = 1;
        #100;
        duty_cycle = 0;
        #100;
        duty_cycle = 3;
        #100;
        duty_cycle = 9;
        #100;
        duty_cycle = 10;
        #100;
        duty_cycle = 11;
    end

endmodule
