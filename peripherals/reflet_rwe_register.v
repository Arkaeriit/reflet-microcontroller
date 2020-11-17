/*----------------------------------------\
|This is a template for both configuration|
|and status registers of the peripherals. |
|The data is stored on a single byte.     |
\----------------------------------------*/

module reflet_rwe_register #(
    parameter addr_size = 16,
    reg_addr = 0,
    default_value = 0
    )(
    input clk,
    input reset,
    input enable,
    //system bus
    input [addr_size-1:0] addr,
    input write_en,
    input [7:0] data_in,
    output [7:0] data_out,
    //peripheral control
    input [7:0] data_override,
    input override,
    output reg [7:0] data
    );

    wire wr_en = enable && write_en && reg_addr == addr;
    wire read_en = enable && reg_addr == addr;

    always @ (posedge clk)
        if(!reset)
        begin
            data = default_value;
        end
        else
        begin
            if(override)
                data = data_override;
            else
            begin
                if(wr_en)
                    data = data_in;
            end
        end

    assign data_out = ( read_en ? data : 0 );

endmodule

