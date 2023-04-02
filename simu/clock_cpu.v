
module clock_cpu #(
    parameter clk_freq = 1000000,
    enable_interrupt_mux = 1,
    enable_gpio = 1,
    enable_timer = 1,
    enable_uart = 1,
    enable_pwm = 1,
    enable_segments = 1,
    enable_power_manager = 1
    )(
    input clk,
    input reset_in,
    //CPU monitoring
    output debug,
    output quit,
    //GPIO
    input [15:0] gpi,
    output [15:0] gpo,
    //UART
    input rx,
    output tx,
    //PWM
    output pwm,
    //Seven segments
    output [6:0] segments,
    output [3:0] seg_select,
    output seg_colon,
    output seg_dot
    );

    //reset control
    wire reset, blink;
    reflet_blink reset_bootstrap(.clk(clk), .out(blink));
    assign reset = reset_in & !blink;

    //system bus and interrupt request
    wire [15:0] addr;
    wire [15:0] data_out_cpu;
    wire [15:0] data_in_cpu;
    wire write_en;
    wire [3:0] interrupt_request;
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
        .interrupt_request(interrupt_request));

    //memory map
    wire [15:0] dout_inst;
    wire [15:0] dout_data;
    wire [7:0] dout_periph;
    wire [7:0] din_periph = (addr[0] ? data_out_cpu[15:8] : data_out_cpu[7:0]);
    wire [15:0] dout_periph_shift = (addr[0] ? {dout_periph, 8'h0} : {8'h0, dout_periph});
    assign data_in_cpu = dout_inst | dout_data | dout_periph_shift;
    //0x00 to 0x7FFF: instruction. Should be replaced with a ROM for real use
    rom05 rom (
        .clk(clk),
        .enable(!addr[15]),
        .addr(addr[9:1]),
        .data(dout_inst));

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
        .clk_freq(clk_freq),
        .enable_interrupt_mux(enable_interrupt_mux),
        .enable_gpio(enable_gpio),
        .enable_timer(enable_timer),
        .enable_uart(enable_uart),
        .enable_pwm(enable_pwm),
        .enable_segments(enable_segments),
        .enable_synth(0),
        .enable_ext_io(0),
        .enable_vga(0),
        .enable_power_manager(enable_power_manager)) 
    periph (
        .clk(clk),
        .reset(reset),
        .enable(addr[15]),
        .interrupt_request(interrupt_request),
        .addr(addr[14:0]),
        .data_in(din_periph),
        .data_out(dout_periph),
        .write_en(write_en),
        .gpi(gpi),
        .gpo(gpo),
        .rx(rx),
        .tx(tx),
        .pwm(pwm),
        .segments(segments),
        .cpu_enable(cpu_enable),
        .seg_select(seg_select),
        .seg_dot(seg_dot),
        .seg_colon(seg_colon));

endmodule

