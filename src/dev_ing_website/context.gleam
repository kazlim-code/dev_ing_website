//// Request and static-export execution context, feature flags, and theme holder.
////

import dev_ing_website/theme.{type Theme}

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
  todo as "Stage 1A stub: prod_defaults"
}

/// Development feature-flag defaults (prototypes & unpublished posts ON, v2 filters OFF).
///
pub fn dev_defaults() -> FeatureFlags {
  todo as "Stage 1A stub: dev_defaults"
}

/// Constructs a production Context with the default Black & Orange theme.
///
pub fn prod_context(
  static_directory _static_directory: String,
  base_path _base_path: String,
) -> Context {
  todo as "Stage 1A stub: prod_context"
}

/// Constructs a local development Context with the default Black & Orange theme.
///
pub fn dev_context(static_directory _static_directory: String) -> Context {
  todo as "Stage 1A stub: dev_context"
}

/// Returns True if the `/prototypes` route and navbar link are enabled.
///
pub fn prototypes_enabled(ctx _ctx: Context) -> Bool {
  todo as "Stage 1A stub: prototypes_enabled"
}

/// Returns True if unpublished draft blog posts should be visible.
///
pub fn unpublished_posts_enabled(ctx _ctx: Context) -> Bool {
  todo as "Stage 1A stub: unpublished_posts_enabled"
}

/// Returns True if the interactive Living Resume filter bar is enabled.
///
pub fn resume_filters_enabled(ctx _ctx: Context) -> Bool {
  todo as "Stage 1A stub: resume_filters_enabled"
}

/// Prefixes an internal route path with `ctx.base_path` safely.
///
pub fn href(ctx _ctx: Context, path _path: String) -> String {
  todo as "Stage 1A stub: href"
}
