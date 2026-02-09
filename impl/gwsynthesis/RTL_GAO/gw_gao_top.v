module gw_gao(
    \dato_uart[7] ,
    \dato_uart[6] ,
    \dato_uart[5] ,
    \dato_uart[4] ,
    \dato_uart[3] ,
    \dato_uart[2] ,
    \dato_uart[1] ,
    \dato_uart[0] ,
    reset,
    \ur1/state_tr[3] ,
    \ur1/state_tr[2] ,
    \ur1/state_tr[1] ,
    \ur1/state_tr[0] ,
    \ur1/cnt_crc[3] ,
    \ur1/cnt_crc[2] ,
    \ur1/cnt_crc[1] ,
    \ur1/cnt_crc[0] ,
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
    \imem/a_uart[13] ,
    \imem/a_uart[12] ,
    \imem/a_uart[11] ,
    \imem/a_uart[10] ,
    \imem/a_uart[9] ,
    \imem/a_uart[8] ,
    \imem/a_uart[7] ,
    \imem/a_uart[6] ,
    \imem/a_uart[5] ,
    \imem/a_uart[4] ,
    \imem/a_uart[3] ,
    \imem/a_uart[2] ,
    \imem/a_uart[1] ,
    \imem/a_uart[0] ,
    \rvsingle/dp/pcreg/reset ,
    clk,
    tms_pad_i,
    tck_pad_i,
    tdi_pad_i,
    tdo_pad_o
);

input \dato_uart[7] ;
input \dato_uart[6] ;
input \dato_uart[5] ;
input \dato_uart[4] ;
input \dato_uart[3] ;
input \dato_uart[2] ;
input \dato_uart[1] ;
input \dato_uart[0] ;
input reset;
input \ur1/state_tr[3] ;
input \ur1/state_tr[2] ;
input \ur1/state_tr[1] ;
input \ur1/state_tr[0] ;
input \ur1/cnt_crc[3] ;
input \ur1/cnt_crc[2] ;
input \ur1/cnt_crc[1] ;
input \ur1/cnt_crc[0] ;
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
input \imem/a_uart[13] ;
input \imem/a_uart[12] ;
input \imem/a_uart[11] ;
input \imem/a_uart[10] ;
input \imem/a_uart[9] ;
input \imem/a_uart[8] ;
input \imem/a_uart[7] ;
input \imem/a_uart[6] ;
input \imem/a_uart[5] ;
input \imem/a_uart[4] ;
input \imem/a_uart[3] ;
input \imem/a_uart[2] ;
input \imem/a_uart[1] ;
input \imem/a_uart[0] ;
input \rvsingle/dp/pcreg/reset ;
input clk;
input tms_pad_i;
input tck_pad_i;
input tdi_pad_i;
output tdo_pad_o;

wire \dato_uart[7] ;
wire \dato_uart[6] ;
wire \dato_uart[5] ;
wire \dato_uart[4] ;
wire \dato_uart[3] ;
wire \dato_uart[2] ;
wire \dato_uart[1] ;
wire \dato_uart[0] ;
wire reset;
wire \ur1/state_tr[3] ;
wire \ur1/state_tr[2] ;
wire \ur1/state_tr[1] ;
wire \ur1/state_tr[0] ;
wire \ur1/cnt_crc[3] ;
wire \ur1/cnt_crc[2] ;
wire \ur1/cnt_crc[1] ;
wire \ur1/cnt_crc[0] ;
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
wire \imem/a_uart[13] ;
wire \imem/a_uart[12] ;
wire \imem/a_uart[11] ;
wire \imem/a_uart[10] ;
wire \imem/a_uart[9] ;
wire \imem/a_uart[8] ;
wire \imem/a_uart[7] ;
wire \imem/a_uart[6] ;
wire \imem/a_uart[5] ;
wire \imem/a_uart[4] ;
wire \imem/a_uart[3] ;
wire \imem/a_uart[2] ;
wire \imem/a_uart[1] ;
wire \imem/a_uart[0] ;
wire \rvsingle/dp/pcreg/reset ;
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
    .data_i({\dato_uart[7] ,\dato_uart[6] ,\dato_uart[5] ,\dato_uart[4] ,\dato_uart[3] ,\dato_uart[2] ,\dato_uart[1] ,\dato_uart[0] ,reset,\ur1/state_tr[3] ,\ur1/state_tr[2] ,\ur1/state_tr[1] ,\ur1/state_tr[0] ,\ur1/cnt_crc[3] ,\ur1/cnt_crc[2] ,\ur1/cnt_crc[1] ,\ur1/cnt_crc[0] ,\PC[31] ,\PC[30] ,\PC[29] ,\PC[28] ,\PC[27] ,\PC[26] ,\PC[25] ,\PC[24] ,\PC[23] ,\PC[22] ,\PC[21] ,\PC[20] ,\PC[19] ,\PC[18] ,\PC[17] ,\PC[16] ,\PC[15] ,\PC[14] ,\PC[13] ,\PC[12] ,\PC[11] ,\PC[10] ,\PC[9] ,\PC[8] ,\PC[7] ,\PC[6] ,\PC[5] ,\PC[4] ,\PC[3] ,\PC[2] ,\PC[1] ,\PC[0] ,\imem/a_uart[13] ,\imem/a_uart[12] ,\imem/a_uart[11] ,\imem/a_uart[10] ,\imem/a_uart[9] ,\imem/a_uart[8] ,\imem/a_uart[7] ,\imem/a_uart[6] ,\imem/a_uart[5] ,\imem/a_uart[4] ,\imem/a_uart[3] ,\imem/a_uart[2] ,\imem/a_uart[1] ,\imem/a_uart[0] ,\rvsingle/dp/pcreg/reset }),
    .clk_i(clk)
);

endmodule
