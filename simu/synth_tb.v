
module synth_tb();

    reg clk = 0;
    always #1 clk = !clk;
    reg reset = 0;
    
    reg [1:0] volume = 1;
    reg [5:0] tone = 60;

    wire out;

    reflet_synth_generator synth(
        .clk(clk),
        .reset(reset),
        .volume(volume),
        .tone(tone),
        .out(out));

    initial
    begin
        $dumpfile("synth_tb.vcd");
        $dumpvars();
        #10;
        reset = 1;
        #10000;
        $finish;
    end

endmodule

