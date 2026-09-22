# Data

This repository does not redistribute the recordings it analyses. It
consumes two external inputs, neither of which is committed. Both are
configured in `configs/analysis.yaml` (or overridden by the environment
variables named below) and are resolved lazily -- importing the package
succeeds without either present.

## 1. The Icelandic 16-electrode Electrohysterogram Database

Public database, distributed by PhysioNet. This is the raw signal source.

- **Obtain it from:** https://physionet.org/content/ehgdb/
- **Expected layout:** the WFDB recordings, `ANNOTATORS`, `RECORDS`, and the
  database's own README, all directly under one directory (no subfolders).
- **Where this repository looks:** `EHG_RAW_DIR`, or `paths.raw_dir` in
  `configs/analysis.yaml` (default: a sibling `EHG-Complexity-Pipeline`
  checkout's `Paper1/paper1_reproducible_pipeline/data/raw/` -- almost
  certainly wrong on any machine other than the one this repository was
  reorganised on; set `EHG_RAW_DIR` or edit the config).
- **Checksums:** use the `SHA256SUMS.txt` (or equivalent) that PhysioNet
  distributes alongside the database; this repository does not mint its own.
- **Size:** on the order of a few gigabytes across ~490 files. Not
  committed, and excluded by `.gitignore` (`/data/raw/`, `*.dat`, `*.hea`,
  `*.atr`).

## 2. The prior study's pipeline tree

This repository analyses gain invariance in a representation defined by the
prior study (the IEEE Access manuscript's mixed-effects electrohysterography
analysis, produced from the same raw database). Rather than duplicating that
pipeline, this repository imports its preprocessing module directly and reads
several of its cached, already-computed tables.

- **Where this repository looks:** `GI_SAMPEN_UPSTREAM_DIR`, or
  `paths.upstream_dir` in `configs/analysis.yaml` (default: a sibling
  `EHG-Complexity-Pipeline/Paper1/paper1_reproducible_pipeline`).
- **What is read from it, specifically** (see `src/gi_sampen/paths.py`):
  - `src/preprocessing.py` -- imported by path, for the exact filter design,
    band edges and decimation factor used to reconstruct each window. Never
    written to.
  - `work/windows/window_manifest_60s.csv` -- the window manifest.
  - `work/features/window_features_60s_{channel}.csv` -- the cached standard
    finite-resolution feature table; the parity target for
    `tests/test_standard_parity.py`.
  - `work/primary/event_unit_analysis_60s_{channel}.csv` -- the 4,083
    analysis-unit selection, per channel.
  - `work/primary/mixed_model_results_60s_fwh_{channel}.csv` -- the standard
    (frozen) per-channel model results, used as a comparator column
    (`frozen_estimate`, `frozen_q_value`) in `results/tables/gate_summary.csv`
    and `results/tables/cross_channel_replication_summary.csv`.
- **Not obtained separately:** this tree is not a public dataset with its own
  citation; it is produced by running the prior study's own pipeline against
  the same raw database. If you do not have it, the stages that need it are
  gated behind `tests/test_standard_parity.py::test_parity_against_cached_manuscript_values`
  (`pytest.mark.requires_data`, skipped by default) and the corresponding
  `scripts/run_*.py` stages; everything else in this repository -- the GI
  invariance tests, the full-precision control, the committed manuscript
  results themselves -- does not need it.

## What lives where after a run

| Directory | Contents | Committed? |
|---|---|---|
| `data/raw/` | Raw PhysioNet recordings (or a symlink/mount to them) | No |
| `data/manifests/` | Lightweight derived manifests, if any | Yes |
| `work/` | Large deterministic intermediates (per-window feature tables) | No -- regenerate with `scripts/` |
| `results/tables/` | Manuscript tables and Figure/Table source CSVs | Yes |
| `results/figures/` | Final Figure 1 (pdf/png/svg) and its source CSVs | Yes |
| `results/audits/` | Compact markdown reports needed to verify a claim | Yes |

No machine-specific absolute path is committed anywhere in this repository;
`configs/analysis.yaml` holds only paths relative to the repository root, and
both external inputs above are configured through it or through the two
environment variables.
