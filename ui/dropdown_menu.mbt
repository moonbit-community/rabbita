///|
struct DropdownMenuScope {
  menu : MenuScope
}

///|
struct DropdownMenuRadioGroupScope {
  menu : MenuScope
  group : String
}

///|
struct DropdownMenuSubScope {
  menu : MenuScope
  key : String
}

///|
#cfg(target="js")
priv enum DropdownMenuMsg {
  DropdownSetOpen(Bool)
  DropdownNativeOpen(Bool)
  DropdownSetActive(Int)
  DropdownToggleChecked(String)
  DropdownSetRadio(String, String)
  DropdownSetSubmenu(MenuSubmenuChange)
}

///|
#cfg(target="js")
fn dropdown_notify(on_open_change : @cmd.Emit[Bool]?, open : Bool) -> @cmd.Cmd {
  if on_open_change is Some(notify) {
    notify(open)
  } else {
    @cmd.none
  }
}

///|
fn dropdown_scope(
  id : String,
  model : MenuCoreModel,
  set_open : @cmd.Emit[Bool],
  set_active : @cmd.Emit[Int],
  toggle_checked : @cmd.Emit[String],
  set_radio : @cmd.Emit[(String, String)],
  set_submenu : @cmd.Emit[MenuSubmenuChange],
) -> DropdownMenuScope {
  {
    menu: {
      id,
      content_id: id + "-content",
      trigger_id: id + "-trigger",
      model,
      counter: Ref(0),
      open_command: set_open(true),
      close_command: set_open(false),
      toggle_command: set_open(!model.open),
      set_active,
      toggle_checked,
      set_radio,
      set_submenu,
    },
  }
}

///|
/// Stateful shadcn/Vega dropdown menu. The builder receives an opaque scope
/// shared by all compound parts; no registration or stylesheet is required.
#cfg(target="js")
pub fn dropdown_menu(
  id~ : String,
  default_open? : Bool = false,
  default_checked_values? : Array[String] = [],
  default_radio_values? : Array[(String, String)] = [],
  on_open_change? : @cmd.Emit[Bool],
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : (DropdownMenuScope) -> @html.Html,
) -> @rabbita.Val[@html.Html] {
  let initial = menu_core_model(
    default_open, default_checked_values, default_radio_values,
  )
  let (model, emit) = @rabbita.create_state_with_init(
    init=emit => {
      let set_active = emit.map(index => DropdownSetActive(index))
      let set_submenu = emit.map(value => DropdownSetSubmenu(value))
      (
        initial,
        @cmd.batch([
          floating_bind_sync_cmd(
            id + "-content",
            emit.map(open => DropdownNativeOpen(open)),
          ),
          menu_bind_surface_cmd(
            id + "-root",
            set_active,
            emit(DropdownSetOpen(false)),
            set_submenu,
          ),
          if default_open {
            @cmd.batch([
              floating_set_open_cmd(id + "-content", true),
              menu_focus_first_cmd(id + "-root", set_active),
            ])
          } else {
            @cmd.none
          },
        ]),
      )
    },
    update=(emit, msg, current) => {
      match msg {
        DropdownSetOpen(open) =>
          if open == current.open {
            (current, @cmd.none)
          } else {
            let next = {
              ..current,
              open,
              active: if open {
                -1
              } else {
                current.active
              },
              submenus: [],
            }
            (
              next,
              @cmd.batch([
                floating_set_open_cmd(id + "-content", open),
                if open {
                  menu_focus_first_cmd(
                    id + "-root",
                    emit.map(index => DropdownSetActive(index)),
                  )
                } else {
                  ui_focus_id(id + "-trigger")
                },
                if open {
                  @cmd.none
                } else {
                  menu_position_submenus_cmd(id + "-root")
                },
                dropdown_notify(on_open_change, open),
              ]),
            )
          }
        DropdownNativeOpen(open) =>
          if open == current.open {
            (current, @cmd.none)
          } else {
            (
              { ..current, open, submenus: [] },
              @cmd.batch([
                if open {
                  @cmd.none
                } else {
                  menu_position_submenus_cmd(id + "-root")
                },
                dropdown_notify(on_open_change, open),
              ]),
            )
          }
        DropdownSetActive(index) =>
          if current.active == index {
            (current, @cmd.none)
          } else {
            (
              { ..current, active: index },
              menu_focus_item_cmd(id + "-root", index),
            )
          }
        DropdownToggleChecked(value) =>
          (
            { ..current, checked: menu_toggle_value(current.checked, value) },
            @cmd.none,
          )
        DropdownSetRadio(group, value) =>
          (
            {
              ..current,
              radios: menu_set_radio_value(current.radios, group, value),
            },
            @cmd.none,
          )
        DropdownSetSubmenu(change) => {
          let submenus = menu_update_submenus(current.submenus, change)
          if submenus == current.submenus {
            (current, @cmd.none)
          } else {
            ({ ..current, submenus, }, menu_position_submenus_cmd(id + "-root"))
          }
        }
      }
    },
  )
  model.view(model => {
    let scope = dropdown_scope(
      id,
      model,
      emit.map(open => DropdownSetOpen(open)),
      emit.map(index => DropdownSetActive(index)),
      emit.map(value => DropdownToggleChecked(value)),
      emit.map(pair => DropdownSetRadio(pair.0, pair.1)),
      emit.map(value => DropdownSetSubmenu(value)),
    )
    menu_root_surface(
      "dropdown-menu",
      id + "-root",
      model.open,
      attrs,
      style,
      children(scope),
    )
  })
}

///|
#cfg(not(target="js"))
pub fn dropdown_menu(
  id~ : String,
  default_open? : Bool = false,
  default_checked_values? : Array[String] = [],
  default_radio_values? : Array[(String, String)] = [],
  on_open_change? : @cmd.Emit[Bool],
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : (DropdownMenuScope) -> @html.Html,
) -> @rabbita.Val[@html.Html] {
  ignore(on_open_change)
  let scope = dropdown_scope(
    id,
    menu_core_model(default_open, default_checked_values, default_radio_values),
    menu_noop_emit(),
    menu_noop_emit(),
    menu_noop_emit(),
    menu_noop_emit(),
    menu_noop_emit(),
  )
  @rabbita.Val::constant(
    menu_root_surface(
      "dropdown-menu",
      id + "-root",
      default_open,
      attrs,
      style,
      children(scope),
    ),
  )
}

///|
/// Explicit Root spelling matching the compound-component API.
pub fn dropdown_menu_root(
  id~ : String,
  default_open? : Bool = false,
  default_checked_values? : Array[String] = [],
  default_radio_values? : Array[(String, String)] = [],
  on_open_change? : @cmd.Emit[Bool],
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : (DropdownMenuScope) -> @html.Html,
) -> @rabbita.Val[@html.Html] {
  dropdown_menu(
    id~,
    default_open~,
    default_checked_values~,
    default_radio_values~,
    on_open_change?,
    attrs?,
    style~,
    children,
  )
}

///|
/// Zero-DOM Portal adapter for shadcn-compatible compound composition.
/// Native `popover="auto"` promotes Content to the top layer when opened, so
/// no registration, DOM relocation, or build-time portal runtime is required.
pub fn dropdown_menu_portal(children : Array[@html.Html]) -> @html.Html {
  @html.fragment(children)
}

///|
pub fn[C : @html.IsChildren] dropdown_menu_trigger(
  scope : DropdownMenuScope,
  variant? : ButtonVariant = Outline,
  size? : ButtonSize = Default,
  disabled? : Bool = false,
  aria_label? : String,
  on_click? : @cmd.Cmd,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  menu_trigger_button(
    "dropdown-menu-trigger",
    scope.menu,
    variant,
    size,
    disabled,
    aria_label,
    on_click,
    class,
    title,
    attrs,
    style,
    children,
  )
}

///|
pub fn[C : @html.IsChildren] dropdown_menu_content(
  scope : DropdownMenuScope,
  side? : PopupSide = Bottom,
  align? : PopupAlign = Start,
  side_offset? : Int = 4,
  align_offset? : Int = 0,
  aria_label? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  menu_content_surface(
    "dropdown-menu-content",
    scope.menu,
    side,
    align,
    side_offset,
    align_offset,
    aria_label,
    class,
    title,
    attrs,
    style,
    children,
  )
}

///|
pub fn[C : @html.IsChildren] dropdown_menu_group(
  aria_label? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  menu_group_surface(
    "dropdown-menu-group", aria_label, class, title, attrs, style, children,
  )
}

///|
pub fn[C : @html.IsChildren] dropdown_menu_item(
  scope : DropdownMenuScope,
  disabled? : Bool = false,
  inset? : Bool = false,
  destructive? : Bool = false,
  close_on_select? : Bool = true,
  on_select? : @cmd.Cmd,
  aria_label? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  menu_item_surface(
    "dropdown-menu-item",
    scope.menu,
    "menuitem",
    None,
    MenuIndicatorInlineStart,
    disabled,
    inset,
    destructive,
    None,
    close_on_select,
    None,
    on_select,
    aria_label,
    class,
    title,
    attrs,
    style,
    children,
  )
}

///|
pub fn[C : @html.IsChildren] dropdown_menu_checkbox_item(
  scope : DropdownMenuScope,
  value~ : String,
  disabled? : Bool = false,
  close_on_select? : Bool = false,
  on_checked_change? : @cmd.Emit[Bool],
  on_select? : @cmd.Cmd,
  aria_label? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let checked = menu_contains(scope.menu.model.checked, value)
  let notify = if on_checked_change is Some(notify) {
    notify(!checked)
  } else {
    @cmd.none
  }
  menu_item_surface(
    "dropdown-menu-checkbox-item",
    scope.menu,
    "menuitemcheckbox",
    Some(checked),
    MenuIndicatorInlineEnd,
    disabled,
    false,
    false,
    None,
    close_on_select,
    Some(@cmd.batch([notify, (scope.menu.toggle_checked)(value)])),
    on_select,
    aria_label,
    class,
    title,
    attrs,
    style,
    children,
  )
}

///|
pub fn[C : @html.IsChildren] dropdown_menu_radio_group(
  scope : DropdownMenuScope,
  value~ : String,
  aria_label? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : (DropdownMenuRadioGroupScope) -> C,
) -> @html.Html {
  menu_group_surface(
    "dropdown-menu-radio-group",
    aria_label,
    class,
    title,
    attrs,
    style,
    children({ menu: scope.menu, group: value }),
  )
}

///|
pub fn[C : @html.IsChildren] dropdown_menu_radio_item(
  scope : DropdownMenuRadioGroupScope,
  value~ : String,
  disabled? : Bool = false,
  close_on_select? : Bool = false,
  on_value_change? : @cmd.Emit[String],
  on_select? : @cmd.Cmd,
  aria_label? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let checked = menu_radio_value(scope.menu.model.radios, scope.group) ==
    Some(value)
  let notify = if on_value_change is Some(notify) {
    notify(value)
  } else {
    @cmd.none
  }
  menu_item_surface(
    "dropdown-menu-radio-item",
    scope.menu,
    "menuitemradio",
    Some(checked),
    MenuIndicatorInlineEnd,
    disabled,
    false,
    false,
    None,
    close_on_select,
    Some(@cmd.batch([notify, (scope.menu.set_radio)((scope.group, value))])),
    on_select,
    aria_label,
    class,
    title,
    attrs,
    style,
    children,
  )
}

///|
pub fn[C : @html.IsChildren] dropdown_menu_label(
  inset? : Bool = false,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  menu_label_surface(
    "dropdown-menu-label", inset, class, title, attrs, style, children,
  )
}

///|
pub fn dropdown_menu_separator(
  class? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  menu_separator_surface("dropdown-menu-separator", class, attrs, style)
}

///|
pub fn[C : @html.IsChildren] dropdown_menu_shortcut(
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  menu_shortcut_surface(
    "dropdown-menu-shortcut", class, title, attrs, style, children,
  )
}

///|
pub fn[C : @html.IsChildren] dropdown_menu_sub(
  scope : DropdownMenuScope,
  value~ : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : (DropdownMenuSubScope) -> C,
) -> @html.Html {
  let key = menu_submenu_key(scope.menu, value)
  let open = menu_submenu_open(scope.menu.model.submenus, key)
  menu_sub_root_surface(
    "dropdown-menu-sub",
    open,
    attrs,
    style,
    children({ menu: scope.menu, key }),
  )
}

///|
pub fn[C : @html.IsChildren] dropdown_menu_sub_trigger(
  scope : DropdownMenuSubScope,
  disabled? : Bool = false,
  inset? : Bool = false,
  aria_label? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  menu_item_surface(
    "dropdown-menu-sub-trigger",
    scope.menu,
    "menuitem",
    None,
    MenuIndicatorInlineStart,
    disabled,
    inset,
    false,
    Some(scope.key),
    false,
    None,
    None,
    aria_label,
    class,
    title,
    attrs,
    style,
    children,
  )
}

///|
pub fn[C : @html.IsChildren] dropdown_menu_sub_content(
  scope : DropdownMenuSubScope,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  menu_sub_content_surface(
    "dropdown-menu-sub-content",
    scope.key,
    menu_submenu_open(scope.menu.model.submenus, scope.key),
    class,
    title,
    attrs,
    style,
    children,
  )
}
