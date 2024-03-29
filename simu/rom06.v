//The software used to make this ROM is software/low_power_mode.asm
module rom06(input clk, input enable, input [9-1:0] addr, output [16-1:0] data);
    reg [16-1:0] data_reg;
    always @ (posedge clk)
        case(addr)
            9'h0 : data_reg <= 16'h5341;
            9'h1 : data_reg <= 16'h4D52;
            9'h2 : data_reg <= 16'h2D3C;
            9'h3 : data_reg <= 16'h2C3B;
            9'h4 : data_reg <= 16'h3D10;
            9'h5 : data_reg <= 16'h3C12;
            9'h6 : data_reg <= 16'h0000;
            9'h7 : data_reg <= 16'h0000;
            9'h8 : data_reg <= 16'h4C12;
            9'h9 : data_reg <= 16'h3E4E;
            9'hA : data_reg <= 16'h0236;
            9'hB : data_reg <= 16'h4C13;
            9'hC : data_reg <= 16'h4E08;
            9'hD : data_reg <= 16'h3CF0;
            9'hE : data_reg <= 16'h3D2B;
            9'hF : data_reg <= 16'h3F2C;
            9'h10 : data_reg <= 16'h2D3C;
            9'h11 : data_reg <= 16'h2C3B;
            9'h12 : data_reg <= 16'h3D10;
            9'h13 : data_reg <= 16'h3C12;
            9'h14 : data_reg <= 16'h0000;
            9'h15 : data_reg <= 16'h0000;
            9'h16 : data_reg <= 16'h4C12;
            9'h17 : data_reg <= 16'h3E4E;
            9'h18 : data_reg <= 16'h0054;
            9'h19 : data_reg <= 16'h4C13;
            9'h1A : data_reg <= 16'h4E08;
            9'h1B : data_reg <= 16'h3CF0;
            9'h1C : data_reg <= 16'h3D2B;
            9'h1D : data_reg <= 16'h3E2C;
            9'h1E : data_reg <= 16'h8000;
            9'h1F : data_reg <= 16'hFF00;
            9'h20 : data_reg <= 16'hFF04;
            9'h21 : data_reg <= 16'hFF08;
            9'h22 : data_reg <= 16'hFF10;
            9'h23 : data_reg <= 16'hFF13;
            9'h24 : data_reg <= 16'hFF16;
            9'h25 : data_reg <= 16'hFF1A;
            9'h26 : data_reg <= 16'hFF1C;
            9'h27 : data_reg <= 16'hFF1F;
            9'h28 : data_reg <= 16'hFF21;
            9'h29 : data_reg <= 16'hFF22;
            9'h2A : data_reg <= 16'h2D3C;
            9'h2B : data_reg <= 16'h2C3B;
            9'h2C : data_reg <= 16'h3D10;
            9'h2D : data_reg <= 16'h3C12;
            9'h2E : data_reg <= 16'h0000;
            9'h2F : data_reg <= 16'h0000;
            9'h30 : data_reg <= 16'h4C12;
            9'h31 : data_reg <= 16'h3E4E;
            9'h32 : data_reg <= 16'h003C;
            9'h33 : data_reg <= 16'h4C13;
            9'h34 : data_reg <= 16'h4E08;
            9'h35 : data_reg <= 16'h3CF0;
            9'h36 : data_reg <= 16'h3D2B;
            9'h37 : data_reg <= 16'hF02C;
            9'h38 : data_reg <= 16'h3C3F;
            9'h39 : data_reg <= 16'h3B2D;
            9'h3A : data_reg <= 16'h102C;
            9'h3B : data_reg <= 16'h123D;
            9'h3C : data_reg <= 16'h003C;
            9'h3D : data_reg <= 16'h0000;
            9'h3E : data_reg <= 16'h0000;
            9'h3F : data_reg <= 16'h4C12;
            9'h40 : data_reg <= 16'h3E4E;
            9'h41 : data_reg <= 16'h01F0;
            9'h42 : data_reg <= 16'h4C13;
            9'h43 : data_reg <= 16'h4E08;
            9'h44 : data_reg <= 16'h3CF0;
            9'h45 : data_reg <= 16'h3D2B;
            9'h46 : data_reg <= 16'h0C2C;
            9'h47 : data_reg <= 16'h2D3C;
            9'h48 : data_reg <= 16'h2C3B;
            9'h49 : data_reg <= 16'h3D10;
            9'h4A : data_reg <= 16'h3C12;
            9'h4B : data_reg <= 16'h0000;
            9'h4C : data_reg <= 16'h0000;
            9'h4D : data_reg <= 16'h4C12;
            9'h4E : data_reg <= 16'h3E4E;
            9'h4F : data_reg <= 16'h004E;
            9'h50 : data_reg <= 16'h4C13;
            9'h51 : data_reg <= 16'h4E08;
            9'h52 : data_reg <= 16'h3CF0;
            9'h53 : data_reg <= 16'h3D2B;
            9'h54 : data_reg <= 16'hF02C;
            9'h55 : data_reg <= 16'h1239;
            9'h56 : data_reg <= 16'hE903;
            9'h57 : data_reg <= 16'h1103;
            9'h58 : data_reg <= 16'h3149;
            9'h59 : data_reg <= 16'h2D3C;
            9'h5A : data_reg <= 16'h2C3B;
            9'h5B : data_reg <= 16'h3D10;
            9'h5C : data_reg <= 16'h3C12;
            9'h5D : data_reg <= 16'h0000;
            9'h5E : data_reg <= 16'h0000;
            9'h5F : data_reg <= 16'h4C12;
            9'h60 : data_reg <= 16'h3E4E;
            9'h61 : data_reg <= 16'h0064;
            9'h62 : data_reg <= 16'h4C13;
            9'h63 : data_reg <= 16'h4E08;
            9'h64 : data_reg <= 16'h3CF0;
            9'h65 : data_reg <= 16'h3D2B;
            9'h66 : data_reg <= 16'h032C;
            9'h67 : data_reg <= 16'h03E1;
            9'h68 : data_reg <= 16'h2D3C;
            9'h69 : data_reg <= 16'h2C3B;
            9'h6A : data_reg <= 16'h3D10;
            9'h6B : data_reg <= 16'h3C12;
            9'h6C : data_reg <= 16'h0000;
            9'h6D : data_reg <= 16'h0000;
            9'h6E : data_reg <= 16'h4C12;
            9'h6F : data_reg <= 16'h3E4E;
            9'h70 : data_reg <= 16'h01F0;
            9'h71 : data_reg <= 16'h4C13;
            9'h72 : data_reg <= 16'h4E08;
            9'h73 : data_reg <= 16'h3CF0;
            9'h74 : data_reg <= 16'h3D2B;
            9'h75 : data_reg <= 16'h0C2C;
            9'h76 : data_reg <= 16'h0310;
            9'h77 : data_reg <= 16'h03E9;
            9'h78 : data_reg <= 16'h2D3C;
            9'h79 : data_reg <= 16'h2C3B;
            9'h7A : data_reg <= 16'h3D10;
            9'h7B : data_reg <= 16'h3C12;
            9'h7C : data_reg <= 16'h0000;
            9'h7D : data_reg <= 16'h0000;
            9'h7E : data_reg <= 16'h4C12;
            9'h7F : data_reg <= 16'h3E4E;
            9'h80 : data_reg <= 16'h0044;
            9'h81 : data_reg <= 16'h4C13;
            9'h82 : data_reg <= 16'h4E08;
            9'h83 : data_reg <= 16'h3CF0;
            9'h84 : data_reg <= 16'h3D2B;
            9'h85 : data_reg <= 16'hF02C;
            9'h86 : data_reg <= 16'h3C31;
            9'h87 : data_reg <= 16'h3B2D;
            9'h88 : data_reg <= 16'h102C;
            9'h89 : data_reg <= 16'h123D;
            9'h8A : data_reg <= 16'h003C;
            9'h8B : data_reg <= 16'h0000;
            9'h8C : data_reg <= 16'h0000;
            9'h8D : data_reg <= 16'h4C12;
            9'h8E : data_reg <= 16'h3E4E;
            9'h8F : data_reg <= 16'h0064;
            9'h90 : data_reg <= 16'h4C13;
            9'h91 : data_reg <= 16'h4E08;
            9'h92 : data_reg <= 16'h3CF0;
            9'h93 : data_reg <= 16'h3D2B;
            9'h94 : data_reg <= 16'h032C;
            9'h95 : data_reg <= 16'h03E1;
            9'h96 : data_reg <= 16'h4112;
            9'h97 : data_reg <= 16'h3C31;
            9'h98 : data_reg <= 16'h3B2D;
            9'h99 : data_reg <= 16'h102C;
            9'h9A : data_reg <= 16'h123D;
            9'h9B : data_reg <= 16'h003C;
            9'h9C : data_reg <= 16'h0000;
            9'h9D : data_reg <= 16'h0000;
            9'h9E : data_reg <= 16'h4C12;
            9'h9F : data_reg <= 16'h3E4E;
            9'hA0 : data_reg <= 16'h0064;
            9'hA1 : data_reg <= 16'h4C13;
            9'hA2 : data_reg <= 16'h4E08;
            9'hA3 : data_reg <= 16'h3CF0;
            9'hA4 : data_reg <= 16'h3D2B;
            9'hA5 : data_reg <= 16'h032C;
            9'hA6 : data_reg <= 16'h03E1;
            9'hA7 : data_reg <= 16'h2D3C;
            9'hA8 : data_reg <= 16'h2C3B;
            9'hA9 : data_reg <= 16'h3D10;
            9'hAA : data_reg <= 16'h3C12;
            9'hAB : data_reg <= 16'h0000;
            9'hAC : data_reg <= 16'h0000;
            9'hAD : data_reg <= 16'h4C12;
            9'hAE : data_reg <= 16'h3E4E;
            9'hAF : data_reg <= 16'h0040;
            9'hB0 : data_reg <= 16'h4C13;
            9'hB1 : data_reg <= 16'h4E08;
            9'hB2 : data_reg <= 16'h3CF0;
            9'hB3 : data_reg <= 16'h3D2B;
            9'hB4 : data_reg <= 16'hF02C;
            9'hB5 : data_reg <= 16'h1431;
            9'hB6 : data_reg <= 16'hE103;
            9'hB7 : data_reg <= 16'h3C03;
            9'hB8 : data_reg <= 16'h3B2D;
            9'hB9 : data_reg <= 16'h102C;
            9'hBA : data_reg <= 16'h123D;
            9'hBB : data_reg <= 16'h003C;
            9'hBC : data_reg <= 16'h0000;
            9'hBD : data_reg <= 16'h0000;
            9'hBE : data_reg <= 16'h4C12;
            9'hBF : data_reg <= 16'h3E4E;
            9'hC0 : data_reg <= 16'h0011;
            9'hC1 : data_reg <= 16'h4C13;
            9'hC2 : data_reg <= 16'h4E08;
            9'hC3 : data_reg <= 16'h3CF0;
            9'hC4 : data_reg <= 16'h3D2B;
            9'hC5 : data_reg <= 16'h032C;
            9'hC6 : data_reg <= 16'h03E9;
            9'hC7 : data_reg <= 16'h2D3C;
            9'hC8 : data_reg <= 16'h2C3B;
            9'hC9 : data_reg <= 16'h3D10;
            9'hCA : data_reg <= 16'h3C12;
            9'hCB : data_reg <= 16'h0000;
            9'hCC : data_reg <= 16'h0000;
            9'hCD : data_reg <= 16'h4C12;
            9'hCE : data_reg <= 16'h3E4E;
            9'hCF : data_reg <= 16'h01F0;
            9'hD0 : data_reg <= 16'h4C13;
            9'hD1 : data_reg <= 16'h4E08;
            9'hD2 : data_reg <= 16'h3CF0;
            9'hD3 : data_reg <= 16'h3D2B;
            9'hD4 : data_reg <= 16'h0C2C;
            9'hD5 : data_reg <= 16'h3C0E;
            9'hD6 : data_reg <= 16'h3B2D;
            9'hD7 : data_reg <= 16'h102C;
            9'hD8 : data_reg <= 16'h123D;
            9'hD9 : data_reg <= 16'h003C;
            9'hDA : data_reg <= 16'h0000;
            9'hDB : data_reg <= 16'h0000;
            9'hDC : data_reg <= 16'h4C12;
            9'hDD : data_reg <= 16'h3E4E;
            9'hDE : data_reg <= 16'h0064;
            9'hDF : data_reg <= 16'h4C13;
            9'hE0 : data_reg <= 16'h4E08;
            9'hE1 : data_reg <= 16'h3CF0;
            9'hE2 : data_reg <= 16'h3D2B;
            9'hE3 : data_reg <= 16'h312C;
            9'hE4 : data_reg <= 16'h2D3C;
            9'hE5 : data_reg <= 16'h2C3B;
            9'hE6 : data_reg <= 16'h3D10;
            9'hE7 : data_reg <= 16'h3C12;
            9'hE8 : data_reg <= 16'h0000;
            9'hE9 : data_reg <= 16'h0000;
            9'hEA : data_reg <= 16'h4C12;
            9'hEB : data_reg <= 16'h3E4E;
            9'hEC : data_reg <= 16'h01E4;
            9'hED : data_reg <= 16'h4C13;
            9'hEE : data_reg <= 16'h4E08;
            9'hEF : data_reg <= 16'h3CF0;
            9'hF0 : data_reg <= 16'h3D2B;
            9'hF1 : data_reg <= 16'h322C;
            9'hF2 : data_reg <= 16'h3311;
            9'hF3 : data_reg <= 16'h5321;
            9'hF4 : data_reg <= 16'h1031;
            9'hF5 : data_reg <= 16'h01C1;
            9'hF6 : data_reg <= 16'h0922;
            9'hF7 : data_reg <= 16'h0D0F;
            9'hF8 : data_reg <= 16'h341A;
            9'hF9 : data_reg <= 16'h2D3C;
            9'hFA : data_reg <= 16'h2C3B;
            9'hFB : data_reg <= 16'h3D10;
            9'hFC : data_reg <= 16'h3C12;
            9'hFD : data_reg <= 16'h0000;
            9'hFE : data_reg <= 16'h0000;
            9'hFF : data_reg <= 16'h4C12;
            9'h100 : data_reg <= 16'h3E4E;
            9'h101 : data_reg <= 16'h020E;
            9'h102 : data_reg <= 16'h4C13;
            9'h103 : data_reg <= 16'h4E08;
            9'h104 : data_reg <= 16'h3CF0;
            9'h105 : data_reg <= 16'h3D2B;
            9'h106 : data_reg <= 16'h352C;
            9'h107 : data_reg <= 16'h2D3C;
            9'h108 : data_reg <= 16'h2C3B;
            9'h109 : data_reg <= 16'h3D10;
            9'h10A : data_reg <= 16'h3C12;
            9'h10B : data_reg <= 16'h0000;
            9'h10C : data_reg <= 16'h0000;
            9'h10D : data_reg <= 16'h4C12;
            9'h10E : data_reg <= 16'h3E4E;
            9'h10F : data_reg <= 16'h01AB;
            9'h110 : data_reg <= 16'h4C13;
            9'h111 : data_reg <= 16'h4E08;
            9'h112 : data_reg <= 16'h3CF0;
            9'h113 : data_reg <= 16'h3D2B;
            9'h114 : data_reg <= 16'h0C2C;
            9'h115 : data_reg <= 16'h3611;
            9'h116 : data_reg <= 16'h5624;
            9'h117 : data_reg <= 16'h1034;
            9'h118 : data_reg <= 16'h01C4;
            9'h119 : data_reg <= 16'h0925;
            9'h11A : data_reg <= 16'h000D;
            default : data_reg <= 0;
        endcase
    assign data = ( enable ? data_reg : 0 );
endmodule
