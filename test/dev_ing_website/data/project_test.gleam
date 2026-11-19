//// Unit tests for `dev_ing_website/data/project` (`T08` plus category and featured filters).
////

import dev_ing_website/data/project.{Personal, Work}
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

/// Verifies `project.featured_projects` returns only featured portfolio items.
///
pub fn projects_featured_returns_featured_entries_test() {
  let featured = project.featured_projects()
  assert featured != []
  assert list.all(featured, fn(p) { p.featured })
}

/// Verifies `project.by_category` partitions Personal and Work projects cleanly.
///
pub fn projects_by_category_separates_personal_and_work_test() {
  let personal_slugs =
    project.by_category(Personal)
    |> list.map(fn(p) { p.slug })
  let work_slugs =
    project.by_category(Work)
    |> list.map(fn(p) { p.slug })

  assert personal_slugs == ["dev-ing", "glelements"]
  assert work_slugs == ["wyrd-technology", "grafa"]
}
