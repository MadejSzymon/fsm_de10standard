create_clock -name board_clk -period 20.000 [get_ports {board_clk}]
derive_pll_clocks
derive_clock_uncertainty
set_false_path -from [get_ports {input_0 input_1 input_panic}]
set_false_path -to [get_ports {output_LED_0* output_LED_1* unused_LED panic_LED
seg_0* seg_1* seg_2* seg_3* seg_4*
}]
