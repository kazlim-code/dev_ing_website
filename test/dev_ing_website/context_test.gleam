//// Unit tests for `dev_ing_website/context` (`T19`).
////

import dev_ing_website/context

/// T19: Verifies `context.href` prefixes internal paths with `base_path` for GitHub Pages.
///
pub fn context_href_prefixes_base_path_test() {
  let gh_ctx = context.prod_context("priv/static", "/dev_ing")
  assert context.href(gh_ctx, "/resume") == "/dev_ing/resume"
}
