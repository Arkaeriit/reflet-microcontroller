/*-----------------------------------\
|This is a template for the status   |
|registers of the peripherals.       |
|The data is stored on a single byte.|
\-----------------------------------*/

module reflet_ro_register #(
    parameter addr_size = 16,
    reg_addr = 0
    )(
    input clk,
    input reset,
    input enable,
    //system bus; note: no data_in nor data_out
    input [addr_size-1:0] addr,
    output reg [7:0] data_out,
    //peripheral status
    input [7:0] data
    );

    wire read_en = enable && reg_addr == addr;

    always @ (posedge clk)
        if(!reset)
            data_out = 0;
        else
        begin
            if(read_en)
                data_out = data;
            else
                data_out = 0;
        end

endmodule

