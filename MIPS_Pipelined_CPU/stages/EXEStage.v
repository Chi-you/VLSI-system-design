`include"defines.v"
`include "mux3input32.v"
`include "ALU.v"
module EXEStage(clk, EXE_CMD, Shift_Derection, Result_sel, Shamt, ALU_src1, ALU_src2, Store_Value_sel, ALU_Input1, ALU_Input2, ALU_Result_MEM, Result_WB, Store_Value_in, ALU_Result, Store_Value);

input clk;
input Shift_Derection, Result_sel;
input [4:0] Shamt;
input [1:0] ALU_src1, ALU_src2, Store_Value_sel;
input [`WORD_LEN-1:0] ALU_Input1, ALU_Input2, ALU_Result_MEM, Result_WB, Store_Value_in;
input [`EXE_CMD_LEN-1:0] EXE_CMD;

output [`WORD_LEN-1:0] ALU_Result, Store_Value;

wire [`WORD_LEN-1:0] mux1_out, mux2_out, ALU_Result_ALU , Shift_Result;

  mux_3input32 mux_ALU_Input1 (
    .in1(ALU_Input1),
    .in2(ALU_Result_MEM),
    .in3(Result_WB),
    .sel(ALU_src1),
    .out(mux1_out)
  );

  mux_3input32 mux_ALU_Input2 (
    .in1(ALU_Input2),
    .in2(ALU_Result_MEM),
    .in3(Result_WB),
    .sel(ALU_src2),
    .out(mux2_out)
  );

  mux_3input32 mux_Store_Valueue (
    .in1(Store_Value_in),
    .in2(ALU_Result_MEM),
    .in3(Result_WB),
    .sel(Store_Value_sel),
    .out(Store_Value)
  );
  
  ALU ALU(
    .ALU_Input1(mux1_out),
    .ALU_Input2(mux2_out),
    .EXE_CMD(EXE_CMD),
    .aluOut(ALU_Result_ALU)
  );

  Shifter Shifter(
    .din(ALU_Input2),
    .sn(Shamt),
    .sd(Shift_Derection),
    .dout(Shift_Result)
  );

  mux_32 mux_ALU_Result (
    .in1(ALU_Result_ALU),
    .in2(Shift_Result),
    .sel(Result_sel),
    .out(ALU_Result)
  );

  
endmodule
