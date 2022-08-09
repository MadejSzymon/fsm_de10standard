
module timer (clk,state_next,state_reg,sec_t,t);

//INPUTS:
input clk;
input [`STATE_SIZE:0] state_next;
input [`STATE_SIZE:0] state_reg;
//state_next - BUS OF WIRES FROM (FSM) 
//state_reg - BUS OF WIRES FROM (STATE_CHANGE) 

//OUTPUTS:
output reg [`SEC_TIMER_SIZE:0] sec_t;
output reg [`TIMER_SIZE:0] t;
//sec_t - REGISTER THAT STORES NUMBER OF SECONDS 
//t - REGISTER COUNTS SECONDS

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
always @(posedge clk) begin
	  if (state_reg != state_next) 
	  begin
			t <= 0;
			sec_t <= 0;
	  end
	  
	  if (t == `T)
	  begin
			sec_t <= sec_t + 1;
	  end
	   if (state_reg != `IDLE)
			t <= t + 1; 
end

endmodule
////////////////////////////////////////////////////////////////////////////////////////////////////////////////