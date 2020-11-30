`include "./traffic_light.v"
`timescale 1ns/10ps
`define Clkperiod 5
module testbench();

reg clk, rst_n, c;
wire R1G, R1Y, R1R, R2G, R2Y, R2R, FG, FY, FR;

Traffic_light DUT(
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
    # 520  c = 1;
    # 70   c = 0;
    # 160  c = 1;
    # 180  c = 0;
	# 350  rst_n = 0;
	# 30   rst_n = 1;
	# 150  $finish;
end


initial begin
    $fsdbDumpfile("Traffic_light.fsdb");
    $fsdbDumpvars;
end

endmodule
