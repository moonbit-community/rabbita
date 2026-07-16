///|
/// Run a DOM operation once an incremental view has actually mounted its
/// element. `create_state_with_init` may enqueue an AfterRender command before
/// the owning `Val::view` has inserted that element into the document. A newer
/// request with the same element id and purpose supersedes an older pending
/// retry, while distinct purposes may wait on the same element independently.
#cfg(target="js")
extern "js" fn ui_after_mount(
  id : String,
  mounted : () -> Unit,
  purpose? : String = "default",
) -> Unit =
  #| (id, mounted, purpose) => {
  #|   const pending = globalThis.__ruiAfterMount ||= new Map()
  #|   const lanes = pending.get(id) || new Map()
  #|   pending.set(id, lanes)
  #|   const token = {}
  #|   lanes.set(purpose, token)
  #|   let attempt = 0
  #|   const isCurrent = () => pending.get(id)?.get(purpose) === token
  #|   const finish = () => {
  #|     if (!isCurrent()) return
  #|     lanes.delete(purpose)
  #|     if (lanes.size === 0 && pending.get(id) === lanes) pending.delete(id)
  #|   }
  #|   const tryMount = () => {
  #|     if (!isCurrent()) return
  #|     if (typeof document === "undefined") {
  #|       finish()
  #|       return
  #|     }
  #|     if (document.getElementById(id)) {
  #|       finish()
  #|       mounted()
  #|       return
  #|     }
  #|     if (attempt >= 60) {
  #|       finish()
  #|       return
  #|     }
  #|     attempt += 1
  #|     if (typeof requestAnimationFrame === "function") {
  #|       requestAnimationFrame(tryMount)
  #|     } else {
  #|       setTimeout(tryMount, 0)
  #|     }
  #|   }
  #|   tryMount()
  #| }

///|
/// Retry a live-DOM operation until all of its own prerequisites are ready.
/// The key makes a newer operation supersede an older pending retry for the
/// same component and purpose, which prevents stale incremental instances from
/// installing callbacks after a same-id remount.
#cfg(target="js")
extern "js" fn ui_after_ready(key : String, ready : () -> Bool) -> Unit =
  #| (key, ready) => {
  #|   if (typeof document === "undefined") return
  #|   const pending = globalThis.__ruiAfterReady ||= new Map()
  #|   const token = {}
  #|   pending.set(key, token)
  #|   let attempt = 0
  #|   const isCurrent = () => pending.get(key) === token
  #|   const finish = () => {
  #|     if (isCurrent()) pending.delete(key)
  #|   }
  #|   const tryReady = () => {
  #|     if (!isCurrent()) return
  #|     let complete = false
  #|     try { complete = Boolean(ready()) }
  #|     catch (_) { }
  #|     if (complete) {
  #|       finish()
  #|       return
  #|     }
  #|     if (attempt >= 60) {
  #|       finish()
  #|       return
  #|     }
  #|     attempt += 1
  #|     if (typeof requestAnimationFrame === "function") {
  #|       requestAnimationFrame(tryReady)
  #|     } else {
  #|       setTimeout(tryReady, 0)
  #|     }
  #|   }
  #|   tryReady()
  #| }
