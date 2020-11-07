//this simulation makes the MSB of gpo blink
//and makes the 15 LSB of gpi being copied to gpo
module simu1();

    reg clk = 0;
    always #1 clk = !clk;
    reg reset = 0;
    wire quit;
    
    //system bus
    wire [7:0] addr;
    wire write_en;
    wire [7:0] data_in_cpu;
    wire [7:0] data_out_cpu;

    //GPIO
    reg [15:0] gpi = 0;
    wire [15:0] gpo;

    //modules
    wire [7:0] data_out_gpio;
    wire [7:0] data_out_rom;
    asrm_gpio #(.wordsize(8), .base_addr_size(7), .base_addr(7'h00)) gpio(
        .clk(clk), 
        .reset(reset), 
        .enable(addr[7]), 
        .addr(addr[6:0]), 
        .write_en(write_en), 
        .data_in(data_out_cpu), 
        .data_out(data_out_gpio), 
        .gpi(gpi), 
        .gpo(gpo));
    rom1 rom(
        .clk(clk), 
        .enable_out(!addr[7]), 
        .addr(addr[5:0]), 
        .dataOut(data_out_rom));
    assign data_in_cpu = data_out_rom | data_out_gpio;
    asrm_cpu #(.wordsize(8)) cpu(
        .clk(clk), 
        .reset(reset), 
        .quit(quit), 
        .data_in(data_in_cpu), 
        .addr(addr), 
        .data_out(data_out_cpu), 
        .write_en(write_en));

    initial
    begin
        #10;
        reset = 1;
        #1000;
        gpi = 16'hABCD;
    end

endmodule

