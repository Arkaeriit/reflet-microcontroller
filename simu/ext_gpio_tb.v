
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
    
    reg [2:0] sys_addr = 0;
    reg sys_wren = 0;
    reg [7:0] sys_din = 3;
    wire [7:0] sys_dout = 0;
    wire [3:0] reio_gpo;

    reflet_extended_io #(.base_addr_size(3), .base_addr(0), .number_of_io(4)) reio (
        .clk(clk),
        .reset(reset),
        .enable(1'b1),
        .addr(sys_addr),
        .write_en(sys_wren),
        .data_in(sys_din),
        .data_out(sys_dout),
        .gpi(gpi[3:0]),
        .gpo(reio_gpo));


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
        sys_wren <= 1;
        #2;
        sys_wren <= 0;
        #10;
        sys_addr <= 1;
        sys_din <= 8'hFF;
        sys_wren <= 1;
        #2;
        sys_wren <= 0;
        #20;
        $finish;
    end

endmodule

