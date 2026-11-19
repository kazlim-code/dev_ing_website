//// Shared HTML5 document shell, header navigation, and footer.
////

import dev_ing_website/context.{type Context}
import gleam/list
import gleam/string
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html

/// Per-page metadata injected into the HTML `<head>` and navbar.
///
pub type PageMeta {
  PageMeta(title: String, description: String, active_path: String)
}

/// Wraps page content in the full HTML5 document layout styled by `ctx.theme`.
///
pub fn document(
  ctx ctx: Context,
  meta meta: PageMeta,
  content content: Element(Nil),
) -> Element(Nil) {
  let body_class = ctx.theme.canvas_class <> " " <> ctx.theme.text_primary_class

  html.html([attribute.lang("en"), attribute.class("dark")], [
    html.head([], [
      html.meta([attribute.charset("utf-8")]),
      html.meta([
        attribute.name("viewport"),
        attribute.content("width=device-width, initial-scale=1.0"),
      ]),
      html.meta([
        attribute.name("color-scheme"),
        attribute.content("dark"),
      ]),
      html.meta([
        attribute.name("description"),
        attribute.content(meta.description),
      ]),
      html.title([], meta.title <> " | dev_ing"),
      html.link([
        attribute.rel("stylesheet"),
        attribute.href(context.href(ctx, "/static/styles.css")),
      ]),
      html.link([
        attribute.rel("preload"),
        attribute.attribute("as", "font"),
        attribute.type_("font/woff2"),
        attribute.href(context.href(
          ctx,
          "/static/fonts/JetBrainsMono-Regular.woff2",
        )),
        attribute.attribute("crossorigin", ""),
      ]),
    ]),
    html.body([attribute.class(body_class)], [
      html.a([attribute.href("#main-content"), attribute.class("skip-link")], [
        element.text("Skip to main content"),
      ]),
      header(ctx:, active_path: meta.active_path),
      html.main([attribute.id("main-content"), attribute.class("site-main")], [
        content,
      ]),
      footer(ctx:),
    ]),
  ])
}

/// Renders the shared multi-page top navigation bar.
///
pub fn header(
  ctx ctx: Context,
  active_path active_path: String,
) -> Element(Nil) {
  let base_items = [
    #("/", "Home"),
    #("/projects", "Projects"),
    #("/blog", "Blog"),
    #("/resume", "Resume"),
  ]

  let nav_items = case context.prototypes_enabled(ctx) {
    True -> list.append(base_items, [#("/prototypes", "Prototypes")])
    False -> base_items
  }

  html.header([attribute.class(ctx.theme.nav_shell_class)], [
    html.div([attribute.class("site-header-inner")], [
      html.a(
        [
          attribute.href(context.href(ctx, "/")),
          attribute.class("site-brand"),
        ],
        [
          html.span([attribute.class(ctx.theme.accent_text_class)], [
            element.text("dev"),
          ]),
          html.span([], [element.text("_ing")]),
        ],
      ),
      html.nav([attribute.aria_label("Primary")], [
        html.ul(
          [attribute.class("site-nav-list"), attribute.role("list")],
          list.map(nav_items, fn(item) {
            let #(path, label) = item
            let is_active = case path {
              "/" -> active_path == "/"
              _ ->
                active_path == path
                || string.starts_with(active_path, path <> "/")
            }

            let link_attrs = case is_active {
              True -> [
                attribute.href(context.href(ctx, path)),
                attribute.class(ctx.theme.nav_link_active_class),
                attribute.aria_current("page"),
              ]
              False -> [
                attribute.href(context.href(ctx, path)),
                attribute.class(ctx.theme.nav_link_inactive_class),
              ]
            }

            html.li([], [html.a(link_attrs, [element.text(label)])])
          }),
        ),
      ]),
    ]),
  ])
}

/// Renders the shared site footer.
///
pub fn footer(ctx ctx: Context) -> Element(Nil) {
  html.footer([attribute.class("site-footer")], [
    html.div([attribute.class("site-footer-inner")], [
      html.p([attribute.class("m-0 " <> ctx.theme.text_muted_class)], [
        element.text("Callum Ingley · Built with Gleam, Wisp, and Lustre"),
      ]),
      html.a(
        [
          attribute.href("https://github.com/kazlim-code"),
          attribute.target("_blank"),
          attribute.rel("noopener noreferrer"),
          attribute.class("bento-link"),
        ],
        [element.text("GitHub (@kazlim-code)")],
      ),
    ]),
  ])
}
