/*------------------------------------\
|This module combines the RAM intended|
|to be filled with instructions and   |
|the bootloader ROM.                  |
|It also takes care to initialise the |
|beguining of the instruction memory  |
|to jump to the bootloader.           |
\----------------------------------- */

module reflet_inst16 #(
    //parameter size = 32255,
    parameter size = 32,
    resetable = 1
    )(
    input clk,
    input reset,
    input enable,
    output reg inst_ready,
    //system bus
    input [14:0] addr,
    input [15:0] data_in,
    output [15:0] data_out,
    input write_en
    );

    //Initiation of the memory
    reg [3:0] addr_init;
    wire [7:0] data_in_init;

    always @ (posedge clk)
        if(!reset)
        begin
            inst_ready = 0;
            addr_init = 0;
        end
        else
        begin
            if(addr_init == 4'b1111)
                inst_ready = 1;
            else
                addr_init = addr_init + 1;
        end

    //Init ROM
    assign data_in_init = 
        ( addr_init == 4'h0 ? 8'h00 :
        ( addr_init == 4'h1 ? 8'h7E : //At addr 0, there is the addr of the bootloader
        ( addr_init == 4'h2 ? 8'h00 :
        ( addr_init == 4'h3 ? 8'h00 :
        ( addr_init == 4'h4 ? 8'h10 : //set 0
        ( addr_init == 4'h5 ? 8'hF0 : //load WR
        ( addr_init == 4'h6 ? 8'h08 : //jmp
          0)))))));


    //Input selection
    wire [14:0] addr_used = ( inst_ready ? addr : addr_init );
    wire [15:0] data_in_used = ( inst_ready ? data_in : data_in_init );
    wire write_en_used = ( inst_ready ? write_en : 1'b1 );

    //output
    wire [15:0] ram_out;
    wire [7:0] bootlader_out;
    assign data_out = ram_out | {8'h0, bootlader_out};

    //Actual memories
    reflet_ram16 #(.size(size), .addrSize(15), .resetable(resetable)) ram (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .addr(addr_used),
        .data_in(data_in_used),
        .data_out(ram_out),
        .write_en(write_en_used));

    reflet_bootloader16_rom bootloader (
        .clk(clk),
        .enable(enable),
        .addr(addr_used),
        .data_out(bootlader_out));

endmodule

