
module reflet_8bit_ctrl_tb ();

    reg clk = 0;
    always #1 clk = !clk;
    wire tx;
    wire rx;
    wire debug, debug_tx;
    reg reset_cpu = 0;
    reg reset_uart = 0;

    reflet_8bit_ctrl_with_rom #(.clk_freq(1_000_000))  ctrl (
        .clk(clk),
        .reset_in(reset_cpu),
        .debug(debug),
        .debug_tx(debug_tx),
        .quit(),
        .gpi(16'b0),
        .gpo(),
        .tx(tx),
        .rx(rx));

    uart_sending #(.clk_freq(1_000_000), .baud_rate(9600)) uart_s (
        .clk(clk),
        .reset(reset_uart),
        .rx(tx),
        .tx(rx));
    

    integer i;
    initial
    begin
        $dumpfile("reflet_8bit_ctrl_tb.vcd");
        $dumpvars(0, reflet_8bit_ctrl_tb);
        for(i = 0; i<16; i=i+1)
            $dumpvars(0, ctrl.cpu.registers[i]);
        #10;
        reset_cpu <= 1;
        #1000;
        reset_uart <= 1;
        #1000000;
        $finish;
    end

endmodule

