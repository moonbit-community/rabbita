///|
#cfg(target="js")
extern "js" fn with_missing_mount_target(run : () -> Unit) -> Bool =
  #| (run) => {
  #|   const hadWindow = Object.prototype.hasOwnProperty.call(globalThis, "window")
  #|   const hadDocument = Object.prototype.hasOwnProperty.call(globalThis, "document")
  #|   const previousWindow = globalThis.window
  #|   const previousDocument = globalThis.document
  #|   globalThis.window = { location: { href: "http://localhost/" } }
  #|   globalThis.document = { getElementById: () => null }
  #|   try {
  #|     run()
  #|     return false
  #|   } catch (_) {
  #|     return true
  #|   } finally {
  #|     if (hadWindow) globalThis.window = previousWindow
  #|     else delete globalThis.window
  #|     if (hadDocument) globalThis.document = previousDocument
  #|     else delete globalThis.document
  #|   }
  #| }

///|
#cfg(target="js")
test "missing mount target is rejected before the builder runs" {
  let mut builder_ran = false
  let rejected = with_missing_mount_target(() => {
    ignore(
      BrowserHost(element_id="missing", () => {
        builder_ran = true
        @duplix.constant(@vdom.VNode::text("unreachable"))
      }),
    )
  })

  inspect(rejected, content="true")
  inspect(builder_ran, content="false")
}
