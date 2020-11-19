/*-----------------------------------\
|This is a template for the status   |
|registers of the peripherals.       |
|The data is stored on a single byte.|
\-----------------------------------*/

module reflet_ro_register #(
    parameter addr_size = 16,
    reg_addr = 0
    )(
    input enable,
    //system bus; note: no data_in nor data_out
    input [addr_size-1:0] addr,
    output [7:0] data_out,
    //peripheral status
    input [7:0] data
    );

    wire read_en = enable && reg_addr == addr;

    assign data_out = ( enable  && addr == reg_addr ? data : 0 );

endmodule

