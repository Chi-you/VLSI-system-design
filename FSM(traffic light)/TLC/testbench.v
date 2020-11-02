`include "./traffic_light.v"
`timescale 1ns/10ps
`define Clkperiod 10
module testbench();

reg clk, rst_n, c;
wire R1G, R1Y, R1R, R2G, R2Y, R2R, FG, FY, FR;

Traffic_light T1(
    .c(c),
    .clk(clk),
    .rst_n(rst_n),
    .R1G(R1G),
    .R1Y(R1Y),
    .R1R(R1R),
    .R2G(R2G),
    .R2Y(R2Y),
    .R2R(R2R),
    .FG(FG),
    .FY(FY),
    .FR(FR)
);

// clock generator
always #(`Clkperiod/2) clk = ~clk;

initial begin
    clk = 1'b0;
    rst_n = 1'b0;
    c = 1'b0;
    # 5    rst_n = 1;
    # 1040 c = 1;
    # 140  c = 0;
    # 1090 c = 1;
    # 360  c = 0;
	# 550  c = 1;
	# 220  $finish;
end

/*
initial begin
    $fsdbDumpfile("Traffic_light.fsdb");
    $fsdbDumpvars;
end
*/

initial begin
    $dumpfile("Traffic_light.vcd");
    $dumpvars;
end

endmodule
