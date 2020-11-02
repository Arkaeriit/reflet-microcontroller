//This simulation print Heelo, world! with the UART
module simu2();

    reg clk = 0;
    always #1 clk = !clk;
    reg reset = 0;
    wire quit;
    
    //system bus
    wire [15:0] addr;
    wire write_en;
    wire [15:0] data_in_cpu;
    wire [15:0] data_out_cpu;

    //UART
    wire rx = 1;
    wire tx;

    //modules
    wire [15:0] data_out_uart;
    wire [7:0] data_out_rom;
    wire [15:0] data_out_ram;
    asrm_uart #(16, 15, 14'h00, 96000) uart (clk, reset, addr[15], addr[14:0], write_en, data_out_cpu, data_out_uart, rx, tx);
    rom2 rom(clk, !addr[15], addr[7:0], data_out_rom);
    wire [15:0] addr_off = addr - 4;
    ram16 #(15) ram(clk, reset, addr_off[15] & addr[15], addr_off[14:0], data_out_cpu, write_en, data_out_ram);
    assign data_in_cpu = {8'h0, data_out_rom} | data_out_uart | data_out_ram;
    asrm_cpu #(16) cpu(clk, reset, quit, data_in_cpu, addr, data_out_cpu, write_en);

    initial
    begin
        #10;
        reset = 1;
    end

endmodule

