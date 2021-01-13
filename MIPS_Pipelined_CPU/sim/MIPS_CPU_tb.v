`timescale 1ns/10ps
`define CYCLE 10
`ifdef SYN
  `include "MIPS_CPU_syn.v"
  `include "tsmc13_neg.v"
`else
  `include "../MIPS_CPU.v"
`endif
module MIPS_CPU_tb();
  reg clk,rst, forwarding_EN;
  MIPS_CPU DUT (clk, rst, forwarding_EN);
  `ifdef full
    initial clk = 0;
    always #(`CYCLE/2) clk = ~clk ;

    initial begin
      rst = 1;
      forwarding_EN = 0;
      #100
      rst = 0;
    end
  `endif
  initial begin
    `ifdef FSDB
      $fsdbDumpfile("CPU.fsdb");
      $fsdbDumpvars("+mda");
    `endif
  end
  `ifdef SYN
	  initial $sdf_annotate("../syn/MIPS_CPU_syn.sdf",MIPS_CPU); 
  `endif
endmodule // test
