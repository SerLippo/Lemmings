TOP				= lemmings_tb
TEST     ?= lemmings_full_random_test
VERDI		 ?= 0
GUI      ?= 0
COV      ?= 0
SEED      = `date "+%m%d%H%M%S"`
OUT      ?= out
VERB     ?= UVM_HIGH	#{UVM_NONE, UVM_LOW, UVM_MEDIUM, UVM_HIGH}
INCDIR    = +incdir+../{agts,cfg,dut,env,seq_lib,tb,tests}
TESTLIST  = lemmings_full_random_test \
						lemmings_left_splat_test \
						lemmings_right_splat_test

VCOMP			= vlogan \
						$(INCDIR) \
						-full64 \
						-sverilog \
						-ntb_opts uvm-1.2 \
						-timescale=1ps/1ps \
						-l $(OUT)/log/comp_$(TOP).log
ELAB			= vcs \
						-cpp g++-4.4 \
						-cc gcc-4.4 \
						-full64 -sverilog \
						-ntb_opts uvm-1.2 \
						-debug_all \
						-l $(OUT)/log/elab_$(TOP).log \
						-o $(OUT)/obj/lemmings.simv
RUN				= $(OUT)/obj/lemmings.simv \
						+ntb_random_seed=$(SEED) \
						+UVM_NO_RELNOTES \
						+UVM_VERBOSITY=$(VERB)
COV_OPTS  	= -full64 -dir $(CM_DIR)
CM_NAME 	?= $(TEST)_$(SEED)
CM_DIR		?= $(OUT)/cov.vdb

ifeq ($(VERDI),1)
	VCOMP  += -kdb
	RUN += -verdi
endif

ifeq ($(GUI),1)
	RUN += -gui
endif

ifeq ($(COV),1)
	ELAB  += -cm line+cond+fsm+tgl+branch+assert -cm_dir $(OUT)/cov.vdb
	RUN += -cm line+cond+fsm+tgl+branch+assert -covg_cont_on_error
endif

.PHONY: clean dcomp comp elab sim_all cov
all: clean dcomp comp elab sim_all cov

prepare:
	mkdir -p $(OUT)/work
	mkdir -p $(OUT)/log
	mkdir -p $(OUT)/sim
	mkdir -p $(OUT)/obj
	mkdir -p .shadow

dcomp: prepare
	$(VCOMP)  -f file_list.f

comp: .shadow/compile_uvm
	${VCOMP} ../env/lemmings_pkg.sv
	${VCOMP} ../tb/lemmings_if.sv
	$(VCOMP) ../tb/lemmings_tb.sv

.shadow/compile_uvm:
	${VCOMP} -ntb_opts uvm-1.2

elab: comp
	$(ELAB) $(TOP)

run: 
	$(RUN) +UVM_TESTNAME=$(TEST) -l $(OUT)/sim/$(CM_NAME).log -cm_dir $(CM_DIR) -cm_name $(CM_NAME)

regr: 
	for t in $(TESTLIST); do \
		$(RUN) +UVM_TESTNAME=$$t -l $(OUT)/sim/$$t.log -cm_dir $(CM_DIR) -cm_name $(CM_NAME) +vpdfile+$(OUT)/sim/$$t_$(SEED)_$(VPDFILE); \
	done

mergecov:
	urg -format both $(COV_OPTS)

dvecov:
	dve $(COV_OPTS)

verdicov:
	verdi -cov -covdir $(CM_DIR)

clean:
	-rm -rf csrc DVEfiles ucli.key uvm_dpi.so vc_hdrs.h  *simv* *.vpd *.log *.sml *.fsdb work.* *.vdb
	-rm -rf AN.DB urgReport novas.conf verdiLog vdCovLog novas.rc $(OUT) .shadow
	-rm -rf eman* vhdl_objs_dir
	-rm -rf transcript vsim* regr_ucdb* work $(TOP) $(TOP).vdb
	-rm -rf ._Vera* .synopsys_dve_rebuild.tcl .restartSimSession.tcl.old
	-rm -rf .vlogansetup* .inter.vpd.uvm