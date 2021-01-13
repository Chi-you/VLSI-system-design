`include "defines.v"
`include "./adder/csa32.v"
// todo:
// wire,
module ALU (val1, val2, EXE_CMD, aluOut);
  input [`WORD_LEN-1:0] val1, val2;
  input [`EXE_CMD_LEN-1:0] EXE_CMD;
  output [`WORD_LEN-1:0] aluOut; // 32 bits
  reg [`WORD_LEN-1:0] aluOut;

  always @ ( * ) begin
    case (EXE_CMD)
      `EXE_ADD: aluOut = bus_add; // include add and sub
      `EXE_AND: aluOut = bus_and;
      `EXE_OR:  aluOut = bus_or;
      `EXE_XOR: aluOut = bus_xor;
      `EXE_NOR: aluOut = bus_nor;
      `EXE_SLL: aluOut = bus_sll;
      `EXE_SRL: aluOut = bus_srl;
      `EXE_SLT: aluOut = bus_slt_move;
      default: aluOut = 0;
      
    endcase
  end
    //====================================================
    //      Adder
    //====================================================
    // adder-32bit
    fu_csa32    u_adder32(
                .din1        (a),
                .din2        (bus_b),
                .carry_in    (adder_sub),
                .dout        (bus_add),
                .carry_out   (),
                .overflow    ()
                );
    //=============================================================
    //      Logic
    //=============================================================

    // and
    assign  bus_and=a&b;

    // or
    assign  bus_or=a|b;

    // xor
    assign  bus_xor=a^b;

    // nor
    assign  bus_nor = ~(a|b);

    // srl 
    assign  bus_srl = a >>> b;

    // sll
    assign bus_sll = a <<< b;

    assign  bus_logic = (op[1:0]==2'b00)?bus_and:
                        (op[1:0]==2'b01)?bus_or:
                        (op[1:0]==2'b10)?bus_xor:
                        (op[1:0]==2'b11)?bus_nor:
                        32'b0;

    //=============================================================
    //      SLT
    //-------------------------------------------------------------
    // if (op[0]=1) ==> Unsigned
    // A[31] B[31]
    //   0     0    --> = 2'complement
    //   0     1    --> A < B
    //   1     0    --> A > B
    //   1     1    --> = 2'complement
    //=============================================================

    assign  bus_slt[31:1]=31'b0;
    assign  bus_slt[0] = (op[0]&({a[31],b[31]}==2'b01))?1'b1:
                            (op[0]&({a[31],b[31]}==2'b10))?1'b0:
                            bus_add[31];

    assign  bus_slt_move = (move_cond[1]) ? a : bus_slt ;

    //=============================================================
    //      LUI
    //=============================================================
    // assign  bus_lui[31:16] = b[15:0] ;
    // assign  bus_lui[15:0] = 16'b0;
        
endmodule // ALU
