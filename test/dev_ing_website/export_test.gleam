//// Integration tests for `dev_ing_website/export` (`T24` plus Stage 2 coverage).
////

import dev_ing_website/context
import dev_ing_website/export
import filepath
import gleam/string
import simplifile

/// T24: Verifies `export.export_site` writes the expected multi-page static HTML tree (`Flag = OFF`).
///
pub fn static_site_exporter_writes_expected_tree_test() {
  let prod_ctx = context.prod_context("priv/static", "")
  let out_dir = "/tmp/dev_ing_website_stage1_export_test"
  let _ = simplifile.delete(out_dir)

  let assert Ok(_report) = export.export_site(prod_ctx, out_dir)

  assert simplifile.is_file(filepath.join(out_dir, "index.html")) == Ok(True)
  assert simplifile.is_file(filepath.join(out_dir, "projects/index.html"))
    == Ok(True)
  assert simplifile.is_file(filepath.join(out_dir, "blog/index.html"))
    == Ok(True)
  assert simplifile.is_file(filepath.join(
      out_dir,
      "blog/what-is-dev-ing/index.html",
    ))
    == Ok(True)
  assert simplifile.is_file(filepath.join(out_dir, "blog/what-is-jj/index.html"))
    == Ok(True)
  assert simplifile.is_file(filepath.join(out_dir, "resume/index.html"))
    == Ok(True)
  assert simplifile.is_file(filepath.join(out_dir, "404.html")) == Ok(True)
  assert simplifile.is_file(filepath.join(out_dir, "prototypes/index.html"))
    == Ok(False)

  let _ = simplifile.delete(out_dir)
  Nil
}

/// Verifies `export.export_site` writes `.nojekyll`, `about/index.html`, and copied static assets.
///
pub fn export_site_copies_static_assets_nojekyll_and_about_alias_test() {
  let prod_ctx = context.prod_context("priv/static", "")
  let out_dir = "/tmp/dev_ing_website_stage2_assets_test"
  let _ = simplifile.delete(out_dir)

  let assert Ok(_report) = export.export_site(prod_ctx, out_dir)

  assert simplifile.is_file(filepath.join(out_dir, ".nojekyll")) == Ok(True)
  assert simplifile.is_file(filepath.join(out_dir, "about/index.html"))
    == Ok(True)
  assert simplifile.is_file(filepath.join(out_dir, "static/styles.css"))
    == Ok(True)
  assert simplifile.is_file(filepath.join(
      out_dir,
      "static/fonts/JetBrainsMono-Regular.woff2",
    ))
    == Ok(True)

  let _ = simplifile.delete(out_dir)
  Nil
}

/// Verifies `export.export_site` omits unpublished draft post directories when `Flag = OFF`.
///
pub fn export_site_omits_draft_post_dir_when_flag_off_test() {
  let prod_ctx = context.prod_context("priv/static", "")
  let out_dir = "/tmp/dev_ing_website_stage2_draft_off_test"
  let _ = simplifile.delete(out_dir)

  let assert Ok(_report) = export.export_site(prod_ctx, out_dir)
  assert simplifile.is_file(filepath.join(
      out_dir,
      "blog/bento-design-systems-in-gleam/index.html",
    ))
    == Ok(False)

  let _ = simplifile.delete(out_dir)
  Nil
}

/// Verifies `export.export_site` writes prototypes and draft posts when dev flags are ON.
///
pub fn export_site_writes_prototypes_and_draft_post_when_flag_on_test() {
  let dev_ctx = context.dev_context("priv/static")
  let out_dir = "/tmp/dev_ing_website_stage2_dev_on_test"
  let _ = simplifile.delete(out_dir)

  let assert Ok(_report) = export.export_site(dev_ctx, out_dir)
  assert simplifile.is_file(filepath.join(out_dir, "prototypes/index.html"))
    == Ok(True)
  assert simplifile.is_file(filepath.join(
      out_dir,
      "blog/bento-design-systems-in-gleam/index.html",
    ))
    == Ok(True)

  let _ = simplifile.delete(out_dir)
  Nil
}

/// Verifies exported HTML prefixes stylesheet and navigation links with `ctx.base_path`.
///
pub fn export_site_prefixes_links_with_base_path_test() {
  let gh_ctx = context.prod_context("priv/static", "/dev_ing")
  let out_dir = "/tmp/dev_ing_website_stage2_base_path_test"
  let _ = simplifile.delete(out_dir)

  let assert Ok(_report) = export.export_site(gh_ctx, out_dir)
  let assert Ok(index_html) =
    simplifile.read(from: filepath.join(out_dir, "index.html"))

  assert string.contains(index_html, "href=\"/dev_ing/static/styles.css\"")
  assert string.contains(index_html, "href=\"/dev_ing/resume\"")

  let _ = simplifile.delete(out_dir)
  Nil
}

/// Verifies `export.export_site` rejects an empty `output_dir`.
///
pub fn export_site_rejects_empty_output_dir_test() {
  let prod_ctx = context.prod_context("priv/static", "")
  assert export.export_site(prod_ctx, "   ")
    == Error(export.FileWriteError("   ", simplifile.Einval))
}

/// Verifies `export.export_site` fails cleanly when `static_directory` is missing.
///
pub fn export_site_returns_error_for_missing_static_dir_test() {
  let bad_ctx = context.prod_context("/tmp/nonexistent_static_dir_xyz", "")
  let out_dir = "/tmp/dev_ing_website_stage2_missing_static_test"
  let _ = simplifile.delete(out_dir)

  let result = export.export_site(bad_ctx, out_dir)
  let _ = simplifile.delete(out_dir)

  let assert Error(_) = result
  Nil
}
