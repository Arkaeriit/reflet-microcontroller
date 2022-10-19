//This simulation print Hello, world! with the UART
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

    // Peripheral
    wire [7:0] dout_periph;
    wire [7:0] din_periph = (addr[0] ? data_out_cpu[15:8] : data_out_cpu[7:0]);
    wire [15:0] dout_periph_shift = (addr[0] ? {dout_periph, 8'h0} : {8'h0, dout_periph});
    reflet_peripheral #(
        .wordsize(16), 
        .base_addr_size(15), 
        .base_addr(15'h7F00), 
        .clk_freq(96000),
        .enable_interrupt_mux(0),
        .enable_gpio(0),
        .enable_timer(0),
        .enable_timer2(0),
        .enable_uart(1),
        .enable_pwm(0),
        .enable_segments(0),
        .enable_power_manager(0),
        .enable_synth(0)
    ) periph (
        .clk(clk),
        .reset(reset),
        .enable(addr[15]),
        .addr(addr[14:0]),
        .data_in(din_periph),
        .data_out(dout_periph),
        .write_en(write_en),
        .rx(rx),
        .tx(tx));

    // Memory
    wire [15:0] data_out_rom;
    wire [15:0] data_out_ram;
    rom2 rom(
        .clk(clk), 
        .enable(!addr[15]), 
        .addr(addr[14:1]),
        .data(data_out_rom));
    reflet_ram #(.addrSize(14), .dataSize(16), .size(100)) ram(
        .clk(clk), 
        .reset(reset), 
        .enable(addr[15]), 
        .addr(addr[14:1]), 
        .data_in(data_out_cpu), 
        .write_en(write_en), 
        .data_out(data_out_ram));
    assign data_in_cpu = data_out_rom | dout_periph_shift | data_out_ram;
    reflet_cpu #(.wordsize(16)) cpu(
        .clk(clk), 
        .reset(reset), 
        .quit(quit), 
        .enable(1'b1),
        .data_in(data_in_cpu), 
        .addr(addr), 
        .data_out(data_out_cpu), 
        .write_en(write_en));

    integer i;

    initial
    begin
        $dumpfile("simu2_tb.vcd");
        $dumpvars(0, simu2);
        for(i = 0; i<16; i=i+1)
            $dumpvars(0, cpu.registers[i]);
        #10;
        reset = 1;
        #40000;
        $finish;
    end

endmodule

