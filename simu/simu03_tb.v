module simu03();

    reg clk = 0;
    always #1 clk = !clk;
    reg reset = 0;
    wire quit;
    wire debug;
    
    //system bus
    wire [7:0] addr;
    wire write_en;
    wire [7:0] data_in_cpu;
    wire [7:0] data_out_cpu;

    //GPIO
    reg [15:0] gpi = 0;
    wire [15:0] gpo;

    //modules
    wire [7:0] data_out_gpio;
    wire [7:0] data_out_interrupt_mux;
    wire [7:0] data_out_rom;
    wire gpio_int;
    wire [3:0] int;
    reflet_gpio #(.base_addr_size(7), .base_addr(7'h00)) gpio(
        .clk(clk), 
        .reset(reset), 
        .enable(addr[7]), 
        .addr(addr[6:0]), 
        .write_en(write_en), 
        .data_in(data_out_cpu), 
        .data_out(data_out_gpio), 
        .gpi(gpi), 
        .gpo(gpo),
        .interrupt(gpio_int));
    reflet_interrupt_mux #(.base_addr_size(7), .base_addr(7'h08)) interrupt_mux(
        .clk(clk), 
        .reset(reset), 
        .enable(addr[7]), 
        .addr(addr[6:0]), 
        .write_en(write_en), 
        .data_in(data_out_cpu), 
        .data_out(data_out_interrupt_mux), 
        .gpio_int_in(gpio_int),
        .uart_int_in(1'b0),
        .timer_int_in(1'b0),
        .cpu_int(int));
    rom03 rom(
        .clk(clk), 
        .enable(!addr[7]), 
        .addr(addr[6:0]), 
        .data(data_out_rom));
    assign data_in_cpu = data_out_rom | data_out_gpio | data_out_interrupt_mux;
    reflet_cpu #(.wordsize(8)) cpu(
        .clk(clk), 
        .reset(reset), 
        .quit(quit), 
        .enable(1'b1),
        .data_in(data_in_cpu), 
        .addr(addr), 
        .data_out(data_out_cpu), 
        .write_en(write_en),
        .interrupt_request(int),
        .debug(debug));

    initial
    begin
        $dumpfile("simu03_tb.vcd");
        $dumpvars(0, simu03);
        #10;
        reset = 1;
        #2000;
        gpi = 16'hABCD;
        #500;
        gpi = 16'h0000;
        #100;
        gpi = 16'h001;
        #200;
        gpi = 16'h0000;
        #200;
        $finish;
    end

endmodule

