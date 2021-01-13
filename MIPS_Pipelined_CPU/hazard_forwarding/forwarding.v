`include "defines.v"

module forwarding_EXE (Rs_EXE, Rt_EXE, Store_Value_EXE, MEM_Dest, WB_Dest, MEM_WB_EN, WB_WB_EN, EXE_is_imm, ALU_src1_sel, ALU_src2_sel, Store_Value_sel);
  input [`REG_FILE_ADDR_LEN-1:0] Rs_EXE, Rt_EXE, Store_Value_EXE, MEM_Dest, WB_Dest;
  input MEM_WB_EN, WB_WB_EN, EXE_is_imm;
  output reg [`FORW_SEL_LEN-1:0] ALU_src1_sel, ALU_src2_sel, Store_Value_sel;

  always @ (Rs_EXE or Rt_EXE or Store_Value_EXE or MEM_Dest or WB_Dest or MEM_WB_EN or WB_WB_EN) begin

    if (MEM_WB_EN & Store_Value_EXE == MEM_Dest & MEM_Dest != 1'b0)
      Store_Value_sel = `FORW_SEL_LEN'd1;
    else if (WB_WB_EN & Store_Value_EXE == WB_Dest & WB_Dest != 1'b0)
      Store_Value_sel = `FORW_SEL_LEN'd2;
    else
      Store_Value_sel = `FORW_SEL_LEN'd0;

    if (MEM_WB_EN & Rs_EXE == MEM_Dest & MEM_Dest != 1'b0)//EX_hazard
      ALU_src1_sel = `FORW_SEL_LEN'd1;
    else if (WB_WB_EN & Rs_EXE == WB_Dest & WB_Dest != 1'b0)//MEM_hazard when ~EX_hazard
      ALU_src1_sel = `FORW_SEL_LEN'd2;
    else
      ALU_src1_sel = `FORW_SEL_LEN'd0;

    if (MEM_WB_EN & Rt_EXE == MEM_Dest & MEM_Dest != 1'b0 & ~EXE_is_imm)//EX_hazard
      ALU_src2_sel = `FORW_SEL_LEN'd1;
    else if (WB_WB_EN & Rt_EXE == WB_Dest & WB_Dest != 1'b0 & ~EXE_is_imm)//MEM_hazard when ~EX_hazard
      ALU_src2_sel = `FORW_SEL_LEN'd2;
    else
      ALU_src2_sel = `FORW_SEL_LEN'd0;

  end

endmodule
