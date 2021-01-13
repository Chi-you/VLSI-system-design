module instruction_set_model ();
parameter WIDTH   = 32,
          CYCLE   = 10,
          ADDRSIZE= 12,
          MAXREGS = 16,
          SBITS   = 5,
          MEMSIZE = (1 << ADDRSIZE);

reg [WIDTH-1:0]    MEM[0:MEMSIZE-1],
                   RFILE[0:MAXREGS-1],
                   ir, src1, src2; 
reg [WIDTH:0]      result; // ALU result register
reg [SBITS-1:0]    psr;    // processor status register
reg [ADDRSIZE-1:0]  pc;    // program counter
reg dir;                   // rotate direction
reg reset;                 // system reset
integer i;


// General definition
`define TRUE 1
`define FALSE 0
`define DEBUG_ON debug = 1
`define DEBUG_OFF debug = 0

// Define Instruction fields
`define OPCODE  ir[31:28]
`define SRC     ir[23:12]
`define DST     ir[11:0]
`define SRCTYPE ir[27]
`define DSTTYPE ir[26]
`define CCODE   ir[27:24] 
`define SRCNT   ir[23:12] // shift or rotate count: <0 -> left, >0 -> right

// Operand types
`define REGTYPE 0
`define IMMTYPE 1

// Define opcodes for each instruction
`define NOP 4'b0000
`define BRA 4'b0001
`define LD  4'b0010
`define STR 4'b0011
`define ADD 4'b0100
`define SUB 4'b0101 // new
`define MUL 4'b0110
`define CMP 4'b0111
`define SHF 4'b1000
`define ROT 4'b1001
`define HLT 4'b1010
`define MOV 4'b1011 // new

// define condition code field 
`define CARRY  psr[0]
`define EVEN   psr[1]
`define PARITY psr[2]
`define ZERO   psr[3]
`define NEG    psr[4]

// define condition codes
`define CCC   1 
`define CCE   2
`define CCP   3
`define CCZ   4
`define CCN   5
`define CCA   0
`define RIGHT 0
`define LEFT  1

// function for ALU operands and result
function [WIDTH-1:0] getsrc;
    input [WIDTH-1:0] in;
    begin
        if(`SRCTYPE == `REGTYPE) getsrc = RFILE[`SRC];
        else getsrc = `SRC;
    end
endfunction

function [WIDTH-1:0] getdst;
    input [WIDTH-1:0] in;
    begin
        if (`DSTTYPE == `REGTYPE) getdst = RFILE[`DST];
        else begin // immediate type
            $display("Error:Immediate data can’t be destination.");
        end
    end
endfunction

// Functions  tasks for Condition Codes
function checkcond; //Returns 1 if condition code is set .
    input [3:0] ccode;
    begin
        case (ccode)
            `CCC : checkcond = `CARRY;
            `CCE : checkcond = `EVEN;
            `CCP : checkcond = `PARITY;
            `CCZ : checkcond = `ZERO;
            `CCN : checkcond = `NEG;
            `CCA : checkcond = 1;
        endcase
    end
endfunction

task clearcondcode ; // Reset condition codes in PSR
    begin
        psr = 0;
    end
endtask

task setcondcode ; // Compute the condition codes and set PSR
    input [WIDTH:0] res; // 33 bits result register
    begin
        `CARRY = res[WIDTH];
        `EVEN = ~res[0];
        `PARITY = ^res;
        `ZERO = ~(|res);
        `NEG = res[WIDTH-1];
    end
endtask

// Main Tasks -fetch, execute, write_result
task fetch ; // Fetch the instruction and increment PC.
    begin
        ir = MEM[pc];
        pc = pc + 1;
        //$display ("ir=%h, pc=%d", ir, pc);
    end
endtask

task execute ; // Decode and execute the instruction. // add "bne/slt"
    begin
        case(`OPCODE)
            `NOP :;
            `BRA : begin
                if(checkcond(`CCODE) == 1) pc = `DST;
            end
            `LD  : begin
                clearcondcode;
                if (`SRCTYPE) RFILE[`DST] = `SRC;
                else RFILE[`DST] = MEM[`SRC];
                setcondcode({1'b0, RFILE[`DST]});
            end
            `STR :begin
                clearcondcode;
                if (`SRCTYPE) MEM[`DST] = `SRC;
                else MEM[`DST] = RFILE[`SRC];
                if (`SRCTYPE) setcondcode({21'b0, `SRC});
                else  setcondcode({1'b0, RFILE[`SRC]});
            end
            `ADD : begin
                clearcondcode;
                src1 = getsrc(ir);
                src2 = getdst(ir);
                result = src1 + src2;
                setcondcode(result);
            end
            `SUB : begin
                clearcondcode;
                src1 = getsrc(ir);
                src2 = getdst(ir);
                result = src1 - src2;
                setcondcode(result);
            end
            `MUL : begin
                clearcondcode;
                src1 = getsrc(ir);
                src2 = getdst(ir);
                result = src1 * src2;
                setcondcode(result);
            end
            `CMP : begin
                clearcondcode;
                src1 = getsrc(ir);
                result = ~src1;
                setcondcode(result);
            end
            `SHF : begin
                clearcondcode;
                src1 = getsrc(ir);
                src2 = getdst(ir);
                i = src1[ADDRSIZE-1:0];
                result = (i>=0) ? (src2 >> i) : (src2 << -i);
                setcondcode(result);
            end
            `ROT : begin
                clearcondcode;
                src1 = getsrc(ir);
                src2 = getdst(ir);
                dir = (src1[ADDRSIZE-1] >= 0) ? `RIGHT : `LEFT;
                i = (src1[ADDRSIZE-1] >= 0) ? src1 : -src1[ADDRSIZE-1:0];
                while (i > 0) begin
                    if (dir == `RIGHT) begin
                        result = src2 >> 1;
                        result[WIDTH-1] = src2 [0];
                    end
                    else begin
                        result = src2 << 1;
                        result[0] = src2[WIDTH-1];
                    end
                    i= i - 1;
                    src2 = result;
                end //end of while
                setcondcode(result);
            end
            `HLT : begin
                $display("Halt...");
                $stop;
            end
			`MOV : begin // initialize the register
                clearcondcode;
                if (`SRCTYPE) RFILE[`DST] = `SRC;
                else RFILE[`DST] = RFILE[`SRC];
                setcondcode({1'b0, RFILE[`DST]});
            end
            default : $display ("Error : Illegal Opcode .");
        endcase
    end
endtask

// Write the result in register file or memory.
task write_result ;
    begin
        if ((`OPCODE >= `ADD) && (`OPCODE < `HLT)) begin
            if(`DSTTYPE == `REGTYPE) RFILE[`DST] = result ;
            else MEM[`DST] = result ;
        end
    end
endtask

//Debugging help
task apply_reset ;
    begin
        reset = 1;
        #CYCLE
        reset = 0;
        pc = 0;
    end
endtask


task disprm ;
    input rm ;
    input [ADDRSIZE-1:0] adr1, adr2 ;
    begin
        if (rm == `REGTYPE) begin
            while (adr2 >= adr1) begin
                $display("REGFILE[%d] = %d\n", adr1, RFILE[adr1]);
                adr1 = adr1 +1;
            end
        end
        else begin
            while (adr2 >= adr1) begin
                $display("MEM[%d] = %d\n", adr1, MEM[adr1]);
                adr1 = adr1 + 1;
            end
        end
    end
endtask


// read the program
initial begin :prog_load
    $readmemb("sisc.prog", MEM);
    $monitor("%d %d %d %d %d %d %d %d %d", $time, pc, RFILE[0], RFILE[1], RFILE[2], RFILE[3], RFILE[4], RFILE[5], MEM[23]);
    apply_reset;
end

always begin : main_process
    if (!reset) begin
        #CYCLE fetch ;
        #CYCLE execute ;
        #CYCLE write_result ;
    end
    else #CYCLE ;
end

initial begin
    $fsdbDumpfile("CPU.fsdb");
    $fsdbDumpvars("+mda");
end

endmodule
