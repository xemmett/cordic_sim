/*
* Cordic1.v - Implementation of a 2.16 Cordic Processor
* Co-Ordinate Rotational by DIgital Computer
* 
* 
*/

module CORDIC(output signed[1:-16] cosine,
		output signed[1:-16] sine,
		output signed[1:-16] angle,
		output done,
		input signed[1:-16] target_angle,
		input init, clk);

	reg signed[1:-16] current_ang, delta_ang, new_ang, cos, sin, new_cos, new_sin;
	reg[3:0] cycle;
	reg state;
	
// Create angle step look up table, can have 2^18 (262,144) steps, to be calculated externally and
// then introduced to the program as constants

	always @(*)
	begin
		case(cycle)
		//	0: delta_ang = ... 
		//	1: delta_ang = ... Put in hex
		// So on...
		endcase
	end

	always @(posedge clk)
	begin
		if( init == 1'b1 ) begin
		state <= 0;
		cycle <= 0;
		current_ang <= 0;
	// 	cos <= K - this will have to be calculated externally and will be dependent on how
	// many steps we decide to implement
		sin <= 0;
		end
		else begin
		if ( state = 0 ) begin
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










