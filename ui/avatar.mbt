///|
pub(all) enum AvatarSize {
  Default
  Sm
  Lg
} derive(Debug, Eq)

///|
pub(all) enum AvatarImageStatus {
  AvatarLoading
  AvatarLoaded
  AvatarError
} derive(Debug, Eq)

///|
#cfg(target="js")
extern "js" fn ffi_bind_avatar_image(
  id : String,
  notify : (Int) -> Unit,
) -> Unit =
  #| (id, notify) => {
  #|   const image = document.getElementById(id)
  #|   if (!image) return
  #|   image.__ruiAvatarNotify = notify
  #|   if (!image.__ruiAvatarBound) {
  #|     image.__ruiAvatarBound = true
  #|     image.addEventListener("load", () => image.__ruiAvatarNotify?.(1))
  #|     image.addEventListener("error", () => image.__ruiAvatarNotify?.(2))
  #|   }
  #|   if (image.complete) notify(image.naturalWidth > 0 ? 1 : 2)
  #| }

///|
#cfg(target="js")
fn bind_avatar_image_cmd(
  id : String,
  emit : @cmd.Emit[AvatarImageStatus],
) -> @cmd.Cmd {
  @cmd.custom_cmd(kind=@cmd.AfterRender, scheduler => {
    ui_after_mount(
      id,
      () => {
        ffi_bind_avatar_image(id, status => {
          scheduler.add(
            emit(if status == 1 { AvatarLoaded } else { AvatarError }),
          )
        })
      },
      purpose="avatar-image-bind",
    )
  })
}

///|
const AvatarBaseStyle : String = "position:relative;isolation:isolate;display:inline-flex;width:var(--rui-avatar-size,2rem);height:var(--rui-avatar-size,2rem);flex-shrink:0;overflow:hidden;margin-inline-start:var(--rui-avatar-overlap,0);border-radius:9999px;box-shadow:var(--rui-avatar-ring,0 0 0 0 transparent);vertical-align:middle;user-select:none"

///|
const AvatarDefaultSizeStyle : String = "--rui-avatar-size:2rem;--rui-avatar-fallback-font-size:0.875rem;--rui-avatar-badge-size:0.625rem;--rui-avatar-badge-icon-size:0.5rem;--rui-avatar-group-count-icon-size:1rem"

///|
const AvatarSmSizeStyle : String = "--rui-avatar-size:1.5rem;--rui-avatar-fallback-font-size:0.75rem;--rui-avatar-badge-size:0.5rem;--rui-avatar-badge-icon-size:0;--rui-avatar-group-count-icon-size:0.75rem"

///|
const AvatarLgSizeStyle : String = "--rui-avatar-size:2.5rem;--rui-avatar-fallback-font-size:0.875rem;--rui-avatar-badge-size:0.75rem;--rui-avatar-badge-icon-size:0.5rem;--rui-avatar-group-count-icon-size:1.25rem"

///|
const AvatarImageStyle : String = "position:absolute;inset:0;z-index:1;width:100%;height:100%;border-radius:9999px;color:transparent;font-size:0;object-fit:cover"

///|
const AvatarFallbackStyle : String = "display:flex;width:100%;height:100%;align-items:center;justify-content:center;border-radius:9999px;background:var(--rui-muted,oklch(0.97 0 0));color:var(--rui-muted-foreground,oklch(0.556 0 0));font-size:var(--rui-avatar-fallback-font-size,0.875rem);line-height:1;font-weight:500"

///|
const AvatarBadgeStyle : String = "position:absolute;inset-inline-end:0;bottom:0;z-index:2;display:inline-flex;width:var(--rui-avatar-badge-size,0.625rem);height:var(--rui-avatar-badge-size,0.625rem);align-items:center;justify-content:center;border-radius:9999px;background:var(--rui-primary,oklch(0.205 0 0));color:var(--rui-primary-foreground,oklch(0.985 0 0));font-size:var(--rui-avatar-badge-icon-size,0.5rem);line-height:1;box-shadow:0 0 0 2px var(--rui-background,oklch(1 0 0));user-select:none"

///|
const AvatarGroupStyle : String = "--rui-avatar-overlap:-0.5rem;--rui-avatar-ring:0 0 0 2px var(--rui-background,oklch(1 0 0));display:flex;align-items:center;padding-inline-start:0.5rem"

///|
const AvatarGroupCountStyle : String = "position:relative;display:flex;width:var(--rui-avatar-size,2rem);height:var(--rui-avatar-size,2rem);flex-shrink:0;align-items:center;justify-content:center;margin-inline-start:var(--rui-avatar-overlap,-0.5rem);border-radius:9999px;background:var(--rui-muted,oklch(0.97 0 0));color:var(--rui-muted-foreground,oklch(0.556 0 0));font-size:var(--rui-avatar-fallback-font-size,0.875rem);line-height:1;font-weight:500;box-shadow:var(--rui-avatar-ring,0 0 0 2px var(--rui-background,oklch(1 0 0)));--rui-icon-size:var(--rui-avatar-group-count-icon-size,1rem)"

///|
fn avatar_size_style(size : AvatarSize) -> String {
  match size {
    Default => AvatarDefaultSizeStyle
    Sm => AvatarSmSizeStyle
    Lg => AvatarLgSizeStyle
  }
}

///|
fn avatar_size_value(size : AvatarSize) -> String {
  match size {
    Default => "default"
    Sm => "sm"
    Lg => "lg"
  }
}

///|
fn avatar_part_attrs(attrs : @html.Attrs?, slot : String) -> @html.Attrs {
  ui_attrs(attrs).data_set("slot", slot)
}

///|
/// Render the composable Vega avatar root as a native `span` element.
///
/// Size is shared with fallback and badge parts through inherited inline custom
/// properties. The root does not own image-loading state; omit `avatar_image`
/// while showing a fallback, or control that choice in the parent TEA model.
pub fn[C : @html.IsChildren] avatar(
  size? : AvatarSize = Default,
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let element_attrs = avatar_part_attrs(attrs, "avatar").data_set(
    "size",
    avatar_size_value(size),
  )
  @html.span(
    style=ui_styles(
      [
        UiBoxSizing,
        UiFontSans,
        UiTextRendering,
        AvatarBaseStyle,
        avatar_size_style(size),
      ],
      style,
    ),
    id?,
    class?,
    title?,
    hidden?,
    attrs=element_attrs,
    children,
  )
}

///|
/// Render the avatar image as a native `img` layered above the fallback.
pub fn avatar_image(
  src? : String,
  alt? : String,
  width? : Int,
  height? : Int,
  srcset? : String,
  sizes? : String,
  loading? : String,
  decoding? : String,
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  @html.img(
    style=ui_styles([UiBoxSizing, AvatarImageStyle], style),
    id?,
    class?,
    hidden?,
    src?,
    alt?,
    title?,
    width?,
    height?,
    srcset?,
    sizes?,
    loading?,
    decoding?,
    attrs=avatar_part_attrs(attrs, "avatar-image"),
  )
}

///|
pub fn[C : @html.IsChildren] avatar_fallback(
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.span(
    style=ui_styles([UiBoxSizing, AvatarFallbackStyle], style),
    id?,
    class?,
    title?,
    hidden?,
    attrs=avatar_part_attrs(attrs, "avatar-fallback"),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] avatar_badge(
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.span(
    style=ui_styles([UiBoxSizing, AvatarBadgeStyle], style),
    id?,
    class?,
    title?,
    hidden?,
    attrs=avatar_part_attrs(attrs, "avatar-badge"),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] avatar_group(
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.div(
    style=ui_styles(
      [UiBoxSizing, UiFontSans, UiTextRendering, AvatarGroupStyle],
      style,
    ),
    id?,
    class?,
    title?,
    hidden?,
    attrs=avatar_part_attrs(attrs, "avatar-group"),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] avatar_group_count(
  size? : AvatarSize = Default,
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let element_attrs = avatar_part_attrs(attrs, "avatar-group-count").data_set(
    "size",
    avatar_size_value(size),
  )
  @html.div(
    style=ui_styles(
      [UiBoxSizing, avatar_size_style(size), AvatarGroupCountStyle],
      style,
    ),
    id?,
    class?,
    title?,
    hidden?,
    attrs=element_attrs,
    children,
  )
}

///|
fn[C : @html.IsChildren] render_avatar_with_fallback(
  status : AvatarImageStatus,
  id : String,
  src : String,
  alt : String?,
  size : AvatarSize,
  class : String?,
  title : String?,
  attrs : @html.Attrs?,
  style : Array[String],
  image_attrs : @html.Attrs?,
  image_style : Array[String],
  fallback_attrs : @html.Attrs?,
  fallback_style : Array[String],
  fallback : C,
) -> @html.Html {
  let status_value = match status {
    AvatarLoading => "loading"
    AvatarLoaded => "loaded"
    AvatarError => "error"
  }
  let root_attrs = ui_attrs(attrs).data_set("image-state", status_value)
  avatar(size~, id~, class?, title?, attrs=root_attrs, style~, [
    avatar_fallback(
      hidden=status is AvatarLoaded,
      attrs?=fallback_attrs,
      style=fallback_style,
      fallback,
    ),
    avatar_image(
      id=id + "-image",
      src~,
      alt?,
      hidden=!(status is AvatarLoaded),
      attrs?=image_attrs,
      style=image_style,
    ),
  ])
}

///|
/// Build a black-box avatar that owns image loading and failure state.
///
/// The fallback remains visible until the browser reports a successfully
/// decoded image resource. Use the pure `avatar`, `avatar_image`, and
/// `avatar_fallback` parts when the application already owns that state.
#cfg(target="js")
pub fn[C : @html.IsChildren] avatar_with_fallback(
  id~ : String,
  src~ : String,
  alt? : String,
  size? : AvatarSize = Default,
  on_status_change? : @cmd.Emit[AvatarImageStatus],
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  image_attrs? : @html.Attrs,
  image_style? : Array[String] = [],
  fallback_attrs? : @html.Attrs,
  fallback_style? : Array[String] = [],
  fallback : C,
) -> @rabbita.Val[@html.Html] {
  let initial = if src == "" { AvatarError } else { AvatarLoading }
  let (status, _) = @rabbita.create_state_with_init(
    init=emit => {
      (
        initial,
        if src == "" {
          @cmd.none
        } else {
          bind_avatar_image_cmd(id + "-image", emit)
        },
      )
    },
    update=(_, next, _) => {
      (
        next,
        if on_status_change is Some(notify) {
          notify(next)
        } else {
          @cmd.none
        },
      )
    },
  )
  status.view(status => {
    render_avatar_with_fallback(
      status, id, src, alt, size, class, title, attrs, style, image_attrs, image_style,
      fallback_attrs, fallback_style, fallback,
    )
  })
}

///|
#cfg(not(target="js"))
pub fn[C : @html.IsChildren] avatar_with_fallback(
  id~ : String,
  src~ : String,
  alt? : String,
  size? : AvatarSize = Default,
  on_status_change? : @cmd.Emit[AvatarImageStatus],
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  image_attrs? : @html.Attrs,
  image_style? : Array[String] = [],
  fallback_attrs? : @html.Attrs,
  fallback_style? : Array[String] = [],
  fallback : C,
) -> @rabbita.Val[@html.Html] {
  ignore(on_status_change)
  let status = if src == "" { AvatarError } else { AvatarLoading }
  @rabbita.Val::constant(
    render_avatar_with_fallback(
      status, id, src, alt, size, class, title, attrs, style, image_attrs, image_style,
      fallback_attrs, fallback_style, fallback,
    ),
  )
}
