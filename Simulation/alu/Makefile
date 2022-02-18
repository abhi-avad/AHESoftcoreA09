TEST_TARGET = SIMULATE_ADD
#TEST_TARGET = SIMULATE_SUB

TEST_BENCH = alu_tb

SUB_MODULE_FILES = ../../Modules/alu.v ../../Modules/constants.v

MODULES_FILES = $(TEST_BENCH).v $(SUB_MODULE_FILES)

.PHONY: all

sim:
	@echo "#### Simulation via iverilog..."
	$(info MODULES_FILES is $(MODULES_FILES))
	iverilog -D$(TEST_TARGET) -o $(TEST_BENCH).vvp $(MODULES_FILES)
	vvp $(TEST_BENCH).vvp -lxt2
	gtkwave $(TEST_BENCH).vcd