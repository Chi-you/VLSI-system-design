`include "defines.v"
`include "IFStage.v"
`include "IDStage.v"
`include "EXEStage.v"
//`include "MEMStage.v"
`include "WBStage.v"
`include "IF2ID.v"
`include "ID2EXE.v"
`include "EXE2MEM.v"
`include "MEM2WB.v"
`include "forwarding_EXE.v"
`include "hazard_detection.v"
`include "regFile.v"
`include "Mux32.v"

module MIPS_CPU (clk, rst, Mem_Read_EN, Mem_Write_EN, ALU_Result, Store_Value, Data_memory_out, /**/instruction, addr);
	input clk, rst;
	/*wire [`WORD_LEN-1:0] PC_IF,PC_ID, PC_EXE, PC_MEM;*/
	wire [`WORD_LEN-1:0] /*inst_IF,*/ inst_ID;
	wire [`WORD_LEN-1:0] reg1_ID, reg2_ID, ST_value_EXE, ST_value_EXE2MEM, ST_value_MEM;
	wire [`WORD_LEN-1:0] val1_ID, val1_EXE;
	wire [`WORD_LEN-1:0] val2_ID, val2_EXE;
	wire [`WORD_LEN-1:0] ALURes_EXE, ALURes_MEM, ALURes_WB;
	wire [`WORD_LEN-1:0] dataMem_out_MEM, dataMem_out_WB;
	wire [`WORD_LEN-1:0] WB_result;
	wire [`REG_FILE_ADDR_LEN-1:0] dest_EXE, dest_MEM, dest_WB; // dest_ID = instruction[25:21] thus nothing declared
	wire [`REG_FILE_ADDR_LEN-1:0] src1_ID, src2_regFile_ID, /*src2_forw_ID,*/ src2_forw_EXE, src1_forw_EXE;
	wire [`EXE_CMD_LEN-1:0] EXE_CMD_ID, EXE_CMD_EXE;
	wire [`FORW_SEL_LEN-1:0] val1_sel, val2_sel, ST_val_sel;
	wire [1:0] branch_comm;
	wire Br_Taken_ID, IF_Flush/*, Br_Taken_EXE*/;
	wire MEM_R_EN_ID, MEM_R_EN_EXE, MEM_R_EN_MEM, MEM_R_EN_WB;
	wire MEM_W_EN_ID, MEM_W_EN_EXE, MEM_W_EN_MEM;
	wire WB_EN_ID, WB_EN_EXE, WB_EN_MEM, WB_EN_WB;
	wire hazard_detected, is_imm_ID, ST_or_BNE;

	wire Shift_Direction_ID, Result_sel_ID, is_imm_EXE, Shift_Direction_EXE, Result_sel_EXE;
	wire [4:0] Dest_ID, Shamt_ID, Shamt_EXE;		
	wire [25:0] jump_offset;
//=========================================

	output Mem_Read_EN, Mem_Write_EN;
	output [`WORD_LEN-1:0] ALU_Result, Store_Value;
        input [`WORD_LEN-1:0]Data_memory_out;
//============================================

	input [`WORD_LEN-1:0] instruction;
	output [`WORD_LEN-1:0] addr;
//==========================================
	regFile regFile(
		// INPUTS
		.clk(clk),
		.rst(rst),
		.readreg1(src1_ID),
		.readreg2(src2_regFile_ID),
		.writereg(dest_WB),
		.writeData(WB_result),
		.writeEn(WB_EN_WB),
		// OUTPUTS
		.readdata1(reg1_ID),
		.readdata2(reg2_ID)
	);
// check
	hazard_detection hazard (
		// INPUTS
		//.forward_EN(forward_EN),
		.ID_is_imm(is_imm_ID),
		.ST_or_BNE(ST_or_BNE),
		.ID_Rs(src1_ID),
		.ID_Rt(src2_regFile_ID),
		.EXE_Dest(dest_EXE),
		.MEM_Dest(dest_MEM),
		.EXE_WB_EN(WB_EN_EXE),
		.MEM_WB_EN(WB_EN_MEM),
		.EXE_Mem_Read_EN(MEM_R_EN_EXE),
		.Branch_CMD(branch_comm),
		// OUTPUTS
		.hazard_detected(hazard_detected)
	);

	forwarding_EXE forwrding_EXE (
		// INPUTS
		.EXE_Rs(src1_forw_EXE),
		.EXE_Rt(src2_forw_EXE),
		.EXE_Store_Value(dest_EXE),
		.MEM_Dest(dest_MEM),
		.WB_Dest(dest_WB),
		.MEM_WB_EN(WB_EN_MEM),
		.WB_WB_EN(WB_EN_WB),
		.EXE_is_imm(is_imm_EXE), //
		// OUTPUTS
		.ALU_src1_sel(val1_sel),
		.ALU_src2_sel(val2_sel),
		.Store_Value_sel(ST_val_sel)
	);

//=============================
//      PIPLINE STAGES 
//============================

//=====================================================================
//      IF Stage
//=====================================================================
	IFStage IFStage (
		// INPUTS
		.clk(clk),
		.rst(rst),
		.freeze(hazard_detected),
		.branch_Taken(Br_Taken_ID),
		.branch_offset(val2_ID),
		.Jump_Offset(jump_offset),
		.ID_op(inst_ID[31:26]),
		// OUTPUTS
		//.instruction(inst_IF)
		.PC(addr)
	);

//=====================================================================
//      ID Stage
//=====================================================================


	IDStage IDStage (
		// INPUTS
		.clk(clk),
		.rst(rst),
		.hazard_detected_in(hazard_detected),
		.instruction(inst_ID),
		.Rs_Value(reg1_ID),
		.Rt_Value(reg2_ID),
		// OUTPUTS
		.Rs(src1_ID),
		.Rt(src2_regFile_ID),
		//.src2_forwarding(src2_forw_ID),
		.ALU_Input1(val1_ID),
		.ALU_Input2(val2_ID),
		.branch_Taken(Br_Taken_ID),
		.EXE_CMD(EXE_CMD_ID),
		.Mem_Read_EN(MEM_R_EN_ID),
		.Mem_Write_EN(MEM_W_EN_ID),
		.WB_EN(WB_EN_ID),
		.is_imm_out(is_imm_ID),
		.ST_or_BNE_out(ST_or_BNE),
		.branch_CMD(branch_comm),
		.Dest(Dest_ID),
		.Shamt(Shamt_ID),
		.Shift_Direction(Shift_Direction_ID),
		.Result_sel(Result_sel_ID),
		.Jump_Offset(jump_offset)
	);

//=====================================================================
//      EXE Stage
//=====================================================================

	
	EXEStage EXEStage (
		// INPUTS
		//.clk(clk),
		.EXE_CMD(EXE_CMD_EXE),
		.ALU_src1_sel(val1_sel),
		.ALU_src2_sel(val2_sel),
		.Store_Value_sel(ST_val_sel),
		.ALU_Input1(val1_EXE),
		.ALU_Input2(val2_EXE),
		.ALU_Result_MEM(ALURes_MEM),
		.Result_WB(WB_result),
		.Store_Value_in(ST_value_EXE),
		.Shamt(Shamt_EXE),
		.Shift_Direction(Shift_Direction_EXE),
		.Result_sel(Result_sel_EXE),
		// OUTPUTS
		.ALU_Result(ALURes_EXE),
		.Store_Value(ST_value_EXE2MEM)
	);

//=====================================================================
//      MEM Stage
//=====================================================================
/*	MEMStage MEMStage (
		// INPUTS
		.clk(clk),
		.rst(rst),
		.Mem_Read_EN(MEM_R_EN_MEM),
		.Mem_Write_EN(MEM_W_EN_MEM),
		.ALU_Result(ALURes_MEM),
		.Store_Value(ST_value_MEM),
		// OUTPUTS
		.Data_memory_out(dataMem_out_MEM)
	);
*/
	assign Mem_Read_EN = MEM_R_EN_MEM;
	assign Mem_Write_EN = MEM_W_EN_MEM;
	assign ALU_Result = ALURes_MEM;
	assign Store_Value = ST_value_MEM;
	assign dataMem_out_MEM = Data_memory_out;
//=====================================================================
//      WB Stage
//=====================================================================
	WBStage WBStage (
		// INPUTS
		.Mem_Read_EN(MEM_R_EN_WB),
		.Data_memory(dataMem_out_WB),
		.ALU_Result(ALURes_WB),
		// OUTPUTS
		.Result_WB(WB_result)
	);



//=====================================================================
//        PIPLINE REGISTERS 
//=====================================================================

//=====================================================================
//      IF2ID 
//=====================================================================
	IF2ID IF2IDReg (
		// INPUTS
		.clk(clk),
		.rst(rst),
		.Flush(IF_Flush),
		.freeze(hazard_detected),
		//.PC_in(PC_IF),
		.instruction_in(instruction),
		// OUTPUTS
		//.PC(PC_ID),
		.instruction(inst_ID)
	);

	ID2EXE ID2EXEReg (
		.clk(clk),
		.rst(rst),
		// INPUTS
		.Dest_in(Dest_ID),
		.Rs_in(src1_ID),
		.Rt_in(src2_regFile_ID),
		.Rt_Value_in(reg2_ID),
		.ALU_Input1_in(val1_ID),
		.ALU_Input2_in(val2_ID),
		//.PCIn(PC_ID),
		.EXE_CMD_in(EXE_CMD_ID),
		.Mem_Read_EN_in(MEM_R_EN_ID),
		.Mem_Write_EN_in(MEM_W_EN_ID),
		.WB_EN_in(WB_EN_ID),
		//.Branch_Taken_in(Br_Taken_ID),
		.is_imm_in(is_imm_ID),
		.Shamt_in(Shamt_ID),
		.Shift_Direction_in(Shift_Direction_ID),
		.Result_sel_in(Result_sel_ID),
		// OUTPUTS
		.Rs(src1_forw_EXE),
		.Rt(src2_forw_EXE),
		.Dest(dest_EXE),
		.Store_Value(ST_value_EXE),
		.ALU_Input1(val1_EXE),
		.ALU_Input2(val2_EXE),
		//.PC(PC_EXE),
		.EXE_CMD(EXE_CMD_EXE),
		.Mem_Read_EN(MEM_R_EN_EXE),
		.Mem_Write_EN(MEM_W_EN_EXE),
		.WB_EN(WB_EN_EXE),
		//.Branch_Taken(Br_Taken_EXE),
		.is_imm(is_imm_EXE),
		.Shamt(Shamt_EXE),
		.Shift_Direction(Shift_Direction_EXE),
		.Result_sel(Result_sel_EXE)
	);

	EXE2MEM EXE2MEMReg (
		.clk(clk),
		.rst(rst),
		// INPUTS
		.WB_EN_in(WB_EN_EXE),
		.Mem_Read_EN_in(MEM_R_EN_EXE),
		.Mem_Write_EN_in(MEM_W_EN_EXE),
		//.PCIn(PC_EXE),
		.ALU_Result_in(ALURes_EXE),
		.Store_Value_in(ST_value_EXE2MEM),
		.Dest_in(dest_EXE),
		// OUTPUTS
		.WB_EN(WB_EN_MEM),
		.Mem_Read_EN(MEM_R_EN_MEM),
		.Mem_Write_EN(MEM_W_EN_MEM),
		//.PC(PC_MEM),
		.ALU_Result(ALURes_MEM),
		.Store_Value(ST_value_MEM),
		.Dest(dest_MEM)
	);

	MEM2WB MEM2WB(
		.clk(clk),
		.rst(rst),
		// INPUTS
		.WB_EN_in(WB_EN_MEM),
		.Mem_Read_EN_in(MEM_R_EN_MEM),
		.ALU_Result_in(ALURes_MEM),
		.Data_memory_in(dataMem_out_MEM),
		.Dest_in(dest_MEM),
		// OUTPUTS
		.WB_EN(WB_EN_WB),
		.Mem_Read_EN(MEM_R_EN_WB),
		.ALU_Result(ALURes_WB),
		.Data_memory(dataMem_out_WB),
		.Dest(dest_WB)
	);

	assign IF_Flush = Br_Taken_ID;
endmodule
