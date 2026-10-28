# Research validation protocol and audit

**Audit date:** 2026-10-29  
**Overall audit severity:** low

## Validation rule

Before calling a computational result a scientific verification, trace the information flow from primitive inputs to the reported observable. Different files, seeds, solvers, or languages are not independent if they share the critical answer, reduction, implementation, reference, or adaptive selection step.

Use these terms strictly:

- **analytic prediction only** — no independent computation;
- **consistency check** — the prediction/equivalent quantity is inserted;
- **independent defining-formula check** — a more primitive exact formula is evaluated without inserting the claimed result;
- **independent dynamics/inference solve** — the parent ODE/PDE/SDE/inference problem is solved without inserting the answer;
- **cross-method replication at [layer]** — genuinely different methods agree at a named layer;
- **end-to-end validation** — the check starts upstream of the critical reduction and tests the actual parent object;
- **oracle/post-hoc diagnostic** — forbidden target/teacher information influenced method/protocol choice;
- **reference-informed evaluation** — target knowledge fixes an evaluation location/protocol;
- **conditional MC uncertainty** — sampling uncertainty with data/model/reference choices fixed;
- **finite-width evidence** / **scaling-consistent** — finite-size evidence without an established infinite-size result.

## Required validation card

For each consequential numerical check record:

- CLAIM_UNDER_TEST
- TARGET_LAYER
- PRIMITIVE_INPUTS
- THEORY_HARDCODED_IN_SOLVER
- UPSTREAM_SHARED_ASSUMPTIONS
- END_TO_END
- NUMERICAL_OBSERVABLE
- FALSIFICATION_CRITERION
- CONVERGENCE_PARAMETERS
- TRUE_INDEPENDENT_STATISTICAL_UNIT
- UNCERTAINTY_INCLUDED
- UNCERTAINTY_OMITTED
- ORACLE_OR_TARGET_INFORMATION_USED
- POST_SELECTION_OR_ADAPTIVITY
- VERIFICATION_STATUS

Also check train/tune/test reuse, post-selection, pseudoreplication, MCMC autocorrelation/ESS, paired randomness, shared implementation, numerical refinement, approximation-layer changes, fit-window selection, and reference uncertainty.

## Repository-specific audit findings

1. The test data cite Abramowitz & Stegun tables/pages, which is a genuine external reference source for those tabulated special-function values. Those comparisons can be described as **independent defining-formula/reference checks at the tested points**.
2. Algebraic/inverse identities computed entirely with this package remain consistency checks because both sides can share implementation errors.
3. Agreement at tabulated points does not automatically validate downstream ODE/physics calculations that use the package in other parameter regimes.

## Validation card for the central current/legacy check

- **CLAIM_UNDER_TEST:** special-function implementation matches authoritative tabulated values.
- **TARGET_LAYER:** library function values.
- **PRIMITIVE_INPUTS:** mathematical definitions and A&S reference points.
- **THEORY_HARDCODED_IN_SOLVER:** reference values live in tests, not implementation.
- **UPSTREAM_SHARED_ASSUMPTIONS:** internal routines may be shared across identities.
- **END_TO_END:** yes for the tested function values only.
- **NUMERICAL_OBSERVABLE:** function output at cited points.
- **FALSIFICATION_CRITERION:** mismatch with external table beyond stated precision.
- **CONVERGENCE_PARAMETERS:** algorithmic precision/parameter regime.
- **TRUE_INDEPENDENT_STATISTICAL_UNIT:** deterministic.
- **UNCERTAINTY_INCLUDED:** reference/roundoff tolerance.
- **UNCERTAINTY_OMITTED:** untested-domain algorithmic error.
- **ORACLE_OR_TARGET_INFORMATION_USED:** external tables are legitimate test references.
- **POST_SELECTION_OR_ADAPTIVITY:** legacy table selection.
- **VERIFICATION_STATUS:** independent reference checks at cited table points; identity tests are consistency checks.

## Highest-value next independent check

Add one modern high-precision cross-check (e.g. DLMF/mpmath/Arb-derived) in a difficult parameter regime not covered by the legacy tables.

Preserve historical outputs and adaptive history. A new safeguard does not retroactively make an old run prospective or independent.
