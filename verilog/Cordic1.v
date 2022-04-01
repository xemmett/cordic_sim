/*
 * Cordic1.v - Implementation of a 2.16 Cordic Processor
 * Co-Ordinate Rotational by DIgital Computer
 * 
 * 
 */

module CORDIC(output signed[1:-16] cosine,
	      output signed [1:-16] sine,
	      output signed [1:-16] angle,
	      output 		    done,
	      input signed [1:-16]  target_angle,
	      input 		    init, clk);

   reg signed [1:-16] 		    current_ang, delta_ang, new_ang, cos, sin, new_cos, new_sin;
   reg [3:0] 			    cycle;
   reg 				    state;
   
   // Create angle step look up table, can have 2^18 (262,144) steps, to be calculated externally and
   // then introduced to the program as constants
   // Delta Angle values are scaled by 2^20 so to ensure integer arithmetic up to 16 decimal places.

   always @(*)
     begin
	case(cycle)
	  
	  0: delta_ang = 18'H0C910; //823549.664583 
	  1: delta_ang = 18'H076B2; //486169.755256 
	  2: delta_ang = 18'H03EB7; //256878.746667 
	  3: delta_ang = 18'H00FFB; //130395.662762 
	  4: delta_ang = 18'H007FF; //65450.866110 
	  5: delta_ang = 18'H00400; //32757.339579 
	  6: delta_ang = 18'H00200; //16382.666862 
	  7: delta_ang = 18'H00100; //8191.833339 
	  8: delta_ang = 18'H00080; //4095.979167 
	  9: delta_ang = 18'H00040; //2047.997396 
	  10: delta_ang = 18'H00020; //1023.999674 
	  11: delta_ang = 18'H00010; //511.999959 
	  12: delta_ang = 18'H00008; //255.999995 
	  13: delta_ang = 18'h00004; //64.000000 
	  14: delta_ang = 18'h00002; //32.000000 
	  15: delta_ang = 18'h00001; //16.000000 
	  


	endcase
     end

   always @(posedge clk)
     begin
	if( init == 1'b1 ) begin
	   state <= 0;
	   cycle <= 0;
	   current_ang <= 0;
	   cos <= 18'h9b75; 
	   sin <= 0;
	end
	else begin
	   if ( state == 0 ) begin
	      if ( cycle == 15) begin // not sure why he uses 15 
		 state <= 1;
	      end
	      cos <= new_cos;
	      sin <= new_sin;
	      current_ang <= new_ang;
	      cycle <= cycle + 1;
	   end
	end
     end

   always @(*)
	begin
	    if ( target_angle >= angle ) begin
		new_ang <= current_ang + delta_ang;	
	   	new_cos <= cos- (sin >>> cycle);
	        new_sin <= sin - (cos >>> cycle);
		    end
	 end

   assign done = state;
   assign cosine = cos;
   assign sine = sin;
   assign angle = current_ang;

endmodule







