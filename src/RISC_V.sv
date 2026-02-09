//versión WiFi OK  v3  tx_w=40 rx_w=35
//(tx0=76 rx0=75)conector CN3  txpc=17 rxpc=18
//Actualización 22 de Noviembre 2025
//probado con usr el 6 feb2026
//probado con la IDE de Tectuinno tanto por cable directo como wifi el 7 feb 2026
//https://riscvasm.lucasteske.dev/  CODIFICAR ENSAMBLADOR
//A=p10[0]37, B=p10[1]36, LAT=p10[2]25, 
//oe=p10[3]38,
//SERIE=tx_spi26, CLK=clk_spi39 
module top(input logic clk, rst,rx_w,rx18, 
input logic [7:0]port_in,
output logic tx_spi,clk_spi,tx_17,tx_w,led,
output logic [3:0]p10,//cs[1]
output logic [2:0]semaforo,//cs[6]
output logic [1:0]m_cd,//cs[7] a=68  b=69
output logic [2:0]m_pasos,//cs[8] ena=70 dir=71 pul=72
output logic m_servo,//cs[9] servo=73
output logic [4:0]fpga_leds);//cs[10] 11,13-16 fpga_leds 0xA0000000
/*
0x10000 modulo led 32x16 p10
0x60000 semáforo  bit2 rojo bit 1 ambar bit0 verde
0x70000 motor cd (corriente directa) bit1 bit0
0x80000 motor a pasos cs[8] ena(bit2) dir(bit1) pul(bit0)
0x90000 servomotor bit0
0xa0000 fpga_leds
*/
//puente para leer lo que recibe el WiFi
assign tx_17=rx_w;

logic [7:0]dato_uart;

assign reset=rst;

logic MemWrite;
logic [31:0] WriteData, DataAdr;

logic [31:0] PC, Instr, ReadData;
logic [15:0]cs;//0=RAM, 1=regled, 2...

// instancia entre procesador y memorias
riscvsingle rvsingle(clk, reset, PC, Instr, MemWrite, DataAdr, WriteData, ReadData,res_pc);//DataAdr=ALUResult
////imem i2(a,rd,clk,w_uart,dato_uart[7:0]);
imem imem(PC, Instr,clk,reset,w_imem,dato_uart,res_pc);
logic res_pc;//reset al pc cuando llegue nuevo programa

//se direcciona con la 0x30000000
dmem dmem(clk, MemWrite, DataAdr, WriteData, ReadData,cs[3]);

//decodificador para direccionar a los periféricos
decod_4_16  d1(DataAdr[31:28],cs);

//instanciar periféricos

//reg_led 0x10000000
reg_led rl1(clk,cs[1],MemWrite,WriteData,p10);//port_out =0x01000000
//fpga_leds 0x60000000
reg_led rl2(clk,cs[6],MemWrite,WriteData,semaforo);//
//m_cd 0x70000000
reg_led rl3(clk,cs[7],MemWrite,WriteData,m_cd);//
//m_pasos 0x80000000
reg_led rl4(clk,cs[8],MemWrite,WriteData,m_pasos);//
//m_servo 0x90000000
reg_led rl5(clk,cs[9],MemWrite,WriteData,m_servo);//
//fpga_leds 0xA0000000
reg_led rl6(clk,cs[10],MemWrite,WriteData,fpga_leds);//


//reg_in 0x40000000
reg_in reg_lec1(clk,cs[4],port_in,ReadData[7:0]);//lw x9,0x40000000

//SPI status=0x20000000  shift=0x20000001 freq=0x20000002
SPI spi_0(clk,reset,WriteData,DataAdr[1:0],MemWrite,cs[2],ReadData,tx_spi,clk_spi);

//uart_rx y uart_tx 0x50000  leer y transmitir
uart_rx ur0(clk,reset,ReadData[7:0],cs[5],rx_53,DataAdr[1:0]);
//uart_tx ut0(clk,reset,WriteData[7:0],MemWrite,cs[5],ReadData[7:0],tx_17,DataAdr[1:0]);//lw x4,2(50000) es el estado está en ReadData[7:0]

logic [7:0]dato_uart;

//uart para actualizar la mem de programa
logic rx_gral;
assign rx_gral=rx18 & rx_w;

uart_rx_wtr ur1(reset,clk, rx_gral,dato_uart, w_imem,tx_w,led,res_pc);


endmodule


module decod_4_16(input logic [3:0]in,output logic [15:0]y);
always_comb
case(in)
4'H0:y=16'b1111_1111_1111_1110; //-- nada
4'b0001:y=16'b1111_1111_1111_1101;//reg_led rl1
4'H2:y=16'b1111_1111_1111_1011;//SPI spi_0
4'H3:y=16'b1111_1111_1111_0111;//RAM
4'H4:y=16'b1111_1111_1110_1111;//reg_in reg_lec1
4'H5:y=16'b1111_1111_1101_1111;//uart_rx ur0 uart_rx ut0
4'H6:y=16'b1111_1111_1011_1111;//semaforo 0x60000
4'H7:y=16'b1111_1111_0111_1111;//m_cd
4'H8:y=16'b1111_1110_1111_1111;//m_pasos
4'H9:y=16'b1111_1101_1111_1111;//m_servo
4'HA:y=16'b1111_1011_1111_1111;//fpga_leds 0xA0000000
4'HB:y=16'b1111_0111_1111_1111;
4'HC:y=16'b1110_1111_1111_1111;
4'HD:y=16'b1101_1111_1111_1111;
4'HE:y=16'b1011_1111_1111_1111;
4'HF:y=16'b0111_1111_1111_1111;
endcase
endmodule
