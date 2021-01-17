
module ext_gpio_tb ();

    reg clk = 0;
    always #1 clk = !clk;
    reg reset = 0;

    wire [15:0] gpi = 16'hABCD;
    wire [15:0] gpo;

    reg [5:0] addr = 6'h3;
    wire gpi_read, gpo_read;
    reg gpo_write = 1'b1;
    reg edit_gpo = 1'b0;

    reflet_addressable_io #(.number_of_io(16), .addr_size(6)) io (
        .clk(clk),
        .reset(reset),
        .addr(addr),
        .gpi_read(gpi_read),
        .gpo_read(gpo_read),
        .gpo_write(gpo_write),
        .edit_gpo(edit_gpo),
        .gpi(gpi),
        .gpo(gpo));

    initial 
    begin
        $dumpfile("ext_gpio_tb.vcd");
        $dumpvars(0, ext_gpio_tb);
        #10;
        reset <= 1;
        #10;
        edit_gpo <= 1;
        #2;
        edit_gpo <= 0;
        gpo_write <= 0;
        #3;
        addr <= 7;
        #2;
        gpo_write <= 1;
        edit_gpo <= 1;
        #2;
        edit_gpo <= 0;
        #4;
        addr <= 1;
        #20;
        $finish;
    end

endmodule

