# Process Retrospective Log (`PROCESS_LOG.md`)

Tracks mid-workflow user corrections, friction points, and process improvements captured during `architect-plan` and `tdd-and-blind-audit` cycles.

---

## 1. Pending Process Retrospective Items

*None pending.*

---

## 2. Promoted & Handed Off Process Evolutions

- **[Item 9] Gleam `simplifile` & Wisp Static Serving Symlink / Trailing-Slash Pitfalls** → **Promoted to [`AGENTS.md`](../../AGENTS.md) (Rule 7)** (`chore(process)`):
  - Enforced segment-boundary static prefix matching, dotfile blocking, trailing-slash stripping before `simplifile.link_info`, segment-by-segment symlink rejection, `copy_directory_strict`, `simplifile.resolve` nesting guards, and `file` asset verification.
- **[Items 2, 4, 5, 6, 7, 8, 10] Cross-Project Agentic Planning, TDD & Blind Audit Improvements** → **Approved for Promotion via `antigravity` Handoff Prompt**:
  - **Item 2 (`[2026-11-18]`)**: Capture deferred scope (`v1` vs `v2`) directly into `ROADMAP.md` during Socratic scoping (`architect-plan`).
  - **Item 4 (`[2026-11-18]`)**: Slice installed package/dependency sources (e.g., `build/packages/<pkg>/src/` for Wisp v2 `wisp/simulate`) during Phase 1 before authoring test specifications (`architect-plan`).
  - **Item 5 (`[2026-11-18]`)**: Create isolated worktrees via `jj workspace add <path> --name spike_<name>` instead of `Workspace: "share"` in `JJ_Git` repositories (`architect-plan`).
  - **Item 6 (`[2026-11-19]`)**: Present Phase 2 spike metrics/diagrams in chat before calling `ask_question` (or keep modal prompts self-contained) (`architect-plan`).
  - **Item 7 (`[2026-11-19]`)**: Enforce atomic, single-responsibility unit tests (`_flag_off_test` vs `_flag_on_test`, one assertion target per test) in Phase 3 TDD matrices & Stage 1 (`architect-plan`, `tdd-and-blind-audit`).
  - **Item 8 (`[2026-11-19]`)**: Open every Phase 2 spike report & ADR with a plain-English **Conceptual Overview** explaining the problem solved and underlying framework mechanism (`architect-plan`).
  - **Item 10 (`[2026-11-19]`)**: Commit per stage (`Stage 1B` / `Stage 2` / `Stage 3`), keep alternating cross-family security passes until `findings: []`, and run `file`/metadata checks on imported binary assets during Stage 4 (`tdd-and-blind-audit`).

---

## 3. Archived One-Off / Project-Specific Notes

1. **[2026-11-11] Voice STT Disambiguation for Gleam Ecosystem Terms & GitHub Handles**:
   - Voice transcription misheard Gleam's `"Lustre"` as `"Lustre.js"` and `"kazlim-code/dev-ing"` as `"chasm-code/dev_ing"`. Already codified in [`AGENTS.md`](../../AGENTS.md) Rule 1; archived as project-specific.
3. **[2026-11-18] Checking `/Users/callum/Documents/antigravity/.agents/skills/` for Newly Created Skills**:
   - Session-specific path discovery note (prompt `<skills>` already lists exact active paths); archived as one-off note.
