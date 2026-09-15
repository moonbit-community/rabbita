///|
test "bundle paths normalize separators and reject invalid paths" {
  @test.assert_eq(asset_request_path("/a//./b"), Some("/a/b"))
  @test.assert_eq(
    asset_request_path("/图/%e5%AD%97%20%2B%25.txt"),
    Some("/图/字 +%.txt"),
  )
  for
    path in [
      "/../a", "/%2e%2e/a", "/a/%2E%2E/b", "/a%5Cb", "/%00", "/%ff", "/%", "/%0",
      "/%gg", "a",
    ] {
    @test.assert_eq(asset_request_path(path), None)
  }
}

///|
async test "bundled middleware preserves the SSR root and explicit index resource" {
  let files : Map[String, Bytes] = { "/index.html": b"<h1>bundle</h1>" }
  let app = @moonback.App(ctx => {
    ctx.add_middleware(bundled_assets(files, serve_root=false))
    ctx.get("/", (_req, res) => res.send_text("SSR"))
  })
  defer app.close()
  @async.with_task_group(group => {
    let listener = @moonback.listen(port=0)
    let task = group.spawn(() => app.serve(listener))
    defer task.cancel()
    let base = "http://127.0.0.1:\{listener.addr.port()}"
    for
      (path, expected) in [("/", b"SSR"), ("/index.html", files["/index.html"])] {
      let (response, body) = @http.get(base + path)
      @test.assert_eq(response.code, 200)
      @test.assert_eq(body.binary(), expected)
    }
  })
}
