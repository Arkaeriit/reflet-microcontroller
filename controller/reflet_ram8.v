/*----------------------------------------\
|This module codes for a 8-bit ram block  |
|with the same input and output addresses.|
\----------------------------------------*/

module reflet_ram8 #(
    parameter addrSize = 7,
    size = 128
    )(
    input clk,
    input reset,
    input enable,
    input [addrSize-1:0] addr,
    input [7:0] data_in,
    input write_en,
    output [7:0] data_out
    );

	// Declare memory 
	reg [7:0] memory_ram [size-1:0];

    //addr control
    wire usable = enable && addr < size;
	
	always @(posedge clk)
		if(!reset)
        begin
			for (integer i=0;i<size; i=i+1)
				memory_ram[i] = 0;
        end
		else
        begin
            if(usable && write_en)
                memory_ram[addr] = data_in;
        end

    assign data_out = ( usable ? memory_ram[addr] : 0 );
        
endmodule

