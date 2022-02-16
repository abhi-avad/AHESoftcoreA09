// Compiler directive that controls the net type created for implicit net declarations
// syntax: `default_nettype value   value can be wire | tri | tri0 | tri1 | wand | triand | wor | trior | trireg | uwire | none 
// when set to none, all variables mus be explicitly delcared, else error is thrown
`default_nettype none 

module Register 
#(
	parameter DataWidth = 8)
(
	input wire Clk,					// Clock
	input wire Reset,				// Active Low
	input wire LD,					// Load: Active Low
	input wire [DataWidth-1:0] DIn,	// Input
	output reg [DataWidth-1:0] DOut	// Output
);

// register acts only on negative edge of clock
always @(negedge Clk) begin

	if (~Reset) begin
		
		// if a complier directive named SIMULATE is `define-d then this code is compiled
		`ifdef SIMULATE
			$display("%d Register reset", $stime); // $stime returns an unsigned integer that is a 32-bit time, scaled to the timescale unit of the module 
		`endif

		// {multiplier{data}} used for replication, {data,data,data...} used for concatenation
		// ' = ' blocking assignment, ' <= ' non-blocking assignment
		DOut <= {DataWidth{1'b0}};

	end
	else if (~LD) begin

		`ifdef SIMULATE
			$display("%d Register load: ",);
		`endif

		DOut <= DIn;

	end
end
endmodule