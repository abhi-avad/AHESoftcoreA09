// -------------------------------------------------------
// Test bench
// -------------------------------------------------------

`timescale 1ns/1ps 

`define VCD_OUTPUT "alu_tb.vcd"

module alu_tb;

	parameter Data_WIDTH = 16;
	parameter Flag_BITS = 4;

	wire [Data_WIDTH-1:0] Y_TB;
	wire [Flag_BITS-1:0] OFlags_TB;

	reg [Flag_BITS-1:0] IFlags_TB;
	reg [Data_WIDTH-1:0] A_TB, B_TB;
	reg [3:0] FuncOp_TB;

	reg Clock_TB;

	// -------------------------------------------------------
	// Clock - although ALU is async, clock is used as way to sample
	// -------------------------------------------------------

	initial begin
		Clock_TB <= 1'b0;
	end

	always begin
		#100 Clock_TB = ~Clock_TB;
	end

	// --------------------------------
	// Device under test
	// --------------------------------

	ALU #(.DataWidth(Data_WIDTH), .FlagBits(4)) alu_sim (
		.IFlags(IFlags_TB),
		.A     (A_TB),
		.B     (B_TB),
		.FuncOp(FuncOp_TB),
		.OFlags(OFlags_TB),
		.Y     (Y_TB)
		);

	// --------------------------------
	// Configure starting sim state
	// --------------------------------
	initial begin
		$dumpfile(`VCD_OUTPUT);
		$dumpvars; // Save waveforms to vcd file

		$display("%d %m: Starting testbench simulation ...", $stime); // %m lists the module
	end

	`include "../../Modules/constants.v"

	always begin
		`ifdef SIMULATE_ADD
			$display("%d Simulating ADD Operation", $stime);
			`include "add_op.v"
		`endif

		`ifdef SIMULATE_SUB
			$display("%d Simulating SUB Operation", $stime);
			`include "sub_op.v"
		`endif

		#100 $finish;
	end

endmodule