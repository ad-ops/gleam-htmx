import envoy
import gleam/string_builder.{type StringBuilder}
import nakai
import nakai/html
import nakai/html/attrs
import wisp

pub fn layout(page: html.Node(a)) {
  let hot_reloading_scripts = case envoy.get("DEVELOPMENT") {
    Ok("0") | Ok("false") | Ok("FALSE") -> [html.Nothing]
    Ok(_) -> hot_reloading()
    Error(_) -> [html.Nothing]
  }

  let layout =
    html.Html([], [
      html.Doctype("html"),
      html.Head([
        html.meta([attrs.charset("UTF-8")]),
        html.meta([
          attrs.name("viewport"),
          attrs.content("width=device-width, initial-scale=1.0"),
        ]),
        html.title("HTMX Gleam!"),
      ]),
      html.Body([], [
        html.h1([], [html.Text("Hello, World!")]),
        page,
        ..hot_reloading_scripts
      ]),
    ])

  layout
}

pub fn render_page(page: html.Node(a)) {
  let content =
    page
    |> layout
    |> nakai.to_inline_string_builder
    |> inject_script_src

  wisp.ok()
  |> wisp.html_body(content)
}

pub fn render_partial(partial: html.Node(a)) {
  let content =
    partial
    |> nakai.to_inline_string_builder
    |> inject_script_src

  wisp.ok()
  |> wisp.html_body(content)
}

fn inject_script_src(html: StringBuilder) -> StringBuilder {
  html
  |> string_builder.replace(
    "</head>",
    "<script src='https://unpkg.com/htmx.org@1.9.10'></script></head>",
  )
}

fn hot_reloading() -> List(html.Node(n)) {
  [
    html.div(
      [
        attrs.id("reload"),
        attrs.Attr("hx-get", "/reload"),
        attrs.Attr("hx-trigger", "every 0.5s"),
        attrs.Attr("hx-target", "#hot-reload"),
      ],
      [
        html.div([attrs.id("hot-reload")], [
          html.Text("This will reload every second"),
        ]),
      ],
    ),
    html.Script(
      "
      let serverStopped = false;
      let reload = undefined;
      document.body.addEventListener('htmx:sendError', function(evt) {
          console.log(evt)
          const target = evt.detail.target;
          if (target.id === 'hot-reload') {
              serverStopped = true;
          }
      });
      document.body.addEventListener('htmx:afterRequest', function(evt) {
          const target = evt.detail.target;
          if (target.id === 'hot-reload') {
              if (evt.detail.failed) {
                  serverStopped = true;
              }
              if (evt.detail.successful) {
                  if (serverStopped) {
                      console.log('Server restarted!');
                      serverStopped = false;
                      window.location.reload();
                  }
              }
          }
      });
      ",
    ),
  ]
}
