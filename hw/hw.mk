# GHDL Simulation Configuration
# ---------------------------------------------------------
GHDL       = ghdl
GHDL_FLAGS = --std=08 --workdir=hw/build
TB         ?= tb_riscv_core
WAVE       = hw/build/$(TB).vcd

# Directories
HW_DIR     = hw
SRC_DIR    = $(HW_DIR)/src
TB_DIR     = $(HW_DIR)/tb
BUILD_DIR  = $(HW_DIR)/build

# Analysis Order (Crucial: Packages must be analyzed first!)
PKGS    = $(SRC_DIR)/common/riscv_pkg.vhd \
          $(SRC_DIR)/common/config_pkg.vhd \
          $(TB_DIR)/include/tb_utils_pkg.vhd

# Collect all other sources and testbenches
SOURCES = $(shell find $(SRC_DIR) -name "*.vhd" $(foreach p,$(PKGS),-not -path $(p)))
TESTBS  = $(shell find $(TB_DIR) -name "*.vhd" -not -path "$(TB_DIR)/include/*")

.PHONY: hw hw-init hw-clean wave

hw: hw-init
	@echo "[GHDL] Analyzing Packages..."
	@$(GHDL) -a $(GHDL_FLAGS) $(PKGS)
	@echo "[GHDL] Analyzing Source Files..."
	@$(GHDL) -a $(GHDL_FLAGS) $(SOURCES)
	@echo "[GHDL] Analyzing Testbenches..."
	@$(GHDL) -a $(GHDL_FLAGS) $(TESTBS)
	@echo "[GHDL] Elaborating Entity: $(TB)..."
	@$(GHDL) -e $(GHDL_FLAGS) $(TB)
	@echo "[GHDL] Running Simulation..."
	@$(GHDL) -r $(GHDL_FLAGS) $(TB) --vcd=$(WAVE)

hw-init:
	@mkdir -p $(BUILD_DIR)

wave:
	@gtkwave $(WAVE) 2>/dev/null &

hw-clean:
	@echo "[CLEAN] Cleaning Hardware build artifacts..."
	@rm -rf $(BUILD_DIR)
