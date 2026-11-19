//// Shared non-test helpers and fixtures for the `dev_ing_website` test suite.
////

import dev_ing_website/theme.{type Theme, Theme}

/// Helper that returns a custom test theme for verifying generic component parameterization.
///
pub fn custom_test_theme() -> Theme {
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
