
//uart_rx_wtr ur1(reset,clk, rx_w,dato_uart, w_imem,tx_w);
module uart_rx_wtr(input logic rst,clk,rx_w,
output logic [7:0]dato_uart, 
output logic w_imem,tx_w,led,
input logic res_pc);


logic [7:0]dato,dato_pre,dato_rx;
logic [7:0]conta;

logic [7:0] RAM [63:0];
logic [7:0] VECTOR[0:8];

uart_rx2 urx1(clk,rx_w,rx_done,dato_rx);

logic new2;
logic [1:0]pnt_trm;
uart_tx2 ut1(clk,new2,dato,tx_w,busy);
logic [7:0]trama [0:19];

logic [5:0]punt;
logic [3:0]state_tr;
logic [24:0]retar;
logic [3:0]cnt_crc;
parameter IDLE=0,LOAD1=1,SEND1=2,CNT1=3,RETARDO=4,
FIN_ENV=5,LEE=6,CMP_TRM=7,ENVI=8,FIN=9;

//AT+CWMODE=3
//AT+CIPMUX=1
//AT+CIPSERVER=1,80

always_ff@(posedge clk)
if(!rst)state_tr<=0;
else begin
case(state_tr)
IDLE:begin
        w_imem<=1'b0;
        new2<=0;
        led<=0;
        cnt_crc<=0;//contador de caract válidos
        retar<=0;
        pnt_trm<=0;
        state_tr<=LOAD1;
    VECTOR[0:8]<={"T","E","C","T","U","I","N","N","O"};        
end
/*
AT+CWMODE=3
AT+CIPMUX=1
AT+CIPSERVER=1,80
*/
LOAD1: begin
    punt<=0;
    case(pnt_trm)
0: trama [0:13]<={"A","T","+","C","W","M","O","D","E","=","3",8'H0D,8'H0A,8'H24};
1: trama [0:13]<={"A","T","+","C","I","P","M","U","X","=","1",8'H0D,8'H0A,8'H24};
2: trama [0:19]<={"A","T","+","C","I","P","S","E","R","V","E","R","=","1",",","8","0",8'H0D,8'H0A,8'H24};
    endcase
state_tr<=SEND1;
    end

SEND1:    
    begin
    if(busy==0)
        begin
        dato_pre<=trama[punt];
        state_tr<=CNT1;
        end

    end
CNT1: 
    if(dato_pre=="$")state_tr<=RETARDO;
    else begin
        punt<=punt+1;
        dato<=dato_pre;
        new2<=1;
        state_tr<=SEND1;
        end
    
RETARDO:begin
        new2<=0;
        if(retar>25'd23_500_000)
            begin
            retar<=0;
            state_tr<=FIN_ENV;
            end
        else retar<=retar+1;

        end

FIN_ENV:begin
    if(pnt_trm==2)begin 
                    state_tr<=LEE;
                    end
    else begin
        pnt_trm<=pnt_trm+1;
        state_tr<=LOAD1;
        end
    end


//lectura del puerto serie de datos

LEE:begin//TECTUINNO 9 caracteres mayúsculas
//    if(rx_done)begin led<=~led;state_tr=CMP_TRM;end
led<=1; 

    if(rx_done)
        begin

        if(dato_rx == VECTOR[cnt_crc][7:0])
            begin   
            if(cnt_crc==4'd8)begin cnt_crc<=0;state_tr<=CMP_TRM;end
            else begin
                cnt_crc<=cnt_crc+1;
                state_tr<=LEE;
                end
            end
       // else cnt_crc<=0;
        end
    end

CMP_TRM:
        begin
    led<=0;
        w_imem<=1'b0;
    if(res_pc==0)state_tr<=LEE;

     else if(rx_done)
        begin
            dato_uart<=dato_rx;
            state_tr<=ENVI;
        end
        end

ENVI:   begin
        w_imem<=1'b1;
        state_tr<=CMP_TRM;
        led<=1'b1;
        end




endcase



end


endmodule














//uart_rx urx1(clk,rx,rx_done,dato);
module uart_rx2(input logic clk,rx,
output logic rx_done,
output logic [7:0]dato);


logic [2:0]state;//5 estados
parameter s0=0,s1=1,s2=2,s3=3,s4=4,s5=5;
logic [7:0]c_235;
logic [3:0]conta10;
logic [9:0]dat_temp;

always_ff@(posedge clk)
case(state)
s0:begin
    rx_done<=0;
    dat_temp<=10'd0;
    c_235<=0;
    conta10<=0;
    if(rx==0) state<=s1;
    else state<=s0;
    end
s1:begin
    c_235<=c_235+1'b1;//c_235++
    if(c_235<8'd118)state<=s1;
    else state<=s2;
    end
s2: begin
    dat_temp<={rx,dat_temp[9:1]};
    c_235<=0;
    conta10<=conta10+1'b1;
    state<=s3;
    end
s3: begin
    if(conta10==4'd10)state<=s4;
    else begin
        c_235<=c_235+1'b1;
        if(c_235<8'd235)state<=s3;
        else state<=s2;
        end
    end
s4: begin
    dato<=dat_temp[8:1];
    state<=s5;
    end

s5: begin
    state<=s0;
    rx_done<=1;
    end
endcase



endmodule


//uart_tx ut1(clk,new2,dato,tx,busy);
module uart_tx2(input logic clk,new2,
input logic [7:0]dato, output logic tx,busy,led);
logic [3:0]state;
parameter s0=0,s1=1,s2=2,s3=3,s4=4;
logic [9:0]cnt;
logic [3:0]bits_cnt;
logic [9:0]temp=10'h3FF;

assign tx=temp[0];

always_ff@(posedge clk)
case(state)
s0:if(new2==1'b1)
    begin state<=s1; temp<={1'b1,dato,1'b0};busy<=1;end
    else state<=s0;

s1: begin     
    if(cnt==10'd235)begin cnt<=0; state<=s2;end
    else begin cnt<=cnt+1'b1;state<=s1;end
    end

s2: begin 
    temp<={1'b1,temp[9:1]};
    if(bits_cnt>4'd9)
    begin 
        bits_cnt<=0;
        busy<=0;
        led<=~led;
        state<=s0;
    end
    else begin bits_cnt<=bits_cnt+1'b1;state<=s1;end
    end

    
endcase


endmodule