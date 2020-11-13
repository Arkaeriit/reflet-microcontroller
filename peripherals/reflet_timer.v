/*------------------------------------\
|This module is a time. It sends      |
|interrupts with a specific frequency.|
|The time to count up is:             |
|(pre1 + 1) * (pre2 + 1) * (arr)      |
\------------------------------------*/

module reflet_timer #(
    parameter wordsize = 16,
    base_addr_size = 16,
    base_addr = 16'hFF10
    )(
    input clk,
    input reset,
    input enable,
    output interrupt,
    //system bus
    input [base_addr_size-1:0] addr,
    input write_en,
    input [wordsize-1:0] data_in,
    input [wordsize-1:0] data_out
    );

    wire using_timer = enable && addr >= base_addr && addr < base_addr + 3;
    wire [1:0] offset = addr - base_addr;

    //registers
    wire [7:0] dout_pre1;
    wire [7:0] dout_pre2;
    wire [7:0] dout_arr;
    assign data_out = dout_arr | dout_pre1 | dout_pre2;
    wire [7:0] pre1;
    wire [7:0] pre2;
    wire [7:0] arr;
    reflet_rw_register #(.addr_size(2), .reg_addr(0), .default_value(0)) reg_pre1(
        .clk(clk),
        .reset(reset),
        .enable(using_timer),
        .addr(offset),
        .write_en(write_en),
        .data_in(data_in[7:0]),
        .data_out(dout_pre1),
        .data(pre1));
    reflet_rw_register #(.addr_size(2), .reg_addr(1), .default_value(0)) reg_pre2(
        .clk(clk),
        .reset(reset),
        .enable(using_timer),
        .addr(offset),
        .write_en(write_en),
        .data_in(data_in[7:0]),
        .data_out(dout_pre2),
        .data(pre2));
    reflet_rw_register #(.addr_size(2), .reg_addr(2), .default_value(0)) reg_arr(
        .clk(clk),
        .reset(reset),
        .enable(using_timer),
        .addr(offset),
        .write_en(write_en),
        .data_in(data_in[7:0]),
        .data_out(dout_arr),
        .data(arr));

    //checking the configuration
    wire timer_active = arr != 8'h0 && pre1 != 8'hFF && pre2 != 8'hFF; //checking for invalid values
    wire [31:0] pre1_max = {24'h0, pre1+1};
    wire [31:0] pre2_max = {24'h0, pre2+1};
    wire [31:0] arr_max = {24'h0, arr};

    //Chain of counter
    wire pre1_out, pre2_out;
    reflet_counter pre1_cnt(
        .clk(clk),
        .reset(reset & timer_active),
        .enable(1'b1),
        .max(pre1_max),
        .out(pre1_out));
    reflet_counter pre2_cnt(
        .clk(clk),
        .reset(reset & timer_active),
        .enable(pre1_out),
        .max(pre2_max),
        .out(pre2_out));
    reflet_counter arr_cnt(
        .clk(clk),
        .reset(reset & timer_active),
        .enable(pre2_out),
        .max(arr_max),
        .out(interrupt));

endmodule

