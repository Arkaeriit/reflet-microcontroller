
module reflet_8bit_ctrl_with_rom #(
    parameter clk_freq = 1000000,
    debug_output = 1,
    enable_interrupt_mux = 1,
    enable_gpio = 1,
    enable_timer = 1,
    enable_uart = 1
    )(
    input clk,
    input reset_in,
    //CPU monitoring
    output debug,
    output quit,
    output debug_tx,
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

    //system bus and interrupt requests
    wire [7:0] addr;
    wire [7:0] data_out_cpu;
    wire [7:0] data_in_cpu;
    wire write_en;
    wire [3:0] interrupt_request;

    // Debug module
    wire cpu_enable;
    wire [7:0] debug_wr;
    generate
        if (debug_output)
        begin
            wire debug_helper_working;
            reflet_debug_helper #(.wordsize(8), .clk_freq(clk_freq)) debug_helper (
                .clk(clk),
                .reset(reset),
                .enable(1'b1),
                .debug(debug),
                .debug_wr(debug_wr),
                .tx(debug_tx),
                .working(debug_helper_working));
            assign cpu_enable = !debug_helper_working;
        end
        else
        begin
            assign cpu_enable =  !(|debug_wr); // In that case, debug_wr is set to 0, so cpu_enable = cpu_enable_periph
            assign debug_tx = 1'b1;
        end
    endgenerate

    //cpu
    reflet_cpu #(.wordsize(8), .debug_output(debug_output)) cpu (
        .clk(clk),
        .reset(reset),
        .enable(cpu_enable),
        .data_in(data_in_cpu),
        .data_out(data_out_cpu),
        .addr(addr),
        .write_en(write_en),
        .quit(quit),
        .debug(debug),
        .debug_wr(debug_wr),
        .interrupt_request(interrupt_request));

    //memory map
    wire [7:0] dout_inst;
    wire [7:0] dout_data;
    wire [7:0] dout_periph;
    assign data_in_cpu = dout_inst | dout_data | dout_periph;
    wire enable_rom = !(addr[7]);
    //0x00 to 0xBF: instruction. A rom that make a UART loop-back
    rom04 mem_inst (
        .clk(clk),
        .enable(enable_rom),
        .addr(addr[6:0]),
        .data(dout_inst));

    //0xC0 to 0xEC: data. Should stay as a regular RAM
    reflet_ram #(.addrSize(6), .dataSize(8), .size(44)) mem_data (
        .clk(clk),
        .reset(reset),
        .enable(!enable_rom),
        .addr(addr[5:0]),
        .data_in(data_out_cpu),
        .data_out(dout_data),
        .write_en(write_en));

    //0xEE to 0xFF: peripherals
    reflet_peripheral_minimal #(
        .wordsize(8), 
        .base_addr_size(6), 
        .base_addr(7'h2D), 
        .clk_freq(clk_freq),
        .enable_interrupt_mux(enable_interrupt_mux),
        .enable_gpio(enable_gpio),
        .enable_timer(enable_timer),
        .enable_uart(enable_uart)) 
    periph (
        .clk(clk),
        .reset(reset),
        .enable(!enable_rom),
        .interrupt_request(interrupt_request),
        .addr(addr[5:0]),
        .data_in(data_out_cpu),
        .data_out(dout_periph),
        .write_en(write_en),
        .gpi(gpi),
        .gpo(gpo),
        .rx(rx),
        .tx(tx));

endmodule

