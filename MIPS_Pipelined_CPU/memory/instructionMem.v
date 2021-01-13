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

        
      end
    end

  assign instruction = {instMem[address], instMem[address + 1], instMem[address + 2], instMem[address + 3]};
endmodule // insttructionMem
