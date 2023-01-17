/*------------------------------------------------\
|This module listen to the debug and debug_wr of  |
|a reflet CPU and outputs the content of the      |
|working register on a UART line. It tells when   |
|doing so to be able to lock the CPU in that case.|
|The data is given in a little endian manner at   |
|9600 bauds (UART's default).                     |
\------------------------------------------------*/

module reflet_debug_helper #(
    parameter wordsize = 16,
    clk_freq = 1000000
    )(
    // Basic controls
    input clk,
    input reset,
    input enable,
    // Input from the CPU
    input debug,
    input [wordsize-1:0] debug_wr,
    // Output to the controler and outside word
    output tx,
    output reg working
    );

    reg [wordsize-1:0] target_byte_index;
    wire [wordsize-1:0] _target_byte = debug_wr >> (8 * target_byte_index);
    wire [7:0] target_byte = _target_byte[7:0];
    reg [7:0] target_byte_r;

    wire end_transmit;
    reg start_transmit;

    always @ (posedge clk)
        if (!reset)
        begin
            working <= 0;
            target_byte_index <= 0;
            start_transmit <= 0;
        end
        else if (enable)
        begin
            if (start_transmit) 
            begin
                start_transmit <= 0;
            end
            else if (end_transmit)
            begin
                if (target_byte_index == (wordsize/8))
                begin
                    working <= 0;
                    target_byte_index <= 0;
                end
                else
                begin
                    start_transmit <= 1;
                    target_byte_index <= target_byte_index + 1;
                    target_byte_r <= target_byte;
                end
            end
            else if (debug)
            begin
                start_transmit <= 1;
                target_byte_r <= target_byte;
                target_byte_index <= target_byte_index + 1;
                working <= 1;
            end
        end

        reflet_uart_uart #(.clk_freq(clk_freq)) uart (
            .clk(clk),
            .reset(reset),
            .rx(1'b1),
            .data_rx(),
            .receive_done(),
            .tx(tx),
            .data_tx(target_byte_r),
            .start_transmit(start_transmit),
            .end_transmit(end_transmit));

endmodule

