/*-------------------------------------\
|This module is a time. It sends       |
|interrupts with a specific frequency. |
|The time to count up is:              |
|(pre1 + 1) * (pre2 + 1) * (mcnt)      |
|The diference between timer and timer2|
|comes from the fact that timer2 can   |
|use the output of timer as its input. |
\-------------------------------------*/

module reflet_timer_2 #(
    parameter base_addr_size = 16,
    base_addr = 16'hFF12
    )(
    input clk,
    input reset,
    input enable,
    output interrupt,
    //system bus
    input [base_addr_size-1:0] addr,
    input write_en,
    input [7:0] data_in,
    output [7:0] data_out,
    //alternative input
    input timer_input
    );

    wire using_timer = enable && addr >= base_addr && addr < base_addr + 3;
    wire [1:0] offset = addr - base_addr;

    //registers
    wire [7:0] dout_pre1;
    wire [7:0] dout_pre2;
    wire [7:0] dout_mcnt;
    assign data_out = dout_mcnt | dout_pre1 | dout_pre2;
    wire using_external_input;
    wire [6:0] pre1;
    wire [7:0] pre2;
    wire [7:0] mcnt;
    reflet_rw_register #(.addr_size(2), .reg_addr(0), .default_value(0)) reg_pre1(
        .clk(clk),
        .reset(reset),
        .enable(using_timer),
        .addr(offset),
        .write_en(write_en),
        .data_in(data_in[7:0]),
        .data_out(dout_pre1),
        .data({pre1, using_external_input}));
    reflet_rw_register #(.addr_size(2), .reg_addr(1), .default_value(0)) reg_pre2(
        .clk(clk),
        .reset(reset),
        .enable(using_timer),
        .addr(offset),
        .write_en(write_en),
        .data_in(data_in[7:0]),
        .data_out(dout_pre2),
        .data(pre2));
    reflet_rw_register #(.addr_size(2), .reg_addr(2), .default_value(0)) reg_mcnt(
        .clk(clk),
        .reset(reset),
        .enable(using_timer),
        .addr(offset),
        .write_en(write_en),
        .data_in(data_in[7:0]),
        .data_out(dout_mcnt),
        .data(mcnt));

    //checking the configuration
    wire timer_active = mcnt != 8'h0;
    wire [31:0] pre1_max = {24'h0, pre1+1};
    wire [31:0] pre2_max = {23'h0, pre2+1};
    wire [31:0] mcnt_max = {24'h0, mcnt};

    //Chain of counter
    wire pre1_out, pre2_out;
    reflet_counter pre1_cnt(
        .clk(clk),
        .reset(reset & timer_active),
        .enable(using_external_input ? timer_input : 1'b1),
        .max(pre1_max),
        .out(pre1_out));
    reflet_counter pre2_cnt(
        .clk(clk),
        .reset(reset & timer_active),
        .enable(pre1_out),
        .max(pre2_max),
        .out(pre2_out));
    reflet_counter mcnt_cnt(
        .clk(clk),
        .reset(reset & timer_active),
        .enable(pre2_out),
        .max(mcnt_max),
        .out(interrupt));

endmodule

