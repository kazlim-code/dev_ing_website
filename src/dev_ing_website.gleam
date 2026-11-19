//// Live Mist + Wisp HTTP server entry point for `dev_ing_website`.
////

import dev_ing_website/context
import dev_ing_website/router
import filepath
import gleam/erlang/charlist
import gleam/erlang/process
import gleam/io
import gleam/string
import mist
import simplifile
import wisp
import wisp/wisp_mist

/// Resolves runtime `Context` from `DEV_ING_ENV` (`"dev"` or `"development"` enables
/// development flags; all other values default safely to production flags).
///
pub fn context_for_env(
  env_value env_value: String,
  static_directory static_directory: String,
) -> context.Context {
  case string.lowercase(string.trim(env_value)) {
    "dev" | "development" -> context.dev_context(static_directory:)
    _ -> context.prod_context(static_directory:, base_path: "")
  }
}

/// Starts the local Wisp + Mist web server on port 8000, defaulting to production
/// feature flags unless `DEV_ING_ENV` is set to `"dev"` or `"development"`.
///
pub fn main() -> Nil {
  wisp.configure_logger()
  let secret_key_base = wisp.random_string(64)
  let static_directory = resolve_static_directory()
  let env_mode =
    os_getenv(charlist.from_string("DEV_ING_ENV"), charlist.from_string("prod"))
    |> charlist.to_string
  let ctx = context_for_env(env_value: env_mode, static_directory:)

  case
    router.handle_request(_, ctx)
    |> wisp_mist.handler(secret_key_base)
    |> mist.new
    |> mist.port(8000)
    |> mist.start
  {
    Ok(_) -> process.sleep_forever()
    Error(reason) -> {
      io.println_error(
        "Failed to start Mist server: " <> string.inspect(reason),
      )
      halt(1)
    }
  }
}

fn resolve_static_directory() -> String {
  case wisp.priv_directory("dev_ing_website") {
    Ok(priv_dir) -> {
      let candidate = filepath.join(priv_dir, "static")
      case simplifile.is_directory(candidate) {
        Ok(True) -> candidate
        _ -> "priv/static"
      }
    }
    Error(Nil) -> "priv/static"
  }
}

@external(erlang, "os", "getenv")
fn os_getenv(
  name: charlist.Charlist,
  default: charlist.Charlist,
) -> charlist.Charlist

@external(erlang, "erlang", "halt")
fn halt(status: Int) -> Nil
