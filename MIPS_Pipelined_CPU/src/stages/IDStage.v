`include "defines.v"
`include "controller.v"
`include "conditionChecker.v"
`include "Mux5.v"
//`include "mux32.v"
`include "signExtend.v"
module IDStage (clk, rst, hazard_detected_in, instruction, Rs_Value, Rt_Value, 
                is_imm_out, Rs, Rt, ALU_Input1, ALU_Input2, branch_Taken, EXE_CMD, Mem_Read_EN, Mem_Write_EN, WB_EN, branch_CMD,ST_or_BNE_out, Dest,
                Shamt, Shift_Direction, Result_sel, Jump_Offset);
  input clk, rst, hazard_detected_in;
  input [`WORD_LEN-1:0] instruction, Rs_Value, Rt_Value;
  output branch_Taken, Mem_Read_EN, Mem_Write_EN, WB_EN, is_imm_out; 
  output ST_or_BNE_out;
  output [1:0] branch_CMD;
  output [`EXE_CMD_LEN-1:0] EXE_CMD;
  output [`REG_FILE_ADDR_LEN-1:0] Rs, Rt, Dest; // new Dest
  // output src2_forwarding;
  output [`WORD_LEN-1:0] ALU_Input1, ALU_Input2;
  output Shift_Direction, Result_sel;
  output [4:0] Shamt;
  output [25:0] Jump_Offset;


  wire [`REG_FILE_ADDR_LEN-1:0] Rd;
  wire ControlUnit2and, Condition2and;
  wire [1:0] ControlUnit2Condition;
  wire Is_Imm, ST_or_BNE;
  wire [`WORD_LEN-1:0] imm_signExt;
  wire [`REG_FILE_ADDR_LEN-1:0] Rt_wire;

  controller controller( // decode 
    // INPUT
    .instruction(instruction),
    .hazard_detected(hazard_detected_in),
    // OUTPUT
    .EXE_CMD(EXE_CMD),
    .Branch_CMD(ControlUnit2Condition),
    .is_imm(Is_Imm),
    .ST_or_BNE(ST_or_BNE),
    .WB_EN(WB_EN),
    .Mem_Read_EN(Mem_Read_EN),
    .Mem_Write_EN(Mem_Write_EN),
    .Branch_En(ControlUnit2and),
    .Shift_Direction(Shift_Direction),
    .Result_sel(Result_sel)
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

  Mux32 mux_val2 ( // determine whether readdata2 is from the reg file or the immediate value
    .in1(Rt_Value),
    .in2(imm_signExt),
    .sel(Is_Imm),
    .out(ALU_Input2)
  );

// *wire 
  Mux5 mux_dest ( // determine whether readdata2 is from the reg file or the immediate value
    .in1(Rd),
    .in2(Rt_wire),
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
  assign Rt_wire = instruction[20:16];
  assign Rt = Rt_wire;
  assign Rd = instruction[15:11];
  assign is_imm_out = Is_Imm;
  assign ST_or_BNE_out = ST_or_BNE;
  assign branch_CMD = ControlUnit2Condition;
  assign Shamt = instruction[10:6];
  assign Jump_Offset = instruction[25:0];

endmodule // IDStage
