import nakai/html
import nakai/html/attrs

pub fn hello() {
  html.div([], [
    html.p_text([attrs.id("hello-text")], "Hello, world!"),
    html.button_text(
      [
        attrs.Attr("hx-get", "/partials/demo"),
        attrs.Attr("hx-target", "#hello-text"),
      ],
      "Click Me!",
    ),
  ])
}
