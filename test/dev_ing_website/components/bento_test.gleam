//// Unit and Birdie snapshot tests for `dev_ing_website/components/bento` (`T03`–`T05`).
////

import birdie
import dev_ing_website/components/bento
import dev_ing_website/theme.{
  BadgeOrangeSolid, OrangeAccent, SpanHalf, SpanThird,
}
import gleam/option.{Some}
import gleam/string
import lustre/element
import lustre/element/html
import test_support

/// T03: Verifies `bento.card` injects a custom Theme rather than hardcoding classes.
///
pub fn bento_card_injects_custom_theme_test() {
  let rendered =
    bento.card(
      theme: test_support.custom_test_theme(),
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
      theme: test_support.custom_test_theme(),
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
