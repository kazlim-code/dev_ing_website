# AGENTS.md — Developer & AI Agent Guidelines

## Project Overview

`dev_ing_website` is **Callum Ingley's** personal developer website, portfolio, and engineering blog (`dev_ing`), built as a **multi-page application (MPA)** in **Gleam**.

### Lineage & Reference
- **Legacy SPA URL:** [https://kazlim-code.github.io/dev_ing](https://kazlim-code.github.io/dev_ing) (`https://kazlim-code.github.io/dev-ing`)
- **Legacy SPA Repository:** [https://github.com/kazlim-code/dev-ing](https://github.com/kazlim-code/dev-ing)
- The previous iteration (`dev-ing`) was a single-page application (SPA) built with Gleam (`v1.13.0`), Lustre (`v5.4.0`), and `modem`.
- This project evolves `dev_ing` into a server-rendered **multi-page architecture (MPA)** using **Gleam** (`v1.18.1`), **Wisp** (`v2.2.2`), **Mist** (`v6.0.3`), and **Lustre** (`v5.7.1`), keeping the signature **black and orange** (`orange-500` primary / `zinc-950` dark surface) palette while redesigning the layout.

## Core Technical Rules

1. **Pure Gleam Stack (Gleam + Wisp + Lustre):**
   - Use **Lustre** (`lustre` on Hex) as the Gleam HTML/UI framework (`lustre/element`, `lustre/element/html`, `lustre/attribute`), **not** "Lustre.js".
   - Use **Wisp** (`wisp`) with **Mist** (`mist`) for multi-page HTTP routing, static asset serving (`priv/static`), and request handling.
   - Render full HTML pages on the server using `lustre/element.to_document_string(view)` passed to `wisp.html_response(html, 200)`.

2. **Version Control with Jujutsu (`jj`) & Regular Commits:**
   - Use **Jujutsu (`jj` `v0.43.0`)** as the primary version control system (`jj git init --colocate`).
   - **Regular Commits / Revisions:** Commit changes on a regular basis after every logical unit of work (e.g., updating docs, adding tests, implementing a route or component) using `jj commit -m "<message>"` or the `@` / `@-` workflow (`jj describe`, `jj new`, `jj squash`).
   - Always check `jj status` and `jj log` to keep the revision history clean, atomic, and well-described.

3. **Test-Driven Development (TDD) & Snapshot Testing (`birdie`):**
   - **Strict TDD Workflow:** Write or update failing unit/route/snapshot tests in `test/` *before* implementing new routes, components, or data transformations.
   - **Atomic, Single-Responsibility Tests:** Test **one behavior or condition per test function** (e.g., separate `_when_flag_off_test` and `_when_flag_on_test` functions, and one Birdie snapshot per test function). Only bundle multiple assertions in a single test when they verify facets of the exact same outcome or when test fixture setup (such as full static directory export to disk) is too costly to repeat per assertion.
   - **Mirrored Test Directory Structure:** Keep `test/dev_ing_website_test.gleam` strictly as the single `gleeunit.main()` entry point, place shared non-test helpers in `test/test_support.gleam`, and organize tests in mirrored `test/dev_ing_website/<module>_test.gleam` files matching `src/dev_ing_website/` 1:1 so files stay focused for both human maintainers and AI context reading.
   - **Unit & Route Assertions (`gleeunit` + `wisp/simulate`):** Test Wisp route handlers directly using `wisp/simulate` (`simulate.request(http.Get, path)` and `simulate.read_body(response)` — note `wisp/simulate` replaced `wisp/testing` in Wisp v2).
   - **Snapshot Testing (`birdie`):** Use [Birdie](https://hexdocs.pm/birdie/) (`birdie.snap(content:, title:)`) to snapshot rendered Lustre HTML views (`element.to_readable_string` / `element.to_document_string`) and multi-page responses so layout or markup regressions are caught explicitly.
   - Run `gleam test` continuously during red-green-refactor cycles, and review snapshots via `gleam run -m birdie`.

4. **Design, Theming & Reusable Component Architecture (Black & Orange):**
   - Preserve the signature **black and orange** default theme (`--color-primary: orange-500` `#f97316` / `#ff6b00` on deep carbon/zinc surfaces `zinc-900` / `zinc-950` `#09090b`, with `JetBrains Mono` accents).
   - **Critical Component Rule:** Structure all UI components (`src/dev_ing_website/components/`) and theme definitions (`src/dev_ing_website/theme.gleam`) as generic, reusable, theme-parameterized primitives (accepting explicit theme options/variants rather than hardcoding page-specific markup) so components can be easily reused, unit/snapshot-tested in isolation, and fed new design-system variations in v2 (replacing the standalone `glelements` POC).

5. **Multi-Page Navigation (MPA) & Content Structure:**
   - Semantic multi-page routes:
     - `/` — Home (Clean Black & Orange Bento Grid showcase of work, Featured Personal Projects: `Dev.Ing`, `Glelements`, Latest Blog Posts)
     - `/projects` — Projects & Work Portfolio (`Dev.Ing`, `Glelements`, `Wyrd Technology`, `Grafa`)
     - `/blog` & `/blog/:slug` — Engineering Blog & Learning Journal (`what-is-dev-ing`, `what-is-jj`)
     - `/resume` (and `/about` alias) — Living Resume covering Callum Ingley's career experience, skills/frameworks, and projects
     - `/prototypes` — Interactive design switcher for comparing multi-page layouts
   - Share layout primitives (navigation header, footer, `<head>` metadata) across pages via `src/dev_ing_website/layout.gleam` and `src/dev_ing_website/components/bento.gleam`.
   - Support both running Wisp dynamically (`gleam run`) and exporting static multi-page HTML (`dist/`) for GitHub Pages in v1, paving the way for live BEAM hosting, richer visual polish (`glelements`), and dynamic CMS features in v2.

6. **Gleam Documentation & Code Style Standards:**
   - Document every module at the top of the file (before imports) using `////` comments, ending with a blank `////` line followed by an empty line.
   - Document every public function before its definition using `///` comments, ending with a blank `///` line.
   - Keep `README.md`, `AGENTS.md`, and `CHANGELOG.md` (following [Keep a Changelog 1.1.0](https://keepachangelog.com/en/1.1.0/)) synchronized with architectural changes.
   - Always verify with `gleam test` and `gleam format --check` before considering a task complete.
