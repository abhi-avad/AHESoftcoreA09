// -------------------------------------------------------
// Test bench
// -------------------------------------------------------

// Compiler directive that specifies the time unit and time precision of the modules that follow it
// syntax: `timescale time_unit / time_precision
// The time_unit argument specifies the unit of measurement for times and delays
// The time_precision argument specifies how delay values are rounded before being used in simulation
`timescale 1ns/1ps 

`define VCD_OUTPUT "register_tb.vcd"

module register_tb;

	parameter Data_WIDTH = 16;

	// Test bench Signals
	// Output from registers

	wire [Data_WIDTH-1:0] DOut_TB;

	reg Reset_TB;
	reg LD_TB;
	reg [Data_WIDTH-1:0] DIn_TB;

	reg Clock_TB;

	// --------------------------------
	// Device under test
	// --------------------------------
	Register #( .DataWidth(Data_WIDTH)) reg_sim (
		.Reset(Reset_TB),
		.Clk(Clock_TB),
		.LD(LD_TB),
		.DIn(DIn_TB),
		.DOut(DOut_TB)
		);

	// --------------------------------
	// Test bench clock
	// --------------------------------
	initial begin
		Clock_TB <= 1'b0;
	end

	always begin
		#100 Clock_TB = ~Clock_TB;
	end

	// --------------------------------
	// Configure starting sim state
	// --------------------------------
	initial begin
		$dumpfile(`VCD_OUTPUT);
		$dumpvars; // Save waveforms to vcd file

		$display("%d %m: Starting testbench simulation ...", $stime); // %m lists the module

		Reset_TB = 1'b0;
		DIn_TB = {Data_WIDTH{1'b0}};
		LD_TB = 1'b1;
	end

	always begin
		
		// --------------------------------
		// Reset first
		// --------------------------------
		// On the posedge of clk we configure/setup signals
		@(posedge Clock_TB);
		Reset_TB = 1'b0; // enable reset i.e wipe register
		LD_TB = 1'b1; // disable load

		// On the negedge we take action
		@(negedge Clock_TB);
		#1 // Wait for data

		$display("%d <- Marker", $stime);

		// Make sure register is reset
		if (DOut_TB != 16'h0000) begin
			$display("%d %m: ERROR - (0) PC output incorrect (%h)", $stime, DOut_TB);
			$finish;
		end

		// --------------------------------
		// Load
		// --------------------------------

		@(posedge Clock_TB);
		Reset_TB = 1'b1; // Disable reset
		DIn_TB = 16'h00A0; // Set Address to 0x00A0, we say address since we'll be using a register as the Program Counter (PC)
		LD_TB = 1'b0; // Enable load

		@(negedge Clock_TB);
		#1

		if (DOut_TB != 16'h00A0) begin
			$display("%d %m: ERROR - (1) PC output incorrect (%h)", $stime, DOut_TB);
			$finish;
		end

		// --------------------------------
		// Reset again
		// --------------------------------
		@(posedge Clock_TB);
		Reset_TB = 1'b0;
		LD_TB = 1'b1;

		@(negedge Clock_TB);
		#1

		if (DOut_TB != 16'h0000) begin
			$display("%d %m: ERROR - (2) PC output incorrect (%h)", $stime, DOut_TB);
			$finish;
		end

		// --------------------------------
		// Simulation duartion
		// --------------------------------

		#50 $display("%d %m: Testbench simulation PASSED", $stime);
		$finish;

	end

endmodule