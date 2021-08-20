//This small demonstration is ment to showcase the low power mode of
//this microcontroller
module simu6 ();

    reg clk = 0;
    always #1 clk = !clk;
    wire reset_in = 1;
    

    //reset control
    wire reset, blink;
    reflet_blink reset_bootstrap(.clk(clk), .out(blink));
    assign reset = reset_in & !blink;

    //system bus and exti
    wire [15:0] addr;
    wire [15:0] data_out_cpu;
    wire [15:0] data_in_cpu;
    wire write_en;
    wire [3:0] exti;
    wire cpu_enable;

    //cpu
    reflet_cpu #(.wordsize(16)) cpu (
        .clk(clk),
        .reset(reset),
        .enable(cpu_enable),
        .data_in(data_in_cpu),
        .data_out(data_out_cpu),
        .addr(addr),
        .write_en(write_en),
        .quit(quit),
        .debug(debug),
        .ext_int(exti));

    //memory map
    wire [15:0] dout_inst;
    wire [15:0] dout_data;
    wire [7:0] dout_periph;
    assign data_in_cpu = dout_inst | dout_data | {8'h0, dout_periph};
    //0x00 to 0x7FFF: instruction. Should be replaced with a ROM for real use
    rom6_wide rom (
        .clk(clk),
        .enable(!addr[15]),
        .addr(addr[8:1]),
        .data_out(dout_inst));

    //0x8000 to 0xFEFF: data. Should stay as a regular RAM
    reflet_ram #(.addrSize(14), .dataSize(16), .size(100)) mem_data (
        .clk(clk),
        .reset(reset),
        .enable(addr[15]),
        .addr(addr[14:1]),
        .data_in(data_out_cpu),
        .data_out(dout_data),
        .write_en(write_en));

    //0xFF00 to 0xFFFF: peripherals
    reflet_peripheral #(
        .wordsize(16), 
        .base_addr_size(15), 
        .base_addr(15'h7F00), 
        .clk_freq(1000000),
        .enable_exti(1),
        .enable_gpio(0),
        .enable_timer(1),
        .enable_timer2(0),
        .enable_uart(0),
        .enable_pwm(0),
        .enable_segments(0),
        .enable_power_manager(1)) 
    periph (
        .clk(clk),
        .reset(reset),
        .enable(addr[15]),
        .ext_int(exti),
        .cpu_enable(cpu_enable),
        .addr(addr[14:0]),
        .data_in(data_out_cpu[7:0]),
        .data_out(dout_periph),
        .write_en(write_en),
        .gpi(16'h0),
        .rx(1'b1));

    initial
    begin
        $dumpfile("simu6_tb.vcd");
        $dumpvars(0, simu6);
        #400000;
        $finish;
    end

endmodule

