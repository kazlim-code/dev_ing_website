//// Shared HTML5 document shell, header navigation, and footer.
////

import dev_ing_website/context.{type Context}
import lustre/element.{type Element}

/// Per-page metadata injected into the HTML `<head>` and navbar.
///
pub type PageMeta {
  PageMeta(title: String, description: String, active_path: String)
}

/// Wraps page content in the full HTML5 document layout styled by `ctx.theme`.
///
pub fn document(
  ctx _ctx: Context,
  meta _meta: PageMeta,
  content _content: Element(Nil),
) -> Element(Nil) {
  todo as "Stage 1A stub: document"
}

/// Renders the shared multi-page top navigation bar.
///
pub fn header(
  ctx _ctx: Context,
  active_path _active_path: String,
) -> Element(Nil) {
  todo as "Stage 1A stub: header"
}

/// Renders the shared site footer.
///
pub fn footer(ctx _ctx: Context) -> Element(Nil) {
  todo as "Stage 1A stub: footer"
}
