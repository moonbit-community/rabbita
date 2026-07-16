///|
pub(all) enum AttachmentState {
  AttachmentIdle
  AttachmentUploading
  AttachmentProcessing
  AttachmentError
  AttachmentDone
} derive(Debug, Eq)

///|
pub(all) enum AttachmentSize {
  AttachmentDefaultSize
  AttachmentSm
  AttachmentXs
} derive(Debug, Eq)

///|
pub(all) enum AttachmentOrientation {
  AttachmentHorizontal
  AttachmentVertical
} derive(Debug, Eq)

///|
pub(all) enum AttachmentMediaVariant {
  AttachmentIcon
  AttachmentImage
} derive(Debug, Eq)

///|
fn attachment_state_value(state : AttachmentState) -> String {
  match state {
    AttachmentIdle => "idle"
    AttachmentUploading => "uploading"
    AttachmentProcessing => "processing"
    AttachmentError => "error"
    AttachmentDone => "done"
  }
}

///|
fn attachment_size_value(size : AttachmentSize) -> String {
  match size {
    AttachmentDefaultSize => "default"
    AttachmentSm => "sm"
    AttachmentXs => "xs"
  }
}

///|
fn attachment_orientation_value(orientation : AttachmentOrientation) -> String {
  match orientation {
    AttachmentHorizontal => "horizontal"
    AttachmentVertical => "vertical"
  }
}

///|
fn attachment_size_style(size : AttachmentSize) -> String {
  match size {
    AttachmentDefaultSize =>
      "--rui-attachment-media-size:2.5rem;--rui-attachment-icon-size:1rem;--rui-attachment-spinner-size:1rem;--rui-attachment-content-padding-block:0.5rem;--rui-attachment-content-padding-inline-root:0.625rem;--rui-attachment-media-padding:0.5rem;gap:0.5rem;font-size:0.875rem"
    AttachmentSm =>
      "--rui-attachment-media-size:2rem;--rui-attachment-icon-size:1rem;--rui-attachment-spinner-size:1rem;--rui-attachment-content-padding-block:0.375rem;--rui-attachment-content-padding-inline-root:0.5rem;--rui-attachment-media-padding:0.375rem;gap:0.625rem;font-size:0.75rem"
    AttachmentXs =>
      "--rui-attachment-media-size:1.75rem;--rui-attachment-icon-size:0.875rem;--rui-attachment-spinner-size:0.875rem;--rui-attachment-content-padding-block:0.25rem;--rui-attachment-content-padding-inline-root:0.375rem;--rui-attachment-media-padding:0.25rem;gap:0.375rem;border-radius:0.5rem;font-size:0.75rem"
  }
}

///|
fn attachment_state_style(state : AttachmentState) -> String {
  match state {
    AttachmentIdle => "border-style:dashed"
    AttachmentError =>
      "--rui-attachment-base-border:color-mix(in oklch,var(--rui-destructive,oklch(0.577 0.245 27.325)) 30%,transparent);--rui-attachment-media-bg:var(--rui-destructive-subtle,oklch(0.577 0.245 27.325 / 0.1));--rui-attachment-media-fg:var(--rui-destructive,oklch(0.577 0.245 27.325));--rui-attachment-description-fg:color-mix(in oklab,var(--rui-destructive,oklch(0.577 0.245 27.325)) 80%,transparent);--rui-attachment-image-opacity:0.6"
    AttachmentUploading | AttachmentProcessing =>
      "--rui-attachment-image-opacity:0.6;--rui-attachment-title-fg:transparent;--rui-attachment-title-bg:linear-gradient(90deg,color-mix(in oklab,var(--rui-muted-foreground,oklch(0.556 0 0)) 30%,transparent) 0%,var(--rui-muted-foreground,oklch(0.556 0 0)) 50%,color-mix(in oklab,var(--rui-muted-foreground,oklch(0.556 0 0)) 30%,transparent) 100%);--rui-attachment-title-bg-size:200% 100%;--rui-attachment-title-animation:rui-shimmer 1.6s linear infinite"
    AttachmentDone => "--rui-attachment-image-opacity:1"
  }
}

///|
pub fn[C : @html.IsChildren] attachment(
  state? : AttachmentState = AttachmentDone,
  size? : AttachmentSize = AttachmentDefaultSize,
  orientation? : AttachmentOrientation = AttachmentHorizontal,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let state_value = attachment_state_value(state)
  let size_value = attachment_size_value(size)
  let orientation_value = attachment_orientation_value(orientation)
  @html.div(
    id?,
    class?,
    title?,
    attrs=ui_attrs(attrs)
      .data_set("slot", "attachment")
      .data_set("state", state_value)
      .data_set("size", size_value)
      .data_set("orientation", orientation_value),
    style=ui_styles(
      [
        UiBoxSizing,
        UiFontSans,
        UiTransition,
        "position:relative;display:flex;width:fit-content;max-width:100%;min-width:0;flex-shrink:0;flex-wrap:wrap;align-items:center;scroll-snap-align:start;border:1px solid var(--rui-attachment-border,var(--rui-attachment-base-border,var(--rui-border,oklch(0.922 0 0))));border-radius:0.75rem;background:var(--rui-attachment-bg,var(--rui-attachment-base-bg,var(--rui-card,var(--rui-background,white))));padding-block:var(--rui-attachment-padding-block,0);padding-inline:var(--rui-attachment-padding-inline,0);color:var(--rui-attachment-fg,var(--rui-attachment-base-fg,var(--rui-card-foreground,var(--rui-foreground,oklch(0.145 0 0)))));box-shadow:var(--rui-attachment-shadow,var(--rui-attachment-base-shadow,none));--rui-attachment-media-bg:var(--rui-muted,oklch(0.97 0 0));--rui-attachment-media-fg:var(--rui-foreground,oklch(0.145 0 0));--rui-attachment-description-fg:var(--rui-muted-foreground,oklch(0.556 0 0));--rui-attachment-image-opacity:1;--rui-attachment-title-fg:inherit;--rui-attachment-title-bg:none;--rui-attachment-title-bg-size:auto;--rui-attachment-title-animation:none;--rui-attachment-content-width:auto;--rui-attachment-content-padding-inline:0;--rui-attachment-actions-position:relative;--rui-attachment-actions-top:auto;--rui-attachment-actions-inline-end:auto;--rui-attachment-actions-gap:0.25rem",
        attachment_size_style(size),
        if orientation is AttachmentVertical {
          if size is AttachmentXs {
            "width:6rem;flex-direction:column;align-items:stretch;--rui-attachment-media-width:100%;--rui-attachment-icon-size:0.875rem;--rui-attachment-spinner-size:1.5rem;--rui-attachment-content-width:7.5rem;--rui-attachment-content-padding-inline:0.25rem;--rui-attachment-actions-position:absolute;--rui-attachment-actions-top:0.75rem;--rui-attachment-actions-inline-end:0.75rem;--rui-attachment-actions-gap:0.25rem"
          } else {
            "width:6rem;flex-direction:column;align-items:stretch;--rui-attachment-media-width:100%;--rui-attachment-icon-size:1.5rem;--rui-attachment-spinner-size:1.5rem;--rui-attachment-content-width:7.5rem;--rui-attachment-content-padding-inline:0.25rem;--rui-attachment-actions-position:absolute;--rui-attachment-actions-top:0.75rem;--rui-attachment-actions-inline-end:0.75rem;--rui-attachment-actions-gap:0.25rem"
          }
        } else {
          "min-width:10rem;--rui-attachment-media-width:var(--rui-attachment-media-size,2.5rem)"
        },
        attachment_state_style(state),
      ],
      style,
    ),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] attachment_group(
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
    attrs=ui_attrs(attrs).data_set("slot", "attachment-group"),
    style=ui_styles(
      [
        "display:flex;min-width:0;gap:0.75rem;overflow-x:auto;overscroll-behavior-inline:contain;padding-block:0.25rem;scroll-snap-type:x mandatory",
      ],
      style,
    ),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] attachment_media(
  variant? : AttachmentMediaVariant = AttachmentIcon,
  error? : Bool = false,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let variant_value = if variant is AttachmentImage { "image" } else { "icon" }
  @html.div(
    id?,
    class?,
    title?,
    attrs=ui_attrs(attrs)
      .data_set("slot", "attachment-media")
      .data_set("variant", variant_value),
    style=ui_styles(
      [
        "position:relative;display:flex;aspect-ratio:1;width:var(--rui-attachment-media-width,var(--rui-attachment-media-size,2.5rem));flex-shrink:0;align-items:center;justify-content:center;overflow:hidden;border-radius:0.5rem;background:var(--rui-attachment-media-bg,var(--rui-muted,oklch(0.97 0 0)));color:var(--rui-attachment-media-fg,var(--rui-foreground,oklch(0.145 0 0)));--rui-icon-size:var(--rui-attachment-icon-size,1rem)",
        if variant is AttachmentImage {
          "opacity:var(--rui-attachment-image-opacity,0.6)"
        } else {
          ""
        },
        if error {
          "--rui-attachment-media-bg:var(--rui-destructive-subtle,oklch(0.577 0.245 27.325 / 0.1));--rui-attachment-media-fg:var(--rui-destructive,oklch(0.577 0.245 27.325))"
        } else {
          ""
        },
      ],
      style,
    ),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] attachment_content(
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
    attrs=ui_attrs(attrs).data_set("slot", "attachment-content"),
    style=ui_styles(
      [
        "width:var(--rui-attachment-content-width,auto);max-width:100%;min-width:0;flex:1;padding-inline:var(--rui-attachment-content-padding-inline,0);line-height:1.25",
      ],
      style,
    ),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] attachment_title(
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
    attrs=ui_attrs(attrs).data_set("slot", "attachment-title"),
    style=ui_styles(
      [
        "display:block;max-width:100%;min-width:0;overflow:hidden;background-image:var(--rui-attachment-title-bg,none);background-position:200% 0;background-size:var(--rui-attachment-title-bg-size,auto);background-repeat:no-repeat;background-clip:text;-webkit-background-clip:text;color:var(--rui-attachment-title-fg,inherit);font-weight:500;text-overflow:ellipsis;white-space:nowrap;animation:var(--rui-attachment-title-animation,none)",
      ],
      style,
    ),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] attachment_description(
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
    attrs=ui_attrs(attrs).data_set("slot", "attachment-description"),
    style=ui_styles(
      [
        "display:block;max-width:100%;min-width:0;overflow:hidden;margin-top:0.125rem;color:var(--rui-attachment-description-fg,var(--rui-muted-foreground,oklch(0.556 0 0)));font-size:0.75rem;line-height:1rem;text-overflow:ellipsis;white-space:nowrap",
      ],
      style,
    ),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] attachment_actions(
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
    attrs=ui_attrs(attrs).data_set("slot", "attachment-actions"),
    style=ui_styles(
      [
        "position:var(--rui-attachment-actions-position,relative);top:var(--rui-attachment-actions-top,auto);inset-inline-end:var(--rui-attachment-actions-inline-end,auto);z-index:20;display:flex;flex-shrink:0;align-items:center;gap:var(--rui-attachment-actions-gap,0.25rem)",
      ],
      style,
    ),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] attachment_action(
  variant? : ButtonVariant = Ghost,
  size? : ButtonSize = IconXs,
  disabled? : Bool = false,
  aria_label? : String,
  on_click? : @cmd.Cmd,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let action_attrs = ui_attrs(attrs).data_set("slot", "attachment-action")
  if aria_label is Some(label) {
    ignore(action_attrs.aria_label(label))
  }
  button(
    variant~,
    size~,
    disabled~,
    slot="attachment-action",
    on_click?,
    id?,
    class?,
    title?,
    attrs=action_attrs,
    style~,
    children,
  )
}

///|
pub fn[C : @html.IsChildren] attachment_trigger(
  disabled? : Bool = false,
  on_click? : @cmd.Cmd,
  aria_label? : String,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let trigger_attrs = ui_attrs(attrs).data_set("slot", "attachment-trigger")
  if aria_label is Some(label) {
    ignore(trigger_attrs.aria_label(label))
  }
  if disabled {
    ignore(trigger_attrs.aria_disabled("true").data_set("disabled", ""))
  }
  @html.button(
    type_="button",
    disabled~,
    on_click?,
    id?,
    class?,
    title?,
    attrs=trigger_attrs,
    style=ui_styles(
      [
        UiBoxSizing,
        "position:absolute;inset:0;z-index:10;border:0;border-radius:inherit;background:transparent;color:transparent;box-shadow:var(--rui-attachment-trigger-shadow,none);cursor:pointer;outline:none;outline-offset:2px",
        ui_disabled_style(disabled),
      ],
      style,
    ),
    children,
  )
}

///|
#cfg(target="js")
fn attachment_bind_disabled_link(attrs : @html.Attrs, disabled : Bool) -> Unit {
  if disabled {
    ignore(
      attrs.on_click_after(event => {
        event.prevent_default()
        @cmd.none
      }),
    )
  }
}

///|
#cfg(not(target="js"))
fn attachment_bind_disabled_link(attrs : @html.Attrs, disabled : Bool) -> Unit {
  ignore((attrs, disabled))
}

///|
/// Render the Vega attachment trigger's `asChild` path as a native anchor.
pub fn[C : @html.IsChildren] attachment_trigger_link(
  href~ : String,
  disabled? : Bool = false,
  aria_label? : String,
  target? : @html.Target = Self,
  rel? : String,
  download? : String,
  escape? : Bool = false,
  on_click? : @cmd.Cmd,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let trigger_attrs = ui_attrs(attrs).data_set("slot", "attachment-trigger")
  if aria_label is Some(label) {
    ignore(trigger_attrs.aria_label(label))
  }
  if disabled {
    ignore(
      trigger_attrs.aria_disabled("true").data_set("disabled", "").tabindex(-1),
    )
  } else if on_click is Some(command) {
    ignore(trigger_attrs.on_click_after(_ => command))
  }
  attachment_bind_disabled_link(trigger_attrs, disabled)
  @html.a(
    href~,
    target~,
    rel?,
    download?,
    id?,
    class?,
    title?,
    attrs=trigger_attrs,
    style=ui_styles(
      [
        UiBoxSizing,
        "position:absolute;inset:0;z-index:10;border:0;border-radius:inherit;background:transparent;color:transparent;box-shadow:var(--rui-attachment-trigger-shadow,none);cursor:pointer;outline:none;outline-offset:2px;text-decoration:none",
        ui_disabled_style(disabled),
      ],
      style,
    ),
    children,
    escape~,
  )
}
