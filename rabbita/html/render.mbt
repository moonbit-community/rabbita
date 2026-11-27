///|
/// Serializes an HTML value synchronously, without a document type declaration
/// or hydration transcript. Available on JavaScript, native, and Wasm targets.
///
/// This renders an already-built value, including memoized children, without
/// mounting an application or running application commands and subscriptions.
/// Use `App::render` for application-level asynchronous SSR and hydration.
///
/// Ordinary text and attribute values use the same escaping as application SSR.
/// Explicit raw HTML and script/style contents retain their raw-text semantics;
/// this method does not sanitize them.
pub fn Html::render_to_string(self : Html) -> String {
  @vdom.server_side_render(() => self.0, include_doctype=false)
}
