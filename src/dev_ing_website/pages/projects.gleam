//// Projects and commercial work portfolio page view.
////

import dev_ing_website/components/bento
import dev_ing_website/context.{type Context}
import dev_ing_website/data/project.{
  type Project, type ProjectCategory, Personal, Work,
}
import dev_ing_website/theme.{
  BadgeOrangeOutline, CarbonDefault, OrangeAccent, SpanHalf,
}
import gleam/list
import gleam/option.{Some}
import gleam/string
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html

/// Renders the `/projects` portfolio view grouping Personal and Work projects.
///
pub fn view(ctx ctx: Context) -> Element(Nil) {
  let personal_projects = project.by_category(Personal)
  let work_projects = project.by_category(Work)

  element.fragment([
    bento.section_header(
      theme: ctx.theme,
      eyebrow: "01 // PORTFOLIO",
      title: "Projects & Commercial Work",
      subtitle: Some(
        "Personal Gleam open-source projects alongside commercial web and mobile engineering.",
      ),
    ),
    html.section([attribute.aria_labelledby("personal-projects-heading")], [
      html.h2(
        [
          attribute.id("personal-projects-heading"),
          attribute.class("bento-subhead " <> ctx.theme.accent_text_class),
        ],
        [element.text("Personal Projects")],
      ),
      bento.grid(
        theme: ctx.theme,
        children: list.map(personal_projects, render_project_card(ctx, _)),
      ),
    ]),
    html.section(
      [
        attribute.aria_labelledby("work-projects-heading"),
        attribute.class("mt-10"),
      ],
      [
        html.h2(
          [
            attribute.id("work-projects-heading"),
            attribute.class("bento-subhead " <> ctx.theme.accent_text_class),
          ],
          [element.text("Commercial Experience")],
        ),
        bento.grid(
          theme: ctx.theme,
          children: list.map(work_projects, render_project_card(ctx, _)),
        ),
      ],
    ),
  ])
}

fn render_project_card(ctx: Context, item: Project) -> Element(Nil) {
  let #(eyebrow_label, card_tone) = category_style(item.category)
  let tech_labels = list.map(item.technologies, fn(tech) { tech.label })

  let external_link = case is_safe_http_url(item.external_url) {
    True ->
      html.a(
        [
          attribute.href(item.external_url),
          attribute.target("_blank"),
          attribute.rel("noopener noreferrer"),
          attribute.class("bento-link"),
        ],
        [element.text("Visit " <> item.title <> " repository ->")],
      )
    False -> element.none()
  }

  bento.card_with_heading(
    theme: ctx.theme,
    span: SpanHalf,
    tone: card_tone,
    eyebrow: Some(eyebrow_label),
    title: item.title,
    heading_level: 3,
    children: [
      html.div([attribute.class("project-header")], [
        html.img([
          attribute.src(context.href(ctx, item.icon_path)),
          attribute.alt(""),
          attribute.width(40),
          attribute.height(40),
          attribute.loading("lazy"),
          attribute.decoding("async"),
          attribute.class("project-icon"),
        ]),
        html.p([attribute.class(ctx.theme.text_muted_class)], [
          element.text(item.summary),
        ]),
      ]),
      html.ul(
        [attribute.class("bento-list")],
        list.map(item.highlights, fn(highlight) {
          html.li([], [element.text(highlight)])
        }),
      ),
      bento.tech_badges(
        theme: ctx.theme,
        tone: BadgeOrangeOutline,
        items: tech_labels,
      ),
      external_link,
    ],
  )
}

fn category_style(category: ProjectCategory) -> #(String, theme.CardTone) {
  case category {
    Personal -> #("PERSONAL // OPEN SOURCE", OrangeAccent)
    Work -> #("WORK // COMMERCIAL", CarbonDefault)
  }
}

fn is_safe_http_url(url: String) -> Bool {
  string.starts_with(url, "https://") || string.starts_with(url, "http://")
}
