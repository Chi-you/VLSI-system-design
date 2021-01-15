`include "defines.v"
//`include "mux32.v"
`include "Register.v"
`include "instructionMem.v"
module IFStage (clk, rst, branch_Taken, branch_offset, freeze, Jump_Offset, ID_op, PC /*instruction,*/ );
  input clk, rst, branch_Taken, freeze;
  input [`WORD_LEN-1:0] branch_offset;
  input [25:0]Jump_Offset;
  input [5:0]ID_op;

  output [`WORD_LEN-1:0] PC ;//instruction;

  wire [`WORD_LEN-1:0] PC_succeeded, PC_offset, PC_next, branch_offset_sl2;
  wire [`WORD_LEN-1:0] PC_wire;

  /*
  Mux_3input32 adderInput (
    .in1(32'd4),
    .in2(branch_offset_sl2),
    .sel(branch_taken), //
    .out(PC_offset)
  );

  Adder PCadder (
    .in1(PC_offset),
    .in2(PC), //
    .out(PC_next)
  );

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
  */

  Mux32 PCoffsetInput (
    .in1(branch_offset_sl2 + PC_wire),
    .in2({PC_wire[31:28], Jump_Offset, 2'b00}),
    .sel(ID_op == 6'd2), //
    .out(PC_offset)
  );
  Mux32 PCREGInput (
    .in1(PC_succeeded),
    .in2(PC_offset),
    .sel(branch_Taken), //
    .out(PC_next)
  );

  
  assign PC_succeeded = PC_wire + 32'd4;

  Register PCReg ( // for flush
    .clk(clk),
    .rst(rst),
    .writeEn(~freeze),
    .regIn(PC_next),
    .regOut(PC_wire) //
  );
/*
  instructionMem instructions (
    .rst(rst),
    .addr(PC),
    .instruction(instruction)
  );
*/
  assign branch_offset_sl2 = branch_offset << 2;
  assign PC = PC_wire;


endmodule // IFStage
