
module simu5_tb;

    reg clk = 0;
    always #1 clk = !clk;
    reg reset = 1;

    wire [6:0] segments;
    wire [3:0] seg_select;
    wire seg_colon;
    wire seg_dot;

    clock_cpu 
    cpu (
        .clk(clk),
        .reset_in(reset),
        .debug(),
        .quit(),
        .gpi(16'h0),
        .gpo(),
        .tx(),
        .rx(1'b1),
        .pwm(),
        .segments(segments),
        .seg_select(seg_select),
        .seg_colon(seg_colon),
        .seg_dot(seg_dot));

    integer i;
    initial
    begin
        $dumpfile("simu5_tb.vcd");
        $dumpvars(0, simu5_tb);
        for(i = 0; i<16; i=i+1)
            $dumpvars(0, cpu.cpu.registers[i]);
        #5000;
        reset = 0;
        #2;
        reset = 1;
        #100000;
        $finish;
    end

endmodule
    
