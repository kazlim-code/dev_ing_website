# Learning Note: `wisp/simulate` & Hybrid Static Multi-Page Export in Gleam

- **Date:** 2026-11-19
- **Related ADR:** [ADR-0001: Multi-Page Wisp + Lustre Bento Architecture](../decisions/ADR-0001-multi-page-wisp-lustre-bento-architecture.md)
- **Tags:** `Gleam`, `Wisp`, `Lustre`, `SSR`, `Static Export`, `Testing`

---

## 1. What Problem Were the Two Spikes Solving?

In v1 of `dev_ing_website`, the site runs in **two modes** from the exact same Gleam codebase:
1. **Live Wisp Server (`gleam run`)**: Serves pages dynamically over HTTP at `http://localhost:8000` (and on a live BEAM server in v2).
2. **Static Exporter (`gleam run -m dev_ing_website/export`)**: Generates static `.html` files into `dist/` (`dist/index.html`, `dist/resume/index.html`, etc.) so the site can be hosted on **GitHub Pages** for free right now.

The architectural question tested by Spike A and Spike B was: **How should `export.gleam` produce the HTML strings for each page to write to `dist/`?**

---

## 2. What `wisp/simulate` Actually Does

Normally, a `wisp.Request` is created by the **Mist** web server when a browser opens a real TCP socket. Because `wisp.Request` wraps an opaque internal network connection type (`HttpRequest(internal.Connection)`), you cannot construct a `wisp.Request` directly by calling a constructor in your own code.

**`wisp/simulate`** (which replaced `wisp/testing` in Wisp v2) is Wisp's built-in **mock HTTP utility** for testing your server in memory without opening a network port:

- `simulate.request(http.Get, "/resume")` builds a synthetic, in-memory `wisp.Request` (using a dummy host `wisp.example.com` and a test secret key).
- You pass that synthetic request into `router.handle_request(req, ctx)` and receive a `wisp.Response`.
- `simulate.read_body(response)` unwraps the response body back into a Gleam `String` of HTML.

---

## 3. Candidate A vs. Candidate B

### Candidate B — The "Fake HTTP Loopback" Approach (`wisp/simulate` in `src/`)
- **How it works**: `export.gleam` imports `wisp/simulate` inside `src/`, pretends to be a browser sending fake `GET "/resume"` HTTP requests to `router.handle_request`, and saves `simulate.read_body(response)` to `dist/resume/index.html`.
- **Potential Benefit**: The static export goes through the exact same HTTP entry point (`handle_request`), URL path splitter, and Wisp middleware stack (`log_request`, `rescue_crashes`) as a live browser request.
- **Downsides discovered during Spike B**:
  1. **Test Helper in Production Code**: It pulls a test utility (`wisp/simulate`, with its dummy `default_secret_key_base`) into production `src/` code.
  2. **Stringly-Typed**: `export.gleam` has to loop over raw URL strings like `"/resume"` and manually assert `response.status == 200` (or `404` for `404.html`).
  3. **Middleware Side Effects**: Every exported file triggers Wisp's HTTP console logger and crash-rescue middleware (which could catch a crash and silently write a `500 Internal Server Error` HTML page into `dist/`).

### Candidate A — The "Shared Pure Function" Approach (`render_route` in `src/`, `wisp/simulate` in `test/`)
- **How it works**: Separates **HTML generation** from **HTTP transport**:
  - `render_route(ctx, Resume)` is a pure Gleam function that accepts a typed `Route` enum (`Home`, `Projects`, `Blog`, `BlogPost(slug)`, `Resume`, etc.) and returns `#(200, "<!doctype html>...")`.
  - **Wisp (`handle_request`)** parses the incoming request's URL segments into a `Route`, calls `render_route(ctx, route)`, and wraps the result in `wisp.html_response(html, status)`.
  - **Static Exporter (`export.gleam`)** loops over a typed `List(#(Route, String))` and calls `render_route(ctx, route)` directly—no fake HTTP requests needed.
- **Where `wisp/simulate` is used in Candidate A**: It stays strictly inside `test/dev_ing_website_test.gleam` to test HTTP routing, method checks, feature-flag 404s, and Wisp middleware.
