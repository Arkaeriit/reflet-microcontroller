/*--------------------------------------\
|This module integrate the seven segment|
|display into a reflet peripheral. It is|
|assumed that a value of 0 in the output|
|value means that the segment is on.    |
\--------------------------------------*/

module reflet_seven_segments #(
    parameter base_addr_size = 16,
    base_addr = 16'hFF10
    )(
    input clk,
    input reset,
    input enable,
    //system bus
    input [base_addr_size-1:0] addr,
    input [7:0] data_in,
    output [7:0] data_out,
    input write_en,
    //display connection
    output [6:0] segments,
    output [3:0] selection,
    output dot,
    output colon
    );

    //access control
    wire using_segment = enable && addr >= base_addr && addr < base_addr + 3;
    wire [1:0] offset = addr - base_addr;

    //registers
    wire [7:0] dout_ctrl;
    wire [7:0] dout_num01;
    wire [7:0] dout_num23;
    wire [7:0] ctrl;
    wire [7:0] num01;
    wire [7:0] num23;
    assign data_out = dout_ctrl | dout_num01 | dout_num23;
    reflet_rw_register #(.addr_size(2), .reg_addr(0), .default_value(0)) reg_ctrl(
        .clk(clk),
        .reset(reset),
        .enable(using_segment),
        .addr(offset),
        .write_en(write_en),
        .data_in(data_in[7:0]),
        .data_out(dout_ctrl),
        .data(ctrl));
    reflet_rw_register #(.addr_size(2), .reg_addr(1), .default_value(0)) reg_num01(
        .clk(clk),
        .reset(reset),
        .enable(using_segment),
        .addr(offset),
        .write_en(write_en),
        .data_in(data_in[7:0]),
        .data_out(dout_num01),
        .data(num01));
    reflet_rw_register #(.addr_size(2), .reg_addr(2), .default_value(0)) reg_num23(
        .clk(clk),
        .reset(reset),
        .enable(using_segment),
        .addr(offset),
        .write_en(write_en),
        .data_in(data_in[7:0]),
        .data_out(dout_num23),
        .data(num23));

    //The actual driver
    reflet_7seg seg7 (
        .clk(clk),
        .reset(reset),
        .enable(ctrl[0]),
        .using_colon(ctrl[1]),
        .dots(ctrl[7:4]),
        .num0(num01[3:0]),
        .num1(num01[7:4]),
        .num2(num23[3:0]),
        .num3(num23[7:4]),
        .segments(segments),
        .selection(selection),
        .dot(dot),
        .colon(colon));

endmodule



/*------------------------------\
|This is a seven segment driver.|
\------------------------------*/

module reflet_7seg (
    input clk,
    input reset,
    input enable,
    //configuration
    input using_colon,
    input [3:0] dots,
    input [3:0] num0,
    input [3:0] num1,
    input [3:0] num2,
    input [3:0] num3,
    //output
    output [6:0] segments,
    output [3:0] selection,
    output dot,
    output colon
    );

    wire [6:0] num_segments [3:0];
    reflet_number_to_segment seg0(num0, num_segments[0]);
    reflet_number_to_segment seg1(num1, num_segments[1]);
    reflet_number_to_segment seg2(num2, num_segments[2]);
    reflet_number_to_segment seg3(num3, num_segments[3]);
    
    reg [10:0] cnt_r;
    wire [1:0] cnt = cnt_r[10:9];
    always @ (posedge clk)
        if(!reset)
            cnt_r = 0;
        else
            cnt_r = cnt_r + 1;

    assign segments = num_segments[cnt];
    assign selection = 
        ( !enable  ? 4'b0000 :
        ( cnt == 0 ? 4'b0001 :
        ( cnt == 1 ? 4'b0010 :
        ( cnt == 2 ? 4'b0100 :
        /*3*/        4'b1000))));
    assign colon = !using_colon;
    assign dot = !dots[cnt];

endmodule
                    
    

/*----------------------------\
|This module convert a number |
|in its base 16 representation|
|on a seven sement display.   |
|Output = 0 means the segment |
|is on.                       |
\----------------------------*/

/*A-\
|   |
F   B
|   |
|-G-|
|   |
E   C
|   |
\-D*/

module reflet_number_to_segment (
    input [3:0] number,
    output [6:0] segments
    );

    assign segments =
        ( number == 4'h0 ? 7'b1000000 :
        ( number == 4'h1 ? 7'b1111001 :
        ( number == 4'h2 ? 7'b0100100 :
        ( number == 4'h3 ? 7'b0110000 :
        ( number == 4'h4 ? 7'b0011001 :
        ( number == 4'h5 ? 7'b0010010 :
        ( number == 4'h6 ? 7'b0000010 :
        ( number == 4'h7 ? 7'b1111000 :
        ( number == 4'h8 ? 7'b0000000 :
        ( number == 4'h9 ? 7'b0010000 :
        ( number == 4'hA ? 7'b0001000 :
        ( number == 4'hB ? 7'b0000011 :
        ( number == 4'hC ? 7'b1000110 :
        ( number == 4'hD ? 7'b0100001 :
        ( number == 4'hE ? 7'b0000110 :
          /* 4'hF*/        7'b0001110 )))))))))))))));
		  
endmodule

