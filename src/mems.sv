//imem i2(a,rd,clk,reset,w_uart,dat_uart);
module imem(input logic [31:0] a,output logic [31:0] rd,
input logic clk, reset,w_uart,
input logic [7:0]dat_uart,
output logic res_pc);


logic [31:0] RAM[255:0];// cambiar para progrs largos
initial
$readmemh("riscvtest.txt",RAM);
assign rd = RAM[a[31:2]]; // word aligned

logic [13:0]a_uart,u0;// contador
//escribe las instrucciones byte por byte en la RAM

always_ff @(posedge clk)
if(!res_pc)begin a_uart<=0;end
else begin
//       if(state==s2)a_uart<=14'd0;
        if (w_uart) begin 
                if(a_uart[1:0]==2'b00)RAM[a_uart[13:2]][7:0]<= dat_uart;
                else if(a_uart[1:0]==2'b01)RAM[a_uart[13:2]][15:8]<= dat_uart;
                else if(a_uart[1:0]==2'b10)RAM[a_uart[13:2]][23:16]<= dat_uart;
                else if(a_uart[1:0]==2'b11)RAM[a_uart[13:2]][31:24]<= dat_uart;
                a_uart<=a_uart+1'd1;
                u0<=u0+1;
                end
    end

logic [24:0]cnt_1seg;
logic [1:0]state;
parameter s0=0,s1=1,s2=2,s3=3;
//agregar reser por hardware


always_ff@(posedge clk)
if(!reset)state<=s0;
else begin
case(state)
s0:begin
   res_pc<=1;
    if (w_uart)
            begin
            state<=s1;
            end
end
s1:
   if(cnt_1seg==25'd27_000_000)
        begin 
            cnt_1seg<=0;
            state<=s2;
            res_pc<=0;
        end
    else begin
        cnt_1seg<=cnt_1seg+1;
        state<=s1;
        end

s2: begin
//    res_pc<=1;
    state=s3;
    end
s3: 
    if(cnt_1seg==25'd2_700_000)
        begin
        state<=s0;
        end
    else cnt_1seg<=cnt_1seg+1;

endcase

end



endmodule
//AltGr +   ~





module dmem(input logic clk, we,input logic [31:0] a,
wd,output logic [31:0] rd,
input logic cs);

logic [31:0] RAM[255:0];//data=32bits dir=0-63(64localidades de 32 bits)
logic [31:0]ax;
assign ax=a & 32'H0FFFFFFF;
assign rd =cs? 32'bz : RAM[ax[31:2]]; // word aligned

always_ff @(posedge clk)
if(!cs)begin // habilita con oe=0
    if (we)RAM[ax[31:2]] <= wd; 
        end

initial begin
/*
        RAM[0] =~ 32'hC6C6C600;//fila 13,9,5,1
        RAM[1] =~ 32'hFEC6C6FE;//fila 14,10,6,2
        RAM[2] =~ 32'hFEC6C6FE;//fila 15,11,7,3
        RAM[3] =~ 32'h00C6C6C6;//fila 16,12,8,4

        RAM[4] =~ 32'h10011001;//fila 13,9,5,1 BLOCK8_0
        RAM[5] =~ 32'h20022002;//fila 14,10,6,2 BLOCK8_0
        RAM[6] =~ 32'h40044004;//fila 15,11,7,3 BLOCK8_0
        RAM[7] =~ 32'h80088008;//fila 16,12,8,4 BLOCK8_0

         RAM[8] =~ 32'h1c1c1c3c;//fila 13,9,5,1 BLOCK8_0
         RAM[9] =~ 32'h7f1c1c3c;//fila 14,10,6,2 BLOCK8_0
        RAM[10] =~ 32'h7f1c1c3c;//fila 15,11,7,3 BLOCK8_0
        RAM[11] =~ 32'h7f1c1c1c;//fila 16,12,8,4 BLOCK8_0

        RAM[12] =~ 32'h707F077F;//fila 13,9,5,1 BLOCK8_0
        RAM[13] =~ 32'h7F7F077F;//fila 14,10,6,2 BLOCK8_0
        RAM[14] =~ 32'h7F70077F;//fila 15,11,7,3 BLOCK8_0
        RAM[15] =~ 32'h7F707F07;//fila 16,12,8,4 BLOCK8_0
*/
RAM[0] = ~32'h00000000;
RAM[1] = ~32'h00000000;
RAM[2] = ~32'h00000000;
RAM[3] = ~32'h00000000;
RAM[4] = ~32'h00000000;
RAM[5] = ~32'h00000000;
RAM[6] = ~32'h00000000;
RAM[7] = ~32'h00000000;
RAM[8] = ~32'h03000300;
RAM[9] = ~32'h01000300;
RAM[10] = ~32'h00000000;
RAM[11] = ~32'h00030001;
RAM[12] = ~32'hFF0F8F00;
RAM[13] = ~32'hFF3FFF3E;
RAM[14] = ~32'hFFFFFFFF;
RAM[15] = ~32'h3EFF3F8F;
RAM[16] = ~32'h00000000;
RAM[17] = ~32'h00000000;
RAM[18] = ~32'h00000000;
RAM[19] = ~32'h00000000;
RAM[20] = ~32'h00000000;
RAM[21] = ~32'h00000000;
RAM[22] = ~32'h00000000;
RAM[23] = ~32'h00000000;
RAM[24] = ~32'h07000700;
RAM[25] = ~32'h03070700;
RAM[26] = ~32'h010F0F01;
RAM[27] = ~32'h00070703;
RAM[28] = ~32'hFF3F1F00;
RAM[29] = ~32'hFFFFFF7C;
RAM[30] = ~32'hFFFFFFFF;
RAM[31] = ~32'h7CFFFF1F;
RAM[32] = ~32'h00000000;
RAM[33] = ~32'h00000000;
RAM[34] = ~32'h00000000;
RAM[35] = ~32'h00000000;
RAM[36] = ~32'h00000000;
RAM[37] = ~32'h00000000;
RAM[38] = ~32'h00000000;
RAM[39] = ~32'h00000000;
RAM[40] = ~32'h0F000E00;
RAM[41] = ~32'h07000F00;
RAM[42] = ~32'h03030303;
RAM[43] = ~32'h000F0006;
RAM[44] = ~32'hFF3F3F00;
RAM[45] = ~32'hFFFFFFF8;
RAM[46] = ~32'hFEFFFFFE;
RAM[47] = ~32'hF8FFFF3F;
RAM[48] = ~32'h00000000;
RAM[49] = ~32'h00000000;
RAM[50] = ~32'h00000000;
RAM[51] = ~32'h00000000;
RAM[52] = ~32'h00000000;
RAM[53] = ~32'h00000000;
RAM[54] = ~32'h00000000;
RAM[55] = ~32'h00000000;
RAM[56] = ~32'h1F001C00;
RAM[57] = ~32'h0F1F1F01;
RAM[58] = ~32'h073F3F07;
RAM[59] = ~32'h011F1F0C;
RAM[60] = ~32'hFFFF7F00;
RAM[61] = ~32'hFEFFFFF0;
RAM[62] = ~32'hFCFFFFFC;
RAM[63] = ~32'hF0FFFF7E;
RAM[64] = ~32'h00000000;
RAM[65] = ~32'h00000000;
RAM[66] = ~32'h00000000;
RAM[67] = ~32'h00000000;
RAM[68] = ~32'h00000000;
RAM[69] = ~32'h00000000;
RAM[70] = ~32'h00000000;
RAM[71] = ~32'h00000000;
RAM[72] = ~32'h3F003800;
RAM[73] = ~32'h1F033F03;
RAM[74] = ~32'h0F0F0F0F;
RAM[75] = ~32'h033F0318;
RAM[76] = ~32'hFEFFFE00;
RAM[77] = ~32'hFCFFFEE0;
RAM[78] = ~32'hF8FFFFF8;
RAM[79] = ~32'hE0FEFFFC;
RAM[80] = ~32'h00000000;
RAM[81] = ~32'h00000000;
RAM[82] = ~32'h00000000;
RAM[83] = ~32'h00000000;
RAM[84] = ~32'h00000000;
RAM[85] = ~32'h00000000;
RAM[86] = ~32'h00000000;
RAM[87] = ~32'h00000000;
RAM[88] = ~32'h7F037100;
RAM[89] = ~32'h3F7F7F07;
RAM[90] = ~32'h1FFFFF1F;
RAM[91] = ~32'h077F7F31;
RAM[92] = ~32'hFCFEFC00;
RAM[93] = ~32'hF8FEFCC0;
RAM[94] = ~32'hF0FEFEF0;
RAM[95] = ~32'hC0FCFEF8;
RAM[96] = ~32'h00000000;
RAM[97] = ~32'h00000000;
RAM[98] = ~32'h00000000;
RAM[99] = ~32'h00000000;
RAM[100] = ~32'h00000000;
RAM[101] = ~32'h00000000;
RAM[102] = ~32'h00000000;
RAM[103] = ~32'h00000000;
RAM[104] = ~32'hFF03E300;
RAM[105] = ~32'h7F0FFF0F;
RAM[106] = ~32'h3F3F3F3F;
RAM[107] = ~32'h0FFF0F63;
RAM[108] = ~32'hF8FCF800;
RAM[109] = ~32'hF0FCF880;
RAM[110] = ~32'hE0FCFCE0;
RAM[111] = ~32'h80F8FCF0;
RAM[112] = ~32'h00000000;
RAM[113] = ~32'h00000000;
RAM[114] = ~32'h00000000;
RAM[115] = ~32'h00000000;
RAM[116] = ~32'h01000100;
RAM[117] = ~32'h00010100;
RAM[118] = ~32'h00030300;
RAM[119] = ~32'h00010100;
RAM[120] = ~32'hFF0FC700;
RAM[121] = ~32'hFFFFFF1F;
RAM[122] = ~32'h7FFFFF7F;
RAM[123] = ~32'h1FFFFFC7;
RAM[124] = ~32'hF0F8F000;
RAM[125] = ~32'hE0F8F000;
RAM[126] = ~32'hC0F8F8C0;
RAM[127] = ~32'h00F0F8E0;
RAM[128] = ~32'hFFF88F00;
RAM[129] = ~32'hFFFEFF3E;
RAM[130] = ~32'hFFFFFFFF;
RAM[131] = ~32'h3EFFFE8F;
RAM[132] = ~32'hE000E000;
RAM[133] = ~32'hC000E000;
RAM[134] = ~32'h80808080;
RAM[135] = ~32'h00E000C0;
RAM[136] = ~32'h00000000;
RAM[137] = ~32'h00000000;
RAM[138] = ~32'h00000000;
RAM[139] = ~32'h00000000;
RAM[140] = ~32'h00000000;
RAM[141] = ~32'h00000000;
RAM[142] = ~32'h00000000;
RAM[143] = ~32'h00000000;
RAM[144] = ~32'hFFFEC700;
RAM[145] = ~32'hFFFFFF1F;
RAM[146] = ~32'h7FFFFF7F;
RAM[147] = ~32'h1FFFFFC7;
RAM[148] = ~32'hF000F000;
RAM[149] = ~32'hE0F0F000;
RAM[150] = ~32'hC0F8F8C0;
RAM[151] = ~32'h00F0F0E0;
RAM[152] = ~32'h00000000;
RAM[153] = ~32'h00000000;
RAM[154] = ~32'h00000000;
RAM[155] = ~32'h00000000;
RAM[156] = ~32'h00000000;
RAM[157] = ~32'h00000000;
RAM[158] = ~32'h00000000;
RAM[159] = ~32'h00000000;
RAM[160] = ~32'hFFFEE300;
RAM[161] = ~32'h7FFFFF0F;
RAM[162] = ~32'h3FFFFF3F;
RAM[163] = ~32'h0FFFFF63;
RAM[164] = ~32'hF800F800;
RAM[165] = ~32'hF080F880;
RAM[166] = ~32'hE0E0E0E0;
RAM[167] = ~32'h80F880F0;
RAM[168] = ~32'h00000000;
RAM[169] = ~32'h00000000;
RAM[170] = ~32'h00000000;
RAM[171] = ~32'h00000000;
RAM[172] = ~32'h00000000;
RAM[173] = ~32'h00000000;
RAM[174] = ~32'h00000000;
RAM[175] = ~32'h00000000;
RAM[176] = ~32'h7FFF7100;
RAM[177] = ~32'h3FFF7F07;
RAM[178] = ~32'h1FFFFF1F;
RAM[179] = ~32'h077FFF31;
RAM[180] = ~32'hFC80FC00;
RAM[181] = ~32'hF8FCFCC0;
RAM[182] = ~32'hF0FEFEF0;
RAM[183] = ~32'hC0FCFCF8;
RAM[184] = ~32'h00000000;
RAM[185] = ~32'h00000000;
RAM[186] = ~32'h00000000;
RAM[187] = ~32'h00000000;
RAM[188] = ~32'h00000000;
RAM[189] = ~32'h00000000;
RAM[190] = ~32'h00000000;
RAM[191] = ~32'h00000000;
RAM[192] = ~32'h3F7F3800;
RAM[193] = ~32'h1F7F3F03;
RAM[194] = ~32'h0F7F7F0F;
RAM[195] = ~32'h033F7F18;
RAM[196] = ~32'hFE80FE00;
RAM[197] = ~32'hFCE0FEE0;
RAM[198] = ~32'hF8F8F8F8;
RAM[199] = ~32'hE0FEE0FC;
RAM[200] = ~32'h00000000;
RAM[201] = ~32'h00000000;
RAM[202] = ~32'h00000000;
RAM[203] = ~32'h00000000;
RAM[204] = ~32'h00000000;
RAM[205] = ~32'h00000000;
RAM[206] = ~32'h00000000;
RAM[207] = ~32'h00000000;
RAM[208] = ~32'h1F3F1C00;
RAM[209] = ~32'h0F3F1F01;
RAM[210] = ~32'h073F3F07;
RAM[211] = ~32'h011F3F0C;
RAM[212] = ~32'hFFE07F00;
RAM[213] = ~32'hFEFFFFF0;
RAM[214] = ~32'hFCFFFFFC;
RAM[215] = ~32'hF0FFFF7E;
RAM[216] = ~32'h00000000;
RAM[217] = ~32'h00000000;
RAM[218] = ~32'h00808000;
RAM[219] = ~32'h00000000;
RAM[220] = ~32'h00000000;
RAM[221] = ~32'h00000000;
RAM[222] = ~32'h00000000;
RAM[223] = ~32'h00000000;
RAM[224] = ~32'h0F1F0E00;
RAM[225] = ~32'h071F0F00;
RAM[226] = ~32'h031F1F03;
RAM[227] = ~32'h000F1F06;
RAM[228] = ~32'hFFE03F00;
RAM[229] = ~32'hFFF8FFF8;
RAM[230] = ~32'hFEFEFEFE;
RAM[231] = ~32'hF8FFF83F;
RAM[232] = ~32'h80008000;
RAM[233] = ~32'h00008000;
RAM[234] = ~32'h00000000;
RAM[235] = ~32'h00800000;
RAM[236] = ~32'h00000000;
RAM[237] = ~32'h00000000;
RAM[238] = ~32'h00000000;
RAM[239] = ~32'h00000000;
RAM[240] = ~32'h070F0700;
RAM[241] = ~32'h030F0700;
RAM[242] = ~32'h010F0F01;
RAM[243] = ~32'h00070F03;
RAM[244] = ~32'hFFF81F00;
RAM[245] = ~32'hFFFFFF7C;
RAM[246] = ~32'hFFFFFFFF;
RAM[247] = ~32'h7CFFFF1F;
RAM[248] = ~32'hC000C000;
RAM[249] = ~32'h80C0C000;
RAM[250] = ~32'h00E0E000;
RAM[251] = ~32'h00C0C080;
RAM[252] = ~32'h00000000;
RAM[253] = ~32'h00000000;
RAM[254] = ~32'h00000000;
RAM[255] = ~32'h00000000;
  // puedes continuar hasta mem[31]

end

endmodule


module rom_32X16_uu(input logic [7:0]dir, output logic [15:0]data);
logic [31:0]dir_uu[0:255];//[0:87]
initial begin // módulos para poner letras
//cer0
dir_uu[00]=32'H00000000;
dir_uu[01]=32'H00000000;
dir_uu[02]=32'H00000000;
dir_uu[03]=32'H00000000;

end
endmodule