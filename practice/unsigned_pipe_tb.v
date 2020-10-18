`timescale 1 ns/1 ns
`include "./unsigned_pipe.v"
module Pipeline_unsigned_arithmetic_tb;
 
reg        clk, reset_n;
reg  [3:0] i_a, i_b, i_c;
wire [7:0] o_answer;

Pipeline_unsigned_arithmetic u0 (
  .clk(clk),
  .rst_n(reset_n),
  .i_a(i_a),
  .i_b(i_b),
  .i_c(i_c),
  .out(o_answer)
);
 

parameter clkper = 50;
initial begin
  clk = 1;
end
 
always begin
  #(clkper/2) clk = ~clk;
end

initial begin
  // time = 0
  reset_n = 1'b0;
  i_a     = 8'h00;
  i_b     = 8'h00;
  i_c     = 8'h00;
 
  // time = 75
  #75
  reset_n = 1'b1;
  
  // time = 101
  #26
  i_a     = 8'h01;
  i_b     = 8'h02;
  i_c     = 8'h03;
  // o_answer = 8'h05;
  
  // time = 151
  #50
  i_a     = 8'h03;
  i_b     = 8'h01;
  i_c     = 8'h04;
  // o_answer = 8'h0c;
  
  // time = 201
  #50
  i_a     = 8'h00;
  i_b     = 8'h00;
  i_c     = 8'h00;

  #200 $finish;
  
end
initial begin
  $dumpfile("unsigned.vcd");
  $dumpvars;
end
endmodule