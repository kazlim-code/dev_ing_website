//// Candidate A Wisp router and pure server-side route renderer.
////

import dev_ing_website/context.{type Context}
import wisp

/// Typed multi-page application routes.
///
pub type Route {
  Home
  Projects
  Blog
  BlogPost(slug: String)
  Resume
  Prototypes
  NotFound
}

/// Parses URL path segments into a typed `Route`, respecting feature gates in `ctx`.
///
pub fn parse_route(
  segments _segments: List(String),
  ctx _ctx: Context,
) -> Route {
  todo as "Stage 1A stub: parse_route"
}

/// Renders a typed `Route` into a `#(http_status_code, html_document_string)` tuple.
///
pub fn render_route(ctx _ctx: Context, route _route: Route) -> #(Int, String) {
  todo as "Stage 1A stub: render_route"
}

/// Returns the list of `#(Route, relative_output_file_path)` pairs for static export.
///
pub fn exportable_routes(ctx _ctx: Context) -> List(#(Route, String)) {
  todo as "Stage 1A stub: exportable_routes"
}

/// Wisp HTTP request handler that serves static assets and renders multi-page routes.
///
pub fn handle_request(
  req _req: wisp.Request,
  ctx _ctx: Context,
) -> wisp.Response {
  todo as "Stage 1A stub: handle_request"
}
