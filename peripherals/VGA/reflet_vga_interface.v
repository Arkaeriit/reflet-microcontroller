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
    wire using_gpu = addr >= base_addr && addr <= base_addr + 2 && enable;
    wire [1:0] offset = addr - base_addr;

    //registers
    wire [7:0] dout_h;
    wire [7:0] dout_v;
    wire [7:0] dout_color;
    wire [7:0] _h;
    wire [7:0] _v;
    wire [7:0] color;
    assign data_out = dout_h | dout_v | dout_color;
    reflet_rw_register #(.addr_size(2), .reg_addr(0), .default_value(0)) reg_h (
        .clk(clk),
        .reset(reset),
        .enable(using_gpu),
        .addr(offset),
        .write_en(write_en),
        .data_in(data_in),
        .data_out(dout_h),
        .data(_h));
    reflet_rw_register #(.addr_size(2), .reg_addr(1), .default_value(0)) reg_v (
        .clk(clk),
        .reset(reset),
        .enable(using_gpu),
        .addr(offset),
        .write_en(write_en),
        .data_in(data_in),
        .data_out(dout_v),
        .data(_v));
    reflet_rw_register #(.addr_size(2), .reg_addr(2), .default_value(0)) reg_color (
        .clk(clk),
        .reset(reset),
        .enable(using_gpu),
        .addr(offset),
        .write_en(write_en),
        .data_in(data_in),
        .data_out(dout_color),
        .data(color));

    // GPU control
    wire gpu_we = write_en && using_gpu && offset == 2;
    wire [$clog2(160)-1:0] h = _h[$clog2(160)-1:0];
    wire [$clog2(120)-1:0] v = _v[$clog2(120)-1:0];

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
        .write_en(gpu_we),
        .h_pixel(h),
        .v_pixel(v),
        .R_in(color[1:0]),
        .G_in(color[3:2]),
        .B_in(color[5:4]),
        //VGA output
        .h_sync(h_sync),
        .v_sync(v_sync),
        .R_out(R_out),
        .G_out(G_out),
        .B_out(B_out));

endmodule

