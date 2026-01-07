# Makefile for Calculator

# User-defined base directory
EXAMPLE_DIR         = $(CURDIR)

# Compiler and flags
CXX         = g++
CXXFLAGS    = -g -O0 -fPIC -Wall -I$(EXAMPLE_DIR)/api -I$(VCS_HOME)/include -DSIMULATOR
LDFLAGS     = -shared   
LIB_NAME    = calculator_xtor
SHARED_LIB  = lib$(LIB_NAME).so
EXE         = calculator_exec
LDFLAGS_VCS = -Wl,-rpath,$(CURDIR) -L$(CURDIR) -l$(LIB_NAME) 

# VCS settings
VCS = vcs
VERDI = verdi
VCS_FLAGS = -sverilog -kdb -debug_access+all -debug_region+cell+encrypt -full64 -LDFLAGS "$(LDFLAGS_VCS)"
SIM_EXEC = simv
SIM_DAIDIR = simv.daidir


# Source and object files
SV_DUT  := $(wildcard $(EXAMPLE_DIR)/dut/*.sv) $(wildcard $(EXAMPLE_DIR)/dut/*.v) 
# SV_RTL  := $(wildcard $(EXAMPLE_DIR))   
SV_SRC  := $(SV_DUT)
CPP_SRC := $(wildcard $(EXAMPLE_DIR)/api/*.cc) #$(EXAMPLE_DIR)/xtor_calculator_main.cc
CPP_HDR := $(wildcard $(EXAMPLE_DIR)/api/*.hh)
CPP_OBJ := $(CPP_SRC:.cc=.o)
# Identify main source and object files
MAIN_SRC := $(wildcard $(EXAMPLE_DIR)/api/*_main.cc)
# MAIN_OBJ := $(MAIN_SRC:.cc=.o)


#.fsdb
SV_FSDB := $(wildcard $(EXAMPLE_DIR)/novas.fsdb)

# Rule to compile SV files with VCS
$(SIM_EXEC): $(SV_SRC) $(SHARED_LIB)
	$(VCS) $(VCS_FLAGS) $(SV_SRC) -o $(SIM_EXEC)

# Rule to launch waveforms in Verdi
# $(Waveform): $(SV_FSDB) $(SIM_DAIDIR)
# 	$(VERDI) -ssf $(SV_FSDB) -dbdir $(SIM_DAIDIR)/ &

# Rule to compile C++ objects
%.o: %.cc $(CPP_HDR)
	$(CXX) $(CXXFLAGS) -c $< -o $@

# Rule to create shared library
$(SHARED_LIB): $(CPP_OBJ)
	$(CXX) $(LDFLAGS) $(CPP_OBJ) -o $(SHARED_LIB)

# Default target
all: $(SIM_EXEC) 

# Compilation
compile: $(SIM_EXEC)

sim: $(SIM_EXEC)
	./$(SIM_EXEC)


# $(EXE): $(MAIN_OBJ) $(SHARED_LIB)
# 	$(CXX) $(MAIN_OBJ) -L. -l$(LIB_NAME) -o $(EXE)


# run: $(EXE)
# 	LD_LIBRARY_PATH=.:$$LD_LIBRARY_PATH ./$(EXE)

# Define phony targets (targets that don't produce files with those names)
.PHONY: all compile sim run wave clean

# Target to launch waveforms in Verdi
wave:
	$(VERDI) -ssf $(SV_FSDB) -dbdir $(SIM_DAIDIR)/ &
	
# Clean up
clean:
	rm -f $(SIM_EXEC) $(SHARED_LIB) $(CPP_OBJ) $(MAIN_OBJ) $(EXE)
	rm -rf *.daidir *.fsdb novas.* verdiLog csrc/ vc_hdrs.h ucli.key novas_dump.log