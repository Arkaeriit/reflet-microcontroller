/*--------------------------\
|This module integrate a pwm|
|as a reflet peripheral.    |
\--------------------------*/

module reflet_pwm #(
    parameter base_addr_size = 16,
    base_addr= 16'hFF1A
    )(
    input clk,
    input reset,
    input enable,
    //system bus
    input [base_addr_size-1:0] addr,
    input [7:0] data_in,
    output [7:0] data_out,
    input write_en,
    //output
    output out
    );

    //acces control
    wire using_pwm = enable && addr >= base_addr && addr < base_addr + 2;
    wire offset = addr - base_addr;

    //registers
    wire [7:0] dout_freq;
    wire [7:0] dout_duty;
    wire [7:0] freq;
    wire [7:0] duty;
    assign data_out = dout_duty | dout_freq;
    reflet_rw_register #(.addr_size(1), .reg_addr(0), .default_value(0)) reg_freq (
        .clk(clk),
        .reset(reset),
        .enable(using_pwm),
        .addr(offset),
        .write_en(write_en),
        .data_in(data_in),
        .data_out(dout_freq),
        .data(freq));
    reflet_rw_register #(.addr_size(1), .reg_addr(1), .default_value(0)) reg_duty (
        .clk(clk),
        .reset(reset),
        .enable(using_pwm),
        .addr(offset),
        .write_en(write_en),
        .data_in(data_in),
        .data_out(dout_duty),
        .data(duty));

    //The actual pwm
    reflet_pwm_pwm #(.size(8)) pwm (
        .clk(clk),
        .reset(reset),
        .enable(1'b1),
        .duty_cycle(duty),
        .max(freq),
        .out(out));

endmodule



/*---------\
|This is an|
|8-bit pwm.|
\---------*/

module reflet_pwm_pwm #(
    parameter size = 8
    )(
    input clk,
    input reset,
    input enable,
    input [size-1:0] duty_cycle,
    input [size-1:0] max,
    output out
    );

    reg out_normal;
    reg enable_later;
    wire update;

    wire using_count_off = duty_cycle > 1 && duty_cycle < max;
    wire using_count_base = using_count_off | duty_cycle == 1;

    wire base_freq, switch_off;
    wire [size-1:0] duty_cycle_late = duty_cycle - 1; //cf .max() in count_off
    reflet_counter #(.size(size)) count_base (
        .clk(clk),
        .reset(reset & !update),
        .enable(using_count_base & enable),
        .max(max),
        .out(base_freq));
    reflet_counter #(.size(size)) count_off (
        .clk(clk),
        .reset(reset & !update & !base_freq), //This counter should start a clk cycle after the other counter, it should thus be reset by uate_late
        .enable(using_count_off & out_normal & enable),
        .max(duty_cycle_late), //As the counter is reset each cycles, we need to put a -1 because this counter is a clock cycle late
        .out(switch_off));

    always @ (posedge clk)
        if(!reset)
        begin
            out_normal <= 0;
            enable_later <= 0;
        end
        else
        begin
            enable_later <= enable;
            if (enable_later)
            begin
                if(base_freq | update)
                    out_normal <= 1;
                else if(switch_off)
                    out_normal <= 0;
            end
        end

    // resetting in case of sudden changes
    reg [2 * size - 1:0] old_values;
    always @ (posedge clk)
        old_values <= {max, duty_cycle};
    assign update = |(old_values ^ {max, duty_cycle});

    assign out = ( duty_cycle == 0 ? 0 :
                    ( duty_cycle == 1 ? base_freq :
                       ( duty_cycle >= max ? 1 :
                          out_normal)));

endmodule

