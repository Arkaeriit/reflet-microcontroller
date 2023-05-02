// This is a test of the GPU

module simu10_tb ();

    reg clk = 0;
    always #1 clk <= !clk;
    reg reset_cpu = 0;

    wire h_sync;
    wire v_sync;
    wire [1:0] R_out;
    wire [1:0] G_out;
    wire [1:0] B_out;


    simu10_mcu #(.clk_freq(20_000_000)) mcu (
        .clk(clk),
        .reset_in(reset_cpu),
        .h_sync(h_sync),
        .v_sync(v_sync),
        .R_out(R_out),
        .G_out(G_out),
        .B_out(B_out));

    integer i;
    initial
    begin
        $dumpfile("simu10_tb.vcd");
        $dumpvars(0, simu10_tb);
        for(i = 0; i<16; i=i+1)
            $dumpvars(0, mcu.cpu.registers[i]);
        #20;
        reset_cpu <= 1;
        #1000000;
        $finish;
    end

endmodule


module simu10_mcu #(
    parameter clk_freq = 1000000
    )(
    input clk,
    input reset_in,
    output h_sync,
    output v_sync,
    output [1:0] R_out,
    output [1:0] G_out,
    output [1:0] B_out
    );

    //reset control
    wire reset, blink;
    reflet_blink reset_bootstrap(.clk(clk), .out(blink));
    assign reset = reset_in & !blink;

    //system bus and interrupt request
    wire [15:0] addr;
    wire [15:0] data_out_cpu;
    wire [15:0] data_in_cpu;
    wire write_en;
    wire [3:0] interrupt_request;
    wire cpu_enable;

    //cpu
    reflet_cpu #(.wordsize(16)) cpu (
        .clk(clk),
        .reset(reset),
        .enable(cpu_enable),
        .data_in(data_in_cpu),
        .data_out(data_out_cpu),
        .addr(addr),
        .write_en(write_en),
        .quit(quit),
        .debug(debug),
        .interrupt_request(interrupt_request));

    //memory map
    wire [15:0] dout_inst;
    wire [15:0] dout_data;
    wire [7:0] dout_periph;
    wire [7:0] din_periph = (addr[0] ? data_out_cpu[15:8] : data_out_cpu[7:0]);
    wire [15:0] dout_periph_shift = (addr[0] ? {dout_periph, 8'h0} : {8'h0, dout_periph});
    assign data_in_cpu = dout_inst | dout_data | dout_periph_shift;
    //0x00 to 0x7FFF: instruction.
    rom10 rom (
        .clk(clk),
        .enable(!addr[15]),
        .addr(addr[14:1]),
        .data(dout_inst));

    //0x8000 to 0xFEFF: data. Should stay as a regular RAM
    reflet_ram #(.addrSize(14), .dataSize(16), .size(100)) mem_data (
        .clk(clk),
        .reset(reset),
        .enable(addr[15]),
        .addr(addr[14:1]),
        .data_in(data_out_cpu),
        .data_out(dout_data),
        .write_en(write_en));

    //0xFF00 to 0xFFFF: peripherals
    reflet_peripheral #(
        .wordsize(16), 
        .base_addr_size(15), 
        .base_addr(15'h7F00), 
        .clk_freq(clk_freq),
        .mem_resetable(1),
        .enable_interrupt_mux(0),
        .enable_gpio(0),
        .enable_timer(0),
        .enable_timer2(0),
        .enable_uart(1),
        .enable_pwm(0),
        .enable_synth(1),
        .enable_segments(0),
        .enable_synth(0),
        .enable_ext_io(0),
        .enable_vga(1),
        .enable_power_manager(0)) 
    periph (
        .clk(clk),
        .reset(reset),
        .enable(addr[15]),
        .interrupt_request(interrupt_request),
        .cpu_enable(cpu_enable),
        .rx(1'b1),
        .addr(addr[14:0]),
        .data_in(din_periph),
        .data_out(dout_periph),
        .write_en(write_en),
        .h_sync(h_sync),
        .v_sync(v_sync),
        .R_out(R_out),
        .G_out(G_out),
        .B_out(B_out));

endmodule

