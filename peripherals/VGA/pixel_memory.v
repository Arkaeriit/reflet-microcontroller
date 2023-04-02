/*-----------------------------\
|This module contains a block  |
|of RAM that can be            |
|accessed with X/Y coordinates.|
|When the X or Y coordinates   |
|are ~0, the output is 0.      |
\-----------------------------*/

module pixel_memory #(
    parameter h_size = 640,
    v_line = 480,
    color_depth = 8,
    ram_resetable = 0
    )(
    input clk,
    input reset,
    input write_en,
    input [$clog2(h_size)-1:0] h_pixel_read,
    input [$clog2(v_line)-1:0] v_pixel_read,
    input [$clog2(h_size)-1:0] h_pixel_write,
    input [$clog2(v_line)-1:0] v_pixel_write,
    input [color_depth-1:0] color_write,
    output [color_depth-1:0] color_read
    );

    localparam ram_size = h_size * v_line;
    localparam addr_size = $clog2(ram_size);

    wire [color_depth-1:0] color_read_mem;

    //addr signals
    wire [addr_size-1:0] addr_read;
    coord_to_addr #(.h_size(h_size), .v_line(v_line)) addr_read_gen (
        .clk(clk),
        .h_pixel(h_pixel_read),
        .v_pixel(v_pixel_read),
        .addr(addr_read));
    wire [addr_size-1:0] addr_write;
    coord_to_addr #(.h_size(h_size), .v_line(v_line)) addr_write_gen (
        .clk(clk),
        .h_pixel(h_pixel_write),
        .v_pixel(v_pixel_write),
        .addr(addr_write));

    //Ram block
    reflet_ram_dual_port #(.addrSize(addr_size), .size(ram_size), .depth(color_depth), .resetable(ram_resetable)) ram (
        .clk(clk),
        .reset(reset),
        .enable(1'b1),
        .addr_read(addr_read),
        .addr_write(addr_write),
        .data_in(color_write),
        .data_out(color_read_mem),
        .write_en(write_en));

    assign color_read = (h_pixel_read >= h_size || v_pixel_read >= v_line ? 0 : color_read_mem);

endmodule



/*-------------------------------\
|This module convert an X/Y coord|
|into an address to feed a RAM.  |
\-------------------------------*/

module coord_to_addr #(
    parameter h_size = 640,
    v_line = 480
    )(
    input clk,
    input [$clog2(h_size)-1:0] h_pixel,
    input [$clog2(v_line)-1:0] v_pixel,
    output reg [$clog2(h_size * v_line)-1:0] addr
    );

    always @ (posedge clk) //A very simple way to compute the addr but I keep it in a separate module if I need to change it.
        addr <= v_pixel * h_size + h_pixel;

endmodule

