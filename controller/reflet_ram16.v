/*-------------------------------------\
|This module codes for a ram block with|
|the same input and output addresses.  |
|The words are 16 bits wide and each   |
|byte can be addressed.                |
\-------------------------------------*/

module reflet_ram16 #(
    parameter addrSize = 9,
    size = 2**addrSize
    )(
    input clk,
    input reset,
    input enable,
    input [addrSize-1:0] addr,
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
			for (i=0;i<size; i=i+1)
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

