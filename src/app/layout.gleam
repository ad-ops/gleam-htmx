import app/hot_reloading
import gleam/string_builder.{type StringBuilder}
import nakai
import nakai/html
import nakai/html/attrs
import wisp

pub fn layout(page: html.Node(a)) {
  let hot_reloading_scripts = hot_reloading.add_hot_reloading()

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

  wisp.ok()
  |> wisp.html_body(content)
}

// ugly hack to inject the htmx script tag into the html since nakai does not
fn inject_script_src(html: StringBuilder) -> StringBuilder {
  html
  |> string_builder.replace(
    "</head>",
    "<script src='https://unpkg.com/htmx.org@1.9.10'></script></head>",
  )
}
