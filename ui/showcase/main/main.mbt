///|
const PageStyle : String = "min-height:100vh;padding:2rem 1.25rem 4rem;background:var(--rui-background);color:var(--rui-foreground)"

///|
const ShellStyle : String = "width:100%;max-width:96rem;margin-inline:auto"

///|
const HeaderStyle : String = "display:flex;align-items:flex-start;justify-content:space-between;flex-wrap:wrap;gap:1.5rem;padding:1.25rem 0 2rem;border-bottom:1px solid var(--rui-border);margin-bottom:1.5rem"

///|
const HeadingStyle : String = "max-width:48rem;margin:0;font-size:clamp(2rem,5vw,4.25rem);line-height:0.98;font-weight:680;letter-spacing:-0.055em"

///|
const LeadStyle : String = "max-width:44rem;margin:1rem 0 0;color:var(--rui-muted-foreground);font-size:0.9375rem;line-height:1.6"

///|
const GridStyle : String = "display:grid;grid-template-columns:repeat(auto-fit,minmax(min(100%,22rem),1fr));gap:1rem;align-items:start"

///|
const StackStyle : String = "display:flex;flex-direction:column;gap:1rem"

///|
const RowStyle : String = "display:flex;flex-wrap:wrap;align-items:center;gap:0.75rem"

///|
const ControlRowStyle : String = "display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:1rem"

///|
const MutedStyle : String = "color:var(--rui-muted-foreground);font-size:0.8125rem;line-height:1.35"

///|
const CatalogLayoutStyle : String = "display:grid;grid-template-columns:var(--rui-showcase-catalog-columns,14rem minmax(0,1fr));align-items:start;gap:clamp(1.5rem,3vw,3rem)"

///|
const CatalogRailStyle : String = "box-sizing:border-box;position:var(--rui-showcase-rail-position,sticky);top:1rem;width:100%;max-width:var(--rui-showcase-rail-max-width,14rem);max-height:var(--rui-showcase-rail-max-height,calc(100vh - 2rem));min-width:0;overflow:auto;padding-right:1rem;scrollbar-width:thin"

///|
const CatalogRailNavStyle : String = "display:flex;min-width:0;flex-direction:var(--rui-showcase-rail-direction,column);gap:0.125rem"

///|
const CatalogMainStyle : String = "min-width:0;display:flex;flex-direction:column;gap:4rem"

///|
const RailLinkStyle : String = "display:block;padding:0.325rem 0;color:var(--rui-muted-foreground);font-size:0.8125rem;line-height:1.2rem;text-decoration:none"

///|
const GallerySectionStyle : String = "display:flex;min-width:0;flex-direction:column;gap:4rem;scroll-margin-top:1rem"

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
fn showcase_view(
  dark : Bool,
  set_dark : @rabbita.Emit[(Bool) -> Bool],
  foundations : @html.Html,
  forms : @html.Html,
  interactions : @html.Html,
) -> @html.Html {
  let mode = if dark { @ui.Dark } else { @ui.Light }
  @ui.theme(
    mode~,
    id="rui-showcase",
    style=[PageStyle],
    @html.main_(style=[ShellStyle], [
      @html.header(style=[HeaderStyle], [
        @html.div([
          @html.h1(style=[HeadingStyle], "Vega components, running natively."),
          @html.p(
            style=[LeadStyle],
            "A live catalogue of the shadcn/ui Vega surface. Every component exposes its visual variants, sizes, and key compositions through the public Rabbita API.",
          ),
        ]),
        @ui.button(
          variant=@ui.Outline,
          size=@ui.Sm,
          on_click=set_dark(value => !value),
          if dark {
            "Use light theme"
          } else {
            "Use dark theme"
          },
        ),
      ]),
      @html.div(style=[CatalogLayoutStyle], [
        @html.aside(class="rui-showcase-catalog", style=[CatalogRailStyle], [
          @html.nav(
            class="rui-showcase-catalog-nav",
            attrs=@html.Attrs::build().aria_label("Component catalogue"),
            style=[CatalogRailNavStyle],
            [
              for
                component in [
                  "Accordion", "Alert", "Alert Dialog", "Aspect Ratio", "Attachment",
                  "Avatar", "Badge", "Breadcrumb", "Bubble", "Button", "Button Group",
                  "Calendar", "Card", "Carousel", "Chart", "Checkbox", "Collapsible",
                  "Combobox", "Command", "Context Menu", "Data Table", "Date Picker",
                  "Dialog", "Direction", "Drawer", "Dropdown Menu", "Empty", "Field",
                  "Hover Card", "Input", "Input Group", "Input OTP", "Item", "Kbd",
                  "Label", "Marker", "Menubar", "Message", "Message Scroller", "Native Select",
                  "Navigation Menu", "Pagination", "Popover", "Progress", "Radio Group",
                  "Resizable", "Scroll Area", "Select", "Separator", "Sheet", "Sidebar",
                  "Skeleton", "Slider", "Sonner", "Spinner", "Switch", "Table", "Tabs",
                  "Textarea", "Toast", "Toggle", "Toggle Group", "Tooltip", "Typography",
                ] => {
                rail_link("#\{showcase_component_anchor(component)}", component)
              }
            ],
          ),
        ]),
        @html.div(style=[CatalogMainStyle], [
          @html.section(
            id="foundations",
            style=[GallerySectionStyle],
            foundations,
          ),
          @html.section(id="forms", style=[GallerySectionStyle], forms),
          @html.section(
            id="interactions",
            style=[GallerySectionStyle],
            interactions,
          ),
        ]),
      ]),
    ]),
  )
}

///|
async fn main {
  @shiki.initialize_static(langs=["moonbit"], themes=[
    "github-light", "github-dark-default",
  ]) catch {
    error => println("showcase syntax highlighting unavailable: \{error}")
  }
  fn app() -> @rabbita.Val[@html.Html] {
    let (dark, set_dark) = @rabbita.create_variable(false)
    let foundations = foundations_gallery()
    let forms_base = forms_gallery()
    let forms_variants = forms_variants_gallery()
    let forms = forms_base.view2(forms_variants, (base, variants) => {
      @html.fragment([base, variants])
    })
    let interactions = interactions_gallery()
    dark.view4(foundations, forms, interactions, (
      dark,
      foundations,
      forms,
      interactions,
    ) => showcase_view(dark, set_dark, foundations, forms, interactions))
  }
  @rabbita.new(app).mount("app")
}
