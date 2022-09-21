/*-----------------------------------\
|This module contains an UART and use|
|it to send a given message in a loop|
\-----------------------------------*/

module uart_sending_msg #(
    parameter clk_freq = 1000000,
    baud_rate = 9600,
    msg_size_byte =2
    )(
    input clk,
    input reset,
    input [8*msg_size_byte-1:0] msg,
    input rx,
    output tx
    );

    reg [$clog2(msg_size_byte)+1:0] byte_index;
    wire [$clog2(msg_size_byte)+1:0] byte_index_max = msg_size_byte;
    wire end_transmit, receive_done;
    reg start_transmit, start_transmit_sl;

    always @ (posedge clk)
        if (!reset)
        begin
            byte_index <= 0;
            start_transmit <= 0;
            start_transmit_sl <= 1;
        end
        else
        begin
            if (end_transmit)
                byte_index <= byte_index + 1;
            start_transmit <= start_transmit_sl;
            if (byte_index+1 < byte_index_max)
                start_transmit_sl <= end_transmit;
            else
                start_transmit_sl <= 0;
        end

    wire [8*msg_size_byte-1:0] shifted_msg = msg >> (byte_index * 8);
    wire [7:0] byte_to_send = shifted_msg[7:0];
    wire [7:0] data_rx;
    
    // Actual UART
    reflet_uart_uart #(.clk_freq(clk_freq), .baud_rate(baud_rate)) uart (
        .clk(clk),
        .reset(reset),
        .rx(rx),
        .tx(tx),
        .data_tx(byte_to_send),
        .data_rx(data_rx),
        .receive_done(receive_done),
        .start_transmit(start_transmit),
        .end_transmit(end_transmit));

endmodule

