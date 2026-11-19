//// Theme tokens and variant primitives for generic UI components.
////

import gleam/list
import gleam/string

/// Visual emphasis variants for Bento cards.
///
pub type CardTone {
  CarbonDefault
  OrangeAccent
  OrangeSolid
}

/// Visual variants for metadata badges and technology pills.
///
pub type BadgeTone {
  BadgeNeutral
  BadgeOrangeOutline
  BadgeOrangeSolid
}

/// Responsive column spans in a 3-column desktop Bento grid.
///
pub type BentoSpan {
  SpanThird
  SpanTwoThirds
  SpanHalf
  SpanFull
}

/// Parameterizable theme configuration passed into generic UI components.
///
pub type Theme {
  Theme(
    name: String,
    canvas_class: String,
    text_primary_class: String,
    text_muted_class: String,
    accent_text_class: String,
    font_mono_class: String,
    grid_class: String,
    card_base_class: String,
    card_default_class: String,
    card_orange_accent_class: String,
    card_orange_solid_class: String,
    badge_neutral_class: String,
    badge_orange_outline_class: String,
    badge_orange_solid_class: String,
    nav_shell_class: String,
    nav_link_active_class: String,
    nav_link_inactive_class: String,
  )
}

/// Returns the default v1 minimal Black & Orange theme.
///
pub fn black_and_orange() -> Theme {
  Theme(
    name: "black-and-orange",
    canvas_class: "bg-zinc-950",
    text_primary_class: "text-zinc-50",
    text_muted_class: "text-zinc-400",
    accent_text_class: "text-orange-500",
    font_mono_class: "font-mono",
    grid_class: "bento-grid grid grid-cols-1 md:grid-cols-3 gap-5",
    card_base_class: "bento-card rounded-2xl border p-6 flex flex-col gap-4",
    card_default_class: "bg-zinc-900 border-zinc-800 text-zinc-50",
    card_orange_accent_class: "bg-zinc-900 border-orange-500/40 text-zinc-50",
    card_orange_solid_class: "bg-orange-500 border-orange-400 text-zinc-950",
    badge_neutral_class: "badge inline-flex items-center rounded-full px-3 py-1 text-xs font-mono bg-zinc-800 text-zinc-200 border border-zinc-700",
    badge_orange_outline_class: "badge inline-flex items-center rounded-full px-3 py-1 text-xs font-mono bg-orange-500/10 text-orange-400 border border-orange-500/40",
    badge_orange_solid_class: "badge inline-flex items-center rounded-full px-3 py-1 text-xs font-mono bg-orange-500 text-zinc-950 font-semibold",
    nav_shell_class: "site-header sticky top-0 z-20 border-b border-zinc-800 bg-zinc-950/90 backdrop-blur",
    nav_link_active_class: "nav-link nav-link-active text-orange-500 font-semibold",
    nav_link_inactive_class: "nav-link text-zinc-300 hover:text-orange-400",
  )
}

/// Resolves the full CSS class string for a Bento card given a Theme, BentoSpan, and CardTone.
///
pub fn resolve_card_class(
  theme theme: Theme,
  span span: BentoSpan,
  tone tone: CardTone,
) -> String {
  let tone_class = case tone {
    CarbonDefault -> theme.card_default_class
    OrangeAccent -> theme.card_orange_accent_class
    OrangeSolid -> theme.card_orange_solid_class
  }

  [theme.card_base_class, resolve_span_class(span), tone_class]
  |> list.filter(fn(part) { string.trim(part) != "" })
  |> string.join(" ")
}

/// Resolves the full CSS class string for a badge given a Theme and BadgeTone.
///
pub fn resolve_badge_class(theme theme: Theme, tone tone: BadgeTone) -> String {
  case tone {
    BadgeNeutral -> theme.badge_neutral_class
    BadgeOrangeOutline -> theme.badge_orange_outline_class
    BadgeOrangeSolid -> theme.badge_orange_solid_class
  }
}

/// Resolves the responsive grid column span class for a BentoSpan.
///
pub fn resolve_span_class(span span: BentoSpan) -> String {
  case span {
    SpanThird -> "md:col-span-1"
    SpanTwoThirds -> "md:col-span-2"
    SpanHalf -> "bento-half md:col-span-1"
    SpanFull -> "md:col-span-3"
  }
}
