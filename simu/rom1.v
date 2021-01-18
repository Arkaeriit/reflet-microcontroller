//The code used to make this rom is in software/simuGPIO.asm
module rom1(input clk, input enable_out,input [5:0] addr, output [7:0] dataOut);
reg [7:0] ret; assign dataOut = (enable_out ? ret : 6'h0);
always @ (posedge clk)
case(addr)
  6'h0 : ret = 8'h41;
  6'h1 : ret = 8'h53;
  6'h2 : ret = 8'h52;
  6'h3 : ret = 8'h4d;
  6'h4 : ret = 8'h16;
  6'h5 : ret = 8'h3d;
  6'h6 : ret = 8'h1a;
  6'h7 : ret = 8'h8;
  6'h8 : ret = 8'h7f;
  6'h9 : ret = 8'h1a;
  6'ha : ret = 8'h18;
  6'hb : ret = 8'h31;
  6'hc : ret = 8'hf1;
  6'hd : ret = 8'h31;
  6'he : ret = 8'h11;
  6'hf : ret = 8'h41;
  6'h10 : ret = 8'h32;
  6'h11 : ret = 8'h11;
  6'h12 : ret = 8'h42;
  6'h13 : ret = 8'h33;
  6'h14 : ret = 8'h11;
  6'h15 : ret = 8'h43;
  6'h16 : ret = 8'h34;
  6'h17 : ret = 8'h11;
  6'h18 : ret = 8'h44;
  6'h19 : ret = 8'h35;
  6'h1a : ret = 8'h0;
  6'h1b : ret = 8'hf4;
  6'h1c : ret = 8'he2;
  6'h1d : ret = 8'hf5;
  6'h1e : ret = 8'h61;
  6'h1f : ret = 8'h37;
  6'h20 : ret = 8'hf3;
  6'h21 : ret = 8'h62;
  6'h22 : ret = 8'h38;
  6'h23 : ret = 8'h98;
  6'h24 : ret = 8'h62;
  6'h25 : ret = 8'h77;
  6'h26 : ret = 8'he3;
  6'h27 : ret = 8'h19;
  6'h28 : ret = 8'h39;
  6'h29 : ret = 8'hf9;
  6'h2a : ret = 8'h8;
  6'h2b : ret = 8'h0;
  6'h2c : ret = 8'h0;
  6'h2d : ret = 8'he;
  default: ret = 8'h0;
endcase
endmodule
