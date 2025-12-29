//reg_led rl1(clk,cs[1],MemWrite,WriteData,port_out);//port_out =0x10000000
module reg_led(input logic clk,cs,we,input logic [31:0]data,
output logic [31:0]leds);

always_ff@(posedge clk)
if(!cs && we)leds<=data;
        
endmodule



//reg_in reg_lec1(clk,cs,port_in,Read_data);
module reg_in(input logic clk,cs,input logic [7:0]data_in,
output logic [31:0]dat_reg);

//always_ff@(posedge clk)
always_comb
if(!cs)dat_reg<=data_in;
else dat_reg<=32'bz;        

endmodule

