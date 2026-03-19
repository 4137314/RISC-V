# LaTeX Documentation Workflow
# ---------------------------------------------------------
LATEX      = pdflatex
BIB        = biber
DOC_DIR    = doc
MAIN       = main
OUT_DIR    = $(DOC_DIR)/build

.PHONY: doc doc-init doc-clean

doc: doc-init
	@echo "[LATEX] Compiling document..."
	@cd $(DOC_DIR) && $(LATEX) -interaction=nonstopmode -output-directory=build $(MAIN).tex
	
	@echo "[LATEX] Checking for bibliography..."
	@if [ -f $(OUT_DIR)/$(MAIN).bcf ]; then \
		cd $(DOC_DIR) && $(BIB) build/$(MAIN) || true; \
		cd $(DOC_DIR) && $(LATEX) -interaction=nonstopmode -output-directory=build $(MAIN).tex; \
	fi
	# RIMOSSO: @cp $(OUT_DIR)/$(MAIN).pdf .
	@echo "[DOC] Success! PDF available at: $(OUT_DIR)/$(MAIN).pdf"

doc-init:
	@mkdir -p $(OUT_DIR)

doc-clean:
	@echo "[CLEAN] Cleaning Documentation build artifacts..."
	@rm -rf $(OUT_DIR)
	@rm -f $(MAIN).pdf
