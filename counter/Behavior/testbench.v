`timescale 1ns/10ps
`include "./counter.v"
`define delay 10
`define clkPeriod 20

module testbench();
reg clk, rst, mode;
wire [4:0] counter;

Syncounter S1(
    .mode(mode),
    .clk(clk),
    .rst(rst),
    .counter(counter)
);

// clock generator
always #(`clkPeriod/2) clk = ~clk;

integer i;
initial begin
    rst = 1;
    clk = 0;
    mode = 1;
    # 5   rst = 0;
    # 107 rst = 1; // check asynchronous reset
    # 23  rst = 0;
    # 660 mode = 0; // check counter in mode 1
    # 702 rst = 1; // check counter in mode 0
    # 28  rst = 0; mode = 1; // check asynchronous reset
    # 600 mode = 0;
    # 600;
    $finish;


end

// generate waveform
initial begin
    $dumpfile("counter.vcd");
    $dumpvars;
end

// initial begin
//     $fsdbDumpfile("counter.fsdb");
//     $fsdbDumpvars;
// end


endmodule