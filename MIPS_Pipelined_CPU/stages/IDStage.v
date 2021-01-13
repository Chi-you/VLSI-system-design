`include "defines.v"
`include "controller.v"
`include "conditionChecker.v"
`include "mux5.v"
`include "mux32.v"
`include "signExtend.v"
module IDStage (clk, rst, hazard_detected_in, is_imm_out, instruction, Rs_Value, Rt_Value, Rs, Rt, ALU_Input1, ALU_Input2, branch_Taken, EXE_CMD, Mem_Read_EN, Mem_Write_EN, WB_EN, branch_CMD, Dest);
  input clk, rst, hazard_detected_in;
  input [`WORD_LEN-1:0] instruction, Rs_Value, Rt_Value;
  output branch_Taken, Mem_Read_EN, Mem_Write_EN, WB_EN, is_imm_out; 
  // output ST_or_BNE_out;
  output [1:0] branch_CMD;
  output [`EXE_CMD_LEN-1:0] EXE_CMD;
  output [`REG_FILE_ADDR_LEN-1:0] Rs, Rt, Dest; // new Dest
  // output src2_forwarding;
  output [`WORD_LEN-1:0] ALU_Input1, ALU_Input2;

  wire ControlUnit2and, Condition2and;
  wire [1:0] ControlUnit2Condition;
  wire Is_Imm, ST_or_BNE;
  wire [`WORD_LEN-1:0] imm_signExt;

  controller controller( // decode 
    // INPUT
    .opcode(instruction[31:26]),
    .hazard_detected(hazard_detected_in),
    // OUTPUT
    .EXE_CMD(EXE_CMD),
    .Branch_CMD(ControlUnit2Condition),
    .is_imm(Is_Imm),
    //.ST_or_BNE(ST_or_BNE),
    .WB_EN(WB_EN),
    .Mem_Read_EN(Mem_Read_EN),
    .Mem_Write_EN(Mem_Write_EN),
    .Branch_En(ControlUnit2and)
  );

  conditionChecker conditionChecker (
    // input
    .Rs_Value(Rs_Value),
    .Rt_Value(Rt_Value),
    .branch_CMD(ControlUnit2Condition),
    // output
    .branch_Cond(Condition2and)
  );
  // delete
  // mux5 mux_src2 ( // determins the register source 2 for register file
  //   .in1(instruction[15:11]),
  //   .in2(instruction[25:21]),
  //   .sel(ST_or_BNE),
  //   .out(Rt)
  // );

  signExtend signExtend( // signextension
    .in(instruction[15:0]),
    .out(imm_signExt)
  );

  mux32 mux_val2 ( // determine whether readdata2 is from the reg file or the immediate value
    .in1(Rt_Value),
    .in2(imm_signExt),
    .sel(Is_Imm),
    .out(ALU_Input2)
  );

// *wire 
  mux5 mux_dest ( // determine whether readdata2 is from the reg file or the immediate value
    .in1(Rt),
    .in2(Rd),
    .sel(Is_Imm),
    .out(Dest)
  );


  // delete
  // mux5 mux_src2_forwarding ( // for forwarding
  //   .in1(instruction[15:11]), // src2 = instruction[15:11]
  //   .in2(5'd0),
  //   .sel(Is_Imm),
  //   .out(src2_forwarding)
  // );


  // output 
  assign branch_Taken = ControlUnit2and && Condition2and;
  assign ALU_Input1 = Rs_Value;
  assign Rs = instruction[25:21];
  assign Rt = instruction[20:16];
  assign is_imm_out = Is_Imm;
  // assign ST_or_BNE_out = ST_or_BNE;
  assign branch_CMD = ControlUnit2Condition;
endmodule // IDStage
