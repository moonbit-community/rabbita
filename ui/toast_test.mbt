///|
test "toast exposes motion states and SVG close control" {
  let open = render(@rabbita-ui.toast(@rabbita-ui.toast_title("Saved")))
  assert_contains(open, "data-slot=\"toast\"")
  assert_contains(open, "data-state=\"open\"")
  assert_contains(open, "transition:opacity 150ms ease,transform 150ms ease")
  assert_contains(open, "--rui-toast-base-shadow:0 4px 12px rgb(0 0 0 / 0.1)")
  assert_contains(
    open, "box-shadow:var(--rui-toast-shadow,var(--rui-toast-base-shadow,0 4px 12px rgb(0 0 0 / 0.1)))",
  )
  assert_contains(
    open, "border-radius:var(--rui-toast-radius,var(--rui-toast-base-radius,1rem))",
  )
  assert_not_contains(open, "0 10px 30px rgb(0 0 0 / 0.14)")
  assert_contains(open, "opacity:1;transform:translateY(0) scale(1)")
  let closed = render(@rabbita-ui.toast(open=false, "Hidden"))
  assert_contains(closed, "data-state=\"closed\"")
  assert_contains(closed, "hidden")
  assert_contains(closed, "opacity:0")
  let toaster = render_incremental(() => {
    @rabbita-ui.toaster(scope => @rabbita-ui.toast_close(scope~, toast_id=7))
  })
  assert_contains(toaster, "data-slot=\"toast-close\"")
  assert_contains(toaster, "aria-label=\"Close notification\"")
  assert_contains(
    toaster, "width:min(26rem,calc(100vw - 2rem));max-height:calc(100dvh - 2rem)",
  )
  assert_contains(toaster, "overflow:visible")
  assert_contains(
    toaster, "border:0;background:transparent;box-shadow:none;pointer-events:none",
  )
  assert_not_contains(toaster, "overflow-y:auto")
  assert_contains(toaster, "<svg")
  assert_not_contains(toaster, ">×<")
}

///|
test "sonner rich colors remain readable in light and dark schemes" {
  let html = render_incremental(() => @rabbita-ui.sonner(_ => @html.nothing))
  assert_contains(html, "data-slot=\"sonner\"")
  assert_contains(html, "data-rui-style=\"sonner-rich-colors\"")
  assert_contains(html, "--rui-sonner-success-background")
  assert_contains(html, "light-dark(")
  assert_contains(html, "--rui-sonner-error-background")
  assert_contains(html, "var(--rui-background")
  assert_contains(
    html, "width:min(22.25rem,calc(100vw - 3rem));max-height:calc(100dvh - 3rem);gap:0.875rem",
  )
  assert_contains(html, "--rui-toast-base-offset:1.5rem")
  assert_contains(html, "overflow:visible")
  assert_not_contains(html, "overflow-y:auto")
}

///|
test "toast hosts preserve a shadow-safe offset in every position" {
  let cases : Array[(String, String)] = [
    (
      "top-left", "top:var(--rui-toast-offset,var(--rui-toast-base-offset,1rem));left:var(--rui-toast-offset,var(--rui-toast-base-offset,1rem))",
    ),
    (
      "top-center", "top:var(--rui-toast-offset,var(--rui-toast-base-offset,1rem));left:50%;transform:translateX(-50%)",
    ),
    (
      "top-right", "top:var(--rui-toast-offset,var(--rui-toast-base-offset,1rem));right:var(--rui-toast-offset,var(--rui-toast-base-offset,1rem))",
    ),
    (
      "bottom-left", "bottom:var(--rui-toast-offset,var(--rui-toast-base-offset,1rem));left:var(--rui-toast-offset,var(--rui-toast-base-offset,1rem))",
    ),
    (
      "bottom-center", "bottom:var(--rui-toast-offset,var(--rui-toast-base-offset,1rem));left:50%;transform:translateX(-50%)",
    ),
    (
      "bottom-right", "right:var(--rui-toast-offset,var(--rui-toast-base-offset,1rem));bottom:var(--rui-toast-offset,var(--rui-toast-base-offset,1rem))",
    ),
  ]
  for item in cases {
    let position = item.0
    let expected_style = item.1
    let html = render_incremental(() => {
      @rabbita-ui.sonner(position~, _ => @html.nothing)
    })
    assert_contains(html, "data-position=\"\{position}\"")
    assert_contains(html, expected_style)
    assert_contains(html, "box-shadow:none")
    assert_contains(html, "overflow:visible")
  }
}
