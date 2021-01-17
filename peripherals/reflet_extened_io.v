/*----------------------------------------\
|This module links a reflet_addressable_io|
|module to the system bus.                |
\----------------------------------------*/

module reflet_extended_io #(
    parameter base_addr_size = 16,
    base_addr = 16'hFF22,
    number_of_io = 128
    )(
    input clk,
    input reset,
    input enable,
    //system bus
    input [base_addr_size-1:0] addr,
    input write_en,
    input [7:0] data_in,
    output [7:0] data_out,
    //IO
    input [number_of_io-1:0] gpi,
    output [number_of_io-1:0] gpo
    );

    //access control
    wire using_extio = addr >= base_addr && addr <= base_addr + 2 && enable;
    wire offset = addr - base_addr;

    //Register
    wire [7:0] dout_addr;
    wire [7:0] dout_ctrl;
    wire [7:0] io_addr;
    wire [7:0] io_ctrl;
    wire gpi_read, gpo_read, gpo_write, edit_gpo, update_ctrl;
    reflet_rw_register #(.addr_size(1), .reg_addr(0), .default_value(0)) reg_addr (
        .clk(clk),
        .reset(reset),
        .enable(using_extio),
        .addr(offset),
        .write_en(write_en),
        .data_in(data_in),
        .data_out(dout_addr),
        .data(io_addr));
    reflet_rwe_register #(.addr_size(1), .reg_addr(1), .default_value(0)) reg_ctrl (
        .clk(clk),
        .reset(reset),
        .enable(using_extio),
        .addr(offset),
        .write_en(write_en),
        .data_in(data_in),
        .data_out(dout_ctrl),
        .data(io_ctrl),
        .data_override({5'h0, gpo_write, gpo_read, gpi_read}),
        .override(edit_gpo | update_ctrl));
    
    //actual module
    assign gpo_write = io_ctrl[2];
    assign edit_gpo = io_ctrl[3];
    reflet_addressable_io #(.number_of_io(number_of_io), .addr_size(8)) io (
        .clk(clk),
        .reset(reset),
        .addr(io_addr),
        .gpi_read(gpi_read),
        .gpo_read(gpo_read),
        .gpo_write(gpo_write),
        .edit_gpo(edit_gpo),
        .gpi(gpi),
        .gpo(gpo));

    //monitoring addr change
    reg [7:0] io_addr_old;
    wire update_addr = io_addr_old != io_addr;
    reg update_delay; //We need two clk cycle to updage the 
    always @ (posedge clk)
        if(!reset)
        begin
            io_addr_old <= 7'h1; //setting it to 1 to ensure that the update_ctrl is set to 1 just after reset
            update_delay <= 1;
        end
        else
        begin
            io_addr_old <= io_addr;
            update_delay <= edit_gpo;
        end
    assign update_ctrl = update_addr | update_delay;

endmodule



/*------------------------------\
|This module let you control a  |
|vast amount of parallel IO from|
|a small amount of ports.       |
\------------------------------*/

module reflet_addressable_io #(
    parameter number_of_io = 128,
    addr_size = 8
    )(
    input clk,
    input reset,
    //bank selection and eddition
    input [addr_size-1:0] addr,
    output gpi_read,
    output gpo_read,
    input gpo_write,
    input edit_gpo,
    //IO
    input [number_of_io-1:0] gpi,
    output reg [number_of_io-1:0] gpo
    );
    integer i;

    //input
    assign gpi_read = gpi[addr];
    assign gpo_read = gpo[addr];

    //output
    always @ (posedge clk)
        if(!reset)
            gpo <= 0;
        else
            if(edit_gpo)
                gpo[addr] <= gpo_write;

endmodule
    
