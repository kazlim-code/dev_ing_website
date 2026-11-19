# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Initialized `dev_ing_website` Gleam (`v1.18.1`) project for the multi-page evolution of [kazlim-code/dev-ing](https://github.com/kazlim-code/dev-ing).
- Initialized Git-colocated **Jujutsu (`jj` `v0.43.0`)** repository for regular atomic version control revisions.
- Added core dependencies: `lustre` (`v5.7.1`), `wisp` (`v2.2.2`), `mist` (`v6.0.3`), `gleam_erlang`, `gleam_http`, `simplifile`, `filepath`, and dev dependencies `gleeunit` and `birdie` (`v2.0.2`).
- Documented architecture, Jujutsu workflow, TDD workflow, Birdie snapshot testing, and `////` / `///` doc-comment standards in `AGENTS.md`, `README.md`, and [ADR-0001](docs/decisions/ADR-0001-multi-page-wisp-lustre-bento-architecture.md).
- Copied static icons, fonts, and images from legacy `dev-ing` into `priv/static/`, and authored self-hosted Black & Orange Bento stylesheet `priv/static/styles.css`.
- Implemented theme-parameterized UI primitives (`theme.gleam`, `components/bento.gleam`), pure data layers (`data/project.gleam`, `data/blog.gleam`, `data/resume.gleam`), shared HTML5 layout (`layout.gleam`), and multi-page views (`pages/{home,projects,blog,resume,prototypes,not_found}.gleam`).
- Implemented Candidate A pure renderer + Wisp router (`router.gleam`), Mist server entrypoint (`dev_ing_website.gleam`), and static GitHub Pages exporter (`export.gleam`).
- Added `74` atomic tests and `4` accepted Birdie snapshots across mirrored `test/dev_ing_website/` modules (`wisp/simulate`, feature-gate dual-path tests, symlink/traversal regression tests, and exporter integration tests).
- Documented Stage 4 read-only efficiency findings and deferred triggers in [EFFICIENCY-0001](docs/audits/EFFICIENCY-0001-wisp-lustre-bento-architecture.md).

### Security
- Enforced safe production defaults in `dev_ing_website.gleam` (`DEV_ING_ENV` opt-in for dev flags), strict HTTP security headers + CSP (`script-src 'none'`, `form-action 'none'`, `frame-ancestors 'none'`) wrapping `rescue_crashes`, and matching `<meta http-equiv="Content-Security-Policy">` tags for static exports.
- Hardened static serving and static export against path traversal, percent-encoded dot segments, dotfile exposure (`.DS_Store`), control-character/backslash URL tricks in `context.href`, trailing-slash POSIX `lstat` symlink bypasses, nested `output_dir` recursion, and stale non-empty export targets (verified `findings: []` on Stage 3 Pass #3).
