
module btn_detector (clk,tick_0,tick_1,state_reg,btn);

//INPUTS:
input clk;
input tick_0;
input tick_1;
input [`STATE_SIZE:0] state_reg;
//clk - WIRE FROM (PLL) 
//tick_0 - WIRE FROM (EDGE_DETECTOR_0) 
//tick_1 - WIRE FROM (EDGE_DETECTOR_1) 
//state_reg - BUS OF WIRES FROM (STATE_CHANGE) 

//OUTPUTS:
output reg btn;
//btn - REGISTER THAT INFORMS WHICH BUTTON WAS PRESSED

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
always @(posedge clk) begin
	if (tick_0 && state_reg == `IDLE)
		btn <= 0;
	else if (tick_1 && state_reg == `IDLE)
		btn <= 1;
end

endmodule
////////////////////////////////////////////////////////////////////////////////////////////////////////////////