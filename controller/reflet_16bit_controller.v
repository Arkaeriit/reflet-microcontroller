/*-------------------------------------\
|This is the top module for a 16 bit   |
|reflet controller. The module mem_inst|
|can be replaced with a ROM to make is |
|usable from the start.                |
\-------------------------------------*/

module reflet_16bit_controller #(
    parameter clk_freq = 1000000,
    debug_output = 0,
    enable_interrupt_mux = 1,
    enable_gpio = 1,
    enable_timer = 1,
    enable_timer2 = 1,
    enable_uart = 1,
    enable_pwm = 1,
    enable_segments = 1,
    enable_power_manager = 1,
    enable_synth = 1,
    enable_ext_io = 1,
    data_size = 100,
    inst_size = 128,
    mem_resetable = 0,
    ext_io_size = 128
    )(
    input clk,
    input reset, //Resets the all system
    input reset_limited, //does not resets the instruction memory
    //CPU monitoring
    output debug,
    output quit,
    output debug_tx,
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
    output seg_dot,
    //Frequency generator
    output synth_out,
    //extended io
    input [ext_io_size-1:0] ext_io_in,
    output [ext_io_size-1:0] ext_io_out
    );

    //reset control
    wire reset_full, blink, reset_smol, inst_ready;
    reflet_blink reset_bootstrap(.clk(clk), .out(blink));
    assign reset_full = reset & !blink;
    assign reset_smol = reset_full & reset_limited & inst_ready;

    //system bus, cpu_enable and interrupts
    wire [15:0] addr;
    wire [15:0] data_out_cpu;
    wire [15:0] data_in_cpu;
    wire write_en;
    wire [3:0] interrupt_request;
    wire cpu_enable, cpu_enable_periph;
    wire [15:0] debug_wr;

    //cpu
    reflet_cpu #(.wordsize(16), .debug_output(debug_output)) cpu (
        .clk(clk),
        .reset(reset_smol),
        .enable(cpu_enable),
        .data_in(data_in_cpu),
        .data_out(data_out_cpu),
        .addr(addr),
        .write_en(write_en),
        .quit(quit),
        .debug(debug),
        .debug_wr(debug_wr),
        .interrupt_request(interrupt_request));

    // Debug module
    generate
        if (debug_output)
        begin
            wire debug_helper_working;
            reflet_debug_helper #(.wordsize(16), .clk_freq(clk_freq)) debug_helper (
                .clk(clk),
                .reset(reset_smol),
                .enable(cpu_enable_periph),
                .debug(debug),
                .debug_wr(debug_wr),
                .tx(debug_tx),
                .working(debug_helper_working));
            assign cpu_enable = cpu_enable_periph & !debug_helper_working;
        end
        else
        begin
            assign cpu_enable = cpu_enable_periph | (|debug_wr); // In that case, debug_wr is set to 0, so cpu_enable = cpu_enable_periph
            assign debug_tx = 1'b1;
        end
    endgenerate

    //memory map
    wire [15:0] dout_inst;
    wire [15:0] dout_data;
    wire [7:0] dout_periph;
    wire [7:0] din_periph = (addr[0] ? data_out_cpu[15:8] : data_out_cpu[7:0]);
    wire [15:0] dout_periph_shift = (addr[0] ? {dout_periph, 8'h0} : {8'h0, dout_periph});
    assign data_in_cpu = dout_inst | dout_data | dout_periph_shift;
    //0x00 to 0x7FFF: instruction. Can be replaced with a ROM
    reflet_inst16 #(.size(inst_size), .resetable(mem_resetable)) mem_inst (
        .clk(clk),
        .reset(reset_full),
        .inst_ready(inst_ready),
        .enable(!addr[15]),
        .addr(addr[14:1]),
        .data_in(data_out_cpu),
        .data_out(dout_inst),
        .write_en(write_en));

    //0x8000 to 0xFEFF: data. Should stay as a regular RAM
    reflet_ram #(.addrSize(14), .dataSize(16), .size(data_size), .resetable(mem_resetable)) mem_data (
        .clk(clk),
        .reset(reset_smol),
        .enable(addr[15]),
        .addr(addr[14:1]),
        .data_in(data_out_cpu),
        .data_out(dout_data),
        .write_en(write_en));

    //0xFF00 to 0xFFFF: peripherals
    //0x00 to 0x03 : hardware info
    //0x04 to 0x07 : interrupt_mux
    //0x08 to 0x0F : gpio
    //0x10 to 0x12 : timer
    //0x13 to 0x15 : timer2
    //0x16 to 0x19 : uart
    //0x1A to 0x1B : pwm
    //0x1C to 0x1E : seven segments
    //0x1F to 0x20 : power_manager
    //0x21         : synth
    //0x22 to 0x23 : extended IO
    reflet_peripheral #(
        .wordsize(16), 
        .base_addr_size(15), 
        .base_addr(15'h7F00), 
        .clk_freq(clk_freq),
        .enable_interrupt_mux(enable_interrupt_mux),
        .enable_gpio(enable_gpio),
        .enable_timer(enable_timer),
        .enable_timer2(enable_timer2),
        .enable_uart(enable_uart),
        .enable_pwm(enable_pwm),
        .enable_segments(enable_segments),
        .enable_power_manager(enable_power_manager),
        .enable_synth(enable_synth),
        .enable_ext_io(enable_ext_io),
        .ext_io_size(ext_io_size)) 
    periph (
        .clk(clk),
        .reset(reset_smol),
        .enable(addr[15]),
        .interrupt_request(interrupt_request),
        .cpu_enable(cpu_enable_periph),
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
        .seg_select(seg_select),
        .seg_dot(seg_dot),
        .seg_colon(seg_colon),
        .synth_out(synth_out),
        .ext_io_in(ext_io_in),
        .ext_io_out(ext_io_out));

endmodule

