/*------------------------------------\
|This module combines the RAM intended|
|to be filled with instructions and   |
|the bootloader ROM.                  |
\----------------------------------- */

module reflet_inst16 #(
    parameter size = 32255
    )(
    input clk,
    input reset,
    input enable,
    //system bus
    input [14:0] addr,
    input [15:0] data_in,
    output [15:0] data_out,
    input write_en
    );

    wire [15:0] ram_out;
    wire [7:0] bootlader_out;
    assign data_out = ram_out | {8'h0, bootlader_out};

    reflet_inst_ram16 #(.size(size)) ram (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .addr(addr),
        .data_in(data_in),
        .data_out(ram_out),
        .write_en(write_en));

    reflet_bootloader16_rom bootloader (
        .clk(clk),
        .enable(enable),
        .addr(addr),
        .data_out(bootlader_out));

endmodule

