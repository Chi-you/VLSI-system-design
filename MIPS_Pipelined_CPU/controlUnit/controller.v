`include "defines.v"

module controller (opcode, Branch_En, EXE_CMD, Branch_CMD, is_imm, /*ST_or_BNE,*/ WB_EN, Mem_Read_EN, Mem_Write_EN, hazard_detected);
  input hazard_detected;
  input [`OP_CODE_LEN-1:0] opcode;
  output reg Branch_En;
  output reg [`EXE_CMD_LEN-1:0] EXE_CMD;
  output reg [1:0] Branch_CMD;
  output reg is_imm, WB_EN, Mem_Read_EN, Mem_Write_EN;
  // output ST_or_BNE;

  always @ (*) begin
    if (hazard_detected == 0) begin
      {Branch_En, EXE_CMD, Branch_CMD, is_imm, WB_EN, Mem_Read_EN, Mem_Write_EN} = 0;
      case (opcode)
        // operations writing to the register file
        `OP_ADD: begin EXE_CMD = `EXE_ADD; WB_EN = 1; end
        `OP_SUB: begin EXE_CMD = `EXE_ADD; WB_EN = 1; end
        `OP_AND: begin EXE_CMD = `EXE_AND; WB_EN = 1; end
        `OP_OR:  begin EXE_CMD = `EXE_OR;  WB_EN = 1; end
        `OP_XOR: begin EXE_CMD = `EXE_XOR; WB_EN = 1; end
        `OP_NOR: begin EXE_CMD = `EXE_NOR; WB_EN = 1; end
        `OP_SLL: begin EXE_CMD = `EXE_SLL; WB_EN = 1; end
        `OP_SRL: begin EXE_CMD = `EXE_SRL; WB_EN = 1; end
        `OP_SLT: begin EXE_CMD = `EXE_SLT;WB_EN = 1; end
        // operations using an immediate value embedded in the instruction
        `OP_ADDI: begin EXE_CMD = `EXE_ADD; WB_EN = 1; is_imm = 1; end
        `OP_SUBI: begin EXE_CMD = `EXE_ADD; WB_EN = 1; is_imm = 1; end
        // memory operations
        `OP_LD: begin EXE_CMD = `EXE_ADD; WB_EN = 1; is_imm = 1; ST_or_BNE = 1; Mem_Read_EN = 1; end
        `OP_ST: begin EXE_CMD = `EXE_ADD; is_imm = 1; Mem_Write_EN = 1; ST_or_BNE = 1; end
        // branch operations
        `OP_BEZ: begin EXE_CMD = `EXE_NO_OPERATION; is_imm = 1; Branch_CMD = `COND_BEZ; Branch_En = 1; end
        `OP_BNE: begin EXE_CMD = `EXE_NO_OPERATION; is_imm = 1; Branch_CMD = `COND_BNE; Branch_En = 1; ST_or_BNE = 1; end
        `OP_JMP: begin EXE_CMD = `EXE_NO_OPERATION; is_imm = 1; Branch_CMD = `COND_JUMP; Branch_En = 1; end
        default: {Branch_En, EXE_CMD, Branch_CMD, is_imm, ST_or_BNE, WB_EN, Mem_Read_EN, Mem_Write_EN} = 0;
      endcase
    end

    else if (hazard_detected ==  1) begin
      // preventing any writes to the register file or the memory
      {EXE_CMD, WB_EN, Mem_Write_EN} = 0;
    end
  end
endmodule // controller



// 4'b0000: result = bus_add;      //ADD:          00 0000 ... 10 0000
//                 4'b0001: result = bus_add;      //ADDU:         00 0000 ... 10 0001
//                 4'b0010: result = bus_add;      //SUB:          00 0000 ... 10 0010
//                 4'b0011: result = bus_add;      //SUBU:         00 0000 ... 10 0011
//                 4'b0100: result = bus_logic;    //AND:          00 0000 ... 10 0100
//                 4'b0101: result = bus_logic;    //OR:           00 0000 ... 10 0101
//                 4'b0110: result = bus_logic;    //XOR:          00 0000 ... 10 0110
//                 4'b0111: result = bus_logic;    //NOR:          00 0000 ... 10 0111
//                 4'b1000: result = bus_add;      //ADDI:         00 1000 ... xx xxxx
//                 4'b1001: result = bus_add;      //ADDIU:        00 1001 ... xx xxxx
//                 4'b1010: result = bus_slt_move; //SLT,SLTI:     00 0000 ... 10 1010
//                                                 //SLTI:         00 1010 ... xx xxxx
//                 4'b1011: result = bus_slt_move; //SLTU,SLTIU:   00 0000 ... 10 1011
//                                                 //SLTIU:        00 1011 ... xx xxxx
//                 4'b1100: result = bus_logic;    //ANDI:         00 1100 ... xx xxxx
//                 4'b1101: result = bus_logic;    //ORI:          00 1101 ... xx xxxx
//                 4'b1110: result = bus_logic;    //XORI:         00 1110 ... xx xxxx
//                 4'b1111: result = bus_lui;      //LUI:          00 1111 ... xx xxxx
