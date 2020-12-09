
module reflet_8bit_controller #(
    parameter clk_freq = 1000000,
    enable_exti = 1,
    enable_gpio = 1,
    enable_timer = 1,
    enable_uart = 1
    )(
    input clk,
    input reset,
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
    assign reset_used = reset & !blink;

    //system bus and exti
    wire [7:0] addr;
    wire [7:0] data_out_cpu;
    wire [7:0] data_in_cpu;
    wire write_en;
    wire [3:0] exti;

    //cpu
    reflet_cpu #(.wordsize(8)) cpu (
        .clk(clk),
        .reset(reset_used),
        .data_in(data_in_cpu),
        .data_out(data_out_cpu),
        .addr(addr),
        .write_en(write_en),
        .quit(quit),
        .debug(debug),
        .ext_int(exti));

    //memory map
    wire [7:0] dout_inst;
    wire [7:0] dout_data;
    wire [7:0] dout_periph;
    assign data_in_cpu = dout_inst | dout_data | dout_periph;
    //0x00 to 0x7F: instruction. Should be replaced with a ROM for real use
    reflet_ram8 #(.addrSize(7), .size(128)) mem_inst (
        .clk(clk),
        .reset(reset_used),
        .enable(!addr[7]),
        .addr(addr[6:0]),
        .data_in(data_out_cpu),
        .data_out(dout_inst),
        .write_en(write_en));

    //0x80 to 0xEC: data. Should stay as a regular RAM
    reflet_ram8 #(.addrSize(7), .size(108)) mem_data (
        .clk(clk),
        .reset(reset_used),
        .enable(addr[7]),
        .addr(addr[6:0]),
        .data_in(data_out_cpu),
        .data_out(dout_data),
        .write_en(write_en));

    //0xED to 0xFF: peripherals
    //0xED to 0xF0: exti
    //0xF1 to 0xF8: GPIO
    //0xF9 to 0xFB: timer
    //0xFC to 0xFF: UART
    reflet_peripheral_minimal #(
        .wordsize(8), 
        .base_addr_size(7), 
        .base_addr(7'h6D), 
        .clk_freq(clk_freq),
        .enable_exti(enable_exti),
        .enable_gpio(enable_gpio),
        .enable_timer(enable_timer),
        .enable_uart(enable_uart)) 
    periph (
        .clk(clk),
        .reset(reset_used),
        .enable(addr[7]),
        .ext_int(exti),
        .addr(addr[6:0]),
        .data_in(data_out_cpu),
        .data_out(dout_periph),
        .write_en(write_en),
        .gpi(gpi),
        .gpo(gpo),
        .rx(rx),
        .tx(tx));

endmodule

