`include "defines.v"

module conditionChecker (Rs_Value, Rt_Value, branch_CMD, branch_Cond);
  input [`WORD_LEN-1: 0] Rs_Value, Rt_Value;
  input [1:0] branch_CMD;
  output reg branch_Cond;

  always @ (*) begin
    case (branch_CMD)
      `COND_JUMP: branch_Cond = 1'b1;
      `COND_BEQ: branch_Cond = (Rs_Value == Rt_Value) ? 1'b1 : 1'b0;
      `COND_BNE: branch_Cond = (Rs_Value != Rt_Value) ? 1'b1 : 1'b0;
      default: branch_Cond = 1'b0;
    endcase
  end
endmodule // conditionChecker
