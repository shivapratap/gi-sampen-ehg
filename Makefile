# Convenience wrapper around scripts/reproduce_paper.py.
#
#   make reproduce          # everything, in dependency order
#   make parity              # just Step 0
#   make gate                # just the decision (needs upstream stages)
#   make test                # tests that need no external data
#   make test-data           # + the ones that need the raw database
#   make clean                # remove deterministic intermediates (work/), never results/

PYTHON ?= python

.PHONY: reproduce parity select-grid extract-gi gain-stress full-precision \
       resolution gain-resolution statistics gate cross-channel figure1 \
       test test-data clean install

reproduce:
	$(PYTHON) scripts/reproduce_paper.py

parity:
	$(PYTHON) scripts/reproduce_paper.py --stage parity

select-grid:
	$(PYTHON) scripts/reproduce_paper.py --stage select_grid

extract-gi:
	$(PYTHON) scripts/reproduce_paper.py --stage extract_gi

gain-stress:
	$(PYTHON) scripts/reproduce_paper.py --stage gain_stress

full-precision:
	$(PYTHON) scripts/reproduce_paper.py --stage full_precision

resolution:
	$(PYTHON) scripts/reproduce_paper.py --stage resolution_ablation

gain-resolution:
	$(PYTHON) scripts/reproduce_paper.py --stage gain_resolution

statistics:
	$(PYTHON) scripts/reproduce_paper.py --stage statistics

gate:
	$(PYTHON) scripts/reproduce_paper.py --stage gate

cross-channel:
	$(PYTHON) scripts/reproduce_paper.py --stage cross_channel

figure1:
	$(PYTHON) scripts/reproduce_paper.py --stage figure1

install:
	$(PYTHON) -m pip install -e '.[test,figures]'

# Fast, no external data. Runs in CI.
test:
	$(PYTHON) -m pytest tests/ -v -m "not requires_data"

# Full check, including the 200-window parity check against the cached
# upstream values. Needs EHG_RAW_DIR and GI_SAMPEN_UPSTREAM_DIR.
test-data:
	$(PYTHON) -m pytest tests/ -v

clean:
	rm -rf work/
	find . -name "__pycache__" -exec rm -rf {} +
	find . -name "*.pyc" -delete
