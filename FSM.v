
module FSM (clk,tick_0,tick_1,tick_panic,state_reg,state_next,sec_t);

//INPUTS:
input clk;
input tick_0;
input tick_1;
input tick_panic;
input [`STATE_SIZE:0] state_reg;
input [`STATE_SIZE:0] sec_t;
//clk - WIRE FROM (PLL) 
//tick_0 - WIRE FROM (EDGE_DETECTOR_0) 
//tick_1 - WIRE FROM (EDGE_DETECTOR_1)
//tick_panic - WIRE FROM (EDGE_DETECTOR_PANIC)
//state_reg - BUS OF WIRES FROM (STATE_CHANGE)
//sec_t - BUS OF WIRES FROM (TIMER) 

//OUTPUTS:
output reg [`STATE_SIZE:0] state_next;
//state_next - REGISTER THAT STORES VALUE OF THE STATE THAT WILL BE AFTER ONE CLOCK CYCLE FROM "NOW"

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
always @(tick_0,tick_1,tick_panic,state_reg,clk) begin 
    case (state_reg)
        `IDLE : begin
            if (tick_0 || tick_1) begin  
                state_next = `OPEN;
            end
				else if (tick_panic)
					state_next = `PANIC;
            else begin 
                state_next = `IDLE; 
            end
        end
        `OPEN : begin
            if ( sec_t >= `TIME_OPEN) begin 
                state_next = `WAIT; 
            end
				else if (tick_panic)
					state_next = `PANIC;
            else begin
                state_next = `OPEN; 
            end
        end
        `WAIT : begin
           if (sec_t >= `TIME_WAIT) begin  
                state_next = `CLOSE; 
            end
				else if (tick_panic)
					state_next = `PANIC;
            else begin 
                state_next = `WAIT; 
            end
        end
		  `CLOSE : begin
           if (sec_t >= `TIME_CLOSE) begin  
                state_next = `IDLE; 
            end
				else if (tick_panic)
					state_next = `PANIC;
            else begin 
                state_next = `CLOSE; 
            end
			end
			default: begin
					state_next = state_reg;
				end
    endcase
end 

endmodule
////////////////////////////////////////////////////////////////////////////////////////////////////////////////