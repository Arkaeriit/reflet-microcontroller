
module reflet_8bit_ctrl_tb ();

    reg clk = 0;
    always #1 clk = !clk;
    wire tx;
    reg rx = 1;
    reg reset_in = 1;

    reflet_8bit_ctrl_with_rom ctrl (
        .clk(clk),
        .reset_in(reset_in),
        .debug(),
        .quit(),
        .gpi(16'b0),
        .gpo(),
        .tx(tx),
        .rx(rx));

    integer i;
    initial
    begin
        $dumpfile("reflet_8bit_ctrl_tb.vcd");
        $dumpvars(0, reflet_8bit_ctrl_tb);
        for(i = 0; i<16; i=i+1)
            $dumpvars(0, ctrl.cpu.registers[i]);
        #1000;
        rx = 0;
        #200;
        rx = 1;
        #2000;
        reset_in = 0;
        #10;
        reset_in = 1;
        #100;
        rx = 0;
        #200;
        rx = 1;
        #10000;
        $finish;
    end

endmodule

