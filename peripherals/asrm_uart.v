/*-------------------------------\
|This is the asrm UART module.   |
|The baud rate is locked at      |
|9600 bauds.                     |
\-------------------------------*/

module asrm_uart #(
    parameter word_size = 16,
    base_addr_size = 16,
    base_addr = 16'hFF05,
    clk_frec = 1000000
    )(
    input clk,
    input reset,
    input enable,
    //sustem bus
    input [base_addr_size-1:0] addr,
    input write_en,
    input [word_size-1:0] data_in,
    input [word_size-1:0] data_out,
    //serial acces
    input rx,
    output tx
    );

    wire using_uart = enable && addr >= base_addr && addr <= base_addr + 4;
    wire [1:0] offset = addr - base_addr;

    //Frequency generator
    integer mult = clk_frec / 9600;
    wire uart_en;
    asrm_counter uart_counter (clk, reset, enable, mult, uart_en);

    //registers
    wire receive_done, end_transmit;
    wire [7:0] dout_tx_cmd;
    wire [7:0] dout_tx_data;
    wire [7:0] dout_rx_cmd;
    wire [7:0] dout_rx_data;
    wire [7:0] tx_cmd;
    wire [7:0] tx_data;
    wire [7:0] rx_cmd;
    wire [7:0] rx_data;
    asrm_rw_register #(2, 0, 1) reg_tx_cmd(
        clk,
        reset | end_transmit,
        using_uart,
        offset,
        write_en,
        data_in[7:0],
        dout_tx_cmd,
        tx_cmd);
    asrm_rw_register #(2, 1, 0) reg_tx_data(
        clk,
        reset,
        using_uart,
        offset,
        write_en,
        data_in[7:0],
        dout_tx_data,
        tx_data);
    asrm_rw_register #(2, 2, 1) reg_rx_cmd(
        clk,
        reset | receive_done,
        using_uart,
        offset,
        write_en,
        data_in[7:0],
        dout_rx_data,
        rx_data);
    asrm_ro_register #(2, 3) reg_rx_data(
        clk,
        reset,
        using_uart,
        offset,
        dout_rx_data,
        rx_data);
    assign data_out = dout_rx_cmd | dout_tx_cmd | dout_rx_data | dout_tx_data;

    asrm_uart_uart uart(
        clk,
        uart_en,
        reset,
        rx,
        tx,
        data_tx,
        data_rx,
        receive_done,
        !(|tx_cmd),
        end_transmit);

endmodule
    
    


/*--------------------------------------------------------------------------\
|A standard UART transmiter. When receving a byte, the content              |
|of the byte will be put in data_rx and a pule will be send from            |
|receive_done. To send a byte the content of the byte must be put in data_tx|
|and a pulse of at least a UART clock cycle must be send to start_transmit. |
\--------------------------------------------------------------------------*/

module asrm_uart_uart(
    input clk,
    input enable,                 //Should have a one tick pulse at the same frequency as the UART
    input reset,
    input rx,
    output tx,
    input [7:0] data_tx,          //Data to be send throught tx
    output reg [7:0] data_rx = 0, //data received on rx
    output receive_done,          //Rise for a clock when a message is recieved
    input start_transmit,         //When set to 1 we transmit the message
    output end_transmit           //Pulse to 1 when a transmission is finished
    );

    //registers to count the number of byte we are at
    reg [4:0] rx_count = 0;
    reg [4:0] tx_count = 0;

    // transmit
    reg tx_buzy = 0;
    reg tx_r = 1;
    assign tx = tx_r;
    assign end_transmit = tx_count > 7;

    always @(posedge clk)
        if(!reset)
        begin
            tx_count = 0;
            tx_buzy = 0;
            tx_r = 1;
        end
        else if(enable)
        begin
            if(tx_buzy)
            begin
                if(tx_count > 7) //end bit
                begin
                    tx_r = 1;
                    tx_count = 0;
                    tx_buzy = 0;
                end    
                else //data bits
                begin
                    tx_r = data_tx[tx_count];
                    tx_count = tx_count + 1;
                end
            end
            else 
                if(start_transmit)
                begin
                    tx_buzy = 1;
                    tx_r = 0; //start bit
                end
                else //rest value : 1
                    tx_r = 1;
        end
    
    //assign transmit_free = !tx_buzy //We could do this if we needed to check
    //if the transmission is possible
    
    //receive
    reg rx_buzy = 0;
    reg receive_done_r = 0;
    reg [7:0] data_rx_r = 0;
    assign receive_done = receive_done_r;

    always @ (posedge clk)
        if(!reset)
        begin
            rx_buzy = 0;
            rx_count = 0;
            data_rx_r = 0;
            receive_done_r = 0;
            data_rx = 0;
        end
        else if(enable)
        begin
            if(rx_buzy)
            begin
                if(rx_count < 8) //receiving the 8 bits
                    data_rx_r[rx_count] = rx;
                else
                begin // end of the transmission
                    receive_done_r = 1;
                    rx_buzy = 0;
                    data_rx = data_rx_r;
                end    
                rx_count = rx_count + 1;
            end
            else
                if(rx) //The message is ended for at least a clock cycle
                    receive_done_r = 0;
                else //We received the start bit
                begin
                    receive_done_r = 0;
                    rx_count = 0;
                    rx_buzy = 1;
                end
        end
    
endmodule




/*------------------------------------------\
|This module is  counter. When enabled,     |
|it will increase a register until a certain|
|value is reached. Then it will start again |
|and send a pulse.                          |
\------------------------------------------*/

module asrm_counter (
    input clk,
    input reset,
    input enable,
    input [31:0] max,
    output reg out = 0
    );

    reg [31:0] counter = 0;

    always @ (posedge clk)
        if(!reset)
        begin
            counter = 0;
            out = 0;    
        end
        else if(enable)
        begin
            if(counter == max - 1)
            begin
                counter = 0;
                out = 1;
            end
            else
            begin
                counter = counter + 1;
                out = 0;
            end
        end

endmodule

