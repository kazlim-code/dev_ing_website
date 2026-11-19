//// Integration tests for `dev_ing_website/export` (`T24`).
////

import dev_ing_website/context
import dev_ing_website/export
import filepath
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
