
module synth_tb();

    reg clk = 0;
    always #1 clk = !clk;
    reg reset = 0;
    
    reg [1:0] shape = 1;
    reg [5:0] tone = 60;

    wire out;

    reflet_synth_generator synth(
        .clk(clk),
        .reset(reset),
        .shape(shape),
        .tone(tone),
        .out(out));

    initial
    begin
        $dumpfile("synth_tb.vcd");
        $dumpvars(0, synth_tb);
        #10;
        reset = 1;
        #10000;
        tone = 48;
        shape = 2;
        #10000;
        tone = 55;
        shape = 3;
        #10000;
        shape = 0;
        #10000;
        $finish;
    end

endmodule

