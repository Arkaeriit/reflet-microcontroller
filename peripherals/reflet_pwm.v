/*---------\
|This is an|
|8-bit pwm.|
\---------*/

module reflet_pwm_pwm (
    input clk,
    input reset,
    input [7:0] duty_cycle,
    input [7:0] max,
    output out
    );

    reg out_normal;
    wire update;

    wire base_freq, switch_off;
    reflet_counter count_base (
        .clk(clk),
        .reset(reset & !update),
        .enable(1'b1),
        .max({24'h0, max}),
        .out(base_freq));
    reflet_counter count_off (
        .clk(clk),
        .reset(reset & !update),
        .enable(out),
        .max({24'h0, duty_cycle}),
        .out(switch_off));

    always @ (posedge clk)
        if(!reset | update)
            out_normal = 0;
        else
        begin
            if(base_freq)
                out_normal = 1;
            else if(switch_off)
                out_normal = 0;
        end

    //resseting in case of sudden changes
    reg [15:0] old_values;
    always @ (posedge clk)
        old_values = {max, duty_cycle};
    assign update = |(old_values ^ {max, duty_cycle});

    assign out = ( duty_cycle == 0 ? 0 :
                    ( duty_cycle == 1 ? base_freq :
                       out_normal));

endmodule

