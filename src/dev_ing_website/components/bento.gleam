//// Generic, reusable, theme-parameterized Bento Grid UI components.
////

import dev_ing_website/theme.{
  type BadgeTone, type BentoSpan, type CardTone, type Theme,
}
import gleam/option.{type Option}
import lustre/element.{type Element}

/// Renders a responsive Bento grid container styled by the provided Theme.
///
pub fn grid(
  theme _theme: Theme,
  children _children: List(Element(msg)),
) -> Element(msg) {
  todo as "Stage 1A stub: grid"
}

/// Renders a generic Bento card parameterized by Theme, BentoSpan, CardTone,
/// optional mono eyebrow label, title, and child elements.
///
pub fn card(
  theme _theme: Theme,
  span _span: BentoSpan,
  tone _tone: CardTone,
  eyebrow _eyebrow: Option(String),
  title _title: String,
  children _children: List(Element(msg)),
) -> Element(msg) {
  todo as "Stage 1A stub: card"
}

/// Renders a generic pill/badge component parameterized by Theme and BadgeTone.
///
pub fn badge(
  theme _theme: Theme,
  tone _tone: BadgeTone,
  label _label: String,
) -> Element(msg) {
  todo as "Stage 1A stub: badge"
}

/// Renders a consistent page or section heading with an optional orange eyebrow and subtitle.
///
pub fn section_header(
  theme _theme: Theme,
  eyebrow _eyebrow: String,
  title _title: String,
  subtitle _subtitle: Option(String),
) -> Element(msg) {
  todo as "Stage 1A stub: section_header"
}

/// Renders a row of reusable technology badge pills.
///
pub fn tech_badges(
  theme _theme: Theme,
  tone _tone: BadgeTone,
  items _items: List(String),
) -> Element(msg) {
  todo as "Stage 1A stub: tech_badges"
}
