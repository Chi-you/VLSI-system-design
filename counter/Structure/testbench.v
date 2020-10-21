`include "./counter.v"
`timescale 1ns/10ps
`define clkPeriod 20

module testbench();

reg mode, clk, rst_n;
wire [4:0] counter;

Syncounter S1(
    .mode(mode),
    .clk(clk),
    .rst_n(rst_n),
    .counter(counter)
);

// clock generator
always #(`clkPeriod/2) clk = ~clk;

initial begin
    rst_n = 0;
    clk = 0;
    mode = 0;
    # 5   rst_n = 1;
    # 107 rst_n = 0; // check asynchronous reset
    # 23  rst_n = 1;
    # 660 mode = 1; // check counter in mode 1
    # 702 rst_n = 0; // check counter in mode 0
    # 28  rst_n = 1; mode = 0; // check asynchronous reset
    # 600 mode = 1;
    # 600 $finish;

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