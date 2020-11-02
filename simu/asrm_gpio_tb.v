/*-------------\
|This testbench|
|tests the GPIO|
\-------------*/

module asrm_gpio_tb();

    reg clk = 0;
    always #1 clk = !clk;
    reg reset = 0;

    //system bus
    reg [3:0] addr = 0;
    reg write_en = 0;
    reg [15:0] data_in = 0;
    wire [15:0] data_out;

    //GPIO
    wire [15:0] gpi = 16'hABCD;
    wire [15:0] gpo;

    asrm_gpio #(16, 4, 2) gpio (clk, reset, 1'b1, addr, write_en, data_in, data_out, gpi, gpo);

    initial
    begin
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
    end

endmodule

