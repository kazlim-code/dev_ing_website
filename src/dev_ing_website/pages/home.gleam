//// Home page Bento Grid showcase view.
////

import dev_ing_website/components/bento
import dev_ing_website/context.{type Context}
import dev_ing_website/data/blog
import dev_ing_website/data/project
import dev_ing_website/theme.{
  BadgeNeutral, BadgeOrangeOutline, CarbonDefault, OrangeAccent, OrangeSolid,
  SpanFull, SpanThird, SpanTwoThirds,
}
import gleam/list
import gleam/option.{Some}
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html

/// Renders the Home page (`/`) Bento Grid view.
///
pub fn view(ctx ctx: Context) -> Element(Nil) {
  let visible_posts =
    blog.list_posts(include_unpublished: context.unpublished_posts_enabled(ctx))
  let featured = project.featured_projects()

  element.fragment([
    bento.section_header(
      theme: ctx.theme,
      eyebrow: "00 // OVERVIEW",
      title: "Callum Ingley — dev_ing",
      subtitle: Some(
        "Full-stack software engineer crafting web, mobile, and server-rendered Gleam systems.",
      ),
    ),
    bento.grid(theme: ctx.theme, children: [
      bento.card(
        theme: ctx.theme,
        span: SpanTwoThirds,
        tone: OrangeAccent,
        eyebrow: Some("01 // ENGINEER"),
        title: "Server-Rendered Gleam & Full-Stack Craft",
        children: [
          html.div([attribute.class("hero-profile")], [
            html.img([
              attribute.src(context.href(ctx, "/static/me.jpg")),
              attribute.alt("Portrait of Callum Ingley"),
              attribute.width(88),
              attribute.height(88),
              attribute.fetchpriority("high"),
              attribute.decoding("async"),
              attribute.class("hero-avatar"),
            ]),
            html.div([attribute.class("flex flex-col gap-3")], [
              html.p([attribute.class(ctx.theme.text_muted_class)], [
                element.text(
                  "Based in Newcastle, NSW. Building reliable products across TypeScript, Vue/Nuxt, Capacitor mobile, PostgreSQL, AWS, and type-safe functional Gleam on the BEAM.",
                ),
              ]),
              html.div([attribute.class("flex flex-wrap gap-4")], [
                html.a(
                  [
                    attribute.href(context.href(ctx, "/resume")),
                    attribute.class("bento-link"),
                  ],
                  [element.text("Open Living Resume ->")],
                ),
                html.a(
                  [
                    attribute.href(context.href(ctx, "/projects")),
                    attribute.class("bento-link"),
                  ],
                  [element.text("Explore Projects ->")],
                ),
              ]),
            ]),
          ]),
        ],
      ),
      bento.card(
        theme: ctx.theme,
        span: SpanThird,
        tone: OrangeSolid,
        eyebrow: Some("02 // ARCHITECTURE"),
        title: "Pure Gleam MPA",
        children: [
          html.p([], [
            element.text(
              "Shared pure Lustre rendering powers both a live Wisp + Mist HTTP server and a zero-JS static export.",
            ),
          ]),
          bento.tech_badges(theme: ctx.theme, tone: BadgeNeutral, items: [
            "Gleam v1.18",
            "Wisp v2.2",
            "Lustre v5.7",
            "Jujutsu",
          ]),
        ],
      ),
      bento.card(
        theme: ctx.theme,
        span: SpanTwoThirds,
        tone: CarbonDefault,
        eyebrow: Some("03 // FEATURED WORK"),
        title: "Personal & Commercial Highlights",
        children: [
          html.ul(
            [attribute.class("bento-list")],
            list.map(featured, fn(item) {
              html.li([], [
                html.h3([attribute.class("text-sm font-semibold m-0")], [
                  element.text(item.title),
                ]),
                html.p(
                  [attribute.class("text-sm " <> ctx.theme.text_muted_class)],
                  [
                    element.text(item.summary),
                  ],
                ),
              ])
            }),
          ),
          html.a(
            [
              attribute.href(context.href(ctx, "/projects")),
              attribute.class("bento-link"),
            ],
            [element.text("View full project portfolio ->")],
          ),
        ],
      ),
      bento.card(
        theme: ctx.theme,
        span: SpanThird,
        tone: CarbonDefault,
        eyebrow: Some("04 // JOURNAL"),
        title: "Latest Engineering Notes",
        children: [
          html.ul(
            [attribute.class("bento-list")],
            list.map(visible_posts, fn(post) {
              html.li([], [
                html.a(
                  [
                    attribute.href(context.href(ctx, "/blog/" <> post.slug)),
                    attribute.class("bento-link"),
                  ],
                  [element.text("Read " <> post.title)],
                ),
                html.p(
                  [attribute.class("text-xs " <> ctx.theme.text_muted_class)],
                  [
                    element.text(post.published_date),
                  ],
                ),
              ])
            }),
          ),
          html.a(
            [
              attribute.href(context.href(ctx, "/blog")),
              attribute.class("bento-link"),
            ],
            [element.text("Browse all blog posts ->")],
          ),
        ],
      ),
      bento.card(
        theme: ctx.theme,
        span: SpanFull,
        tone: CarbonDefault,
        eyebrow: Some("05 // LIVING RESUME"),
        title: "Experience Timeline & Capabilities",
        children: [
          html.p([attribute.class(ctx.theme.text_muted_class)], [
            element.text(
              "Full career history spanning Grafa (2021–2026), Wyrd Technology (2024–2025), Akora Property, The West Australian, and UWA Computer & Mathematical Sciences.",
            ),
          ]),
          bento.tech_badges(theme: ctx.theme, tone: BadgeOrangeOutline, items: [
            "TypeScript",
            "Gleam",
            "Vue & Nuxt",
            "Capacitor Mobile",
            "PostgreSQL",
            "AWS",
          ]),
        ],
      ),
    ]),
  ])
}
