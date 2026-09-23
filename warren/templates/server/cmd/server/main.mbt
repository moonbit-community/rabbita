///|
async fn main {
  let host = @env.get_env_var("WARREN_HOST").unwrap_or("127.0.0.1")
  let port = @string.parse_uint(
    @env.get_env_var("WARREN_PORT").unwrap_or("4300"),
  )
  guard port > 0 && port <= 65535 else { fail("Invalid WARREN_PORT") }
  let dist = @env.get_env_var("WARREN_DIST").unwrap_or(
    @path.Path(@env.args()[0]).resolve().dirname().to_string(),
  )
  let assets = warren_assets()
  let dev = @env.get_env_var("WARREN_MODE") == Some("DEV")
  let client = if dev { @env.get_env_var("WARREN_CLIENT") } else { None }
  let resources = if dev || assets.is_empty() {
    @static.new(root=dist, rewrite_trailing_slash_index=true)
  } else {
    @static.from_assets(assets, rewrite_trailing_slash_index=true)
  }
  let app = @moonback.App(ctx => {
    ctx.add_middleware(
      @moonback.Middleware(next => {
        let serve = (resources.0)(next)
        (req, res) => {
          if client is Some(_) && req.path == "/" {
            next(req, res)
          } else {
            serve(req, res)
          }
        }
      }),
    )
    if client is Some(client) {
      ctx.get("/", (_req, res) => {
        let html = @fs.read_file(
          @path.Path(dist).join("index.html").to_string(),
        ).text()
        let (head, tail) = html
          .split_once("</head>")
          .map_or((html, ""), parts => (parts.0.to_owned(), "</head>\{parts.1}"))
        res.send_html(
          @moonback.Html(b => {
            b <+ "\{@moonback.Html::raw(head)}"
            b <+ "<script src=\"\{client}\" defer></script>"
            b <+ "\{@moonback.Html::raw(tail)}"
          }),
        )
      })
    }
    ctx.get("/api/hello", (_req, res) => res.send_text("Hello from Moonback"))
  })
  defer app.close()
  let listener = @moonback.listen(host~, port=port.to_uint16(), reuse_addr=true)
  println("Server is running on http://\{host}:\{port}")
  app.serve(listener)
}
