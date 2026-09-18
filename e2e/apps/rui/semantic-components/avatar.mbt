///|
fn semantic_avatar_fixture() -> Val[Html] {
  let loaded = @rui.avatar_with_fallback(
    id="fixture-avatar-loaded",
    src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///ywAAAAAAQABAAACAUwAOw==",
    alt="Loaded fixture avatar",
    "LA",
  )
  let failed = @rui.avatar_with_fallback(
    id="fixture-avatar-failed",
    src="data:image/png;base64,not-a-real-image",
    alt="Failed fixture avatar",
    "FA",
  )
  loaded.map2(failed, fn(loaded, failed) {
    @fixture.section("fixture-section-semantic-media", "Media and Direction", [
      loaded,
      failed,
      @rui.aspect_ratio(
        ratio=2.0,
        id="fixture-aspect-ratio",
        style=["width:16rem;background:var(--rui-muted,oklch(0.97 0 0))"],
        span("2:1 fixture surface"),
      ),
      @rui.direction(
        direction=Rtl,
        id="fixture-direction-rtl",
        "واجهة الاختبار",
      ),
    ])
  })
}
