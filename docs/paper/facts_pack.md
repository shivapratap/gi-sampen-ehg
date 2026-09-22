# Facts pack — gain-invariant SampEn profiling (ICASSP 2027 short paper)

**Purpose of this file.** Everything a writer needs to draft the paper without
touching the repository or the data again. Every number below has been
checked against the actual analysis output — do not paraphrase a number into
a different one, and do not introduce a new number that isn't here without
going back to the repo to verify it. Prose, structure, and wording are all
free to change; the numbers and the claims they support are not.

**Claim language is also not free to change.** §12 lists the exact phrasings
that must not appear. Those rules bind this document too: nothing in §1 or
§8 may be copied into the manuscript if it conflicts with §12.

Companion documents: `Paper1/.../README.md` (the Access manuscript this work
extends), `Paper2/README.md` (how every number below was produced), and
`GI_SampEn_ICASSP_Planning_Review.md` (the pre-drafting review this revision
responds to).

*Revised 21 Sep 2026: claim language in §1/§8 brought into line with §12; §3
mechanism description corrected; §5.6–§5.8 added; §12 added.*

---

## 1. The one-sentence story

A widely used signal-complexity summary (Total Sample Entropy) is, in the
reference implementation, dominated by recording amplitude rather than by
signal irregularity — we identify why, prove an exact correction, and show
that the correction changes both the direction and the statistical support
of a fetal-movement association in EHG, consistently across four channels of
the same cohort.

## 2. Background — what the prior (IEEE Access) paper established

- Public Icelandic 16-electrode EHG database (PhysioNet). 42 women, 112
  recordings. Median-axis channels EHG9–EHG12. FWH band 0.3–1.0 Hz. 60-second
  windows (event windows: −30 s to +30 s around the annotation timestamp).
- Primary EHG9 analysis, 34 FWH-band features, patient-aware mixed-effects
  models (woman + recording random effects), BH-FDR. 4,083 analysis windows:
  3,358 baseline (IN), 333 contraction (UC), 392 fetal movement (FM).
- UC-versus-IN: 11/34 features FDR-supported, dominated by amplitude/waveform
  measures (MAV, RMS, peak-to-peak, waveform length).
- FM-versus-IN (secondary, this is the contrast this new paper turns on):
  amplitude features were **null** (MAV q=0.710, RMS q=0.758, peak-to-peak
  q=0.803, waveform length q=0.710), while several SampEn-profile summaries
  *were* FDR-supported on EHG9: SD SampEn (β=−0.209, q=0.0002), Kurtosis
  SampEn (β=+0.184, q=0.0047), Skewness SampEn (β=+0.219, q=0.0004).
- Total SampEn was found to be strongly amplitude-coupled: scaling the same
  real waveform by 0.25×/0.5×/2×/4× changed it by −75.4% / −50.4% / +102.3% /
  +309.2% (median across 60 real windows: 20 UC, 20 FM, 20 IN). SD SampEn
  moved far less at the same scales: −6.1% / −2.2% / +3.4% / +7.5%. This
  audit is Table S16 in the Access manuscript.
- The Access paper's conclusion on Total SampEn: interpret it conservatively
  as an amplitude-coupled entropy-derived summary, not an amplitude-
  independent complexity marker. It does not attempt a fix. **This new paper
  is that fix.**

## 3. The problem, precisely

The frozen SampEn-profile implementation **quantizes each pairwise Chebyshev
distance to a fixed absolute resolution (three decimals, i.e. 0.001 signal
units) and then takes the distinct occupied quantized values as the tolerance
support.** The profile is evaluated at those occupied values — it is not a
sweep of every point of a regular 0.001 grid, and it must not be described as
one. The distinction matters: splitting and merging under gain are properties
of a many-to-one map applied to the distances, and on a fixed grid nothing
splits.

Under a multiplicative gain c > 0 every pairwise distance scales by exactly
c, but the quantizer does not commute with that scaling. Distances that
shared a quantized level at unit gain can separate, and distinct levels can
merge, so the profile is evaluated at a support that is not the scaled image
of the original one. Total SampEn — a raw sum over that support — is the most
exposed, because the support's cardinality grows roughly in proportion to the
signal's amplitude divided by the fixed resolution.

**Provenance of the rounding step.** The quantization is established from the
released reference implementation, not from the published formulation, which
contains no rounding. The relevant lines are `round(d,3)` / `round(d1,3)` in
`Sample entropy/CHM.m` of the authors' released code, at commit
`2a1d496c8bcf1e859ae9887d9911d168dd9a17dc` (2020-09-24) — the same commit
that introduced them. **Every manuscript sentence asserting the quantization
must cite the implementation alongside the parent paper, never the parent
paper alone.**

**The rounding is specific to the SampEn-profile implementation.** The same
repository's ApEn-profile code (`Approximate entropy/CHMforApEn.m`) takes
`unique()` over the *raw* distances with no rounding step. The quantizer is
therefore a deliberate, method-specific choice rather than an incidental slip
— this is the strongest available answer to the "it's just a bug" objection
and should be stated in one sentence in Section II.

The same documentation-versus-implementation divergence is reproduced in this
project's own Python port: `core/sampleEntropy_Gayathri.py`'s docstring
promises "unique sorted r-values derived from the data" while its code rounds
to three decimals. The divergence propagates silently to anyone
reimplementing the method from its description.

## 4. The method — Gain-Invariant SampEn (GI-SampEn)

**Construction.** Before computing any pairwise distance, divide the window
by its own standard deviation: `z = x / sd(x)`. Then run the *same* profiling
algorithm as the frozen implementation (embedding dimension m=2, Chebyshev
distance, 3-decimal rounding, KD-tree pair counting, ε=1e-12 numerical
stabilisation) on `z` instead of `x`. Everything downstream — Total, Average,
Median, SD, Kurtosis, Skewness SampEn — is computed identically, just on the
normalised signal.

**Exact invariance, proved.** For gain c > 0: `sd(cx) = c·sd(x)`, and every
Chebyshev distance under `cx` is exactly `c` times the corresponding distance
under `x`. Therefore `z = cx / sd(cx) = x / sd(x)`, unchanged. The whole
profile — and every summary computed from it — is analytically identical
under any positive gain, not merely empirically robust to it.

**The general statement, which is worth one sentence in the paper.** The
profile summaries are functionals of the ordered count sequence over the
tolerance support. That sequence survives *any strictly monotone*
transformation of the distance multiset — which is why the unrounded profile
is gain-equivariant (§5.5). Fixed-resolution quantization is many-to-one and
therefore not order-preserving, which is why the rounded profile is not. This
frames the finding as a property of the construction rather than of one
constant.

**A resolution caveat that had to be checked, and the experiment that
settles it.** Because EHG amplitude is of order 1e-2 in signal units,
normalising by sd also makes the 0.001-unit rounding grid far finer (on a
bench test, ~80 retained profile bins in raw units versus ~5,000 after
normalising — roughly a 60× change in resolution). The normalisation
therefore does two things at once: removes gain-dependence, *and* changes bin
count. **§5.3 and §5.7 separate these two effects and show the reported
results are driven by the invariance, not the resolution change.** Present
this in the manuscript as the separation experiment it is, not as a caveat —
it answers a serious reviewer objection.

**The mechanism itself, confirmed independently.** §5.5 adds a direct test of
the causal claim: an unrounded, purely data-derived tolerance axis (no
fixed-decimal rounding at all) was built and shown to be exactly
gain-equivariant. This is not the GI construction — it never divides by sd —
so it isolates the rounding step itself as the mechanism, independent of the
sd-normalisation fix.

## 5. Validation chain — in the order it was run

### 5.1 Parity
The gain-invariant code path was checked against Paper 1's frozen, cached
Stage-04 values (not merely re-derived): 200 windows, all six frozen
summaries (Total/Average/Median/SD/Kurtosis/Skewness SampEn), maximum
absolute deviation 3.6×10⁻¹⁵ (floating-point noise). Confirms the
reimplementation and window reconstruction are correct before anything new
is interpreted. **In the manuscript this is one clause, not a subsection.**

### 5.2 Exact invariance
The 60-window gain-stress design from Table S16 was reproduced, with GI
features added, at scales 0.25×, 0.5×, 2×, 4× (and two non-power-of-two
scales, 1.3× and 7.1×, as a harder test). **Every GI feature was invariant to
< 10⁻⁸ relative tolerance at every scale — 65/65 test rows passed, zero
failures.** (Frozen features, unchanged, still show the Table S16 pattern.)

### 5.3 Resolution ablation — separating invariance from bin count
Six-point ladder, EHG9, FM-versus-IN contrast, same mixed-model
specification throughout: frozen (not gain-invariant) at ~80 / ~800 / ~7,000
bins, and GI (gain-invariant) at ~60 / ~600 / ~5,000 bins.

| Feature | frozen ~80 bins | frozen ~800 | frozen ~7,000 | GI ~60 bins | GI ~600 | GI ~5,000 |
|---|---:|---:|---:|---:|---:|---:|
| SD | −0.209 (q=1.9e-4) | −0.186 (q=2.7e-4) | −0.213 (q=1.7e-5) | −0.239 (q=7.5e-6) | −0.271 (q=5.2e-7) | −0.246 (q=2.1e-6) |
| Total | +0.078 (q=0.459) | +0.098 (q=0.088) | +0.154 (q=0.0035) | −0.197 (q=3.6e-5) | −0.211 (q=1.4e-5) | −0.200 (q=1.5e-5) |
| Kurtosis | +0.184 (q=0.0047) | +0.192 (q=0.0011) | +0.120 (q=0.0385) | +0.202 (q=0.0004) | −0.078 (q=0.156) | +0.078 (q=0.195) |
| Skewness | +0.219 (q=4.5e-4) | +0.215 (q=2.0e-4) | +0.103 (q=0.080) | +0.211 (q=2.0e-4) | −0.029 (q=0.605) | +0.114 (q=0.048) |

**Verdict, per feature:**
- **SD** — significant, same sign, at *every* resolution, GI or not. Robust,
  but note it doesn't uniquely demonstrate the value of gain-invariance,
  since it was already fairly amplitude-robust in the frozen form (small
  moves in Table S16).
- **Total** — the central result. GI-Total is significant and **negative**
  at all three GI resolutions (essentially unchanged, −0.20 to −0.21, across
  a ~80× bin-count range). Frozen Total is unstable and only reaches
  significance at the finest resolution, where it is **positive** — the
  opposite sign. This pattern (stable and one sign under invariance;
  unstable and the other sign without it) is the evidence that the negative
  GI-Total effect is real and the positive frozen trend is a scale/
  resolution artefact, not the reverse.
  **Claim-scope note:** at the finest frozen resolution the frozen estimate
  is itself FDR-supported (+0.154, q=0.0035) with the opposite sign to GI.
  See §12 for how this must and must not be described.
- **Kurtosis** — flips sign and loses significance as GI resolution
  increases (significant only at the coarsest GI setting). Not trustworthy.
  **Dropped from the paper.**
- **Skewness** — same pattern: unstable across GI resolutions, sign flip at
  medium resolution, only marginal (q≈0.048) at the resolution used
  elsewhere. **Dropped from the paper.**

### 5.4 Cross-channel replication (EHG9–EHG12)
Only SD and Total were carried forward (5.3 eliminated Kurtosis and
Skewness). Each replication channel (EHG10–12) got its own 30-window
invariance spot-check before being trusted (all passed). EHG9's frozen
counterparts are already independently fit in Paper 1's own per-channel
models (not only its aggregate UC/IN comparison), so no recomputation of the
frozen reference was needed.

**BH-FDR family for this table (state this in the manuscript).** All 16 tests
(4 channels × 2 features × 2 contrasts) are corrected together as **one
family**. EHG9's raw p-values are refit and re-corrected inside this family;
the EHG9 q-value from the 13-feature GI family in `gate_summary.csv` is *not*
reused. The same estimate therefore carries a different q-value in
`results/gate_summary.csv` (GI-family correction, §5.6) than in
`results/cross_channel_replication_summary.csv` (16-test correction, below).
Both are correct; the manuscript must say which family each quoted q-value
belongs to.

**FM-versus-IN, all four channels — this table is the paper's headline result
(16-test cross-channel family):**

| Channel | GI-SD | GI-SD q | frozen-SD | frozen-SD q | GI-Total | GI-Total q | frozen-Total | frozen-Total q |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| EHG9  | −0.246 | 1.9×10⁻⁷ | −0.209 | 1.9×10⁻⁴ | −0.200 | 7.2×10⁻⁶ | +0.078 | 0.459 |
| EHG10 | −0.345 | 1.6×10⁻¹² | −0.293 | 1.1×10⁻⁸ | −0.274 | 1.2×10⁻⁹ | +0.019 | 0.962 |
| EHG11 | −0.332 | 3.6×10⁻¹¹ | −0.309 | 5.3×10⁻⁹ | −0.294 | 4.0×10⁻¹⁰ | +0.074 | 0.487 |
| EHG12 | −0.279 | 2.5×10⁻⁸ | −0.263 | 2.0×10⁻⁶ | −0.254 | 4.8×10⁻⁸ | +0.067 | 0.554 |

n=4,083 windows (3,358 IN / 333 UC / 392 FM), n=42 women, n=112 recordings,
identical on every channel (same physical windows, different electrode).

**Read this table as:** GI-SD is consistent across all four channels (same
sign, FDR-supported, 4/4). GI-Total is consistent across all four channels
and carries the opposite sign to its frozen counterpart on every one (4/4);
the frozen version is a statistical null (q≥0.459) on every channel, while
the GI version is FDR-supported by 6–10 orders of magnitude on every channel,
always negative. **This is cross-channel consistency within one cohort, not
independent replication — see §12.**

### 5.5 Full-precision, no-rounding control — the mechanism-isolating experiment

An unrounded, purely data-derived tolerance axis (no fixed-decimal rounding
at any step, and **no sd-normalisation**) was built for a 12-window subset of
the 60-window gain-stress set and evaluated at all six gains.

**Result: exactly gain-equivariant — 0.000e+00 deviation for fp_total,
fp_average and fp_sd at every tested gain (0.25×–7.1×), all within
atol=1e-08, rtol=1e-06.** Full report:
`results/full_precision_gain_test_report.md`.

This isolates fixed-decimal distance quantization, rather than SampEn
profiling itself, as the mechanism responsible for the gain dependence.
**It is the single strongest answer to the "this is just a bug in one
implementation" objection, and it belongs in the abstract and early in the
results — not fifth in a list.**

*Sample-size note:* this control ran on 12 windows while every other gain
test used 60. The script supports `--n-per-class 20` (→ 60 windows) and its
own cost note calls the O(N²) step cheap; run `--probe` first. If it is
extended, update this paragraph and drop the subset qualification in §12
claim 11. Until then, the claim must be bounded to the tested subset.

### 5.6 Two anticipated reviewer objections, tested directly

Both were raised as likely reviewer pushback before submission and were
checked empirically rather than argued away.

**Objection 1 — "AvgSampEn already divides by bin count, so why is GI
normalisation needed?"** Tested on the same 60-window gain-stress set, same
six gains (0.25×, 0.5×, 1.3×, 2×, 4×, 7.1×):

| Feature | mode | 0.25× | 0.5× | 1.3× | 2× | 4× | 7.1× | invariant (0–60) |
|---|---|---:|---:|---:|---:|---:|---:|---:|
| Total   | frozen | −75.4% | −50.4% | +30.7% | +102.3% | +309.2% | +630.6% | 0/60 every gain |
| Average | frozen | −5.6% | −1.7% | +0.9% | +2.1% | +4.6% | +7.0% | 0/60 every gain |
| SD      | frozen | −6.1% | −2.2% | +1.5% | +3.4% | +7.5% | +11.7% | 0/60 every gain |
| Total / Average / SD | GI | 0.0% | 0.0% | 0.0% | 0.0% | 0.0% | 0.0% | 60/60 every gain |

(median relative deviation from the 1× baseline, 60 windows; maximum absolute
relative deviation reaches a +16.9%/−7.0% envelope for Average and up to
+47.8% for SD, versus up to +673% for Total — see
`results/avg_sampen_gain_summary.csv`.)

Dividing Total by the retained bin count (the textbook AvgSampEn definition)
removes most, but not all, of the gain sensitivity — Average SampEn is
roughly one order of magnitude less gain-sensitive than Total, but it is
**not invariant**: 0/60 windows pass the numerical-invariance test at any
tested gain, and the deviation reaches ~7–17% at moderate gains and is
larger at the extremes. Only the GI construction reaches exact invariance
(0.000% at every gain, 60/60 pass). Per the pre-registered decision rule for
this check, frozen AvgSampEn is clearly gain-sensitive, so the conditional
full mixed-model/resolution extension for AvgSampEn was **not run** — this
gain-stress control is the sufficient answer to this objection.

**Objection 2 — "The problem is just that three-decimal rounding is too
coarse; use finer rounding instead."** Tested by rerunning the same
gain-stress design at the resolution-ablation's own decimals settings
(frozen at ~80/~800/~7,000 bins; GI at ~60/~600/~5,000 bins,
`decimals` = 3/4/5 and 1/2/3 respectively):

| resolution | mode | approx. bins | worst median rel.diff | worst max rel.diff | pass rate |
|---|---|---:|---:|---:|---:|
| frozen_d3 | frozen | 84 | 630.6% | 673.2% | 0/60 |
| frozen_d4 | frozen | 793 | 604.1% | 629.0% | 0/60 |
| frozen_d5 | frozen | 6,902 | 604.3% | 610.7% | 0/60 |
| gi_d1 | GI | 60 | 0.0% | 0.0% | 60/60 |
| gi_d2 | GI | 588 | 0.0% | 0.0% | 60/60 |
| gi_d3 | GI | 5,258 | 0.0% | 0.0% | 60/60 |

Going from ~80 to ~6,900 bins (an ~82× finer absolute grid) leaves the
frozen construction's worst-case gain sensitivity essentially unchanged for
Total SampEn (673% → 611%), and the per-feature breakdown is **not
monotonic**: Average SampEn's worst deviation is 31.6% at the coarsest
resolution, drops to 22.9% at the middle resolution, then *rises* to 65.4%
at the finest; SD SampEn similarly dips at the middle resolution (47.8% →
17.0%) before rising again (30.1%). Finer absolute rounding does not
reliably reduce gain sensitivity, and sometimes makes it worse. GI profiling
stays exactly invariant (0.000%, 60/60 pass) at all three tested
resolutions, independent of bin count. Full detail:
`results/gain_resolution_sensitivity_report.md`.

**Do not describe the frozen trend across resolution as an improvement.** It
is flat for Total and non-monotonic for Average and SD. Report it as observed.

**Conclusion for both objections:** the fix has to be sd-normalisation
before quantisation, not bin-count division after it and not a finer fixed
grid. This is now an empirically closed question, not only an argued one.

### 5.7 Fixed dimensionless grid — the cross-window-comparable variant

Two residual worries about the GI construction were addressed by a third
variant with an explicitly chosen, dimensionless tolerance grid:

1. sd-normalisation refines the profile ~60× as well as making it invariant
   (§4) — is the refinement doing the work?
2. the GI rounded profile still runs out to each window's own maximum
   distance, so its support varies between windows even though it is
   invariant to gain within one.

**Grid definition** (`results/grid_definition.json`): candidate tolerances
τ ∈ [0.01, 4.00] sd in steps of 0.01; a tolerance counts as covered if the
sd-normalised profile yields a finite retained value there; the selected
range is the longest contiguous run covered in ≥95% of a fixed random sample
of 300 baseline (IN) windows (seed 20260920); the analysis grid is 200
equally spaced points on that range. **Chosen from baseline windows only,
before any UC or FM feature was computed, and written with a UTC timestamp
and a SHA-256 hash of the baseline window IDs.** That pre-registration is
worth one sentence in the manuscript.

**Result — the fixed grid reproduces the rounded GI result** (EHG9,
FM-vs-IN, GI-family FDR):

| feature | estimate | q |
|---|---:|---:|
| gigrid_auc | −0.2004 | 1.53×10⁻⁵ |
| gi_total (rounded GI) | −0.2003 | 1.53×10⁻⁵ |
| gigrid_sd | −0.2246 | 3.35×10⁻⁶ |
| gigrid_slope | +0.2187 | 4.19×10⁻⁶ |
| gigrid_centroid | +0.1761 | 1.55×10⁻³ |
| gigrid_kurtosis | −0.0127 | 0.816 |
| gigrid_skewness | +0.0322 | 0.607 |

Agreement between the two GI variants: **r = 0.999 (r² = 0.998)** across
4,083 windows (`results/amplitude_collinearity.csv`, cross-feature block).

**Both worries are therefore excluded empirically, not argued away.** The
~60× refinement is not producing the result, and neither is the
window-varying support. This is the answer to "you replaced the feature
rather than correcting it."

`gigrid_kurtosis` and `gigrid_skewness` are firmly null, which independently
corroborates the §5.3 decision to drop those two summaries.

### 5.8 Amplitude collinearity — what frozen Total is actually measuring

Pearson correlations across all 4,083 EHG9 FWH 60-s windows, against
time-domain mean absolute value (`results/amplitude_collinearity.csv`,
`results/amplitude_collinearity_report.md`):

| summary | r vs MAV | r² |
|---|---:|---:|
| **frozen Total** | **+0.984** | **0.968** |
| frozen Average | −0.048 | 0.002 |
| frozen SD | −0.086 | 0.007 |
| frozen fixed-r SampEn | −0.118 | 0.014 |
| GI Total | −0.102 | 0.010 |
| GI SD | −0.115 | 0.013 |
| GIgrid AUC | −0.100 | 0.010 |
| GI retained bin count | +0.053 | 0.003 |

Cross-feature: **GI Total vs frozen Total r = −0.053 (r² = 0.003)**.

**Reading.** Frozen Total SampEn shares 96.8% of its variance with a plain
amplitude statistic; in this implementation it is not interpretable as an
irregularity summary. No other summary — frozen or GI — shows this
collinearity, and after sd-normalisation the retained bin count decouples
from amplitude (r = 0.053), which is the mechanism in §3 confirmed directly.
GI Total is close to orthogonal to the frozen Total it replaces.

This is the strongest single quantitative statement available to the paper
and the best candidate for a mechanism figure panel. It is also the most
efficient answer to "this is just z-scoring": an r² near unity between a
published complexity summary and mean absolute value is not a triviality.

### 5.9 Comparator already run: fixed-r SampEn on the normalised signal

`gi_fixed_r_sampen` is conventional SampEn at a single SD-scaled tolerance,
computed on the same windows. Because a single tolerance proportional to SD
is already gain-invariant, its GI and frozen values are identical.

FM-vs-IN, EHG9, GI-family FDR: **−0.2376 (q = 4.19×10⁻⁶)**; frozen
counterpart −0.2376 (q = 4.38×10⁻⁵).

**This is larger than any profile summary** (GI-Total −0.2003, GIgrid AUC
−0.2004). **Report it in the manuscript rather than leaving it in the
repository.** A reviewer who finds it unreported will ask why the profile is
needed at all; a paper that volunteers it reads as rigorous. The two answers
are (a) the profile carries shape information no single tolerance has —
`gigrid_slope` +0.2187 (q=4.19×10⁻⁶) and `gigrid_centroid` +0.1761
(q=1.55×10⁻³) are FDR-supported and have no single-r analogue — and (b) the
paper's object is the correctness of the representation the Access paper
already used, not the maximisation of effect size.

### 5.10 Contraction contrast — where the frozen result is itself FDR-supported

Not part of the headline FM story, recorded here because it is the cleanest
confirmation of §5.8 and because §12's claim rules depend on it.

UC-vs-IN, EHG9, GI-family FDR (`results/gate_summary.csv`):

| feature | GI estimate | GI q | frozen estimate | frozen q |
|---|---:|---:|---:|---:|
| Total | −0.1131 | 0.0373 | **+0.4092** | **5.02×10⁻¹¹** |
| SD | −0.1398 | 0.0258 | −0.0412 | 0.506 |
| GIgrid AUC | −0.1035 | 0.0373 | — | — |
| fixed-r SampEn | −0.1154 | 0.0373 | −0.1154 | 0.0558 |

Contractions are high-amplitude events, and frozen Total is collinear with
amplitude (§5.8) — so a very strong positive frozen association is exactly
what the mechanism predicts, and the corrected feature carries the opposite
sign with FDR support.

**Unlike the FM contrast, this *is* a sign change of an FDR-supported
association**, and §12 permits it to be described as such. Whether it earns
space in four pages is a separate editorial decision; if it is included, it
is the strongest single demonstration that the numerical choice determines
the inference.

## 6. What did NOT survive — report this honestly

Kurtosis SampEn and Skewness SampEn were part of the original FM signature
(Access paper) and were initial candidates for this paper. They failed the
resolution ablation (§5.3): significant only at the coarsest bin count,
flipping sign or losing significance as resolution increased. Independently,
both are null on the fixed grid (§5.7). They were **not** carried into
cross-channel replication. State this plainly in the paper — it is a
legitimate negative finding, not something to bury, and it pre-empts the
obvious reviewer question ("what about the other two FM features from your
own Access paper?").

Note for accuracy: gain correction moves both toward the null (frozen
kurtosis +0.184 q=0.0047 → gigrid_kurtosis −0.013 q=0.816; frozen skewness
+0.219 q=0.00045 → gigrid_skewness +0.032 q=0.607). So the honest summary is
that two of the three frozen FM profile-shape findings do not survive
correction — see §12 claim 14 for permitted wording.

## 7. Paper structure

**Superseded — use the recommended spine in
`GI_SampEn_ICASSP_Manuscript_Spine.md` (revised 21 Sep 2026).** The earlier
structure sketch in this section proposed stating the resolution result "as
one paragraph, cite the repo" and did not give the full-precision control
(§5.5) its weight; both have changed. The spine is now the structural source
of truth, and this file is the numerical source of truth.

## 8. Draft abstract (a starting point, not final wording)

Compliant with §12. Replaces the earlier draft, which used "reverses the
original finding" and "replicates across four electrodes" — both forbidden.

> Sample entropy profiling replaces a single tolerance with a profile
> evaluated over a support derived from the data's own pairwise distances.
> We show that this support is scale-equivariant only when the distances are
> retained at full precision: quantized at a fixed absolute resolution, as in
> the released reference implementation, positive gain splits and merges the
> occupied levels non-uniformly, so the profile is evaluated at
> non-corresponding tolerances and summaries such as Total SampEn inherit a
> dependence on gain that the formulation they implement does not have. We
> isolate the mechanism by removing the quantization alone — an unrounded
> profile, with no normalisation applied, is exactly gain-equivariant — and
> show that neither bin-count normalisation (AvgSampEn) nor an ~82× finer
> absolute grid repairs it. Standardising each window before an otherwise
> unchanged profiling stage restores exact invariance, verified to 10⁻⁸ at
> six gain factors while reproducing reference values to 3.6×10⁻¹⁵. On
> 4,083 windows from four electrohysterography channels in 42 women, the
> corrected Total SampEn shows a negative, FDR-supported fetal-movement
> association consistent across all four channels, whereas its uncorrected
> counterpart is statistically null on every channel.

## 9. Figure and table specs

**Table 1** (the primary table): §5.4's four-channel table, GI vs frozen, SD
and Total, estimate + q-value, with the FDR family named in the caption.

**Figure 1** (two panels — resolves the earlier conflict between this file
and the spine):

- **(a) Mechanism, empirically.** Scatter of frozen Total SampEn against
  time-domain mean absolute value (r = +0.984) beside GI-Total against the
  same (r = −0.102), shared axes. Numbers from §5.8. *Fallback if this panel
  is cut:* a schematic showing distances collapsing and separating under gain
  — not a generic pipeline diagram, which communicates nothing a sentence
  cannot.
- **(b) Consequence.** Grouped bar chart: x-axis = channel (EHG9–12), y-axis
  = standardised effect estimate, frozen vs GI, faceted or colour-coded by
  feature (SD, Total), zero line drawn. The visual point is Total's frozen
  bars crossing zero while GI-Total's stay consistently negative.

**Table 2, only if space remains:** two rows of the resolution ladder
(coarsest and finest, frozen and GI) plus the AvgSampEn row — the compressed
form of §5.6. If it does not fit, the numbers go in the text. Do not cut them
to the repository.

Do not spend a figure on the resolution ladder; it is a three-number argument
that prose carries.

## 10. Things still open, not yet done

- **RangeEn empirical comparison** — not run. Cite as related work, name as
  future work. Do not claim a direct empirical comparison exists.
- **Mischi et al. (2018) full text** — not read; only the abstract was
  available. The Related Work sentence distinguishing their tolerance-metric
  modification from this work is **provisional** until the full text is
  checked. If their modification turns out to be a per-window amplitude
  standardisation, that sentence must change.
- **Keenan et al. (2022) methods section** — not read. That paper applies
  entropy profiling with TotalSampEn to fetal ECG and shares authors with the
  profiling lineage. If it normalises its input before profiling, it is prior
  art for the *operation* (not for the diagnosis), and Introduction paragraph
  3 must acknowledge it. Highest-value remaining literature check.
- **Full-precision control at 60 windows** — currently 12 (§5.5).
- **Archiving the reference implementation** — the cited commit is from 2020
  and the repository is currently stable, but an archived snapshot (e.g.
  Zenodo DOI) would make the paper's central factual claim permanently
  verifiable. Recommended before submission.
- **Only EHG9–EHG12 of one public database** — no external cohort. State as
  a limitation.
- **No classifier / prospective claim** — this is a representation and
  statistical-association paper, same scope discipline as the Access paper.
  Do not let a draft drift into implying detection performance.

## 11. Reproducibility statement (for the paper's own text, if space allows)

All code and validation artefacts (parity check, invariance check, resolution
ablation, AvgSampEn and full-precision controls, fixed-grid variant,
amplitude collinearity audit, cross-channel replication) are in the
accompanying repository, `EHG-Complexity-Pipeline/Paper2/`. See that repo's
README for the exact scripts and result files behind every number in this
pack.

## 12. Claim boundaries — binding on this document and the manuscript

### Never write

- "SampEn is gain-sensitive" (unqualified) — conventional SampEn with
  r ∝ SD is not.
- "Entropy profiling is gain-sensitive" (unqualified) — §5.5 shows the
  unrounded representation is gain-equivariant.
- "We introduce the first gain-invariant SampEn" / "we introduce
  gain-invariant SampEn" — scale handling, COSEn and RangeEn all predate this.
- "GI-SampEn removes amplitude effects" / "is amplitude-independent."
- "GI-Total is superior to RangeEn" — no comparison was run.
- "The four EHG channels **independently replicate** the result" / "replicates
  across four electrodes."
- "GI-Total reveals the true physiological effect."

### Permitted wording

- "finite-resolution SampEn profiling"; "fixed absolute distance
  quantization"; "positive multiplicative gain"; "gain-invariant SampEn
  profiling"; "cross-channel consistency" / "spatial consistency within the
  same cohort"; "the profiling representation is gain-equivariant in the
  absence of fixed absolute quantization."
- Claim 11 (the unrounded profile is gain-equivariant) must be bounded to the
  tested subset until §5.5 is extended: "on the tested 12-window subset, at
  every tested gain, to within the predefined numerical tolerance."
- Claim 13: "the association cannot be attributed to constant multiplicative
  gain differences between windows; other amplitude-related confounds are not
  excluded by this argument."

### The reversal rule — scoped, not blanket

The earlier blanket ban on "the original significant finding was reversed"
was over-broad and would cause the writer to understate a real result. The
correct rule is:

- **FM-vs-IN Total, at the reference resolution** — frozen is statistically
  null on all four channels. Write: *"Gain correction reverses the direction
  of the Total SampEn point estimate and reveals a stable FDR-supported
  negative FM-versus-IN association across all four channels, whereas frozen
  Total remains statistically null."* Never "reverses the original finding"
  or "overturns a significant finding."
- **Where a frozen result is itself FDR-supported, describe it accurately.**
  Two such cases exist: the UC-vs-IN Total contrast (§5.10, frozen +0.409,
  q=5.02×10⁻¹¹ → GI −0.113, q=0.037) and frozen Total at the finest
  resolution in §5.3 (+0.154, q=0.0035). In those cases a sign change of an
  FDR-supported association may be stated as such.
- **Kurtosis and skewness** (§6) — both frozen results were FDR-supported and
  both are null after correction. Permitted: *"two of the three frozen FM
  profile-shape associations do not survive gain correction."*

### Terminology

Use **"Gain-Invariant SampEn Profiling"**, never "Gain-Invariant SampEn". The
shorter form reads as a claim to the first gain-invariant SampEn formulation
and is refuted by a single citation. Include the scope sentence once, in the
abstract or the contribution list: *"we do not claim priority for
amplitude-robust entropy estimation, which is well established."*

## 13. Numerical source of truth

All manuscript numbers must come from this file. Do not interpolate,
estimate, recompute from memory, or copy numbers from earlier drafts if they
differ from this pack. If a manuscript sentence requires a number that is not
present here, flag it rather than inventing or estimating it.

Every number in this pack traces to a file under `Paper2/results/`:
`parity_check.csv`, `invariance_summary.csv`, `resolution_ablation_summary.csv`,
`cross_channel_replication_summary.csv`, `gate_summary.csv`,
`avg_sampen_gain_summary.csv`, `gain_resolution_sensitivity_report.md`,
`full_precision_gain_test_report.md`, `grid_definition.json`,
`amplitude_collinearity.csv`.
