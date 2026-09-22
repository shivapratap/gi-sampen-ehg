# GI-SampEn ICASSP 2027 Citation Map

*Revised 21 Sep 2026 in response to `GI_SampEn_ICASSP_Planning_Review.md`.
Changes: three bibliographic errors corrected ([15] Mischi, [18] Cheng,
[9] Keenan); the reference implementation added as [20]; multiscale profiling
removed to keep the count at 20; Keenan promoted from "first to trim" to
essential; the Mischi distinction marked provisional; trim order revised.*

## Purpose

A deliberately compact set of **20 references**. Not an exhaustive review.
Each citation must earn space in a five-page ICASSP bibliography by serving at
least one of:

1. establish SampEn or tolerance-selection foundations;
2. establish the entropy/SampEn profiling lineage;
3. define profile-derived summaries such as Total and Average SampEn;
4. bound our novelty by documenting prior amplitude-normalisation or
   amplitude-robust entropy methods;
5. provide prior work on numerical/quantization effects;
6. establish EHG-specific entropy precedent;
7. document the dataset, or the implementation whose behaviour we study.

References marked **CORE** are non-negotiable unless later verification finds
a bibliographic error.

**Verification status.** Bibliographic fields for [3], [6], [7], [9], [11],
[15], [16], [17], [18] were checked against Crossref or publisher records on
21 Sep 2026. Corrections are flagged inline. All entries must still be
regenerated from verified BibTeX before submission.

---

# Citation Map

## [1] Richman & Moorman, 2000

Richman, J. S., and Moorman, J. R. "Physiological time-series analysis using
approximate entropy and sample entropy." *American Journal of
Physiology-Heart and Circulatory Physiology*, 278(6), H2039–H2049, 2000.
DOI: 10.1152/ajpheart.2000.278.6.H2039

**Role.** Foundational SampEn citation.
**Supports.** Definition and motivation of SampEn; conventional tolerance
practice; novelty boundary — scale handling in conventional SampEn predates
this work.
**Placement.** Introduction ¶1; possibly Section II when distinguishing
conventional SampEn from profiling.
**Classification.** Essential.

---

## [2] Lake et al., 2002

Lake, D. E., Richman, J. S., Griffin, M. P., and Moorman, J. R. "Sample
entropy analysis of neonatal heart rate variability." *American Journal of
Physiology-Regulatory, Integrative and Comparative Physiology*, 283(3),
R789–R797, 2002. DOI: 10.1152/ajpregu.00069.2002

**Role.** Early physiological SampEn methodology.
**Supports.** SampEn behaviour depends on analysis parameters and tolerance
selection; established use in short physiological signals.
**Placement.** Introduction ¶1.
**Classification.** Expendable — overlaps [3] on parameter sensitivity, and
[3] serves this argument better. **First trim candidate.**

---

## [3] Yentes et al., 2013 — *verified*

Yentes, J. M., Hunt, N., Schmid, K. K., Kaipust, J. P., McGrath, D., and
Stergiou, N. "The Appropriate Use of Approximate Entropy and Sample Entropy
with Short Data Sets." *Annals of Biomedical Engineering*, 41(2), 349–365,
2013. DOI: 10.1007/s10439-012-0668-3

**Role.** Parameter-sensitivity and methodological-rigour citation.
**Supports.** SampEn estimates can depend substantially on parameter selection
and data length; methodological settings require validation rather than being
treated as innocuous implementation details.
**Placement.** Introduction ¶1; optional reuse when discussing numerical
sensitivity.
**Classification.** Useful.

---

## [4] Lake & Moorman, 2011

Lake, D. E., and Moorman, J. R. "Accurate estimation of entropy in very short
physiological time series: the problem of atrial fibrillation detection in
implanted ventricular devices." *American Journal of Physiology-Heart and
Circulatory Physiology*, 300(1), H319–H325, 2011.
DOI: 10.1152/ajpheart.00561.2010

**Role.** Prior scale/tolerance correction within the SampEn family.
**Supports.** COSEn subtracts a log-scale term to remove the data's scale from
the statistic — correcting scale behaviour of SampEn-family measures is not a
new goal, so our novelty cannot be generic normalisation.
**Placement.** Introduction ¶3.
**Classification.** Essential — the strongest prior art against a
generic-normalisation claim.

---

# SampEn / Entropy Profiling Lineage

## [5] Udhayakumar, Karmakar & Palaniswami, 2017

Udhayakumar, R. K., Karmakar, C., and Palaniswami, M. "Approximate entropy
profile: a novel approach to comprehend irregularity of short-term HRV
signal." *Nonlinear Dynamics*, 88, 823–837, 2017.
DOI: 10.1007/s11071-016-3278-z

**Role.** Origin of the entropy-profile representation.
**Supports.** Replacing a single selected tolerance with a profile over
data-derived tolerances; the ideal profiling lineage predates the
SampEn-profile implementation studied here.
**Second function, and the reason this is now essential rather than useful:**
the released ApEn-profile implementation takes `unique()` over *raw*
distances, with no rounding step. The contrast with [6]'s implementation is
the evidence that the quantizer is a deliberate, method-specific choice.
**Placement.** Introduction ¶2; Section II-B (provenance sentence).
**Classification.** Essential.

---

## [6] Udhayakumar, Karmakar & Palaniswami, 2018 — CORE

Udhayakumar, R. K., Karmakar, C., and Palaniswami, M. "Understanding
Irregularity Characteristics of Short-Term HRV Signals Using Sample Entropy
Profile." *IEEE Transactions on Biomedical Engineering*, 65(11), 2569–2579,
2018. DOI: 10.1109/TBME.2018.2808271

**Role.** Direct parent method.
**Supports.** SampEn profiling; the data-derived tolerance-profile
representation; the method whose released reference implementation is
investigated here.
**Placement.** Introduction ¶2; Section II-A; any sentence defining the
frozen/reference-compatible profile.

**Claim discipline — the most important line in this document.** Do not
attribute three-decimal rounding to the published mathematical formulation.
The published formulation contains no rounding. The rounding is established
from the released reference implementation, **[20]**, which must be cited
alongside [6] at every point where the quantization is asserted. Never cite
[6] alone for that claim.

**Classification.** Essential — CORE.

---

## [7] Udhayakumar et al., 2017 (EMBC) — *verified*

Udhayakumar, R. K., Karmakar, C., and Palaniswami, M. "Secondary measures of
regularity from an entropy profile in detecting arrhythmia." *39th Annual
International Conference of the IEEE Engineering in Medicine and Biology
Society (EMBC)*, 2017. DOI: 10.1109/EMBC.2017.8037607

**Role.** Profile-derived summary measures.
**Supports.** Use of secondary measures derived from an entropy profile; the
lineage of Total/Average/SD/Kurtosis/Skewness-style summaries.
**Placement.** Section II-A; possibly Introduction ¶2.
**Classification.** Useful.

---

## ~~[8] Udhayakumar, Karmakar & Palaniswami, 2019 — REMOVED~~

~~"Multiscale entropy profiling to estimate complexity of heart rate
dynamics." *Physical Review E*, 100, 012405, 2019.~~

**Removed in this revision** to make room for [20] while holding the count at
20. It supported only "the framework was extended beyond a single HRV
experiment," which [5], [6] and [7] carry between them. Reinstate only if a
slot frees up and the extension claim proves load-bearing in drafting.

---

## [8] Karmakar, Udhayakumar & Palaniswami, 2020 — CORE *(renumbered from [9])*

Karmakar, C., Udhayakumar, R. K., and Palaniswami, M. "Entropy Profiling: A
Reduced-Parametric Measure of Kolmogorov–Sinai Entropy from Short-Term HRV
Signal." *Entropy*, 22(12), 1396, 2020. DOI: 10.3390/e22121396

**Role.** Canonical profiling review/method summary, and AvgSampEn prior art.
**Supports.** TotalSampEn; AvgSampEn as Total divided by the number of bins;
the rationale for including AvgSampEn in our robustness audit.
**Placement.** Introduction ¶2 or ¶3; Section II-A; Section IV-A result 3.
**Reviewer relevance.** Essential — a reviewer may reasonably ask whether
AvgSampEn already solves Total's gain sensitivity. Our answer is empirical
(facts pack §5.6), and this citation is what makes the question legible.
**Classification.** Essential — CORE.

---

## [9] Keenan et al., 2022 — *bibliographic fields corrected; PROMOTED*

Keenan, E., Karmakar, C., Udhayakumar, R. K., Brownfoot, F. C., Lakhno, I.,
Shulgin, V., Behar, J. A., and Palaniswami, M. "Detection of fetal arrhythmias
in non-invasive fetal ECG recordings using data-driven entropy profiling."
*Physiological Measurement*, **43(2), 025008**, 2022.
DOI: 10.1088/1361-6579/ac4e6d

> **Correction.** The previous entry gave only "*Physiological Measurement*,
> 2022" with no volume, issue or article number, and no author list. Both are
> now supplied and verified.

**Role.** Downstream biomedical use of entropy profiling.
**Supports.** TotalSampEn is not an in-house HRV statistic — it is used as the
primary reported metric in an independent clinical application, by a partly
different author group. This is the best available answer to "why does this
matter beyond one paper", and in a paper whose weakest perceived point is
narrowness it is worth more than three lineage citations.
**Placement.** Introduction ¶2, in the clause establishing downstream use.

> **Priority reversed.** The previous version listed this first for trimming.
> It is now **essential**; [2] and [17] are the trim candidates.

> **Open check before drafting.** This paper shares authors with the profiling
> lineage and almost certainly uses the same code path. **If it normalises its
> input series before profiling, it is prior art for the *operation*** — not
> for the diagnosis, and not fatal, since the spine already concedes the
> operation is not novel. But Introduction ¶3 would have to acknowledge it.
> Full text was not accessible during verification. Highest-value remaining
> literature check (facts pack §10).

**Classification.** Essential.

---

# Related Distance-Distribution and Normalisation Work

## [10] Li et al., 2015

Li, P., Liu, C., Li, K., Zheng, D., Liu, C., and Hou, Y. "Assessing the
complexity of short-term heartbeat interval series by distribution entropy."
*Medical & Biological Engineering & Computing*, 53, 77–87, 2015.
DOI: 10.1007/s11517-014-1216-0

**Role.** Distance-distribution alternative.
**Supports.** Precedent for representing the distribution of pairwise
distances rather than relying on one tolerance; and the conceptual distinction
that carries real weight here — DistEn's parameter is a **relative** bin count
spanning the observed distance range, so it rescales with the signal, whereas
the construction we study uses a **fixed absolute** resolution, which does not.
That contrast is one of the paper's sharpest one-liners.
**Placement.** Introduction ¶3, or IV-A.
**Classification.** Useful.

---

## [11] Karmakar et al., 2017 — CORE

Karmakar, C., et al. "Stability, Consistency and Performance of Distribution
Entropy in Analysing Short Length HRV Signal." *Frontiers in Physiology*, 8,
720, 2017. DOI: 10.3389/fphys.2017.00720

> Expand "et al." from the DOI record at BibTeX time.

**Role.** Novelty-boundary citation.
**Supports.** Unit-variance normalisation before a distance-based entropy
measure is prior art — by the same group, in the adjacent method; and
discretisation/bin-count sensitivity has methodological precedent.
**Placement.** Introduction ¶3; Section IV-C.
**Claim discipline.** This citation is the reason **not** to claim that SD
normalisation before a distance-based entropy measure is itself novel. Keep
this note; cite the paper ourselves rather than waiting for a reviewer to
produce it.
**Classification.** Essential — CORE.

---

# Amplitude / Gain Robustness Prior Art

## [12] Omidvarnia et al., 2018 — CORE

Omidvarnia, A., Mesbah, M., Pedersen, M., and Jackson, G. "Range Entropy: A
Bridge between Signal Complexity and Self-Similarity." *Entropy*, 20(12), 962,
2018. DOI: 10.3390/e20120962

**Role.** Closest general amplitude-robust entropy alternative.
**Supports.** Amplitude robustness is an established goal; SD correction is
already known practice (the paper calls it "a common practice"); RangeEn
changes the distance definition and addresses a broader class of amplitude
variation, including non-stationary amplitude where SD correction is
demonstrably insufficient.
**Placement.** Introduction ¶3; Section IV-C.
**Claim discipline.** Do not claim GI-SampEn is superior to RangeEn. No direct
comparison has been performed. Concede that RangeEn's invariance class is
strictly broader than ours.
**Classification.** Essential — CORE.

---

# Numerical / Quantization Precedent

## [13] Bajić & Japundžić-Žigon, 2022 — CORE

Bajić, D., and Japundžić-Žigon, N. "On Quantization Errors in Approximate and
Sample Entropy." *Entropy*, 24(1), 73, 2022. DOI: 10.3390/e24010073

**Role.** Closest prior methodological work on quantization in the ApEn/SampEn
family.
**Supports.** Numerical quantization is a legitimate methodological issue in
entropy estimation, and the community treats it as a research object rather
than an implementation detail.
**Important distinction — keep this wording.** Their analysis concerns
quantization of matching probabilities and count-related quantities, not the
construction studied here:

> fixed absolute quantization of pairwise **distances** before constructing a
> data-derived SampEn-profile tolerance support.

Different axis, different mechanism, different consequence.
**Placement.** Introduction ¶3; Section IV-A.
**Classification.** Essential — CORE.

---

## [14] Chen et al., 2019

Chen, et al. "A comprehensive comparison and overview of R packages for
calculating sample entropy." *Biology Methods and Protocols*, 4(1), bpz016,
2019. DOI: 10.1093/biomethods/bpz016

**Role.** Implementation-reproducibility precedent.
**Supports.** Implementations carrying the same broad method label yield
different numerical results because of algorithmic and preprocessing choices.
Genre precedent for a paper about implementation-level numerical behaviour.
**Placement.** Introduction ¶3 or Section IV-A.
**Classification.** Useful.

---

# EHG-Specific Entropy Prior Art

## [15] Mischi et al., 2018 — CORE — *author initials corrected*

Mischi, M., Chen, C., Ignatenko, T., de Lau, H., Ding, B., **Oei, S. G. G.**,
and Rabotti, C. "Dedicated Entropy Measures for Early Assessment of Pregnancy
Progression From Single-Channel Electrohysterography." *IEEE Transactions on
Biomedical Engineering*, 65(4), 875–884, 2018.
DOI: 10.1109/TBME.2017.2723933

> **Correction.** The previous entry gave "Oei, G. S." The record is
> S. G. Guid Oei, conventionally "Oei, S. G. G." All other fields verified
> correct.

**Role.** Closest EHG-domain amplitude-robust entropy prior art.
**Supports.** EHG amplitude variation is already recognised as a
methodological issue for entropy estimation; prior EHG work modified
tolerance/similarity handling to improve amplitude robustness.

**Our distinction — PROVISIONAL.** Not a SampEn tolerance profile; no
Total/Average profile summaries; no study of fixed absolute distance
quantization of a data-derived tolerance axis.

> **These are three negative claims about a paper whose full text has not been
> read.** The distinction currently rests on the abstract, which supports only
> "modifications in the tolerance metrics… for improving robustness to EHG
> amplitude fluctuations." **Obtain the full text before writing the Related
> Work sentence.** If their modification turns out to be a per-window
> amplitude standardisation, the sentence must change and the novelty boundary
> narrows. This is the citation map's own §B4 discipline applied to itself.

**Placement.** Introduction ¶3; Section IV-C.
**Claim discipline.** Amplitude robustness in EHG is **not** our novelty.
**Classification.** Essential — CORE.

---

## [16] Mas-Cabo et al., 2020

Mas-Cabo, J., Ye-Lin, Y., Garcia-Casado, J., Díaz-Martinez, A.,
Perales-Marin, A., Monfort-Ortiz, R., Roca-Prats, A., López-Corral, Á., and
Prats-Boluda, G. "Robust Characterization of the Uterine Myoelectrical
Activity in Different Obstetric Scenarios." *Entropy*, 22(7), 743, 2020.
DOI: 10.3390/e22070743

**Role.** EHG nonlinear-feature context.
**Supports.** Nonlinear/entropy-based EHG characterisation across obstetric
conditions.
**Placement.** Introduction or Section IV-C, only if a broader EHG context
sentence is needed.
**Classification.** Useful. **Second trim candidate** after [2].

---

## [17] Nieto-del-Amor et al., 2021 — *verified*

Nieto-del-Amor, F., Beskhani, R., Ye-Lin, Y., Garcia-Casado, J.,
Diaz-Martinez, A., Monfort-Ortiz, R., Diago-Almela, V. J., Hao, D., and
Prats-Boluda, G. "Assessment of Dispersion and Bubble Entropy Measures for
Enhancing Preterm Birth Prediction Based on Electrohysterographic Signals."
*Sensors*, 21(18), 6071, 2021. DOI: 10.3390/s21186071

**Role.** Alternative entropy families in EHG.
**Supports.** EHG complexity analysis is not limited to SampEn; rank- and
symbol-oriented entropy alternatives already exist and are amplitude-
insensitive by construction. Pre-empts "why not simply use a rank-based
entropy?" — the answer being that they discard the amplitude-distance
information the profile is built on, so they cannot explain a previously
reported SampEn-profile finding.
**Placement.** Introduction ¶3 or Section IV-C.
**Claim discipline.** Do not suggest GI profiling is the first amplitude-robust
or alternative entropy approach in EHG.
**Classification.** Useful.

---

## [18] Cheng et al., 2022 — *author initials corrected*

**Cheng, A., Yao, Y., Jin, Y., Chen, C., Vullings, R., Xu, L.**, and
Mischi, M. "Novel Multichannel Entropy Features and Machine Learning for Early
Assessment of Pregnancy Progression Using Electrohysterography." *IEEE
Transactions on Biomedical Engineering*, 69(12), 3728–3738, 2022.
DOI: 10.1109/TBME.2022.3176668

> **Correction.** The previous entry gave "Cheng, Y., Yao, S., Jin, M., …,
> Xu, P." Four initials were wrong. Verified against Crossref: Anyi Cheng,
> Yang Yao, Yibin Jin, Chuan Chen, Rik Vullings, Lin Xu, Massimo Mischi. DOI,
> volume, issue and pages were correct.

**Role.** Multichannel EHG entropy precedent.
**Supports.** Entropy information has already been evaluated across multiple
EHG channels — so our cross-channel design is conventional in this domain and
should not be oversold.
**Placement.** EHG context, or Section IV-B.
**Claim discipline.** Describe our EHG9–EHG12 result as cross-channel
consistency / spatial consistency within the same cohort. Never independent
replication.
**Classification.** Useful.

---

# Dataset and Implementation

## [19] Alexandersson et al., 2015 — CORE

Alexandersson, A., Steingrimsdottir, T., Terrien, J., Marque, C., and
Karlsson, B. "The Icelandic 16-electrode electrohysterogram database."
*Scientific Data*, 2, 150017, 2015. DOI: 10.1038/sdata.2015.17

**Role.** Dataset provenance.
**Supports.** Source of the multichannel EHG recordings; acquisition and
annotation information, including the fetal-movement annotations this paper's
primary contrast depends on.
**Placement.** Section III-A.
**Classification.** Essential — CORE.

---

## [20] Reference implementation — CORE — **NEW**

R. K. Udhayakumar, "Entropy-Codes: MATLAB code for entropy profiling,"
GitHub repository, commit `2a1d496c8bcf1e859ae9887d9911d168dd9a17dc`,
24 Sep 2020. [Online]. Available: https://github.com/radhagayathri/Entropy-Codes
(accessed 21 Sep 2026).

**Role.** Provenance for the paper's central factual claim.

**Why a separate entry rather than a footnote.** The quantization step is the
object of this paper, and **no paper in this list supports it** — the
published formulation [6] contains no rounding. A reviewer checking the
central claim must be able to follow a formal citation to it. A footnote
signals "incidental"; this is not incidental. Under IEEE conventions software
is cited as a first-class reference.

**Why the commit hash matters.** Repository content can change. The cited
commit is the one that introduced the `round(d,3)` / `round(d1,3)` lines in
`Sample entropy/CHM.m`, and the repository has been stable since 2020 — but
an unpinned URL would leave the paper's central factual claim unverifiable if
that line were ever edited.

**Recommended before submission.** Archive the repository state (e.g. a Zenodo
DOI) and cite the archived snapshot instead. This converts a mutable URL into
a permanent record and costs an afternoon. See facts pack §10.

**Placement.** Alongside [6] at **every** point where the quantization is
asserted — Introduction ¶2, Section II-A, Section II-B.

**Classification.** Essential — CORE.

---

# Core References That Should Survive Any Trimming

1. **[6]** Udhayakumar et al., 2018 — direct SampEn-profile parent method.
2. **[20]** Reference implementation — provenance for the rounding.
3. **[8]** Karmakar et al., 2020 — profile summaries and AvgSampEn.
4. **[11]** Karmakar et al., 2017 — normalisation/bin-resolution novelty boundary.
5. **[12]** Omidvarnia et al., 2018 — RangeEn and amplitude robustness.
6. **[13]** Bajić & Japundžić-Žigon, 2022 — closest quantization precedent.
7. **[15]** Mischi et al., 2018 — EHG amplitude-robust entropy prior art.
8. **[19]** Alexandersson et al., 2015 — dataset.

[1] Richman & Moorman and [9] Keenan should also normally remain: [1] anchors
SampEn itself, [9] is the evidence that the affected summary is in downstream
clinical use.

---

# Citation Deployment by Manuscript Section

## Introduction ¶1 — SampEn foundations

[1], [2], [3]. Establish SampEn and tolerance/parameter sensitivity. Avoid
over-citing foundational background; this is the paragraph to trim first.

## Introduction ¶2 — Profiling lineage and the object of study

[5], [6], [7], [8], and **[20] alongside [6]** wherever the rounding is
mentioned. Optional downstream-use clause: [9].
The key citations are [6] and [20].

## Introduction ¶3 — Novelty boundaries and gap

[4] COSEn / scale correction; [11] DistEn normalisation and bin sensitivity;
[12] RangeEn; [13] quantization; [15] EHG-specific amplitude-robust entropy.
Optional: [10], [14], [17].

**The most important literature paragraph in the paper.** It demonstrates that
the manuscript understands and concedes the relevant prior art before defining
the narrower gap. Do not trim it for space — trim ¶1 instead.

## Section II — Method and failure mechanism

[6] and [20] together for the implementation; [7], [8] for the summaries;
[5] for the unrounded ApEn-profile contrast in the provenance sentence.

Do not turn Section II into another literature review. The equations and the
scale-covariance argument are our technical analysis of the construction.

## Section III-A — EHG data

[19]. Optional EHG context: [15], [18].

## Section IV-A — Quantization/gain controls

[8] for AvgSampEn; [11] for prior bin/discretisation sensitivity; [13] for
quantization precedent; [10] for the relative-versus-absolute binning
contrast; [14] if implementation reproducibility needs explicit support.

Main evidence here comes from our experiments, not from citations.

## Section IV-B — Cross-channel EHG association

Optional contextual citation: [18]. Do not overload the central results table
with literature discussion.

## Section IV-C — Interpretation and scope

[12] RangeEn; [15] Mischi (provisional); [17] alternative EHG entropy
families. Use this subsection to delimit what GI-SampEn does and does not
claim.

---

# Claims These References Must Prevent Us From Making

| Unsafe claim | Why |
|---|---|
| "SampEn is gain-sensitive." | Conventional SampEn commonly links *r* to signal scale [1]. |
| "We introduce the first gain-invariant SampEn." | Scale handling [1], COSEn [4] and RangeEn [12] all predate this work. |
| "Amplitude robustness in EHG entropy is new." | [15], and later EHG entropy studies [17], [18], directly address it. |
| "SD normalisation before a distance-based entropy measure is novel." | [11] used unit-variance normalisation in the DistEn work. |
| "Quantization effects have never been studied in SampEn." | [13] explicitly studies quantization error in ApEn/SampEn — though on a different axis. |
| "AvgSampEn was introduced by us." | It is defined in [8], which is precisely why our robustness control matters. |
| "The channels independently replicate the finding." | Same physical windows, different electrodes; [18] is the multichannel precedent, not a licence. |

---

# Recommended Gap Statement

> Existing work has addressed SampEn tolerance selection, scale normalisation,
> amplitude-robust entropy, distance-distribution representations, and
> EHG-specific amplitude variation. Entropy profiling further replaces a
> single tolerance with a data-derived tolerance representation. However, the
> behaviour of a SampEn profile whose tolerance support is constructed from
> pairwise distances quantized at a fixed absolute resolution has received
> little attention. In such a representation, positive multiplicative gain can
> split or merge occupied tolerance levels, potentially altering
> profile-derived summaries and downstream statistical inference. This paper
> characterises that finite-resolution failure mode, isolates it by removing
> the quantization alone, tests alternatives such as AvgSampEn and finer
> absolute rounding, and evaluates an exactly gain-invariant correction.

Keep this bounded to the searched literature. Do not convert it into an
absolute "no previous study" claim.

**Searches performed** (21 Sep 2026): SampEn profile + amplitude
normalisation; SampEn profile + gain invariance; entropy profile + scaling;
tolerance-profile quantization; rounding pairwise distances in SampEn;
numerical resolution of SampEn tolerance axes; scale-equivariant entropy
profiling; AvgSampEn under amplitude scaling; finite-precision effects in
entropy profiling; EHG + SampEn profile; EHG + gain/amplitude-invariant
entropy. **No paper was found that directly undermines the gap.** No EHG +
entropy-profiling prior art was found, so the application appears novel as
well as the diagnosis.

**Not searched, and therefore not claimed:** Scopus, Web of Science, IEEE
Xplore full-text search, ACM DL, non-English literature, theses. Full texts of
[9] and [15] were not accessible.

---

# Reference Budget Strategy

Target: **20 references** (currently exactly 20).

Revised trim order, if the paper becomes crowded:

1. **[2]** Lake et al., 2002 — overlaps [3].
2. **[16]** Mas-Cabo et al., 2020 — context only.
3. **[14]** Chen et al., 2019 — supporting genre precedent.
4. **[10]** Li et al., 2015 — keep if the relative-vs-absolute binning
   sentence survives drafting.
5. **[17]** Nieto-del-Amor et al., 2021.

> **Changed from the previous version**, which listed [9] Keenan first to cut.
> That was backwards: [9] is the strongest available answer to "why does this
> matter beyond one paper." Do not trim it.

Do not trim the CORE references. A final paper with 15–20 tightly relevant
references is preferable to a longer bibliography that obscures the closest
prior art.

---

# Final Verification Before Submission

1. Regenerate every entry from verified BibTeX records — this file is a
   planning artifact, not a bibliography.
2. Expand the "et al." in [11] and confirm author order everywhere.
3. Re-verify year, volume, issue and pages/article number against the DOI
   record. (Three errors were found in this file on 21 Sep 2026; assume more
   are possible.)
4. Confirm every claim attributed to a paper is explicitly supported by that
   paper — in particular, resolve the **provisional** status of [15].
5. Keep claims supported by published papers distinct from claims supported by
   released source code: [6] versus [20].
6. Confirm [20] cites an archived snapshot if one has been created, and that
   the commit hash still resolves if not.
7. Resolve the open question on [9] (does it normalise before profiling?)
   before Introduction ¶3 is finalised.
