
module reflet_8bit_ctrl_tb ();

    reg clk = 0;
    always #1 clk = !clk;
    wire tx;
    reg rx = 1;

    reflet_8bit_ctrl_with_rom ctrl (
        .clk(clk),
        .reset_in(1'b1),
        .debug(),
        .quit(),
        .gpi(16'b0),
        .gpo(),
        .tx(tx),
        .rx(rx));

    initial
    begin
        #1000;
        rx = 0;
        #200;
        rx = 1;
    end

endmodule

