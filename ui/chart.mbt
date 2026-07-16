///|
pub(all) enum ChartIndicator {
  ChartDot
  ChartLine
  ChartDashed
} derive(Debug, Eq)

///|
const ChartContentsCarrierStyle : String = "display:contents"

///|
const ChartLegendContentStyle : String = "display:flex;flex-wrap:wrap;align-items:center;justify-content:center;gap:1rem"

///|
fn chart_indicator_value(indicator : ChartIndicator) -> String {
  match indicator {
    ChartDot => "dot"
    ChartLine => "line"
    ChartDashed => "dashed"
  }
}

///|
fn chart_indicator_style(indicator : ChartIndicator, color : String) -> String {
  match indicator {
    ChartDot =>
      "width:0.625rem;height:0.625rem;border-radius:2px;background:\{color}"
    ChartLine =>
      "width:0.25rem;align-self:stretch;border-radius:2px;background:\{color}"
    ChartDashed => "width:0;height:1rem;border-left:1.5px dashed \{color}"
  }
}

///|
/// Vega chart surface for an application-provided SVG, canvas, or chart engine.
pub fn[C : @html.IsChildren] chart_container(
  aria_label? : String,
  aspect? : String = "16 / 9",
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let chart_attrs = ui_attrs(attrs).data_set("slot", "chart")
  if aria_label is Some(label) {
    ignore(chart_attrs.role("img").aria_label(label))
  }
  @html.div(
    id?,
    class?,
    title?,
    attrs=chart_attrs,
    style=ui_styles(
      [
        UiBoxSizing,
        UiFontSans,
        "display:flex;width:100%;min-width:0;align-items:center;justify-content:center;color:var(--rui-muted-foreground,oklch(0.556 0 0));font-size:0.75rem;line-height:1rem;aspect-ratio:\{aspect}",
      ],
      style,
    ),
    children,
  )
}

///|
/// Carry chart-engine tooltip output without introducing a layout box.
///
/// Rabbita does not bundle a chart engine, so this is the native composition
/// adapter corresponding to shadcn's `ChartTooltip` export. The application
/// still owns pointer tracking and supplies the rendered tooltip content.
pub fn[C : @html.IsChildren] chart_tooltip(
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.span(
    id?,
    class?,
    title?,
    attrs=ui_attrs(attrs).data_set("slot", "chart-tooltip"),
    style=ui_styles([ChartContentsCarrierStyle], style),
    children,
  )
}

///|
/// Scope chart color variables to `children` with inline custom properties.
///
/// A variable named `revenue` becomes `--color-revenue`; names already
/// starting with `--` are kept verbatim. Unlike shadcn's Recharts helper this
/// never emits a `<style>` element, so it remains CSP-friendly and copyable.
pub fn[C : @html.IsChildren] chart_style(
  variables? : Array[(String, String)] = [],
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let carrier_attrs = ui_attrs(attrs).data_set("slot", "chart-style")
  for entry in variables {
    if entry.0 != "" {
      let property = if entry.0.has_prefix("--") {
        entry.0
      } else {
        "--color-\{entry.0}"
      }
      ignore(carrier_attrs.style(property, entry.1))
    }
  }
  @html.span(
    id?,
    class?,
    title?,
    attrs=carrier_attrs,
    style=ui_styles([ChartContentsCarrierStyle], style),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] chart_tooltip_content(
  active? : Bool = true,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.div(
    hidden=!active,
    id?,
    class?,
    title?,
    attrs=ui_attrs(attrs)
      .role("status")
      .aria_live("polite")
      .data_set("slot", "chart-tooltip-content")
      .data_set("state", if active { "open" } else { "closed" }),
    style=ui_styles(
      [
        "display:grid;min-width:8rem;align-items:start;gap:0.375rem;border:1px solid color-mix(in oklch,var(--rui-border,oklch(0.922 0 0)) 50%,transparent);border-radius:0.5rem;background:var(--rui-background,white);padding:0.375rem 0.625rem;color:var(--rui-foreground,oklch(0.145 0 0));font-size:0.75rem;line-height:1rem;box-shadow:0 8px 24px rgb(0 0 0 / 0.12)",
      ],
      style,
    ),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] chart_tooltip_label(
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.div(
    id?,
    class?,
    title?,
    attrs=ui_attrs(attrs).data_set("slot", "chart-tooltip-label"),
    style=ui_styles(["font-weight:500"], style),
    children,
  )
}

///|
pub fn chart_tooltip_item(
  label~ : String,
  value~ : String,
  color? : String = "currentColor",
  indicator? : ChartIndicator = ChartDot,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  @html.div(
    id?,
    class?,
    title?,
    attrs=ui_attrs(attrs)
      .data_set("slot", "chart-tooltip-item")
      .data_set("indicator", chart_indicator_value(indicator)),
    style=ui_styles(
      ["display:flex;width:100%;align-items:center;gap:0.5rem"],
      style,
    ),
    [
      @html.span(
        attrs=@html.Attrs::build().aria_hidden("true"),
        style=[chart_indicator_style(indicator, color)],
        "",
      ),
      @html.span(
        style=[
          "min-width:0;flex:1;color:var(--rui-muted-foreground,oklch(0.556 0 0))",
        ],
        label,
      ),
      @html.span(
        style=[
          "font-family:ui-monospace,SFMono-Regular,Menlo,monospace;font-weight:500;font-variant-numeric:tabular-nums;color:var(--rui-foreground,oklch(0.145 0 0))",
        ],
        value,
      ),
    ],
  )
}

///|
fn[C : @html.IsChildren] chart_legend_surface(
  slot : String,
  position? : String = "bottom",
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.div(
    id?,
    class?,
    title?,
    attrs=ui_attrs(attrs).data_set("slot", slot).data_set("position", position),
    style=ui_styles(
      [
        ChartLegendContentStyle,
        if position == "top" {
          "padding-bottom:0.75rem"
        } else {
          "padding-top:0.75rem"
        },
      ],
      style,
    ),
    children,
  )
}

///|
/// Carry an application chart engine's legend output.
///
/// This compatibility spelling predates the explicit shadcn content part;
/// prefer [`chart_legend_content`] for new compound composition.
pub fn[C : @html.IsChildren] chart_legend(
  position? : String = "bottom",
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  chart_legend_surface(
    "chart-legend",
    position~,
    id?,
    class?,
    title?,
    attrs?,
    style~,
    children,
  )
}

///|
/// Render the official shadcn chart legend content surface.
pub fn[C : @html.IsChildren] chart_legend_content(
  position? : String = "bottom",
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  chart_legend_surface(
    "chart-legend-content",
    position~,
    id?,
    class?,
    title?,
    attrs?,
    style~,
    children,
  )
}

///|
pub fn[C : @html.IsChildren] chart_legend_item(
  color? : String = "currentColor",
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.div(
    id?,
    class?,
    title?,
    attrs=ui_attrs(attrs).data_set("slot", "chart-legend-item"),
    style=ui_styles(["display:flex;align-items:center;gap:0.375rem"], style),
    [
      @html.span(
        attrs=@html.Attrs::build().aria_hidden("true"),
        style=[
          "width:0.5rem;height:0.5rem;flex-shrink:0;border-radius:2px;background:\{color}",
        ],
        "",
      ),
      @html.span(children),
    ],
  )
}
