//// Unit tests for `dev_ing_website/data/project` (`T08`).
////

import dev_ing_website/data/project
import gleam/list

/// T08: Verifies pure project data (B1.2) includes personal and work portfolio entries.
///
pub fn projects_include_personal_and_work_entries_test() {
  let slugs =
    project.all_projects()
    |> list.map(fn(p) { p.slug })

  assert list.contains(slugs, "dev-ing")
  assert list.contains(slugs, "glelements")
  assert list.contains(slugs, "wyrd-technology")
  assert list.contains(slugs, "grafa")
}
