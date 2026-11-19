//// Unit tests for `dev_ing_website/context` (`T19` plus URL sanitization regression tests).
////

import dev_ing_website/context

/// T19: Verifies `context.href` prefixes internal paths with `base_path` for GitHub Pages.
///
pub fn context_href_prefixes_base_path_test() {
  let gh_ctx = context.prod_context("priv/static", "/dev_ing")
  assert context.href(gh_ctx, "/resume") == "/dev_ing/resume"
}

/// Verifies `context.href` neutralizes protocol-relative slashes, backslashes, and control chars.
///
pub fn context_href_sanitizes_backslashes_and_control_chars_test() {
  let root_ctx = context.prod_context("priv/static", "")
  assert context.href(root_ctx, "//evil.com") == "/evil.com"
  assert context.href(root_ctx, "\\\\evil.com") == "/evil.com"
  assert context.href(root_ctx, "/\t\r\n/evil.com") == "/evil.com"
}
