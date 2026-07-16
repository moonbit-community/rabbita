///|
const SpinnerStyle : String = "display:inline-flex;width:1rem;height:1rem;align-items:center;justify-content:center;color:currentColor;vertical-align:-0.125em"

///|
/// Render a self-contained SVG spinner. `theme` supplies the CSS keyframes and
/// reduced-motion override so motion is not tracked by runtime script.
pub fn spinner(
  label? : String = "Loading",
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  @html.span(
    id?,
    class?,
    title?,
    attrs=ui_attrs(attrs)
      .role("status")
      .aria_label(label)
      .data_set("slot", "spinner"),
    style=ui_styles([UiBoxSizing, SpinnerStyle], style),
    @svg.svg(
      width=16,
      height=16,
      view_box="0 0 24 24",
      style=[
        "display:block;width:100%;height:100%;transform-origin:center;animation:rui-spin 0.8s linear infinite",
      ],
      [
        @svg.g(fill="none", stroke="currentColor", [
          @svg.circle(
            cx=12,
            cy=12,
            r=9,
            stroke="currentColor",
            stroke_width=2,
            opacity="0.22",
          ),
          @svg.path(
            d="M12 3a9 9 0 0 1 9 9",
            fill="none",
            stroke="currentColor",
            stroke_width=2,
            attrs=@svg.Attrs::build().stroke_linecap("round"),
          ),
        ]),
      ],
    ),
  )
}
