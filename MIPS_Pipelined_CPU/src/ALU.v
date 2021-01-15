//  2021/1/13 15:08
`include "defines.v"
`include "csa32_nov_nco.v"
`include "csa16_nov.v"
`include "csa16_nov_nco.v"
`include "csa8_nov.v"
`include "csa8_nov_nco.v"
`include "cla4_nov.v"
`include "cla4_nov_nco.v"
module ALU (Input1, Input2, EXE_CMD, aluOut);
  input [`WORD_LEN-1:0] Input1, Input2;
  input [`EXE_CMD_LEN-1:0] EXE_CMD;
  output reg [`WORD_LEN-1:0] aluOut;

  //wire    [`WORD_LEN-1:0]  a ;		//Input1
  //wire    [`WORD_LEN-1:0]p  b ;		//Input2
  //wire    [`EXE_CMD_LEN-1:0]  op;	//EXE_CMD

  wire            adder_sub;
  wire    [`WORD_LEN-1:0]  bus_b;
  wire    [`WORD_LEN-1:0]  bus_add;

  wire    [`WORD_LEN-1:0]  bus_and, bus_or, bus_xor, bus_nor;
  wire    [`WORD_LEN-1:0]  bus_logic;

  wire    [`WORD_LEN-1:0]  bus_slt;


  //=============================================================
  //      Output  Mux
  //=============================================================
  always@(bus_logic or bus_add or bus_slt or
          EXE_CMD)
  begin
      case(EXE_CMD)
          4'b0000: aluOut = bus_add;      //ADD:          00 0000 ... 10 0000
          4'b0001: aluOut = bus_add;      //ADDU:         00 0000 ... 10 0001
          4'b0010: aluOut = bus_add;      //SUB:          00 0000 ... 10 0010
          4'b0011: aluOut = bus_add;      //SUBU:         00 0000 ... 10 0011
          4'b0100: aluOut = bus_logic;    //AND:          00 0000 ... 10 0100
          4'b0101: aluOut = bus_logic;    //OR:           00 0000 ... 10 0101
          4'b0110: aluOut = bus_logic;    //XOR:          00 0000 ... 10 0110
          4'b0111: aluOut = bus_logic;    //NOR:          00 0000 ... 10 0111
          4'b1000: aluOut = bus_add;      //ADDI:         00 1000 ... xx xxxx
          4'b1001: aluOut = bus_add;      //ADDIU:        00 1001 ... xx xxxx
          4'b1010: aluOut = bus_slt;      //SLT:          00 0000 ... 10 1010
                                          //SLTI:         00 1010 ... xx xxxx
          4'b1011: aluOut = bus_slt;      //SLTU:         00 0000 ... 10 1011
                                          //SLTIU:        00 1011 ... xx xxxx
          4'b1100: aluOut = bus_logic;    //ANDI:         00 1100 ... xx xxxx
          4'b1101: aluOut = bus_logic;    //ORI:          00 1101 ... xx xxxx
          4'b1110: aluOut = bus_logic;    //XORI:         00 1110 ... xx xxxx
          default: aluOut = 32'hxxxx_xxxx;
      endcase
  end        

  //=============================================================
  //                    ALUOp     ALU Function
  //-------------------------------------------------------------
  //      ADD:          0000      ADD
  //      ADDU:         0001      ADD
  //      SUB:          0010      SUB
  //      SUBU:         0011      SUB
  //      AND:          0100      AND
  //      OR:           0101      OR
  //      XOR:          0110      XOR
  //      NOR:          0111      NOR
  //      ADDI:         1000      ADD
  //      ADDIU:        1001      ADD
  //      SLT,SLTI:     1010      SUB
  //      SLTU,SLTIU:   1011      SUB
  //      ANDI:         1100      AND
  //      ORI:          1101      OR
  //      XORI:         1110      XOR
  //=============================================================


  //=============================================================
  //      Adder
  //=============================================================

  // inv
  assign  adder_sub = (EXE_CMD[2:1]==2'b01) ? 1'b1 : 1'b0 ;
  assign  bus_b=(adder_sub)?~Input2:Input2;

  // adder-32bit
  csa32_nov_nco   u_adder32(
                    .din1          (Input1),
                    .din2          (bus_b),
                    .carry_in      (adder_sub),
                    .dout          (bus_add)
                  );

  //=============================================================
  //      Logic
  //=============================================================

  // and
  assign  bus_and=Input1&Input2;

  // or
  assign  bus_or=Input1|Input2;

  // xor
  assign  bus_xor=Input1^Input2;

  // nor
  assign  bus_nor = ~(Input1|Input2);

  assign  bus_logic = (EXE_CMD[1:0]==2'b00)?bus_and:
                      (EXE_CMD[1:0]==2'b01)?bus_or:
                      (EXE_CMD[1:0]==2'b10)?bus_xor:
                      (EXE_CMD[1:0]==2'b11)?bus_nor:
                      32'b0;

  //=============================================================
  //      SLT
  //-------------------------------------------------------------
  // if (op[0]=1) ==> Unsigned
  // A[`WORD_LEN-1] B[`WORD_LEN-1]
  //   0     0    --> = 2'complement
  //   0     1    --> A < B
  //   1     0    --> A > B
  //   1     1    --> = 2'complement
  //=============================================================

  //assign  bus_slt[`WORD_LEN-1:1]=(`WORD_LEN-1)'b0;
  assign  bus_slt[`WORD_LEN-1:1]=31'b0;
  assign  bus_slt[0] = (EXE_CMD[0]&({Input1[`WORD_LEN-1],Input2[`WORD_LEN-1]}==2'b01))?1'b1:
                        (EXE_CMD[0]&({Input1[`WORD_LEN-1],Input2[`WORD_LEN-1]}==2'b10))?1'b0:
                        bus_add[`WORD_LEN-1];

endmodule
