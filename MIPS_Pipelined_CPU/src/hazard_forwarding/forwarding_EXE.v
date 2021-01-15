`include "defines.v"

module forwarding_EXE (EXE_Rs, EXE_Rt, EXE_Store_Value, MEM_Dest, WB_Dest, MEM_WB_EN, WB_WB_EN, EXE_is_imm, ALU_src1_sel, ALU_src2_sel, Store_Value_sel);
  input [`REG_FILE_ADDR_LEN-1:0] EXE_Rs, EXE_Rt, EXE_Store_Value, MEM_Dest, WB_Dest;
  input MEM_WB_EN, WB_WB_EN, EXE_is_imm;
  output reg [`FORW_SEL_LEN-1:0] ALU_src1_sel, ALU_src2_sel, Store_Value_sel;

  always @ (EXE_Rs or EXE_Rt or EXE_Store_Value or MEM_Dest or WB_Dest or MEM_WB_EN or WB_WB_EN or EXE_is_imm) begin

    if (MEM_WB_EN & EXE_Store_Value == MEM_Dest & MEM_Dest != `REG_FILE_ADDR_LEN'b0)
      Store_Value_sel = `FORW_SEL_LEN'd1;
    else if (WB_WB_EN & EXE_Store_Value == WB_Dest & WB_Dest != `REG_FILE_ADDR_LEN'b0)
      Store_Value_sel = `FORW_SEL_LEN'd2;
    else
      Store_Value_sel = `FORW_SEL_LEN'd0;

    if (MEM_WB_EN & EXE_Rs == MEM_Dest & MEM_Dest != `REG_FILE_ADDR_LEN'b0)//EX_hazard
      ALU_src1_sel = `FORW_SEL_LEN'd1;
    else if (WB_WB_EN & EXE_Rs == WB_Dest & WB_Dest != `REG_FILE_ADDR_LEN'b0)//MEM_hazard when ~EX_hazard
      ALU_src1_sel = `FORW_SEL_LEN'd2;
    else
      ALU_src1_sel = `FORW_SEL_LEN'd0;

    if (MEM_WB_EN & EXE_Rt == MEM_Dest & MEM_Dest != `REG_FILE_ADDR_LEN'b0 & ~EXE_is_imm)//EX_hazard
      ALU_src2_sel = `FORW_SEL_LEN'd1;
    else if (WB_WB_EN & EXE_Rt == WB_Dest & WB_Dest != `REG_FILE_ADDR_LEN'b0 & ~EXE_is_imm)//MEM_hazard when ~EX_hazard
      ALU_src2_sel = `FORW_SEL_LEN'd2;
    else
      ALU_src2_sel = `FORW_SEL_LEN'd0;

  end

endmodule
