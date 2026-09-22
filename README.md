# Gain-Invariant Sample Entropy Profiling for Electrohysterography

Analysis code and manuscript results for an ICASSP 2027 submission proposing
**Gain-Invariant (GI) SampEn profiling**: an amplitude-robust variant of the
standard finite-resolution sample-entropy-profile representation, evaluated
on electrohysterography (EHG).

## The problem, briefly

The standard finite-resolution SampEn-profile implementation rounds each
pairwise Chebyshev distance to three decimals (0.001 signal units) before
forming the tolerance support. That rounding does not commute with a
multiplicative gain, so the profile's summaries -- Total SampEn especially --
are sensitive to constant amplitude scaling, even though sample entropy is
usually treated as scale-free. **GI-SampEn profiling** divides each window
by its own standard deviation before an otherwise unchanged profiling stage,
which removes that sensitivity by construction. A separate,
mechanism-isolating control shows that removing the rounding alone -- with no
standardisation at all -- is *also* exactly gain-invariant, which is the
strongest available evidence that quantization, not SampEn profiling itself,
is the mechanism. See `docs/methods.md` for the full account, and
`docs/provenance.md` for exactly which released implementation this
characterisation refers to and how it was verified.

This is a representation and statistical-association paper: it reports
associations between GI-SampEn features and fetal movement / uterine
contraction, on one public database (Icelandic 16-electrode EHG, channels
EHG9-EHG12). It makes no classifier or prospective-detection claim.

## Repository layout

```
gi-sampen-ehg/
├── configs/analysis.yaml     paths and constants (no machine-specific values)
├── src/gi_sampen/            the package: numerical core + analysis stages
├── scripts/                  thin CLI wrappers around gi_sampen, one per stage
├── data/README.md            where to obtain the two external inputs
├── results/
│   ├── tables/                manuscript tables, incl. Table 1 and the gate decision
│   ├── figures/                Figure 1 (pdf/png/svg) + its source CSVs
│   └── audits/                  compact markdown reports backing specific claims
├── tests/                     parity, invariance, and regression-fingerprint tests
├── docs/
│   ├── methods.md              the method, in plain language
│   ├── provenance.md            claim -> script -> input -> output; upstream attribution
│   ├── reproducibility.md        environment, commands, what each test needs
│   └── paper/                    facts pack and manuscript spine (working documents)
└── legacy/                    superseded scripts and pre-review drafts, kept not deleted
```

## Installation

```bash
python -m pip install -e '.[test,figures]'
```

Python >= 3.10. Dependencies are pinned to compatible-release ranges (numpy,
scipy, pandas, statsmodels, matplotlib, wfdb) because the numerics here are
sensitive to floating-point detail that is not guaranteed identical across
major library versions -- see `docs/reproducibility.md`.

## The two things this repository needs but does not contain

1. The public PhysioNet Icelandic 16-electrode EHG database (`EHG_RAW_DIR`).
2. The prior study's pipeline tree, which supplies the window manifest and
   the cached feature table used as this repository's parity target
   (`GI_SAMPEN_UPSTREAM_DIR`).

See `data/README.md`. Everything that does NOT need either -- the numerical
core, the gain-invariance tests, the mechanism-isolating control test, and
the committed manuscript tables and Figure 1 themselves -- runs with no setup
beyond installation:

```bash
pytest -m "not requires_data"
```

## Reproducing the principal experiments

```bash
export EHG_RAW_DIR=/path/to/physionet/ehgdb
export GI_SAMPEN_UPSTREAM_DIR=/path/to/prior-study/pipeline

python scripts/reproduce_paper.py           # everything, in dependency order
# or:  make reproduce
```

`scripts/reproduce_paper.py --dry-run` prints the ordered plan (script,
arguments, rough cost) without running anything.
`scripts/reproduce_paper.py --stage <name>` runs one stage;
`--from <name>` resumes a partial run. Total wall time is dominated by GI
feature extraction (~30-45 min) and the cross-channel replication (~2 hours
across EHG9-EHG12); every other stage is under 10 minutes. See
`docs/reproducibility.md` for the full ordered command list and what each
output corresponds to.

**Figure 1** = `results/figures/Figure1_support_mechanism.{pdf,png,svg}`.
**Table 1** (the four-channel cross-channel result) =
`results/tables/cross_channel_replication_summary.csv`.

## Upstream method implementation

The standard finite-resolution implementation this work characterises and
compares against derives from a chain of implementations, not a single
pinned commit -- see `docs/provenance.md` for the full account, including why
the released [`sampen-profile`](https://github.com/shivapratap/sampen-profile)
package (pinned here as a **test-only** verification dependency) postdates
this analysis and produced no manuscript number.

## Citation

See `CITATION.cff`. The accompanying paper is under review; the citation
entry there is provisional and carries no DOI. Do not cite it as published
until that changes.

## License

MIT for the code in this repository (`LICENSE`). The EHG database and the
upstream SampEn-profile implementations are the work of their respective
authors and are not relicensed by this repository -- see `docs/provenance.md`
and `data/README.md`.
