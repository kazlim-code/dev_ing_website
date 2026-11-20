# ROADMAP.md — `dev_ing_website`

This roadmap tracks upcoming features, queued bug fixes, priority efficiency & asset actions, architectural suggestions, and documentation/developer experience (DX) items for Callum Ingley's multi-page Gleam + Wisp + Lustre portfolio and engineering blog (`dev_ing`).

---

## 1. Upcoming Features

### Version 1.0 — Core Multi-Page Foundation & Static Export (Completed — See [ADR-0001](docs/decisions/ADR-0001-multi-page-wisp-lustre-bento-architecture.md))
- [x] **F1.1 — Wisp + Lustre SSR Core Pipeline (`context`, `router`, `layout`)**:
  - Idiomatic Wisp middleware pipeline, typed `Route` parser (`/`, `/projects`, `/blog`, `/blog/:slug`, `/resume`, `/prototypes`), security headers + CSP, and shared HTML5 document shell ([ADR-0001](docs/decisions/ADR-0001-multi-page-wisp-lustre-bento-architecture.md)).
- [x] **F1.2 — Generic, Theme-Parameterized UI Component Architecture (`theme`, `components/`)**:
  - Reusable, generic UI components (`bento.grid`, `bento.card`, `bento.card_with_heading`, `bento.badge`, `bento.section_header`, `bento.tech_badges`) parameterized by typed `Theme`, `CardTone`, `BentoSpan`, and `BadgeTone` options and isolated unit + Birdie snapshot tests.
  - Shipped v1 with self-hosted **Black & Orange Bento Grid** styling (`priv/static/styles.css`, `#09090b` canvas, `#18181b` cards, `#f97316` orange accents).
- [x] **F1.3 — Typed Content Modules & Living Resume (`data/project`, `data/blog`, `data/resume`)**:
  - Pure Gleam data modules for Personal & Work projects (`Dev.Ing`, `Glelements`, `Wyrd Technology`, `Grafa`), blog posts (`what-is-dev-ing`, `what-is-jj`, plus gated draft `bento-design-systems-in-gleam`), and a dedicated **Living Resume** page (`/resume` with `/about` alias).
- [x] **F1.4 — Hybrid GitHub Pages Static Multi-Page Exporter (`export`)**:
  - CLI command (`gleam run -m dev_ing_website/export`) rendering all enabled routes (`dist/index.html`, `dist/projects/index.html`, `dist/blog/index.html`, `dist/blog/<slug>/index.html`, `dist/resume/index.html`, `dist/about/index.html`, `dist/404.html`, `.nojekyll`) and strictly copying non-dotfile, symlink-free `priv/static/` assets.
- [x] **F1.5 — Feature Gating & Dark-Launch Config (`Context` Flag Accessors)**:
  - Typed feature flags in `Context` (`enable_prototypes_route`, `enable_unpublished_posts`, `enable_resume_filters`) accessed through pure query helpers (`context.prototypes_enabled(ctx)`, etc.), defaulting safely to `False` in production exports and live server runs unless `DEV_ING_ENV=dev`.

### Version 2.0 — Design System Prototyping, Fun Interactive Resume & Live BEAM Hosting (Upcoming)
- [ ] **F2.1 — Fun & Cool Design System Prototyping (Fleshing Out the Look & Feel)**:
  - Discuss, prototype, and compare expressive, standout design systems and theme variations using the v1 theme-parameterized component architecture and `/prototypes` switcher (moving away from the standalone `glelements` POC library in favor of in-repo, AI-accelerated, testable themeable components).
  - Explore bespoke card treatments, view transitions, refined typography hierarchy, and hybrid layout accents (Terminal CLI, Editorial Split, Industrial Spec, and new playful themes).
- [ ] **F2.2 — Dedicated Live BEAM Hosting (Wisp + Mist Server Deployment)**:
  - Deploy the live Wisp + Mist HTTP server to a BEAM-friendly host (Fly.io, Railway, or VPS) with zero view rewrites.
- [ ] **F2.3 — Standout, Fun & Highly Interactive Living Resume (`/resume`)**:
  - Interactivity is **KEY** on `/resume`: make the page stand out as crystal-clear, functional, and genuinely fun to explore (interactive technology/skill filtering, playful interactive timeline/role inspection, print/PDF-ready mode, and rich engineering case studies for Wyrd Technology and Grafa).
- [ ] **F2.4 — Dynamic Blog CMS, Runtime Feature Flag Toggling (OTP / DB) & Telemetry**:
  - Add runtime feature-flag toggling without redeployment on the live BEAM server (backed by an in-memory OTP Actor / ETS cache hydrated from SQLite/PostgreSQL or an admin endpoint, plugged directly into `context.*_enabled(ctx)`).
  - Add dynamic blog post management, tag/search filtering, and OTP actor services.

---

## 2. Queued Bug Fixes & Legacy Cleanups (Porting from `kazlim-code/dev-ing`)

- [x] **B1.1 — Fix Legacy Bio Typo**: Corrected `"such  s Git"` to `"such as Git"` in `src/dev_ing_website/data/resume.gleam` ([ADR-0001](docs/decisions/ADR-0001-multi-page-wisp-lustre-bento-architecture.md)).
- [x] **B1.2 — Decouple `Project` Data Type from Lustre `Attribute(a)`**: Removed the phantom `a` type parameter so `Project` records are 100% pure data in `src/dev_ing_website/data/project.gleam`.
- [x] **B1.3 — Enable & Gate `what-is-jj` Blog Post Cleanly**: Published `what-is-jj` and modeled `published: Bool` on `BlogPost` gated by `enable_unpublished_posts` in `src/dev_ing_website/data/blog.gleam`.
- [x] **B1.4 — Eliminate GitHub Pages SPA 404 Routing Hack**: Replaced client-side `modem` SPA routing with real `<route>/index.html` directories generated by `src/dev_ing_website/export.gleam`.
- [x] **B1.5 — Strip EXIF `GPS-Data` & Resize Hero Portrait (`priv/static/me.jpg`)** *(from [EFFICIENCY-0001](docs/audits/EFFICIENCY-0001-wisp-lustre-bento-architecture.md) `E1`)*:
  - Stripped Samsung `GPS-Data` EXIF metadata and resized `priv/static/me.jpg` from `256K` (`2944×2208`) to `176×176` (`~4.8 KB` JPEG) for the `88×88 px` hero portrait.
- [x] **B1.6 — Fix Corrupt `JetBrainsMono-Regular.woff2` Font Asset** *(from [EFFICIENCY-0001](docs/audits/EFFICIENCY-0001-wisp-lustre-bento-architecture.md) `E2`)*:
  - Removed corrupt legacy `priv/static/fonts/JetBrainsMono-Regular.woff2` (Google 404 HTML page), its `@font-face` rule in `priv/static/styles.css`, and the broken `<link rel="preload">` from `src/dev_ing_website/layout.gleam` (optionally bundle a valid Latin-subset `.woff2` in `F2.1`).
- [ ] **B1.7 — Generalize `T07` Private Contact Assertions (`resume_test.gleam`)** *(from Stage 2 `blind-rev` `m11`)*:
  - Replace hardcoded legacy street/phone substring checks in `resume_omits_private_contact_details_test` with pattern checks (no digits-only phone numbers or street suffixes) so real string fragments are not persisted in tests.

---

## 3. Priority Efficiency & Asset Action Queue (From `EFFICIENCY-0001`)

Action items and trigger-gated optimizations sourced from [EFFICIENCY-0001](docs/audits/EFFICIENCY-0001-wisp-lustre-bento-architecture.md).

### Completed Immediate Asset Fixes
- [x] **E1 / B1.5** — Strip EXIF `GPS-Data` and resize `priv/static/me.jpg` (`256K` -> `4.8K`, `176×176`).
- [x] **E2 / B1.6** — Remove corrupt `JetBrainsMono-Regular.woff2` (Google 404 HTML page) and broken `@font-face`/preload (optionally bundle a valid Latin-subset `.woff2` in `F2.1`).

### Priority Next-Up Actions
- [ ] **E3** — Prune or manifest-filter unreferenced `priv/static/` payload (`under-construction.png` `1.0M`, `glelements.css` `4.6K`, 28 unused icons `~700 KB`) and resize rendered project icons `<= 96 px` (`~83%` smaller static bundle; already `>100 KB`).
- [ ] **E6** — Replace recursive `strip_leading_slashes` in `src/dev_ing_website/router.gleam` with single-pass prefix scanning and precompute `static_prefix` once at startup (cheap, eliminates `O(n^2)` slash-run CPU cost).
- [ ] **E4** — Add `Cache-Control` headers (`max-age=300` HTML, `max-age=86400` / hashed `immutable` static assets) and gzip/brotli compression for live BEAM hosting (`F2.2`).

### Deferred Scale-Triggered Optimizations
*(Implement ONLY when the numeric trigger threshold fires)*
- [ ] **E5** (`>500 static req/s` or `>50 page views/s`): Startup symlink-free static manifest in `persistent_term`/ETS (`src/dev_ing_website/router.gleam`).
- [ ] **E7** (`>2,000` files in one directory or `>10,000` total): Prepend + single `list.reverse` in `export.copy_directory_strict` (`src/dev_ing_website/export.gleam`).
- [ ] **E8** (`>2 s` export wall time or `>500` pages / `>1,000` files): Reuse rendered HTML across route aliases (`/resume` & `/about`) and parallelize at scale (`src/dev_ing_website/export.gleam`, `src/dev_ing_website/router.gleam`).
- [ ] **E9** (`>5` posts on Home or `>100` posts): Pre-sort `all_posts()`, skip sorting in `find_by_slug`, and cap Home at `list.take(posts, 3)` (`src/dev_ing_website/data/blog.gleam`, `src/dev_ing_website/pages/home.gleam`).
- [ ] **E10** (`>50 page req/s per core` or HTML `>100 KB`): Stream `to_document_string_tree` via `wisp.string_tree_body` and memoize prod HTML per `Route` in `persistent_term` (`src/dev_ing_website/router.gleam`).
- [ ] **E11** (`>1,000 page req/s` or `>200` links / `>500` cards per page): Precompute normalized `base_path`/static URLs and cache repeated theme class strings (`src/dev_ing_website/context.gleam`, `src/dev_ing_website/theme.gleam`).

---

## 4. Architecture & Testing Suggestions

- **S3.1 — Theme-Parameterized Generic Component Testing Matrix (Trigger: Every new component in `src/dev_ing_website/components/`)**:
  - Rather than maintaining an external `glelements` package, keep generic UI components in `src/dev_ing_website/components/` parameterized by a `Theme` / `Variant` record so feeding in new theming options in v2 can be snapshot-tested across variants in isolation.
- **S3.2 — Retire Static Export Flag When Live BEAM Host Is Active (Trigger: Completion of `F2.2`)**:
  - Once `dev_ing_website` runs on a live BEAM host in v2.2, transition GitHub Pages to a redirect or retire `export.gleam`.
- **S3.3 — Retire `feature.prototypes_route.enabled` Gate (Trigger: After v2.1 visual design sign-off)**:
  - Keep `/prototypes` gated behind `Context.features.enable_prototypes_route` (ON in dev via `DEV_ING_ENV=dev`, OFF in prod) until v2.1 visual experiments conclude.
- **S3.4 — Retire Legacy Copy Typo Test (`T06`) (Trigger: First v1/v2 content copy rewrite)**:
  - `resume_summary_fixes_legacy_git_typo_test` (`test/dev_ing_website/data/resume_test.gleam`) is a one-time migration guard for `B1.1`; remove it once resume copy diverges from the legacy `dev-ing` text.

---

## 5. Documentation & Developer Experience (DX)

- [x] **D1.1 — Comprehensive Local Development, Static Preview & Verification Guide (`README.md`)**:
  - **Live Wisp + Mist Server (`http://localhost:8000`)**: Document production-parity mode (`gleam run`, feature flags OFF where `/prototypes` and draft posts return `404`), development mode (`DEV_ING_ENV=dev gleam run` / `DEV_ING_ENV=development`, unlocking `/prototypes` and draft posts such as `bento-design-systems-in-gleam`), and all active routes (`/`, `/projects`, `/blog`, `/blog/what-is-dev-ing`, `/blog/what-is-jj`, `/resume` & `/about`, plus dev-only `/prototypes`).
  - **Static GitHub Pages Export (`dist/`) Local Preview**: Document why default `gleam run -m dev_ing_website/export` uses `DEV_ING_BASE_PATH="/dev_ing"` (which causes 404s if served at `/` locally), local root preview (`DEV_ING_BASE_PATH="" gleam run -m dev_ing_website/export` + `python3 -m http.server 8080 --directory dist`), and subpath build check (`DEV_ING_BASE_PATH="/<repo-name>" gleam run -m dev_ing_website/export`).
  - **Local Verification Commands**: Document `gleam test` (`75` tests + `4` Birdie snapshots), `gleam format --check`, and `gleam run -m birdie`.
