//// Live Mist + Wisp HTTP server entry point for `dev_ing_website`.
////

import dev_ing_website/context
import dev_ing_website/router
import filepath
import gleam/erlang/process
import mist
import simplifile
import wisp
import wisp/wisp_mist

/// Starts the local Wisp + Mist web server on port 8000 using development context defaults.
///
pub fn main() -> Nil {
  wisp.configure_logger()
  let secret_key_base = wisp.random_string(64)
  let static_directory = resolve_static_directory()
  let ctx = context.dev_context(static_directory:)

  let assert Ok(_) =
    router.handle_request(_, ctx)
    |> wisp_mist.handler(secret_key_base)
    |> mist.new
    |> mist.port(8000)
    |> mist.start

  process.sleep_forever()
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
