// written with behavioral modelling

`default_nettype none

//---------------------------------------------
/*
ALU
Operations:
	Add, Sub
	Shift Left, Shift Right
	Compare
Flags:
	FLAG 		BIT
	Z zero		0
	C carry		1
	N negative	2
	V overflow	3
*/
//---------------------------------------------

module ALU
#(
	parameter DataWidth = 16,
	parameter FlagBits = 4
)
(
	input wire [FlagBits-1:0] IFlags,
	input wire [DataWidth-1:0] A, B,
	input wire [3:0] FuncOp,

	output wire [DataWidth-1:0] Y,
	output wire [FlagBits-1:0] OFlags
);

localparam ZeroFlag = 0,
		CarryFlag	= 1,
		NegFlag 	= 2,
		OverFlag	= 3;

reg [DataWidth-1:0] ORes;
reg cF;

// '@*' is a wild card - Any signal that is read inside a block, and so may cause the result of a block to change if it's value changes, will be included
always @* begin

	// Initial Conditions
	ORes = {DataWidth{1'b0}};
	cF = 1'b0;

	case(FuncOp)
		`ADD: begin
				`ifdef SIMULATE
					$display("%d Add_OP: A: %h + B: %h", $stime, A, B);
				`endif

				{cF, ORes} = A + B + IFlags[CarryFlag];

				// $display("%d %h + %h = %h = %h", $stime, A, B, (A + B + IFlags[CarryFlag]), {cF, ORes});	// test code for debugging

				`ifdef SIMULATE
					$display("%d Add_OP: Sum: %h, Carry: %h", $stime, ORes, cF);
				`endif
			end

		`SUB: begin					// SUB => Subtract without borrow
				`ifdef SIMULATE
					$display("%d Sub_OP: A: %h - B: %h", $stime, A, B);
				`endif

				{cF, ORes} = A + ((~B) + 1);

				// $display("%d %h - %h = %h + %h = %h = %h", $stime, A, B, A, ((~B) + 1), (A + ((~B) + 1)),{cF, ORes});		// test code for debugging

				`ifdef SIMULATE
					$display("%d Sub_OP: Carry: %h, Diff: %h", $stime, cF, ORes);
				`endif
			end

		`SHL: begin
				`ifdef SIMULATE
					$display("%d Shl_OP: A: %h << B: %h", $stime, A, B);
				`endif

				{cF, ORes} = {A << B, A[DataWidth-1]};
			end

		`SHR: begin
				`ifdef SIMULATE
					$display("%d Shr_OP: A: %h >> B: %h", $stime, A, B);
				`endif

				{cF, ORes} = {A[0], A << B};
			end

		default: begin
				`ifdef SIMULATE
					$display("%d *** ALU UNKNOWN OP: %04b", $stime, FuncOp);
				`endif

				ORes = {DataWidth{1'b0}};
			end
	endcase // FuncOp
end

/*
assign OFlags[2:0] = {				// V
	ORes[DataWidth-1],			// N
	cF,							// C
	ORes == {DataWidth{1'b0}}	// Z
};
*/

assign OFlags = {
	(
		((A[DataWidth-1] == 0) && (B[DataWidth-1] == 0) && (ORes[DataWidth-1] == 1) && (FuncOp != `SUB)) ||
		((A[DataWidth-1] == 1) && (B[DataWidth-1] == 1) && (ORes[DataWidth-1] == 0) && (FuncOp != `SUB)) ||
		((A[DataWidth-1] == 0) && (B[DataWidth-1] == 1) && (ORes[DataWidth-1] == 1) && (FuncOp == `SUB)) ||
		((A[DataWidth-1] == 1) && (B[DataWidth-1] == 0) && (ORes[DataWidth-1] == 0) && (FuncOp == `SUB))
	),							// V
	ORes[DataWidth-1],			// N
	cF,							// C
	ORes == {DataWidth{1'b0}}	// Z
};


/*
	INCOMPLETE ????

	Operation 	VNCZ	Meaning
	X			XXX1	A == B
	ADD			0000	Positive Number
	SUB			0010	Negative Number
	SUB			0100		
				1100	Negative signed number	
				1110	Positive signed number

*/



assign Y = ORes;

endmodule