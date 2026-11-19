//// 404 Not Found page view.
////

import dev_ing_website/components/bento
import dev_ing_website/context.{type Context}
import dev_ing_website/theme.{OrangeAccent, SpanFull}
import gleam/option.{Some}
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html

/// Renders the 404 Not Found page view.
///
pub fn view(ctx ctx: Context) -> Element(Nil) {
  element.fragment([
    bento.section_header(
      theme: ctx.theme,
      eyebrow: "404 // NOT FOUND",
      title: "Page Not Found",
      subtitle: Some(
        "The route or draft article you requested is either missing or gated off.",
      ),
    ),
    bento.grid(theme: ctx.theme, children: [
      bento.card(
        theme: ctx.theme,
        span: SpanFull,
        tone: OrangeAccent,
        eyebrow: Some("NAVIGATION"),
        title: "Return to dev_ing",
        children: [
          html.p([attribute.class(ctx.theme.text_muted_class)], [
            element.text(
              "Continue exploring the portfolio, engineering journal, or Living Resume.",
            ),
          ]),
          html.div([attribute.class("flex flex-wrap gap-4")], [
            html.a(
              [
                attribute.href(context.href(ctx, "/")),
                attribute.class("bento-link"),
              ],
              [element.text("Go to Home ->")],
            ),
            html.a(
              [
                attribute.href(context.href(ctx, "/blog")),
                attribute.class("bento-link"),
              ],
              [element.text("Browse Engineering Blog ->")],
            ),
          ]),
        ],
      ),
    ]),
  ])
}
