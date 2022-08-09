
module state_change(clk,state_next,state_reg);

//INPUTS:
input clk;
input [`STATE_SIZE:0] state_next;
//clk - WIRE FROM (PLL) 
//state_next - BUS OF WIRES FROM (FSM) 

//OUTPUTS:
output reg [`STATE_SIZE:0] state_reg;
//state_reg - REGISTER THAT STORES VALUE OF CURRENT STATE

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
initial
	state_reg = `IDLE;

always @(posedge clk) begin
        state_reg <= state_next;
 end
 
endmodule
////////////////////////////////////////////////////////////////////////////////////////////////////////////////