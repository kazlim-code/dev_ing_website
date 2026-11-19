//// Pure blog post data models and lookup functions.
////

import gleam/list
import gleam/string

/// Represents an engineering blog post or learning journal entry.
///
pub type BlogPost {
  BlogPost(
    slug: String,
    title: String,
    published_date: String,
    author: String,
    published: Bool,
    tags: List(String),
    summary: String,
    paragraphs: List(String),
  )
}

/// Returns blog posts, filtering out unpublished drafts when `include_unpublished` is False.
///
pub fn list_posts(
  include_unpublished include_unpublished: Bool,
) -> List(BlogPost) {
  let posts = case include_unpublished {
    True -> all_posts()
    False ->
      all_posts()
      |> list.filter(fn(post) { post.published })
  }

  list.sort(posts, fn(a, b) {
    string.compare(b.published_date, a.published_date)
  })
}

/// Finds a single blog post by slug, respecting the `include_unpublished` flag.
///
pub fn find_by_slug(
  slug slug: String,
  include_unpublished include_unpublished: Bool,
) -> Result(BlogPost, Nil) {
  list_posts(include_unpublished:)
  |> list.find(fn(post) { post.slug == slug })
}

fn all_posts() -> List(BlogPost) {
  [
    BlogPost(
      slug: "what-is-dev-ing",
      title: "What is Dev_Ing?",
      published_date: "2026-11-11",
      author: "Callum Ingley",
      published: True,
      tags: ["Gleam", "Wisp", "Lustre", "MPA"],
      summary: "Why dev_ing evolved from a client-side Lustre single-page app into a server-rendered multi-page Gleam, Wisp, and Mist website with static GitHub Pages output.",
      paragraphs: [
        "The original dev_ing site started as an exploration of Gleam and Lustre compiled to JavaScript with client-side routing. While fun to build, hosting a single-page application on GitHub Pages required 404 redirect tricks and mixed view attributes into data models.",
        "In dev_ing_website, every page is rendered directly in pure Gleam on the BEAM using Lustre server-side HTML generation and Wisp routing. The exact same render_route function powers both the live Mist HTTP server during development and a static dist/ exporter for zero-cost hosting.",
        "Separating pure domain records from theme-parameterized Bento components keeps the markup easy to test with wisp/simulate and Birdie snapshots while paving the way for future BEAM features.",
      ],
    ),
    BlogPost(
      slug: "what-is-jj",
      title: "Experimenting with VCS other than Git (Jujutsu)",
      published_date: "2026-11-18",
      author: "Callum Ingley",
      published: True,
      tags: ["Jujutsu", "VCS", "Git", "Workflow"],
      summary: "Notes from adopting Jujutsu (jj) in a colocated Git repository for atomic revisions, frictionless rebases, and test-driven engineering.",
      paragraphs: [
        "Most day-to-day workflows treat version control as a staging ritual where you manually juggle index state, stashes, and branch checkouts before recording progress. Jujutsu (jj) turns the working copy itself into a live revision that automatically snapshots changes.",
        "Because jj runs colocated alongside Git, existing GitHub remotes and tooling continue to work seamlessly while jj gives you anonymous branches, conflict-tolerant rebases, and first-class undo via the operation log.",
        "Pairing jj with Test-Driven Development encourages smaller, cleaner revisions: one commit for failing Red Phase specs, one for Green implementation, and clean trailing empty revisions ready for the next task.",
      ],
    ),
    BlogPost(
      slug: "bento-design-systems-in-gleam",
      title: "Bento Design Systems in Gleam & Lustre",
      published_date: "2026-11-19",
      author: "Callum Ingley",
      published: False,
      tags: ["Design Systems", "Gleam", "Lustre", "CSS"],
      summary: "Draft exploration of theme-parameterized Lustre UI primitives, custom CSS token layouts, and interactive design prototyping.",
      paragraphs: [
        "When building an early UI library proof-of-concept like Glelements, it is tempting to hardcode utility strings directly inside page views. Moving to explicit Theme records flips that dependency around so every card, badge, and header adapts cleanly.",
        "Draft experiments on the /prototypes route compare the default Black & Orange carbon aesthetic against alternative industrial themes using identical component functions and Birdie snapshot coverage.",
      ],
    ),
  ]
}
