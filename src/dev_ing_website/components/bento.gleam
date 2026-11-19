//// Generic, reusable, theme-parameterized Bento Grid UI components.
////

import dev_ing_website/theme.{
  type BadgeTone, type BentoSpan, type CardTone, type Theme, CarbonDefault,
  OrangeAccent, OrangeSolid,
}
import gleam/list
import gleam/option.{type Option, None, Some}
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html

/// Renders a responsive Bento grid container styled by the provided Theme.
///
pub fn grid(
  theme theme: Theme,
  children children: List(Element(msg)),
) -> Element(msg) {
  html.div([attribute.class(theme.grid_class)], children)
}

/// Renders a generic Bento card parameterized by Theme, BentoSpan, CardTone,
/// optional mono eyebrow label, title, and child elements.
///
pub fn card(
  theme theme: Theme,
  span span: BentoSpan,
  tone tone: CardTone,
  eyebrow eyebrow: Option(String),
  title title: String,
  children children: List(Element(msg)),
) -> Element(msg) {
  let eyebrow_class = case tone {
    OrangeSolid -> theme.font_mono_class <> " bento-eyebrow bento-eyebrow-solid"
    CarbonDefault | OrangeAccent ->
      theme.font_mono_class
      <> " "
      <> theme.accent_text_class
      <> " bento-eyebrow"
  }

  let eyebrow_element = case eyebrow {
    Some(label) ->
      html.p([attribute.class(eyebrow_class)], [element.text(label)])
    None -> element.none()
  }

  html.article(
    [attribute.class(theme.resolve_card_class(theme:, span:, tone:))],
    [
      eyebrow_element,
      html.h2(
        [attribute.class("bento-card-title text-xl font-bold tracking-tight")],
        [element.text(title)],
      ),
      html.div(
        [attribute.class("bento-card-body flex flex-col gap-3")],
        children,
      ),
    ],
  )
}

/// Renders a generic pill/badge component parameterized by Theme and BadgeTone.
///
pub fn badge(
  theme theme: Theme,
  tone tone: BadgeTone,
  label label: String,
) -> Element(msg) {
  html.span([attribute.class(theme.resolve_badge_class(theme:, tone:))], [
    element.text(label),
  ])
}

/// Renders a consistent page or section heading with an orange eyebrow and optional subtitle.
///
pub fn section_header(
  theme theme: Theme,
  eyebrow eyebrow: String,
  title title: String,
  subtitle subtitle: Option(String),
) -> Element(msg) {
  let subtitle_element = case subtitle {
    Some(text) ->
      html.p(
        [attribute.class("bento-section-subtitle " <> theme.text_muted_class)],
        [element.text(text)],
      )
    None -> element.none()
  }

  html.div([attribute.class("bento-section-header mb-8 flex flex-col gap-2")], [
    html.p(
      [
        attribute.class(
          theme.font_mono_class
          <> " "
          <> theme.accent_text_class
          <> " bento-eyebrow",
        ),
      ],
      [element.text(eyebrow)],
    ),
    html.h1(
      [attribute.class("bento-section-title " <> theme.text_primary_class)],
      [element.text(title)],
    ),
    subtitle_element,
  ])
}

/// Renders a row of reusable technology badge pills.
///
pub fn tech_badges(
  theme theme: Theme,
  tone tone: BadgeTone,
  items items: List(String),
) -> Element(msg) {
  html.ul(
    [
      attribute.class("flex flex-wrap gap-2 list-none p-0 m-0"),
      attribute.role("list"),
    ],
    list.map(items, fn(item) {
      html.li([], [badge(theme:, tone:, label: item)])
    }),
  )
}
