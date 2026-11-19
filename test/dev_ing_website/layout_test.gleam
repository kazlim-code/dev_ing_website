//// Unit tests for `dev_ing_website/layout`.
////

import dev_ing_website/context.{Context, FeatureFlags}
import dev_ing_website/layout.{PageMeta}
import gleam/string
import lustre/element
import lustre/element/html
import test_support

/// Verifies `layout.header` omits the `/prototypes` navigation link when `Flag = OFF`.
///
pub fn header_hides_prototypes_link_when_flag_off_test() {
  let ctx = context.prod_context("priv/static", "")
  let rendered =
    layout.header(ctx:, active_path: "/")
    |> element.to_string

  assert !string.contains(rendered, "/prototypes")
  assert string.contains(rendered, "/projects")
  assert string.contains(rendered, "/blog")
  assert string.contains(rendered, "/resume")
}

/// Verifies `layout.header` includes the `/prototypes` navigation link when `Flag = ON`.
///
pub fn header_shows_prototypes_link_when_flag_on_test() {
  let ctx = context.dev_context("priv/static")
  let rendered =
    layout.header(ctx:, active_path: "/prototypes")
    |> element.to_string

  assert string.contains(rendered, "/prototypes")
  assert string.contains(rendered, "aria-current=\"page\"")
}

/// Verifies `layout.document` applies injected Theme classes rather than hardcoding Black & Orange.
///
pub fn document_uses_custom_theme_classes_test() {
  let ctx =
    Context(
      static_directory: "priv/static",
      base_path: "",
      features: FeatureFlags(
        enable_prototypes_route: False,
        enable_unpublished_posts: False,
        enable_resume_filters: False,
      ),
      theme: test_support.custom_test_theme(),
    )

  let rendered =
    layout.document(
      ctx:,
      meta: PageMeta(title: "Test", description: "Desc", active_path: "/"),
      content: html.p([], [element.text("Hello")]),
    )
    |> element.to_string

  assert string.contains(rendered, "cyber-canvas")
  assert string.contains(rendered, "cyber-text")
  assert string.contains(rendered, "cyber-nav")
}
