/*-------------------------------------\
|This module is the RAM ment to be used|
|in a 16 bit Reflet microcontroller. At|
|the begining, there is a small chunk  |
|of RAM whose default value is not all |
|0 but the instructions to jump to the |
|bootloader. Its content should be     |
|changed with an actual program by the |
|bootloader.                           |
\-------------------------------------*/

module reflet_inst_ram16 #(
    parameter size = 128
    )(
    input clk,
    input reset,
    input enable,
    input [14:0] addr,
    input [15:0] data_in,
    input write_en,
    output [15:0] data_out
    );
    integer i; //loop counter
    
    wire usable = enable && addr < size;

	// Declare memory 
	reg [7:0] memory_ram [size-1:0];
	
	always @(posedge clk)
		if(!reset)
        begin
            memory_ram[0] = 8'h00;
            memory_ram[1] = 8'h7E; //At address 0, there is the address of the bootloader
            memory_ram[2] = 8'h00;
            memory_ram[3] = 8'h00;
            memory_ram[4] = 8'h10; //set 0
            memory_ram[5] = 8'hF0; //load WR
            memory_ram[6] = 8'h08; //jump 
			for (i=8;i<size; i=i+1)
				memory_ram[i] = 0;
        end
		else
        begin
            if(write_en & usable)
            begin
                memory_ram[addr] = data_in[7:0];
                memory_ram[addr+1] = data_in[15:8];
            end
        end

    assign data_out = ( usable ? {memory_ram[addr+1], memory_ram[addr]} : 0 );

endmodule

