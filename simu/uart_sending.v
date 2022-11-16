/*--------------------------------------------------------\
|This module contains an UART and use it to send messages.|
|It sends all chars form 0 to 255 once.                   |
\--------------------------------------------------------*/

module uart_sending #(
    parameter clk_freq = 1000000,
    baud_rate = 9600,
    wait_time = 1

    )(
    input clk,
    input reset,
    input rx,
    output tx
    );

    uart_sending_msg #(.clk_freq(clk_freq), .baud_rate(baud_rate), .msg_size_byte(256), .wait_time(wait_time)) uart (
        .clk(clk),
        .reset(reset),
        .rx(rx),
        .tx(tx),
        .msg(2048'hFFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F0EFEEEDECEBEAE9E8E7E6E5E4E3E2E1E0DFDEDDDCDBDAD9D8D7D6D5D4D3D2D1D0CFCECDCCCBCAC9C8C7C6C5C4C3C2C1C0BFBEBDBCBBBAB9B8B7B6B5B4B3B2B1B0AFAEADACABAAA9A8A7A6A5A4A3A2A1A09F9E9D9C9B9A999897969594939291908F8E8D8C8B8A898887868584838281807F7E7D7C7B7A797877767574737271706F6E6D6C6B6A696867666564636261605F5E5D5C5B5A595857565554535251504F4E4D4C4B4A494847464544434241403F3E3D3C3B3A393837363534333231302F2E2D2C2B2A292827262524232221201F1E1D1C1B1A191817161514131211100F0E0D0C0B0A09080706050403020100));

endmodule

