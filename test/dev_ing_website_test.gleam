//// Main Gleeunit test entry point for `dev_ing_website`.
////
//// Unit and Birdie snapshot tests are organized into mirrored modules under
//// `test/dev_ing_website/` and shared helpers in `test/test_support.gleam`.
////

import gleeunit

/// Runs the gleeunit test suite, discovering all `*_test` functions in `test/`.
///
pub fn main() -> Nil {
  gleeunit.main()
}
