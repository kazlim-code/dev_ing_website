//// Experimental design-system prototype playground (`/prototypes`, feature-gated).
////

import dev_ing_website/components/bento
import dev_ing_website/context.{type Context}
import dev_ing_website/theme.{
  type Theme, BadgeOrangeOutline, BadgeOrangeSolid, CarbonDefault, OrangeAccent,
  SpanHalf, Theme,
}
import gleam/option.{Some}
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html

/// Renders the `/prototypes` view comparing Black & Orange against an experimental spec theme.
///
pub fn view(ctx ctx: Context) -> Element(Nil) {
  let experimental_theme = industrial_spec_theme()

  element.fragment([
    bento.section_header(
      theme: ctx.theme,
      eyebrow: "LAB // PROTOTYPES",
      title: "Design System Prototypes",
      subtitle: Some(
        "Comparing theme-parameterized Bento components without altering component markup.",
      ),
    ),
    bento.grid(theme: ctx.theme, children: [
      bento.card(
        theme: ctx.theme,
        span: SpanHalf,
        tone: OrangeAccent,
        eyebrow: Some("THEME A // ACTIVE"),
        title: "Black & Orange Default",
        children: [
          html.p([attribute.class(ctx.theme.text_muted_class)], [
            element.text(
              "Signature zinc-950 canvas paired with orange-500 accents and JetBrains Mono metadata.",
            ),
          ]),
          bento.tech_badges(theme: ctx.theme, tone: BadgeOrangeSolid, items: [
            "zinc-950",
            "orange-500",
            "JetBrains Mono",
          ]),
        ],
      ),
      bento.card(
        theme: experimental_theme,
        span: SpanHalf,
        tone: CarbonDefault,
        eyebrow: Some("THEME B // PROTOTYPE"),
        title: "Industrial Spec Grid",
        children: [
          html.p([attribute.class(experimental_theme.text_muted_class)], [
            element.text(
              "Injects an alternate Theme record directly into the exact same bento.card and bento.badge primitives.",
            ),
          ]),
          bento.tech_badges(
            theme: experimental_theme,
            tone: BadgeOrangeOutline,
            items: ["Theme Parameterized", "Isolated Snapshots", "v2 Ready"],
          ),
        ],
      ),
    ]),
  ])
}

fn industrial_spec_theme() -> Theme {
  let base = theme.black_and_orange()
  Theme(
    ..base,
    name: "industrial-spec",
    card_default_class: "bg-zinc-950 border-zinc-700 text-zinc-50",
    badge_orange_outline_class: "badge inline-flex items-center rounded-full px-3 py-1 text-xs font-mono bg-zinc-900 text-orange-400 border border-orange-500/40",
  )
}
