
module uart_tb();
    
    reg clk = 0;
    always #1 clk <= !clk;
    reg reset = 0;

    wire rx, tx, receive_done, end_transmit;
    wire [7:0] rx_data;
    reg [7:0] tx_data = 8'hAB;
    reg start_transmit = 0;
    reg [2:0] uart_cnt = 0;
    always @ (posedge clk)
        uart_cnt <= uart_cnt + 1;
    wire uart_en = uart_cnt == 0;

    reflet_uart_uart uart(
        .clk(clk),
        .enable(uart_en),
        .reset(reset),
        .rx(rx),
        .tx(tx),
        .data_tx(tx_data),
        .data_rx(rx_data),
        .receive_done(receive_done),
        .start_transmit(start_transmit),
        .end_transmit(end_transmit));

    shift_r shift (clk, reset, tx, rx);

    initial
    begin
        $dumpfile("uart_tb.vcd");
        $dumpvars(0, uart_tb);
        #10;
        reset <= 1;
        #300;
        start_transmit <= 1;
        #40;
        start_transmit <= 0;
        #600;
        start_transmit <= 1;
        tx_data = 8'hCD;
        #40;
        start_transmit <= 0;
        #1500;
        $finish;
    end

endmodule



module shift_r(
    input clk,
    input reset,
    input in,
    output out
    );

    reg [127:0] register;

    always @ (posedge clk) 
        if(!reset)
            register <= ~0;
        else
        begin
            register[0] = in;
            for(integer i=0; i<127; i++)
                register[i+1] <= register[i];
        end

    assign out = register[127];

endmodule

