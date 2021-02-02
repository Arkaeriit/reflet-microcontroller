//This rom is made with a sloghly modified vertion of ../software/clock.asm
module rom5(input clk, input enable_out,input [8:0] addr, output [7:0] dataOut);
reg [7:0] ret; assign dataOut = (enable_out ? ret : 9'h0);
always @ (posedge clk)
case(addr)
  9'h0 : ret = 8'h41;
  9'h1 : ret = 8'h53;
  9'h2 : ret = 8'h52;
  9'h3 : ret = 8'h4d;
  9'h4 : ret = 8'h14;
  9'h5 : ret = 8'h3c;
  9'h6 : ret = 8'h10;
  9'h7 : ret = 8'h3b;
  9'h8 : ret = 8'h10;
  9'h9 : ret = 8'h7b;
  9'ha : ret = 8'hac;
  9'hb : ret = 8'h3b;
  9'hc : ret = 8'h11;
  9'hd : ret = 8'h7b;
  9'he : ret = 8'hac;
  9'hf : ret = 8'h3b;
  9'h10 : ret = 8'h18;
  9'h11 : ret = 8'h7b;
  9'h12 : ret = 8'hac;
  9'h13 : ret = 8'h3b;
  9'h14 : ret = 8'h13;
  9'h15 : ret = 8'h7b;
  9'h16 : ret = 8'h3f;
  9'h17 : ret = 8'h14;
  9'h18 : ret = 8'h3c;
  9'h19 : ret = 8'h10;
  9'h1a : ret = 8'h3b;
  9'h1b : ret = 8'h10;
  9'h1c : ret = 8'h7b;
  9'h1d : ret = 8'hac;
  9'h1e : ret = 8'h3b;
  9'h1f : ret = 8'h10;
  9'h20 : ret = 8'h7b;
  9'h21 : ret = 8'hac;
  9'h22 : ret = 8'h3b;
  9'h23 : ret = 8'h12;
  9'h24 : ret = 8'h7b;
  9'h25 : ret = 8'hac;
  9'h26 : ret = 8'h3b;
  9'h27 : ret = 8'h1a;
  9'h28 : ret = 8'h7b;
  9'h29 : ret = 8'h3E;
  9'h2a : ret = 8'h14;
  9'h2b : ret = 8'h3c;
  9'h2c : ret = 8'h10;
  9'h2d : ret = 8'h3b;
  9'h2e : ret = 8'h18;
  9'h2f : ret = 8'h7b;
  9'h30 : ret = 8'hac;
  9'h31 : ret = 8'h3b;
  9'h32 : ret = 8'h10;
  9'h33 : ret = 8'h7b;
  9'h34 : ret = 8'hac;
  9'h35 : ret = 8'h3b;
  9'h36 : ret = 8'h10;
  9'h37 : ret = 8'h7b;
  9'h38 : ret = 8'hac;
  9'h39 : ret = 8'h3b;
  9'h3a : ret = 8'h10;
  9'h3b : ret = 8'h7b;
  9'h3c : ret = 8'h3f;
  9'h3d : ret = 8'h14;
  9'h3e : ret = 8'h3c;
  9'h3f : ret = 8'h10;
  9'h40 : ret = 8'h3b;
  9'h41 : ret = 8'h1f;
  9'h42 : ret = 8'h7b;
  9'h43 : ret = 8'hac;
  9'h44 : ret = 8'h3b;
  9'h45 : ret = 8'h1f;
  9'h46 : ret = 8'h7b;
  9'h47 : ret = 8'hac;
  9'h48 : ret = 8'h3b;
  9'h49 : ret = 8'h11;
  9'h4a : ret = 8'h7b;
  9'h4b : ret = 8'hac;
  9'h4c : ret = 8'h3b;
  9'h4d : ret = 8'h1c;
  9'h4e : ret = 8'h7b;
  9'h4f : ret = 8'h31;
  9'h50 : ret = 8'h13;
  9'h51 : ret = 8'he1;
  9'h52 : ret = 8'h14;
  9'h53 : ret = 8'h3c;
  9'h54 : ret = 8'h10;
  9'h55 : ret = 8'h3b;
  9'h56 : ret = 8'h1f;
  9'h57 : ret = 8'h7b;
  9'h58 : ret = 8'hac;
  9'h59 : ret = 8'h3b;
  9'h5a : ret = 8'h1f;
  9'h5b : ret = 8'h7b;
  9'h5c : ret = 8'hac;
  9'h5d : ret = 8'h3b;
  9'h5e : ret = 8'h11;
  9'h5f : ret = 8'h7b;
  9'h60 : ret = 8'hac;
  9'h61 : ret = 8'h3b;
  9'h62 : ret = 8'h10;
  9'h63 : ret = 8'h7b;
  9'h64 : ret = 8'h32;
  9'h65 : ret = 8'h14;
  9'h66 : ret = 8'h3c;
  9'h67 : ret = 8'h10;
  9'h68 : ret = 8'h3b;
  9'h69 : ret = 8'h10;
  9'h6a : ret = 8'h7b;
  9'h6b : ret = 8'hac;
  9'h6c : ret = 8'h3b;
  9'h6d : ret = 8'h10;
  9'h6e : ret = 8'h7b;
  9'h6f : ret = 8'hac;
  9'h70 : ret = 8'h3b;
  9'h71 : ret = 8'h10;
  9'h72 : ret = 8'h7b;
  9'h73 : ret = 8'hac;
  9'h74 : ret = 8'h3b;
  9'h75 : ret = 8'h13;
  9'h76 : ret = 8'h7b;
  9'h77 : ret = 8'he2;
  9'h78 : ret = 8'hb;
  9'h79 : ret = 8'h11;
  9'h7a : ret = 8'h42;
  9'h7b : ret = 8'h32;
  9'h7c : ret = 8'ha;
  9'h7d : ret = 8'he2;
  9'h7e : ret = 8'hb;
  9'h7f : ret = 8'h11;
  9'h80 : ret = 8'h42;
  9'h81 : ret = 8'h32;
  9'h82 : ret = 8'h14;
  9'h83 : ret = 8'h3c;
  9'h84 : ret = 8'h10;
  9'h85 : ret = 8'h3b;
  9'h86 : ret = 8'h1f;
  9'h87 : ret = 8'h7b;
  9'h88 : ret = 8'hac;
  9'h89 : ret = 8'h3b;
  9'h8a : ret = 8'h1f;
  9'h8b : ret = 8'h7b;
  9'h8c : ret = 8'hac;
  9'h8d : ret = 8'h3b;
  9'h8e : ret = 8'h10;
  9'h8f : ret = 8'h7b;
  9'h90 : ret = 8'hac;
  9'h91 : ret = 8'h3b;
  9'h92 : ret = 8'h10;
  9'h93 : ret = 8'h7b;
  9'h94 : ret = 8'h33;
  9'h95 : ret = 8'hf3;
  9'h96 : ret = 8'he2;
  9'h97 : ret = 8'h11;
  9'h98 : ret = 8'h42;
  9'h99 : ret = 8'h32;
  9'h9a : ret = 8'h11;
  9'h9b : ret = 8'he2;
  9'h9c : ret = 8'h42;
  9'h9d : ret = 8'h32;
  9'h9e : ret = 8'ha;
  9'h9f : ret = 8'he2;
  9'ha0 : ret = 8'h11;
  9'ha1 : ret = 8'h42;
  9'ha2 : ret = 8'h32;
  9'ha3 : ret = 8'h11;
  9'ha4 : ret = 8'he2;
  9'ha5 : ret = 8'h14;
  9'ha6 : ret = 8'h43;
  9'ha7 : ret = 8'h33;
  9'ha8 : ret = 8'h18;
  9'ha9 : ret = 8'he3;
  9'haa : ret = 8'h13;
  9'hab : ret = 8'h43;
  9'hac : ret = 8'h33;
  9'had : ret = 8'h14;
  9'hae : ret = 8'h3c;
  9'haf : ret = 8'h10;
  9'hb0 : ret = 8'h3b;
  9'hb1 : ret = 8'h10;
  9'hb2 : ret = 8'h7b;
  9'hb3 : ret = 8'hac;
  9'hb4 : ret = 8'h3b;
  9'hb5 : ret = 8'h10;
  9'hb6 : ret = 8'h7b;
  9'hb7 : ret = 8'hac;
  9'hb8 : ret = 8'h3b;
  9'hb9 : ret = 8'h1d;
  9'hba : ret = 8'h7b;
  9'hbb : ret = 8'hac;
  9'hbc : ret = 8'h3b;
  9'hbd : ret = 8'h19;
  9'hbe : ret = 8'h7b;
  9'hbf : ret = 8'h4;
  9'hc0 : ret = 8'h18;
  9'hc1 : ret = 8'h3d;
  9'hc2 : ret = 8'h14;
  9'hc3 : ret = 8'h32;
  9'hc4 : ret = 8'h14;
  9'hc5 : ret = 8'h3c;
  9'hc6 : ret = 8'h10;
  9'hc7 : ret = 8'h3b;
  9'hc8 : ret = 8'h10;
  9'hc9 : ret = 8'h7b;
  9'hca : ret = 8'hac;
  9'hcb : ret = 8'h3b;
  9'hcc : ret = 8'h10;
  9'hcd : ret = 8'h7b;
  9'hce : ret = 8'hac;
  9'hcf : ret = 8'h3b;
  9'hd0 : ret = 8'h1d;
  9'hd1 : ret = 8'h7b;
  9'hd2 : ret = 8'hac;
  9'hd3 : ret = 8'h3b;
  9'hd4 : ret = 8'h16;
  9'hd5 : ret = 8'h7b;
  9'hd6 : ret = 8'h0;
  9'hd7 : ret = 8'h0;
  9'hd8 : ret = 8'h3E;
  9'hd9 : ret = 8'hb;
  9'hda : ret = 8'h10;
  9'hdb : ret = 8'he3;
  9'hdc : ret = 8'h11;
  9'hdd : ret = 8'h41;
  9'hde : ret = 8'h34;
  9'hdf : ret = 8'h14;
  9'he0 : ret = 8'h3c;
  9'he1 : ret = 8'h10;
  9'he2 : ret = 8'h3b;
  9'he3 : ret = 8'h10;
  9'he4 : ret = 8'h7b;
  9'he5 : ret = 8'hac;
  9'he6 : ret = 8'h3b;
  9'he7 : ret = 8'h11;
  9'he8 : ret = 8'h7b;
  9'he9 : ret = 8'hac;
  9'hea : ret = 8'h3b;
  9'heb : ret = 8'h14;
  9'hec : ret = 8'h7b;
  9'hed : ret = 8'hac;
  9'hee : ret = 8'h3b;
  9'hef : ret = 8'h17;
  9'hf0 : ret = 8'h7b;
  9'hf1 : ret = 8'hc;
  9'hf2 : ret = 8'hf4;
  9'hf3 : ret = 8'h35;
  9'hf4 : ret = 8'h14;
  9'hf5 : ret = 8'h3c;
  9'hf6 : ret = 8'h10;
  9'hf7 : ret = 8'h3b;
  9'hf8 : ret = 8'h10;
  9'hf9 : ret = 8'h7b;
  9'hfa : ret = 8'hac;
  9'hfb : ret = 8'h3b;
  9'hfc : ret = 8'h10;
  9'hfd : ret = 8'h7b;
  9'hfe : ret = 8'hac;
  9'hff : ret = 8'h3b;
  9'h100 : ret = 8'h16;
  9'h101 : ret = 8'h7b;
  9'h102 : ret = 8'hac;
  9'h103 : ret = 8'h3b;
  9'h104 : ret = 8'h10;
  9'h105 : ret = 8'h7b;
  9'h106 : ret = 8'hc5;
  9'h107 : ret = 8'h14;
  9'h108 : ret = 8'h3c;
  9'h109 : ret = 8'h10;
  9'h10a : ret = 8'h3b;
  9'h10b : ret = 8'h10;
  9'h10c : ret = 8'h7b;
  9'h10d : ret = 8'hac;
  9'h10e : ret = 8'h3b;
  9'h10f : ret = 8'h11;
  9'h110 : ret = 8'h7b;
  9'h111 : ret = 8'hac;
  9'h112 : ret = 8'h3b;
  9'h113 : ret = 8'h11;
  9'h114 : ret = 8'h7b;
  9'h115 : ret = 8'hac;
  9'h116 : ret = 8'h3b;
  9'h117 : ret = 8'h1c;
  9'h118 : ret = 8'h7b;
  9'h119 : ret = 8'h9;
  9'h11a : ret = 8'ha;
  9'h11b : ret = 8'h2;
  9'h11c : ret = 8'h10;
  9'h11d : ret = 8'he4;
  9'h11e : ret = 8'h11;
  9'h11f : ret = 8'h44;
  9'h120 : ret = 8'h34;
  9'h121 : ret = 8'h14;
  9'h122 : ret = 8'h3c;
  9'h123 : ret = 8'h10;
  9'h124 : ret = 8'h3b;
  9'h125 : ret = 8'h10;
  9'h126 : ret = 8'h7b;
  9'h127 : ret = 8'hac;
  9'h128 : ret = 8'h3b;
  9'h129 : ret = 8'h11;
  9'h12a : ret = 8'h7b;
  9'h12b : ret = 8'hac;
  9'h12c : ret = 8'h3b;
  9'h12d : ret = 8'h14;
  9'h12e : ret = 8'h7b;
  9'h12f : ret = 8'hac;
  9'h130 : ret = 8'h3b;
  9'h131 : ret = 8'h17;
  9'h132 : ret = 8'h7b;
  9'h133 : ret = 8'hc;
  9'h134 : ret = 8'h14;
  9'h135 : ret = 8'h3c;
  9'h136 : ret = 8'h10;
  9'h137 : ret = 8'h3b;
  9'h138 : ret = 8'h10;
  9'h139 : ret = 8'h7b;
  9'h13a : ret = 8'hac;
  9'h13b : ret = 8'h3b;
  9'h13c : ret = 8'h11;
  9'h13d : ret = 8'h7b;
  9'h13e : ret = 8'hac;
  9'h13f : ret = 8'h3b;
  9'h140 : ret = 8'h11;
  9'h141 : ret = 8'h7b;
  9'h142 : ret = 8'hac;
  9'h143 : ret = 8'h3b;
  9'h144 : ret = 8'h1a;
  9'h145 : ret = 8'h7b;
  9'h146 : ret = 8'h3E;
  9'h147 : ret = 8'hf4;
  9'h148 : ret = 8'h35;
  9'h149 : ret = 8'h11;
  9'h14a : ret = 8'h45;
  9'h14b : ret = 8'h35;
  9'h14c : ret = 8'h1f;
  9'h14d : ret = 8'h65;
  9'h14e : ret = 8'h36;
  9'h14f : ret = 8'h1a;
  9'h150 : ret = 8'hc6;
  9'h151 : ret = 8'h14;
  9'h152 : ret = 8'h3c;
  9'h153 : ret = 8'h10;
  9'h154 : ret = 8'h3b;
  9'h155 : ret = 8'h10;
  9'h156 : ret = 8'h7b;
  9'h157 : ret = 8'hac;
  9'h158 : ret = 8'h3b;
  9'h159 : ret = 8'h11;
  9'h15a : ret = 8'h7b;
  9'h15b : ret = 8'hac;
  9'h15c : ret = 8'h3b;
  9'h15d : ret = 8'h16;
  9'h15e : ret = 8'h7b;
  9'h15f : ret = 8'hac;
  9'h160 : ret = 8'h3b;
  9'h161 : ret = 8'h17;
  9'h162 : ret = 8'h7b;
  9'h163 : ret = 8'h9;
  9'h164 : ret = 8'h25;
  9'h165 : ret = 8'he4;
  9'h166 : ret = 8'hd;
  9'h167 : ret = 8'h14;
  9'h168 : ret = 8'h36;
  9'h169 : ret = 8'hf4;
  9'h16a : ret = 8'hb6;
  9'h16b : ret = 8'h35;
  9'h16c : ret = 8'h11;
  9'h16d : ret = 8'h45;
  9'h16e : ret = 8'ha6;
  9'h16f : ret = 8'h35;
  9'h170 : ret = 8'h14;
  9'h171 : ret = 8'h3c;
  9'h172 : ret = 8'h10;
  9'h173 : ret = 8'h3b;
  9'h174 : ret = 8'h10;
  9'h175 : ret = 8'h7b;
  9'h176 : ret = 8'hac;
  9'h177 : ret = 8'h3b;
  9'h178 : ret = 8'h11;
  9'h179 : ret = 8'h7b;
  9'h17a : ret = 8'hac;
  9'h17b : ret = 8'h3b;
  9'h17c : ret = 8'h16;
  9'h17d : ret = 8'h7b;
  9'h17e : ret = 8'hac;
  9'h17f : ret = 8'h3b;
  9'h180 : ret = 8'h14;
  9'h181 : ret = 8'h7b;
  9'h182 : ret = 8'h3E;
  default: ret = 8'h0;
endcase
endmodule
