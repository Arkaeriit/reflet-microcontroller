/*--------------------------------------------------------\
|This module contains an UART and use it to send messages.|
|It sends all chars form 0 to 255 and repeats.            |
\--------------------------------------------------------*/

module uart_sending #(
    parameter clk_freq = 1000000,
    baud_rate = 9600 
    )(
    input clk,
    input reset,
    input rx,
    output tx
    );

    // Unused monitor wires
    wire receive_done;
    wire data_rx;

    // Choosing what data to send
    reg [7:0] data_tx;
    reg start_transmit, start_transmit_sl;
    wire end_transmit;
    always @ (posedge clk)
        if(!reset)
        begin
            start_transmit <= 0;
            start_transmit_sl <= 1;
            data_tx <= 0;
        end
        else
        begin
            if(end_transmit)
                data_tx <= data_tx + 1;
            start_transmit <= start_transmit_sl;
            start_transmit_sl <= end_transmit;
        end

    // Actual UART
    reflet_uart_uart #(.clk_freq(clk_freq), .baud_rate(baud_rate)) uart (
        .clk(clk),
        .reset(reset),
        .rx(rx),
        .tx(tx),
        .data_tx(data_tx),
        .data_rx(data_rx),
        .receive_done(receive_done),
        .start_transmit(start_transmit),
        .end_transmit(end_transmit));

endmodule

