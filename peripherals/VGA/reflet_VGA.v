/*----------------------------------\
|This module combines the VGA timing|
|generator and some memory to have a|
|block ready to be pluged to an ADC.|
|It is interfaced by giving it a    |
|pixel coordinate, a color and a    |
|write_enable signal.               |
\----------------------------------*/

module reflet_VGA #(
    parameter clk_freq = 1000000,
    refresh_rate = 60,
    h_size = 640,
    h_front_porch = 16,
    h_sync_pulse = 96,
    h_back_porsh = 48,
    v_line = 480,
    v_front_porch  = 10,
    v_sync_pulse = 2,
    v_back_porsh = 33,
    color_depth = 8,
    ram_resetable = 0,
    bit_reduction = 0
    )(
    input clk,
    input reset,
    //Pixel input
    input write_en,
    input [$clog2(h_size)-bit_reduction-1:0] h_pixel,
    input [$clog2(v_line)-bit_reduction-1:0] v_pixel,
    input [color_depth-1:0] R_in,
    input [color_depth-1:0] G_in,
    input [color_depth-1:0] B_in,
    //VGA output
    output h_sync,
    output v_sync,
    output [color_depth-1:0] R_out,
    output [color_depth-1:0] G_out,
    output [color_depth-1:0] B_out
    );

    localparam reduction_factor = 2 ** bit_reduction;

    //Timing generator
    wire [$clog2(h_size)-bit_reduction-1:0] h_pixel_out;
    wire [$clog2(v_line)-bit_reduction-1:0] v_pixel_out;
    VGA_timing_generation #(
        .clk_freq(clk_freq),
        .refresh_rate(refresh_rate),
        .h_size(h_size),
        .h_front_porch(h_front_porch),
        .h_sync_pulse(h_sync_pulse),
        .h_back_porsh(h_back_porsh),
        .v_line(v_line),
        .v_front_porch(v_front_porch),
        .v_sync_pulse(v_sync_pulse),
        .v_back_porsh(v_back_porsh),
        .bit_reduction(bit_reduction))
    timing (
        .clk(clk),
        .reset(reset),
        .h_sync(h_sync),
        .v_sync(v_sync),
        .h_pixel(h_pixel_out),
        .v_pixel(v_pixel_out));

    //Memories
    pixel_memory #(
        .h_size(h_size/reduction_factor),
        .v_line(v_line/reduction_factor),
        .color_depth(color_depth),
        .ram_resetable(ram_resetable))
    memory_red (
        .clk(clk),
        .reset(reset),
        .write_en(write_en),
        .h_pixel_read(h_pixel_out),
        .v_pixel_read(v_pixel_out),
        .h_pixel_write(h_pixel),
        .v_pixel_write(v_pixel),
        .color_write(R_in),
        .color_read(R_out));

    pixel_memory #(
        .h_size(h_size/reduction_factor),
        .v_line(v_line/reduction_factor),
        .color_depth(color_depth),
        .ram_resetable(ram_resetable))
    memory_green (
        .clk(clk),
        .reset(reset),
        .write_en(write_en),
        .h_pixel_read(h_pixel_out),
        .v_pixel_read(v_pixel_out),
        .h_pixel_write(h_pixel),
        .v_pixel_write(v_pixel),
        .color_write(G_in),
        .color_read(G_out));
    
    pixel_memory #(
        .h_size(h_size/reduction_factor),
        .v_line(v_line/reduction_factor),
        .color_depth(color_depth),
        .ram_resetable(ram_resetable))
    memory_blue (
        .clk(clk),
        .reset(reset),
        .write_en(write_en),
        .h_pixel_read(h_pixel_out),
        .v_pixel_read(v_pixel_out),
        .h_pixel_write(h_pixel),
        .v_pixel_write(v_pixel),
        .color_write(B_in),
        .color_read(B_out));

endmodule

