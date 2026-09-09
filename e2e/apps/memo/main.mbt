///|
fn main {
  let url = @dom.window().current_url()
  if url.contains("physical-document") {
    @rabbita.new(physical_document_app).hydrate()
  } else if url.contains("physical-root") {
    @rabbita.new(physical_root_app).mount("app")
  } else if url.contains("physical-nodes") {
    @rabbita.new(physical_nodes_app).mount("app")
  } else if url.contains("physical-keyed") {
    @rabbita.new(physical_keyed_app).mount("app")
  } else {
    @rabbita.new(app).mount("app")
  }
}
