//// Static multi-page HTML exporter for GitHub Pages deployment (`dist/`).
////

import dev_ing_website/context.{type Context}
import simplifile

/// Errors that can occur during static site export.
///
pub type ExportError {
  FileWriteError(path: String, reason: simplifile.FileError)
}

/// Summary report returned after exporting all routes to `output_dir`.
///
pub type ExportReport {
  ExportReport(output_dir: String, files_written: List(String))
}

/// Exports all enabled routes and static assets to `output_dir`.
///
pub fn export_site(
  ctx _ctx: Context,
  output_dir _output_dir: String,
) -> Result(ExportReport, ExportError) {
  todo as "Stage 1A stub: export_site"
}

/// CLI entrypoint (`gleam run -m dev_ing_website/export`).
///
pub fn main() -> Nil {
  todo as "Stage 1A stub: export main"
}
