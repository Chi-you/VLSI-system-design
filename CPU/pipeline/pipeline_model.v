module pipeline_control;
// Declare parameters
parameter CYCLE = 10; // Cycle Time
parameter HALFCYCLE = (CYCLE/2); // Half Cycle Time
parameter WIDTH = 32; // Width of datapaths
parameter ADDRSIZE = 12; // Size of address fields
parameter MEMSIZE = (1<<ADDRSIZE); // Size of max memory
parameter MAXREGS = 16; // Maximum number of registers
parameter SBITS = 5; // Status register bits
parameter QDEPTH = 3; // Instruction Queue Depth

// Declare Registers and Memory
reg [WIDTH-1:0] MEM [0:MEMSIZE-1], // Memory
    RFILE [0:MAXREGS-1], // Register file
    ir,         // instruction registers
    src1, src2; // Alu operation registers
reg bypass1, bypass2; // Solve data dependency
reg [WIDTH:0] result; // ALU result register
reg [SBITS-1:0] psr; // Processor Status Register
reg [ADDRSIZE-1:0] pc; // Program counter
reg dir; // rotate direction
reg reset; // System Reset
integer i; // useful for interactive debugging

// Declare additional registers for pipeline control
reg [WIDTH-1:0] IR_Queue [0:QDEPTH-1], //Instruction Queue
    wir; // Instruction Register for write stage
reg [2:0] eptr, fptr, qsize; // Book keeping pointers
reg clock; // System Clock
reg [WIDTH:0] wresult; // ALU result register for write stage

// Various Flags -control lines
reg mem_access, branch_taken, halt_found;
reg result_ready;
reg executed, fetched;
reg debug;
wire queue_full;
event do_fetch, do_execute, do_write_results; 

// General definitions
`define TRUE 1
`define FALSE 0
`define DEBUG_ON debug = 1
`define DEBUG_OFF debug = 0

// Define Instruction fields
`define OPCODE ir[31:28]
`define SRC ir[23:12]
`define DST ir[11:0]
`define SRCTYPE ir[27] // source type, 0 = reg (mem for LD), 1 = imm
`define DSTTYPE ir[26] // desti. type, 0 = reg, 1 = imm
`define CCODE ir[27:24]
`define SRCNT ir[23:12] // Shift/rotate count -: left, +: right

// Define for Write instructions
`define WOPCODE wir[31:28]
`define WSRC wir[23:12]
`define WDST wir[11:0]
`define WSRCTYPE wir[27]
`define WDSTTYPE wir[26]

// Operand types
`define REGTYPE 0
`define IMMTYPE 1

// Define opcodes for each instruction
`define NOP 4'b0000
`define BRA 4'b0001
`define LD  4'b0010
`define STR 4'b0011
`define ADD 4'b0100
`define MUL 4'b0101
`define CMP 4'b0110
`define SHF 4'b0111
`define ROT 4'b1000
`define HLT 4'b1001

// Define Condition Code fields
`define CARRY  psr[0]
`define EVEN   psr[1]
`define PARITY psr[2]
`define ZERO   psr[3]
`define NEG    psr[4]

// define condition code
`define CCC 1 // Result has carry
`define CCE 2 // Result is even
`define CCP 3 // Result has odd parity
`define CCZ 4 // Result is Zero
`define CCN 5 // Result is Negative
`define CCA 0 // Always
`define RIGHT 0 // Rotate/Shift Right
`define LEFT 1 // Rotate/Shift Left

// Continuous assignment for queue_full
assign queue_full = (qsize == QDEPTH);

// Functions for ALU operands and result
function [WIDTH-1:0] getsrc;
    input [WIDTH-1:0] in;
    begin
        if (bypass1) getsrc = result;
        else if(`SRCTYPE == `REGTYPE) getsrc = RFILE[`SRC];
        else getsrc = `SRC; // immediate type
    end
endfunction

function [WIDTH-1:0] getdst;
    input [WIDTH-1:0] in;
    begin
        if (bypass2) getdst = result;
        else if (`DSTTYPE == `REGTYPE) getdst = RFILE[`DST];
        else begin // immediate type
            $display ("Error:Immediate data can't be destination.");
        end
    end
endfunction

// Functions/tasks for Condition Codes
function checkcond; // Returns 1 if condition code is set.
    input [4:0] ccode;
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

task clearcondcode; // Reset condition codes in PSR
    begin
        psr = 0;
    end
endtask

task setcondcode; // Compute the condition codes and set PSR
    input [WIDTH:0] res;
    begin
        `CARRY = res [WIDTH];
        `EVEN = ~res [0];
        `PARITY = ^res;
        `ZERO = ~(|res);
        `NEG = res [WIDTH-1] ;
    end
endtask

// Function and Tasks
task fetch;
    begin
        IR_Queue [fptr] = MEM [pc];
        fetched = 1;
    end
endtask

task execute;
    begin
        if (!mem_access) ir = IR_Queue [eptr] ; // New IR required?
        case (`OPCODE)
            `NOP: begin
                if (debug) $display ("Nop...");
            end
            `BRA: begin // BRA mem, cc
                if (debug) $write ("Branch...");
                if (checkcond (`CCODE) == 1) begin
                    pc = `DST;
                    branch_taken = 1;
                end
            end
            `LD: begin // LD reg, mem1
                if (mem_access == 0) begin
                    mem_access = 1; // Reserve next cycle
                end
                else begin // Memory access
                    if (debug) $display ("load...");
                        clearcondcode;
                    if (`SRCTYPE) begin
                        RFILE[`DST] = `SRC;
                    end
                    else RFILE[`DST] = MEM[`SRC];
                    setcondcode ({1'b0, RFILE[`DST]});
                    mem_access = 0;
                end
            end
            `STR: begin // STR mem, src
                if (mem_access == 0) mem_access = 1; // Reserve next cycle
                else begin // Memory access
                    if (debug) $display ("Store...");
                        clearcondcode;
                    if (`SRCTYPE) MEM [`DST] = `SRC;
                    else MEM [`DST] = RFILE [`SRC];
                    mem_access = 0;
                end
            end
            `ADD : begin
                clearcondcode;
                src1 = getsrc(ir);
                src2 = getdst(ir);
                result = src1 + src2;
                setcondcode(result);
            end
            // `SUB : begin
            //     clearcondcode;
            //     src1 = getsrc(ir);
            //     src2 = getdst(ir);
            //     result = src1 - src2;
            //     setcondcode(result);
            // end
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
            `HLT: begin
                $display ("Halt...");
                halt_found = 1;
            end
            default: $display ("Error: Wrong Opcode in instruction.");
        endcase
        if (!mem_access) executed = 1; // Instruction executed?
    end
endtask

task write_result;
    begin //ADD reg, src
        if ((`WOPCODE >= `ADD) && (`WOPCODE < `HLT)) begin
            if (`WDSTTYPE == `REGTYPE) RFILE[`WDST] = wresult;
            else $display ("Error: destination error.");
            result_ready = 0;
        end
    end
endtask

task flush_queue;
    begin // pc is already modified by branch execution
        fptr = 0;
        eptr = 0;
        qsize = 0;
        branch_taken = 0;
    end
endtask

task copy_results;
    begin
        if ((`OPCODE >= `ADD) && (`OPCODE< `HLT)) begin
            setcondcode (result);
            wresult = result;
            wir = ir;
            result_ready = 1;
        end
    end
endtask 

task apply_reset;
    begin
        result = 1;
        #2 reset = 0;
        pc = 0;
        mem_access = 0;
        qsize = 0;
        fptr = 0;
        eptr = 0;
        branch_taken = 0;
    end
endtask

task disprm;
    input rm;
    input [ADDRSIZE-1:0] adr1, adr2;
    begin
        if (rm == `REGTYPE) begin
            while (adr2 >= adr1) begin
                adr1 = adr1+1; // display …
            end
        end
        else begin
            while (adr2 >= adr1) begin
                adr1 = adr1+1; // display …
            end
        end
    end
endtask

task set_points;
    begin
        case ({fetched, executed})
            2'b00: ;
            2'b01: begin
                qsize = qsize-1;
                eptr = (eptr+1) % QDEPTH;
            end
            2'b10: begin
                qsize = qsize+1;
                fptr = (fptr+1) % QDEPTH;
            end
            2'b11: begin
                eptr = (eptr+1) % QDEPTH;
                fptr = (fptr+1) % QDEPTH;
            end
        endcase
    end
endtask

initial begin: asm_load
    clock = 0;
    $readmemb ("sisc.asm", MEM);
    $monitor ("%d %b %d %h %h %h", $time, clock, pc, RFILE[0], RFILE[1], RFILE[2]);
    apply_reset;
end

always begin: system_clock
    #5 clock = ~clock;
end

always@(posedge clock) begin : phase1_loop
    if (!reset) begin
        fetched = 0;
        executed = 0;
        if (!queue_full && !mem_access)
            -> do_fetch;
        if (qsize || mem_access)
            -> do_execute;
        if (result_ready)
            -> do_write_results;
    end
end

always@(do_fetch) begin : fetch_block
    fetch;
end

always@(do_execute) begin: execute_block
    if (!mem_access) begin
        ir = IR_Queue [eptr];
        bypass1 = (`SRC == `WDST) && ~ir[27] && ~wir[26];
        bypass2 = (`DST == `WDST) && ~ir[26] && ~wir[26];
    end
    execute; // Duplicated mem_acess check (redundancy)
    if (!mem_access) executed = 1;
end

always@(do_write_results) begin: write_result_block
    if (!mem_access) write_result;
end

always@(negedge clock) begin: phase2_loop
    if (!reset) begin
        if (!mem_access && !branch_taken) begin
            copy_results;
        end
        if (branch_taken) pc = `DST; // Duplicated assignment
        else if (!mem_access) pc = pc+1;
        if (branch_taken || halt_found) flush_queue;
        else set_points;
        if (halt_found) begin
            halt_found = 0;
            $stop;
        end
    end
end
endmodule