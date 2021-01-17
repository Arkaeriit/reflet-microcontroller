
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
    
