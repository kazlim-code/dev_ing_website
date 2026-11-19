//// Unit tests for `dev_ing_website/data/blog` (`T09`–`T10` plus slug lookup and ordering).
////

import dev_ing_website/data/blog
import gleam/list

/// T09: Verifies `blog.list_posts(include_unpublished: False)` excludes draft posts (`Flag = OFF`).
///
pub fn blog_list_posts_excludes_drafts_when_flag_off_test() {
  let posts = blog.list_posts(include_unpublished: False)
  assert posts != []
  assert list.all(posts, fn(post) { post.published })
}

/// T10: Verifies `blog.list_posts(include_unpublished: True)` includes draft posts (`Flag = ON`).
///
pub fn blog_list_posts_includes_drafts_when_flag_on_test() {
  let posts = blog.list_posts(include_unpublished: True)
  assert list.any(posts, fn(post) { !post.published })
}

/// Verifies `blog.find_by_slug` hides draft posts when `include_unpublished` is False.
///
pub fn blog_find_by_slug_hides_draft_when_flag_off_test() {
  assert blog.find_by_slug(
      slug: "bento-design-systems-in-gleam",
      include_unpublished: False,
    )
    == Error(Nil)
}

/// Verifies `blog.find_by_slug` returns draft posts when `include_unpublished` is True.
///
pub fn blog_find_by_slug_returns_draft_when_flag_on_test() {
  let assert Ok(post) =
    blog.find_by_slug(
      slug: "bento-design-systems-in-gleam",
      include_unpublished: True,
    )
  assert !post.published
}

/// Verifies `blog.find_by_slug` returns `Error(Nil)` for unknown slugs.
///
pub fn blog_find_by_slug_returns_error_for_unknown_slug_test() {
  assert blog.find_by_slug(slug: "nonexistent-slug", include_unpublished: True)
    == Error(Nil)
}

/// Verifies `blog.list_posts` returns posts sorted newest-first by `published_date`.
///
pub fn blog_list_posts_orders_newest_first_test() {
  let assert [first, second, ..] = blog.list_posts(include_unpublished: False)
  assert first.published_date == "2026-11-18"
  assert second.published_date == "2026-11-11"
}
