//// Engineering blog index and individual article page views.
////

import dev_ing_website/components/bento
import dev_ing_website/context.{type Context}
import dev_ing_website/data/blog.{type BlogPost}
import dev_ing_website/theme.{
  BadgeNeutral, BadgeOrangeOutline, CarbonDefault, OrangeAccent, SpanFull,
}
import gleam/list
import gleam/option.{Some}
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html

/// Renders the `/blog` article index page for the supplied visible posts.
///
pub fn list_view(
  ctx ctx: Context,
  posts posts: List(BlogPost),
) -> Element(Nil) {
  element.fragment([
    bento.section_header(
      theme: ctx.theme,
      eyebrow: "02 // JOURNAL",
      title: "Engineering Blog",
      subtitle: Some(
        "Technical notes on Gleam, Wisp, Lustre, Test-Driven Development, and Jujutsu.",
      ),
    ),
    bento.grid(
      theme: ctx.theme,
      children: list.map(posts, fn(post) {
        let tone = case post.published {
          True -> CarbonDefault
          False -> OrangeAccent
        }

        let draft_badge = case post.published {
          True -> element.none()
          False ->
            bento.badge(
              theme: ctx.theme,
              tone: BadgeOrangeOutline,
              label: "DRAFT",
            )
        }

        bento.card(
          theme: ctx.theme,
          span: SpanFull,
          tone:,
          eyebrow: Some(post.published_date <> " · " <> post.author),
          title: post.title,
          children: [
            html.div([attribute.class("flex flex-wrap items-center gap-2")], [
              draft_badge,
              html.time(
                [
                  attribute.attribute("datetime", post.published_date),
                  attribute.class(
                    "text-xs "
                    <> ctx.theme.font_mono_class
                    <> " "
                    <> ctx.theme.text_muted_class,
                  ),
                ],
                [element.text(post.published_date)],
              ),
            ]),
            html.p([attribute.class(ctx.theme.text_muted_class)], [
              element.text(post.summary),
            ]),
            bento.tech_badges(
              theme: ctx.theme,
              tone: BadgeNeutral,
              items: post.tags,
            ),
            html.a(
              [
                attribute.href(context.href(ctx, "/blog/" <> post.slug)),
                attribute.class("bento-link"),
              ],
              [element.text("Read " <> post.title <> " ->")],
            ),
          ],
        )
      }),
    ),
  ])
}

/// Renders an individual `/blog/:slug` engineering article view.
///
pub fn post_view(ctx ctx: Context, post post: BlogPost) -> Element(Nil) {
  let draft_badge = case post.published {
    True -> element.none()
    False ->
      bento.badge(
        theme: ctx.theme,
        tone: BadgeOrangeOutline,
        label: "DRAFT PREVIEW",
      )
  }

  element.fragment([
    html.div([attribute.class("mb-6")], [
      html.a(
        [
          attribute.href(context.href(ctx, "/blog")),
          attribute.class("bento-link"),
        ],
        [element.text("<- Back to Engineering Blog")],
      ),
    ]),
    bento.section_header(
      theme: ctx.theme,
      eyebrow: post.published_date <> " · " <> post.author,
      title: post.title,
      subtitle: Some(post.summary),
    ),
    bento.grid(theme: ctx.theme, children: [
      bento.card(
        theme: ctx.theme,
        span: SpanFull,
        tone: CarbonDefault,
        eyebrow: Some("ARTICLE"),
        title: "Notes",
        children: [
          html.div([attribute.class("flex flex-wrap items-center gap-3")], [
            draft_badge,
            bento.tech_badges(
              theme: ctx.theme,
              tone: BadgeOrangeOutline,
              items: post.tags,
            ),
          ]),
          html.div(
            [attribute.class("article-prose mt-2")],
            list.map(post.paragraphs, fn(paragraph) {
              html.p([attribute.class(ctx.theme.text_primary_class)], [
                element.text(paragraph),
              ])
            }),
          ),
        ],
      ),
    ]),
  ])
}
