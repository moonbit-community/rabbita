///|
/// The demo data behind `GET /issues`; a real app would reach for a database
/// here.
let issues : Array[@app.Issue] = [
  { content: "issue 1", status: "done" },
  { content: "issue 2", status: "pending" },
  { content: "issue 3", status: "pending" },
]

///|
/// Routes specific to this app. The server-rendered document and the assets
/// built by `warren` are served by `@rabbita_server.Server` itself.
let api : @moonback.Module = ctx => {
  ctx.get("/issues", (_req, res) => res.send_json(@json.to_json(issues)))
}

///|
async fn main {
  let server = @rabbita_server.Server(
    api~,
    port=3002,
    dist=@path.Path("./dist"),
    component=@app.view,
  )
  defer server.close()
  server.run_forever()
}
