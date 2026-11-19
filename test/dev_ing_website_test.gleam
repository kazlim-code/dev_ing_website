//// Atomic, single-responsibility TDD and Birdie snapshot test suite (`T01`–`T24`).
////

import birdie
import dev_ing_website/components/bento
import dev_ing_website/context.{Context, FeatureFlags}
import dev_ing_website/data/blog
import dev_ing_website/data/project
import dev_ing_website/data/resume
import dev_ing_website/export
import dev_ing_website/router.{
  Blog, BlogPost, Home, NotFound, Projects, Prototypes, Resume,
}
import dev_ing_website/theme.{
  type Theme, BadgeOrangeSolid, OrangeAccent, SpanHalf, SpanThird, SpanTwoThirds,
  Theme,
}
import filepath
import gleam/http
import gleam/list
import gleam/option.{Some}
import gleam/string
import gleeunit
import lustre/element
import lustre/element/html
import simplifile
import wisp/simulate

/// Runs the gleeunit test suite.
///
pub fn main() -> Nil {
  gleeunit.main()
}

/// Helper that returns a custom test theme for verifying generic component parameterization.
///
fn custom_test_theme() -> Theme {
  Theme(
    name: "cyber-test",
    canvas_class: "cyber-canvas",
    text_primary_class: "cyber-text",
    text_muted_class: "cyber-muted",
    accent_text_class: "cyber-accent",
    font_mono_class: "cyber-mono",
    grid_class: "cyber-grid",
    card_base_class: "cyber-card-base",
    card_default_class: "cyber-card-default",
    card_orange_accent_class: "cyber-custom-card",
    card_orange_solid_class: "cyber-card-solid",
    badge_neutral_class: "cyber-badge-neutral",
    badge_orange_outline_class: "cyber-badge-outline",
    badge_orange_solid_class: "cyber-custom-badge",
    nav_shell_class: "cyber-nav",
    nav_link_active_class: "cyber-nav-active",
    nav_link_inactive_class: "cyber-nav-inactive",
  )
}

// =============================================================================
// A. Theme & Generic Component Tests (T01–T05)
// =============================================================================

/// T01: Verifies `theme.resolve_card_class` combines span and orange accent classes.
///
pub fn theme_resolve_card_class_test() {
  let default_theme = theme.black_and_orange()
  let resolved =
    theme.resolve_card_class(default_theme, SpanTwoThirds, OrangeAccent)

  assert string.contains(resolved, "md:col-span-2")
  assert string.contains(resolved, "orange-500")
}

/// T02: Verifies `theme.resolve_badge_class` resolves the solid orange badge classes.
///
pub fn theme_resolve_badge_class_test() {
  let default_theme = theme.black_and_orange()
  let resolved = theme.resolve_badge_class(default_theme, BadgeOrangeSolid)

  assert string.contains(resolved, "bg-orange-500")
}

/// T03: Verifies `bento.card` injects a custom Theme rather than hardcoding classes.
///
pub fn bento_card_injects_custom_theme_test() {
  let rendered =
    bento.card(
      theme: custom_test_theme(),
      span: SpanThird,
      tone: OrangeAccent,
      eyebrow: Some("01 // TEST"),
      title: "Custom Themed Card",
      children: [html.p([], [element.text("Body")])],
    )
    |> element.to_string

  assert string.contains(rendered, "cyber-custom-card")
}

/// T04: Verifies `bento.badge` injects a custom Theme rather than hardcoding classes.
///
pub fn bento_badge_injects_custom_theme_test() {
  let rendered =
    bento.badge(
      theme: custom_test_theme(),
      tone: BadgeOrangeSolid,
      label: "Gleam",
    )
    |> element.to_string

  assert string.contains(rendered, "cyber-custom-badge")
}

/// T05: Snapshots a generic Black & Orange Bento card via Birdie.
///
pub fn bento_card_black_and_orange_snapshot_test() {
  bento.card(
    theme: theme.black_and_orange(),
    span: SpanHalf,
    tone: OrangeAccent,
    eyebrow: Some("FEATURED // COMPONENT"),
    title: "Reusable Bento Primitive",
    children: [
      html.p([], [
        element.text(
          "Theme-parameterized Lustre card tested in isolation with Birdie.",
        ),
      ]),
      bento.tech_badges(
        theme: theme.black_and_orange(),
        tone: BadgeOrangeSolid,
        items: ["Gleam", "Wisp", "Lustre"],
      ),
    ],
  )
  |> element.to_readable_string
  |> birdie.snap(title: "generic_bento_card_black_and_orange")
}

// =============================================================================
// B. Pure Data & Bugfix Verification Tests (T06–T10)
// =============================================================================

/// T06: Verifies legacy typo `"such  s Git"` (B1.1) is absent from resume data.
///
pub fn resume_summary_fixes_legacy_git_typo_test() {
  let data = resume.callum_resume()
  assert !string.contains(data.summary, "such  s Git")
}

/// T07: Verifies Living Resume data uses city/state and omits private street address or phone.
///
pub fn resume_omits_private_contact_details_test() {
  let data = resume.callum_resume()
  assert data.location == "Newcastle, NSW"
  assert !string.contains(data.location, "Bellfrog")
  assert !string.contains(data.summary, "0433")
}

/// T08: Verifies pure project data (B1.2) includes personal and work portfolio entries.
///
pub fn projects_include_personal_and_work_entries_test() {
  let slugs =
    project.all_projects()
    |> list.map(fn(p) { p.slug })

  assert list.contains(slugs, "dev-ing")
  assert list.contains(slugs, "glelements")
  assert list.contains(slugs, "wyrd-technology")
  assert list.contains(slugs, "grafa")
}

/// T09: Verifies `blog.list_posts(include_unpublished: False)` excludes draft posts (`Flag = OFF`).
///
pub fn blog_list_posts_excludes_drafts_when_flag_off_test() {
  let posts = blog.list_posts(include_unpublished: False)
  assert posts != []
  assert list.all(posts, fn(post) { post.published })
}

/// T10: Verifies `blog.list_posts(include_unpublished: True)` includes draft posts (`Flag = ON`).
///
pub fn blog_list_posts_includes_drafts_when_flag_on_test() {
  let posts = blog.list_posts(include_unpublished: True)
  assert list.any(posts, fn(post) { !post.published })
}

// =============================================================================
// C. Route Parsing & Feature-Flag Gating Tests (T11–T19)
// =============================================================================

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

/// T19: Verifies `context.href` prefixes internal paths with `base_path` for GitHub Pages.
///
pub fn context_href_prefixes_base_path_test() {
  let gh_ctx = context.prod_context("priv/static", "/dev_ing")
  assert context.href(gh_ctx, "/resume") == "/dev_ing/resume"
}

// =============================================================================
// D. Wisp HTTP Simulation, Birdie Snapshots & Static Exporter Tests (T20–T24)
// =============================================================================

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

/// T24: Verifies `export.export_site` writes the expected multi-page static HTML tree (`Flag = OFF`).
///
pub fn static_site_exporter_writes_expected_tree_test() {
  let prod_ctx = context.prod_context("priv/static", "")
  let out_dir = "/tmp/dev_ing_website_stage1_export_test"
  let _ = simplifile.delete(out_dir)

  let assert Ok(_report) = export.export_site(prod_ctx, out_dir)

  assert simplifile.is_file(filepath.join(out_dir, "index.html")) == Ok(True)
  assert simplifile.is_file(filepath.join(out_dir, "projects/index.html"))
    == Ok(True)
  assert simplifile.is_file(filepath.join(out_dir, "blog/index.html"))
    == Ok(True)
  assert simplifile.is_file(filepath.join(
      out_dir,
      "blog/what-is-dev-ing/index.html",
    ))
    == Ok(True)
  assert simplifile.is_file(filepath.join(out_dir, "blog/what-is-jj/index.html"))
    == Ok(True)
  assert simplifile.is_file(filepath.join(out_dir, "resume/index.html"))
    == Ok(True)
  assert simplifile.is_file(filepath.join(out_dir, "404.html")) == Ok(True)
  assert simplifile.is_file(filepath.join(out_dir, "prototypes/index.html"))
    == Ok(False)

  let _ = simplifile.delete(out_dir)
  Nil
}
