`timescale 1ns/10ps
`include "./test.v"
`define Clkperiod 10

module test_tb();
reg a, clk;
wire b;
test t1(a, clk, b);
always #(`Clkperiod/2) clk = ~clk; // clk = 10
initial begin
    a = 0;
    clk = 0;
    # 5 a = 1;
    # 5 a = 0;
    # 10 $finish;
end
initial begin
    $dumpfile("test.vcd");
    $dumpvars;
end

endmodule
