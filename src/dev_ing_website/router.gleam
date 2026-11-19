//// Candidate A Wisp router and pure server-side route renderer.
////

import dev_ing_website/context.{type Context}
import dev_ing_website/data/blog
import dev_ing_website/data/resume
import dev_ing_website/layout.{type PageMeta, PageMeta}
import dev_ing_website/pages/blog as blog_page
import dev_ing_website/pages/home
import dev_ing_website/pages/not_found
import dev_ing_website/pages/projects
import dev_ing_website/pages/prototypes
import dev_ing_website/pages/resume as resume_page
import gleam/http
import gleam/http/response
import gleam/list
import gleam/string
import gleam/uri
import lustre/element
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
pub fn parse_route(segments segments: List(String), ctx ctx: Context) -> Route {
  case segments {
    [] -> Home
    ["projects"] -> Projects
    ["blog"] -> Blog
    ["blog", slug] if slug != "" -> BlogPost(slug)
    ["resume"] | ["about"] -> Resume
    ["prototypes"] ->
      case context.prototypes_enabled(ctx) {
        True -> Prototypes
        False -> NotFound
      }
    _ -> NotFound
  }
}

/// Renders a typed `Route` into a `#(http_status_code, html_document_string)` tuple.
///
pub fn render_route(ctx ctx: Context, route route: Route) -> #(Int, String) {
  case route {
    Home -> #(
      200,
      render_page(
        ctx,
        PageMeta(
          title: "Home",
          description: "Callum Ingley's personal developer website, portfolio, and engineering blog built with Gleam, Wisp, and Lustre.",
          active_path: "/",
        ),
        home.view(ctx),
      ),
    )
    Projects -> #(
      200,
      render_page(
        ctx,
        PageMeta(
          title: "Projects",
          description: "Personal Gleam projects and commercial web and mobile engineering work.",
          active_path: "/projects",
        ),
        projects.view(ctx),
      ),
    )
    Blog -> #(
      200,
      render_page(
        ctx,
        PageMeta(
          title: "Blog",
          description: "Engineering notes on Gleam, Wisp, Lustre, TDD, and Jujutsu.",
          active_path: "/blog",
        ),
        blog_page.list_view(
          ctx,
          blog.list_posts(
            include_unpublished: context.unpublished_posts_enabled(ctx),
          ),
        ),
      ),
    )
    BlogPost(slug) ->
      case
        blog.find_by_slug(
          slug:,
          include_unpublished: context.unpublished_posts_enabled(ctx),
        )
      {
        Ok(post) -> #(
          200,
          render_page(
            ctx,
            PageMeta(
              title: post.title,
              description: post.summary,
              active_path: "/blog/" <> post.slug,
            ),
            blog_page.post_view(ctx, post),
          ),
        )
        Error(Nil) -> render_not_found(ctx)
      }
    Resume -> #(
      200,
      render_page(
        ctx,
        PageMeta(
          title: "Living Resume",
          description: "Callum Ingley's Living Engineering Resume covering career experience, skills, and education.",
          active_path: "/resume",
        ),
        resume_page.view(ctx, resume.callum_resume()),
      ),
    )
    Prototypes ->
      case context.prototypes_enabled(ctx) {
        True -> #(
          200,
          render_page(
            ctx,
            PageMeta(
              title: "Prototypes",
              description: "Design system prototyping playground built on theme-parameterized Bento primitives.",
              active_path: "/prototypes",
            ),
            prototypes.view(ctx),
          ),
        )
        False -> render_not_found(ctx)
      }
    NotFound -> render_not_found(ctx)
  }
}

/// Returns the list of `#(Route, relative_output_file_path)` pairs for static export.
///
pub fn exportable_routes(ctx ctx: Context) -> List(#(Route, String)) {
  let base_routes = [
    #(Home, "index.html"),
    #(Projects, "projects/index.html"),
    #(Blog, "blog/index.html"),
  ]

  let post_routes =
    blog.list_posts(include_unpublished: context.unpublished_posts_enabled(ctx))
    |> list.map(fn(post) {
      #(BlogPost(post.slug), "blog/" <> post.slug <> "/index.html")
    })

  let resume_routes = [
    #(Resume, "resume/index.html"),
    #(Resume, "about/index.html"),
  ]

  let prototype_routes = case context.prototypes_enabled(ctx) {
    True -> [#(Prototypes, "prototypes/index.html")]
    False -> []
  }

  list.flatten([
    base_routes,
    post_routes,
    resume_routes,
    prototype_routes,
    [#(NotFound, "404.html")],
  ])
}

/// Wisp HTTP request handler that serves static assets and renders multi-page routes.
///
pub fn handle_request(
  req req: wisp.Request,
  ctx ctx: Context,
) -> wisp.Response {
  use req <- wisp.handle_head(req)
  use <- wisp.log_request(req)
  use <- wisp.rescue_crashes

  let static_prefix = context.href(ctx, "/static")

  let resp = case is_unsafe_static_request(req.path, static_prefix) {
    True -> {
      let #(status, html) = render_not_found(ctx)
      wisp.html_response(html, status)
    }
    False -> {
      use <- wisp.serve_static(
        req,
        under: static_prefix,
        from: ctx.static_directory,
      )
      use <- wisp.require_method(req, http.Get)

      let segments =
        wisp.path_segments(req)
        |> strip_base_path(ctx.base_path)

      let route = case segments {
        Ok(route_segments) -> parse_route(route_segments, ctx)
        Error(Nil) -> NotFound
      }

      let #(status, html) = render_route(ctx, route)
      wisp.html_response(html, status)
    }
  }

  add_security_headers(resp)
}

fn render_page(
  ctx: Context,
  meta: PageMeta,
  content: element.Element(Nil),
) -> String {
  layout.document(ctx:, meta:, content:)
  |> element.to_document_string
}

fn render_not_found(ctx: Context) -> #(Int, String) {
  #(
    404,
    render_page(
      ctx,
      PageMeta(
        title: "Not Found",
        description: "The requested page could not be found.",
        active_path: "",
      ),
      not_found.view(ctx),
    ),
  )
}

fn strip_base_path(
  segments: List(String),
  base_path: String,
) -> Result(List(String), Nil) {
  let base_segments =
    base_path
    |> string.split("/")
    |> list.filter(fn(segment) { segment != "" })

  strip_prefix_segments(segments, base_segments)
}

fn strip_prefix_segments(
  segments: List(String),
  prefix: List(String),
) -> Result(List(String), Nil) {
  case prefix, segments {
    [], _ -> Ok(segments)
    [p, ..p_rest], [s, ..s_rest] if p == s ->
      strip_prefix_segments(s_rest, p_rest)
    _, _ -> Error(Nil)
  }
}

fn is_unsafe_static_request(req_path: String, static_prefix: String) -> Bool {
  let clean_req = strip_leading_slashes(req_path)
  let clean_prefix = strip_leading_slashes(static_prefix)

  let matches_prefix = case uri.percent_decode(clean_req) {
    Ok(decoded) ->
      string.starts_with(clean_req, clean_prefix)
      || string.starts_with(decoded, clean_prefix)
    Error(_) -> string.starts_with(clean_req, clean_prefix)
  }

  case matches_prefix {
    False -> False
    True ->
      case uri.percent_decode(clean_req) {
        Error(_) -> True
        Ok(decoded) ->
          has_unsafe_path_pattern(clean_req) || has_unsafe_path_pattern(decoded)
      }
  }
}

fn has_unsafe_path_pattern(path: String) -> Bool {
  string.contains(path, "..")
  || string.contains(path, "\\")
  || string.contains(path, "\u{0000}")
  || list.any(string.split(path, "/"), fn(segment) {
    segment == "." || segment == ".."
  })
}

fn strip_leading_slashes(value: String) -> String {
  case string.starts_with(value, "/") {
    True -> strip_leading_slashes(string.drop_start(value, 1))
    False -> value
  }
}

fn add_security_headers(resp: wisp.Response) -> wisp.Response {
  resp
  |> response.set_header(
    "content-security-policy",
    "default-src 'self'; img-src 'self' data:; style-src 'self'; font-src 'self'; script-src 'none'; object-src 'none'; base-uri 'none'; frame-ancestors 'none'",
  )
  |> response.set_header("x-content-type-options", "nosniff")
  |> response.set_header("x-frame-options", "DENY")
  |> response.set_header("referrer-policy", "strict-origin-when-cross-origin")
  |> response.set_header(
    "permissions-policy",
    "camera=(), microphone=(), geolocation=()",
  )
}
