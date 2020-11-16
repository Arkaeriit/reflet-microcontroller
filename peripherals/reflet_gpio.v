/*-----------------\
|This module offers|
|16 GPO and 16 GPI.|
\-----------------*/

module reflet_gpio #(
    parameter wordsize = 16,
    base_addr_size = 16,
    base_addr = 16'hFF00
    )(
    input clk,
    input reset,
    input enable,
    output interrupt,
    //system bus
    input [base_addr_size-1:0] addr,
    input write_en,
    input [wordsize-1:0] data_in,
    output [wordsize-1:0] data_out,
    //GPIO acces
    input [15:0] gpi,
    output [15:0] gpo
    );
    
    wire using_gpio = enable && addr >= base_addr && addr < base_addr + 8;
    wire [2:0] offset = addr - base_addr;

    //interrupts
    wire [15:0] intmap_rising;
    wire [15:0] intmap_falling;
    reg [15:0] prev_gpi;
    wire [15:0] rising_edge_gpi = gpi & !prev_gpi;
    wire [15:0] falling_edge_gpi = !gpi & prev_gpi;
    assign interrupt = |(rising_edge_gpi & intmap_rising) | |(falling_edge_gpi & intmap_falling);
    always @ (posedge clk)
        if(!reset)
            prev_gpi = 0;
        else
            prev_gpi = gpi;

    //Registers
    wire [7:0] dout_gpo1;
    wire [7:0] dout_gpo2;
    wire [7:0] dout_gpi1;
    wire [7:0] dout_gpi2;
    wire [7:0] dout_intmap_r1;
    wire [7:0] dout_intmap_r2;
    wire [7:0] dout_intmap_f1;
    wire [7:0] dout_intmap_f2;
    reflet_rw_register #(.addr_size(3), .reg_addr(0), .default_value(0)) reg_pgo1(
        .clk(clk),
        .reset(reset),
        .enable(using_gpio),
        .addr(offset),
        .write_en(write_en),
        .data_in(data_in[7:0]),
        .data_out(dout_gpo1),
        .data(gpo[7:0]));
    reflet_rw_register #(.addr_size(3), .reg_addr(1), .default_value(0)) reg_pgo2(
        .clk(clk),
        .reset(reset),
        .enable(using_gpio),
        .addr(offset),
        .write_en(write_en),
        .data_in(data_in[7:0]),
        .data_out(dout_gpo2),
        .data(gpo[15:8]));
    reflet_ro_register #(.addr_size(3), .reg_addr(2)) reg_pgi1(
        .clk(clk),
        .reset(reset),
        .enable(using_gpio),
        .addr(offset),
        .data_out(dout_gpi1),
        .data(gpi[7:0]));
    reflet_ro_register #(.addr_size(3), .reg_addr(3)) reg_pgi2(
        .clk(clk),
        .reset(reset),
        .enable(using_gpio),
        .addr(offset),
        .data_out(dout_gpi2),
        .data(gpi[15:8]));
    reflet_rw_register #(.addr_size(3), .reg_addr(4), .default_value(0)) reg_intmap_r1(
        .clk(clk),
        .reset(reset),
        .enable(using_gpio),
        .addr(offset),
        .write_en(write_en),
        .data_in(data_in[7:0]),
        .data_out(dout_intmap_r1),
        .data(intmap_rising[7:0]));
    reflet_rw_register #(.addr_size(3), .reg_addr(5), .default_value(0)) reg_intmap_r2(
        .clk(clk),
        .reset(reset),
        .enable(using_gpio),
        .addr(offset),
        .write_en(write_en),
        .data_in(data_in[7:0]),
        .data_out(dout_intmap_r2),
        .data(intmap_rising[15:8]));
    reflet_rw_register #(.addr_size(3), .reg_addr(6), .default_value(0)) reg_intmap_f1(
        .clk(clk),
        .reset(reset),
        .enable(using_gpio),
        .addr(offset),
        .write_en(write_en),
        .data_in(data_in[7:0]),
        .data_out(dout_intmap_f1),
        .data(intmap_falling[7:0]));
    reflet_rw_register #(.addr_size(3), .reg_addr(7), .default_value(0)) reg_intmap_f2(
        .clk(clk),
        .reset(reset),
        .enable(using_gpio),
        .addr(offset),
        .write_en(write_en),
        .data_in(data_in[7:0]),
        .data_out(dout_intmap_f2),
        .data(intmap_falling[15:8]));

    assign data_out = dout_gpi1 | dout_gpi2 | dout_gpo1 | dout_gpo2;

endmodule
        
