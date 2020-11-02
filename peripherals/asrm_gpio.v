/*-----------------\
|This module offers|
|16 GPO and 16 GPI.|
\-----------------*/

module asrm_gpio #(
    parameter word_size = 16,
    base_addr_size = 16,
    base_addr = 16'hFF00
    )(
    input clk,
    input reset,
    input enable,
    //system bus
    input [base_addr_size-1:0] addr,
    input write_en,
    input [word_size-1:0] data_in,
    input [word_size-1:0] data_out,
    //GPIO acces
    input [15:0] gpi,
    output [15:0] gpo
    );
    
    wire using_gpio = enable && addr >= base_addr && addr <= base_addr + 4;
    wire [1:0] offset = addr - base_addr;

    //Registers
    wire [7:0] dout_gpo1;
    wire [7:0] dout_gpo2;
    wire [7:0] dout_gpi1;
    wire [7:0] dout_gpi2;
    asrm_rw_register #(2, 0, 0) reg_pgo1(
        clk,
        reset,
        using_gpio,
        offset,
        write_en,
        data_in[7:0],
        dout_gpo1,
        gpo[7:0]);
    asrm_rw_register #(2, 1, 0) reg_pgo2(
        clk,
        reset,
        using_gpio,
        offset,
        write_en,
        data_in[7:0],
        dout_gpo2,
        gpo[15:8]);
    asrm_ro_register #(2, 2) reg_pgi1(
        clk,
        reset,
        using_gpio,
        offset,
        dout_gpi1,
        gpi[7:0]);
    asrm_ro_register #(2, 3) reg_pgi2(
        clk,
        reset,
        using_gpio,
        offset,
        dout_gpi2,
        gpi[15:8]);

    assign data_out = dout_gpi1 | dout_gpi2 | dout_gpo1 | dout_gpo2;

endmodule
        
