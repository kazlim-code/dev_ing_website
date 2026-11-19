//// Unit, HTTP simulation, and Birdie snapshot tests for `dev_ing_website/router` (`T11`–`T18`, `T20`–`T23`).
////

import birdie
import dev_ing_website/context.{Context, FeatureFlags}
import dev_ing_website/router.{
  Blog, BlogPost, Home, NotFound, Projects, Prototypes, Resume,
}
import dev_ing_website/theme
import gleam/http
import gleam/string
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

/// T20: Verifies Wisp handler rejects `POST` requests with `405 Method Not Allowed`.
///
pub fn wisp_rejects_post_requests_with_405_test() {
  let prod_ctx = context.prod_context("priv/static", "")
  let response =
    simulate.request(http.Post, "/")
    |> router.handle_request(prod_ctx)

  assert response.status == 405
}

/// T21: Verifies `GET /` via `wisp/simulate` returns 200 and matches the Home page Birdie snapshot.
///
pub fn home_page_wisp_snapshot_test() {
  let prod_ctx = context.prod_context("priv/static", "")
  let response =
    simulate.request(http.Get, "/")
    |> router.handle_request(prod_ctx)

  assert response.status == 200
  response
  |> simulate.read_body
  |> birdie.snap(title: "home_page_bento_view")
}

/// T22: Verifies `GET /projects` via `wisp/simulate` returns 200 and matches the Projects page Birdie snapshot.
///
pub fn projects_page_wisp_snapshot_test() {
  let prod_ctx = context.prod_context("priv/static", "")
  let response =
    simulate.request(http.Get, "/projects")
    |> router.handle_request(prod_ctx)

  assert response.status == 200
  response
  |> simulate.read_body
  |> birdie.snap(title: "projects_page_bento_view")
}

/// T23: Verifies `GET /resume` via `wisp/simulate` returns 200 and matches the Living Resume Birdie snapshot.
///
pub fn living_resume_page_wisp_snapshot_test() {
  let prod_ctx = context.prod_context("priv/static", "")
  let response =
    simulate.request(http.Get, "/resume")
    |> router.handle_request(prod_ctx)

  assert response.status == 200
  response
  |> simulate.read_body
  |> birdie.snap(title: "living_resume_page_bento_view")
}
