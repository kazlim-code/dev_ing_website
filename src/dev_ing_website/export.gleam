//// Static multi-page HTML exporter for GitHub Pages deployment (`dist/`).
////

import dev_ing_website/context.{type Context}
import dev_ing_website/router
import filepath
import gleam/erlang/charlist
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import simplifile

const max_static_copy_depth = 32

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
/// Refuses to export into an existing non-empty directory, across symlinks, or
/// into a directory nested inside `ctx.static_directory`.
///
pub fn export_site(
  ctx ctx: Context,
  output_dir output_dir: String,
) -> Result(ExportReport, ExportError) {
  case
    string.trim(output_dir) == "" || string.contains(output_dir, "\u{0000}")
  {
    True -> Error(FileWriteError(output_dir, simplifile.Einval))
    False -> {
      let clean_output_dir = strip_trailing_slashes(output_dir)
      let clean_static_dir = strip_trailing_slashes(ctx.static_directory)

      use _ <- result.try(ensure_real_directory(
        clean_static_dir,
        ctx.static_directory,
      ))
      use _ <- result.try(ensure_not_nested_inside_static(
        clean_static_dir,
        clean_output_dir,
        output_dir,
      ))
      use _ <- result.try(ensure_clean_output_dir(clean_output_dir, output_dir))
      use _ <- result.try(create_dir_mapped(clean_output_dir))

      use page_files <- result.try(
        list.try_fold(router.exportable_routes(ctx), [], fn(acc, entry) {
          let #(route, rel_path) = entry
          use _ <- result.try(validate_relative_path(rel_path))

          let full_path = filepath.join(clean_output_dir, rel_path)
          let parent_dir = filepath.directory_name(full_path)
          use _ <- result.try(create_dir_mapped(parent_dir))

          let #(_status, html_doc) = router.render_route(ctx, route)
          use _ <- result.try(write_file_mapped(full_path, html_doc))
          Ok([full_path, ..acc])
        }),
      )

      let nojekyll_path = filepath.join(clean_output_dir, ".nojekyll")
      use _ <- result.try(write_file_mapped(nojekyll_path, ""))

      let static_dest = filepath.join(clean_output_dir, "static")
      use static_files <- result.try(copy_directory_strict(
        clean_static_dir,
        static_dest,
        0,
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
  let clean_result = case simplifile.link_info("dist") {
    Error(simplifile.Enoent) -> Ok(Nil)
    Error(reason) -> Error(reason)
    Ok(info) ->
      case simplifile.file_info_type(info) {
        simplifile.Symlink -> Error(simplifile.Eloop)
        _ -> simplifile.delete("dist")
      }
  }

  case clean_result {
    Error(reason) -> {
      io.println_error(
        "Failed to clean dist/: " <> simplifile.describe_error(reason),
      )
      halt(1)
    }
    Ok(Nil) -> {
      let base_path =
        os_getenv(
          charlist.from_string("DEV_ING_BASE_PATH"),
          charlist.from_string("/dev_ing"),
        )
        |> charlist.to_string
      let ctx = context.prod_context("priv/static", base_path)

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
  }
}

fn ensure_real_directory(
  clean_path: String,
  raw_path: String,
) -> Result(Nil, ExportError) {
  case simplifile.link_info(clean_path) {
    Error(reason) -> Error(FileWriteError(raw_path, reason))
    Ok(info) ->
      case simplifile.file_info_type(info) {
        simplifile.Directory -> Ok(Nil)
        simplifile.File -> Error(FileWriteError(raw_path, simplifile.Enotdir))
        simplifile.Symlink | simplifile.Other ->
          Error(FileWriteError(raw_path, simplifile.Eloop))
      }
  }
}

fn ensure_not_nested_inside_static(
  clean_static_dir: String,
  clean_output_dir: String,
  raw_output_dir: String,
) -> Result(Nil, ExportError) {
  use resolved_src <- result.try(
    simplifile.resolve(clean_static_dir)
    |> result.map_error(fn(err) { FileWriteError(clean_static_dir, err) }),
  )
  use resolved_out <- result.try(
    simplifile.resolve(clean_output_dir)
    |> result.map_error(fn(err) { FileWriteError(raw_output_dir, err) }),
  )

  let is_nested =
    resolved_src == "/"
    || resolved_out == resolved_src
    || string.starts_with(resolved_out, resolved_src <> "/")

  case is_nested {
    True -> Error(FileWriteError(raw_output_dir, simplifile.Einval))
    False -> Ok(Nil)
  }
}

fn ensure_clean_output_dir(
  clean_output_dir: String,
  raw_output_dir: String,
) -> Result(Nil, ExportError) {
  case simplifile.link_info(clean_output_dir) {
    Error(simplifile.Enoent) -> Ok(Nil)
    Error(reason) -> Error(FileWriteError(raw_output_dir, reason))
    Ok(info) ->
      case simplifile.file_info_type(info) {
        simplifile.Directory ->
          case simplifile.read_directory(clean_output_dir) {
            Ok([]) -> Ok(Nil)
            Ok(_) -> Error(FileWriteError(raw_output_dir, simplifile.Eexist))
            Error(reason) -> Error(FileWriteError(raw_output_dir, reason))
          }
        simplifile.Symlink ->
          Error(FileWriteError(raw_output_dir, simplifile.Eloop))
        _ -> Error(FileWriteError(raw_output_dir, simplifile.Eexist))
      }
  }
}

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
  depth: Int,
) -> Result(List(String), ExportError) {
  case depth > max_static_copy_depth {
    True -> Error(FileWriteError(src_dir, simplifile.Eloop))
    False -> {
      use _ <- result.try(ensure_real_directory(src_dir, src_dir))
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
          False ->
            case string.starts_with(entry, ".") {
              True -> Ok(acc)
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
                      |> result.map_error(fn(err) {
                        FileWriteError(dest_path, err)
                      }),
                    )
                    Ok(list.append(acc, [dest_path]))
                  }
                  simplifile.Directory -> {
                    use nested <- result.try(copy_directory_strict(
                      src_path,
                      dest_path,
                      depth + 1,
                    ))
                    Ok(list.append(acc, nested))
                  }
                  simplifile.Symlink | simplifile.Other ->
                    Error(FileWriteError(src_path, simplifile.Eloop))
                }
              }
            }
        }
      })
    }
  }
}

fn strip_trailing_slashes(value: String) -> String {
  case string.ends_with(value, "/") && value != "/" {
    True -> strip_trailing_slashes(string.drop_end(value, 1))
    False -> value
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

@external(erlang, "os", "getenv")
fn os_getenv(
  name: charlist.Charlist,
  default: charlist.Charlist,
) -> charlist.Charlist

@external(erlang, "erlang", "halt")
fn halt(status: Int) -> Nil
