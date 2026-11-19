//// Unit, HTTP simulation, and Birdie snapshot tests for `dev_ing_website/router` (`T11`–`T18`, `T20`–`T23` + Stage 2 coverage).
////

import birdie
import dev_ing_website/context.{Context, FeatureFlags}
import dev_ing_website/router.{
  Blog, BlogPost, Home, NotFound, Projects, Prototypes, Resume,
}
import dev_ing_website/theme
import filepath
import gleam/http
import gleam/http/response
import gleam/list
import gleam/string
import simplifile
import test_support
import wisp/simulate

/// T11: Verifies core multi-page URL path segments map to typed `Route` variants.
///
pub fn parse_route_core_paths_test() {
  let ctx = context.prod_context("priv/static", "")
  assert router.parse_route([], ctx) == Home
  assert router.parse_route(["projects"], ctx) == Projects
  assert router.parse_route(["blog"], ctx) == Blog
  assert router.parse_route(["blog", "what-is-jj"], ctx)
    == BlogPost("what-is-jj")
  assert router.parse_route(["resume"], ctx) == Resume
}

/// T12: Verifies `/about` maps to the `Resume` route alias.
///
pub fn parse_route_about_alias_maps_to_resume_test() {
  let ctx = context.prod_context("priv/static", "")
  assert router.parse_route(["about"], ctx) == Resume
}

/// T13: Verifies `/prototypes` resolves to `NotFound` when `enable_prototypes_route` is False (`Flag = OFF`).
///
pub fn parse_route_prototypes_returns_not_found_when_flag_off_test() {
  let ctx = context.prod_context("priv/static", "")
  assert router.parse_route(["prototypes"], ctx) == NotFound
}

/// T14: Verifies `/prototypes` resolves to `Prototypes` when `enable_prototypes_route` is True (`Flag = ON`).
///
pub fn parse_route_prototypes_resolves_when_flag_on_test() {
  let ctx = context.dev_context("priv/static")
  assert router.parse_route(["prototypes"], ctx) == Prototypes
}

/// T15: Verifies rendering an unpublished draft post returns 404 when `Flag = OFF`.
///
pub fn render_route_draft_post_returns_404_when_flag_off_test() {
  let prod_ctx = context.prod_context("priv/static", "")
  let #(status, _html) =
    router.render_route(prod_ctx, BlogPost("bento-design-systems-in-gleam"))

  assert status == 404
}

/// T16: Verifies rendering an unpublished draft post returns 200 when `Flag = ON`.
///
pub fn render_route_draft_post_returns_200_when_flag_on_test() {
  let dev_ctx = context.dev_context("priv/static")
  let #(status, html_doc) =
    router.render_route(dev_ctx, BlogPost("bento-design-systems-in-gleam"))

  assert status == 200
  assert string.contains(html_doc, "Design Systems")
  assert string.contains(html_doc, "DRAFT PREVIEW")
}

/// T17: Verifies `/resume` omits the interactive filter bar when `enable_resume_filters` is False (`Flag = OFF`).
///
pub fn render_route_resume_hides_filters_when_flag_off_test() {
  let prod_ctx = context.prod_context("priv/static", "")
  let #(status, html_doc) = router.render_route(prod_ctx, Resume)

  assert status == 200
  assert !string.contains(html_doc, "data-resume-filter-bar")
}

/// T18: Verifies `/resume` renders the interactive filter bar when `enable_resume_filters` is True (`Flag = ON`).
///
pub fn render_route_resume_shows_filters_when_flag_on_test() {
  let ctx_with_filters =
    Context(
      static_directory: "priv/static",
      base_path: "",
      features: FeatureFlags(
        enable_prototypes_route: False,
        enable_unpublished_posts: False,
        enable_resume_filters: True,
      ),
      theme: theme.black_and_orange(),
    )
  let #(status, html_doc) = router.render_route(ctx_with_filters, Resume)

  assert status == 200
  assert string.contains(html_doc, "data-resume-filter-bar")
}

/// Verifies `/blog` index excludes draft posts when `enable_unpublished_posts` is False (`Flag = OFF`).
///
pub fn render_route_blog_index_excludes_draft_when_flag_off_test() {
  let prod_ctx = context.prod_context("priv/static", "")
  let #(status, html_doc) = router.render_route(prod_ctx, Blog)

  assert status == 200
  assert !string.contains(html_doc, "bento-design-systems-in-gleam")
}

/// Verifies `/blog` index includes draft posts when `enable_unpublished_posts` is True (`Flag = ON`).
///
pub fn render_route_blog_index_includes_draft_when_flag_on_test() {
  let dev_ctx = context.dev_context("priv/static")
  let #(status, html_doc) = router.render_route(dev_ctx, Blog)

  assert status == 200
  assert string.contains(html_doc, "bento-design-systems-in-gleam")
}

/// Verifies `/` Home view excludes draft posts when `enable_unpublished_posts` is False (`Flag = OFF`).
///
pub fn render_route_home_excludes_draft_when_flag_off_test() {
  let prod_ctx = context.prod_context("priv/static", "")
  let #(status, html_doc) = router.render_route(prod_ctx, Home)

  assert status == 200
  assert !string.contains(html_doc, "bento-design-systems-in-gleam")
}

/// Verifies 404 NotFound page does not disclose internal feature-gating or draft mechanisms.
///
pub fn render_route_not_found_does_not_leak_gate_details_test() {
  let prod_ctx = context.prod_context("priv/static", "")
  let #(status, html_doc) = router.render_route(prod_ctx, NotFound)

  assert status == 404
  assert !string.contains(html_doc, "gated off")
  assert !string.contains(html_doc, "draft article")
}

/// Verifies `/projects` renders project cards as `<h3>` under `<h2>` category headings.
///
pub fn render_route_projects_uses_h3_under_h2_sections_test() {
  let prod_ctx = context.prod_context("priv/static", "")
  let #(status, html_doc) = router.render_route(prod_ctx, Projects)

  assert status == 200
  assert string.contains(html_doc, "<h2 class=\"bento-subhead")
  assert string.contains(html_doc, "<h3 class=\"bento-card-title")
}

/// Verifies blog article prose uses injected Theme `text_primary_class` rather than hardcoded colors.
///
pub fn render_route_blog_post_uses_theme_primary_text_test() {
  let custom_ctx =
    Context(
      static_directory: "priv/static",
      base_path: "",
      features: context.prod_defaults(),
      theme: test_support.custom_test_theme(),
    )
  let #(status, html_doc) =
    router.render_route(custom_ctx, BlogPost("what-is-jj"))

  assert status == 200
  assert !string.contains(html_doc, "text-zinc-200")
  assert string.contains(html_doc, "cyber-text")
}

/// Verifies resume filter bar uses injected Theme mono and muted classes.
///
pub fn render_route_resume_filter_bar_uses_theme_classes_test() {
  let custom_ctx =
    Context(
      static_directory: "priv/static",
      base_path: "",
      features: FeatureFlags(
        enable_prototypes_route: False,
        enable_unpublished_posts: False,
        enable_resume_filters: True,
      ),
      theme: test_support.custom_test_theme(),
    )
  let #(status, html_doc) = router.render_route(custom_ctx, Resume)

  assert status == 200
  assert string.contains(html_doc, "data-resume-filter-bar")
  assert string.contains(html_doc, "cyber-mono cyber-muted")
}

/// Verifies `exportable_routes` excludes prototypes and drafts when flags are OFF.
///
pub fn exportable_routes_excludes_draft_and_prototypes_when_flag_off_test() {
  let prod_ctx = context.prod_context("priv/static", "")
  let routes = router.exportable_routes(prod_ctx)
  let paths = list.map(routes, fn(pair) { pair.1 })

  assert !list.contains(paths, "prototypes/index.html")
  assert !list.contains(paths, "blog/bento-design-systems-in-gleam/index.html")
}

/// Verifies `exportable_routes` includes prototypes and drafts when flags are ON.
///
pub fn exportable_routes_includes_draft_and_prototypes_when_flag_on_test() {
  let dev_ctx = context.dev_context("priv/static")
  let routes = router.exportable_routes(dev_ctx)
  let paths = list.map(routes, fn(pair) { pair.1 })

  assert list.contains(paths, "prototypes/index.html")
  assert list.contains(paths, "blog/bento-design-systems-in-gleam/index.html")
}

/// T20: Verifies Wisp handler rejects `POST` requests with `405 Method Not Allowed`.
///
pub fn wisp_rejects_post_requests_with_405_test() {
  let prod_ctx = context.prod_context("priv/static", "")
  let res =
    simulate.request(http.Post, "/")
    |> router.handle_request(prod_ctx)

  assert res.status == 405
}

/// Verifies Wisp handler supports `HEAD` requests via `wisp.handle_head`.
///
pub fn wisp_handles_head_request_with_200_test() {
  let prod_ctx = context.prod_context("priv/static", "")
  let res =
    simulate.request(http.Head, "/")
    |> router.handle_request(prod_ctx)

  assert res.status == 200
}

/// Verifies unknown HTTP paths return `404 Not Found`.
///
pub fn wisp_unknown_route_returns_404_test() {
  let prod_ctx = context.prod_context("priv/static", "")
  let res =
    simulate.request(http.Get, "/does-not-exist")
    |> router.handle_request(prod_ctx)

  assert res.status == 404
}

/// Verifies `GET /prototypes` returns 404 over HTTP when `Flag = OFF`.
///
pub fn wisp_prototypes_returns_404_when_flag_off_test() {
  let prod_ctx = context.prod_context("priv/static", "")
  let res =
    simulate.request(http.Get, "/prototypes")
    |> router.handle_request(prod_ctx)

  assert res.status == 404
}

/// Verifies `GET /prototypes` returns 200 over HTTP when `Flag = ON`.
///
pub fn wisp_prototypes_returns_200_when_flag_on_test() {
  let dev_ctx = context.dev_context("priv/static")
  let res =
    simulate.request(http.Get, "/prototypes")
    |> router.handle_request(dev_ctx)

  assert res.status == 200
  assert string.contains(simulate.read_body(res), "Industrial Spec Grid")
}

/// Verifies `handle_request` strips `ctx.base_path` on prefixed requests.
///
pub fn wisp_base_path_routes_prefixed_request_test() {
  let gh_ctx = context.prod_context("priv/static", "/dev_ing")
  let res =
    simulate.request(http.Get, "/dev_ing/resume")
    |> router.handle_request(gh_ctx)

  assert res.status == 200
  assert string.contains(simulate.read_body(res), "Callum Ingley")
}

/// Verifies `handle_request` returns 404 when request path omits configured `ctx.base_path`.
///
pub fn wisp_base_path_rejects_unprefixed_request_with_404_test() {
  let gh_ctx = context.prod_context("priv/static", "/dev_ing")
  let res =
    simulate.request(http.Get, "/resume")
    |> router.handle_request(gh_ctx)

  assert res.status == 404
}

/// Verifies static asset middleware serves `/static/styles.css` with 200.
///
pub fn wisp_serves_static_css_file_test() {
  let prod_ctx = context.prod_context("priv/static", "")
  let res =
    simulate.request(http.Get, "/static/styles.css")
    |> router.handle_request(prod_ctx)

  assert res.status == 200
}

/// Verifies dot-dot path traversal under `/static` is blocked with 404.
///
pub fn wisp_blocks_static_dot_dot_traversal_test() {
  let prod_ctx = context.prod_context("priv/static", "")
  let res =
    simulate.request(http.Get, "/static/....//gleam.toml")
    |> router.handle_request(prod_ctx)

  assert res.status == 404
}

/// Verifies percent-encoded path traversal under `/static` is blocked with 404.
///
pub fn wisp_blocks_static_encoded_traversal_test() {
  let prod_ctx = context.prod_context("priv/static", "")
  let res =
    simulate.request(http.Get, "/static/%2e%2e/gleam.toml")
    |> router.handle_request(prod_ctx)

  assert res.status == 404
}

/// Verifies `POST` to a static path returns `405 Method Not Allowed`.
///
pub fn wisp_rejects_post_to_static_with_405_test() {
  let prod_ctx = context.prod_context("priv/static", "")
  let res =
    simulate.request(http.Post, "/static/styles.css")
    |> router.handle_request(prod_ctx)

  assert res.status == 405
}

/// Verifies HTTP responses include strict security headers.
///
pub fn wisp_sets_security_headers_test() {
  let prod_ctx = context.prod_context("priv/static", "")
  let res =
    simulate.request(http.Get, "/")
    |> router.handle_request(prod_ctx)

  assert response.get_header(res, "x-content-type-options") == Ok("nosniff")
  assert response.get_header(res, "x-frame-options") == Ok("DENY")
  assert response.get_header(res, "referrer-policy")
    == Ok("strict-origin-when-cross-origin")
  let assert Ok(csp) = response.get_header(res, "content-security-policy")
  assert string.contains(csp, "script-src 'none'")
  assert string.contains(csp, "form-action 'none'")
}

/// Verifies dotfiles under `/static` (such as an existing `.DS_Store`) are blocked with 404.
///
pub fn wisp_blocks_static_dotfiles_test() {
  let static_dir = "/tmp/dev_ing_website_stage3_static_dotfile_test"
  let _ = simplifile.delete(static_dir)
  let assert Ok(Nil) = simplifile.create_directory_all(static_dir)
  let assert Ok(Nil) =
    simplifile.write(
      to: filepath.join(static_dir, ".DS_Store"),
      contents: "secret",
    )

  let prod_ctx = context.prod_context(static_dir, "")
  let res =
    simulate.request(http.Get, "/static/.DS_Store")
    |> router.handle_request(prod_ctx)

  let _ = simplifile.delete(static_dir)
  assert res.status == 404
}

/// Verifies percent-encoded dotfiles under `/static` are blocked with 404.
///
pub fn wisp_blocks_static_encoded_dotfiles_test() {
  let prod_ctx = context.prod_context("priv/static", "")
  let res =
    simulate.request(http.Get, "/static/%2eDS_Store")
    |> router.handle_request(prod_ctx)

  assert res.status == 404
}

/// Verifies static prefix matching requires a `/` segment boundary (rejecting `/staticstyles.css`).
///
pub fn wisp_rejects_unseparated_static_prefix_collision_test() {
  let prod_ctx = context.prod_context("priv/static", "")
  let res =
    simulate.request(http.Get, "/staticstyles.css")
    |> router.handle_request(prod_ctx)

  assert res.status == 404
}

/// Verifies rendered HTML documents include a `<meta http-equiv="Content-Security-Policy">` tag.
///
pub fn layout_includes_meta_csp_for_static_hosting_test() {
  let prod_ctx = context.prod_context("priv/static", "")
  let #(_status, html_doc) = router.render_route(prod_ctx, Home)

  assert string.contains(html_doc, "http-equiv=\"Content-Security-Policy\"")
}

/// T21: Verifies `GET /` via `wisp/simulate` returns 200 and matches the Home page Birdie snapshot.
///
pub fn home_page_wisp_snapshot_test() {
  let prod_ctx = context.prod_context("priv/static", "")
  let res =
    simulate.request(http.Get, "/")
    |> router.handle_request(prod_ctx)

  assert res.status == 200
  res
  |> simulate.read_body
  |> birdie.snap(title: "home_page_bento_view")
}

/// T22: Verifies `GET /projects` via `wisp/simulate` returns 200 and matches the Projects page Birdie snapshot.
///
pub fn projects_page_wisp_snapshot_test() {
  let prod_ctx = context.prod_context("priv/static", "")
  let res =
    simulate.request(http.Get, "/projects")
    |> router.handle_request(prod_ctx)

  assert res.status == 200
  res
  |> simulate.read_body
  |> birdie.snap(title: "projects_page_bento_view")
}

/// T23: Verifies `GET /resume` via `wisp/simulate` returns 200 and matches the Living Resume Birdie snapshot.
///
pub fn living_resume_page_wisp_snapshot_test() {
  let prod_ctx = context.prod_context("priv/static", "")
  let res =
    simulate.request(http.Get, "/resume")
    |> router.handle_request(prod_ctx)

  assert res.status == 200
  res
  |> simulate.read_body
  |> birdie.snap(title: "living_resume_page_bento_view")
}
