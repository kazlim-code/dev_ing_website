//// Unit tests for `dev_ing_website/data/blog` (`T09`–`T10`).
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
