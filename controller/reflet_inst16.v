/*------------------------------------\
|This module combines the RAM intended|
|to be filled with instructions and   |
|the bootloader ROM.                  |
|It also takes care to initialise the |
|beguining of the instruction memory  |
|to jump to the bootloader.           |
\----------------------------------- */

module reflet_inst16 #(
    parameter size = 10000,
    resetable = 1,
    swift_bootloader = 0
    )(
    input clk,
    input reset,
    input enable,
    output reg inst_ready,
    //system bus
    input [13:0] addr,
    input [15:0] data_in,
    output [15:0] data_out,
    input write_en
    );

    //Initiation of the memory
    reg [2:0] addr_init;
    wire [15:0] data_in_init;

    always @ (posedge clk)
        if(!reset)
        begin
            inst_ready <= 0;
            addr_init <= 0;
        end
        else
        begin
            if(addr_init == 3'b111)
                inst_ready <= 1;
            else
                addr_init <= addr_init + 1;
        end

    //Init ROM
    assign data_in_init = 
        ( addr_init == 3'h0 ? 16'h7D00 : //At addr 0, there is the addr of the bootloader
        ( addr_init == 3'h1 ? 16'h0000 :
        ( addr_init == 3'h2 ? 16'hd020 : //set 0; load WR
        ( addr_init == 3'h3 ? 16'h001E : //jmp
          0))));

    //Input selection
    wire [13:0] addr_used = ( inst_ready ? addr : {11'h0, addr_init} );
    wire [15:0] data_in_used = ( inst_ready ? data_in : data_in_init );
    wire write_en_used = ( inst_ready ? write_en : 1'b1 );

    //output
    wire [15:0] ram_out;
    wire [15:0] bootlader_out;
    assign data_out = ram_out | bootlader_out;

    //Address validation
    wire [13:0] bl_start_addr = 14'h3E80;
    wire ram_en = (addr_used < bl_start_addr) && (enable || !inst_ready);
    wire bl_en = enable && (addr_used >= bl_start_addr);

    //Actual memories
    reflet_ram #(.size(size), .dataSize(16), .addrSize(14), .resetable(resetable)) ram (
        .clk(clk),
        .reset(reset),
        .enable(ram_en),
        .addr(addr_used),
        .data_in(data_in_used),
        .data_out(ram_out),
        .write_en(write_en_used));

    generate
        if (swift_bootloader)
            reflet_bootloader16_swift_rom bootloader (
                .clk(clk),
                .enable(bl_en),
                .addr(addr_used),
                .data(bootlader_out));
        else
            reflet_bootloader16_rom bootloader (
                .clk(clk),
                .enable(bl_en),
                .addr(addr_used),
                .data(bootlader_out));
    endgenerate

endmodule

