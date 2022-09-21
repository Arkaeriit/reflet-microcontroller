// This test bench tests the uart_sending module
// It is somewhat ironic to test a test module but whatever

module uart_sending_tb();
    
    reg clk = 0;
    always #1 clk = !clk;
    reg reset = 0;
    
    reg rx = 0;
    wire tx;

    uart_sending #(.clk_freq(10_000), .baud_rate(1000)) uart_s (
        .clk(clk),
        .reset(reset),
        .rx(rx),
        .tx(tx));

    initial
    begin
        $dumpfile("uart_sending_tb.vcd");
        $dumpvars(0, uart_sending_tb);
        #10;
        reset <= 1;
        #100000;
        $finish;
    end
    
endmodule

