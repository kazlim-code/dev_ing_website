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
