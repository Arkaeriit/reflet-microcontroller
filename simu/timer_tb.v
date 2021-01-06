
module timer_tb();
    
    reg clk = 0;
    always #1 clk = !clk;
    reg reset = 0;
    
    wire [7:0] data_out;
    reg [1:0] addr = 0;
    reg [7:0] data_in = 0;
    reg write_en = 0;

    wire timer_int;

    reflet_timer #(.base_addr_size(2), .base_addr(0)) timer (
    .clk(clk),
    .reset(reset),
    .enable(1'b1),
    .interrupt(timer_int),
    .addr(addr),
    .write_en(write_en),
    .data_in(data_in),
    .data_out(data_out));

    initial
    begin
        $dumpfile("timer_tb.vcd");
        $dumpvars();
        #10;
        reset = 1;
        #100;
        addr = 2;
        write_en = 1;
        data_in = 10;
        #2;
        write_en = 0;
        #100;
        addr = 1;
        write_en = 1;
        data_in = 3;
        #2;
        write_en = 0;
        #400;
        addr = 0;
        write_en = 1;
        data_in = 2;
        #2;
        write_en = 0;
        addr = 3;
        #10000;
        $finish;
    end

endmodule
    
