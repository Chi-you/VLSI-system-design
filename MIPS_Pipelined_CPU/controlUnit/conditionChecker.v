`include "defines.v"

module conditionChecker (Rs_Value, Rt_value, branch_CMD, branch_Cond);
  input [`WORD_LEN-1: 0] Rs_Value, Rt_value;
  input [1:0] branch_CMD;
  output reg branch_Cond;

  always @ (*) begin
    case (branch_CMD)
      `COND_JUMP: branch_Cond = 1;
      `COND_BEZ: branch_Cond = (Rs_Value == 0) ? 1 : 0;
      `COND_BNE: branch_Cond = (Rs_Value != Rt_value) ? 1 : 0;
      default: branch_Cond = 0;
    endcase
  end
endmodule // conditionChecker
