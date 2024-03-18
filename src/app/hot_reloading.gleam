import envoy
import nakai/html
import nakai/html/attrs

pub fn add_hot_reloading() -> List(html.Node(n)) {
  case envoy.get("DEVELOPMENT") {
    Ok("0") | Ok("false") | Ok("FALSE") -> [html.Nothing]
    Ok(_) -> hot_reloading()
    Error(_) -> [html.Nothing]
  }
}

fn hot_reloading() -> List(html.Node(n)) {
  [
    html.div(
      [
        attrs.Attr("hx-get", "/reload"),
        attrs.Attr("hx-trigger", "every 0.5s"),
        attrs.Attr("hx-target", "#hot-reload"),
      ],
      [
        html.div([attrs.id("hot-reload")], [
          html.Comment(
            "This is a placeholder for the hot-reload response. It will be replaced by the server.",
          ),
          html.Nothing,
        ]),
      ],
    ),
    html.Script(
      "
      let serverStopped = false;
      let reload = undefined;
      document.body.addEventListener('htmx:sendError', function(evt) {
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
