`include "defines.v"
`include "mux32.v"

`include "../register.v"
`include "instructionMem.v"
module IFStage (clk, rst, branch_taken, branch_offset, freeze, PC, instruction);
  input clk, rst, branch_taken, freeze;
  input [`WORD_LEN-1:0] branch_offset;
  output [`WORD_LEN-1:0] PC, instruction;

  wire [`WORD_LEN-1:0] PC_offset, PC_next, branch_offset_sl2;

  Mux32 adderInput (
    .in1(32'd4),
    .in2(branch_offset_sl2),
    .sel(branch_taken), //
    .out(PC_offset)
  );

  // Adder PCadder (
  //   .in1(PC_offset),
  //   .in2(PC), //
  //   .out(PC_next)
  // );
  assign PC_next = PC_offset + PC;

  Register PCReg ( // for flush
    .clk(clk),
    .rst(rst),
    .writeEn(~freeze),
    .regIn(PC_next),
    .regOut(PC) //
  );

  InstructionMem instructions (
    .rst(rst),
    .addr(PC),
    .instruction(instruction)
  );

  assign branch_offset_sl2 = branch_offset << 2;
endmodule // IFStage
