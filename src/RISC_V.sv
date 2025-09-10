//Actualización 8 de Mayo 2025
//https://riscvasm.lucasteske.dev/  CODIFICAR ENSAMBLADOR
//A=port_out[0]37, B=port_out[1]36, LAT=port_out[2]25, 
//oe=port_out[3]38,
//SERIE=tx_spi26, CLK=clk_spi39 

module top(input logic clk, reset,rx, 
output logic [7:0]port_out,input logic [7:0]port_in,
output logic tx_spi,clk_spi,tx_uart0);

logic MemWrite;
logic [31:0] WriteData, DataAdr;

logic [31:0] PC, Instr, ReadData;
logic [15:0]cs;//0=RAM, 1=regled, 2...

// instancia entre procesador y memorias
riscvsingle rvsingle(clk, reset, PC, Instr, MemWrite, DataAdr, WriteData, ReadData);//DataAdr=ALUResult

imem imem(PC, Instr);

//se direcciona con la 0x30000000
dmem dmem(clk, MemWrite, DataAdr, WriteData, ReadData,cs[3]);

//decodificador para direccionar a los periféricos
decod_4_16  d1(DataAdr[31:28],cs);

//instanciar periféricos

//reg_led 0x10000000
reg_led rl1(clk,cs[1],MemWrite,WriteData,port_out);//port_out =0x01000000

//reg_in 0x40000000
reg_in reg_lec1(clk,cs[4],port_in,ReadData[7:0]);//lw x9,0x40000000

//SPI status=0x20000000  shift=0x20000001 freq=0x20000002
SPI spi_0(clk,reset,WriteData,DataAdr[1:0],MemWrite,cs[2],ReadData,tx_spi,clk_spi);

//uart_rx y uart_tx 0x50000  leer y transmitir
uart_rx ur0(clk,reset,ReadData[7:0],cs[5],rx,DataAdr[1:0]);
uart_tx ut0(clk,reset,WriteData[7:0],MemWrite,cs[5],ReadData[7:0],tx_uart0,DataAdr[1:0]);//lw x4,2(50000) es el estado está en ReadData[7:0]

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
4'H6:y=16'b1111_1111_1011_1111;
4'H7:y=16'b1111_1111_0111_1111;
4'H8:y=16'b1111_1110_1111_1111;
4'H9:y=16'b1111_1101_1111_1111;
4'HA:y=16'b1111_1011_1111_1111;
4'HB:y=16'b1111_0111_1111_1111;
4'HC:y=16'b1110_1111_1111_1111;
4'HD:y=16'b1101_1111_1111_1111;
4'HE:y=16'b1011_1111_1111_1111;
4'HF:y=16'b0111_1111_1111_1111;
endcase
endmodule
