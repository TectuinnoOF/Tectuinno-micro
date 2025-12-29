//MODULOS RX Y TX
//uart_rx u0(clk,reset,ReadData[7:0],cs[5],rx,DataAdr[1:0]);
//uart_tx (clk,reset,WriteData[7:0],MemWrite,cs[5],ReadData[7:0],tx_uart0,DataAdr[1:0],rx_data_valid);//lw x4,2(50000) es el estado está en ReadData[7:0]

module uart_rx #(parameter CLK_FRE=27, parameter BAUD_RATE = 9600)
(input clk,rst_n,output reg[7:0]datarec,
input rx_data_ready,input rx_pin,
input logic [1:0] addr,output logic rx_data_valid);

reg [7:0]rx_data;
always_comb begin
        if (!rx_data_ready) begin
            case (addr)
                2'b00: datarec = rx_data; // Leer el registro de estado
                2'b01: datarec = {7'd0,rx_data_valid}; // Leer el último dato enviado
                2'b10: datarec = 8'dz;//es para el tx
                2'b11: datarec = 8'dz;// es para el tx
                default: datarec = 32'b0;
            endcase
                    end 
        else begin
            datarec = 32'bz; //alta imped si cs=1
        end
    end


//reg rx_data_valid;

//calculates the clock cycle for baud rate 
localparam CYCLE = CLK_FRE * 1000000 / BAUD_RATE;
//state machine code
localparam                       S_IDLE      = 1;
localparam                       S_START     = 2; //start bit
localparam                       S_REC_BYTE  = 3; //data bits
localparam                       S_STOP      = 4; //stop bit
localparam                       S_DATA      = 5;

reg[2:0]                         state;
reg[2:0]                         next_state;
reg                              rx_d0;            //delay 1 clock for rx_pin
reg                              rx_d1;            //delay 1 clock for rx_d0
wire                             rx_negedge;       //negedge of rx_pin
reg[7:0]                         rx_bits;          //temporary storage of received data
reg[15:0]                        cycle_cnt;        //baud counter
reg[2:0]                         bit_cnt;          //bit counter
reg busy=0;// 1 mientras está recibiendo datos
assign rx_negedge = rx_d1 && ~rx_d0;

always@(posedge clk or negedge rst_n)
begin
	if(rst_n == 1'b0)
	begin
		rx_d0 <= 1'b0;
		rx_d1 <= 1'b0;	
	end
	else
	begin
		rx_d0 <= rx_pin;
		rx_d1 <= rx_d0;
	end
end


always@(posedge clk or negedge rst_n)
begin
	if(rst_n == 1'b0)
		state <= S_IDLE;
	else
		state <= next_state;
end

always@(*)
begin
	case(state)
		S_IDLE:
			if(rx_negedge)//
				next_state <= S_START;
			else
				next_state <= S_IDLE;
		S_START:
			if(cycle_cnt == CYCLE - 1)//one data cycle 
				next_state <= S_REC_BYTE;
			else
				next_state <= S_START;
		S_REC_BYTE:
			if(cycle_cnt == CYCLE - 1  && bit_cnt == 3'd7)  //receive 8bit data
				next_state <= S_STOP;
			else
				next_state <= S_REC_BYTE;
		S_STOP:
			if(cycle_cnt == CYCLE/2 - 1)//half bit cycle,to avoid missing the next byte receiver
				next_state <= S_DATA;
			else
				next_state <= S_STOP;
		S_DATA:
			if(rx_data_ready)    //data receive complete
				next_state <= S_IDLE;
			else
				next_state <= S_DATA;
		default:
			next_state <= S_IDLE;
	endcase
end

always@(posedge clk or negedge rst_n)
begin
	if(rst_n == 1'b0)
		rx_data_valid <= 1'b0; 
	else if(state == S_DATA)
		rx_data_valid <= 1'b1;
//	else if(state == S_STOP && next_state != state)
	//	rx_data_valid <= 1'b1;
//	else if(state == S_DATA && rx_data_ready)
//		rx_data_valid <= 1'b0;

	else if(!rx_data_ready && addr[1:0]==2'b01 &&rx_data_valid == 1'b1)
		rx_data_valid <= 1'b0;

end

always@(posedge clk or negedge rst_n)
begin
	if(rst_n == 1'b0)
		rx_data <= 8'd0;
	else if(state == S_STOP && next_state != state)
		begin rx_data <= rx_bits; busy<=1'b0;end//latch received data
end

always@(posedge clk or negedge rst_n)
begin
	if(rst_n == 1'b0)
		begin
			bit_cnt <= 3'd0;
		end
	else if(state == S_REC_BYTE)
		if(cycle_cnt == CYCLE - 1)
			bit_cnt <= bit_cnt + 3'd1;
		else
			bit_cnt <= bit_cnt;
	else
		bit_cnt <= 3'd0;
end


always@(posedge clk or negedge rst_n)
begin
	if(rst_n == 1'b0)
		cycle_cnt <= 16'd0;
	else if((state == S_REC_BYTE && cycle_cnt == CYCLE - 1) || next_state != state)
		cycle_cnt <= 16'd0;
	else
		cycle_cnt <= cycle_cnt + 16'd1;	
end
//receive serial data bit data
always@(posedge clk or negedge rst_n)
begin
	if(rst_n == 1'b0)
		rx_bits <= 8'd0;
	else if(state == S_REC_BYTE && cycle_cnt == CYCLE/2 - 1)
		rx_bits[bit_cnt] <= rx_pin;
	else
		rx_bits <= rx_bits; 
end
endmodule 











module uart_tx
#(
	parameter CLK_FRE = 27,      //clock frequency(Mhz)
	parameter BAUD_RATE = 9600 //serial baud rate
)
//uart_tx (clk,reset,WriteData[7:0],MemWrite,cs[5],ReadData[7:0],tx_uart0,DataAdr[1:0]);//lw x4,2(50000) es el estado está en ReadData[7:0]
(
	input                        clk,              //clock input
	input                        rst_n,            //asynchronous reset input, low active 
	input[7:0]                   tx_data,          //data to send
	input                        tx_data_valid,    //data to be sent is valid
	input                        cs,    //data to be sent is valid
output reg[7:0] estado,    //[7:0]tx_data_ready lw x4,2(50000) 
	output                       tx_pin,            //serial data output
    output logic [1:0]addr
);
//calculates the clock cycle for baud rate 
localparam                       CYCLE = CLK_FRE * 1000000 / BAUD_RATE;
//state machine code
localparam                       S_IDLE       = 1;
localparam                       S_START      = 2;//start bit
localparam                       S_SEND_BYTE  = 3;//data bits
localparam                       S_STOP       = 4;//stop bit
reg[2:0]                         state;
reg[2:0]                         next_state;
reg[15:0]                        cycle_cnt; //baud counter
reg[2:0]                         bit_cnt;//bit counter
reg[7:0]                         tx_data_latch; //latch data to send
reg                              tx_reg; //serial data output

logic [7:0]tx_data_ready;
//lw x4,2(50000) sw x4,0(50000)
always_comb
        if (!cs) begin
            case (addr)
                2'b00: estado=8'dz;
                2'b01: estado=8'dz;
                2'b10: estado=tx_data_ready;
                2'b11: estado=8'dz;
                default: estado=8'dz;
            endcase
                    end 

assign tx_pin = tx_reg;
always@(posedge clk or negedge rst_n)
begin
	if(rst_n == 1'b0)
		state <= S_IDLE;
	else
		state <= next_state;
end

always@(*)
begin
	case(state)
		S_IDLE:
			if(tx_data_valid == 1'b1 && !cs)
				next_state <= S_START;
			else
				next_state <= S_IDLE;
		S_START:
			if(cycle_cnt == CYCLE - 1)
				next_state <= S_SEND_BYTE;
			else
				next_state <= S_START;
		S_SEND_BYTE:
			if(cycle_cnt == CYCLE - 1  && bit_cnt == 3'd7)
				next_state <= S_STOP;
			else
				next_state <= S_SEND_BYTE;
		S_STOP:
			if(cycle_cnt == CYCLE - 1)
				next_state <= S_IDLE;
			else
				next_state <= S_STOP;
		default:
			next_state <= S_IDLE;
	endcase

end
always@(posedge clk or negedge rst_n)
begin
	if(rst_n == 1'b0)
		begin
			tx_data_ready <= 8'd0;
		end
	else if(state == S_IDLE)
		if(tx_data_valid == 1'b1 && !cs)//memwrite !cs[5] 
			tx_data_ready <= 8'd1;//cuando SW
//		else
	//		tx_data_ready <= 8'd0;// estaba en 1
	else if(state == S_STOP && cycle_cnt == CYCLE - 1)
			tx_data_ready <= 8'd0; //finaliza
end


always@(posedge clk or negedge rst_n)
begin
	if(rst_n == 1'b0)
		begin
			tx_data_latch <= 8'd0;
		end
	else if(state == S_IDLE && tx_data_valid == 1'b1 && !cs)
			tx_data_latch <= tx_data;
		
end

always@(posedge clk or negedge rst_n)
begin
	if(rst_n == 1'b0)
		begin
			bit_cnt <= 3'd0;
		end
	else if(state == S_SEND_BYTE)
		if(cycle_cnt == CYCLE - 1)
			bit_cnt <= bit_cnt + 3'd1;
		else
			bit_cnt <= bit_cnt;
	else
		bit_cnt <= 3'd0;
end


always@(posedge clk or negedge rst_n)
begin
	if(rst_n == 1'b0)
		cycle_cnt <= 16'd0;
	else if((state == S_SEND_BYTE && cycle_cnt == CYCLE - 1) || next_state != state)
		cycle_cnt <= 16'd0;
	else
		cycle_cnt <= cycle_cnt + 16'd1;	
end

always@(posedge clk or negedge rst_n)
begin
	if(rst_n == 1'b0)
		tx_reg <= 1'b1;
	else
		case(state)
			S_IDLE,S_STOP:
				tx_reg <= 1'b1; 
			S_START:
				tx_reg <= 1'b0; 
			S_SEND_BYTE:
				tx_reg <= tx_data_latch[bit_cnt];
			default:
				tx_reg <= 1'b1; 
		endcase
end

endmodule 
