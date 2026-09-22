# Reproducibility

## Environment

```bash
python -m pip install -e '.[test,figures]'
```

Dependencies are pinned to compatible-release ranges in `pyproject.toml`
(numpy, scipy, pandas, statsmodels, matplotlib, wfdb), because sample entropy
profiling depends on floating-point detail in pairwise distance computation
and neighbour counting (`scipy.spatial.cKDTree`) that is not guaranteed
identical across major versions. `sampen-profile`, pinned to an exact commit,
is a **test-only** dependency -- see `docs/provenance.md` section 1 for why it
is not a runtime dependency.

## Two things this repository needs that it does not contain

1. The PhysioNet raw recordings (`EHG_RAW_DIR`).
2. The prior study's pipeline tree (`GI_SAMPEN_UPSTREAM_DIR`), which supplies
   the window manifest, the cached parity-target feature table, and the
   standard per-channel model results.

See `data/README.md` for exactly what is expected in each, and
`configs/analysis.yaml` for how to point at them (both default to a sibling
`EHG-Complexity-Pipeline` checkout, which is almost certainly wrong on a
machine other than the one this repository was produced on).

Everything else -- the numerical core, the GI-invariance tests, the
full-precision-control test, the committed manuscript tables and Figure 1
themselves, and the fingerprint check that they have not silently changed --
needs neither, and runs anywhere.

## Running the tests

```bash
# Fast, no external data. This is what CI runs.
pytest -m "not requires_data"

# Everything, including the 200-window parity check against the cached
# upstream values (needs both external inputs above).
pytest
```

What each file checks:

| File | Needs external data? | Checks |
|---|---|---|
| `tests/test_standard_parity.py` | Partial -- one test needs both external inputs | `frozen_summaries` against the released `sampen-profile` package (synthetic data, always runs) AND against the prior study's cached values on 200 real windows (`requires_data`) |
| `tests/test_gain_invariance.py` | No | GI summaries invariant at gains 0.25, 0.5, 1.3, 2, 4, 7.1 (< 1e-8 relative), on synthetic windows. Also asserts the *standard* implementation is NOT invariant, as a sanity check on the paper's own premise. |
| `tests/test_unrounded_equivariance.py` | No | The full-precision control is exactly gain-invariant with no rounding and no standardisation at all -- reproducing `results/audits/full_precision_gain_test_report.md`'s own numbers (0.000e+00 deviation) |
| `tests/test_reproducibility.py` | No | sha256 + row/column fingerprints of every tracked `results/` file, plus a numeric spot-check of Table 1's primary estimate and the gate decision |

## Minimum commands to reproduce the principal experiments

Run from the repository root, after installing (see above) and setting the
two paths:

```bash
export EHG_RAW_DIR=/path/to/physionet/ehgdb
export GI_SAMPEN_UPSTREAM_DIR=/path/to/EHG-Complexity-Pipeline/Paper1/paper1_reproducible_pipeline

python scripts/reproduce_paper.py            # everything, in order
# or:
make reproduce
```

`scripts/reproduce_paper.py --dry-run` prints the full ordered plan --
script, arguments, and rough cost -- without running anything.
`--stage <name>` runs exactly one stage; `--from <name>` resumes from a
stage onward. Total wall time is dominated by two stages: GI feature
extraction (~30-45 min) and the cross-channel replication (~2 hours,
EHG9-EHG12); every other stage is under 10 minutes. Run
`scripts/run_extract_gi.py --probe 100` first if you want a timing estimate
before committing to the full run.

If a single command is not sensible on your setup (partial data, no need to
regenerate Table 1), run the ordered commands directly instead:

```bash
python scripts/run_parity_check.py                    # Step 0 -- must pass first
python scripts/run_select_grid.py                      # Stage A1
python scripts/run_extract_gi.py                        # Stage A2
python scripts/run_gain_stress.py --extra-scales        # Stage B
python scripts/report_avg_sampen_gain.py
python scripts/run_full_precision_control.py
python scripts/run_resolution_ablation.py
python scripts/report_resolution_ablation.py
python scripts/run_gain_resolution.py
python scripts/report_gain_resolution.py
python scripts/run_statistics.py                        # Stage C -- needs statsmodels
python scripts/run_gate_report.py                       # Stage D -- the decision
python scripts/run_cross_channel_analysis.py             # ~2 hours
python scripts/report_cross_channel.py                   # writes Table 1
python scripts/run_amplitude_collinearity.py
python scripts/make_figure1.py                            # writes Figure 1
```

Run each stage to completion before the next; several read the previous
stage's `work/` output.

## What "reproduce" means for each output

- **Figure 1** = `results/figures/Figure1_support_mechanism.{pdf,png,svg}`,
  from `scripts/make_figure1.py`.
- **Table 1** (or its source CSV) =
  `results/tables/cross_channel_replication_summary.csv`, from
  `scripts/report_cross_channel.py`.
- The go/no-go decision = `results/tables/gate_summary.csv`, from
  `scripts/run_gate_report.py`.

See `docs/provenance.md` section 3 for the full claim -> script -> input ->
output mapping, covering all twelve reproducibles named in the reorganisation
brief.

## Validating this reorganisation specifically

This repository was produced by migrating a working-folder version of this
analysis (`Paper2/` in the `EHG-Complexity-Pipeline` monorepo) into a
standalone, packaged layout. The migration:

- renamed modules and rewrote intra-package imports (e.g. `_common` ->
  `gi_sampen.paths`) but did not change any numerical code inside a function
  body;
- replaced hard-coded relative paths (`../../Paper1/...`) with
  `configs/analysis.yaml` + environment-variable overrides, resolved lazily
  so importing the package does not require either external input to be
  present;
- did not re-run any analysis. Every file under `results/` is the file
  produced before the migration, copied byte-for-byte.

Two checks specifically validate this:

1. `tests/test_reproducibility.py` sha256-fingerprints every tracked
   `results/` file against `tests/fixtures/results_fingerprint.json`, taken
   immediately after the migration and before any further edit.
2. `tests/test_standard_parity.py::test_parity_against_cached_manuscript_values`
   re-derives the 200-window parity check from the raw recordings through the
   migrated code path, and will fail if the migration silently altered window
   reconstruction, path resolution, or the profile computation itself.
