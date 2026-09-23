///|
let bundle_server_source =
  #|///|
  #|import {
  #|  "moonbitlang/async@0.21.0",
  #|  "moonbitlang/moonback@0.8.3",
  #|  "moonbitlang/moonback@0.8.3/middlewares/unstable_static" @static,
  #|  "moonbitlang/core/env",
  #|  "moonbitlang/core/string",
  #|}
  #|
  #|///|
  #|async fn main {
  #|  let host = @env.get_env_var("WARREN_HOST").unwrap_or("127.0.0.1")
  #|  let port = @string.parse_uint(@env.get_env_var("WARREN_PORT").unwrap_or("4300"))
  #|  guard port > 0 && port <= 65535 else { fail("Invalid WARREN_PORT") }
  #|  let files = warren_assets()
  #|  let app = @moonback.App(ctx => {
  #|    ctx.add_middleware(@static.from_assets(files, rewrite_trailing_slash_index=true))
  #|  })
  #|  defer app.close()
  #|  let listener = @moonback.listen(host~, port=port.to_uint16(), reuse_addr=true)
  #|  println("Server is running on http://\{host}:\{port}")
  #|  app.serve(listener)
  #|}
