//// Unit tests for `dev_ing_website/theme` (`T01`–`T02` plus stylesheet token coverage).
////

import dev_ing_website/theme.{BadgeOrangeSolid, OrangeAccent, SpanTwoThirds}
import gleam/string
import simplifile

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

/// Verifies `priv/static/styles.css` defines key layout utility rules used by components and pages.
///
pub fn theme_stylesheet_defines_used_utility_classes_test() {
  let assert Ok(css) = simplifile.read(from: "priv/static/styles.css")

  assert string.contains(css, ".gap-1")
  assert string.contains(css, ".md\\:grid-cols-3")
  assert string.contains(css, ".md\\:col-span-2")
  assert string.contains(css, ".md\\:col-span-3")
  assert string.contains(css, ".bg-orange-500")
}
