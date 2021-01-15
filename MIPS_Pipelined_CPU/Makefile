bld_dir  := $(PWD)/build
add_dir  := $(PWD)/src/adder
conU_dir := $(PWD)/src/controlUnit
def_dir  := $(PWD)/src/define
haz_dir  := $(PWD)/src/hazard_forwarding
mem_dir  := $(PWD)/src/memory
pipe_dir := $(PWD)/src/pipeRegisters
stg_dir  := $(PWD)/src/stages
sim_dir  := $(PWD)/sim
ext_dir  := $(PWD)/src
syn_dir  := $(PWD)/syn
 
ifeq ($(FSDB),1)
FSDB_DEF := +FSDB
endif

$(bld_dir):
	mkdir -p $(bld_dir)
$(syn_dir):
	mkdir -p $(syn_dir)
	
#RTL Simulation (presim)

rtl_full: | $(bld_dir)
	cd $(bld_dir); \
	ncverilog $(sim_dir)/MIPS_CPU_tb.v \
	+incdir+$(conU_dir)+$(add_dir)+$(def_dir)+$(haz_dir)+$(mem_dir)+$(pipe_dir)+$(stg_dir)+$(ext_dir)  \
	+define+full$(FSDB_DEF) \
	+access+rwc	
	
#Post-Synthesis simulation
syn_full: | $(bld_dir)
	cd $(bld_dir); \
	ncverilog $(sim_dir)/MIPS_CPU_tb.v \
	+incdir+$(syn_dir)+$(conU_dir)+$(add_dir)+$(def_dir)+$(haz_dir)+$(mem_dir)+$(pipe_dir)+$(stg_dir)+$(ext_dir) \
	+define+SYN+full$(FSDB_DEF) \
	+access+rwc
#ICC-check
icc: | $(bld_dir)
	cd $(bld_dir); \
	ncverilog $(sim_dir)/MIPS_CPU_tb.v \
	+incdir+$(conU_dir)+$(add_dir)+$(def_dir)+$(haz_dir)+$(mem_dir)+$(pipe_dir)+$(stg_dir)+$(ext_dir) \
	+define+full$(FSDB_DEF) \
	+access+rwc +nccoverage+all +nccovdut+MIPS_CPU +nccovoverwrite +nccov58
	
#Utilities
nwave: | $(bld_dir)
	cd $(bld_dir); \
	nWave CPU.fsdb &

superlint: | $(bld_dir)
	cd $(bld_dir); \
	jg -superlint ../script/superlint.tcl &
	
synthesize: | $(bld_dir) $(syn_dir)
	cd $(bld_dir); \
	dc_shell -f ../script/synthesis.tcl
	
tar: clean
	STUDENTID=$$(basename $(PWD)); \
	cd ..;\
	tar cvf $$STUDENTID.tar $$STUDENTID
	
.PHONY: clean
	
clean:
	rm -rf $(bld_dir);

	
