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

- `/` — **Home**: Hero overview, What's New, Featured Personal Projects (`Dev.Ing`, `Glelements`), and Latest Blog Posts
- `/projects` — **Projects & Work**: Personal projects (`Dev.Ing`, `Glelements`) and professional work (`Wyrd Technology`, `Grafa`)
- `/blog` & `/blog/:slug` — **Blog**: Technical articles including *What is Dev_Ing* and *Experimenting with VCS other than Git (Jujutsu)*
- `/about` — **About**: Callum Ingley's background, frameworks & tooling, career history, and hobbies
- `/prototypes` — **Design Prototypes**: Live multi-page layout comparison in the black & orange theme

## Development, Testing & Version Control (`jj`)

This project follows **Test-Driven Development (TDD)** and uses **Jujutsu (`jj`)** with regular atomic commits/revisions:

```sh
# Run unit, route, and Birdie snapshot tests
gleam test

# Review and accept/reject Birdie snapshots interactively
gleam run -m birdie

# Run the Wisp development server
gleam run

# Format Gleam source files
gleam format

# Check Jujutsu status & revision log
jj status
jj log

# Record a regular atomic revision
jj commit -m "feat: description of change"
```
