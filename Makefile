# =========================================================
# RISC-V RV32I(M) Core Project
# Main Orchestrator
# =========================================================

.PHONY: all hw doc clean help

all: hw doc

# Include sub-modules
include hw/hw.mk
include doc/doc.mk

help:
	@echo "Usage:"
	@echo "  make hw [TB=testbench_name]  - Compile and simulate hardware"
	@echo "  make wave [TB=testbench_name]- Open GTKWave for the specified TB"
	@echo "  make doc                     - Compile LaTeX documentation"
	@echo "  make clean                   - Remove all generated build artifacts"

clean: hw-clean doc-clean
	@echo "[CLEAN] Root directory cleaned."
