
module output_control(clk,output_LED_0,output_LED_1,panic_LED,seg_0,
seg_1,seg_2,seg_3,seg_4,state_reg,t,sec_t,btn);

//INPUTS:
input clk;
input [`STATE_SIZE:0] state_reg;
input [`TIMER_SIZE:0] t;
input [`STATE_SIZE:0] sec_t;
input btn;
//clk - WIRE FROM (PLL) 
//state_reg - BUS OF WIRES FROM (STATE_CHANGE) 
//t - BUS OF WIRES FROM (TIMER) 
//sec_t - BUS OF WIRES FROM (TIMER) 

//OUTPUTS:
output reg [6:0] output_LED_0;
output reg [6:0] output_LED_1;
output reg panic_LED;
output reg [7:0] seg_0;
output reg [7:0] seg_1;
output reg [7:0] seg_2;
output reg [7:0] seg_3;
output reg [7:0] seg_4;
//output_LED_0 - REGISTER THAT STORES STATE OF THE RIGHT DOOR
//output_LED_0  - REGISTER THAT STORES STATE OF THE RIGHT DOOR
//panic_LED - REGISTER THAT STORES STATE OF THE "PANIC LED"
//seg_0 - REGISTER THAT STORES CONTROL VALUES FOR HEX DISPLAY_0
//seg_1 - REGISTER THAT STORES CONTROL VALUES FOR HEX DISPLAY_1
//seg_2 - REGISTER THAT STORES CONTROL VALUES FOR HEX DISPLAY_2
//seg_3 - REGISTER THAT STORES CONTROL VALUES FOR HEX DISPLAY_3
//seg_4 - REGISTER THAT STORES CONTROL VALUES FOR HEX DISPLAY_4

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
always @( posedge clk) begin 
    case (state_reg)  
        `IDLE : begin
				output_LED_0 = 4'b1111;
				output_LED_1 = 4'b1111;
				panic_LED <= 0;
			
				seg_0 = 7'b1111001;
				seg_1 = 7'b0100001;
				seg_2 = 7'b1000111;
				seg_3 = 7'b0000110;
				seg_4 = 7'b1111111;
        end
        `OPEN : begin
				seg_0 = 7'b1000000;
				seg_1 = 7'b0001100;
				seg_2 = 7'b0000110;
				seg_3 = 7'b0101011;
				seg_4 = 7'b1111111;
			if (t == `T)
			begin
			   if (btn == 0)
				begin
					output_LED_0 = output_LED_0 >> 1;
				end
				else if (btn == 1)
				begin
					output_LED_1 = output_LED_1 >> 1;
				end
		   end
        end
        `WAIT : begin
				seg_0 = 7'b1000001;
				seg_1 = 7'b0001000;
				seg_2 = 7'b1111001;
				seg_3 = 7'b1001110;
				seg_4 = 7'b1111111;
			  if (btn == 0)
					output_LED_0 = 4'b0000;
				else if (btn == 1)
					output_LED_1 = 4'b0000;
        end
		  `CLOSE : begin
				seg_0 = 7'b1000110;
				seg_1 = 7'b1000111;
				seg_2 = 7'b1000000;
				seg_3 = 7'b0010010;
				seg_4 = 7'b0000110;
			if (t == `T)
			begin
				 if (btn == 0)
				 begin
					output_LED_0 = output_LED_0 << 1;
					output_LED_0 = output_LED_0 + 1;
				 end
				else if (btn == 1)
				begin
					output_LED_1 = output_LED_1 << 1;
					output_LED_1 = output_LED_1 + 1;
				end
			 end
			end
		  `PANIC : begin
				seg_0 = 7'b0001100;
				seg_1 = 7'b0001000;
				seg_2 = 7'b0101011;
				seg_3 = 7'b1001111;
				seg_4 = 7'b1000110;
				if (t == `T_quarter || t == `T || t == `T_half || t == `T_3quarter )
				begin
					output_LED_0 = output_LED_0 << 1;
					output_LED_0 = output_LED_0 + 1;
					output_LED_1 = output_LED_1 << 1;
					output_LED_1 = output_LED_1 + 1;
				end	
				if (t == `T || t == `T_half)
					panic_LED <= ~panic_LED;
        end
		  default: begin
			   seg_0 = 7'b0000110;
				seg_1 = 7'b0001000; //ERROR ON 7seg display
				seg_2 = 7'b0001000;
				seg_3 = 7'b0100000;
				seg_4 = 7'b0001000;
			end
    endcase
end
 
endmodule
////////////////////////////////////////////////////////////////////////////////////////////////////////////////