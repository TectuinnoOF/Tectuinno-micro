//Copyright (C)2014-2025 GOWIN Semiconductor Corporation.
//All rights reserved.
//File Title: Timing Constraints file
//Tool Version: V1.9.9 (64-bit) 
//Created Time: 2025-08-13 05:11:57
create_clock -name clk -period 10 -waveform {0 5} [get_ports {clk_spi}]
