//// Static multi-page HTML exporter for GitHub Pages deployment (`dist/`).
////

import dev_ing_website/context.{type Context}
import dev_ing_website/router
import filepath
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
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
  ctx ctx: Context,
  output_dir output_dir: String,
) -> Result(ExportReport, ExportError) {
  case string.trim(output_dir) == "" {
    True -> Error(FileWriteError(output_dir, simplifile.Einval))
    False -> {
      use _ <- result.try(create_dir_mapped(output_dir))

      use page_files <- result.try(
        list.try_fold(router.exportable_routes(ctx), [], fn(acc, entry) {
          let #(route, rel_path) = entry
          use _ <- result.try(validate_relative_path(rel_path))

          let full_path = filepath.join(output_dir, rel_path)
          let parent_dir = filepath.directory_name(full_path)
          use _ <- result.try(create_dir_mapped(parent_dir))

          let #(_status, html_doc) = router.render_route(ctx, route)
          use _ <- result.try(write_file_mapped(full_path, html_doc))
          Ok([full_path, ..acc])
        }),
      )

      let nojekyll_path = filepath.join(output_dir, ".nojekyll")
      use _ <- result.try(write_file_mapped(nojekyll_path, ""))

      let static_dest = filepath.join(output_dir, "static")
      use static_files <- result.try(copy_directory_strict(
        ctx.static_directory,
        static_dest,
      ))

      let files_written =
        list.flatten([list.reverse(page_files), [nojekyll_path], static_files])

      Ok(ExportReport(output_dir:, files_written:))
    }
  }
}

/// CLI entrypoint (`gleam run -m dev_ing_website/export`).
///
pub fn main() -> Nil {
  let _ = simplifile.delete("dist")
  let ctx = context.prod_context("priv/static", "/dev_ing")
  case export_site(ctx:, output_dir: "dist") {
    Ok(report) ->
      io.println(
        "Exported "
        <> int.to_string(list.length(report.files_written))
        <> " files to "
        <> report.output_dir,
      )
    Error(FileWriteError(path, reason)) -> {
      io.println_error(
        "Static export failed at "
        <> path
        <> ": "
        <> simplifile.describe_error(reason),
      )
      halt(1)
    }
  }
}

@external(erlang, "erlang", "halt")
fn halt(status: Int) -> Nil

fn validate_relative_path(rel_path: String) -> Result(Nil, ExportError) {
  let has_bad_segment =
    list.any(string.split(rel_path, "/"), fn(segment) {
      segment == "" || segment == "." || segment == ".."
    })

  case
    filepath.is_absolute(rel_path)
    || string.contains(rel_path, "\\")
    || string.contains(rel_path, "\u{0000}")
    || has_bad_segment
  {
    True -> Error(FileWriteError(rel_path, simplifile.Einval))
    False -> Ok(Nil)
  }
}

fn copy_directory_strict(
  src_dir: String,
  dest_dir: String,
) -> Result(List(String), ExportError) {
  use is_dir <- result.try(
    simplifile.is_directory(src_dir)
    |> result.map_error(fn(err) { FileWriteError(src_dir, err) }),
  )

  case is_dir {
    False -> Error(FileWriteError(src_dir, simplifile.Enotdir))
    True -> {
      use _ <- result.try(create_dir_mapped(dest_dir))
      use entries <- result.try(
        simplifile.read_directory(src_dir)
        |> result.map_error(fn(err) { FileWriteError(src_dir, err) }),
      )

      entries
      |> list.sort(string.compare)
      |> list.try_fold([], fn(acc, entry) {
        case
          entry == "."
          || entry == ".."
          || string.contains(entry, "/")
          || string.contains(entry, "\\")
        {
          True ->
            Error(FileWriteError(
              filepath.join(src_dir, entry),
              simplifile.Einval,
            ))
          False -> {
            let src_path = filepath.join(src_dir, entry)
            let dest_path = filepath.join(dest_dir, entry)

            use info <- result.try(
              simplifile.link_info(src_path)
              |> result.map_error(fn(err) { FileWriteError(src_path, err) }),
            )

            case simplifile.file_info_type(info) {
              simplifile.File -> {
                use _ <- result.try(
                  simplifile.copy_file(at: src_path, to: dest_path)
                  |> result.map_error(fn(err) { FileWriteError(dest_path, err) }),
                )
                Ok(list.append(acc, [dest_path]))
              }
              simplifile.Directory -> {
                use nested <- result.try(copy_directory_strict(
                  src_path,
                  dest_path,
                ))
                Ok(list.append(acc, nested))
              }
              simplifile.Symlink | simplifile.Other ->
                Error(FileWriteError(src_path, simplifile.Eloop))
            }
          }
        }
      })
    }
  }
}

fn create_dir_mapped(path: String) -> Result(Nil, ExportError) {
  simplifile.create_directory_all(path)
  |> result.map_error(fn(err) { FileWriteError(path, err) })
}

fn write_file_mapped(
  path: String,
  contents: String,
) -> Result(Nil, ExportError) {
  simplifile.write(to: path, contents:)
  |> result.map_error(fn(err) { FileWriteError(path, err) })
}
