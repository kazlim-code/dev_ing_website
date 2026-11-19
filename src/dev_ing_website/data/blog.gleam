//// Pure blog post data models and lookup functions.
////

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
  include_unpublished _include_unpublished: Bool,
) -> List(BlogPost) {
  todo as "Stage 1A stub: list_posts"
}

/// Finds a single blog post by slug, respecting the `include_unpublished` flag.
///
pub fn find_by_slug(
  slug _slug: String,
  include_unpublished _include_unpublished: Bool,
) -> Result(BlogPost, Nil) {
  todo as "Stage 1A stub: find_by_slug"
}
