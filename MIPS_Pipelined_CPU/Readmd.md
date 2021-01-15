# MIPS_CPU 
####*NOTE: All "make instruction" must execute in the MIPS_Pipelined_CPU file
1. To compile the design (for presim): make rtl_full
2. To compile the design (for postsim): make syn_full
3. To compile the design (for coverage): make icc
4. To run nWave with CPU.fsdb: make nwave
5. To run superlint and execute superlint.tcl: make superlint
6. To synthesize the design: make synthesize
7. The file hierachy:
    MIPS_Pipelined_CPU/
        -scipt/
            -superlint.tcl
            -synthesis.tcl
        -sim/
            -correct_bubblesort1.txt
            -correct_bubblesort2.txt
            -Fibonacci.txt
            -all_instructions_without_Branch_Jump.txt
            -forwarding.txt
            -hazard_without_PCproblem.txt
        -src/
            -adder/
                -csa32_nov_nco.v
                -csa16_nov_nco.v
                -csa16_nov.v
                -csa8_nov_nco.v
                -csa8_nov.v
                -cla4_nov_nco.v
                -cla4_nov.v
            -controlUnit/
                -conditionChecker.v
                -controller.v
            -define/
                -defines.v
            -hazard_forwarding/
                -forwarding_EXE.v
                -hazard_detection.v
            -memory/
            -pipeRegisters/
                -IF2ID.v
                -ID2EXE.v
                -EXE2MEM.v
                -MEM2WB.v
            -stages/
                -IFStage.v
                -IDStage.v
                -EXEStage.v
                -WBStage.v
                -Mux_3input32.v
                -Mux5.v
                -Mux32.v
                -signExtend.v
        -syn/
            -MIPS_CPU_syn.sdf
            -MIPS_CPU_syn.v
            -tsmc18.v
        -ALU.v
        -MIPS_CPU.v
        -Register.v
        -shifter.v
