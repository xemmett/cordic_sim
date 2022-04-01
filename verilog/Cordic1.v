/*
 * Cordic1.v - Implementation of a 2.16 Cordic Processor
 * Co-Ordinate Rotational by DIgital Computer
 * Student Names: Charlie Gorey O'Neill, Emmett Lawlor, Niall Coughlan, Cian Surlis, Ciaran Hogan
 * Id: 18222803, 18238831, , 18233074, 18238831
 */

module CORDIC(output signed[1:-16] cosine,
	      output signed [1:-16] sine,
	      output signed [1:-16] angle,
	      output 		    done,
	      input signed [1:-16]  target_angle,
	      input 		    init, 
	      input 		    clk);

   reg signed [1:-16] 		    current_ang, delta_ang, new_ang, cos, sin, new_cos, new_sin;
   reg [3:0] 			    cycle;
   reg 				    state;
   
   // Create angle step look up table, can have up to 2^18 (262,144) steps, to be calculated externally and
   // then introduced to the program as constants
   // Delta Angle values are scaled by 2^16 so to ensure integer arithmetic up to 16 decimal places.

   always @(*)
     begin
	case(cycle)
	  
	  0: delta_ang = 18'H0C910;
	  1: delta_ang = 18'H076B2; 
	  2: delta_ang = 18'H03EB7;
	  3: delta_ang = 18'H00FFB; 
	  4: delta_ang = 18'H01FD6; 
	  5: delta_ang = 18'H007FF; 
	  6: delta_ang = 18'H00400; 
	  7: delta_ang = 18'H00200; 
	  8: delta_ang = 18'H00100;
	  9: delta_ang = 18'H00080; 
	  10: delta_ang = 18'H00040;
	  11: delta_ang = 18'H00020;
	  12: delta_ang = 18'H00010; 
	  13: delta_ang = 18'H00008;
	  14: delta_ang = 18'h00004;
	  15: delta_ang = 18'h00002;
	  16: delta_ang = 18'h00001; 

	endcase
     end

   always @(posedge clk)
     begin
	if( init == 1'b1 ) begin
	   state <= 0;
	   cycle <= 0;
	   current_ang <= 0;
	   cos <= 18'h09b75; 	// This is constant K which initializes cosine.
	   sin <= 0;
	end
	else begin
	   if ( state == 0 ) begin
	      if ( cycle == 15) begin 
		 state <= 1;
	      end
	      cos <= new_cos;
	      sin <= new_sin;
	      current_ang <= new_ang;
	      cycle <= cycle + 1;
	   end
	end
     end
// Here is the cordic processing algorithm at work
   always @(*)
	begin
	    if ( target_angle >= angle ) begin
		new_ang <= current_ang + delta_ang;	
	   	new_cos <= cos - (sin >>> cycle);
	        new_sin <= sin + (cos >>> cycle);
		    end
	else begin 
		new_ang <= current_ang - delta_ang;
		new_cos <= cos + (sin >>> cycle);
		new_sin <= sin - (cos >>> cycle);
	 end
end
   assign done = state;
   assign cosine = cos;
   assign sine = sin;
   assign angle = current_ang;

endmodule







