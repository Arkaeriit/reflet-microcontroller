/*--------------------------------------------\
|This module is  counter. When enabled,       |
|it will increase a register until a certain  |
|value is reached. Then it will start again   |
|and send a pulse.                            |
|If the max value is 0, the counter is        |
|disabled; if it is 1, it output a constant 1.|
\--------------------------------------------*/

module reflet_counter #(
    parameter size = 32
    )(
    input clk,
    input reset,
    input enable,
    input [size-1:0] max,
    output out
    );

    reg [size-1:0] counter = 0;
    reg reached_max;
    reg reached_max_ark;

    always @ (posedge clk)
        if(!reset)
        begin
            counter = 0;
            reached_max = 0;    
            reached_max_ark = 0;
        end
        else
        begin 
            if(enable) //incrementing the counter
            begin
                if(counter == max - 1)
                begin
                    counter = 0;
                    reached_max <= 1;
                end
                else
                begin
                    counter = counter + 1;
                    reached_max <= 0;
                end
            end
            reached_max_ark <= reached_max;
        end

        assign out = ( max == 0 ? 0 :
                        ( max == 1 ? enable :
                           reached_max & !reached_max_ark));

endmodule

