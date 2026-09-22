# Review of the ICASSP 2027 planning documents — spine, citation map, facts pack

**Reviewed:** `GI_SampEn_ICASSP_Manuscript_Spine.md`, `GI_SampEn_ICASSP_Citation_Map.md`, `facts_pack.md`
**Date:** 21 September 2026
**Stance:** senior BSP reviewer / ICASSP area chair / adversarial manuscript strategist. Critical by request.
**Numerical rule observed:** `facts_pack.md` treated as the only source of truth. Numbers I needed that are *not* in it are flagged as missing in §0.3, with the repository file where each currently lives. I have not imported any of them into the recommended manuscript text.

---

## 0. Before Part A — four blocking issues

These come first because three of them are internal contradictions between the three documents, and the writer will hit them on day one.

### 0.1 The facts pack violates the spine's non-negotiable claim boundaries — in the passages most likely to be copied

The spine's "Non-Negotiable Claim Boundaries" forbid *"The original significant finding was reversed"* and *"The four EHG channels independently replicate the result."* The facts pack, which you have designated the source of truth and will hand to the writer, breaks both — in its opening sentence and in its draft abstract:

| Location | Text | Spine rule broken |
|---|---|---|
| `facts_pack` §1 | "correcting it does not merely clean the measure up, it **reverses its apparent finding**" | "The original significant finding was reversed" |
| `facts_pack` §1 | "consistently across four **independent** electrodes" | "The four EHG channels independently replicate the result" |
| `facts_pack` §8 (draft abstract) | "gain-invariant Total SampEn **reverses** the sign of the original (amplitude-confounded) finding" | same as row 1 |
| `facts_pack` §8 | "a known effect **replicates** across four electrodes" | same as row 2 |

A writer handed both documents will follow the facts pack, because it contains the draft abstract and is labelled authoritative. **Fix the facts pack, not just the spine.** This is the single highest-priority change in this review.

### 0.2 The facts pack describes the mechanism in the way the spine explicitly forbids — and the code contradicts it

`facts_pack` §3: *"evaluates the profile on a tolerance **grid** with a fixed, absolute spacing (0.001 in raw signal units), and retains only the tolerances at which pairs of signal snippets are observed close together."*

The spine says, correctly: *"Avoid describing the method as evaluating every point of a regular 0.001 grid."*

The reference implementation quantizes each pairwise distance and then takes the distinct occupied values — quantize-then-collect, not grid-then-retain. The two descriptions produce similar supports but they are not the same construction, and the difference is load-bearing for your splitting/merging argument: splitting and merging are properties of a *many-to-one map applied to the distances*, not of a fixed grid being sampled. A reviewer who reads §3's description will not understand why gain causes splitting, because on a fixed grid nothing splits.

**Rewrite `facts_pack` §3 to match the spine's §II-A wording.** The spine's version is the correct one.

### 0.3 Numbers the manuscript will need that are not in the facts pack

Per your instruction I am flagging rather than importing. Each exists in the repository; none is currently in `facts_pack.md`.

| Missing number | Why the manuscript needs it | Where it lives now |
|---|---|---|
| Amplitude collinearity of frozen Total (Pearson r and r² against mean absolute value), and the same for GI-Total | Turns "amplitude-coupled" from an adjective into a measurement; it is the strongest single sentence available to the paper and the best candidate for Figure 1a | `results/amplitude_collinearity.csv`, `results/amplitude_collinearity_report.md` |
| **UC-vs-IN Total: frozen estimate and q, GI estimate and q** | This is a genuine sign change of an FDR-supported association, and it is the cleanest confirmation of the amplitude mechanism (contractions are high-amplitude). Currently the facts pack's cross-channel table is FM-only | `results/gate_summary.csv`, rows `contraction_vs_baseline` / `gi_total` |
| Fixed-grid (`gigrid_*`) results, and their agreement with `gi_total` | Answers the resolution-confound and cross-window-comparability objections *empirically* rather than by argument; the grid was pre-registered with a UTC timestamp and window-ID hash, which is worth a sentence on its own | `results/gate_summary.csv`, `results/grid_definition.json` |
| `gi_fixed_r_sampen` estimate and q for FM | `facts_pack` §10 names fixed-r SampEn as "the only already-run amplitude-robust comparator" but gives no value. A reviewer will want it, and its magnitude drives objection C4 below | `results/gate_summary.csv` |
| Which BH-FDR family each q-value belongs to | The same GI-Total EHG9 estimate carries two different q-values in the repository depending on the correction family (cross-channel 16-test family vs the gate family). The facts pack quotes one without naming the family | `results/cross_channel_replication_summary.csv` vs `results/gate_summary.csv` |
| That the released **ApEn**-profile implementation does *not* apply the rounding | Strongest available evidence that the quantizer is a deliberate, method-specific choice rather than an accident — which is the core of the answer to the bug-report objection | reference repository, `Approximate entropy/CHMforApEn.m` |

I recommend adding rows 1–4 and 6 to the facts pack before drafting, and resolving row 5 as a definition rather than a number.

### 0.4 A strategic fact you should know before you choose a framing tone

Dr Radhagayathri Udhayakumar — first author of citations [5]–[8], co-author of [9] and [10], and author of the reference implementation whose rounding step this paper is about — is publicly listed on the faculty of Amrita Vishwa Vidyapeetham, your own institution ([faculty page](https://www.amrita.edu/faculty/dr-radhagayathri-udhayakumar/)).

I raise this only because it bears directly on framing, which is the main risk this paper carries. It argues strongly for the collegial reading — *a method developed and calibrated for HRV behaves differently when transferred to a domain with a different amplitude scale* — over any framing that reads as fault-finding in someone else's code. It may also be worth a conversation before submission rather than after. That is your call, not mine; I flag it because it is material and publicly available.

---

## Part A — Manuscript spine

### A1. Overall architecture

**Verdict: sound, with one reallocation.** The structure follows current ICASSP methods-paper practice: no separate Related Work (correct — it would cost ~0.4 column you cannot spare, and paragraph 3 of the Introduction already does the job), integrated Results and Discussion (correct — a separate Discussion in four pages produces two thin sections instead of one strong one), and a short Conclusion.

Two changes:

**Section III is over-built for four pages.** III-B currently lists six numbered experiments with individual "Purpose" statements. Rendered at that granularity this consumes most of a column describing experiments before any result appears. In a four-page paper the validation protocol should be **one paragraph plus the results themselves** — the purpose of each experiment is self-evident once its result is stated. Compress III-B to a single paragraph naming the chain, and let IV-A carry the detail.

**III-A can be halved.** The cohort, windowing and model specification are inherited from the Access paper and should be stated in three or four sentences with a citation, not reconstructed. The spine already says "Do not reproduce the full methodology of the earlier EHG study" — make that explicit as a length target.

Recommended renaming: **II → "Finite-Resolution SampEn Profiling and Its Scale Behaviour."** "Gain Invariance" in the current title promises the fix before the problem has been posed, which slightly undercuts the mechanism-first strategy the rest of the spine commits to.

### A2. Story order

**Verdict: correct, and correctly centred.** The spine does put the finite-resolution failure mechanism, rather than SD normalization, at the intellectual centre. That is the right call and it is the decision that makes this paper publishable rather than dismissible. Keep it.

One refinement, and it matters more than it sounds. Section II-B currently opens abstractly, with $d(cx)=c\,d(x)$ and $Q_\Delta(cd)\neq c\,Q_\Delta(d)$. **Open with the empirical fact instead, then explain it.** A reviewer who reads "a 4× gain change on an identical waveform moves Total SampEn by +309%" in the first two sentences of Section II is engaged; one who reads a quantizer inequality first has to hold an abstraction in mind while waiting to learn why it matters. The algebra should arrive as the explanation of a number the reader already finds surprising. This costs no space — it is purely an ordering change within II-B.

### A3. Validation chain — classification

The chain is causally convincing: it establishes the symptom, isolates the cause, eliminates the two plausible cheap fixes, and demonstrates the consequence. Nothing in it is unnecessary. But the page-weight is currently misallocated.

| # | Experiment | Classification | Note |
|---|---|---|---|
| 1 | Frozen-code parity | **Essential, but one clause** | Not a subsection and not a sentence of its own. "Our implementation reproduces the frozen reference summaries to 3.6 × 10⁻¹⁵ across 200 windows" belongs inside the first sentence of IV-A. It is a licence to proceed, not a finding |
| 2 | Gain-stress test | **Essential main-paper** | This is the symptom. Give it the headline number, not a table |
| 3 | AvgSampEn control | **Essential main-paper** | Compressible to two sentences plus one table row. It rebuts a named prior-art alternative, which is worth more than its size |
| 4 | Absolute-resolution stress test | **Essential main-paper — currently under-weighted** | `facts_pack` §7 proposes stating this "as one paragraph, cite the repo." I disagree. This is the experiment that converts the paper from "we found a bad constant" into "we characterised a property of the construction." The non-monotonicity in particular is a genuine finding. Keep two rows of the table in the paper |
| 5 | Full-precision no-rounding control | **Essential main-paper — most under-weighted item in the plan** | This is the mechanism-isolating experiment and the strongest single answer to the most dangerous objection. It currently appears fifth in IV-A and is absent from the abstract's emphasis. Promote it: it belongs in the abstract and early in IV-A. See A4 |
| 6 | Cross-channel EHG analysis | **Essential main-paper** | Table 1. Correctly placed |

Supplementary/repository-only: the six-point resolution ladder in full (two rows suffice in the paper), and the per-channel 30-window invariance spot-checks (one clause).

**Nothing should be cut. The problem is weighting, not content.**

### A4. Result ordering in IV-A

**The proposed order is good but not optimal. I recommend one change.**

Proposed: AvgSampEn fails → finer rounding fails → removing quantization restores equivariance → GI restores exact invariance.

The weakness: it eliminates two candidate fixes *before* the reader has been told what the cause is. A reader who does not yet know that the rounding is the mechanism cannot see why bin-count normalization or finer decimals were the natural things to try. The two negative results arrive as unmotivated checks.

**Recommended order — symptom, cause, then elimination of cheap fixes:**

1. **Symptom.** Frozen profile summaries move under positive gain; Total by up to +630% at 7.1×. (Parity folded in as a clause.)
2. **Cause, isolated.** An unrounded profile — no fixed-decimal quantization, and *no* SD normalization — is exactly gain-equivariant on the tested windows. The quantization step, not the profiling concept, is the mechanism.
3. **Cheap fix 1 fails.** Dividing by bin count (AvgSampEn) removes roughly an order of magnitude of the sensitivity but not the invariance failure: 0/60 at every gain.
4. **Cheap fix 2 fails.** Finer absolute rounding does not reliably reduce gain sensitivity, and is non-monotonic across features.
5. **The correction.** SD standardisation before the unchanged profiling stage restores exact invariance, at every tested resolution, independent of bin count.

This ordering has three advantages. The mechanism is named in step 2 rather than step 4, so steps 3 and 4 become motivated tests of obvious alternatives rather than a list. The full-precision control gets the prominence it earns. And the reader reaches step 5 already knowing that the two cheapest fixes have been excluded, which is exactly the state of mind in which a one-line normalization looks like a considered choice rather than a trivial one.

### A5. EHG result positioning

**Keep it after the mechanism validation, as proposed — with one addition.**

Reasoning from the ICASSP reviewer's seat: reviewers are assigned on the signal-processing contribution. A paper that opens with fetal movement in EHG is read as an application paper, and application papers at ICASSP get "single cohort, no external validation" as the *primary* objection rather than a limitation. A paper that opens with a numerical property of an estimator and closes with a physiological consequence is read as a methods paper with a demonstrated payoff, and the cohort question becomes a scope note. The second framing is strictly better here, and the spine already chooses it.

**The addition:** the contribution list at the end of the Introduction must state the EHG consequence in one sentence, so that a reviewer skimming the first column knows a payoff is coming. Without it, three quarters of the paper reads as machinery with no stated destination. The spine's contribution ordering (mechanism → correction → consequence) already does this — make sure the writer does not compress contribution 3 out of existence for space.

Do **not** interweave. Alternating mechanism and physiology in four pages produces a paper that reads as two half-papers.

### A6. Figure and table strategy

**The spine and the facts pack disagree, and this must be resolved before drafting.** The spine specifies Figure 1 = mechanism schematic. `facts_pack` §9 specifies Figure 1 = grouped bar chart of the four-channel effects. Both cannot be the single figure.

**Recommendation: one two-panel Figure 1, carrying mechanism and consequence.**

- **Panel (a) — the mechanism, empirically.** My strong preference is a scatter of frozen Total SampEn against a time-domain amplitude feature, beside the same for GI-Total on shared axes. This shows the mechanism *in the data* rather than as a cartoon, it takes one glance, and it is unarguable. **It depends on a number not currently in the facts pack (§0.3, row 1)** — add it or fall back to the schematic. If you fall back, the schematic must show distances collapsing and separating under gain, not a generic pipeline diagram; a pipeline diagram communicates nothing a sentence cannot.
- **Panel (b) — the consequence.** The grouped bar chart from `facts_pack` §9: channel on the x-axis, standardised estimate on the y-axis, frozen versus GI, faceted by feature, with the zero line drawn. Total's bars crossing zero is the visual the paper is for.

- **Table 1** — the four-channel FM-vs-IN table, exactly as specified in the spine and `facts_pack` §5.4. Agreed, no change.
- **Table 2, if and only if space remains** — two rows of the resolution ladder (coarsest and finest, frozen and GI) plus the AvgSampEn row. This is the compressed form of experiments 3 and 4. If it does not fit, the numbers go in the text; do not cut them to the repository.

Do not spend a figure on the resolution ladder. It is a three-number argument and prose carries it.

### A7. Page allocation

The proposal gives Section III 15–18%, which is close to what Section II gets. For a paper whose experimental design is inherited and whose contribution is entirely in the mechanism and the evidence, that is the wrong balance.

| Section | Proposed | Recommended | Reason |
|---|---|---|---|
| I. Introduction | 15–18% | **14–16%** | Paragraph 3 (prior art and gap) must stay full length; trim paragraph 1 |
| II. Method / mechanism | 20–22% | **20–22%** | Unchanged. This is the intellectual core |
| III. Experimental design | 15–18% | **10–12%** | Inherited design; compress per A1 |
| IV. Results and discussion | 38–42% | **45–48%** | Absorbs the saving. IV-A in particular needs room for five ordered results |
| V. Conclusion | <5% | **3–4%** | Unchanged |

---

## Part B — Citation map

### B1. The 20-paper selection

| # | Citation | Classification | Comment |
|---|---|---|---|
| 1 | Richman & Moorman 2000 | **Essential** | Anchors SampEn and the `r ∝ SD` convention that bounds claim E1 |
| 2 | Lake et al. 2002 | **Expendable** | Overlaps [3] on parameter sensitivity; [3] does the job better for this argument. First candidate for displacement |
| 3 | Yentes et al. 2013 | **Useful** | Verified correct (Ann. Biomed. Eng. 41(2):349–365). Best available "parameters are not innocuous implementation details" citation |
| 4 | Lake & Moorman 2011 | **Essential** | COSEn's explicit scale subtraction is the strongest prior art against a generic-normalization claim. Keep |
| 5 | Udhayakumar et al. 2017 (ApEn profile) | **Essential** | Origin of profiling — and, per §0.3 row 6, the sibling whose implementation does not round. That contrast is worth its slot twice over |
| 6 | Udhayakumar et al. 2018 (SampEn profile) | **Essential — CORE** | Direct parent. Correct |
| 7 | Udhayakumar et al. 2017 (EMBC, secondary measures) | **Useful** | Verified real (DOI 10.1109/EMBC.2017.8037607, PMID 29060648). Supports the lineage of profile summaries |
| 8 | Udhayakumar et al. 2019 (multiscale profiling) | **Expendable** | Supports only "the framework was extended." A grouped cite of [5]–[7] covers the lineage. **Recommended displacement** (see B5) |
| 9 | Karmakar et al. 2020 (profiling review, AvgSampEn) | **Essential — CORE** | Correct, and the map's reviewer-relevance note is exactly right |
| 10 | Keenan et al. 2022 | **Essential — and the map under-rates it** | See below |
| 11 | Li et al. 2015 (DistEn) | **Useful** | The relative-binning versus absolute-quantization contrast is one of your sharpest one-liners. Keep |
| 12 | Karmakar et al. 2017 (DistEn stability) | **Essential — CORE** | The map's claim-discipline note is the most self-aware item in the document. Keep verbatim |
| 13 | Omidvarnia et al. 2018 (RangeEn) | **Essential — CORE** | Correct |
| 14 | Bajić & Japundžić-Žigon 2022 | **Essential — CORE** | The "Important distinction" paragraph is accurate and well drawn. Keep verbatim |
| 15 | Chen et al. 2019 (R packages) | **Useful** | Genre precedent that implementation choices change results. Keep if space |
| 16 | Mischi et al. 2018 | **Essential — CORE** | Keep, but see B4 on over-attribution |
| 17 | Mas-Cabo et al. 2020 | **Useful** | EHG context only. Second candidate for displacement after [2] |
| 18 | Nieto-Del-Amor et al. 2021 | **Useful** | Pre-empts "why not a rank-based entropy?" Worth keeping |
| 19 | Cheng et al. 2022 | **Useful** | Multichannel EHG precedent. **Bibliographic errors — see B4** |
| 20 | Alexandersson et al. 2015 | **Essential — CORE** | Dataset |

**Redundancy:** one real instance, [2] against [3]. Mild overlap in the profiling lineage ([5]/[7]/[8]) where three citations support a claim two would carry.

**Missing and genuinely essential: the reference implementation.** The paper's central factual claim — that distances are quantized at a fixed absolute resolution — is established from released code, not from any of the 20 papers. It must be citable. See B5.

**I recommend against the map's trim order.** `facts_pack`-adjacent "Reference Budget Strategy" lists [10] Keenan first to cut. That is backwards. Keenan et al. (verified: *Physiol. Meas.* 43(2):025008, 2022) applies data-driven entropy profiling to fetal ECG with **TotalSampEn as the primary reported metric**. It is the evidence that TotalSampEn is not an in-house HRV statistic but a summary being used as a biomarker in an independent clinical application by a partly different author group. That is the best available answer to "why does this matter beyond one paper", and in a paper whose weakest point is perceived narrowness, it is worth more than three lineage citations. **Promote [10] to essential; make [8] and [2] the trim candidates.**

**Candidate addition considered and rejected:** NPSampEn (Liu et al., *Entropy* 23(3):267, 2021), which derives the tolerance from the distance distribution. Relevant to the data-driven-tolerance family but does not threaten the gap and does not earn a slot at 20. Do not add.

### B2. Closest prior art — is the distinction accurate?

| Prior art | Map's distinction | Assessment |
|---|---|---|
| Richman & Moorman — conventional SampEn | Scale handling predates us | **Accurate.** Correctly bounds claim E1 |
| Udhayakumar/Karmakar/Palaniswami — profiling | Direct parent; rounding is from code not paper | **Accurate, and well guarded.** The explicit code-versus-paper note on [6] is the map's best feature |
| AvgSampEn ([9]) | Normalizes Total by bin count; does not guarantee gain invariance | **Accurate**, and now empirically supported by `facts_pack` §5.5 |
| Karmakar et al. DistEn / unit-variance ([12]) | SD normalization before a distance-based entropy is prior art | **Accurate and appropriately damaging to your own claim.** Keep exactly as written |
| RangeEn ([13]) | Changes the distance function; broader amplitude class | **Accurate.** The no-superiority-claim discipline is correct |
| Bajić & Japundžić-Žigon ([14]) | Quantization of matching probabilities, not of the distance axis | **Accurate.** This is the correct and defensible distinction |
| Mischi et al. ([16]) | Not a profile; no Total/Avg summaries; no quantization study | **Probably accurate, but currently unverifiable — see B4** |
| Multichannel EHG ([19]) | Cross-channel consistency, not independent replication | **Accurate** framing; bibliographic errors in the entry itself |

### B3. Focused adversarial search for dangerous missing prior art

Searches run against the specific constructs you listed: SampEn profile + amplitude normalization; SampEn profile + gain invariance; entropy profile + scaling; tolerance-profile quantization; rounding of pairwise distances in SampEn; numerical resolution of SampEn tolerance axes; scale-equivariant entropy profiling; AvgSampEn under amplitude scaling; finite-precision effects in entropy profiling; EHG + SampEn profile; EHG + gain/amplitude-invariant entropy.

**Result: I did not identify a paper that directly undermines the proposed gap.**

Specific negative findings worth stating in the paper's own terms:

- **No EHG + entropy-profiling prior art found.** Searches for entropy profile / SampEn profile / TotalSampEn combined with electrohysterography or uterine EMG returned nothing. The application of profiling to EHG appears to originate with your own Access paper, which supports the novelty of the downstream analysis as well as the method.
- **No work found that rounds pairwise distances to a fixed absolute resolution and studies the consequence.** The nearest remains [14] (probability-axis quantization) and the DistEn bin-count line ([11], [12]), both of which the map already distinguishes correctly.
- **No formal derivation of positive-gain invariance for conventional SampEn found** — it is asserted as practice rather than proved. This is favourable to you only in a limited sense: it means nobody has claimed the theorem, but it also means nobody would regard it as a contribution.

**Databases not searched, and therefore not claimed:** Scopus, Web of Science, IEEE Xplore full-text search, ACM DL, non-English literature, and theses. Full texts of [16] and [10] were not accessible. The gap statement must remain bounded to the searched literature, as the map already correctly instructs.

**The one unresolved risk, and it is specific.** [10] Keenan et al. (2022) applies entropy profiling with TotalSampEn to fetal ECG, shares two authors with the profiling lineage, and almost certainly uses the same code path. **If that paper normalizes its input series before profiling, it is prior art for the operation** — not for the diagnosis, and not fatal, since the spine already concedes the operation is not novel. But it would change how paragraph 3 of the Introduction must be written, and it is better found by you than by a reviewer. I could not access the full text. **Read its methods section before drafting.** This is the highest-value remaining literature check, ahead of [16].

### B4. Citation-to-claim mapping — errors found

**Bibliographic errors (verified against Crossref):**

1. **[19] Cheng et al. 2022 — four incorrect author initials.** The map gives "Cheng, Y., Yao, S., Jin, M., Chen, C., Vullings, R., Xu, P., and Mischi, M." The record is **Anyi Cheng, Yang Yao, Yibin Jin, Chuan Chen, Rik Vullings, Lin Xu, Massimo Mischi** — so Cheng A., Yao Y., Jin Y., Xu L. The DOI (10.1109/TBME.2022.3176668), volume 69, issue 12, pages 3728–3738 are all correct.
2. **[16] Mischi et al. 2018 — incorrect initials for one author.** The map gives "Oei, G. S."; the record is **S. G. Guid Oei** (conventionally "Oei, S. G. G."). All other fields correct.
3. **[10] Keenan et al. 2022 — incomplete.** The map gives only "*Physiological Measurement*, 2022". Correct: **43(2), 025008**. Full author list: Keenan, Karmakar, Udhayakumar, Brownfoot, Lakhno, Shulgin, Behar, Palaniswami.
4. **[12] and [17]** are given as "et al." Acceptable in a planning artifact; both must be expanded from the DOI record at BibTeX time. Both papers verified as real and correctly identified.

Verified correct and needing no change: [1], [3] (41(2):349–365), [4], [5], [6], [7], [8], [9], [11], [13], [14], [15], [18] (21(18):6071, Nieto-del-Amor et al.), [20].

**Over-attribution — one instance, and it is in a CORE entry.**

[16] Mischi et al. carries the confident distinction: *"not a SampEn tolerance profile; no TotalSampEn/AvgSampEn profile summaries; no study of fixed absolute distance quantization of a data-derived tolerance axis."* Those are three negative claims about a paper's full text. **The full text has not been read** — the distinction rests on the abstract. The abstract supports "modifications in the tolerance metrics… for improving robustness to EHG amplitude fluctuations" and nothing more granular.

This matters more than a normal over-attribution, because the map's own §B4 instruction is precisely about distinguishing what a paper says from what is inferred, and this entry breaches it. Two actions: mark the [16] distinction **provisional pending full text** in the map, and obtain the full text before the Related Work sentence is written. If their modification turns out to be a per-window amplitude standardisation, the sentence must change.

**Claims correctly flagged as code-based, not paper-based:** [6]'s claim-discipline note is correct and should be preserved verbatim. It is the single most important line in the citation map.

### B5. How to cite the reference implementation

**As a separate numbered bibliography entry, cited alongside [6] at every point where the rounding is asserted.** Not a footnote.

Reasoning. Under IEEE conventions software and datasets are cited as first-class references, and this one carries a factual claim that no paper in the list supports. A footnote signals "incidental"; the rounding step is the object of the paper, and a reviewer checking your central claim must be able to follow a formal citation to it. Every sentence asserting the quantization should read as "the released reference implementation [6], [21]" — never [6] alone, which would attribute the rounding to the published formulation.

Form: authors, title, version or commit, repository, URL, accessed date — with the **commit hash included**. This is not pedantry. Repository content can change; if that line is later edited, a commit-pinned citation keeps the paper's central factual claim verifiable and an unpinned one does not. **If a Zenodo DOI or other archived snapshot can be created, do it** — it converts a mutable URL into a permanent record and costs an afternoon.

**Displacement to stay at 20: remove [8] Udhayakumar et al. 2019 (multiscale profiling).** It is the lineage citation with the least load-bearing work; [5], [6] and [7] carry the lineage without it. If a second slot is ever needed, remove [2] Lake et al. 2002 next, not [10].

---

## Part C — The five strongest reviewer objections

Selected for realism, not coverage. Objections around AvgSampEn, finer decimals, and RangeEn are pre-answered by the current plan and are not among the top five — see the note at the end.

### C1. "The contribution is standard-deviation normalization, which is textbook practice. This is not an ICASSP-level methodological contribution."

**Why it matters.** It is the objection a reviewer forms in the first thirty seconds, from the title and the method equation, before reading the evidence. It merges the "just z-scoring" and "too simple for ICASSP" attacks, which are the same attack.

**Severity: serious but answerable.** Fatal to the current *title framing* if the paper is skimmed; survivable and comfortably answerable if the contribution ordering the spine already specifies survives into the draft.

**Do the current experiments answer it?** Yes — indirectly. The full-precision control and the resolution ladder together show the paper is about the construction, not the operation. But the answer is *evidential*, not rhetorical, and a skimming reviewer may not reach it.

**Does the structure make the answer obvious?** Partly. The spine's contribution ordering (mechanism → correction → consequence) is the right defence, and Section II-C's explicit "do not present the one-line normalization itself as the novelty" is correct. The weak point is the abstract, whose step 3 introduces the GI construction before step 4 establishes that cheaper alternatives fail.

**Change required before writing.** In the abstract, state the failure mechanism and the fact that bin-count normalization and finer rounding do not fix it **before** introducing the SD standardisation. The correction should arrive as the survivor of an elimination, not as the proposal. Also add the amplitude collinearity number if it is promoted into the facts pack (§0.3) — an r² near unity between a "complexity" summary and a plain amplitude statistic is not a finding anyone calls trivial.

### C2. "This is a bug report on one MATLAB implementation, not a signal-processing contribution. The published method contains no rounding, and the authors concede the ideal profile is already gain-equivariant."

**Why it matters.** The reviewer's premise is factually correct on both counts, which makes it the hardest objection to dismiss and the most likely to produce a reject from a reviewer who stops there.

**Severity: serious but answerable.** Not potentially fatal *given the current evidence*, and it was the most dangerous objection before the full-precision control existed.

**Do the current experiments answer it?** Yes, and better than the plan currently conveys. Three independent elements answer it: the full-precision control shows the property is a consequence of the quantization step rather than of an implementation slip; the resolution ladder shows the behaviour persists across an ~82× change in the constant, so it is not a bad choice of Δ; and the sibling ApEn-profile implementation does not round, which makes the rounding a deliberate, method-specific design decision rather than an accident. **The third of these is not in the facts pack or the spine** (§0.3, row 6).

**Does the structure make the answer obvious?** **No — this is the most important structural defect in the plan.** The full-precision control is currently fifth in IV-A and absent from the abstract's emphasis. A reviewer forms this objection while reading Section I and abandons it, or does not, long before reaching IV-A item 5.

**Changes required before writing.** Adopt the A4 reordering so the mechanism isolation is result 2, not result 5. Put the full-precision control in the abstract. Add the ApEn-sibling observation to the facts pack and use it in one sentence of Section II-B. Cite the implementation separately and with a commit hash (B5). And state the general property rather than the instance: the profile summaries are functionals of the ordered count sequence and are preserved under any strictly monotone transformation of the distance multiset — fixed-resolution quantization is many-to-one, hence not order-preserving, hence the failure. That is one sentence, it generalises beyond the specific code, and it is the difference between a bug report and a characterisation.

### C3. "Four channels from the same 112 recordings are not replication, and one public database is not validation. The physiological claim is cohort-specific."

**Why it matters.** It is the standard objection to any biomedical application result at ICASSP, it will be raised by at least one reviewer, and here the channels share the *identical physical windows* — so the effective sample for the replication claim is one cohort, not four.

**Severity: serious but answerable** for the paper as scoped. It would be potentially fatal only if the paper claimed independent replication, which the spine correctly forbids.

**Do the current experiments answer it?** Partially, and honestly. The spine and facts pack both concede it and prescribe "cross-channel consistency" / "spatial consistency within the same cohort." That concession is the right answer and should not be softened. What the plan does *not* currently deploy is the strongest available supporting argument: the pre-registered fixed grid reaches the same conclusion by a methodologically independent route within the same data. That is not replication, but it is meaningfully more than a single analysis choice, and the grid's pre-registration (timestamped, window-ID hashed, selected from baseline windows only before any UC or FM feature existed) is a discipline reviewers reward. It is currently invisible to the reader (§0.3, row 3).

**Does the structure make the answer obvious?** The concession is well placed in IV-C. The supporting argument is missing.

**Change required before writing.** Add one sentence to IV-B reporting the fixed-grid agreement and its pre-registration. Keep every limitation sentence the spine already specifies. Do not attempt to argue the channels are more independent than they are — the concession is load-bearing for the paper's credibility on everything else.

### C4. "Your own results show a single fixed-tolerance SampEn on the normalized signal gives a larger effect than any profile summary. Why is the profile needed?"

**Why it matters.** This objection comes directly out of your own results table once the fixed-r comparator is reported, and it attacks the *premise* of the paper rather than its execution: if one tolerance suffices, the entire finite-resolution profile apparatus — and therefore the problem the paper solves — is optional.

**Severity: serious but answerable.** Under-appreciated in the current plan, which mentions the comparator only in passing in `facts_pack` §10 and gives no number.

**Do the current experiments answer it?** The numbers exist (`results/gate_summary.csv`) but the *argument* does not, anywhere in the spine or facts pack. Two answers are available and both are sound. First, the profile carries shape information no single tolerance can: the fixed-grid slope and centroid summaries are FDR-supported on the primary contrast and have no single-r analogue. Second, and more fundamentally, the paper's object is the correctness of the representation the Access paper *already used* — it explains a published result, it does not propose a competing detector. An ICASSP paper is not obliged to maximise effect size, but it is obliged to be honest about comparators.

**Does the structure make the answer obvious?** No. There is currently no place in the spine where this is addressed.

**Change required before writing.** Report the fixed-r comparator explicitly, with its number, in IV-B — do not leave it in the repository for a reviewer to find. Add two sentences to IV-C giving the answers above. Volunteering an unfavourable comparator reads as rigour; having it discovered reads as concealment, and the difference in reviewer response is large.

### C5. "The corrected summary is not a corrected version of the original — it is a different quantity. Calling this a correction to Total SampEn is misleading."

**Why it matters.** The normalization changes the retained bin count by roughly 60× in your own bench test, which the facts pack candidly reports. A reviewer who notices that will ask whether GI-Total is the same estimand at all, and if it is not, whether the "sign reversal" is a comparison between two different measurements rather than a correction of one.

**Severity: serious but answerable.** Currently unanswered anywhere in the plan, and it is the objection I would raise first if I wanted to reject this paper on substance rather than framing.

**Do the current experiments answer it?** Yes, and unusually well, but the plan does not deploy the answer. The resolution ablation shows GI-Total is essentially unchanged (−0.197 to −0.211) across an ~80× bin-count range, which demonstrates directly that the refinement is not what produces the result — the facts pack §5.3 even says so. The fixed-grid variant, whose resolution is set explicitly rather than inherited from the units, agrees to three decimal places. Together these exclude the refinement explanation empirically.

**Does the structure make the answer obvious?** The ablation is present but is framed in `facts_pack` §4 as a "caveat that had to be checked," which understates it. It is not a caveat; it is the answer to a serious objection.

**Change required before writing.** Reframe the resolution ablation in II-C and IV-A as the *separation experiment* it is, not as a caveat. Add the fixed-grid agreement (§0.3, row 3). And add one sentence to II-C establishing the estimand: the summaries are functionals of the profile over its occupied support, the frozen support's cardinality carries an amplitude term, and GI evaluates the same functional on a support from which that term has been removed — same estimand, identifiable representation.

**Pre-answered objections, listed for completeness and not among the top five:** "AvgSampEn already solved it" (answered empirically, `facts_pack` §5.5, 0/60 at every gain); "use more decimal places" (answered, §5.5, non-monotonic across an ~82× range); "RangeEn already solves amplitude sensitivity" (conceded in scope, no superiority claimed, correct handling); "Mischi already solved it in EHG" (conceded in scope — **but see B4; the distinction is unverified**). The first two are genuinely closed. The fourth is closed only after the full text is read.

---

## Part D — Where the contribution actually resides

### D1. New mathematical method — **weak, and correctly conceded**

SD standardisation is established practice, stated as such by Richman & Moorman, described as "common practice" in the RangeEn paper, and applied before a distance-based entropy measure by Karmakar et al. (2017). The invariance argument is one line that any reader reproduces mentally. The spine is right to instruct that this not be presented as the novelty, and right to forbid "we introduce gain-invariant SampEn." **Contributes close to nothing on its own, and would sink the paper if it were the headline.**

### D2. New failure-mode diagnosis — **strong; this is the contribution**

That a data-derived tolerance support built from distances quantized at a fixed *absolute* resolution loses the scale equivariance of the representation it implements is non-obvious, checkable, and — on the searched literature — uncharacterised. It has three properties good diagnoses have: it is invisible in the published equations, it is consequential, and it generalises beyond the instance (any absolute quantizer inside a data-derived axis, not just this one). The finding that the induced dependence does not diminish across an ~82× range of the constant is what elevates it from an implementation note to a property of the construction. **This is the paper.**

### D3. New validation methodology — **strong, and currently undersold**

The chain — parity, then symptom, then mechanism isolation by removing the suspected cause, then elimination of the two cheapest alternative fixes, then downstream consequence — is a transferable template for auditing any estimator whose behaviour depends on an implementation-level numerical choice. Most papers in this space assert robustness; this one eliminates alternatives. The full-precision control in particular is the kind of experiment that separates a characterisation from an anecdote, precisely because it removes the suspected cause *without* applying the proposed fix.

The plan treats this as robustness testing. It is better than that. **One sentence in the Introduction claiming the validation protocol as a contribution in its own right is justified and costs almost nothing.**

### D4. New downstream inference — **strong, and it is what makes this ICASSP rather than a correspondence note**

Without the EHG result the paper is a numerical observation about an estimator. With it, the paper shows that the numerical choice determines whether a physiological association is detected, and in which direction. That is the consequence that earns four pages. It also carries the paper's honesty burden: the FM/Total comparison is a null-versus-supported contrast, not an overturned finding, and the spine is right to police that — subject to §0.1 and to the scoping correction in Part E.

### Where the novelty resides — for the Introduction

> The novelty is not the normalization and not the invariance argument, both of which are established. It is the identification of a specific, consequential failure mode: a tolerance support constructed from pairwise distances quantized at a fixed absolute resolution inherits an implicit amplitude scale, so a representation that is gain-equivariant in its published form is not gain-equivariant as realised. We show this failure is a property of the construction rather than of a particular resolution, that neither bin-count normalization nor finer quantization removes it, and that correcting it changes the direction and the statistical support of a downstream physiological association in multichannel EHG.

---

## Part E — Claim-safety audit

| # | Claim | Classification | Safer wording where needed |
|---|---|---|---|
| 1 | "SampEn is gain-sensitive." | **Unsafe** | "SampEn computed with a fixed absolute tolerance depends on signal gain; the conventional choice r = k·SD removes this dependence." |
| 2 | "Finite-resolution SampEn profiling is gain-sensitive." | **Safe** | Optional precision: "…when the tolerance support is constructed from distances quantized at a fixed absolute resolution." Use the longer form on first statement |
| 3 | "Entropy profiling is gain-sensitive." | **Unsafe** | Contradicts your own full-precision control. "The SampEn-profile representation becomes gain-sensitive when its tolerance support is built from absolutely quantized distances; the unrounded representation does not." |
| 4 | "We introduce gain-invariant SampEn." | **Unsafe** | "We introduce gain-invariant SampEn *profiling*," with the scope sentence: "we do not claim priority for amplitude-robust entropy estimation, which is well established." |
| 5 | "We introduce gain-invariant SampEn profiling." | **Safe with qualification** | Safe once the scope sentence in row 4 appears in the abstract or the contribution list. Without it, row 4's objection transfers |
| 6 | "Fixed absolute distance quantization breaks gain equivariance." | **Safe** | This is your demonstrated central claim, supported by the full-precision control. State it plainly |
| 7 | "GI profiling removes amplitude effects." | **Unsafe** | "GI profiling removes dependence on constant positive multiplicative gain applied to the analysis window. Within-window amplitude non-stationarity is outside the scope of this invariance." |
| 8 | "GI profiling is invariant to positive multiplicative gain." | **Safe with qualification** | Add the verification clause: "…analytically invariant, verified numerically to within 10⁻⁸ relative tolerance at every tested gain." Analytic plus empirical is stronger than either |
| 9 | "AvgSampEn does not restore gain invariance." | **Safe** | Supported directly by `facts_pack` §5.5 (0/60 at every gain). Optionally add that it removes roughly an order of magnitude of the sensitivity — the concession strengthens it |
| 10 | "Increasing rounding precision does not restore gain invariance." | **Safe** | Supported by §5.5. Report the non-monotonicity as observed; do not describe the trend as improvement |
| 11 | "The unrounded profile is gain-equivariant." | **Safe with qualification** | Bound it to the evidence: "on the tested 12-window subset, at every tested gain, to within the predefined numerical tolerance." The n is small; stating it pre-empts the challenge |
| 12 | "GI-Total reveals a physiological effect." | **Unsafe** | Two problems: "reveals" over-reads an observational association, and SampEn is an irregularity statistic — the profiling literature you cite distinguishes irregularity from complexity. "GI-Total shows a negative, FDR-supported association with annotated fetal-movement windows, consistent with reduced signal irregularity during those windows." |
| 13 | "The FM-associated GI-Total result cannot be attributed to multiplicative gain." | **Safe** | Supported by construction. One clause makes it airtight: "…cannot be attributed to constant multiplicative gain differences between windows; other amplitude-related confounds are not excluded by this argument." |
| 14 | "The result replicates across four EHG channels." | **Unsafe** | "The association is consistent across four median-axis channels of the same recordings (cross-channel consistency within a single cohort), not an independent replication." |

**One scoping correction to the spine's claim boundaries.** The spine bans "the original significant finding was reversed" outright. That ban is **correct for the FM/Total contrast at the frozen resolution used in the Access paper**, where the frozen estimate was null. It is **over-broad as a blanket rule**, because the repository contains at least two cases where an FDR-supported frozen result changes sign or loses support under correction — one in a different contrast, and one at the finest frozen resolution reported in `facts_pack` §5.3, where frozen Total is positive and FDR-supported (+0.154, q = 0.0035) while GI-Total is negative.

Applying the ban paper-wide will cause the writer to understate a real result. **Rewrite the boundary as scoped:** *"For the FM-versus-IN contrast at the reference resolution, frozen Total is statistically null; describe the change as a reversal of the point-estimate direction accompanied by the emergence of FDR support, never as the reversal of a significant finding. Where a frozen result is itself FDR-supported, describe the change accurately."* Whether to bring the second contrast into a four-page paper is a space decision, not a claim-safety decision — but the rule should not make the accurate statement unavailable.

---

## Part F — ICASSP verdict

**Credible ICASSP contribution but framing-sensitive.**

Not "clearly strong enough methodologically," because the proposed method is a standardisation step whose invariance follows from one line of algebra, and because every individual ingredient — SD normalization, profiling, bin-count normalization, amplitude-robust EHG entropy — is published prior art, in two cases by the groups whose work you build on. A reviewer who reads only the method equation has a defensible reject.

Not "borderline/incremental" and not "insufficient novelty," for four reasons.

**Technical novelty.** The diagnosis is real, checkable, absent from the published formulations, and — on the searched literature — uncharacterised. The resolution ladder establishes it as a property of the construction rather than of a constant, which is the difference between a finding and an incident.

**Clarity of the signal-processing contribution.** This is a statement about when a data-derived representation is scale-equivariant, demonstrated on an estimator in active use. That is squarely in ICASSP's territory, and it is stated in the plan in terms a signal-processing reviewer will recognise.

**Completeness of validation.** Unusually strong for four pages: parity at 3.6 × 10⁻¹⁵, exact invariance 65/65, a three-point resolution ladder on both implementations, two named alternative fixes eliminated empirically, a mechanism-isolating control that removes the suspected cause without applying the proposed fix, and a four-channel analysis on 4,083 windows with patient-aware mixed models and FDR control. Most submissions making a claim of this type are supported by less.

**Risk of being read as a bug report.** This is the real risk, and the reason for the verdict rather than the stronger one. It is *currently mitigated by the evidence but not by the structure*: the experiment that defeats the objection sits fifth in the results section and is absent from the abstract's emphasis. The A4 reordering is the highest-leverage change in this review.

**Does the EHG result provide enough consequence?** Yes. Without it this is a note; with it, a numerical implementation choice is shown to determine whether a physiological association is detected and in which direction. That is the payload.

**Relevance to the ICASSP community.** Moderate-to-good and improvable. The finding generalises to any estimator that builds a data-derived support from quantized distances, but the plan currently states it only for SampEn profiling in EHG. One sentence of generalisation in the Conclusion — not overclaimed — would broaden the readership materially. The Keenan citation, showing TotalSampEn in use as a biomarker in an independent clinical application, does more for perceived relevance than three lineage citations.

**Summary judgement.** The gap between the strongest true statement and the strongest tempting statement is unusually wide here. "We introduce gain-invariant SampEn" is refuted by one citation. "Fixed absolute distance quantization breaks the scale equivariance of a data-derived tolerance support, neither bin-count normalization nor finer quantization repairs it, and correcting it changes the inference" is, on the searched literature, unrefuted. Both describe the same work. The plan mostly chooses correctly; the remaining risk is that the facts pack's own narrative language (§0.1) pulls the writer toward the first.

---

## Part G — Recommended changes before drafting

### MUST CHANGE

1. **Reconcile `facts_pack.md` with the spine's claim boundaries** (§0.1). Rewrite §1 and the §8 draft abstract to remove "reverses its apparent finding," "reverses the sign of the original finding," "four independent electrodes," and "replicates." The facts pack is what the writer will follow.
2. **Rewrite `facts_pack` §3's mechanism description** to quantize-then-collect rather than grid-then-retain (§0.2). The current wording contradicts the spine and makes the splitting/merging argument incoherent.
3. **Reorder Section IV-A to symptom → mechanism isolation → cheap fix 1 fails → cheap fix 2 fails → correction** (A4), and put the full-precision control in the abstract. This is the structural answer to objection C2 and the highest-leverage change in this review.
4. **Resolve the Figure 1 conflict** between the spine (schematic) and `facts_pack` §9 (bar chart). Recommended: one two-panel figure carrying mechanism and consequence (A6).
5. **Add a separate bibliography entry for the reference implementation, with commit hash**, cited alongside [6] wherever the rounding is asserted; displace [8] (B5). Archive the code state if at all possible.
6. **Fix the bibliographic errors in [19], [16] and [10]** (B4).
7. **Mark the [16] Mischi distinction as provisional** and obtain the full text before writing the Related Work sentence (B2, B4).
8. **Scope the "no reversal" claim boundary** rather than applying it paper-wide (Part E, closing note).
9. **Add the missing numbers in §0.3 to `facts_pack.md`**, or make an explicit decision not to use each one. In particular the fixed-r comparator (objection C4) and the fixed-grid agreement (objection C5) are currently repository-only and each answers a serious objection.

### SHOULD CHANGE

10. Reallocate pages: Section III down to 10–12%, Section IV up to 45–48% (A7); compress III-B to one paragraph (A1).
11. Open Section II-B with the empirical gain number, then the algebra (A2).
12. Add the ApEn-sibling observation — the released ApEn-profile implementation does not round — to the facts pack and to one sentence of II-B (C2).
13. Add the monotone-transformation sentence to II-B or II-C: profile summaries are functionals of the ordered count sequence and survive any strictly monotone transformation of the distances; fixed-resolution quantization is many-to-one, hence not order-preserving (C2, C5).
14. Add two sentences to IV-C answering "why profile at all?" against the fixed-r comparator (C4).
15. Reframe the resolution ablation from "a caveat that had to be checked" to the separation experiment that answers C5 (C5).
16. Promote [10] Keenan from "first to trim" to essential; make [8] and [2] the trim candidates (B1).
17. Read the Keenan et al. methods section for input normalization before drafting (B3) — highest-value remaining literature check.
18. Rename Section II to "Finite-Resolution SampEn Profiling and Its Scale Behaviour" (A1).
19. State the BH-FDR family explicitly wherever a q-value appears (§0.3, row 5).
20. Add one non-overclaimed sentence of generalisation to the Conclusion (Part F).

### KEEP AS IS

- The mechanism-first story order and the contribution ordering (mechanism → correction → consequence). This is the decision that makes the paper publishable; do not let space pressure invert it.
- No separate Related Work section. Correct for four pages.
- Integrated Results and Discussion. Correct.
- The decision to report that Kurtosis and Skewness did not survive. This is the plan's most credibility-building element — it demonstrates the validation criterion was applied before the results were known, not after.
- The claim-discipline note on citation [6] distinguishing the published formulation from the released implementation. The most important line in the citation map.
- The claim-discipline note on citation [12] (unit-variance normalization is prior art). Self-aware and correct; do not soften it.
- The [14] Bajić "Important distinction" paragraph. Accurate as written.
- The no-superiority-over-RangeEn discipline, and the decision not to run a RangeEn comparison for this submission.
- Table 1 as the four-channel FM-vs-IN table.
- The limitations list in IV-C, unshortened.
- The "cross-channel consistency, not independent replication" language, everywhere it appears.
- The facts pack's discipline that all numbers trace to verified analysis output.

**No additional experiments are recommended.** The five objections in Part C are each answerable from the existing validation chain; what is missing is deployment, not data.

---

## Required final output

### 1. Recommended final manuscript spine

```
Title: Gain-Invariant Sample Entropy Profiling for Electrohysterography
Abstract
Index Terms

I.   INTRODUCTION
     (4 paragraphs: SampEn and tolerance; profiling and its released
      implementation; prior amplitude-robustness work and the narrow gap;
      contributions — mechanism, correction, consequence)

II.  FINITE-RESOLUTION SAMPEN PROFILING AND ITS SCALE BEHAVIOUR
     A. The Finite-Resolution SampEn Profile
     B. Scale Behaviour of the Quantized Tolerance Support
     C. Gain-Invariant Profiling

III. EXPERIMENTAL DESIGN
     A. EHG Data and Statistical Analysis
     B. Validation Protocol            [one paragraph]

IV.  RESULTS AND DISCUSSION
     A. Gain, Quantization, and Resolution
        1) frozen summaries under gain          [symptom; parity as a clause]
        2) unrounded profile is gain-equivariant [mechanism isolated]
        3) bin-count normalization does not suffice
        4) finer absolute quantization does not suffice
        5) GI profiling: exact invariance at every resolution
     B. Cross-Channel EHG Associations
     C. Interpretation and Scope

V.   CONCLUSION

REFERENCES                              [fifth page, references only]
```

Changes from the current spine: Section II renamed; III-B compressed to one paragraph; IV-A reordered so mechanism isolation is result 2; everything else retained.

### 2. Recommended final 20-reference set

Unchanged from the citation map except as noted.

| # | Reference | Status |
|---|---|---|
| 1 | Richman & Moorman 2000 | keep |
| 2 | Lake et al. 2002 | keep (first trim candidate if a slot is needed) |
| 3 | Yentes et al. 2013 | keep — verified 41(2):349–365 |
| 4 | Lake & Moorman 2011 | keep |
| 5 | Udhayakumar et al. 2017, *Nonlinear Dyn.* 88:823–837 | keep |
| 6 | Udhayakumar et al. 2018, *IEEE TBME* 65(11):2569–2579 | keep — CORE |
| 7 | Udhayakumar et al. 2017, EMBC | keep — verified, DOI 10.1109/EMBC.2017.8037607 |
| — | ~~Udhayakumar et al. 2019, *Phys. Rev. E* 100:012405~~ | **REMOVED** — displaced by [20] below |
| 8 | Karmakar et al. 2020, *Entropy* 22(12):1396 | keep — CORE (renumbered) |
| 9 | Keenan et al. 2022, *Physiol. Meas.* **43(2):025008** | keep — **promoted to essential**; bibliographic fields corrected |
| 10 | Li et al. 2015, *Med. Biol. Eng. Comput.* 53:77–87 | keep |
| 11 | Karmakar et al. 2017, *Front. Physiol.* 8:720 | keep — CORE; expand "et al." at BibTeX time |
| 12 | Omidvarnia et al. 2018, *Entropy* 20(12):962 | keep — CORE |
| 13 | Bajić & Japundžić-Žigon 2022, *Entropy* 24(1):73 | keep — CORE |
| 14 | Chen et al. 2019, *Biol. Methods Protoc.* 4(1):bpz016 | keep |
| 15 | Mischi et al. 2018, *IEEE TBME* 65(4):875–884 | keep — CORE; **"Oei, S. G. G."**; distinction provisional pending full text |
| 16 | Mas-Cabo et al. 2020, *Entropy* 22(7):743 | keep (second trim candidate) |
| 17 | Nieto-del-Amor et al. 2021, *Sensors* 21(18):6071 | keep |
| 18 | Cheng et al. 2022, *IEEE TBME* 69(12):3728–3738 | keep — **authors corrected to Cheng A., Yao Y., Jin Y., Chen C., Vullings R., Xu L., Mischi M.** |
| 19 | Alexandersson et al. 2015, *Sci. Data* 2:150017 | keep — CORE |
| 20 | **Reference implementation** — entropy profiling source code, repository, commit hash, accessed date | **ADDED** — CORE; cited alongside [6] wherever the quantization is asserted |

Net: one removal ([8] multiscale profiling), one addition (the reference implementation), total unchanged at 20.

### 3. One-sentence paper identity

> This paper is fundamentally about **the conditions under which a data-derived tolerance representation remains scale-equivariant, and what follows downstream when it does not**, not about **normalizing a signal before computing entropy**.

### 4. Recommended ICASSP story (≈140 words)

Sample entropy profiling replaces a single tolerance with a profile evaluated over a support derived from the data's own pairwise distances. We show that this support is scale-equivariant only when the distances are retained at full precision: quantized at a fixed absolute resolution, as in the released reference implementation, positive gain splits and merges the occupied levels non-uniformly, so the profile is evaluated at non-corresponding tolerances and summaries such as Total SampEn inherit a dependence on gain that the formulation they implement does not have. We isolate the mechanism by removing the quantization alone, and show that neither bin-count normalization nor finer quantization repairs it. Standardizing each window before an otherwise unchanged profiling stage restores exact invariance at every tested resolution. On multichannel electrohysterography, this changes the direction and the statistical support of a fetal-movement association — a numerical choice determining a physiological conclusion.

---

*Verification performed for this review: bibliographic records for citations [3], [7], [10], [16], [17], [18], [19] checked against Crossref or publisher records; focused adversarial searches run against the eleven constructs listed in B3; Scopus, Web of Science, IEEE Xplore full text and non-English literature not searched; full texts of [10] and [16] not accessible.*
