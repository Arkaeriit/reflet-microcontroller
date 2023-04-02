
module VGA_timing_generation #(
    parameter clk_freq = 1000000,
    refresh_rate = 60,
    h_size = 640,
    h_front_porch = 16,
    h_sync_pulse = 96,
    h_back_porsh = 48,
    v_line = 480,
    v_front_porch  = 10,
    v_sync_pulse = 2,
    v_back_porsh = 33,
    bit_reduction = 0    
    )(
    input clk,
    input reset,
    output h_sync,
    output v_sync,
    output [$clog2(h_size)-bit_reduction-1:0] h_pixel,
    output [$clog2(v_line)-bit_reduction-1:0] v_pixel
    );

    //using parameters to compute usefull data
    localparam reduction_factor = 2 ** bit_reduction;
    localparam ticks_per_line = (h_size + h_front_porch + h_sync_pulse + h_back_porsh) / reduction_factor;
    localparam lines_per_frame = (v_line + v_front_porch + v_sync_pulse + v_back_porsh);
    localparam ticks_per_frame = ticks_per_line * lines_per_frame;
    localparam freq_div = clk_freq / (ticks_per_frame * refresh_rate) + (clk_freq % (ticks_per_frame * refresh_rate) > (ticks_per_frame * refresh_rate) / 2 ? 1 : 0); //clk_freq / (tpf * ref_rate * reduction_factor) rounded to closest

    //Generating pixel-tick clock
    wire pixel_tick;
    //wire [$clog2(freq_div)-1:0] freq_div_wire = freq_div;
    wire [$clog2(freq_div):0] freq_div_wire = freq_div;
    reflet_counter #(.size($clog2(freq_div)+1)) tick_gen (
        .clk(clk),
        .reset(reset),
        .enable(1'b1),
        .max(freq_div_wire),
        .out(pixel_tick));

    //keeping track of the where we are
    reg [$clog2(ticks_per_line)-1:0] h_pos;
    reg [$clog2(lines_per_frame)-1:0] v_pos;
    always @ (posedge clk)
        if(!reset)
        begin
            h_pos <= 0;
            v_pos <= 0;
        end
        else
            if(pixel_tick)
            begin
                if(h_pos == ticks_per_line - 1)
                begin
                    h_pos <= 0;
                    if(v_pos == lines_per_frame - 1)
                        v_pos <= 0;
                    else
                        v_pos <= v_pos + 1;
                end
                else
                    h_pos <= h_pos + 1;
            end


    //generating output signal
    assign h_pixel = ( h_pos < h_size ? h_pos : ~0 );
    assign v_pixel = ( v_pos < v_line ? v_pos >> bit_reduction : ~0 );
    assign h_sync = !(h_pos * reduction_factor >= h_size + h_front_porch && h_pos * reduction_factor < h_size + h_front_porch + h_sync_pulse);
    assign v_sync = !(v_pos >= v_line + v_front_porch && v_pos < v_line + v_front_porch + v_sync_pulse);

endmodule

