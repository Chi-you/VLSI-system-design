`include "defines.v"

module instructionMem (rst, addr, instruction);
  input rst;
  input [`WORD_LEN-1:0] addr;
  output [`WORD_LEN-1:0] instruction;

  wire [$clog2(`INSTR_MEM_SIZE)-1:0] address = addr[$clog2(`INSTR_MEM_SIZE)-1:0];
  reg [`MEM_CELL_SIZE-1:0] instMem [0:`INSTR_MEM_SIZE-1];

  always @ (*) begin
  	if (rst) begin
        // No nop added in between instructions since there is a hazard detection unit

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/*//hazard--------------------------------------------------------------hazard_without_PCproblem
instMem[0] = 8'b0010_0000;
instMem[1] = 8'b0010_0001;
instMem[2] = 8'b0000_0000;
instMem[3] = 8'b0000_0001;//addi $1, $1, 1 // $1 = 1

instMem[4] = 8'b1010_1100;
instMem[5] = 8'b0000_0001;
instMem[6] = 8'b0000_0000;
instMem[7] = 8'b0000_0000;//sw $1, 0($0) // mem[0-3] = 1


instMem[8] = 8'b0010_0000;
instMem[9] = 8'b0100_0010;
instMem[10] = 8'b0000_0000;
instMem[11] = 8'b0000_0010;//addi $2, $2, 2 // $2 = 2

instMem[12] = 8'b1010_1100;
instMem[13] = 8'b0000_0010;
instMem[14] = 8'b0000_0000;
instMem[15] = 8'b0000_0100;//sw $2, 4($0) // mem[4-7] = 2

instMem[16] = 8'b0010_0000;
instMem[17] = 8'b0110_0011;
instMem[18] = 8'b0000_0000;
instMem[19] = 8'b0000_0011;//addi $3, $3, 3 // $3 = 3

instMem[20] = 8'b1010_1100;
instMem[21] = 8'b0000_0011;
instMem[22] = 8'b0000_0000;
instMem[23] = 8'b0000_1000;//sw $3, 8($0) // mem[8-11] = 3

instMem[24] = 8'b0010_0000;
instMem[25] = 8'b1000_0100;
instMem[26] = 8'b0000_0000;
instMem[27] = 8'b0000_0100;//addi $4, $4, 4 // $4 = 4

instMem[28] = 8'b1010_1100;
instMem[29] = 8'b0000_0100;
instMem[30] = 8'b0000_0000;
instMem[31] = 8'b0000_1100;//sw $4, 12($0) // mem[12-15] = 4

instMem[32] = 8'b0010_0000;
instMem[33] = 8'b1010_0101;
instMem[34] = 8'b0000_0000;
instMem[35] = 8'b0000_0101;//addi $5, $5, 5 // $5 = 5

instMem[36] = 8'b1010_1100;
instMem[37] = 8'b0000_0101;
instMem[38] = 8'b0000_0000;
instMem[39] = 8'b0001_0000;//sw $5, 16($0) // mem[16-19] = 5

instMem[40] = 8'b1000_1100;
instMem[41] = 8'b0000_0110;
instMem[42] = 8'b0000_0000;
instMem[43] = 8'b0000_0000;//lw $6, 0($0) // $6 = 1

instMem[44] = 8'b0000_0000;
instMem[45] = 8'b1010_0110;
instMem[46] = 8'b0101_0000;
instMem[47] = 8'b0010_0000;//add $10, $5, $6 //$10 = 5+1 = 6

instMem[48] = 8'b1000_1100;
instMem[49] = 8'b0000_0111;
instMem[50] = 8'b0000_0000;
instMem[51] = 8'b0000_0100;//lw $7, 4($0) // $7 = 2

instMem[52] = 8'b0010_0000;
instMem[53] = 8'b1110_1011;
instMem[54] = 8'b0000_0000;
instMem[55] = 8'b0000_0101;//addi $11, $7, 5//$11 = 2+5 = 7

instMem[56] = 8'b1000_1100;
instMem[57] = 8'b0000_1000;
instMem[58] = 8'b0000_0000;
instMem[59] = 8'b0000_1000;//lw $8, 8($0) // $8 = 3

instMem[60] = 8'b1000_1101;
instMem[61] = 8'b0000_1100;
instMem[62] = 8'b0000_0000;
instMem[63] = 8'b0000_0000;//lw $12, 0($8)//$12 = 1 //mem[0-3] = 1

instMem[64] = 8'b1000_1100;
instMem[65] = 8'b0000_1001;
instMem[66] = 8'b0000_0000;
instMem[67] = 8'b0000_1100;//lw $9, 12($0) // $9 = 4

instMem[68] = 8'b1010_1100;
instMem[69] = 8'b0000_1001;
instMem[70] = 8'b0000_0000;
instMem[71] = 8'b0001_0100;//sw $9, 20($0) // mem[20-23] = 4

instMem[72] = 8'b0000_0000;
instMem[73] = 8'b1010_0110;
instMem[74] = 8'b0110_1000;
instMem[75] = 8'b0010_0000;//add $13, $5, $6 //$13 = 5+1 = 6

instMem[76] = 8'b0001_0101;
instMem[77] = 8'b1010_0000;
instMem[78] = 8'b0000_0000;
instMem[79] = 8'b0000_0100;//bne $13, $0, j1  //j1: j b1

instMem[80] = 8'b0010_0000;
instMem[81] = 8'b1110_1110;
instMem[82] = 8'b0000_0000;
instMem[83] = 8'b0000_0101;//b1: addi $14, $7, 5 //$14 = 2+5 = 7

instMem[84] = 8'b0001_0001;         
instMem[85] = 8'b1100_1110;
instMem[86] = 8'b0000_0000;
instMem[87] = 8'b0000_0011;//beq $14, $14, j2 //j2: j b2

instMem[88] = 8'b1000_1101;
instMem[89] = 8'b0000_1111;
instMem[90] = 8'b0000_0000;
instMem[91] = 8'b0000_0000;//b2: lw $15, 0($8) // $15 = 1 //mem[0-3] = 1

instMem[92] = 8'b0001_0001;
instMem[93] = 8'b1110_1111;
instMem[94] = 8'b0000_0000;
instMem[95] = 8'b0000_0010;//beq $15, $15, Exit //Exit: nop

instMem[96] = 8'b0000_1000;
instMem[97] = 8'b0000_0000;
instMem[98] = 8'b0000_0000;
instMem[99] = 8'b000101_00;//j1: j b1

instMem[100] = 8'b0000_1000;
instMem[101] = 8'b0000_0000;
instMem[102] = 8'b0000_0000;
instMem[103] = 8'b000101_10;//j2: j b2

instMem[104] = 8'b0000_0000;
instMem[105] = 8'b0000_0000;
instMem[106] = 8'b0000_0000;
instMem[107] = 8'b0000_0000;//Exit: nop
*///hazard--------------------------------------------------------------hazard_without_PCproblem


//forwarding--------------------------------------------------------------forwarding
/*///single forwarding
instMem[0] <= 8'b001000_00;
instMem[1] <= 8'b001_00001;
instMem[2] <= 8'b00000_000;
instMem[3] <= 8'b00_000001;//addi $1, $1, 1 // $1 = 1

instMem[4] <= 8'b001000_00;
instMem[5] <= 8'b010_00010;
instMem[6] <= 8'b00000_000;
instMem[7] <= 8'b00_000010;//addi $2, $2, 2 // $2 = 2

instMem[8] <= 8'b000000_00;
instMem[9] <= 8'b010_00001;
instMem[10] <= 8'b00011_000;
instMem[11] <= 8'b00_100000;//add $3, $2, $1 // $3 = 3

instMem[12] <= 8'b000000_00;
instMem[13] <= 8'b010_00011;
instMem[14] <= 8'b00100_000;
instMem[15] <= 8'b00_100000;//add $4, $2, $3 // $4 = 5

instMem[16] <= 8'b101011_00;
instMem[17] <= 8'b101_00100;
instMem[18] <= 8'b00000_000;
instMem[19] <= 8'b11_001000;//sw $4, 200($5) // mem[200-203] = 5

instMem[20] <= 8'b101011_00;
instMem[21] <= 8'b110_00100;
instMem[22] <= 8'b00000_000;
instMem[23] <= 8'b11_001100;//sw $4, 204($6) // mem[204-207] = 5

instMem[24] <= 8'b0000_0000;
instMem[25] <= 8'b0000_0000;
instMem[26] <= 8'b0000_0000;
instMem[27] <= 8'b0000_0000;//nop

instMem[28] <= 8'b0000_0000;
instMem[29] <= 8'b0000_0000;
instMem[30] <= 8'b0000_0000;
instMem[31] <= 8'b0000_0000;//nop
*///single forwarding

/*//double forwarding
instMem[0] <= 8'b001000_00;
instMem[1] <= 8'b001_00001;
instMem[2] <= 8'b00000_000;
instMem[3] <= 8'b00_000001;//addi $1, $1, 1 // $1 = 1

instMem[4] <= 8'b000000_00;
instMem[5] <= 8'b001_00001;
instMem[6] <= 8'b00001_000;
instMem[7] <= 8'b00_100000;//add $1, $1, $1 // $1 = 2

instMem[8] <= 8'b000000_00;
instMem[9] <= 8'b001_00001;
instMem[10] <= 8'b00010_000;
instMem[11] <= 8'b00_100000;//add $2, $1, $1 // $2 = 4
*///double forwarding
//forwarding--------------------------------------------------------------forwarding

/*//all_instructions--------------------------------------------------all_instructions_without_Branch&Jump
instMem[0] <= 8'b0010_0011;
instMem[1] <= 8'b0011_1001;
instMem[2] <= 8'b0000_0000;
instMem[3] <= 8'b0001_1001;//ADDI $25 $25 25

instMem[4] <= 8'b0010_0000;
instMem[5] <= 8'b0010_0001;
instMem[6] <= 8'b0000_0000;
instMem[7] <= 8'b0000_0001;//ADDI $1 $1 1

instMem[8] <= 8'b0010_0000;
instMem[9] <= 8'b0100_0010;
instMem[10] <= 8'b0000_0000;
instMem[11] <= 8'b0000_0010;//ADDI $2 $2 2

instMem[12] <= 8'b0010_0000;
instMem[13] <= 8'b0110_0011;
instMem[14] <= 8'b0000_0000;
instMem[15] <= 8'b0000_0011;//ADDI $3 $3 3

instMem[16] <= 8'b0010_0000;
instMem[17] <= 8'b1000_0100;
instMem[18] <= 8'b0000_0000;
instMem[19] <= 8'b0000_0100;//ADDI $4 $4 4

instMem[20] <= 8'b0010_0000;
instMem[21] <= 8'b1010_0101;
instMem[22] <= 8'b0000_0000;
instMem[23] <= 8'b0000_0101;//ADDI $5 $5 5

instMem[24] <= 8'b1010_1100;
instMem[25] <= 8'b1001_1001;
instMem[26] <= 8'b0000_0000;
instMem[27] <= 8'b1100_1000;//SW    $25 200($4)

instMem[28] <= 8'b0000_0000;
instMem[29] <= 8'b0100_0001;
instMem[30] <= 8'b0011_0000;
instMem[31] <= 8'b0010_0001;//ADDU $6 $2 $1 // $6  = 3

instMem[32] <= 8'b0000_0000;
instMem[33] <= 8'b0110_0100;
instMem[34] <= 8'b0011_1000;
instMem[35] <= 8'b0010_0010;//SUB  $7 $3 $4 // $7  = -1

instMem[36] <= 8'b0000_0000;
instMem[37] <= 8'b0100_0011;
instMem[38] <= 8'b0100_1000;
instMem[39] <= 8'b0010_0100;//AND  $9 $2 $3 // $9  = 2'b10

instMem[40] <= 8'b0000_0000;
instMem[41] <= 8'b0100_0011;
instMem[42] <= 8'b0101_0000;
instMem[43] <= 8'b0010_0101;//OR  $10 $2 $3 // $10 = 2'b11

instMem[44] <= 8'b0000_0000;
instMem[45] <= 8'b0100_0011;
instMem[46] <= 8'b0101_1000;
instMem[47] <= 8'b0010_0110;//XOR $11 $2 $3 // $11 = 2'b01

instMem[48] <= 8'b0000_0000;
instMem[49] <= 8'b0100_0011;
instMem[50] <= 8'b0110_0000;
instMem[51] <= 8'b0010_0111;//NOR $12 $2 $3 // $12 = 32'b1111....1100

instMem[52] <= 8'b0000_0000;
instMem[53] <= 8'b0100_0011;
instMem[54] <= 8'b0110_1000;
instMem[55] <= 8'b0010_0000;//ADD $13 $2 $3 // $13 = 5

instMem[56] <= 8'b0010_0100;
instMem[57] <= 8'b1110_1110;
instMem[58] <= 8'b0000_0000;
instMem[59] <= 8'b0000_0001;//ADDIU $14 $7 $1 // $14 = 32'd0

instMem[60] <= 8'b0000_0000;
instMem[61] <= 8'b1110_0101;
instMem[62] <= 8'b0100_0000;
instMem[63] <= 8'b0010_0011;//SUBU $8 $7 $5 // $8 = 32'b1111....11 - 5 

instMem[64] <= 8'b0000_0000;
instMem[65] <= 8'b0110_0010;
instMem[66] <= 8'b0111_1000;
instMem[67] <= 8'b0010_1010;//SLT   $15 $3 $2 // $15 = 0

instMem[68] <= 8'b0010_1000;
instMem[69] <= 8'b0101_0000;
instMem[70] <= 8'b0000_0000;
instMem[71] <= 8'b0000_0011;//SLTI  $16 $2 3 // $16 = 1

instMem[72] <= 8'b0000_0000;
instMem[73] <= 8'b0110_0010;
instMem[74] <= 8'b1000_1000;
instMem[75] <= 8'b0010_1011;//SLTU  $17 $3 $2 // $17 = 0

instMem[76] <= 8'b0010_1100;
instMem[77] <= 8'b0101_0010;
instMem[78] <= 8'b0000_0000;
instMem[79] <= 8'b0000_0011;//SLTIU $18 $2 3 // $18 = 1

instMem[80] <= 8'b0011_0000;
instMem[81] <= 8'b0101_0011;
instMem[82] <= 8'b0000_0000;
instMem[83] <= 8'b0000_0011;//ANDI  $19 $2 3 // $19  = 2'b10

instMem[84] <= 8'b0011_0100;
instMem[85] <= 8'b0101_0100;
instMem[86] <= 8'b0000_0000;
instMem[87] <= 8'b0000_0011;//ORI   $20 $2 3 // $20 = 2'b11

instMem[88] <= 8'b0011_1000;
instMem[89] <= 8'b0101_0101;
instMem[90] <= 8'b0000_0000;
instMem[91] <= 8'b0000_0011;//XORI  $21 $2 3 // $21 = 2'b01

instMem[92] <= 8'b0000_0000;
instMem[93] <= 8'b0000_0010;
instMem[94] <= 8'b1011_0000;
instMem[95] <= 8'b1100_0000;//SLL   $22 $2 3 // $22 = 10000

instMem[96] <= 8'b0000_0000;
instMem[97] <= 8'b0000_0101;
instMem[98] <= 8'b1011_1000;
instMem[99] <= 8'b1000_0010;//SRL   $23 $5 2 // $23 = 1

instMem[100] <= 8'b1000_1100;
instMem[101] <= 8'b1001_1000;
instMem[102] <= 8'b0000_0000;
instMem[103] <= 8'b1100_1000;//LW    $24 200($4) //$24 = 25

instMem[104] <= 8'b0000_0000;
instMem[105] <= 8'b0000_0000;
instMem[106] <= 8'b0000_0000;
instMem[107] <= 8'b0000_0000;//nop

instMem[108] <= 8'b0000_0000;
instMem[109] <= 8'b0000_0000;
instMem[110] <= 8'b0000_0000;
instMem[111] <= 8'b0000_0000;//nop

instMem[112] <= 8'b0000_0000;
instMem[113] <= 8'b0000_0000;
instMem[114] <= 8'b0000_0000;
instMem[115] <= 8'b0000_0000;//nop

instMem[116] <= 8'b0000_0000;
instMem[117] <= 8'b0000_0000;
instMem[118] <= 8'b0000_0000;
instMem[119] <= 8'b0000_0000;//nop

instMem[120] <= 8'b0000_0000;
instMem[121] <= 8'b0000_0000;
instMem[122] <= 8'b0000_0000;
instMem[123] <= 8'b0000_0000;//nop
*///all_instructions--------------------------------------------------all_instructions_without_Branch&Jump

//////////////////////////////////
/*
// test2_bubblesort
instMem[0] = 8'b0010_0000; // addi
instMem[1] = 8'b0000_1000; 
instMem[2] = 8'b0000_0000;
instMem[3] = 8'b1100_1000;

instMem[4] = 8'b0010_0000; // addi
instMem[5] = 8'b0000_1001;
instMem[6] = 8'b0000_0000;
instMem[7] = 8'b0000_0101;

instMem[8] = 8'b0010_0000; // *addi(92) 2.
instMem[9] = 8'b0000_0010;
instMem[10] = 8'b0000_0000;
instMem[11] = 8'b0101_1100;

instMem[12] = 8'b1010_1101; // sw v0 0(t0)
instMem[13] = 8'b0000_0010;
instMem[14] = 8'b0000_0000;
instMem[15] = 8'b0000_0000;

instMem[16] = 8'b0010_0000; // *addi(55) 3.
instMem[17] = 8'b0000_0010;
instMem[18] = 8'b0000_0000;
instMem[19] = 8'b0011_0111;

instMem[20] = 8'b1010_1101; // sw
instMem[21] = 8'b0000_0010;
instMem[22] = 8'b0000_0000;
instMem[23] = 8'b0000_0100;


instMem[24] = 8'b0010_0000; // *addi(46) 5.
instMem[25] = 8'b0000_0010;
instMem[26] = 8'b0000_0000;
instMem[27] = 8'b0010_1110;

instMem[28] = 8'b1010_1101; // sw
instMem[29] = 8'b0000_0010;
instMem[30] = 8'b0000_0000;
instMem[31] = 8'b0000_1000;

instMem[32] = 8'b0010_0000; // *addi(10) 1.
instMem[33] = 8'b0000_0010;
instMem[34] = 8'b0000_0000;
instMem[35] = 8'b0000_1010;

instMem[36] = 8'b1010_1101; // sw
instMem[37] = 8'b0000_0010;
instMem[38] = 8'b0000_0000;
instMem[39] = 8'b0000_1100;

instMem[40] = 8'b0010_0000; // *addi(1) 4.
instMem[41] = 8'b0000_0010;
instMem[42] = 8'b0000_0000;
instMem[43] = 8'b0000_0001;

instMem[44] = 8'b1010_1101; // sw
instMem[45] = 8'b0000_0010;
instMem[46] = 8'b0000_0000;
instMem[47] = 8'b0001_0000;
instMem[48] = 8'b0010_0000;
instMem[49] = 8'b0000_0111;
instMem[50] = 8'b0000_0000;
instMem[51] = 8'b0000_0000;
instMem[52] = 8'b0010_0101;
instMem[53] = 8'b0010_1010;
instMem[54] = 8'b1111_1111;
instMem[55] = 8'b1111_1111;
instMem[56] = 8'b0000_0001;
instMem[57] = 8'b0010_0111;
instMem[58] = 8'b0001_0000;
instMem[59] = 8'b0010_0011;
instMem[60] = 8'b0010_0100;
instMem[61] = 8'b0100_0010;
instMem[62] = 8'b1111_1111;
instMem[63] = 8'b1111_1111;
instMem[64] = 8'b0001_0000;
instMem[65] = 8'b0100_0000;
instMem[66] = 8'b0000_0000;
instMem[67] = 8'b0001_1000;
instMem[68] = 8'b0000_0000;
instMem[69] = 8'b0000_0000;
instMem[70] = 8'b0000_0000;
instMem[71] = 8'b0000_0000;
instMem[72] = 8'b0000_0000;
instMem[73] = 8'b0100_0000;
instMem[74] = 8'b0101_1000;
instMem[75] = 8'b0010_1010;
instMem[76] = 8'b0001_0101;
instMem[77] = 8'b0110_0000;
instMem[78] = 8'b0000_0000;
instMem[79] = 8'b0001_0101;
instMem[80] = 8'b0000_0000;
instMem[81] = 8'b0000_0000;
instMem[82] = 8'b0000_0000;
instMem[83] = 8'b0000_0000;
instMem[84] = 8'b0010_0000;
instMem[85] = 8'b0000_0101;
instMem[86] = 8'b0000_0000;
instMem[87] = 8'b0000_0000;
instMem[88] = 8'b0000_0001;
instMem[89] = 8'b0010_0111;
instMem[90] = 8'b0001_0000;
instMem[91] = 8'b0010_0011;
instMem[92] = 8'b0010_0100;
instMem[93] = 8'b0100_0110;
instMem[94] = 8'b1111_1111;
instMem[95] = 8'b1111_1111;
instMem[96] = 8'b0000_0000;
instMem[97] = 8'b0000_0101;
instMem[98] = 8'b0001_0000;
instMem[99] = 8'b1000_0000;
instMem[100] = 8'b0000_0000;
instMem[101] = 8'b0100_1000;
instMem[102] = 8'b0010_0000;
instMem[103] = 8'b0010_0001;
instMem[104] = 8'b1000_1100;
instMem[105] = 8'b1000_0010;
instMem[106] = 8'b0000_0000;
instMem[107] = 8'b0000_0100;
instMem[108] = 8'b1000_1100;
instMem[109] = 8'b1000_0011;
instMem[110] = 8'b0000_0000;
instMem[111] = 8'b0000_0000;
instMem[112] = 8'b0000_0000;
instMem[113] = 8'b0100_0011;
instMem[114] = 8'b0001_0000;
instMem[115] = 8'b0010_1010;
instMem[116] = 8'b0001_0000;
instMem[117] = 8'b0100_0000;
instMem[118] = 8'b0000_0000;
instMem[119] = 8'b0000_0110;
instMem[120] = 8'b0000_0000;
instMem[121] = 8'b0000_0000;
instMem[122] = 8'b0000_0000;
instMem[123] = 8'b0000_0000;
instMem[124] = 8'b0000_0000;
instMem[125] = 8'b0000_0000;
instMem[126] = 8'b0000_0000;
instMem[127] = 8'b0000_0000;
instMem[128] = 8'b1000_1100;
instMem[129] = 8'b1000_0011;
instMem[130] = 8'b0000_0000;
instMem[131] = 8'b0000_0000;
instMem[132] = 8'b1000_1100;
instMem[133] = 8'b1000_0010;
instMem[134] = 8'b0000_0000;
instMem[135] = 8'b0000_0100;
instMem[136] = 8'b1010_1100;
instMem[137] = 8'b1000_0010;
instMem[138] = 8'b0000_0000;
instMem[139] = 8'b0000_0000;
instMem[140] = 8'b1010_1100;
instMem[141] = 8'b1000_0011;
instMem[142] = 8'b0000_0000;
instMem[143] = 8'b0000_0100;
instMem[144] = 8'b0010_0100;
instMem[145] = 8'b1010_0101;
instMem[146] = 8'b0000_0000;
instMem[147] = 8'b0000_0001;

instMem[148] = 8'b0000_0000;
instMem[149] = 8'b1010_0110;
instMem[150] = 8'b0001_0000;
instMem[151] = 8'b0010_1010;

instMem[152] = 8'b0001_0100;//bne
instMem[153] = 8'b0100_0000;
instMem[154] = 8'b1111_1111;
instMem[155] = 8'b1111_0001;

instMem[156] = 8'b0000_0000;//sll
instMem[157] = 8'b0000_0010;
instMem[158] = 8'b0001_0000;
instMem[159] = 8'b1000_0000;

instMem[160] = 8'b0000_0000;// nop
instMem[161] = 8'b0000_0000;
instMem[162] = 8'b0000_0000;
instMem[163] = 8'b0000_0000;

instMem[164] = 8'b0010_0100;// addiu
instMem[165] = 8'b1110_0111;
instMem[166] = 8'b0000_0000;
instMem[167] = 8'b0000_0001;

instMem[168] = 8'b0000_0000;//slt 
instMem[169] = 8'b1110_1010;
instMem[170] = 8'b0001_0000;
instMem[171] = 8'b0010_1010;

instMem[172] = 8'b0001_0100;//bnez
instMem[173] = 8'b0100_0000;
instMem[174] = 8'b1111_1111;
instMem[175] = 8'b1110_0010;

instMem[176] = 8'b0000_0000;// nop
instMem[177] = 8'b0000_0000;
instMem[178] = 8'b0000_0000;
instMem[179] = 8'b0000_0000;

instMem[180] = 8'b0010_0000;//addi
instMem[181] = 8'b0000_0010;
instMem[182] = 8'b0000_0000;
instMem[183] = 8'b0000_0000;

instMem[184] = 8'b0000_0000;
instMem[185] = 8'b0000_0000;
instMem[186] = 8'b0000_0000;
instMem[187] = 8'b0000_0000;

instMem[188] = 8'b0000_0000;
instMem[189] = 8'b0000_0000;
instMem[190] = 8'b0000_0000;
instMem[191] = 8'b0000_0000;//correct bubblesort2
*/
/*

// test1_bubblesort
instMem[0] = 8'b0010_0000; // addi
instMem[1] = 8'b0000_1000; 
instMem[2] = 8'b0000_0000;
instMem[3] = 8'b1100_1000;

instMem[4] = 8'b0010_0000; // addi
instMem[5] = 8'b0000_1001;
instMem[6] = 8'b0000_0000;
instMem[7] = 8'b0000_0101;

instMem[8] = 8'b0010_0000; // *addi(10)
instMem[9] = 8'b0000_0010;
instMem[10] = 8'b0000_0000;
instMem[11] = 8'b0000_1010;

instMem[12] = 8'b1010_1101; // sw v0 0(t0)
instMem[13] = 8'b0000_0010;
instMem[14] = 8'b0000_0000;
instMem[15] = 8'b0000_0000;

instMem[16] = 8'b0010_0000; // *addi(92)
instMem[17] = 8'b0000_0010;
instMem[18] = 8'b0000_0000;
instMem[19] = 8'b0101_1100;

instMem[20] = 8'b1010_1101; // sw
instMem[21] = 8'b0000_0010;
instMem[22] = 8'b0000_0000;
instMem[23] = 8'b0000_0100;

instMem[24] = 8'b0010_0000; // *addi(55)
instMem[25] = 8'b0000_0010;
instMem[26] = 8'b0000_0000;
instMem[27] = 8'b0011_0111;

instMem[28] = 8'b1010_1101; // sw
instMem[29] = 8'b0000_0010;
instMem[30] = 8'b0000_0000;
instMem[31] = 8'b0000_1000;

instMem[32] = 8'b0010_0000; // *addi(1)
instMem[33] = 8'b0000_0010;
instMem[34] = 8'b0000_0000;
instMem[35] = 8'b0000_0001;

instMem[36] = 8'b1010_1101; // sw
instMem[37] = 8'b0000_0010;
instMem[38] = 8'b0000_0000;
instMem[39] = 8'b0000_1100;

instMem[40] = 8'b0010_0000; // *addi(46)
instMem[41] = 8'b0000_0010;
instMem[42] = 8'b0000_0000;
instMem[43] = 8'b0010_1110;

instMem[44] = 8'b1010_1101; // sw
instMem[45] = 8'b0000_0010;
instMem[46] = 8'b0000_0000;
instMem[47] = 8'b0001_0000;
instMem[48] = 8'b0010_0000;
instMem[49] = 8'b0000_0111;
instMem[50] = 8'b0000_0000;
instMem[51] = 8'b0000_0000;
instMem[52] = 8'b0010_0101;
instMem[53] = 8'b0010_1010;
instMem[54] = 8'b1111_1111;
instMem[55] = 8'b1111_1111;
instMem[56] = 8'b0000_0001;
instMem[57] = 8'b0010_0111;
instMem[58] = 8'b0001_0000;
instMem[59] = 8'b0010_0011;
instMem[60] = 8'b0010_0100;
instMem[61] = 8'b0100_0010;
instMem[62] = 8'b1111_1111;
instMem[63] = 8'b1111_1111;
instMem[64] = 8'b0001_0000;
instMem[65] = 8'b0100_0000;
instMem[66] = 8'b0000_0000;
instMem[67] = 8'b0001_1000;
instMem[68] = 8'b0000_0000;
instMem[69] = 8'b0000_0000;
instMem[70] = 8'b0000_0000;
instMem[71] = 8'b0000_0000;
instMem[72] = 8'b0000_0000;
instMem[73] = 8'b0100_0000;
instMem[74] = 8'b0101_1000;
instMem[75] = 8'b0010_1010;
instMem[76] = 8'b0001_0101;
instMem[77] = 8'b0110_0000;
instMem[78] = 8'b0000_0000;
instMem[79] = 8'b0001_0101;
instMem[80] = 8'b0000_0000;
instMem[81] = 8'b0000_0000;
instMem[82] = 8'b0000_0000;
instMem[83] = 8'b0000_0000;
instMem[84] = 8'b0010_0000;
instMem[85] = 8'b0000_0101;
instMem[86] = 8'b0000_0000;
instMem[87] = 8'b0000_0000;
instMem[88] = 8'b0000_0001;
instMem[89] = 8'b0010_0111;
instMem[90] = 8'b0001_0000;
instMem[91] = 8'b0010_0011;
instMem[92] = 8'b0010_0100;
instMem[93] = 8'b0100_0110;
instMem[94] = 8'b1111_1111;
instMem[95] = 8'b1111_1111;
instMem[96] = 8'b0000_0000;
instMem[97] = 8'b0000_0101;
instMem[98] = 8'b0001_0000;
instMem[99] = 8'b1000_0000;
instMem[100] = 8'b0000_0000;
instMem[101] = 8'b0100_1000;
instMem[102] = 8'b0010_0000;
instMem[103] = 8'b0010_0001;
instMem[104] = 8'b1000_1100;
instMem[105] = 8'b1000_0010;
instMem[106] = 8'b0000_0000;
instMem[107] = 8'b0000_0100;
instMem[108] = 8'b1000_1100;
instMem[109] = 8'b1000_0011;
instMem[110] = 8'b0000_0000;
instMem[111] = 8'b0000_0000;
instMem[112] = 8'b0000_0000;
instMem[113] = 8'b0100_0011;
instMem[114] = 8'b0001_0000;
instMem[115] = 8'b0010_1010;
instMem[116] = 8'b0001_0000;
instMem[117] = 8'b0100_0000;
instMem[118] = 8'b0000_0000;
instMem[119] = 8'b0000_0110;
instMem[120] = 8'b0000_0000;
instMem[121] = 8'b0000_0000;
instMem[122] = 8'b0000_0000;
instMem[123] = 8'b0000_0000;
instMem[124] = 8'b0000_0000;
instMem[125] = 8'b0000_0000;
instMem[126] = 8'b0000_0000;
instMem[127] = 8'b0000_0000;
instMem[128] = 8'b1000_1100;
instMem[129] = 8'b1000_0011;
instMem[130] = 8'b0000_0000;
instMem[131] = 8'b0000_0000;
instMem[132] = 8'b1000_1100;
instMem[133] = 8'b1000_0010;
instMem[134] = 8'b0000_0000;
instMem[135] = 8'b0000_0100;
instMem[136] = 8'b1010_1100;
instMem[137] = 8'b1000_0010;
instMem[138] = 8'b0000_0000;
instMem[139] = 8'b0000_0000;
instMem[140] = 8'b1010_1100;
instMem[141] = 8'b1000_0011;
instMem[142] = 8'b0000_0000;
instMem[143] = 8'b0000_0100;
instMem[144] = 8'b0010_0100;
instMem[145] = 8'b1010_0101;
instMem[146] = 8'b0000_0000;
instMem[147] = 8'b0000_0001;

instMem[148] = 8'b0000_0000;
instMem[149] = 8'b1010_0110;
instMem[150] = 8'b0001_0000;
instMem[151] = 8'b0010_1010;

instMem[152] = 8'b0001_0100;//bne
instMem[153] = 8'b0100_0000;
instMem[154] = 8'b1111_1111;
instMem[155] = 8'b1111_0001;

instMem[156] = 8'b0000_0000;//sll
instMem[157] = 8'b0000_0010;
instMem[158] = 8'b0001_0000;
instMem[159] = 8'b1000_0000;

instMem[160] = 8'b0000_0000;// nop
instMem[161] = 8'b0000_0000;
instMem[162] = 8'b0000_0000;
instMem[163] = 8'b0000_0000;

instMem[164] = 8'b0010_0100;// addiu
instMem[165] = 8'b1110_0111;
instMem[166] = 8'b0000_0000;
instMem[167] = 8'b0000_0001;

instMem[168] = 8'b0000_0000;//slt 
instMem[169] = 8'b1110_1010;
instMem[170] = 8'b0001_0000;
instMem[171] = 8'b0010_1010;

instMem[172] = 8'b0001_0100;//bnez
instMem[173] = 8'b0100_0000;
instMem[174] = 8'b1111_1111;
instMem[175] = 8'b1110_0010;

instMem[176] = 8'b0000_0000;// nop
instMem[177] = 8'b0000_0000;
instMem[178] = 8'b0000_0000;
instMem[179] = 8'b0000_0000;

instMem[180] = 8'b0010_0000;//addi
instMem[181] = 8'b0000_0010;
instMem[182] = 8'b0000_0000;
instMem[183] = 8'b0000_0000;

instMem[184] = 8'b0000_0000;
instMem[185] = 8'b0000_0000;
instMem[186] = 8'b0000_0000;
instMem[187] = 8'b0000_0000;

instMem[188] = 8'b0000_0000;
instMem[189] = 8'b0000_0000;
instMem[190] = 8'b0000_0000;
instMem[191] = 8'b0000_0000;//correct bubblesort1
*/
		
/*
instMem[0] <= 8'b0010_0001;
instMem[1] <= 8'b0010_1001;
instMem[2] <= 8'b0000_0000;
instMem[3] <= 8'b0000_0001;


instMem[4] <= 8'b0010_0001;
instMem[5] <= 8'b0100_1010;
instMem[6] <= 8'b0000_0000;
instMem[7] <= 8'b0000_0001;


instMem[8] <= 8'b0010_0001;
instMem[9] <= 8'b0110_1011;
instMem[10] <= 8'b0000_0000;
instMem[11] <= 8'b0000_1010;


instMem[12] <= 8'b0010_0001;
instMem[13] <= 8'b0100_1010;
instMem[14] <= 8'b0000_0000;
instMem[15] <= 8'b0000_0001;


instMem[16] <= 8'b0000_0001;
instMem[17] <= 8'b0000_1001;
instMem[18] <= 8'b0110_0000;
instMem[19] <= 8'b0010_0000;


instMem[20] <= 8'b0010_0001;
instMem[21] <= 8'b0010_1000;
instMem[22] <= 8'b0000_0000;
instMem[23] <= 8'b0000_0000;
// finish

instMem[24] <= 8'b0010_0001;
instMem[25] <= 8'b1000_1001;
instMem[26] <= 8'b0000_0000;
instMem[27] <= 8'b0000_0000;

instMem[28] <= 8'b0001_0101;
instMem[29] <= 8'b0100_1011;
instMem[30] <= 8'b1111_1111;
instMem[31] <= 8'b1111_1011;//bne to 10

instMem[32] <= 8'b0001_0000;
instMem[33] <= 8'b0000_0000;
instMem[34] <= 8'b0000_0000;
instMem[35] <= 8'b0000_0000;//infinity*/
//F

    end
  end

  assign instruction = {instMem[address], instMem[address + 10'd1], instMem[address + 10'd2], instMem[address + 10'd3]};
endmodule // insttructionMem
