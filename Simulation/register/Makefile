TEST_BENCH = register_tb

SUB_MODULE_FILES = ../../Modules/register.v

MODULES_FILES = $(TEST_BENCH).v $(SUB_MODULE_FILES)

.PHONY: all

sim:
	@echo "#### Simulation via iverilog..."
	$(info MODULES_FILES is $(MODULES_FILES))
	iverilog -DSIMULATE -o $(TEST_BENCH).vvp $(MODULES_FILES)
	vvp $(TEST_BENCH).vvp -lxt2
	gtkwave $(TEST_BENCH).vcd