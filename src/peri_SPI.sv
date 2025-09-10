//sxpi unn(clk,reset,WriteData,DataAdr[1:0],MemWrite,cs[2],ReadData,tx_spi,clk_spi);
module SPI(
    input logic clk,  // Reloj del sistema
    input logic rst,  // Reset
    input logic [31:0] data_in,  // Dato de escritura desde el procesador
    input logic [1:0] addr,  // Dirección de acceso al registro de estado
    input logic write_en_n,  // Señal de escritura (activa en bajo)
    input logic cs_n,  // Chip Select (activo en bajo)
    output logic [31:0] data_out,  // Salida de datos hacia el procesador
    output logic mosi,  // Salida de datos SPI
    clk_spi
);
logic [7:0] div=8'd4;//pares
logic [31:0] shift_reg;
logic [4:0] bit_count;
logic transmitting;
logic [31:0] status_reg;  // Registro de estado interno de 8 bits
logic [7:0]cont;
//lui x4,0x20000 parte alta
//addi x3,x0,2 (2-254) configurcion de freq SPI0
//sw x3,2(x4) carga la freq del SPI 8bitsLSB
//sw x5,1(x4) envia dato al SPI
//lw x4,0(x4) lee registro de estado del SPI

always_ff@(posedge clk) 
begin
    if (!rst) 
            begin
            div<=8'd4;//default
            shift_reg <= 0;
            bit_count <= 0;
            transmitting <= 0;
            status_reg <= 32'b0;
            cont<=0;
            clk_spi<=0;
            end 
    else begin
        if (write_en_n && !cs_n) 
            begin
              cont<=0;            
              clk_spi<=0;
                case (addr)
                2'b00: status_reg <= data_in; // Permite actualizar el estado desde el procesador
                2'b01: 
                    begin
                    shift_reg <= data_in;
                    bit_count <= 0;
                    transmitting <= 1;
                    status_reg[0] <= 1'b1; // Indicador de transmisión en progreso
                    end
                2'b10:div <= {data_in[7:1],1'b0};//carga freq SPI
                endcase
            end

        else if (transmitting)
                begin
                    if(cont==div-1'd1) 
                    begin
                    cont<=0;
                    shift_reg <= {shift_reg[30:0], 1'b0};
                    bit_count <= bit_count + 1'd1;
                    if (bit_count == 5'd31) 
                        begin
                        transmitting <= 0;
                        status_reg[0] <= 1'b0; // Transmisión completada
                        status_reg[31:1] <= shift_reg[31:1]; // Guardar datos enviados
                        end
                    end
                    else cont<=cont+1'd1;
                    if(cont==(div/2)-1'd1 || cont==div-1'd1)clk_spi<=~clk_spi;
                end
             end
end //fin del else


always_comb begin
        if (!cs_n) begin
            case (addr)
                2'b00: data_out = status_reg; // Leer el registro de estado
                2'b01: data_out = shift_reg; // Leer el último dato enviado
                default: data_out = 32'b0;
            endcase
                    end 
        else begin
            data_out = 32'bz; //alta imped si cs=1
        end
    end

assign mosi = shift_reg[31];
endmodule


