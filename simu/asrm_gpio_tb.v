/*-------------\
|This testbench|
|tests the GPIO|
\-------------*/

module asrm_gpio_tb();

    reg clk = 0;
    reg reset = 0;

    //system bus
    reg [3:0] addr = 0;
    reg write_en;
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
        #1;
        addr = 4;
        #1;
        write_en = 0;
        #1;
        addr = 5;
        #1;
        addr = 6;
        #1;
        addr = 7;
    end

endmodule

