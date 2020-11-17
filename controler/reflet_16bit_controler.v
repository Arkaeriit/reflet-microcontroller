
module reflet_16bit_controler #(
    parameter clk_freq = 1000000,
    enable_exti = 1,
    enable_gpio = 1,
    enable_timer = 1,
    enable_uart = 1,
    enable_pwm = 1
    )(
    input clk,
    input reset_in,
    //CPU monitoring
    output debug,
    output quit,
    //peripheral IO
    input [15:0] gpi,
    output [15:0] gpo,
    input rx,
    output tx
    );

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

    //cpu
    reflet_cpu #(.wordsize(16)) cpu (
        .clk(clk),
        .reset(reset),
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
    wire [15:0] dout_periph;
    assign data_in_cpu = dout_inst | dout_data | dout_periph;
    //0x00 to 0x7FFF: instruction. Should be replaced with a ROM for real use
    reflet_ram16 #(.addrSize(15), .size(128)) mem_inst (
        .clk(clk),
        .reset(reset),
        .enable(!addr[15]),
        .addr(addr[14:0]),
        .data_in(data_out_cpu),
        .data_out(dout_inst),
        .write_en(write_en));

    //0x8000 to 0xFEFF: data. Should stay as a regular RAM
    reflet_ram16 #(.addrSize(15), .size(100)) mem_data (
        .clk(clk),
        .reset(reset),
        .enable(addr[15]),
        .addr(addr[14:0]),
        .data_in(data_out_cpu),
        .data_out(dout_data),
        .write_en(write_en));

    //0xFF00 to 0xFFFF: peripherals
    reflet_peripheral #(
        .wordsize(16), 
        .base_addr_size(15), 
        .base_addr(15'h7F00), 
        .clk_freq(clk_freq),
        .enable_exti(enable_exti),
        .enable_gpio(enable_gpio),
        .enable_timer(enable_timer),
        .enable_uart(enable_uart),
        .enable_pwm(enable_pwm)) 
    periph (
        .clk(clk),
        .reset(reset),
        .enable(addr[15]),
        .ext_int(exti),
        .addr(addr[14:0]),
        .data_in(data_out_cpu),
        .data_out(dout_periph),
        .write_en(write_en),
        .gpi(gpi),
        .gpo(gpo),
        .rx(rx),
        .tx(tx));

endmodule

