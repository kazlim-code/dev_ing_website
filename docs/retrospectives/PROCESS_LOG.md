# Process Retrospective Log (`PROCESS_LOG.md`)

Tracks mid-workflow user corrections, friction points, and process improvements captured during `architect-plan` and `tdd-and-blind-audit` cycles.

---

## Pending Process Retrospective Items

1. **[2026-11-11] Voice STT Disambiguation for Gleam Ecosystem Terms & GitHub Handles**:
   - **Observation**: Voice transcription misheard Gleam's `"Lustre"` framework as `"Lustre.js"` and GitHub handle `"kazlim-code/dev-ing"` as `"chasm-code/dev_ing"`.
   - **Process Improvement**: Always treat `"Lustre"` in a Gleam workspace as the pure Gleam Hex package (`lustre`), never a JS library; when a spoken GitHub repo returns 404, immediately check `gh repo list` to resolve phonetic spelling and hyphen vs. underscore naming (`dev-ing` vs `dev_ing`).

2. **[2026-11-18] Capturing Deferred Scope into `ROADMAP.md` (v1 vs. v2)**:
   - **Observation**: During Socratic scoping questions (`ask_question`), the user shared both immediate v1 priorities (clean structure, basic Black & Orange Bento theme, Living Resume page, static GitHub Pages compatibility) and future v2 ambitions (visual polish, live BEAM hosting, dynamic features).
   - **Process Improvement**: Every time an option is deferred during Socratic scoping ("for v1 let's do X, eventually in v2 I want Y"), automatically record the deferred items in `ROADMAP.md` under upcoming version milestones in the same turn.

3. **[2026-11-18] Checking `/Users/callum/Documents/antigravity/.agents/skills/` for Newly Created Skills**:
   - **Observation**: Custom skills may live in `/Users/callum/Documents/antigravity/.agents/skills/` in addition to `~/.gemini/antigravity/scratch/antigravity-skills/skills/`.
   - **Process Improvement**: When a user references a newly created skill, verify `<skills>` in the prompt context and check `/Users/callum/Documents/antigravity/.agents/skills/<skill-name>/SKILL.md`.

4. **[2026-11-18] Wisp v2 API Change (`wisp/testing` -> `wisp/simulate`)**:
   - **Observation**: Phase 1 repo slicing (`Slice B` & `Slice C`) discovered that `wisp v2.2.2` replaced the v1 `wisp/testing` module with `wisp/simulate` (`simulate.request`, `simulate.read_body`).
   - **Process Improvement**: Always slice installed package sources in `build/packages/<pkg>/src/` during Phase 1 before writing test specifications so deprecated v1 module names never enter test plans.

5. **[2026-11-18] Isolated Subagent Worktrees in `JJ_Git` Repositories (`jj workspace add`)**:
   - **Observation**: Calling `invoke_subagent` with `Workspace: "share"` fails in Git-colocated Jujutsu repositories (`share workspace not supported for VCS type JJ_Git`).
   - **Process Improvement**: In `JJ_Git` repos, create isolated shared Jujutsu worktrees in `<appDataDir>/brain/<conversation-id>/scratch/spike_<name>` using `jj workspace add <path> --name spike_<name>`, run the parallel subagent spikes inside those directories, and clean them up afterwards with `jj workspace forget spike_<name>` and `rm -rf`.

6. **[2026-11-19] Render Phase 2 Spike Metrics in Chat Before Calling `ask_question`**:
   - **Observation**: Calling `ask_question` in the same tool batch immediately after receiving subagent spike results displays the question modal *before* the assistant's markdown text response renders, so the user sees the question without the spike metrics, charts, or snippets.
   - **Process Improvement**: Either present the full Phase 2 spike comparison (table, `xychart-beta`, architecture diagram, and code snippets) in the chat response first (or embed the summary directly in the prompt/artifact) before prompting for the decision gate.

7. **[2026-11-19] Atomic, Single-Responsibility Unit Tests in TDD Matrix**:
   - **Observation**: The initial Phase 3 TDD matrix bundled multiple routes, flag states (`OFF` and `ON`), and Birdie snapshots into composite test functions (`T04`, `T05`, `T07`–`T09`).
   - **Process Improvement**: Design every test in the Phase 3 TDD Specification Matrix to test **one behavior or assertion target at a time** (separate `_flag_off_test` vs. `_flag_on_test`, one route or snapshot per test), only bundling assertions when fixture setup cost (such as a full filesystem export) justifies sharing setup.

7. **[2026-11-19] Explain "What Problem the Spikes Solve & What the Framework Mechanism Does" in Phase 2 Reports**:
   - **Observation**: Presenting raw spike metrics (`LOC`, `wisp/simulate` import counts) without first explaining in plain terms what problem the two spikes are solving and what `wisp/simulate` actually does under the hood left the architectural trade-off unclear until explained in a follow-up.
   - **Process Improvement**: Every Phase 2 spike report and ADR must open with a short, plain-English **Conceptual Overview** explaining (1) the problem being solved, (2) how the underlying library/framework mechanism works, and (3) the concrete trade-off between Candidate A and Candidate B.
