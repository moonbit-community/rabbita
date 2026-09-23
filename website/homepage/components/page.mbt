///|
const PageStyle : String = "flex:1;min-height:calc(100vh - var(--nav-h,60px));padding:2rem 0 4rem;background:var(--rui-background);color:var(--rui-foreground)"

///|
const ShellStyle : String = "box-sizing:border-box;width:100%;max-width:1232px;margin-inline:auto;padding-inline:1.25rem"

///|
const StackStyle : String = "display:flex;flex-direction:column;gap:1rem"

///|
const RowStyle : String = "display:flex;flex-wrap:wrap;align-items:center;gap:0.75rem"

///|
const ControlRowStyle : String = "display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:1rem"

///|
const MutedStyle : String = "color:var(--rui-muted-foreground);font-size:0.8125rem;line-height:1.35"

///|
const CatalogLayoutStyle : String = "display:grid;grid-template-columns:var(--rui-showcase-catalog-columns,13rem minmax(0,1fr));align-items:start;gap:clamp(1.5rem,3vw,2.5rem)"

///|
const CatalogRailStyle : String = "box-sizing:border-box;position:var(--rui-showcase-rail-position,sticky);top:calc(var(--nav-h,60px) + 1rem);width:100%;max-width:var(--rui-showcase-rail-max-width,13rem);max-height:var(--rui-showcase-rail-max-height,calc(100vh - var(--nav-h,60px) - 2rem));min-width:0;overflow:auto;padding-block:0.25rem;padding-inline:0.25rem 1rem;scrollbar-width:thin"

///|
const CatalogRailNavStyle : String = "display:flex;min-width:0;flex-direction:var(--rui-showcase-rail-direction,column);gap:0.125rem"

///|
const CatalogMainStyle : String = "min-width:0"

///|
const RailLinkStyle : String = "display:block;padding:0.325rem 0;color:var(--rui-muted-foreground);font-size:0.8125rem;line-height:1.2rem;text-decoration:none"

///|
const CatalogRailLinkStyle : String = "box-sizing:border-box;display:flex;width:fit-content;max-width:100%;min-height:2rem;align-items:center;padding:0.375rem 0.625rem;border-radius:0.5rem;white-space:nowrap"

///|
const ActiveRailLinkStyle : String = "color:var(--rui-foreground);font-weight:500"

///|
const MobileCatalogStyle : String = "display:none;min-width:0"

///|
const MobileCatalogDetailsStyle : String = "box-sizing:border-box;width:100%;border:1px solid var(--rui-border);border-radius:calc(var(--rui-radius) - 0.125rem);background:var(--rui-background);overflow:hidden"

///|
const MobileCatalogSummaryStyle : String = "box-sizing:border-box;display:flex;min-height:2.75rem;align-items:center;justify-content:space-between;gap:0.75rem;padding:0.625rem 0.75rem;color:var(--rui-foreground);font-size:0.875rem;font-weight:600;line-height:1.25rem;cursor:pointer;list-style:none"

///|
const MobileCatalogNavStyle : String = "box-sizing:border-box;display:grid;max-height:min(22rem,60vh);grid-template-columns:repeat(auto-fit,minmax(9rem,1fr));gap:0.125rem;overflow:auto;border-top:1px solid var(--rui-border);padding:0.5rem"

///|
const MissingPageStyle : String = "box-sizing:border-box;display:flex;min-height:24rem;flex-direction:column;align-items:flex-start;justify-content:center;gap:0.75rem"

///|
#cfg(target="js")
extern "js" fn showcase_local_href(hash : String) -> String =
  #| hash => `${globalThis.location?.pathname || "/"}${globalThis.location?.search || ""}${hash}`

///|
#cfg(not(target="js"))
fn showcase_local_href(hash : String) -> String {
  hash
}

///|
fn rail_link(
  href : String,
  label : String,
  style? : String = RailLinkStyle,
) -> @html.Html {
  @html.a(
    href=showcase_local_href(href),
    class="rui-showcase-rail-link",
    style=[style],
    label,
  )
}

///|
fn showcase_catalog_link(
  entry : ShowcasePageEntry,
  current_slug : String,
) -> @html.Html {
  let active = entry.slug == current_slug
  let attrs = @html.Attrs::build()
  if active {
    ignore(attrs.aria_current("page"))
  }
  @html.a(
    href=showcase_page_href(entry.slug),
    class=if active {
      "rui-showcase-rail-link rui-showcase-rail-link--active"
    } else {
      "rui-showcase-rail-link"
    },
    attrs~,
    style=[
      RailLinkStyle,
      CatalogRailLinkStyle,
      if active {
        ActiveRailLinkStyle
      } else {
        ""
      },
    ],
    entry.title,
  )
}

///|
fn showcase_mobile_catalog(current_slug : String) -> @html.Html {
  @html.aside(
    class="rui-showcase-mobile-catalog",
    style=[MobileCatalogStyle],
    @html.details(style=[MobileCatalogDetailsStyle], [
      @html.summary(
        class="rui-showcase-mobile-catalog-summary",
        style=[MobileCatalogSummaryStyle],
        [
          @html.span(showcase_page_title(current_slug)),
          showcase_chevron_right_icon(),
        ],
      ),
      @html.nav(
        attrs=@html.Attrs::build().aria_label("Component catalogue"),
        style=[MobileCatalogNavStyle],
        [
          for entry in showcase_page_entries => {
            showcase_catalog_link(entry, current_slug)
          }
        ],
      ),
    ]),
  )
}

///|
fn showcase_missing_page(slug : String) -> @html.Html {
  @html.section(style=[MissingPageStyle], [
    @html.h1(
      style=["margin:0;font-size:1.75rem;line-height:1.2"],
      "Component not found",
    ),
    @html.p(
      style=["margin:0;color:var(--rui-muted-foreground)"],
      "There is no component page for “\{slug}”.",
    ),
    @html.a(
      href=showcase_page_href(showcase_default_page_slug()),
      class="rui-showcase-page-navigation-link",
      style=[ShowcasePageNavigationLinkStyle, "min-height:2.25rem;width:auto"],
      "Open Accordion",
    ),
  ])
}

///|
fn showcase_component_page(slug : String) -> @rabbita.Val[@html.Html] {
  match slug {
    "alert"
    | "aspect-ratio"
    | "attachment"
    | "avatar"
    | "badge"
    | "bubble"
    | "button"
    | "button-group"
    | "card"
    | "chart"
    | "data-table"
    | "direction"
    | "empty"
    | "item"
    | "kbd"
    | "label"
    | "markdown"
    | "marker"
    | "message"
    | "progress"
    | "separator"
    | "skeleton"
    | "spinner"
    | "table"
    | "toggle"
    | "toggle-group"
    | "typography" => showcase_foundations_page(slug)
    "calendar"
    | "checkbox"
    | "combobox"
    | "date-picker"
    | "field"
    | "input"
    | "input-group"
    | "input-otp"
    | "native-select"
    | "radio-group"
    | "select"
    | "slider"
    | "switch"
    | "textarea" => showcase_forms_page(slug)
    "accordion"
    | "breadcrumb"
    | "carousel"
    | "collapsible"
    | "navigation-menu"
    | "pagination"
    | "sidebar"
    | "tabs" => ig_navigation_page(slug)
    "alert-dialog"
    | "command"
    | "context-menu"
    | "dialog"
    | "drawer"
    | "dropdown-menu"
    | "hover-card"
    | "menubar"
    | "popover"
    | "sheet"
    | "tooltip" => ig_overlay_page(slug)
    "message-scroller" | "resizable" | "scroll-area" | "sonner" | "toast" =>
      ig_feedback_page(slug)
    _ => showcase_static_page(showcase_missing_page(slug))
  }
}

///|
fn showcase_view(
  dark : Bool,
  current_slug : String,
  component : @html.Html,
) -> @html.Html {
  let mode = if dark { @rui.Dark } else { Light }
  @rui.theme(
    mode~,
    id="rui-showcase",
    style=[PageStyle],
    @html.main_(style=[ShellStyle], [
      @html.div(style=[CatalogLayoutStyle], [
        @html.aside(class="rui-showcase-catalog", style=[CatalogRailStyle], [
          @html.nav(
            class="rui-showcase-catalog-nav",
            attrs=@html.Attrs::build().aria_label("Component catalogue"),
            style=[CatalogRailNavStyle],
            [
              for entry in showcase_page_entries => {
                showcase_catalog_link(entry, current_slug)
              }
            ],
          ),
        ]),
        showcase_mobile_catalog(current_slug),
        @html.div(
          class="rui-showcase-current-page",
          style=[CatalogMainStyle],
          component,
        ),
      ]),
    ]),
  )
}

///|
pub fn components_page(
  dark : @rabbita.Val[Bool],
  slug : String,
) -> @rabbita.Val[@html.Html] {
  let component = showcase_component_page(slug)
  dark.view2(component, (dark, component) => {
    showcase_view(dark, slug, component)
  })
}
