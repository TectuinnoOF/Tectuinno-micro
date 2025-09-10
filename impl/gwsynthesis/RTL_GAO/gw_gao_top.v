module gw_gao(
    \cs[15] ,
    \cs[14] ,
    \cs[13] ,
    \cs[12] ,
    \cs[11] ,
    \cs[10] ,
    \cs[9] ,
    \cs[8] ,
    \cs[7] ,
    \cs[6] ,
    \cs[5] ,
    \cs[4] ,
    \cs[3] ,
    \cs[2] ,
    \cs[1] ,
    \cs[0] ,
    \WriteData[31] ,
    \WriteData[30] ,
    \WriteData[29] ,
    \WriteData[28] ,
    \WriteData[27] ,
    \WriteData[26] ,
    \WriteData[25] ,
    \WriteData[24] ,
    \WriteData[23] ,
    \WriteData[22] ,
    \WriteData[21] ,
    \WriteData[20] ,
    \WriteData[19] ,
    \WriteData[18] ,
    \WriteData[17] ,
    \WriteData[16] ,
    \WriteData[15] ,
    \WriteData[14] ,
    \WriteData[13] ,
    \WriteData[12] ,
    \WriteData[11] ,
    \WriteData[10] ,
    \WriteData[9] ,
    \WriteData[8] ,
    \WriteData[7] ,
    \WriteData[6] ,
    \WriteData[5] ,
    \WriteData[4] ,
    \WriteData[3] ,
    \WriteData[2] ,
    \WriteData[1] ,
    \WriteData[0] ,
    MemWrite,
    \PC[31] ,
    \PC[30] ,
    \PC[29] ,
    \PC[28] ,
    \PC[27] ,
    \PC[26] ,
    \PC[25] ,
    \PC[24] ,
    \PC[23] ,
    \PC[22] ,
    \PC[21] ,
    \PC[20] ,
    \PC[19] ,
    \PC[18] ,
    \PC[17] ,
    \PC[16] ,
    \PC[15] ,
    \PC[14] ,
    \PC[13] ,
    \PC[12] ,
    \PC[11] ,
    \PC[10] ,
    \PC[9] ,
    \PC[8] ,
    \PC[7] ,
    \PC[6] ,
    \PC[5] ,
    \PC[4] ,
    \PC[3] ,
    \PC[2] ,
    \PC[1] ,
    \PC[0] ,
    \spi_0/transmitting ,
    \spi_0/bit_count[4] ,
    \spi_0/bit_count[3] ,
    \spi_0/bit_count[2] ,
    \spi_0/bit_count[1] ,
    \spi_0/bit_count[0] ,
    \ReadData[31] ,
    \ReadData[30] ,
    \ReadData[29] ,
    \ReadData[28] ,
    \ReadData[27] ,
    \ReadData[26] ,
    \ReadData[25] ,
    \ReadData[24] ,
    \ReadData[23] ,
    \ReadData[22] ,
    \ReadData[21] ,
    \ReadData[20] ,
    \ReadData[19] ,
    \ReadData[18] ,
    \ReadData[17] ,
    \ReadData[16] ,
    \ReadData[15] ,
    \ReadData[14] ,
    \ReadData[13] ,
    \ReadData[12] ,
    \ReadData[11] ,
    \ReadData[10] ,
    \ReadData[9] ,
    \ReadData[8] ,
    \ReadData[7] ,
    \ReadData[6] ,
    \ReadData[5] ,
    \ReadData[4] ,
    \ReadData[3] ,
    \ReadData[2] ,
    \ReadData[1] ,
    \ReadData[0] ,
    clk_spi,
    tx_spi,
    \spi_0/cont[7] ,
    \spi_0/cont[6] ,
    \spi_0/cont[5] ,
    \spi_0/cont[4] ,
    \spi_0/cont[3] ,
    \spi_0/cont[2] ,
    \spi_0/cont[1] ,
    \spi_0/cont[0] ,
    \port_out[7] ,
    \port_out[6] ,
    \port_out[5] ,
    \port_out[4] ,
    \port_out[3] ,
    \port_out[2] ,
    \port_out[1] ,
    \port_out[0] ,
    \ur0/rx_data[7] ,
    \ur0/rx_data[6] ,
    \ur0/rx_data[5] ,
    \ur0/rx_data[4] ,
    \ur0/rx_data[3] ,
    \ur0/rx_data[2] ,
    \ur0/rx_data[1] ,
    \ur0/rx_data[0] ,
    \ur0/rx_data_valid ,
    \ur0/busy ,
    \reg_lec1/dat_reg[31] ,
    \reg_lec1/dat_reg[30] ,
    \reg_lec1/dat_reg[29] ,
    \reg_lec1/dat_reg[28] ,
    \reg_lec1/dat_reg[27] ,
    \reg_lec1/dat_reg[26] ,
    \reg_lec1/dat_reg[25] ,
    \reg_lec1/dat_reg[24] ,
    \reg_lec1/dat_reg[23] ,
    \reg_lec1/dat_reg[22] ,
    \reg_lec1/dat_reg[21] ,
    \reg_lec1/dat_reg[20] ,
    \reg_lec1/dat_reg[19] ,
    \reg_lec1/dat_reg[18] ,
    \reg_lec1/dat_reg[17] ,
    \reg_lec1/dat_reg[16] ,
    \reg_lec1/dat_reg[15] ,
    \reg_lec1/dat_reg[14] ,
    \reg_lec1/dat_reg[13] ,
    \reg_lec1/dat_reg[12] ,
    \reg_lec1/dat_reg[11] ,
    \reg_lec1/dat_reg[10] ,
    \reg_lec1/dat_reg[9] ,
    \reg_lec1/dat_reg[8] ,
    \reg_lec1/dat_reg[7] ,
    \reg_lec1/dat_reg[6] ,
    \reg_lec1/dat_reg[5] ,
    \reg_lec1/dat_reg[4] ,
    \reg_lec1/dat_reg[3] ,
    \reg_lec1/dat_reg[2] ,
    \reg_lec1/dat_reg[1] ,
    \reg_lec1/dat_reg[0] ,
    clk,
    tms_pad_i,
    tck_pad_i,
    tdi_pad_i,
    tdo_pad_o
);

input \cs[15] ;
input \cs[14] ;
input \cs[13] ;
input \cs[12] ;
input \cs[11] ;
input \cs[10] ;
input \cs[9] ;
input \cs[8] ;
input \cs[7] ;
input \cs[6] ;
input \cs[5] ;
input \cs[4] ;
input \cs[3] ;
input \cs[2] ;
input \cs[1] ;
input \cs[0] ;
input \WriteData[31] ;
input \WriteData[30] ;
input \WriteData[29] ;
input \WriteData[28] ;
input \WriteData[27] ;
input \WriteData[26] ;
input \WriteData[25] ;
input \WriteData[24] ;
input \WriteData[23] ;
input \WriteData[22] ;
input \WriteData[21] ;
input \WriteData[20] ;
input \WriteData[19] ;
input \WriteData[18] ;
input \WriteData[17] ;
input \WriteData[16] ;
input \WriteData[15] ;
input \WriteData[14] ;
input \WriteData[13] ;
input \WriteData[12] ;
input \WriteData[11] ;
input \WriteData[10] ;
input \WriteData[9] ;
input \WriteData[8] ;
input \WriteData[7] ;
input \WriteData[6] ;
input \WriteData[5] ;
input \WriteData[4] ;
input \WriteData[3] ;
input \WriteData[2] ;
input \WriteData[1] ;
input \WriteData[0] ;
input MemWrite;
input \PC[31] ;
input \PC[30] ;
input \PC[29] ;
input \PC[28] ;
input \PC[27] ;
input \PC[26] ;
input \PC[25] ;
input \PC[24] ;
input \PC[23] ;
input \PC[22] ;
input \PC[21] ;
input \PC[20] ;
input \PC[19] ;
input \PC[18] ;
input \PC[17] ;
input \PC[16] ;
input \PC[15] ;
input \PC[14] ;
input \PC[13] ;
input \PC[12] ;
input \PC[11] ;
input \PC[10] ;
input \PC[9] ;
input \PC[8] ;
input \PC[7] ;
input \PC[6] ;
input \PC[5] ;
input \PC[4] ;
input \PC[3] ;
input \PC[2] ;
input \PC[1] ;
input \PC[0] ;
input \spi_0/transmitting ;
input \spi_0/bit_count[4] ;
input \spi_0/bit_count[3] ;
input \spi_0/bit_count[2] ;
input \spi_0/bit_count[1] ;
input \spi_0/bit_count[0] ;
input \ReadData[31] ;
input \ReadData[30] ;
input \ReadData[29] ;
input \ReadData[28] ;
input \ReadData[27] ;
input \ReadData[26] ;
input \ReadData[25] ;
input \ReadData[24] ;
input \ReadData[23] ;
input \ReadData[22] ;
input \ReadData[21] ;
input \ReadData[20] ;
input \ReadData[19] ;
input \ReadData[18] ;
input \ReadData[17] ;
input \ReadData[16] ;
input \ReadData[15] ;
input \ReadData[14] ;
input \ReadData[13] ;
input \ReadData[12] ;
input \ReadData[11] ;
input \ReadData[10] ;
input \ReadData[9] ;
input \ReadData[8] ;
input \ReadData[7] ;
input \ReadData[6] ;
input \ReadData[5] ;
input \ReadData[4] ;
input \ReadData[3] ;
input \ReadData[2] ;
input \ReadData[1] ;
input \ReadData[0] ;
input clk_spi;
input tx_spi;
input \spi_0/cont[7] ;
input \spi_0/cont[6] ;
input \spi_0/cont[5] ;
input \spi_0/cont[4] ;
input \spi_0/cont[3] ;
input \spi_0/cont[2] ;
input \spi_0/cont[1] ;
input \spi_0/cont[0] ;
input \port_out[7] ;
input \port_out[6] ;
input \port_out[5] ;
input \port_out[4] ;
input \port_out[3] ;
input \port_out[2] ;
input \port_out[1] ;
input \port_out[0] ;
input \ur0/rx_data[7] ;
input \ur0/rx_data[6] ;
input \ur0/rx_data[5] ;
input \ur0/rx_data[4] ;
input \ur0/rx_data[3] ;
input \ur0/rx_data[2] ;
input \ur0/rx_data[1] ;
input \ur0/rx_data[0] ;
input \ur0/rx_data_valid ;
input \ur0/busy ;
input \reg_lec1/dat_reg[31] ;
input \reg_lec1/dat_reg[30] ;
input \reg_lec1/dat_reg[29] ;
input \reg_lec1/dat_reg[28] ;
input \reg_lec1/dat_reg[27] ;
input \reg_lec1/dat_reg[26] ;
input \reg_lec1/dat_reg[25] ;
input \reg_lec1/dat_reg[24] ;
input \reg_lec1/dat_reg[23] ;
input \reg_lec1/dat_reg[22] ;
input \reg_lec1/dat_reg[21] ;
input \reg_lec1/dat_reg[20] ;
input \reg_lec1/dat_reg[19] ;
input \reg_lec1/dat_reg[18] ;
input \reg_lec1/dat_reg[17] ;
input \reg_lec1/dat_reg[16] ;
input \reg_lec1/dat_reg[15] ;
input \reg_lec1/dat_reg[14] ;
input \reg_lec1/dat_reg[13] ;
input \reg_lec1/dat_reg[12] ;
input \reg_lec1/dat_reg[11] ;
input \reg_lec1/dat_reg[10] ;
input \reg_lec1/dat_reg[9] ;
input \reg_lec1/dat_reg[8] ;
input \reg_lec1/dat_reg[7] ;
input \reg_lec1/dat_reg[6] ;
input \reg_lec1/dat_reg[5] ;
input \reg_lec1/dat_reg[4] ;
input \reg_lec1/dat_reg[3] ;
input \reg_lec1/dat_reg[2] ;
input \reg_lec1/dat_reg[1] ;
input \reg_lec1/dat_reg[0] ;
input clk;
input tms_pad_i;
input tck_pad_i;
input tdi_pad_i;
output tdo_pad_o;

wire \cs[15] ;
wire \cs[14] ;
wire \cs[13] ;
wire \cs[12] ;
wire \cs[11] ;
wire \cs[10] ;
wire \cs[9] ;
wire \cs[8] ;
wire \cs[7] ;
wire \cs[6] ;
wire \cs[5] ;
wire \cs[4] ;
wire \cs[3] ;
wire \cs[2] ;
wire \cs[1] ;
wire \cs[0] ;
wire \WriteData[31] ;
wire \WriteData[30] ;
wire \WriteData[29] ;
wire \WriteData[28] ;
wire \WriteData[27] ;
wire \WriteData[26] ;
wire \WriteData[25] ;
wire \WriteData[24] ;
wire \WriteData[23] ;
wire \WriteData[22] ;
wire \WriteData[21] ;
wire \WriteData[20] ;
wire \WriteData[19] ;
wire \WriteData[18] ;
wire \WriteData[17] ;
wire \WriteData[16] ;
wire \WriteData[15] ;
wire \WriteData[14] ;
wire \WriteData[13] ;
wire \WriteData[12] ;
wire \WriteData[11] ;
wire \WriteData[10] ;
wire \WriteData[9] ;
wire \WriteData[8] ;
wire \WriteData[7] ;
wire \WriteData[6] ;
wire \WriteData[5] ;
wire \WriteData[4] ;
wire \WriteData[3] ;
wire \WriteData[2] ;
wire \WriteData[1] ;
wire \WriteData[0] ;
wire MemWrite;
wire \PC[31] ;
wire \PC[30] ;
wire \PC[29] ;
wire \PC[28] ;
wire \PC[27] ;
wire \PC[26] ;
wire \PC[25] ;
wire \PC[24] ;
wire \PC[23] ;
wire \PC[22] ;
wire \PC[21] ;
wire \PC[20] ;
wire \PC[19] ;
wire \PC[18] ;
wire \PC[17] ;
wire \PC[16] ;
wire \PC[15] ;
wire \PC[14] ;
wire \PC[13] ;
wire \PC[12] ;
wire \PC[11] ;
wire \PC[10] ;
wire \PC[9] ;
wire \PC[8] ;
wire \PC[7] ;
wire \PC[6] ;
wire \PC[5] ;
wire \PC[4] ;
wire \PC[3] ;
wire \PC[2] ;
wire \PC[1] ;
wire \PC[0] ;
wire \spi_0/transmitting ;
wire \spi_0/bit_count[4] ;
wire \spi_0/bit_count[3] ;
wire \spi_0/bit_count[2] ;
wire \spi_0/bit_count[1] ;
wire \spi_0/bit_count[0] ;
wire \ReadData[31] ;
wire \ReadData[30] ;
wire \ReadData[29] ;
wire \ReadData[28] ;
wire \ReadData[27] ;
wire \ReadData[26] ;
wire \ReadData[25] ;
wire \ReadData[24] ;
wire \ReadData[23] ;
wire \ReadData[22] ;
wire \ReadData[21] ;
wire \ReadData[20] ;
wire \ReadData[19] ;
wire \ReadData[18] ;
wire \ReadData[17] ;
wire \ReadData[16] ;
wire \ReadData[15] ;
wire \ReadData[14] ;
wire \ReadData[13] ;
wire \ReadData[12] ;
wire \ReadData[11] ;
wire \ReadData[10] ;
wire \ReadData[9] ;
wire \ReadData[8] ;
wire \ReadData[7] ;
wire \ReadData[6] ;
wire \ReadData[5] ;
wire \ReadData[4] ;
wire \ReadData[3] ;
wire \ReadData[2] ;
wire \ReadData[1] ;
wire \ReadData[0] ;
wire clk_spi;
wire tx_spi;
wire \spi_0/cont[7] ;
wire \spi_0/cont[6] ;
wire \spi_0/cont[5] ;
wire \spi_0/cont[4] ;
wire \spi_0/cont[3] ;
wire \spi_0/cont[2] ;
wire \spi_0/cont[1] ;
wire \spi_0/cont[0] ;
wire \port_out[7] ;
wire \port_out[6] ;
wire \port_out[5] ;
wire \port_out[4] ;
wire \port_out[3] ;
wire \port_out[2] ;
wire \port_out[1] ;
wire \port_out[0] ;
wire \ur0/rx_data[7] ;
wire \ur0/rx_data[6] ;
wire \ur0/rx_data[5] ;
wire \ur0/rx_data[4] ;
wire \ur0/rx_data[3] ;
wire \ur0/rx_data[2] ;
wire \ur0/rx_data[1] ;
wire \ur0/rx_data[0] ;
wire \ur0/rx_data_valid ;
wire \ur0/busy ;
wire \reg_lec1/dat_reg[31] ;
wire \reg_lec1/dat_reg[30] ;
wire \reg_lec1/dat_reg[29] ;
wire \reg_lec1/dat_reg[28] ;
wire \reg_lec1/dat_reg[27] ;
wire \reg_lec1/dat_reg[26] ;
wire \reg_lec1/dat_reg[25] ;
wire \reg_lec1/dat_reg[24] ;
wire \reg_lec1/dat_reg[23] ;
wire \reg_lec1/dat_reg[22] ;
wire \reg_lec1/dat_reg[21] ;
wire \reg_lec1/dat_reg[20] ;
wire \reg_lec1/dat_reg[19] ;
wire \reg_lec1/dat_reg[18] ;
wire \reg_lec1/dat_reg[17] ;
wire \reg_lec1/dat_reg[16] ;
wire \reg_lec1/dat_reg[15] ;
wire \reg_lec1/dat_reg[14] ;
wire \reg_lec1/dat_reg[13] ;
wire \reg_lec1/dat_reg[12] ;
wire \reg_lec1/dat_reg[11] ;
wire \reg_lec1/dat_reg[10] ;
wire \reg_lec1/dat_reg[9] ;
wire \reg_lec1/dat_reg[8] ;
wire \reg_lec1/dat_reg[7] ;
wire \reg_lec1/dat_reg[6] ;
wire \reg_lec1/dat_reg[5] ;
wire \reg_lec1/dat_reg[4] ;
wire \reg_lec1/dat_reg[3] ;
wire \reg_lec1/dat_reg[2] ;
wire \reg_lec1/dat_reg[1] ;
wire \reg_lec1/dat_reg[0] ;
wire clk;
wire tms_pad_i;
wire tck_pad_i;
wire tdi_pad_i;
wire tdo_pad_o;
wire tms_i_c;
wire tck_i_c;
wire tdi_i_c;
wire tdo_o_c;
wire [9:0] control0;
wire gao_jtag_tck;
wire gao_jtag_reset;
wire run_test_idle_er1;
wire run_test_idle_er2;
wire shift_dr_capture_dr;
wire update_dr;
wire pause_dr;
wire enable_er1;
wire enable_er2;
wire gao_jtag_tdi;
wire tdo_er1;

IBUF tms_ibuf (
    .I(tms_pad_i),
    .O(tms_i_c)
);

IBUF tck_ibuf (
    .I(tck_pad_i),
    .O(tck_i_c)
);

IBUF tdi_ibuf (
    .I(tdi_pad_i),
    .O(tdi_i_c)
);

OBUF tdo_obuf (
    .I(tdo_o_c),
    .O(tdo_pad_o)
);

GW_JTAG  u_gw_jtag(
    .tms_pad_i(tms_i_c),
    .tck_pad_i(tck_i_c),
    .tdi_pad_i(tdi_i_c),
    .tdo_pad_o(tdo_o_c),
    .tck_o(gao_jtag_tck),
    .test_logic_reset_o(gao_jtag_reset),
    .run_test_idle_er1_o(run_test_idle_er1),
    .run_test_idle_er2_o(run_test_idle_er2),
    .shift_dr_capture_dr_o(shift_dr_capture_dr),
    .update_dr_o(update_dr),
    .pause_dr_o(pause_dr),
    .enable_er1_o(enable_er1),
    .enable_er2_o(enable_er2),
    .tdi_o(gao_jtag_tdi),
    .tdo_er1_i(tdo_er1),
    .tdo_er2_i(1'b0)
);

gw_con_top  u_icon_top(
    .tck_i(gao_jtag_tck),
    .tdi_i(gao_jtag_tdi),
    .tdo_o(tdo_er1),
    .rst_i(gao_jtag_reset),
    .control0(control0[9:0]),
    .enable_i(enable_er1),
    .shift_dr_capture_dr_i(shift_dr_capture_dr),
    .update_dr_i(update_dr)
);

ao_top u_ao_top(
    .control(control0[9:0]),
    .data_i({\cs[15] ,\cs[14] ,\cs[13] ,\cs[12] ,\cs[11] ,\cs[10] ,\cs[9] ,\cs[8] ,\cs[7] ,\cs[6] ,\cs[5] ,\cs[4] ,\cs[3] ,\cs[2] ,\cs[1] ,\cs[0] ,\WriteData[31] ,\WriteData[30] ,\WriteData[29] ,\WriteData[28] ,\WriteData[27] ,\WriteData[26] ,\WriteData[25] ,\WriteData[24] ,\WriteData[23] ,\WriteData[22] ,\WriteData[21] ,\WriteData[20] ,\WriteData[19] ,\WriteData[18] ,\WriteData[17] ,\WriteData[16] ,\WriteData[15] ,\WriteData[14] ,\WriteData[13] ,\WriteData[12] ,\WriteData[11] ,\WriteData[10] ,\WriteData[9] ,\WriteData[8] ,\WriteData[7] ,\WriteData[6] ,\WriteData[5] ,\WriteData[4] ,\WriteData[3] ,\WriteData[2] ,\WriteData[1] ,\WriteData[0] ,MemWrite,\PC[31] ,\PC[30] ,\PC[29] ,\PC[28] ,\PC[27] ,\PC[26] ,\PC[25] ,\PC[24] ,\PC[23] ,\PC[22] ,\PC[21] ,\PC[20] ,\PC[19] ,\PC[18] ,\PC[17] ,\PC[16] ,\PC[15] ,\PC[14] ,\PC[13] ,\PC[12] ,\PC[11] ,\PC[10] ,\PC[9] ,\PC[8] ,\PC[7] ,\PC[6] ,\PC[5] ,\PC[4] ,\PC[3] ,\PC[2] ,\PC[1] ,\PC[0] ,\spi_0/transmitting ,\spi_0/bit_count[4] ,\spi_0/bit_count[3] ,\spi_0/bit_count[2] ,\spi_0/bit_count[1] ,\spi_0/bit_count[0] ,\ReadData[31] ,\ReadData[30] ,\ReadData[29] ,\ReadData[28] ,\ReadData[27] ,\ReadData[26] ,\ReadData[25] ,\ReadData[24] ,\ReadData[23] ,\ReadData[22] ,\ReadData[21] ,\ReadData[20] ,\ReadData[19] ,\ReadData[18] ,\ReadData[17] ,\ReadData[16] ,\ReadData[15] ,\ReadData[14] ,\ReadData[13] ,\ReadData[12] ,\ReadData[11] ,\ReadData[10] ,\ReadData[9] ,\ReadData[8] ,\ReadData[7] ,\ReadData[6] ,\ReadData[5] ,\ReadData[4] ,\ReadData[3] ,\ReadData[2] ,\ReadData[1] ,\ReadData[0] ,clk_spi,tx_spi,\spi_0/cont[7] ,\spi_0/cont[6] ,\spi_0/cont[5] ,\spi_0/cont[4] ,\spi_0/cont[3] ,\spi_0/cont[2] ,\spi_0/cont[1] ,\spi_0/cont[0] ,\port_out[7] ,\port_out[6] ,\port_out[5] ,\port_out[4] ,\port_out[3] ,\port_out[2] ,\port_out[1] ,\port_out[0] ,\ur0/rx_data[7] ,\ur0/rx_data[6] ,\ur0/rx_data[5] ,\ur0/rx_data[4] ,\ur0/rx_data[3] ,\ur0/rx_data[2] ,\ur0/rx_data[1] ,\ur0/rx_data[0] ,\ur0/rx_data_valid ,\ur0/busy ,\reg_lec1/dat_reg[31] ,\reg_lec1/dat_reg[30] ,\reg_lec1/dat_reg[29] ,\reg_lec1/dat_reg[28] ,\reg_lec1/dat_reg[27] ,\reg_lec1/dat_reg[26] ,\reg_lec1/dat_reg[25] ,\reg_lec1/dat_reg[24] ,\reg_lec1/dat_reg[23] ,\reg_lec1/dat_reg[22] ,\reg_lec1/dat_reg[21] ,\reg_lec1/dat_reg[20] ,\reg_lec1/dat_reg[19] ,\reg_lec1/dat_reg[18] ,\reg_lec1/dat_reg[17] ,\reg_lec1/dat_reg[16] ,\reg_lec1/dat_reg[15] ,\reg_lec1/dat_reg[14] ,\reg_lec1/dat_reg[13] ,\reg_lec1/dat_reg[12] ,\reg_lec1/dat_reg[11] ,\reg_lec1/dat_reg[10] ,\reg_lec1/dat_reg[9] ,\reg_lec1/dat_reg[8] ,\reg_lec1/dat_reg[7] ,\reg_lec1/dat_reg[6] ,\reg_lec1/dat_reg[5] ,\reg_lec1/dat_reg[4] ,\reg_lec1/dat_reg[3] ,\reg_lec1/dat_reg[2] ,\reg_lec1/dat_reg[1] ,\reg_lec1/dat_reg[0] }),
    .clk_i(clk)
);

endmodule
