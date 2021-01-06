
module seven_seg_tb();

    reg clk = 0;
    always #1 clk = ! clk;
    reg reset_in = 1;
    //Seven segments
    wire [6:0] segments;
    wire [3:0] seg_select;
    wire seg_colon;
    wire seg_dot;

    reg [15:0] num;
    wire reset, blink;
    reflet_blink reset_bootstrap(.clk(clk), .out(blink));
    assign reset = reset_in & !blink;

    wire en, update;
    reflet_counter cnt1 (
        .clk(clk),
        .reset(reset),
        .enable(1'b1),
        .max(32'd100),
        .out(en));
    reflet_counter cnt2 (
        .clk(clk),
        .reset(reset),
        .enable(en),
        .max(32'd5),
        .out(update));

    reflet_7seg seg (
        .clk(clk),
        .reset(reset),
        .enable(1'b1),
        .using_colon(1'b0),
        .dots(4'b0),
        .num0(num[3:0]),
        .num1(num[7:4]),
        .num2(num[11:8]),
        .num3(num[15:12]),
        .segments(segments),
        .selection(seg_select),
        .dot(seg_dot),
        .colon(seg_colon));

    always @ (posedge clk)
        if(!reset)
            num = 0;
        else
            if(update)
                num = num + 1;

    initial
    begin
        $dumpfile("seven_seg_tb.vcd");
        $dumpvars();
        #100000;
        $finish;
    end
    
endmodule
    
