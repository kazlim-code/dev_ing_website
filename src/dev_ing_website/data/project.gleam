//// Pure project data models and records for personal and professional work.
////

/// Categorizes a project as either personal exploration or commercial work.
///
pub type ProjectCategory {
  Personal
  Work
}

/// Metadata for a technology badge linked to an official resource.
///
pub type Technology {
  Technology(label: String, icon_path: String, href: String)
}

/// Pure data representation of a portfolio project.
///
pub type Project {
  Project(
    slug: String,
    title: String,
    category: ProjectCategory,
    featured: Bool,
    summary: String,
    highlights: List(String),
    icon_path: String,
    external_url: String,
    technologies: List(Technology),
  )
}

/// Returns all portfolio projects (both personal and professional work).
///
pub fn all_projects() -> List(Project) {
  todo as "Stage 1A stub: all_projects"
}

/// Returns featured projects surfaced on the home page Bento grid.
///
pub fn featured_projects() -> List(Project) {
  todo as "Stage 1A stub: featured_projects"
}

/// Filters projects by category (`Personal` or `Work`).
///
pub fn by_category(category _category: ProjectCategory) -> List(Project) {
  todo as "Stage 1A stub: by_category"
}
