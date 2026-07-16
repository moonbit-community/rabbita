///|
#cfg(target="js")
extern "js" fn ffi_install_delayed_mount_fixture(
  id : String,
  missing_reads : Int,
) -> Unit =
  #| (id, missingReads) => {
  #|   const own = key => Object.prototype.hasOwnProperty.call(globalThis, key)
  #|   const fixture = globalThis.__ruiDelayedMountFixture = {
  #|     document: globalThis.document,
  #|     hadDocument: own("document"),
  #|     requestAnimationFrame: globalThis.requestAnimationFrame,
  #|     hadRequestAnimationFrame: own("requestAnimationFrame"),
  #|     afterMount: globalThis.__ruiAfterMount,
  #|     hadAfterMount: own("__ruiAfterMount"),
  #|     reads: 0,
  #|     frames: 0,
  #|     mountedCalls: 0,
  #|   }
  #|   globalThis.__ruiAfterMount = new Map()
  #|   globalThis.document = {
  #|     getElementById(value) {
  #|       fixture.reads += 1
  #|       return value === id && fixture.reads > missingReads ? { id } : null
  #|     },
  #|   }
  #|   globalThis.requestAnimationFrame = callback => {
  #|     fixture.frames += 1
  #|     callback()
  #|     return fixture.frames
  #|   }
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_delayed_mount_mark_called() -> Unit =
  #| () => { globalThis.__ruiDelayedMountFixture.mountedCalls += 1 }

///|
#cfg(target="js")
extern "js" fn ffi_delayed_mount_calls() -> Int =
  #| () => globalThis.__ruiDelayedMountFixture.mountedCalls

///|
#cfg(target="js")
extern "js" fn ffi_delayed_mount_frames() -> Int =
  #| () => globalThis.__ruiDelayedMountFixture.frames

///|
#cfg(target="js")
extern "js" fn ffi_restore_delayed_mount_fixture() -> Unit =
  #| () => {
  #|   const fixture = globalThis.__ruiDelayedMountFixture
  #|   if (!fixture) return
  #|   if (fixture.hadDocument) globalThis.document = fixture.document
  #|   else delete globalThis.document
  #|   if (fixture.hadRequestAnimationFrame) {
  #|     globalThis.requestAnimationFrame = fixture.requestAnimationFrame
  #|   } else {
  #|     delete globalThis.requestAnimationFrame
  #|   }
  #|   if (fixture.hadAfterMount) {
  #|     globalThis.__ruiAfterMount = fixture.afterMount
  #|   } else {
  #|     delete globalThis.__ruiAfterMount
  #|   }
  #|   delete globalThis.__ruiDelayedMountFixture
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_install_queued_mount_fixture(id : String) -> Unit =
  #| id => {
  #|   const own = key => Object.prototype.hasOwnProperty.call(globalThis, key)
  #|   const fixture = globalThis.__ruiQueuedMountFixture = {
  #|     document: globalThis.document,
  #|     hadDocument: own("document"),
  #|     requestAnimationFrame: globalThis.requestAnimationFrame,
  #|     hadRequestAnimationFrame: own("requestAnimationFrame"),
  #|     afterMount: globalThis.__ruiAfterMount,
  #|     hadAfterMount: own("__ruiAfterMount"),
  #|     mounted: false,
  #|     frames: 0,
  #|     oldCalls: 0,
  #|     newCalls: 0,
  #|     queue: [],
  #|   }
  #|   globalThis.__ruiAfterMount = new Map()
  #|   globalThis.document = {
  #|     getElementById(value) {
  #|       return fixture.mounted && value === id ? { id } : null
  #|     },
  #|   }
  #|   globalThis.requestAnimationFrame = callback => {
  #|     fixture.frames += 1
  #|     fixture.queue.push(callback)
  #|     return fixture.frames
  #|   }
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_queued_mount_mark_mounted() -> Unit =
  #| () => { globalThis.__ruiQueuedMountFixture.mounted = true }

///|
#cfg(target="js")
extern "js" fn ffi_queued_mount_mark_old_called() -> Unit =
  #| () => { globalThis.__ruiQueuedMountFixture.oldCalls += 1 }

///|
#cfg(target="js")
extern "js" fn ffi_queued_mount_mark_new_called() -> Unit =
  #| () => { globalThis.__ruiQueuedMountFixture.newCalls += 1 }

///|
#cfg(target="js")
extern "js" fn ffi_queued_mount_flush() -> Unit =
  #| () => {
  #|   const queue = globalThis.__ruiQueuedMountFixture.queue
  #|   while (queue.length > 0) queue.shift()()
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_queued_mount_old_calls() -> Int =
  #| () => globalThis.__ruiQueuedMountFixture.oldCalls

///|
#cfg(target="js")
extern "js" fn ffi_queued_mount_new_calls() -> Int =
  #| () => globalThis.__ruiQueuedMountFixture.newCalls

///|
#cfg(target="js")
extern "js" fn ffi_restore_queued_mount_fixture() -> Unit =
  #| () => {
  #|   const fixture = globalThis.__ruiQueuedMountFixture
  #|   if (!fixture) return
  #|   if (fixture.hadDocument) globalThis.document = fixture.document
  #|   else delete globalThis.document
  #|   if (fixture.hadRequestAnimationFrame) {
  #|     globalThis.requestAnimationFrame = fixture.requestAnimationFrame
  #|   } else {
  #|     delete globalThis.requestAnimationFrame
  #|   }
  #|   if (fixture.hadAfterMount) {
  #|     globalThis.__ruiAfterMount = fixture.afterMount
  #|   } else {
  #|     delete globalThis.__ruiAfterMount
  #|   }
  #|   delete globalThis.__ruiQueuedMountFixture
  #| }

///|
#cfg(target="js")
test "after-mount operation survives a delayed incremental mount" {
  ffi_install_delayed_mount_fixture("late-root", 3)
  ui_after_mount("late-root", ffi_delayed_mount_mark_called)
  let calls = ffi_delayed_mount_calls()
  let frames = ffi_delayed_mount_frames()
  ffi_restore_delayed_mount_fixture()
  assert_eq(calls, 1)
  assert_eq(frames, 3)
}

///|
#cfg(target="js")
test "after-mount operation stops after its bounded retry window" {
  ffi_install_delayed_mount_fixture("never-root", 100)
  ui_after_mount("never-root", ffi_delayed_mount_mark_called)
  let calls = ffi_delayed_mount_calls()
  let frames = ffi_delayed_mount_frames()
  ffi_restore_delayed_mount_fixture()
  assert_eq(calls, 0)
  assert_eq(frames, 60)
}

///|
#cfg(target="js")
test "new same-purpose mount supersedes a queued callback for the same id" {
  ffi_install_queued_mount_fixture("reused-root")
  ui_after_mount("reused-root", ffi_queued_mount_mark_old_called)
  ui_after_mount("reused-root", ffi_queued_mount_mark_new_called)
  ffi_queued_mount_mark_mounted()
  ffi_queued_mount_flush()
  let old_calls = ffi_queued_mount_old_calls()
  let new_calls = ffi_queued_mount_new_calls()
  ffi_restore_queued_mount_fixture()
  assert_eq(old_calls, 0)
  assert_eq(new_calls, 1)
}

///|
#cfg(target="js")
test "different after-mount purposes may wait on the same id" {
  ffi_install_queued_mount_fixture("shared-root")
  ui_after_mount(
    "shared-root",
    ffi_queued_mount_mark_old_called,
    purpose="events",
  )
  ui_after_mount(
    "shared-root",
    ffi_queued_mount_mark_new_called,
    purpose="visibility",
  )
  ffi_queued_mount_mark_mounted()
  ffi_queued_mount_flush()
  let old_calls = ffi_queued_mount_old_calls()
  let new_calls = ffi_queued_mount_new_calls()
  ffi_restore_queued_mount_fixture()
  assert_eq(old_calls, 1)
  assert_eq(new_calls, 1)
}
