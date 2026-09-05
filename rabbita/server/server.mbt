///|
using @html {nothing, script, link}

///|
using @rabbita {type Val, type Html}

///|
priv enum RunningMode {
  Prod
  Dev
}

///|
struct Server {
  app : @moonback.App
  port : UInt16
}

///|
pub fn Server::close(self : Self) -> Unit {
  self.app.close()
}

///|
#internal(experimental, "This API is unstable and may change in the future.")
pub async fn Server::Server(
  api~ : @moonback.Module,
  port~ : UInt16,
  dist? : @path.Path,
  component? : () -> Val[Html],
  silent? : Bool = false,
) -> Self {
  // invariants
  // WARREN_MODE: set `DEV` when `warren dev` running
  // WARREN_PORT: port in develop
  // WARREN_CLIENT: dev client src
  // WARREN_DIST: dev dist path
  let {
    "WARREN_CLIENT"? : warren_client,
    "WARREN_DIST"? : warren_dist,
    "WARREN_MODE"? : warren_mode,
    "WARREN_PORT"? : warren_port,
    ..
  } = @env.get_env_vars()
  let mode = match warren_mode {
    Some("DEV") => Dev
    _ => Prod
  }
  let dist = match mode {
    Dev => warren_dist
    Prod => dist.map(Show::to_string)
  }
  let port = match mode {
    Dev => {
      let s = warren_port.unwrap_or_error(Failure("env WARREN_PORT not found"))
      @string.parse_uint(s).to_uint16()
    }
    Prod => port
  }
  let dist = match dist {
    Some(p) if mode is Prod => Some(p.to_string())
    _ => @env.get_env_var("WARREN_DIST")
  }
  let app = @moonback.App(ctx => {
    ctx.use_(page_service(port~, warren_client?, dist?, component?))
    api(ctx)
  })
  if !silent {
    println("Server is running on http://127.0.0.1:\{port}")
  }
  { app, port, }
}

///|
pub async fn Server::run_forever(self : Self) -> Unit {
  let listener = @moonback.listen(reuse_addr=true, port=self.port)
  self.app.serve(listener)
}

///|
fn page_service(
  component? : () -> Val[Html],
  dist? : String,
  port~ : UInt16,
  warren_client? : String,
) -> @moonback.Module {
  let head = [
    link(rel="stylesheet", href="/styles.css"),
    script(src="/index.js", type_="module", nothing),
    ..if warren_client is Some(src) && src != "" {
      Some(@html.script(src~, defer_=true, @html.nothing))
    },
  ]

  ctx => {
    if dist is Some(dir) {
      ctx.add_middleware(@static.new(root=dir.to_string()))
    }
    if component is Some(component) {
      ctx.get("/", (req, res) => {
        let host = req.headers.get("Host").unwrap_or("127.0.0.1:\{port}")
        let url = if req.search is Some(search) {
          "http://\{host}\{req.path}?\{search}"
        } else {
          "http://\{host}\{req.path}"
        }
        let page = @rabbita.new(component).render(url~, head~)
        res.send_html(@moonback.Html::raw(page))
      })
    } else {
      ctx.get("/", (_req, res) => serve_index_html(res, dist?, warren_client?))
    }
  }
}

///|
async fn serve_index_html(
  res : @moonback.Responder,
  dist? : String,
  warren_client? : String,
) -> Unit {
  fn escape_html_attribute(value : String) -> String {
    value
    .replace_all(old="&", new="&amp;")
    .replace_all(old="\"", new="&quot;")
    .replace_all(old="'", new="&#39;")
    .replace_all(old="<", new="&lt;")
    .replace_all(old=">", new="&gt;")
  }

  fn inject_warren_client(html : String) -> String {
    guard warren_client is Some(client) && client != "" else { html }
    let client = escape_html_attribute(client)
    let double_quoted_src = "src=\"\{client}\""
    let single_quoted_src = "src='\{client}'"
    guard !html.contains(double_quoted_src) && !html.contains(single_quoted_src) else {
      html
    }
    let patch = "    <script src=\"\{client}\" defer></script>\n"
    if html.rev_find("</head>") is Some(index) {
      "\{html[:index]}\{patch}\{html[index:]}"
    } else if html.rev_find("</body>") is Some(index) {
      "\{html[:index]}\{patch}\{html[index:]}"
    } else if html.rev_find("</html>") is Some(index) {
      "\{html[:index]}\{patch}\{html[index:]}"
    } else if html.has_suffix("\n") {
      "\{html}\{patch}"
    } else {
      "\{html}\n\{patch}"
    }
  }

  guard dist is Some(dir) else {
    res.send_text(
      "index.html not found: no dist directory is configured",
      status=404,
    )
    return
  }
  let index_path = @path.Path(dir).join("index.html")
  let index_path = "\{index_path}"
  guard @fs.exists(index_path) else {
    res.send_text("index.html not found: \{index_path}", status=404)
    return
  }
  let html = @fs.read_file(index_path).text()
  res.send_html(@moonback.Html::raw(inject_warren_client(html)))
}
