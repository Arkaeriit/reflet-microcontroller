
module simu_boot;

    reg clk = 0;
    always #1 clk = !clk;
    reg reset = 1;

    wire quit;

    test_boot 
    cpu (
        .clk(clk),
        .reset_in(reset),
        .debug(),
        .quit(quit),
        .gpi(16'h0),
        .gpo(),
        .tx(),
        .rx(1'b1),
        .pwm(),
        .segments(),
        .seg_select(),
        .seg_colon(),
        .seg_dot());

endmodule
    
