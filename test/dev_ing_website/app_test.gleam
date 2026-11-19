//// Unit tests for `dev_ing_website` entrypoint configuration.
////

import dev_ing_website
import dev_ing_website/context

/// Verifies `context_for_env` defaults safely to production feature flags (`Flag = OFF`).
///
pub fn app_context_defaults_to_prod_when_env_unset_or_prod_test() {
  let prod_ctx = dev_ing_website.context_for_env("", "priv/static")
  assert !context.prototypes_enabled(prod_ctx)
  assert !context.unpublished_posts_enabled(prod_ctx)
  assert !context.resume_filters_enabled(prod_ctx)
}

/// Verifies `context_for_env` enables development feature flags only when explicitly requested.
///
pub fn app_context_enables_dev_flags_when_env_is_dev_test() {
  let dev_ctx = dev_ing_website.context_for_env("dev", "priv/static")
  assert context.prototypes_enabled(dev_ctx)
  assert context.unpublished_posts_enabled(dev_ctx)
}
