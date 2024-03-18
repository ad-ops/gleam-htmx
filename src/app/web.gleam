import wisp.{type Request, type Response}

pub fn middleware(
  req: wisp.Request,
  handle_request: fn(wisp.Request) -> wisp.Response,
) -> wisp.Response {
  let req = wisp.method_override(req)
  use <- selective_logging(req)
  use <- wisp.rescue_crashes
  use req <- wisp.handle_head(req)

  handle_request(req)
}

// ignores some paths when logging
fn selective_logging(req: Request, usage: fn() -> Response) -> Response {
  case req.path {
    "/reload" -> usage()
    _ -> wisp.log_request(req, usage)
  }
}
