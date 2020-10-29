`include "./traffic_light.v"
`timescale 1ns/10ps
`define INTERVAL 10
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
always #(`INTERVAL/2) clk = ~clk;

initial begin
    clk = 0;
    rst_n = 1'b0;
    c = 0;
    #`INTERVAL rst_n = 1;
    // #`INTERVAL
    // #`INTERVAL
    // #`INTERVAL
    // #`INTERVAL
    // #`INTERVAL
    // #`INTERVAL
    // #`INTERVAL
    # 1000 c = 1;
    # 200  c = 0;
    # 1000 c = 1;
    # 100 $finish;
end

// initial begin
//     $fsdbDumpfile("counter.fsdb");
//     $fsdbDumpvars;
// end

initial begin
    $dumpfile("FSM.vcd");
    $dumpvars;
end

endmodule