/*---------------------------------\
|This file contains some very basic|
|elements needed by other modules. |
\---------------------------------*/

//basic sr_latch
module reflet_sr_latch #(
    parameter default_value = 1'b0
    )(
    input clk,
    input reset,
    input set,
    output reg out = default_value
    );

    always @ (posedge clk)
        if(reset)
            out <= 0;
        else
            if(set)
                out <= 1;

endmodule

//Shorten a signal to a single clock cycle
module reflet_short (
    input clk,
    input reset,
    input in,
    output out
    );

    reg mem1, mem2;

    always @ (posedge clk)
        if(!reset)
        begin
            mem1 <= 0;
            mem2 <= 0;
        end
        else
        begin
            mem1 <= in;
            mem2 <= mem1;
        end

    assign out = mem1 & !mem2;

endmodule

