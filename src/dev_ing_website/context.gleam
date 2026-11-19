//// Request and static-export execution context, feature flags, and theme holder.
////

import dev_ing_website/theme.{type Theme}
import gleam/list
import gleam/string

/// Feature flags controlling dark-launched routes and capabilities.
///
pub type FeatureFlags {
  FeatureFlags(
    enable_prototypes_route: Bool,
    enable_unpublished_posts: Bool,
    enable_resume_filters: Bool,
  )
}

/// Shared execution context passed to Wisp handlers, view renderers, and the static exporter.
///
pub type Context {
  Context(
    static_directory: String,
    base_path: String,
    features: FeatureFlags,
    theme: Theme,
  )
}

/// Production feature-flag defaults (all experimental flags OFF).
///
pub fn prod_defaults() -> FeatureFlags {
  FeatureFlags(
    enable_prototypes_route: False,
    enable_unpublished_posts: False,
    enable_resume_filters: False,
  )
}

/// Development feature-flag defaults (prototypes & unpublished posts ON, v2 filters OFF).
///
pub fn dev_defaults() -> FeatureFlags {
  FeatureFlags(
    enable_prototypes_route: True,
    enable_unpublished_posts: True,
    enable_resume_filters: False,
  )
}

/// Constructs a production Context with the default Black & Orange theme.
///
pub fn prod_context(
  static_directory static_directory: String,
  base_path base_path: String,
) -> Context {
  Context(
    static_directory:,
    base_path: normalize_base_path(base_path),
    features: prod_defaults(),
    theme: theme.black_and_orange(),
  )
}

/// Constructs a local development Context with the default Black & Orange theme.
///
pub fn dev_context(static_directory static_directory: String) -> Context {
  Context(
    static_directory:,
    base_path: "",
    features: dev_defaults(),
    theme: theme.black_and_orange(),
  )
}

/// Returns True if the `/prototypes` route and navbar link are enabled.
///
pub fn prototypes_enabled(ctx ctx: Context) -> Bool {
  ctx.features.enable_prototypes_route
}

/// Returns True if unpublished draft blog posts should be visible.
///
pub fn unpublished_posts_enabled(ctx ctx: Context) -> Bool {
  ctx.features.enable_unpublished_posts
}

/// Returns True if the interactive Living Resume filter bar is enabled.
///
pub fn resume_filters_enabled(ctx ctx: Context) -> Bool {
  ctx.features.enable_resume_filters
}

/// Prefixes an internal route path with `ctx.base_path` safely.
///
pub fn href(ctx ctx: Context, path path: String) -> String {
  let clean_path =
    path
    |> sanitize_path_value
    |> strip_leading_slashes
  let normalized_path = "/" <> clean_path

  case normalize_base_path(ctx.base_path) {
    "" -> normalized_path
    base ->
      case normalized_path {
        "/" -> base <> "/"
        _ -> base <> normalized_path
      }
  }
}

fn normalize_base_path(raw: String) -> String {
  let cleaned =
    raw
    |> sanitize_path_value
    |> strip_leading_slashes
    |> strip_trailing_slashes

  case cleaned {
    "" -> ""
    _ -> "/" <> cleaned
  }
}

fn sanitize_path_value(value: String) -> String {
  value
  |> strip_control_chars
  |> string.trim
  |> string.replace(each: "\\", with: "/")
}

fn strip_control_chars(value: String) -> String {
  value
  |> string.to_utf_codepoints
  |> list.filter(fn(cp) {
    let code = string.utf_codepoint_to_int(cp)
    code >= 32 && code != 127
  })
  |> string.from_utf_codepoints
}

fn strip_leading_slashes(value: String) -> String {
  case string.starts_with(value, "/") {
    True -> strip_leading_slashes(string.drop_start(value, 1))
    False -> value
  }
}

fn strip_trailing_slashes(value: String) -> String {
  case string.ends_with(value, "/") {
    True -> strip_trailing_slashes(string.drop_end(value, 1))
    False -> value
  }
}
