/*-------------\
|This testbench|
|tests the GPIO|
\-------------*/

module reflet_gpio_tb();

    reg clk = 0;
    always #1 clk = !clk;
    reg reset = 0;

    //system bus
    reg [3:0] addr = 0;
    reg write_en = 0;
    reg [7:0] data_in = 0;
    wire [7:0] data_out;

    //GPIO
    wire [15:0] gpi = 16'hABCD;
    wire [15:0] gpo;

    reflet_gpio #(.base_addr_size(4), .base_addr(2)) gpio (
        .clk(clk), 
        .reset(reset), 
        .enable(1'b1), 
        .addr(addr), 
        .write_en(write_en), 
        .data_in(data_in), 
        .data_out(data_out), 
        .gpi(gpi), 
        .gpo(gpo));

    initial
    begin
        $dumpfile("reflet_gpio_tb.vcd");
        $dumpvars(0, reflet_gpio_tb);
        #10;
        reset = 1;
        data_in = 7;
        write_en = 1;
        #2;
        addr = 2;
        #2;
        write_en = 0;
        #2;
        addr = 3;
        #2;
        addr = 4;
        #2;
        addr = 5;
        #2;
        addr = 6;
        #10;
        $finish;
    end

endmodule

