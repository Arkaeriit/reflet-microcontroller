/*----------------------------------------\
|This module codes for a ram block        |
|with the same input and output addresses.|
|Its behavior tries to mimic standard     |
|synchronous RAM.                         |
\----------------------------------------*/

module reflet_ram #(
    parameter addrSize = 7,
    dataSize = 8,
    size = 2**addrSize,
    resetable = 1
    )(
    input clk,
    input reset,
    input enable,
    input [addrSize-1:0] addr,
    input [dataSize-1:0] data_in,
    input write_en,
    output [dataSize-1:0] data_out
    );
    integer i; //loop variable

	// Declare memory 
	reg [dataSize-1:0] memory_ram [size-1:0];
    reg [dataSize-1:0] data_out_array;

    //addr control
    wire usable = enable && addr < size && reset;

	generate
		if(|resetable)
		begin
			always @(posedge clk)
				if(!reset)
				  begin
					for (i=0;i<size; i=i+1)
						memory_ram[i] <= 0;
				  end
				else
				  begin
						if(usable && write_en)
							 memory_ram[addr] <= data_in;
						data_out_array <= memory_ram[addr];
				  end
		end
		else
		begin
			always @(posedge clk)
			  begin
					if(usable && write_en)
						 memory_ram[addr] <= data_in;
					data_out_array <= memory_ram[addr];
			  end
		end
	endgenerate
				 
    assign data_out = ( usable ? data_out_array : 0 );
        
endmodule

