$display("%d Begining SUB tests", $time);

@(posedge Clock_TB);
IFlags_TB = 4'b0000;    // Clearing All Flags
FuncOp_TB = `SUB;       // Selecting Sub Op

// -------------------------------------------------------
// 0000 - 0000 = 0
//            V N C Z
// Flags set: 0,0,0,1
// -------------------------------------------------------

A_TB = 16'h0000;
B_TB = 16'h0000;

$display("%d Checking : %h, %h", $time, A_TB, B_TB);

@(negedge Clock_TB);
$display("%d Flags : %04b", $time, OFlags_TB);
if (OFlags_TB != 4'b0001) begin
    $display("%d ERROR - Expected Zero Flag set. Got : (%04b).", $time, OFlags_TB);
    $finish;
end

if (Y_TB != 'b0) begin
    $display("%d ERROR - Expected difference of 0. Got : (%d).", $time, Y_TB);
    $finish;
end

// -------------------------------------------------------
// 0002 - 0001 = 0001 => 0002 + FFFF = 10001
//            V N C Z
// Flags set: 0,0,0,0
// -------------------------------------------------------

@(posedge Clock_TB);

A_TB = 16'h0002;
B_TB = 16'h0001;

$display("%d Checking : %h, %h", $time, A_TB, B_TB);

@(negedge Clock_TB);
$display("%d Flags : %04b", $time, OFlags_TB);
if (OFlags_TB != 4'b0000) begin
    $display("%d ERROR - Expected Zero Flag cleared. Got : (%04b).", $time, OFlags_TB);
    $finish;
end

if (Y_TB != 'h0001) begin
    $display("%d ERROR - Expected difference of 1. Got : (%d).", $time, Y_TB);
    $finish;
end


// -------------------------------------------------------
// 0000 - 0001 = -1 => 0000 + FFFF = FFFF
//            V N C Z
// Flags set: 0,1,1,0
// -------------------------------------------------------

@(posedge Clock_TB);

A_TB = 16'h0000;
B_TB = 16'h0001;

$display("%d Checking : %h, %h", $time, A_TB, B_TB);

@(negedge Clock_TB);
$display("%d Flags : %04b", $time, OFlags_TB);
if (OFlags_TB != 4'b0110) begin
    $display("%d ERROR - Expected Neg and Carry Flag set. Got : (%04b).", $time, OFlags_TB);
    // $finish;
end

if (Y_TB != 'hFFFF) begin
    $display("%d ERROR - Expected difference of -1. Got : (%d).", $time, Y_TB);
    // $finish;
end

// -------------------------------------------------------
// FFFF - 00FF = FF00 => FFFF + FF01 = FF00
//            V N C Z
// Flags set: 0,1,0,0
// -------------------------------------------------------

@(posedge Clock_TB);

A_TB = 16'hFFFF;
B_TB = 16'h00FF;

$display("%d Checking : %h, %h", $time, A_TB, B_TB);

@(negedge Clock_TB);
$display("%d Flags : %04b", $time, OFlags_TB);
if (OFlags_TB != 4'b0100) begin
    $display("%d ERROR - Expected Carry Flag cleared. Got : (%04b).", $time, OFlags_TB);
    // $finish;
end

if (Y_TB != 'hFF00) begin
    $display("%d ERROR - Expected difference of FF00. Got : (%d).", $time, Y_TB);
    // $finish;
end

// -------------------------------------------------------
// 00FF - FFFF = FF00 => 00FF + 0001 = 0100
//            V N C Z
// Flags set: 0,0,1,0
// -------------------------------------------------------

@(posedge Clock_TB);

A_TB = 16'h00FF;
B_TB = 16'hFFFF;

$display("%d Checking : %h, %h", $time, A_TB, B_TB);

@(negedge Clock_TB);
$display("%d Flags : %04b", $time, OFlags_TB);
if (OFlags_TB != 4'b0010) begin
    $display("%d ERROR - Expected Neg Flag cleared, Carry Flag set. Got : (%04b).", $time, OFlags_TB);
    // $finish;
end

if (Y_TB != 'h0100) begin
    $display("%d ERROR - Expected difference of FF00. Got : (%d).", $time, Y_TB);
    // $finish;
end

// -------------------------------------------------------
// Clearing carry results in subtracting 1
// FFFF - 0001 = FFFF + FFFF = FFFE
//            V N C Z
// Flags set: 0,1,0,0
// -------------------------------------------------------

@(posedge Clock_TB);

A_TB = 16'hFFFF;
B_TB = 16'h0001;

$display("%d Checking : %h, %h", $time, A_TB, B_TB);

@(negedge Clock_TB);
$display("%d Flags : %04b", $time, OFlags_TB);
if (OFlags_TB != 4'b0100) begin
    $display("%d ERROR - Expected Neg Flag set, Carry Flag cleared. Got : (%04b).", $time, OFlags_TB);
    // $finish;
end

if (Y_TB != 'hFFFE) begin
    $display("%d ERROR - Expected difference of FFFE. Got : (%d).", $time, Y_TB);
    // $finish;
end

// -------------------------------------------------------
// FFFF - FFO2 = FFFF + 00FE = 00FD
//            V N C Z
// Flags set: 0,0,0,0
// -------------------------------------------------------

@(posedge Clock_TB);

A_TB = 16'hFFFF;
B_TB = 16'hFF02;

$display("%d Checking : %h, %h", $time, A_TB, B_TB);

@(negedge Clock_TB);
$display("%d Flags : %04b", $time, OFlags_TB);
if (OFlags_TB != 4'b0000) begin
    $display("%d ERROR - Expected Neg Flag cleared. Got : (%04b).", $time, OFlags_TB);
    // $finish;
end

if (Y_TB != 'h00FD) begin
    $display("%d ERROR - Expected difference of 00FD. Got : (%h).", $time, Y_TB);
    // $finish;
end


// -------------------------------------------------
// 0023 - FFCF = 0023 + 0031 = 0054
//            V N C Z
// Flags set: 0,0,1,0
// -------------------------------------------------------

@(posedge Clock_TB);

A_TB = 16'h0023;
B_TB = 16'hFFCF;

$display("%d Checking : %h, %h", $time, A_TB, B_TB);

@(negedge Clock_TB);
$display("%d Flags : %04b", $time, OFlags_TB);
if (OFlags_TB != 4'b0010) begin
    $display("%d ERROR - Expected Carry Flag set. Got : (%04b).", $time, OFlags_TB);
    // $finish;
end

if (Y_TB != 'h0054) begin
    $display("%d ERROR - Expected difference of 0054. Got : (%h).", $time, Y_TB);
    // $finish;
end


// -------------------------------------------------------
// Clearing carry results in subtracting 1
// FFFF - FFFF = FFFF + 0001 = 0000
//            V N C Z
// Flags set: 0,0,0,0
// -------------------------------------------------------

@(posedge Clock_TB);

A_TB = 16'hFFFF;
B_TB = 16'hFFFF;

$display("%d Checking : %h, %h", $time, A_TB, B_TB);

@(negedge Clock_TB);
$display("%d Flags : %04b", $time, OFlags_TB);
if (OFlags_TB != 4'b0001) begin
    $display("%d ERROR - Expected Zero Flag set. Got : (%04b).", $time, OFlags_TB);
    // $finish;
end

if (Y_TB != 'h0000) begin
    $display("%d ERROR - Expected difference of 0. Got : (%d).", $time, Y_TB);
    // $finish;
end


// ------------------------------------
// Simulation duration
// ------------------------------------


#10 $display("%d %m: Testbench simulation PASSED.", $stime);
$finish;