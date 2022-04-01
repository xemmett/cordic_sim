// Test bench for Cordic
// Tests for +- angles 
// Edge cases are +-90 and 0 degrees
// Student Names: Charlie Gorey O'Neill, Emmett Lawlor, Niall Coughlan, Cian Surlis, Ciaran Hogan
// Id: 18222803, 18238831, , 18233074, 18238831
`timescale 1ns/1ps

module cordic_tb;
   reg signed[1:-16] angle_in;
   wire signed [1:-16] cos_out, sin_out, angle_out;
   wire 	       done;
   reg 		       clk, init;
   integer 	       count;

   task run_cordic(input signed[1:-16] angle);
      begin
	 $display("test for input angle %d (%15.12f rads, %10.6f degs)", angle, angle/65536.0, angle*0.0008742642137616321); // Displays input angle in in 2.16, radians and degrees
	 clk = 0;
	 init = 0;
	 angle_in = angle;
	 #5 init = 1;
	 count = 0;
	 #5 clk = 1;
	 #5 init = 0;
	 #5 clk = 0;		
	 while ( done == 1'b0 ) begin
	    #5 clk = 1;
	    #10 clk = 0;
	    #5 count = count+1;
	    init = 0;
	 end
	 #5 $display("%6t: %3d: init %1b, done %1b, angle %18b, cos %18b, sin %18b",
		     $time, count, init, done, angle_out, cos_out, sin_out);
	 $display("angle %d (%15.12f), cos %d (%15.12f) sin %d (%15.12f)", 
		  angle_out, angle_out/65536.0, cos_out, cos_out/65536.0, sin_out, sin_out/65536.0);
      end
   endtask

   task run_display(input signed[1:-16] angle, input integer expected_angle, input integer expected_cosine, input integer expected_sine);
      begin
	 run_cordic(angle);
	 $display("Results should be: angle: %d, cosine: %d, sine: %d\n\n", expected_angle, expected_cosine, expected_sine);
      end
   endtask

   // dut - device under test
   CORDIC dut(cos_out, sin_out, angle_out, done, angle_in, init, clk);

   initial
     begin
	// Tests 4 arguments: 1-Input angle, 2-Expected out angle, 3-Expected Cos, 4-Expected Sine. 
	// All arguments presented in 2.16 rads

	#0 run_display(0, -1, 65536, 2);
	#100 run_display(102944, 102945, 2, 65536); // 102944 = pi/2 radians (90 deg) in 2.16 fp format

	#100 run_display(51472, 51473, 46341, 46342); //"		" = pi/4 

	#100 run_display(25736, 25737, 60546, 25081); //"		" = pi/8 

	#100 run_display(77208, 77207, 25081, 60546); //"		" = 3*pi/8 

	#100 run_display(-102944, -102945, -2, -65536); //"		" = -pi/2 

	#100 run_display(-51472, -51471, 46343, -46342); //"		" = -pi/4 

     end

   initial
     begin
	$dumpfile("Cordic1.vcd");
	$dumpvars;
     end
endmodule
