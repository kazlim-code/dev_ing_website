//// Theme tokens and variant primitives for generic UI components.
////

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
  todo as "Stage 1A stub: black_and_orange"
}

/// Resolves the full CSS class string for a Bento card given a Theme, BentoSpan, and CardTone.
///
pub fn resolve_card_class(
  theme _theme: Theme,
  span _span: BentoSpan,
  tone _tone: CardTone,
) -> String {
  todo as "Stage 1A stub: resolve_card_class"
}

/// Resolves the full CSS class string for a badge given a Theme and BadgeTone.
///
pub fn resolve_badge_class(
  theme _theme: Theme,
  tone _tone: BadgeTone,
) -> String {
  todo as "Stage 1A stub: resolve_badge_class"
}

/// Resolves the responsive grid column span class for a BentoSpan.
///
pub fn resolve_span_class(span _span: BentoSpan) -> String {
  todo as "Stage 1A stub: resolve_span_class"
}
