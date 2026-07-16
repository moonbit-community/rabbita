///|
const ShowcaseComponentShellStyle : String = "box-sizing:border-box;display:grid;width:100%;min-width:0;grid-template-columns:var(--rui-showcase-component-columns,minmax(0,46rem) 11rem);justify-content:center;align-items:start;column-gap:clamp(2rem,3vw,3rem);grid-column:1 / -1;scroll-margin-top:1rem"

///|
const ShowcaseComponentMainStyle : String = "box-sizing:border-box;display:flex;width:100%;min-width:0;flex-direction:column;gap:1rem"

///|
const ShowcaseComponentHeaderStyle : String = "box-sizing:border-box;display:flex;width:100%;min-width:0;flex-direction:column;align-items:flex-start;gap:0.375rem;margin:0;text-align:start"

///|
const ShowcaseComponentTitleStyle : String = "margin:0;font-size:clamp(1.375rem,2vw,1.75rem);line-height:1.2;font-weight:650;letter-spacing:-0.035em"

///|
const ShowcaseComponentDescriptionStyle : String = "max-width:42rem;margin:0;color:var(--rui-muted-foreground);font-size:0.9375rem;line-height:1.55"

///|
const ShowcaseComponentTocStyle : String = "position:sticky;top:1rem;min-width:0;padding-left:1rem;border-left:1px solid var(--rui-border)"

///|
const ShowcaseComponentTocLinkStyle : String = "display:block;padding:0.35rem 0;color:var(--rui-muted-foreground);font-size:0.75rem;line-height:1.2rem;text-decoration:none"

///|
priv enum ShowcaseStageVariant {
  ShowcaseStagePlain
  ShowcaseStageSurface
}

///|
priv enum ShowcasePreparedStage {
  PreparedShowcaseStage(@html.Html)
}

///|
priv enum ShowcaseDemoEntry {
  NamedShowcaseDemo(String, String, @html.Html)
}

///|
const ShowcaseComponentStageBodyStyle : String = "width:100%;min-width:0"

///|
const ShowcaseDemoListStyle : String = "box-sizing:border-box;display:flex;width:100%;min-width:0;flex-direction:column;gap:2.5rem"

///|
const ShowcaseDemoSectionStyle : String = "box-sizing:border-box;display:flex;width:100%;min-width:0;flex-direction:column;gap:1rem"

///|
const ShowcaseDemoSectionHeaderStyle : String = "box-sizing:border-box;display:flex;width:100%;min-width:0;flex-direction:column;align-items:flex-start;gap:0.375rem;margin:0;text-align:start"

///|
const ShowcaseDemoSectionTitleStyle : String = "margin:0;font-size:1.125rem;line-height:1.5rem;font-weight:650;letter-spacing:-0.02em"

///|
const ShowcaseDemoSectionDescriptionStyle : String = "max-width:42rem;margin:0;color:var(--rui-muted-foreground);font-size:0.875rem;line-height:1.5"

///|
const ShowcaseDemoFrameStyle : String = "box-sizing:border-box;width:100%;min-width:0;overflow:hidden;border:1px solid var(--rui-border);border-radius:calc(var(--rui-radius) + 0.375rem);background:var(--rui-background)"

///|
const ShowcaseDemoPreviewStyle : String = "box-sizing:border-box;display:flex;width:100%;min-width:0;min-height:var(--rui-showcase-stage-min-height,16rem);align-items:center;justify-content:center;padding:clamp(1.25rem,4vw,2.5rem)"

///|
const ShowcaseDemoPlainStyle : String = "background:var(--rui-background)"

///|
const ShowcaseDemoSurfaceStyle : String = "background:light-dark(color-mix(in oklab,var(--rui-muted) 35%,var(--rui-background)),var(--rui-background))"

///|
const ShowcaseDemoCodeStyle : String = "--rui-showcase-code-background:light-dark(color-mix(in oklab,var(--rui-muted) 65%,var(--rui-background)),var(--rui-card));border-top:1px solid var(--rui-border);background:var(--rui-showcase-code-background)"

///|
const ShowcaseDemoCodePeekStyle : String = "box-sizing:border-box;position:absolute;inset:0;margin:0;overflow:hidden;pointer-events:none;user-select:none"

///|
const ShowcaseDemoCodePanelStyle : String = "position:relative"

///|
const ShowcaseDemoCodeScrollStyle : String = "max-height:18rem;overflow:auto"

///|
const ShowcaseDemoCodeCopyStyle : String = "position:absolute;top:0.75rem;right:1rem;z-index:3;width:1.75rem;height:1.75rem;min-width:1.75rem;min-height:1.75rem;--rui-button-base-bg:var(--rui-showcase-code-background);--rui-control-radius:0.375rem"

///|
fn showcase_anchor(value : String) -> String {
  let builder = StringBuilder::new()
  let mut separator = false
  for character in value {
    match character {
      'A'..='Z' | 'a'..='z' | '0'..='9' => {
        if separator && !builder.is_empty() {
          builder.write_char('-')
        }
        builder.write_char(character)
        separator = false
      }
      _ => if !builder.is_empty() { separator = true }
    }
  }
  let anchor = builder.to_string()
  if anchor == "" {
    "component"
  } else {
    anchor
  }
}

///|
fn showcase_highlighted_code(code : String) -> @html.Html {
  @shiki.static_code(
    code,
    lang="moonbit",
    light_theme="github-light",
    dark_theme="github-dark-default",
  )
}

///|
fn showcase_component_anchor(title : String) -> String {
  "component-\{showcase_anchor(title)}"
}

///|
fn showcase_component_header(
  title : String,
  description : String,
) -> @html.Html {
  @html.header(
    class="rui-showcase-component-header",
    style=[ShowcaseComponentHeaderStyle],
    [
      @html.h3(
        class="rui-showcase-component-title",
        style=[ShowcaseComponentTitleStyle],
        title,
      ),
      @html.p(style=[ShowcaseComponentDescriptionStyle], description),
    ],
  )
}

///|
fn showcase_stage(
  body : @html.Html,
  code : String,
  variant? : ShowcaseStageVariant = ShowcaseStagePlain,
  tall? : Bool = false,
  stage_style? : String = "",
) -> @html.Html {
  let preview_styles = [
    ShowcaseDemoPreviewStyle,
    if tall {
      "--rui-showcase-stage-min-height:22rem"
    } else {
      ""
    },
    match variant {
      ShowcaseStagePlain => ShowcaseDemoPlainStyle
      ShowcaseStageSurface => ShowcaseDemoSurfaceStyle
    },
    stage_style,
  ]
  @html.div(class="rui-showcase-demo-stage", style=[ShowcaseDemoFrameStyle], [
    @html.div(
      class="rui-showcase-demo-preview",
      style=preview_styles,
      @html.div(style=[ShowcaseComponentStageBodyStyle], body),
    ),
    @html.details(
      class="rui-showcase-demo-code",
      style=[ShowcaseDemoCodeStyle],
      [
        @html.summary(class="rui-showcase-demo-code-summary", [
          @html.div(
            class="rui-showcase-shiki rui-showcase-demo-code-peek",
            style=[ShowcaseDemoCodePeekStyle],
            attrs=@html.Attrs::build().aria_hidden("true"),
            showcase_highlighted_code(code),
          ),
          @html.span(class="rui-showcase-demo-code-toggle", "View Code"),
        ]),
        @html.div(
          class="rui-showcase-demo-code-panel",
          style=[ShowcaseDemoCodePanelStyle],
          [
            @ui.button(
              variant=@ui.Ghost,
              size=@ui.IconSm,
              class="rui-showcase-demo-code-copy",
              title="Copy code",
              attrs=@html.Attrs::build().aria_label("Copy code"),
              style=[ShowcaseDemoCodeCopyStyle],
              on_click=@clipboard.copy(@clipboard.Text(code)),
              showcase_copy_icon(),
            ),
            @html.div(
              class="rui-showcase-shiki rui-showcase-demo-code-scroll",
              style=[ShowcaseDemoCodeScrollStyle],
              showcase_highlighted_code(code),
            ),
          ],
        ),
      ],
    ),
  ])
}

///|
fn showcase_demo_stage(
  body : @html.Html,
  code : String,
  variant? : ShowcaseStageVariant = ShowcaseStageSurface,
  tall? : Bool = false,
  stage_style? : String = "",
) -> ShowcasePreparedStage {
  PreparedShowcaseStage(
    showcase_stage(body, code, variant~, tall~, stage_style~),
  )
}

///|
fn showcase_demo_section(
  title : String,
  description : String,
  stage : ShowcasePreparedStage,
) -> ShowcaseDemoEntry {
  let stage_html = match stage {
    PreparedShowcaseStage(stage_html) => stage_html
  }
  NamedShowcaseDemo(title, description, stage_html)
}

///|
fn showcase_demo_entry_id(
  component_id : String,
  entry : ShowcaseDemoEntry,
) -> String {
  match entry {
    NamedShowcaseDemo(title, _, _) =>
      "\{component_id}--\{showcase_anchor(title)}"
  }
}

///|
fn showcase_demo_entry_label(entry : ShowcaseDemoEntry) -> String {
  match entry {
    NamedShowcaseDemo(title, _, _) => title
  }
}

///|
fn showcase_demo_entry_view(
  component_id : String,
  entry : ShowcaseDemoEntry,
) -> @html.Html {
  let id = showcase_demo_entry_id(component_id, entry)
  match entry {
    NamedShowcaseDemo(title, description, stage) =>
      @html.section(
        id~,
        class="rui-showcase-demo-section",
        style=[ShowcaseDemoSectionStyle],
        [
          @html.header(
            class="rui-showcase-demo-section-header",
            style=[ShowcaseDemoSectionHeaderStyle],
            [
              @html.h4(style=[ShowcaseDemoSectionTitleStyle], title),
              @html.p(style=[ShowcaseDemoSectionDescriptionStyle], description),
            ],
          ),
          stage,
        ],
      )
  }
}

///|
fn showcase_component_toc(
  title : String,
  component_id : String,
  entries : Array[ShowcaseDemoEntry],
) -> @html.Html {
  @html.aside(
    class="rui-showcase-component-toc",
    style=[ShowcaseComponentTocStyle],
    [
      @html.nav(
        attrs=@html.Attrs::build().aria_label("\{title} variants"),
        [
          for entry in entries => {
            rail_link(
              "#\{showcase_demo_entry_id(component_id, entry)}",
              showcase_demo_entry_label(entry),
              style=ShowcaseComponentTocLinkStyle,
            )
          }
        ],
      ),
    ],
  )
}

///|
fn showcase_component_demos(
  title : String,
  description : String,
  demos : Array[ShowcaseDemoEntry],
) -> @html.Html {
  let component_id = showcase_component_anchor(title)
  @html.section(
    id=component_id,
    class="rui-showcase-component",
    style=[ShowcaseComponentShellStyle],
    [
      @html.div(
        class="rui-showcase-component-main",
        style=[ShowcaseComponentMainStyle],
        [
          showcase_component_header(title, description),
          @html.div(
            style=[ShowcaseDemoListStyle],
            [
              for demo in demos => showcase_demo_entry_view(component_id, demo)
            ],
          ),
        ],
      ),
      showcase_component_toc(title, component_id, demos),
    ],
  )
}
