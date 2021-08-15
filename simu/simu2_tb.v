//This simulation print Heelo, world! with the UART
module simu2();

    reg clk = 0;
    always #1 clk = !clk;
    reg reset = 0;
    wire quit;
    
    //system bus
    wire [15:0] addr;
    wire write_en;
    wire [15:0] data_in_cpu;
    wire [15:0] data_out_cpu;

    //UART
    wire rx = 1;
    wire tx;

    //modules
    wire [7:0] data_out_uart;
    wire [15:0] data_out_rom;
    wire [15:0] data_out_ram;
    reflet_uart #(.base_addr_size(15), .base_addr(15'h7F16), .clk_freq(96000)) uart (
        .clk(clk), 
        .reset(reset), 
        .enable(addr[15]), 
        .addr(addr[14:0]), 
        .write_en(write_en), 
        .data_in(data_out_cpu[7:0]), 
        .data_out(data_out_uart), 
        .rx(rx), 
        .tx(tx));
    rom2_wide rom(
        .clk(clk), 
        .enable(!addr[15]), 
        .addr(addr[10:1]),
        .data_out(data_out_rom));
    reflet_ram #(.addrSize(14), .dataSize(16), .size(100)) ram(
        .clk(clk), 
        .reset(reset), 
        .enable(addr[15]), 
        .addr(addr[14:1]), 
        .data_in(data_out_cpu), 
        .write_en(write_en), 
        .data_out(data_out_ram));
    assign data_in_cpu = data_out_rom | {8'h0, data_out_uart} | data_out_ram;
    reflet_cpu #(.wordsize(16)) cpu(
        .clk(clk), 
        .reset(reset), 
        .quit(quit), 
        .enable(1'b1),
        .data_in(data_in_cpu), 
        .addr(addr), 
        .data_out(data_out_cpu), 
        .write_en(write_en));

    initial
    begin
        $dumpfile("simu2_tb.vcd");
        $dumpvars(0, simu2);
        #10;
        reset = 1;
        #15000;
        $finish;
    end

endmodule

