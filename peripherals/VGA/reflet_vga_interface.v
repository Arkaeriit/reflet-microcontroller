module reflet_vga_interface #(
    parameter base_addr_size = 16,
    base_addr = 16'hFF24,
    clk_freq = 1000000,
    mem_resetable = 0
    )(
    input clk,
    input reset,
    input enable,
    //system bus
    input [base_addr_size-1:0] addr,
    input [7:0] data_in,
    output [7:0] data_out,
    input write_en,
    //VGA output
    output h_sync,
    output v_sync,
    output [1:0] R_out,
    output [1:0] G_out,
    output [1:0] B_out
    );

    //access control
    wire using_gpu = addr >= base_addr && addr <= base_addr + 4 && enable;
    wire [2:0] offset = addr - base_addr;

    //registers
    wire [7:0] dout_h;
    wire [7:0] dout_v;
    wire [7:0] dout_color;
    wire [7:0] dout_color_bg;
    wire [7:0] dout_char;
    wire [7:0] _h;
    wire [7:0] _v;
    wire [7:0] color;
    wire [7:0] color_bg;
    wire [7:0] char;
    assign data_out = dout_h | dout_v | dout_color | dout_color_bg | dout_char;
    reflet_rw_register #(.addr_size(3), .reg_addr(0), .default_value(0)) reg_h (
        .clk(clk),
        .reset(reset),
        .enable(using_gpu),
        .addr(offset),
        .write_en(write_en),
        .data_in(data_in),
        .data_out(dout_h),
        .data(_h));
    reflet_rw_register #(.addr_size(3), .reg_addr(1), .default_value(0)) reg_v (
        .clk(clk),
        .reset(reset),
        .enable(using_gpu),
        .addr(offset),
        .write_en(write_en),
        .data_in(data_in),
        .data_out(dout_v),
        .data(_v));
    reflet_rw_register #(.addr_size(3), .reg_addr(2), .default_value(0)) reg_char (
        .clk(clk),
        .reset(reset),
        .enable(using_gpu),
        .addr(offset),
        .write_en(write_en),
        .data_in(data_in),
        .data_out(dout_char),
        .data(char));
    reflet_rw_register #(.addr_size(3), .reg_addr(3), .default_value(0)) reg_color_bg (
        .clk(clk),
        .reset(reset),
        .enable(using_gpu),
        .addr(offset),
        .write_en(write_en),
        .data_in(data_in),
        .data_out(dout_color_bg),
        .data(color_bg));
    reflet_rw_register #(.addr_size(3), .reg_addr(4), .default_value(0)) reg_color (
        .clk(clk),
        .reset(reset),
        .enable(using_gpu),
        .addr(offset),
        .write_en(write_en),
        .data_in(data_in),
        .data_out(dout_color),
        .data(color));

    // GPU control
    wire [$clog2(160)-1:0] h = _h[$clog2(160)-1:0];
    wire [$clog2(120)-1:0] v = _v[$clog2(120)-1:0];
    wire _gpu_we_bitmap = write_en && using_gpu && offset == 4 && char == 8'h0;
    wire _gpu_we_txt = write_en && using_gpu && offset == 4 && char != 8'h0;
    reg gpu_we_bitmap, gpu_we_txt;
    always @ (posedge clk)
    begin
        gpu_we_bitmap <= _gpu_we_bitmap;
        gpu_we_txt <= _gpu_we_txt;
    end

    reflet_VGA #(
        .clk_freq(clk_freq),
        .refresh_rate(60),
        .h_size(640),
        .h_front_porch(16),
        .h_sync_pulse(96),
        .h_back_porsh(48),
        .v_line(480),
        .v_front_porch (10),
        .v_sync_pulse(2),
        .v_back_porsh(33),
        .color_depth(2),
        .ram_resetable(mem_resetable),
        .bit_reduction(2)
        ) vga (
        .clk(clk),
        .reset(reset),
        //Pixel input
        .write_bitmap(gpu_we_bitmap),
        .write_txt(gpu_we_txt),
        .h_pixel(h),
        .v_pixel(v),
        .R_in(color[1:0]),
        .G_in(color[3:2]),
        .B_in(color[5:4]),
        .a_in(color[7:6]),
        .R_bg_in(color_bg[1:0]),
        .G_bg_in(color_bg[3:2]),
        .B_bg_in(color_bg[5:4]),
        .char_in(char),
        //VGA output
        .h_sync(h_sync),
        .v_sync(v_sync),
        .R_out(R_out),
        .G_out(G_out),
        .B_out(B_out));

endmodule

