`include "defines.v"

module controller ( hazard_detected, instruction, Branch_En, is_imm, ST_or_BNE, WB_EN, Mem_Read_EN, Mem_Write_EN, Shift_Direction, Result_sel, Branch_CMD, EXE_CMD );
  input hazard_detected;
  input [`WORD_LEN-1:0] instruction;
  //input [`OP_CODE_LEN-1:0] opcode;
  output Branch_En;
  output is_imm, WB_EN, Mem_Read_EN, Mem_Write_EN;
  output Shift_Direction, Result_sel;//shifter or ALU
  output [1:0] Branch_CMD;
  output [`EXE_CMD_LEN-1:0] EXE_CMD;  
  output ST_or_BNE;

//                 4'b0000: result = bus_add;      //ADD:          00 0000 ... 10 0000
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
//
//SLL:          00 0000 ... 00 0000
//SRL:          00 0000 ... 00 0010
//
//LW:           10 0011 ... xx xxxx
//SW:           10 1011 ... xx xxxx
//
//BEQ:          00 0100 ... xx xxxx
//BNE:          00 0101 ... xx xxxx
//
//J:            00 0010 ... xx xxxx


    wire            nop_ins;
                            
    wire            arith_reg_ins;
    
    wire            shift_ins;
    wire            SLL_ins;
    wire            SRL_ins;

    wire            arith_imm_ins;    

    wire            LW_ins;
    wire            SW_ins;

    wire            branch_ins;
    wire            BEQ_ins;
    wire            BNE_ins;

    wire            J_ins;

    //=============================================================
    // instruction decoding
    //=============================================================

        assign  nop_ins = (instruction[31:0]==32'b0) ? 1'b1 : 1'b0 ;


        //Arithmetic (Reg.)
        assign  arith_reg_ins = (instruction[31:26]==6'b0)&(instruction[10:4]==7'b0000010);
        /*assign  ADD_ins  = arith_reg_ins&(instruction[3:0]==4'b0000);
        assign  ADDU_ins = arith_reg_ins&(instruction[3:0]==4'b0001);
        assign  SUB_ins  = arith_reg_ins&(instruction[3:0]==4'b0010);
        assign  SUBU_ins = arith_reg_ins&(instruction[3:0]==4'b0011);
        assign  AND_ins  = arith_reg_ins&(instruction[3:0]==4'b0100);
        assign  OR_ins   = arith_reg_ins&(instruction[3:0]==4'b0101);
        assign  XOR_ins  = arith_reg_ins&(instruction[3:0]==4'b0110);
        assign  NOR_ins  = arith_reg_ins&(instruction[3:0]==4'b0111);
        assign  SLT_ins  = arith_reg_ins&(instruction[3:0]==4'b1010);
        assign  SLTU_ins = arith_reg_ins&(instruction[3:0]==4'b1011);
*/
        //Shift
        assign  shift_ins = SLL_ins  |
                            SRL_ins  ;

        assign  SLL_ins   = (instruction[31:26]==6'b000000)&
                            (instruction[25:21]==5'b00000)&
                            (instruction[5:3]==3'b000)&
                            (instruction[2:0]==3'b000);

        assign  SRL_ins   = (instruction[31:26]==6'b000000)&
                            (instruction[25:21]==5'b00000)&
                            (instruction[5:3]==3'b000)&
                            (instruction[2:0]==3'b010);

        //Arithmetic (Imm.)
        assign  arith_imm_ins = (instruction[31:29]==3'b001);
  /*      assign  ADDI_ins  = arith_imm_ins&(instruction[28:26]==3'b000);
        assign  ADDIU_ins = arith_imm_ins&(instruction[28:26]==3'b001);
        assign  SLTI_ins  = arith_imm_ins&(instruction[28:26]==3'b010);
        assign  SLTIU_ins = arith_imm_ins&(instruction[28:26]==3'b011);
        assign  ANDI_ins  = arith_imm_ins&(instruction[28:26]==3'b100);
        assign  ORI_ins   = arith_imm_ins&(instruction[28:26]==3'b101);
        assign  XORI_ins  = arith_imm_ins&(instruction[28:26]==3'b110);
*/
        //Load
        assign  LW_ins  = (instruction[31:26]==6'b100011);


        //Store
        assign  SW_ins    = (instruction[31:26]==6'b101011);


        //Branch
        assign  branch_ins = BEQ_ins |
                              BNE_ins ;
        assign  BEQ_ins    = (instruction[31:26]==6'b000100);
        assign  BNE_ins    = (instruction[31:26]==6'b000101);

        //Jump
        assign  J_ins      = (instruction[31:26]==6'b000010);

       
        
    //=============================================================
    // ID-Stage : Branch/Jump instruction
    //=============================================================
    assign  Branch_En = J_ins | branch_ins;

	  assign  Branch_CMD = J_ins ? 2'b10 :
                         BEQ_ins ? 2'b11 :
                         BNE_ins ? 2'b01 :
                         2'b00 ;

    //=============================================================
    // ID-Stage : instruction type information
    //=============================================================
    assign  is_imm = arith_imm_ins|LW_ins|SW_ins|branch_ins|J_ins; 

    //=============================================================
    // ID-Stage : ST_or_BNE
    //=============================================================
    assign  ST_or_BNE = SW_ins|branch_ins; 
    

    //=============================================================
    // EX-Stage : ALUop control signals
    //=============================================================
    assign  EXE_CMD[3] = (arith_reg_ins&instruction[3])|
                           (arith_imm_ins&instruction[29]);
    assign  EXE_CMD[2] = (arith_reg_ins&instruction[2])|
                           (arith_imm_ins&instruction[28]);
    assign  EXE_CMD[1] = (arith_reg_ins&instruction[1])|
                           (arith_imm_ins&instruction[27]);
    assign  EXE_CMD[0] = (arith_reg_ins&instruction[0])|
                           (arith_imm_ins&instruction[26]);


    //=============================================================
    // EX-Stage : Shifter control signals
    //=============================================================
    assign  Shift_Direction = instruction[1];

    //=============================================================
    // EX-Stage : Mux the execution output value
    //-------------------------------------------------------------
    //      0 : result_bus = alu_out
    //      1 : result_bus = shifter_out
    //=============================================================
    assign  Result_sel = shift_ins;
                               

    //=============================================================
    // MEM-Stage : Memory accessing
    //=============================================================
    assign  Mem_Write_EN = SW_ins & ~hazard_detected;
    assign  Mem_Read_EN = LW_ins & ~hazard_detected;


    //=============================================================
    // WB-Stage : Enable the regiser to store data
    //=============================================================
    assign      WB_EN = ((LW_ins)|
                        (shift_ins&(~nop_ins))|
                        (arith_reg_ins)|
                        (arith_imm_ins)) & ~hazard_detected;


endmodule  // controller


  /*always @ (*) begin
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
endmodule*/

