///|
pub(all) enum BroadcastMsg {
  Building
  Reload
  BuildFailed(String)
} derive(Debug)

///|
pub extend BroadcastMsg with Debug::{to_repr}

///|
pub(all) enum ClientMsg {
  Text(String)
} derive(Debug)

///|
pub extend ClientMsg with Debug::{to_repr}

///|
pub struct Devhub {
  priv server : @http.Server
  priv vfs : @vfs.VirtualFileSystem
  priv html_fallback_path : String?
  priv client_msgs : @async.Queue[ClientMsg]
  priv mut next_id : Int
  priv subscribers : Map[Int, @async.Queue[BroadcastMsg]]
}

///|
#cfg(not(platform="windows"))
async fn check_port(port : UInt) -> Unit {
  let pids = try {
    let (_, output) = @process.collect_stdout("lsof", [
      "-tiTCP:\{port}",
      "-sTCP:LISTEN",
    ])
    output
    .text()
    .split("\n")
    .map(pid => pid.trim().to_owned())
    .filter(pid => pid != "")
    .collect()
  } catch {
    _ => []
  }

  let mut stopped = false
  for pid in pids {
    let command = try {
      let (code, output) = @process.collect_stdout("ps", [
        "-p", pid, "-o", "command=",
      ])
      if code == 0 {
        output.text().trim().to_owned()
      } else {
        ""
      }
    } catch {
      _ => ""
    }

    guard command.contains("warren") else {
      let detail = if command == "" { "" } else { ": \{command}" }
      @log.log(
        "error",
        "Port \{port} is already in use by process \{pid}\{detail}. Stop it manually, or run `warren dev --port <port>`.",
      )
      panic()
    }

    @log.log(
      "warn",
      "Port \{port} is occupied by previous warren process \{pid}. Killing it...",
    )
    guard @process.run("kill", [pid]) == 0 else {
      @log.log(
        "error",
        "Failed to kill previous warren process \{pid} on port \{port}. Stop it manually, or run `warren dev --port <port>`.",
      )
      panic()
    }
    stopped = true
  }

  if stopped {
    @async.sleep(100)
  }
}

///|
#cfg(platform="windows")
async fn check_port(port : UInt) -> Unit {
  let pids = try {
    let (_, output) = @process.collect_stdout("powershell.exe", [
      "-NoProfile",
      "-Command",
      "Get-NetTCPConnection -LocalPort \{port} -State Listen -ErrorAction SilentlyContinue | Select-Object -ExpandProperty OwningProcess",
    ])
    output
    .text()
    .split("\n")
    .map(pid => pid.trim().to_owned())
    .filter(pid => pid != "")
    .collect()
  } catch {
    _ => []
  }

  let mut stopped = false
  for pid in pids {
    let command = try {
      let (code, output) = @process.collect_stdout("powershell.exe", [
        "-NoProfile",
        "-Command",
        "$p = Get-CimInstance Win32_Process -Filter 'ProcessId=\{pid}' -ErrorAction SilentlyContinue; if ($p) { $p.CommandLine }",
      ])
      if code == 0 {
        output.text().trim().to_owned()
      } else {
        ""
      }
    } catch {
      _ => ""
    }

    guard command.contains("warren") else {
      let detail = if command == "" { "" } else { ": \{command}" }
      @log.log(
        "error",
        "Port \{port} is already in use by process \{pid}\{detail}. Stop it manually, or run `warren dev --port <port>`.",
      )
      panic()
    }

    @log.log(
      "warn",
      "Port \{port} is occupied by previous warren process \{pid}. Killing it...",
    )
    guard @process.run("taskkill", ["/PID", pid, "/F"]) == 0 else {
      @log.log(
        "error",
        "Failed to kill previous warren process \{pid} on port \{port}. Stop it manually, or run `warren dev --port <port>`.",
      )
      panic()
    }
    stopped = true
  }

  if stopped {
    @async.sleep(100)
  }
}

///|
pub async fn Devhub::Devhub(
  port : UInt,
  vfs : @vfs.VirtualFileSystem,
  html_fallback_path? : String,
) -> Self {
  check_port(port)

  {
    server: Server(@socket.Addr::parse("127.0.0.1:\{port}"), reuse_addr=true),
    vfs,
    html_fallback_path,
    client_msgs: Queue(kind=Unbounded),
    next_id: 0,
    subscribers: Map([]),
  }
}

///|
fn request_accepts_html(request : @http.Request) -> Bool {
  match request.headers.get("accept") {
    Some(accept) => accept.to_lower().contains("text/html")
    None => false
  }
}

///|
pub fn Devhub::port(self : Self) -> Int {
  self.server.addr.port()
}

///|
pub fn Devhub::broadcast(self : Self, msg : BroadcastMsg) -> Unit {
  for entry in self.subscribers.iter() {
    let (_, queue) = entry
    ignore(queue.try_put(msg)) catch {
      _ => ()
    }
  }
}

///|
pub async fn Devhub::run_forever(self : Self) -> Unit {
  self.server.run_forever(
    (request, _, conn) => self.handle_request(request, conn),
    allow_failure=true,
    max_connections=64,
  )
}

///|
pub async fn Devhub::wait_client(self : Self) -> ClientMsg {
  self.client_msgs.get()
}

///|
async fn Devhub::handle_request(
  self : Self,
  request : @http.Request,
  conn : @http.ServerConnection,
) -> Unit {
  guard request.meth is Get else {
    conn
    ..send_response(405, "Method Not Allowed", extra_headers={
      "Content-Type": "text/plain",
    })
    ..write("Method Not Allowed")
    .end_response()
    return
  }
  let path = if request.path == "/" { "/index.html" } else { request.path }
  let path = match path.split("?").collect() {
    [path, ..] => path.to_owned()
    [] => path
  }
  match path {
    "/__warren/events" => self.handle_ws(request, conn)
    path => {
      let resource = if self.vfs.read(path) is Some(content) {
        Some((path, content))
      } else if request_accepts_html(request) &&
        self.html_fallback_path is Some(fallback) {
        self.vfs.read(fallback).map(content => (fallback, content))
      } else {
        None
      }
      match resource {
        Some((resource_path, content)) => {
          let content_type = match @path.Path::extname(resource_path) {
            ".png" => "image/png"
            ".jpg" | ".jpeg" => "image/jpeg"
            ".html" => "text/html"
            ".css" => "text/css"
            ".js" => "text/javascript"
            ".mp4" => "video/mp4"
            ".mpv" => "video/mpv"
            ".mpeg" => "video/mpeg"
            ".mkv" => "video/x-matroska"
            _ => "application/octet-stream"
          }
          conn
          ..send_response(200, "OK", extra_headers={
            "Content-Type": content_type,
            "Cache-Control": "no-store",
          })
          ..write(content)
          .end_response()
        }
        None =>
          conn
          ..send_response(404, "Not Found", extra_headers={
            "Content-Type": "text/plain",
            "Cache-Control": "no-store",
          })
          ..write("\{path} Not Found")
          .end_response()
      }
    }
  }
}

///|
async fn Devhub::handle_ws(
  self : Self,
  request : @http.Request,
  conn : @http.ServerConnection,
) -> Unit {
  let ws = @websocket.from_http_server(request, conn)
  defer ws.close()
  let id = self.next_id
  self.next_id += 1
  let queue = @async.Queue(kind=DiscardOldest(32))
  self.subscribers[id] = queue
  defer self.subscribers.remove(id)
  @async.with_task_group(group => {
    group.spawn_bg(allow_failure=true, () => {
      while queue.get() is msg {
        match msg {
          Building => ws.send_text("building")
          Reload => ws.send_text("reload")
          BuildFailed(diagnostics) =>
            ws.send_text("build_failed\n\{diagnostics}")
        }
      }
    })
    try {
      for ;; {
        let msg = ws.recv()
        match msg.kind {
          Text => self.client_msgs.put(Text(msg.read_all().text()))
          Binary => ignore(msg.read_all())
        }
      }
    } catch {
      _ => ()
    }
    group.return_immediately(()) catch {
      _ => ()
    }
  })
}
