//// Pure project data models and records for personal and professional work.
////

import gleam/list

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
  [
    Project(
      slug: "dev-ing",
      title: "Dev.Ing",
      category: Personal,
      featured: True,
      summary: "Personal developer portfolio and engineering journal evolving from a client-side Lustre SPA into a server-rendered multi-page Gleam, Wisp, and Mist application with hybrid static GitHub Pages export.",
      highlights: [
        "Pure Gleam multi-page architecture rendered server-side via Lustre",
        "Dual runtime supporting a live Wisp + Mist server and static dist/ export",
        "Strict Test-Driven Development with wisp/simulate and Birdie snapshots",
      ],
      icon_path: "/static/icons/dev-ing.webp",
      external_url: "https://github.com/kazlim-code/dev-ing",
      technologies: [
        Technology("Gleam", "/static/icons/lucy.webp", "https://gleam.run"),
        Technology(
          "Lustre",
          "/static/icons/lustre.webp",
          "https://hexdocs.pm/lustre/",
        ),
        Technology(
          "Wisp",
          "/static/icons/lucy.webp",
          "https://hexdocs.pm/wisp/",
        ),
        Technology(
          "Jujutsu",
          "/static/icons/jj-logo.webp",
          "https://jj-vcs.github.io/jj/latest/",
        ),
      ],
    ),
    Project(
      slug: "glelements",
      title: "Glelements",
      category: Personal,
      featured: True,
      summary: "Early Lustre UI component library proof-of-concept exploring reusable design tokens and black-and-orange styling in Gleam, whose lessons directly shaped dev_ing_website's theme-parameterized component primitives.",
      highlights: [
        "Established the signature black-and-orange design token palette",
        "Tested declarative Lustre component composition patterns",
        "Informs the in-repo theme.gleam and Bento component architecture",
      ],
      icon_path: "/static/icons/glelements.webp",
      external_url: "https://github.com/kazlim-code",
      technologies: [
        Technology("Gleam", "/static/icons/lucy.webp", "https://gleam.run"),
        Technology(
          "Lustre",
          "/static/icons/lustre.webp",
          "https://hexdocs.pm/lustre/",
        ),
        Technology(
          "CSS3",
          "/static/icons/css3.webp",
          "https://developer.mozilla.org/en-US/docs/Web/CSS",
        ),
      ],
    ),
    Project(
      slug: "wyrd-technology",
      title: "Wyrd Technology",
      category: Work,
      featured: True,
      summary: "Cross-platform mobile and web engineering delivering production user workflows across iOS, Android, and modern web frontends.",
      highlights: [
        "Built Capacitor hybrid mobile features bridging Swift and Kotlin native plugins",
        "Delivered responsive Vue and TypeScript interfaces backed by automated testing",
        "Collaborated across iterative product releases and cross-platform builds",
      ],
      icon_path: "/static/icons/wyrd-technology-icon.webp",
      external_url: "",
      technologies: [
        Technology(
          "TypeScript",
          "/static/icons/typescript.webp",
          "https://www.typescriptlang.org",
        ),
        Technology("Vue", "/static/icons/vue.webp", "https://vuejs.org"),
        Technology(
          "Capacitor",
          "/static/icons/capacitor.webp",
          "https://capacitorjs.com",
        ),
        Technology("Swift", "/static/icons/swift.webp", "https://www.swift.org"),
        Technology(
          "Kotlin",
          "/static/icons/kotlin.webp",
          "https://kotlinlang.org",
        ),
      ],
    ),
    Project(
      slug: "grafa",
      title: "Grafa",
      category: Work,
      featured: True,
      summary: "Full-stack engineering on data-rich financial media and analytics applications spanning web interfaces, API services, and cloud infrastructure.",
      highlights: [
        "Developed TypeScript and Nuxt web applications for high-density market insights",
        "Integrated PostgreSQL data pipelines and AWS cloud services",
        "Maintained design consistency and API reliability across fast-moving releases",
      ],
      icon_path: "/static/icons/grafa-icon.webp",
      external_url: "",
      technologies: [
        Technology(
          "TypeScript",
          "/static/icons/typescript.webp",
          "https://www.typescriptlang.org",
        ),
        Technology("Nuxt", "/static/icons/nuxt.webp", "https://nuxt.com"),
        Technology(
          "PostgreSQL",
          "/static/icons/postgresql.webp",
          "https://www.postgresql.org",
        ),
        Technology("AWS", "/static/icons/aws.webp", "https://aws.amazon.com"),
      ],
    ),
  ]
}

/// Returns featured projects surfaced on the home page Bento grid.
///
pub fn featured_projects() -> List(Project) {
  all_projects()
  |> list.filter(fn(project) { project.featured })
}

/// Filters projects by category (`Personal` or `Work`).
///
pub fn by_category(category category: ProjectCategory) -> List(Project) {
  all_projects()
  |> list.filter(fn(project) { project.category == category })
}
