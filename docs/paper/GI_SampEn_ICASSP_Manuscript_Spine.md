# GI-SampEn ICASSP 2027 Manuscript Spine

*Revised 21 Sep 2026 in response to `GI_SampEn_ICASSP_Planning_Review.md`.
Changes: Section II renamed; Section IV-A reordered so the mechanism is
isolated second rather than fifth; Section III compressed; page allocation
shifted toward Results; figure strategy reconciled with the facts pack; the
"no reversal" claim boundary scoped rather than blanket.*

## Purpose

This document defines the planned structure of the ICASSP 2027 paper on
**Gain-Invariant Sample Entropy Profiling for Electrohysterography (EHG)**.

The paper should be written as a compact signal-processing methods paper, not
as a journal-style biomedical manuscript. The central story is:

1. identify a finite-resolution failure mode in the released SampEn-profile
   implementation;
2. isolate fixed absolute distance quantization as its cause;
3. show that the two obvious cheaper fixes do not work;
4. introduce the GI construction as the exact correction;
5. show that the correction materially changes the downstream EHG association.

This document is the **structural** source of truth.
`facts_pack.md` is the **numerical and claim-language** source of truth. Where
they disagree, the facts pack governs numbers and permitted wording; this
document governs structure and emphasis.

The target is ICASSP 2027: four pages of technical content plus an optional
references-only fifth page.

---

# Front Matter

## Title

Foreground the signal-processing problem; avoid implying that we invented the
first gain-invariant form of conventional SampEn.

Preferred:

- **Gain-Invariant Sample Entropy Profiling for Electrohysterography**

Avoid:

- "Gain-Invariant Sample Entropy" (without "Profiling") — reads as a claim to
  the first gain-invariant SampEn formulation, refuted by a single citation.
- "First Gain-Invariant Sample Entropy."
- wording implying conventional SampEn itself is inherently gain-sensitive.

## Abstract

**Sequence — note that the correction now arrives as the survivor of an
elimination, not as the opening proposal.** This ordering is the structural
answer to the "this is just z-scoring" objection and should not be inverted
for space.

1. SampEn profiling and its data-derived tolerance representation.
2. The hidden finite-resolution problem: pairwise distances are quantized at
   a fixed absolute resolution before the tolerance support is formed, so the
   support is not the scaled image of itself under gain.
3. **Mechanism isolated:** an unrounded profile — with no normalisation
   applied — is exactly gain-equivariant. The quantization, not the profiling
   concept, is the cause.
4. **Neither cheap fix works:** bin-count normalisation (AvgSampEn) and an
   ~82× finer absolute grid both leave the gain dependence in place.
5. GI construction: standardise the analysis window by its SD before the
   otherwise unchanged profiling stage; exact invariance, verified
   numerically, with parity against the frozen reference.
6. Main EHG consequence: GI-Total shows a consistent negative FM-vs-IN
   association across EHG9–EHG12; frozen Total remains positive but
   statistically null on all four channels.
7. Restrained implication: fixed absolute numerical quantization can
   materially affect profile-derived inference.

A compliant draft is in `facts_pack.md` §8. Do **not** use the pre-21-Sep
draft abstract, which used forbidden claim language.

Do not include: generic pregnancy background; classifier language; diagnostic
claims; "amplitude-independent complexity" claims.

## Index Terms

Sample entropy; entropy profiling; electrohysterography; gain invariance;
numerical quantization; signal irregularity.

---

# I. INTRODUCTION

## Purpose

Introduce the signal-processing problem quickly, position the relevant prior
art, identify the gap, end with a compact contribution statement.

A separate Related Work section is **not** recommended — at four pages it
would cost ~0.4 column, and paragraph 3 below already does the work.

**Target: 14–16% of the technical pages.** Trim paragraph 1 before paragraph 3;
paragraph 3 is the paper's novelty insurance and must stay full length.

## Content

### Paragraph 1 — SampEn and tolerance dependence

- SampEn as a widely used irregularity measure for physiological time series.
- Conventional SampEn compares embedded templates at tolerance *r*.
- In standard formulations *r* is commonly tied to signal SD.
- Parameter/tolerance choice is a known methodological issue.

Do not claim "SampEn is gain-sensitive" without qualification.

### Paragraph 2 — Entropy/SampEn profiling

- Entropy profiling replaces a single selected tolerance with a profile over
  data-derived pairwise-distance tolerances.
- Profile summaries such as Total, Average, SD, Kurtosis and Skewness were
  subsequently proposed.
- The released reference implementation quantizes pairwise distances to three
  decimals before forming the distinct occupied tolerance support. **Cite the
  implementation alongside the parent paper here, never the parent paper
  alone** (facts pack §3).
- One clause establishing that these summaries are in downstream use as
  biomarkers beyond the originating HRV work — this is what makes the problem
  worth four pages rather than a correspondence note.

This is where the paper moves from general SampEn to its actual object of study.

### Paragraph 3 — Prior amplitude robustness and the unresolved gap

Acknowledge explicitly, and early:

- SD scaling/normalisation is established practice.
- RangeEn addresses amplitude robustness by modifying the distance definition,
  covering a broader class of amplitude variation than constant gain.
- Dedicated EHG entropy measures have previously modified similarity/tolerance
  definitions to reduce sensitivity to amplitude fluctuations.
- AvgSampEn already normalises Total by bin count.
- Quantization effects have been discussed elsewhere in the ApEn/SampEn family
  (though on the probability axis, not the tolerance axis).

Then state the narrow unresolved problem:

> The interaction between positive multiplicative gain and a SampEn-profile
> tolerance support constructed from pairwise distances quantized at a fixed
> absolute resolution has not been adequately characterised, particularly for
> profile summaries and downstream physiological inference.

Keep this bounded to the searched literature. Do not convert it into an
absolute "no previous study" claim.

### Paragraph 4 — Contributions

Order matters. Do not let space pressure invert it or delete item 3.

1. **Failure mechanism.** Fixed absolute distance quantization breaks the
   scale equivariance of a data-derived tolerance support by splitting and
   merging occupied levels under gain — demonstrated by removing the
   quantization alone, and shown to persist across an ~82× change in the
   resolution constant.
2. **Correction and validation.** GI-SampEn profiling: SD-standardise each
   window before an otherwise unchanged profiling stage. Parity, exact gain
   invariance, and elimination of the two obvious alternatives.
3. **Downstream consequence.** GI-Total produces a stable negative FM-vs-IN
   association across EHG9–EHG12 where frozen Total is positive but
   statistically null on every channel.

**Include the scope sentence once**, here or in the abstract: *"We do not
claim priority for amplitude-robust entropy estimation, which is well
established."* One sentence, and the largest framing objection loses most of
its force.

The method must not be presented as novel; SD normalisation is not novel.

Optional, and justified: one clause claiming the validation protocol itself —
parity, symptom, mechanism isolation, elimination of alternatives, consequence
— as a transferable template. It costs almost nothing and the chain is
stronger than the assertion-of-robustness norm in this literature.

---

# II. FINITE-RESOLUTION SAMPEN PROFILING AND ITS SCALE BEHAVIOUR

*Renamed. The previous title ("…and Gain Invariance") promised the fix before
the problem had been posed, undercutting the mechanism-first strategy.*

## Purpose

The intellectual core. Establish the failure mechanism before the correction.

**Target: 20–22%.** Unchanged.

---

## II-A. The Finite-Resolution SampEn Profile

Define only what is necessary: analysis window *x*; embedding dimension m=2;
Chebyshev pairwise distances at *m* and *m+1*; distance quantization; the
tolerance support as the distinct occupied quantized distances; the SampEn
profile; the profile summaries this paper uses.

Quantizer notation: $Q_\Delta(d)$, with $\Delta$ the fixed absolute numerical
resolution.

Describe the implementation precisely:

> Pairwise Chebyshev distances are quantized to three decimal places,
> corresponding to an absolute resolution of 0.001 signal units, and the
> profile is evaluated at the resulting distinct occupied quantized-distance
> values.

**Do not describe the method as evaluating every point of a regular 0.001
grid.** On a fixed grid nothing splits or merges, and the argument in II-B
becomes incoherent. (The facts pack previously contained this error; it has
been corrected there.)

Do not spend space defining every discarded profile summary.

---

## II-B. Scale Behaviour of the Quantized Tolerance Support

**Open with the empirical fact, then the algebra.** A reviewer who reads "a
4× gain change on an identical waveform moves Total SampEn by +309%" in the
first two sentences is engaged; one who meets a quantizer inequality first
must hold an abstraction while waiting to learn why it matters. This costs no
space — it is purely an ordering change.

Then establish, for positive gain $c$:

$$d(cx) = c\,d(x)$$

For the ideal unrounded profile the tolerance support scales with the
distances, so corresponding tolerance ranks are preserved. With fixed absolute
quantization,

$$Q_\Delta(cd) \neq c\,Q_\Delta(d)$$

in general. Mechanism:

- gain > 1 can split distances that formerly shared a quantized level;
- gain < 1 can merge formerly distinct levels;
- the support cardinality changes — roughly in proportion to amplitude / Δ;
- and, more importantly, the profile is evaluated at a set of
  **non-corresponding** occupied tolerances.

This is why dividing Total by the number of bins cannot restore exact
invariance: it corrects cardinality, not correspondence.

**State the general property in one sentence.** The profile summaries are
functionals of the ordered count sequence over the support; that sequence
survives any strictly monotone transformation of the distance multiset, which
is why the unrounded profile is gain-equivariant. Fixed-resolution
quantization is many-to-one and therefore not order-preserving. This frames
the finding as a property of the construction rather than of one constant, and
it is the difference between a characterisation and a bug report.

**Add one sentence on provenance** (facts pack §3): the rounding is absent
from the published formulation and absent from the same repository's
ApEn-profile implementation, which takes `unique()` over raw distances. It is
a deliberate, method-specific choice, not an incidental slip.

Framing to preserve:

- the data-derived profiling concept is not inherently gain-sensitive;
- the finite-resolution absolute quantization is the mechanism under study.

---

## II-C. Gain-Invariant Profiling

Define $z = x / \mathrm{sd}(x)$. For $c>0$,

$$\frac{cx}{\mathrm{sd}(cx)} = \frac{x}{\mathrm{sd}(x)}$$

so the entire signal entering the profiling/quantization pipeline is
identical; all downstream operations are unchanged; the complete profile and
every summary are analytically invariant to constant positive multiplicative
gain.

Do not present the one-line normalisation as the novelty. The novelty is the
diagnosis, the exactness of the correction in the profile representation, and
the demonstrated inferential consequence.

**Add one sentence establishing the estimand**, which answers "you replaced
the feature rather than correcting it": the summaries are functionals of the
profile over its occupied support; the frozen support's cardinality carries an
amplitude term; GI evaluates the same functional on a support from which that
term has been removed. Same estimand, identifiable representation.

**Mention the resolution point here in one clause, framed as separation, not
as a caveat**: sd-normalisation also refines the effective resolution, and
IV-A result 5 plus the fixed-grid variant show the reported result is driven
by invariance rather than refinement.

---

# III. EXPERIMENTAL DESIGN

## Purpose

Only the methodological information needed to evaluate the claims in *this*
paper. Do not reproduce the methodology of the earlier EHG study.

**Target: 10–12%** (reduced from 15–18%). The design is inherited; the
contribution is in the mechanism and the evidence.

---

## III-A. EHG Data and Statistical Analysis

**Three to four sentences with a citation, not a reconstruction.** Include:
public Icelandic 16-electrode EHG database; median-axis channels EHG9–EHG12;
60-s windows; states IN, UC, FM; cohort/window counts from `facts_pack.md`;
the primary contrast (FM vs IN); patient-aware mixed-effects structure
(woman + recording random effects); BH-FDR.

**Name the FDR family explicitly wherever a q-value is quoted** — the same
estimate carries different q-values under the 13-feature GI family and the
16-test cross-channel family (facts pack §5.4). Both are correct; silence
about which is not.

Do not include: all 34 Paper 1 features; extensive UC interpretation;
classifier methodology; clinical background.

---

## III-B. Validation Protocol

**One paragraph, not six subsections.** Name the chain — parity, gain stress,
mechanism isolation by removing the quantization, elimination of bin-count
normalisation and of finer quantization, cross-channel analysis — and let
IV-A carry the detail. The purpose of each experiment is self-evident once
its result is stated; at four pages, six headed "Purpose" statements consume
most of a column before any result appears.

State once that the resolution grid for the fixed-grid variant was selected
from baseline windows only, before any UC or FM feature was computed, with a
recorded timestamp and window-ID hash. Pre-registration is cheap to say and
reviewers reward it.

Use "cross-channel consistency" or "spatial consistency within the same
cohort." Never "independent replication."

---

# IV. RESULTS AND DISCUSSION

## Purpose

The largest section. Results and interpretation integrated; no separate
journal-style Discussion. Causal numerical evidence first, physiological
consequence second.

**Target: 45–48%** (raised from 38–42%).

---

## IV-A. Gain, Quantization, and Resolution

### Narrative order — REVISED

The previous order eliminated two candidate fixes *before* naming the cause,
so the negative results arrived as unmotivated checks. The revised order
names the cause second, which makes results 3 and 4 motivated tests of the
obvious alternatives and gives the mechanism-isolating experiment the
prominence it earns.

#### 1. Symptom — frozen summaries under gain

Frozen profile summaries change under positive gain; Total by up to +630% at
7.1×. **Fold parity in as a clause** ("our implementation reproduces the
frozen reference summaries to 3.6×10⁻¹⁵ across 200 windows"), not as a
finding of its own.

#### 2. Cause, isolated — the unrounded profile

An unrounded profile — no fixed-decimal quantization, and **no**
sd-normalisation — is exactly gain-equivariant at every tested gain. This
isolates the quantization step, not the profiling concept, as the mechanism.

**This is the single strongest answer to the "it's a bug in one
implementation" objection and it must appear here, not fifth.** It also
belongs in the abstract. Bound the claim to the tested subset per facts pack
§12 until §5.5 is extended.

#### 3. Cheap fix 1 fails — bin-count normalisation

AvgSampEn is roughly an order of magnitude less gain-sensitive than Total but
is **not** invariant: 0/60 windows pass at any tested gain. Bin-count
normalisation corrects cardinality, not correspondence of the support.

Two sentences plus one table row.

#### 4. Cheap fix 2 fails — finer absolute quantization

An ~82× finer absolute grid leaves the worst-case gain sensitivity
essentially unchanged for Total, and the per-feature behaviour is **not
monotonic** — Average and SD each dip at the middle resolution and rise
again at the finest.

**Do not describe the trend as improvement.** Report it as observed.

#### 5. The correction — GI profiling

GI summaries are exactly invariant within the predefined numerical tolerance,
at every tested resolution, independent of bin count. The invariance across an
~80× bin-count range is simultaneously the answer to "the refinement is doing
the work" — state it that way.

### Central causal argument

The subsection should leave the reader with:

> Frozen summaries move under gain → removing the fixed absolute quantization
> alone restores gain equivariance → bin-count normalisation does not → finer
> absolute quantization does not → scale normalisation restores exact
> invariance while retaining the finite-resolution implementation.

Core evidence, not supplementary robustness testing.

---

## IV-B. Cross-Channel EHG Associations

Present the central four-channel result.

Primary table (values from `facts_pack.md` §5.4 only; name the FDR family in
the caption):

| Channel | GI-SD | q | Frozen SD | q | GI-Total | q | Frozen Total | q |
|---|---:|---:|---:|---:|---:|---:|---:|---:|

### Total SampEn

- GI-Total is negative and FDR-supported across EHG9–EHG12.
- Frozen Total has positive point estimates but is statistically null on all
  four channels.
- Required wording:

> Gain correction reverses the direction of the Total SampEn point estimate
> and reveals a stable FDR-supported negative FM-vs-IN association across all
> four channels, whereas frozen Total remains statistically null.

Do not say "reverses the original finding", "overturns a significant finding",
or "independent replication" **for this contrast**. See the scoped rule below.

### SD SampEn

GI-SD and frozen SD are both negative and supported across all four channels.
SD is less vulnerable than Total to the gain/quantization mechanism.

### Fixed-grid agreement — one sentence

The pre-registered dimensionless grid reproduces the rounded GI result
(agreement r = 0.999 across 4,083 windows). This is not replication, but it
is a methodologically independent route to the same conclusion within the same
data, and it is the strongest available support against the
pseudo-replication objection.

### Fixed-r comparator — report it

Report `gi_fixed_r_sampen` explicitly (facts pack §5.9). It gives a **larger**
FM effect than any profile summary. Volunteering an unfavourable comparator
reads as rigour; having a reviewer find it unreported does not. The answer
goes in IV-C.

---

## IV-C. Interpretation and Scope

### What the result supports

- GI profiling removes dependence on constant positive multiplicative gain.
- The GI-Total FM association therefore cannot be explained by constant
  multiplicative gain differences between windows. (Other amplitude-related
  confounds are not excluded by this argument — say so.)
- The failure of AvgSampEn shows bin-count normalisation does not restore
  support correspondence.
- The resolution analysis shows finer decimal precision is not equivalent to
  scale equivariance.
- The full-precision control shows the profiling concept itself is not the
  source of the problem.

### Why profile at all — two sentences

Against the fixed-r comparator: the profile carries shape information no
single tolerance has (`gigrid_slope`, `gigrid_centroid`, both FDR-supported,
with no single-r analogue); and the object of this paper is the correctness of
the representation the prior study already used, not the maximisation of
effect size.

### Feature-selection honesty

Kurtosis and Skewness SampEn were unstable under the resolution criterion and
were not retained for cross-channel inference; both are also null on the fixed
grid. State it plainly — it shows the validation criterion was applied before
the results were known, and it pre-empts "what about the other two FM
features from your own prior paper?"

### Prior-work distinction

- **AvgSampEn:** normalises Total by support cardinality; does not guarantee
  gain invariance.
- **RangeEn:** changes the distance function; targets a broader
  amplitude-robustness problem, including non-stationary amplitude, which is
  outside our scope. No superiority claimed; no comparison run.
- **Mischi et al.:** modify similarity/tolerance handling for EHG amplitude
  fluctuations, but do not study a quantized SampEn-profile representation.
  **This sentence is provisional** until the full text is read (facts pack
  §10); if their modification is a per-window amplitude standardisation, it
  must change.

### Limitations — concise, and do not shorten further

One public EHG cohort; channels are spatial measurements from the same
recordings, not independent validation cohorts; the invariance claim is
limited to constant positive multiplicative gain; within-window non-stationary
amplitude modulation is out of scope; no classifier or diagnostic-performance
claim; no empirical superiority claim over RangeEn or other entropy families.

No separate long Limitations section.

---

# V. CONCLUSION

Two to four sentences. **Target: 3–4%.**

1. Fixed absolute distance quantization can introduce gain dependence into
   SampEn profiling.
2. Removing the quantization restores gain equivariance; neither bin-count
   normalisation nor finer quantization does.
3. SD standardisation before the otherwise unchanged profiling stage restores
   exact positive-gain invariance.
4. Correcting this numerical issue materially changes the interpretation of
   the EHG Total SampEn association.

**One non-overclaimed generalisation sentence is worth the space**: the same
interaction can arise wherever a data-derived support is built from quantized
distances. This materially broadens the readership beyond EHG and beyond
SampEn, at the cost of one line.

Do not introduce new results, speculate about clinical utility, or add an
extensive future-work list.

---

# REFERENCES

Optional fifth page, references only. Approximately 20 citations; see
`GI_SampEn_ICASSP_Citation_Map.md` (revised 21 Sep 2026).

**The reference implementation is a separate bibliography entry** and must be
cited alongside the parent paper wherever the quantization is asserted.

---

# Figure and Table Strategy

*Reconciled with `facts_pack.md` §9, which previously specified a different
Figure 1. The facts pack has been updated to match this.*

## Figure 1 — two panels: mechanism and consequence

- **(a) Mechanism, empirically.** Frozen Total SampEn against time-domain
  mean absolute value beside GI-Total against the same, shared axes
  (facts pack §5.8). This shows the mechanism *in the data* rather than as a
  cartoon; it takes one glance and is unarguable.
  *Fallback if cut:* a schematic showing occupied tolerance levels splitting
  and merging under gain — **not** a generic pipeline diagram, which
  communicates nothing a sentence cannot.
- **(b) Consequence.** Grouped bar chart: channel on the x-axis, standardised
  estimate on the y-axis, frozen vs GI, faceted by feature, zero line drawn.
  The visual point is Total's frozen bars crossing zero while GI-Total's stay
  consistently negative.

## Table 1 — cross-channel EHG result

The EHG9–EHG12 effect/q-value table. Name the FDR family in the caption.

## Table 2 — only if space remains

Two rows of the resolution ladder (coarsest and finest, frozen and GI) plus
the AvgSampEn row. If it does not fit, the numbers go in the text — do not
relegate them to the repository.

Do not spend a figure on the resolution ladder.

---

# Space Allocation

| Section | Target |
|---|---|
| I. Introduction | 14–16% |
| II. Method / mechanism | 20–22% |
| III. Experimental design | 10–12% |
| IV. Results and discussion | 45–48% |
| V. Conclusion | 3–4% |

The saving comes from Section III, which describes an inherited design, and
goes to IV-A, which now carries five ordered results.

---

# Claim Boundaries

`facts_pack.md` §12 is authoritative. Summarised here:

## Never write

- "SampEn is gain-sensitive" (unqualified).
- "Entropy profiling is inherently gain-sensitive."
- "We introduce the first gain-invariant SampEn" / "gain-invariant SampEn"
  without "profiling."
- "GI-SampEn removes amplitude effects" / "is amplitude-independent."
- "GI-Total is superior to RangeEn."
- "The four EHG channels independently replicate the result."
- "GI-Total reveals the true physiological effect."

## The reversal rule — SCOPED, not blanket

The previous blanket ban on "the original significant finding was reversed"
was over-broad and would cause the writer to understate a real result.

- **FM-vs-IN Total at the reference resolution** — frozen is null on all four
  channels. Describe the change as a reversal of the point-estimate direction
  accompanied by the emergence of FDR support. **Never** as the reversal of a
  significant finding.
- **Where a frozen result is itself FDR-supported** — the UC-vs-IN Total
  contrast and frozen Total at the finest resolution (facts pack §5.10, §5.3)
  — a sign change of an FDR-supported association may be described as such.
- **Kurtosis and skewness** — both frozen results were FDR-supported and both
  are null after correction; "two of the three frozen FM profile-shape
  associations do not survive gain correction" is permitted.

## Preferred wording

"finite-resolution SampEn profiling"; "fixed absolute distance quantization";
"positive multiplicative gain"; "gain-invariant SampEn profiling";
"cross-channel consistency"; "the direction of the point estimate changes";
"the association cannot be attributed to constant multiplicative gain"; "the
profiling representation is gain-equivariant in the absence of fixed absolute
quantization."

---

# Numerical Source of Truth

All manuscript numbers come from `facts_pack.md`. Do not interpolate,
estimate, recompute from memory, or copy numbers from earlier drafts that
differ from the current pack. If a sentence requires a number not present
there, flag it rather than inventing it.
