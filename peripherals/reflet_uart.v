/*-------------------------------\
|This is the reflet UART module.   |
|The baud rate is locked at      |
|9600 bauds.                     |
\-------------------------------*/

module reflet_uart #(
    parameter wordsize = 16,
    base_addr_size = 16,
    base_addr = 16'hFF08,
    clk_frec = 1000000
    )(
    input clk,
    input reset,
    input enable,
    output interrupt,
    //system bus
    input [base_addr_size-1:0] addr,
    input write_en,
    input [wordsize-1:0] data_in,
    input [wordsize-1:0] data_out,
    //serial acces
    input rx,
    output tx
    );

    wire using_uart = enable && addr >= base_addr && addr < base_addr + 4;
    wire [1:0] offset = addr - base_addr;

    //Frequency generator
    integer mult = clk_frec / 9600;
    wire uart_en;
    reflet_counter uart_counter (
        .clk(clk), 
        .reset(reset), 
        .enable(1'b1), 
        .max(mult), 
        .out(uart_en));

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
    reflet_rw_register #(.addr_size(2), .reg_addr(0), .default_value(1)) reg_tx_cmd(
        .clk(clk),
        .reset(reset & !end_transmit),
        .enable(using_uart),
        .addr(offset),
        .write_en(write_en),
        .data_in(data_in[7:0]),
        .data_out(dout_tx_cmd),
        .data(tx_cmd));
    reflet_rw_register #(.addr_size(2), .reg_addr(1), .default_value(0)) reg_tx_data(
        .clk(clk),
        .reset(reset),
        .enable(using_uart),
        .addr(offset),
        .write_en(write_en),
        .data_in(data_in[7:0]),
        .data_out(dout_tx_data),
        .data(tx_data));
    reflet_rw_register #(.addr_size(2), .reg_addr(2), .default_value(1)) reg_rx_cmd(
        .clk(clk),
        .reset(reset & !receive_done),
        .enable(using_uart),
        .addr(offset),
        .write_en(write_en),
        .data_in(data_in[7:0]),
        .data_out(dout_rx_cmd),
        .data(rx_cmd));
    reflet_ro_register #(.addr_size(2), .reg_addr(3)) reg_rx_data(
        .clk(clk),
        .reset(reset),
        .enable(using_uart),
        .addr(offset),
        .data_out(dout_rx_data),
        .data(rx_data));
    assign data_out = dout_rx_cmd | dout_tx_cmd | dout_rx_data | dout_tx_data;

    reflet_uart_uart uart(
        .clk(clk),
        .enable(uart_en),
        .reset(reset),
        .rx(rx),
        .tx(tx),
        .data_tx(tx_data),
        .data_rx(rx_data),
        .receive_done(receive_done),
        .start_transmit(!(|tx_cmd)),
        .end_transmit(end_transmit));

    //Interrupt
    reg save_receive;
    assign interrupt = receive_done & !save_receive;
    always @ (posedge clk)
        if(!reset)
            save_receive = 0;
        else
            save_receive = receive_done;

endmodule
    
    


/*--------------------------------------------------------------------------\
|A standard UART transmiter. When receving a byte, the content              |
|of the byte will be put in data_rx and a pule will be send from            |
|receive_done. To send a byte the content of the byte must be put in data_tx|
|and a pulse of at least a UART clock cycle must be send to start_transmit. |
\--------------------------------------------------------------------------*/

module reflet_uart_uart(
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

