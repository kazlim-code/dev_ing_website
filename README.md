# dev_ing_website

**Callum Ingley's** personal developer website, portfolio, and engineering blog (`dev_ing`), built as a **multi-page web application (MPA)** using **Gleam**, **Wisp**, and **Lustre** in a signature **black and orange** theme.

## Background & Prior Version

- **Previous Version (SPA):** [https://kazlim-code.github.io/dev_ing](https://kazlim-code.github.io/dev_ing) ([github.com/kazlim-code/dev-ing](https://github.com/kazlim-code/dev-ing))
  - Originally built as a single-page application (SPA) using **Gleam**, **Lustre**, `modem`, and Tailwind CSS v4 (`orange-500` primary / `zinc-950` dark surface).
- **Current Version (MPA):** Evolves `dev_ing` into a server-rendered **multi-page application** powered by **Wisp** (`wisp`) and **Lustre** (`lustre/element` & `lustre/attribute`), preserving the black and orange palette while introducing a redesigned layout and strict TDD with **Birdie** snapshot testing.

## Tech Stack

- **Language:** [Gleam](https://gleam.run/) (`v1.18.1`) on the Erlang/BEAM runtime
- **Web Server & Routing:** [Wisp](https://hexdocs.pm/wisp/) (`v2.2.2`) + [Mist](https://hexdocs.pm/mist/) (`v6.0.3`)
- **HTML & UI Framework:** [Lustre](https://hexdocs.pm/lustre/) (`v5.7.1`) — pure Gleam declarative HTML/UI framework
- **Testing & Snapshots:** [Gleeunit](https://hexdocs.pm/gleeunit/) + [Birdie](https://hexdocs.pm/birdie/) (`v2.0.2`)
- **Version Control:** [Jujutsu (`jj`)](https://jj-vcs.github.io/jj/latest/) (`v0.43.0`, Git-colocated)

## Multi-Page Routes & Content

- `/` — **Home**: Clean Black & Orange Bento Grid showcase of work, projects, and latest learnings
- `/projects` — **Projects & Work**: Personal projects (`Dev.Ing`, `Glelements`) and professional work (`Wyrd Technology`, `Grafa`)
- `/blog` & `/blog/:slug` — **Blog**: Technical articles & learning journal — published posts (`what-is-dev-ing`, `what-is-jj`) and dev-only draft posts (`bento-design-systems-in-gleam`)
- `/resume` (alias `/about`) — **Living Resume**: Dedicated living engineering resume covering Callum Ingley's career history, frameworks, tooling, and featured work
- `/prototypes` — **Design Prototypes** *(dev only)*: Multi-page layout experimentation in the black & orange theme (`DEV_ING_ENV=dev`; returns `404` in production mode)

## Roadmap

### Version 1 (Completed — Structure, Themeable Components & Static Export)
- [x] Ground-up multi-page architecture in Gleam (`v1.18.1`), Wisp (`v2.2.2`), and Lustre (`v5.7.1`).
- [x] Generic, reusable, **theme-parameterized UI component architecture** (`src/dev_ing_website/theme.gleam` & `src/dev_ing_website/components/`) shipped with a self-hosted **Black & Orange Bento Grid** default theme and isolated component tests.
- [x] Core routes (`/`, `/projects`, `/blog`, `/blog/:slug`, `/resume` Living Resume) tested with `wisp/simulate` and `birdie` snapshots (`75` tests passing, including `4` Birdie snapshots).
- [x] Static multi-page HTML exporter (`gleam run -m dev_ing_website/export`) for zero-cost **GitHub Pages** hosting alongside local Wisp server support.

### Version 2 (Upcoming Work — Fun Design Systems, Interactive Resume & Live Hosting)
- [ ] **v2.1 — Fun & Cool Design System Prototyping**: Prototype and compare expressive visual design systems to flesh out the look of the site, leveraging the v1 theme-parameterized component architecture (superseding the early `glelements` POC).
- [ ] **v2.2 — Live Hosted BEAM Server**: Migrate from static GitHub Pages export to a hosted Wisp + Mist server deployment (e.g., Fly.io, Railway, or VPS) with zero view rewrites.
- [ ] **v2.3 — Standout, Fun & Interactive Living Resume (`/resume`)**: Make interactivity central on `/resume`—clear, functional, and genuinely fun to explore (interactive skill/stack filtering, interactive timeline/case-study views, and print/PDF mode).
- [ ] **v2.4 — Dynamic Blog CMS & OTP Features**: Introduce dynamic content management, tag/search filtering, and optional database persistence or OTP actor services on the live BEAM server.

## Running Locally

### 1. Live Wisp + Mist Server (`http://localhost:8000`)

The live HTTP server (`src/dev_ing_website.gleam`) listens on **`http://localhost:8000`** (`mist.port(8000)`).

- **Production-parity mode (default):**

  ```sh
  gleam run
  ```

  `DEV_ING_ENV` defaults to `"prod"` (`context.prod_context`), keeping all experimental feature flags **OFF**. Production routes work normally, while `/prototypes` and unpublished draft posts return **`404`**.

- **Development mode (feature flags ON):**

  ```sh
  DEV_ING_ENV=dev gleam run
  ```

  Setting `DEV_ING_ENV=dev` (or `DEV_ING_ENV=development`) switches to `context.dev_context`, enabling `enable_prototypes_route` and `enable_unpublished_posts` (`enable_resume_filters` remains `False` for v2). This unlocks `/prototypes` and draft posts such as `/blog/bento-design-systems-in-gleam`.

#### Active Local Routes

| Route | Mode | Description |
| :--- | :--- | :--- |
| `/` | Always enabled | Home (Black & Orange Bento Grid) |
| `/projects` | Always enabled | Personal & commercial projects |
| `/blog` | Always enabled | Blog post index |
| `/blog/what-is-dev-ing` | Always enabled | Published post: *What is Dev_Ing?* |
| `/blog/what-is-jj` | Always enabled | Published post: *Experimenting with VCS other than Git (Jujutsu)* |
| `/resume` (or `/about`) | Always enabled | Living Resume |
| `/prototypes` | Dev only (`DEV_ING_ENV=dev`) | Design system switcher (`404` in prod mode) |
| `/blog/bento-design-systems-in-gleam` | Dev only (`DEV_ING_ENV=dev`) | Draft post: *Bento Design Systems in Gleam & Lustre* (`404` in prod mode) |

### 2. Previewing the Static GitHub Pages Export (`dist/`) Locally

`gleam run -m dev_ing_website/export` always exports with production feature flags **OFF** (`context.prod_context`) and cleans/rewrites `dist/` (which is gitignored). By default, `DEV_ING_BASE_PATH` defaults to `"/dev_ing"` for GitHub Pages project hosting, so all generated stylesheets, images, and internal links are prefixed with `/dev_ing/...`. Serving that default `dist/` directory at `/` locally causes **`404`** responses for CSS, static assets, and links.

- **Local root preview (serve `dist/` at `http://localhost:8080/`):**

  ```sh
  DEV_ING_BASE_PATH="" gleam run -m dev_ing_website/export
  python3 -m http.server 8080 --directory dist
  ```

  Then open **`http://localhost:8080/`** in your browser.

- **Subpath build check (GitHub Pages project path):**

  ```sh
  # Default GitHub Pages subpath (/dev_ing)
  gleam run -m dev_ing_website/export

  # Or override for another repository subpath
  DEV_ING_BASE_PATH="/<repo-name>" gleam run -m dev_ing_website/export
  ```

## Local Verification & Version Control (`jj`)

This project follows **Test-Driven Development (TDD)** and uses **Jujutsu (`jj`)** with regular atomic commits/revisions:

```sh
# Run all unit, route, security, export, and Birdie snapshot checks (75 tests + 4 snapshots)
gleam test

# Verify Gleam code formatting without modifying files
gleam format --check

# Format Gleam source and test files
gleam format

# Interactively review and accept/reject Birdie snapshots
gleam run -m birdie

# Check Jujutsu status & revision log
jj status
jj log

# Record a regular atomic revision
jj commit -m "feat: description of change"
```
