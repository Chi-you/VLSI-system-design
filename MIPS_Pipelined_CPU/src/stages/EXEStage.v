`include "defines.v"
`include "Mux_3input32.v"
`include "ALU.v"
`include "shifter.v"
//`include "mux32.v"
module EXEStage(/*clk,*/ EXE_CMD, Shift_Direction, Result_sel, Shamt, ALU_src1_sel, ALU_src2_sel, Store_Value_sel, ALU_Input1, ALU_Input2, ALU_Result_MEM, Result_WB, Store_Value_in, ALU_Result, Store_Value);

// input clk;
input Shift_Direction, Result_sel;
input [4:0] Shamt;
input [1:0] ALU_src1_sel, ALU_src2_sel, Store_Value_sel;
input [`WORD_LEN-1:0] ALU_Input1, ALU_Input2, ALU_Result_MEM, Result_WB, Store_Value_in;
input [`EXE_CMD_LEN-1:0] EXE_CMD;

output [`WORD_LEN-1:0] ALU_Result, Store_Value;

wire [`WORD_LEN-1:0] mux1_out, mux2_out, ALU_Result_ALU , Shift_Result;

  Mux_3input32 mux_ALU_Input1 (
    .in1(ALU_Input1),
    .in2(ALU_Result_MEM),
    .in3(Result_WB),
    .sel(ALU_src1_sel),
    .out(mux1_out)
  );

  Mux_3input32 mux_ALU_Input2 (
    .in1(ALU_Input2),
    .in2(ALU_Result_MEM),
    .in3(Result_WB),
    .sel(ALU_src2_sel),
    .out(mux2_out)
  );

  Mux_3input32 mux_Store_Valueue (
    .in1(Store_Value_in),
    .in2(ALU_Result_MEM),
    .in3(Result_WB),
    .sel(Store_Value_sel),
    .out(Store_Value)
  );
  
  ALU ALU(
    .Input1(mux1_out),
    .Input2(mux2_out),
    .EXE_CMD(EXE_CMD),
    .aluOut(ALU_Result_ALU)
  );

  shifter shifter(
    .din(ALU_Input2),
    .sn(Shamt),
    .sd(Shift_Direction),
    .dout(Shift_Result)
  );

  Mux32 mux_ALU_Result (
    .in1(ALU_Result_ALU),
    .in2(Shift_Result),
    .sel(Result_sel),
    .out(ALU_Result)
  );

  
endmodule
