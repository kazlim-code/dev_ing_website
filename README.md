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
- `/blog` & `/blog/:slug` — **Blog**: Technical articles & learning journal (*What is Dev_Ing*, *Experimenting with VCS other than Git (Jujutsu)*)
- `/resume` — **Living Resume**: Dedicated living engineering resume covering Callum Ingley's career history, frameworks, tooling, and featured work
- `/prototypes` — **Design Prototypes**: Multi-page layout experimentation in the black & orange theme

## Roadmap

### Version 1 (Completed — Structure, Themeable Components & Static Export)
- [x] Ground-up multi-page architecture in Gleam (`v1.18.1`), Wisp (`v2.2.2`), and Lustre (`v5.7.1`).
- [x] Generic, reusable, **theme-parameterized UI component architecture** (`src/dev_ing_website/theme.gleam` & `src/dev_ing_website/components/`) shipped with a self-hosted **Black & Orange Bento Grid** default theme and isolated component tests.
- [x] Core routes (`/`, `/projects`, `/blog`, `/blog/:slug`, `/resume` Living Resume) tested with `wisp/simulate` and `birdie` snapshots (`74` tests passing).
- [x] Static multi-page HTML exporter (`gleam run -m dev_ing_website/export`) for zero-cost **GitHub Pages** hosting alongside local Wisp server support.

### Version 2 (Upcoming Work — Fun Design Systems, Interactive Resume & Live Hosting)
- [ ] **v2.1 — Fun & Cool Design System Prototyping**: Prototype and compare expressive visual design systems to flesh out the look of the site, leveraging the v1 theme-parameterized component architecture (superseding the early `glelements` POC).
- [ ] **v2.2 — Live Hosted BEAM Server**: Migrate from static GitHub Pages export to a hosted Wisp + Mist server deployment (e.g., Fly.io, Railway, or VPS) with zero view rewrites.
- [ ] **v2.3 — Standout, Fun & Interactive Living Resume (`/resume`)**: Make interactivity central on `/resume`—clear, functional, and genuinely fun to explore (interactive skill/stack filtering, interactive timeline/case-study views, and print/PDF mode).
- [ ] **v2.4 — Dynamic Blog CMS & OTP Features**: Introduce dynamic content management, tag/search filtering, and optional database persistence or OTP actor services on the live BEAM server.

## Development, Testing & Version Control (`jj`)

This project follows **Test-Driven Development (TDD)** and uses **Jujutsu (`jj`)** with regular atomic commits/revisions:

```sh
# Run unit, route, and Birdie snapshot tests
gleam test

# Review and accept/reject Birdie snapshots interactively
gleam run -m birdie

# Run the Wisp development server (defaults to prod flags; set DEV_ING_ENV=dev for prototypes & drafts)
DEV_ING_ENV=dev gleam run

# Export static multi-page HTML into dist/ for GitHub Pages (optional DEV_ING_BASE_PATH, defaults to /dev_ing)
gleam run -m dev_ing_website/export

# Format Gleam source files
gleam format

# Check Jujutsu status & revision log
jj status
jj log

# Record a regular atomic revision
jj commit -m "feat: description of change"
```
