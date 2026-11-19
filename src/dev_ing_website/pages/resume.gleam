//// Living Resume page view (`/resume`) with feature-gated interactive filter bar.
////

import dev_ing_website/components/bento
import dev_ing_website/context.{type Context}
import dev_ing_website/data/resume.{type ResumeData, type SkillGroup}
import dev_ing_website/theme.{
  BadgeNeutral, BadgeOrangeOutline, CarbonDefault, OrangeAccent, SpanFull,
  SpanThird, SpanTwoThirds,
}
import gleam/list
import gleam/option.{Some}
import gleam/string
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html

/// Renders the Living Resume page (`/resume` and `/about` alias).
///
pub fn view(ctx ctx: Context, data data: ResumeData) -> Element(Nil) {
  let filter_bar = case context.resume_filters_enabled(ctx) {
    False -> element.none()
    True -> render_filter_bar(data.skill_groups)
  }

  let github_link = case is_safe_http_url(data.github_url) {
    True ->
      html.a(
        [
          attribute.href(data.github_url),
          attribute.target("_blank"),
          attribute.rel("noopener noreferrer"),
          attribute.class("bento-link"),
        ],
        [element.text("GitHub Profile")],
      )
    False -> element.none()
  }

  let summary_card =
    bento.card(
      theme: ctx.theme,
      span: SpanTwoThirds,
      tone: OrangeAccent,
      eyebrow: Some("PROFILE // " <> data.location),
      title: "Engineering Summary",
      children: [
        html.p([attribute.class(ctx.theme.text_muted_class)], [
          element.text(data.summary),
        ]),
        html.div([attribute.class("flex flex-wrap gap-4")], [
          html.a(
            [
              attribute.href("mailto:" <> data.email),
              attribute.class("bento-link"),
            ],
            [element.text(data.email)],
          ),
          github_link,
        ]),
      ],
    )

  let education_card =
    bento.card(
      theme: ctx.theme,
      span: SpanThird,
      tone: CarbonDefault,
      eyebrow: Some("ACADEMIC"),
      title: "Education",
      children: list.map(data.education, fn(entry) {
        html.div([attribute.class("flex flex-col gap-1")], [
          html.h3([attribute.class("text-sm font-semibold m-0")], [
            element.text(entry.institution),
          ]),
          html.p([attribute.class("text-sm " <> ctx.theme.text_muted_class)], [
            element.text(entry.qualification),
          ]),
          html.p(
            [
              attribute.class(
                "text-xs "
                <> ctx.theme.font_mono_class
                <> " "
                <> ctx.theme.accent_text_class,
              ),
            ],
            [element.text(entry.period)],
          ),
        ])
      }),
    )

  let skills_card =
    bento.card(
      theme: ctx.theme,
      span: SpanFull,
      tone: CarbonDefault,
      eyebrow: Some("CAPABILITIES"),
      title: "Technical Skills",
      children: [
        html.div(
          [attribute.class("grid grid-cols-1 md:grid-cols-3 gap-5")],
          list.map(data.skill_groups, fn(group) {
            html.section([attribute.class("flex flex-col gap-2")], [
              html.h3(
                [
                  attribute.class(
                    "text-sm font-semibold m-0 " <> ctx.theme.accent_text_class,
                  ),
                ],
                [element.text(group.category)],
              ),
              bento.tech_badges(
                theme: ctx.theme,
                tone: BadgeOrangeOutline,
                items: group.skills,
              ),
            ])
          }),
        ),
      ],
    )

  let experience_cards =
    list.map(data.experience, fn(role) {
      bento.card(
        theme: ctx.theme,
        span: SpanFull,
        tone: CarbonDefault,
        eyebrow: Some(role.period <> " · " <> role.location),
        title: role.role <> " — " <> role.company,
        children: [
          html.ul(
            [attribute.class("bento-list")],
            list.map(role.highlights, fn(highlight) {
              html.li([], [element.text(highlight)])
            }),
          ),
          bento.tech_badges(
            theme: ctx.theme,
            tone: BadgeNeutral,
            items: role.technologies,
          ),
        ],
      )
    })

  element.fragment([
    bento.section_header(
      theme: ctx.theme,
      eyebrow: "03 // LIVING RESUME",
      title: data.name,
      subtitle: Some(data.headline),
    ),
    filter_bar,
    bento.grid(theme: ctx.theme, children: [
      summary_card,
      education_card,
      skills_card,
      ..experience_cards
    ]),
  ])
}

fn render_filter_bar(skill_groups: List(SkillGroup)) -> Element(Nil) {
  let category_buttons =
    list.map(skill_groups, fn(group) {
      html.button(
        [
          attribute.type_("button"),
          attribute.class("filter-pill"),
          attribute.data("skill-category", group.category),
        ],
        [element.text(group.category)],
      )
    })

  html.search(
    [
      attribute.data("resume-filter-bar", "true"),
      attribute.aria_label("Filter resume skills"),
      attribute.class("resume-filter-bar"),
    ],
    [
      html.span([attribute.class("text-xs font-mono text-zinc-400")], [
        element.text("Filter skills:"),
      ]),
      html.button(
        [
          attribute.type_("button"),
          attribute.class("filter-pill"),
          attribute.data("skill-category", "all"),
        ],
        [element.text("All")],
      ),
      ..category_buttons
    ],
  )
}

fn is_safe_http_url(url: String) -> Bool {
  string.starts_with(url, "https://") || string.starts_with(url, "http://")
}
