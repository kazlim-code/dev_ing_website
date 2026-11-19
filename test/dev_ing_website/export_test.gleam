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

/// Verifies `export.export_site` refuses a non-empty `output_dir` so stale dev artifacts cannot persist.
///
pub fn export_site_rejects_non_empty_output_dir_test() {
  let prod_ctx = context.prod_context("priv/static", "")
  let out_dir = "/tmp/dev_ing_website_stage3_non_empty_test"
  let _ = simplifile.delete(out_dir)
  let assert Ok(Nil) = simplifile.create_directory_all(out_dir)
  let stale_file = filepath.join(out_dir, "stale.html")
  let assert Ok(Nil) = simplifile.write(to: stale_file, contents: "stale")

  let result = export.export_site(prod_ctx, out_dir)
  let _ = simplifile.delete(out_dir)

  assert result == Error(export.FileWriteError(out_dir, simplifile.Eexist))
}

/// Verifies `export.export_site` skips dotfiles (such as `.DS_Store`) in `static_directory`.
///
pub fn export_site_skips_dotfiles_in_static_dir_test() {
  let src_dir = "/tmp/dev_ing_website_stage3_src_dotfile_test"
  let out_dir = "/tmp/dev_ing_website_stage3_out_dotfile_test"
  let _ = simplifile.delete(src_dir)
  let _ = simplifile.delete(out_dir)

  let assert Ok(Nil) = simplifile.create_directory_all(src_dir)
  let assert Ok(Nil) =
    simplifile.write(to: filepath.join(src_dir, "ok.css"), contents: "body{}")
  let assert Ok(Nil) =
    simplifile.write(to: filepath.join(src_dir, ".DS_Store"), contents: "junk")

  let ctx = context.prod_context(src_dir, "")
  let assert Ok(_report) = export.export_site(ctx, out_dir)

  let ok_exists = simplifile.is_file(filepath.join(out_dir, "static/ok.css"))
  let dotfile_exists =
    simplifile.is_file(filepath.join(out_dir, "static/.DS_Store"))

  let _ = simplifile.delete(src_dir)
  let _ = simplifile.delete(out_dir)

  assert ok_exists == Ok(True)
  assert dotfile_exists == Ok(False)
}
