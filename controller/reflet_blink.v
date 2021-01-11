/*-------------------------------------------\
|This module is output a signal for 3 clock  |
|cycles at the starting of the FPGA then shut|
|down definitively. It is ment to bootstrap a|
|reset signal to initialize all modules.     |
\-------------------------------------------*/

module reflet_blink (
    input clk,
    output out
    );

    reg [1:0] cnt = 0;
    
    always @ (posedge clk)
        if(cnt != 2'b11)
            cnt <= cnt + 1;

    assign out = cnt != 2'b11;

endmodule

