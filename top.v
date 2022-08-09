
module top(board_clk,input_0,input_1,input_panic,output_LED_0, output_LED_1,
unused_LED, panic_LED, seg_0, seg_1, seg_2, seg_3, seg_4);

//INPUTS:
input wire board_clk;
input wire input_0;
input wire input_1;
input wire input_panic;
//board_clk - WIRE FROM (50 MHz CLOCK) TO (THE PLL INPUT)
//input_0 - WIRE FROM (PUSH BUTTON THAT CONTROLS RIGHT DOOR) TO (EDGE_DETECTOR_0)
//input_1 - WIRE FROM (PUSH BUTTON THAT CONTROLS LEFT DOOR) TO (EDGE_DETECTOR_1)
//input_panic - WIRE FROM (PUSH BUTTON "PANIC") TO (EDGE_DETECTOR_PANIC)


//OUTPUTS:
output  wire [3:0] output_LED_0;
output  wire [3:0] output_LED_1;
output  wire       panic_LED;
output  wire [6:0] seg_0;
output  wire [6:0] seg_1;
output  wire [6:0] seg_2;
output  wire [6:0] seg_3;
output  wire [6:0] seg_4;
output  reg        unused_LED;
//output_LED_0 - BUS OF WIRES FROM (OUTPUT_CONTROL) TO (LEDS THAT SHOW STATE OF THE RIGHT DOOR)
//output_LED_1 - BUS OF WIRES FROM (OUTPUT_CONTROL) TO (LEDS THAT SHOW STATE OF THE LEFT DOOR)
//panic_LED - BUS OF WIRES FROM (OUTPUT_CONTROL) TO (LED THAT SHOWS "PANIC ALARM")
//seg_0 - BUS OF WIRES FROM (OUTPUT_CONTROL) TO (HEX DISPLAY_0)
//seg_1 - BUS OF WIRES FROM (OUTPUT_CONTROL) TO (HEX DISPLAY_1)
//seg_2 - BUS OF WIRES FROM (OUTPUT_CONTROL) TO (HEX DISPLAY_2)
//seg_3 - BUS OF WIRES FROM (OUTPUT_CONTROL) TO (HEX DISPLAY_3)
//seg_4 - BUS OF WIRES FROM (OUTPUT_CONTROL) TO (HEX DISPLAY_4)
//unused_LED - REGISTER THAT PULLS DOWN THE LEDR_8

//OTHER NETS AND VARIABLES:
wire clk; 
wire tick_0;
wire tick_1;
wire tick_panic;
wire [`STATE_SIZE:0] state_reg; 
wire [`STATE_SIZE:0] state_next;
wire [`TIMER_SIZE:0] t;
wire btn;
wire [`SEC_TIMER_SIZE:0] sec_t;
//clk - WIRE FROM (PLL) TO (ALL OTHER MODULES)
//tick_0 - WIRE FROM (EDGE_DETECTOR_0) TO (BUTTON_DETECTOR AND FSM)
//tick_1 - WIRE FROM (EDGE_DETECTOR_1) TO (BUTTON_DETECTOR AND FSM)
//tick_panic - WIRE FROM (EDGE_DETECTOR_PANIC) TO (FSM)
//state_reg - BUS OF WIRES FROM (STATE_CHANGE) TO (ALL OTHER MODULES)
//state_next - BUS OF WIRES FROM (FSM) TO (STATE_CHANGE AND TIMER)
//t - BUS OF WIRES FROM (TIMER) TO (OUTPUT_CONTROL)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
pll_0002 pll_inst (
		.refclk   (board_clk), 
		.rst      (),      
		.outclk_0 (clk), 
		.locked   ()       
	);
	
	edge_detector edge_detector_0 (
		.clk  (clk),  
		.level      (input_0),      
		.tick (tick_0) 
	);
	
	edge_detector edge_detector_1 (
		.clk  (clk),   
		.level      (input_1),      
		.tick (tick_1)
	);
	
	edge_detector edge_detector_panic (
		.clk  (clk),   
		.level      (input_panic),    
		.tick (tick_panic) 
	);
	
	btn_detector btn_detector_u (
		.clk  (clk), 
		.tick_0      (tick_0),      
		.tick_1 (tick_1), 
		.state_reg (state_reg),
		.btn (btn)
	);
	
	timer timer_u (
		.clk  (clk),   
		.state_next      (state_next),     
		.state_reg (state_reg), 
		.sec_t (sec_t),
		.t (t)
	);
	
	state_change state_change_u (
		.clk  (clk),   
		.state_next  (state_next),    
		.state_reg (state_reg) 
	);
	
	FSM FSM_u (
		.clk  (clk),   
		.state_next      (state_next),      
		.state_reg (state_reg), 
		.sec_t (sec_t),
		.tick_0 (tick_0),
		.tick_1 (tick_1),
		.tick_panic (tick_panic)
	);
	
	output_control output_control_u (
		.clk  (clk),   
		.btn      (btn),      
		.state_reg (state_reg), 
		.sec_t (sec_t),
		.t (t),
		.output_LED_0     (output_LED_0),
		.output_LED_1 (output_LED_1),
		.panic_LED    (panic_LED),
		.seg_0 (seg_0),
		.seg_1 (seg_1),
		.seg_2 (seg_2),
		.seg_3 (seg_3),
		.seg_4 (seg_4)
	);  
	
endmodule
//////////////////////////////////////////////////////////////////////////////////////////////////////////////// 