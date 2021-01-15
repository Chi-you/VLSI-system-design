`include "defines.v"

module IF2ID (clk, rst, Flush, freeze, /*PC_in,*/ instruction_in,
										 /*PC,*/    instruction);
  
  input clk, rst, Flush, freeze;
  input [`WORD_LEN-1:0] /*PC_in,*/ instruction_in;
  
  output reg [`WORD_LEN-1:0] /*PC,*/ instruction;
  
  always@(posedge clk or posedge rst)begin
    if(rst)begin
	  /*PC <= `WORD_LEN'b0;*/
	  instruction <= `WORD_LEN'b0;
	end
	else begin
	  if(~freeze)begin
	    if(Flush)begin
		  instruction <= `WORD_LEN'b0;
		  /*PC <= `WORD_LEN'b0;*/
		end
		else begin
		  instruction <= instruction_in;
		  /*PC <= PC_in;*/
		end
      end
	  /*else begin//new
	    instruction <= instruction;
		PC <= PC;
	  end*/
	end
  end
endmodule
