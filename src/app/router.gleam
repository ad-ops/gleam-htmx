import wisp.{type Request, type Response}
import app/web
import app/layout
import app/pages/hello.{hello}
import app/partials/demo.{demo}

pub fn handle_request(req: Request) -> Response {
  use req <- web.middleware(req)
  // let assert Ok(priv) = priv_directory("my_application")
  // use <- wisp.serve_static(req, under: "/static", from: priv)

  case wisp.path_segments(req) {
    [] -> layout.render_page(hello())
    ["partials", "demo"] -> layout.render_partial(demo())
    ["reload"] -> reload()
    _ -> wisp.not_found()
  }
}

fn reload() -> wisp.Response {
  wisp.no_content()
}