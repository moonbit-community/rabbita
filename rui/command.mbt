///|
priv struct CommandModel {
  query : String
  active : Int
} derive(Eq)

///|
priv enum CommandMessage {
  CommandSetQuery(String, Int)
  CommandSetActive(Int)
  CommandSelect(String, @cmd.Cmd)
  CommandReset
}

///|
priv struct CommandEntry {
  value : String
  keywords : Array[String]
  disabled : Bool
  force_mount : Bool
  id : String?
  select_command : @cmd.Cmd
}

///|
/// Opaque state supplied to every compound command part.
///
/// The scope deliberately replaces a global context: query, active option,
/// and filtering stay local to one Rabbita value.
struct CommandScope {
  root_id : String
  model : CommandModel
  catalog : Array[CommandEntry]
  collecting : Bool
  cursor : Ref[Int]
  group_cursor : Ref[Int]
  list_id : Ref[String]
  filter : (String, String, Array[String]) -> Bool
  should_filter : Bool
  dialog : Bool
  emit : @cmd.Emit[CommandMessage]
}

///|
const CommandRootStyle : String = "display:flex;width:100%;min-width:0;flex-direction:column;overflow:hidden;border:0;border-radius:calc(var(--rui-radius,0.625rem) + 0.25rem);background:var(--rui-popover,var(--rui-background,oklch(1 0 0)));color:var(--rui-popover-foreground,var(--rui-foreground,oklch(0.145 0 0)));box-shadow:none;padding:0.25rem"

///|
const CommandDialogRootStyle : String = "border:0;border-radius:inherit;padding:0.25rem;box-shadow:none"

///|
const CommandDialogStyle : String = "position:fixed;inset:0;width:min(calc(100% - 2rem),24rem);max-width:none;max-height:calc(100vh - 2rem);margin:auto;padding:0;overflow-y:auto;border:0;border-radius:calc(var(--rui-radius,0.625rem) + 0.25rem);background:var(--rui-popover,var(--rui-background,oklch(1 0 0)));color:var(--rui-popover-foreground,var(--rui-foreground,oklch(0.145 0 0)));box-shadow:0 0 0 1px color-mix(in oklab,var(--rui-foreground,oklch(0.145 0 0)) 10%,transparent)"

///|
const CommandInputWrapperStyle : String = "display:flex;min-width:0;align-items:center;gap:0.5rem;padding-inline:0.5rem;height:2rem;margin:0.25rem 0.25rem 0;border:1px solid color-mix(in oklab,var(--rui-input,oklch(0.922 0 0)) 30%,transparent);border-radius:var(--rui-radius,0.625rem);background:color-mix(in oklab,var(--rui-input,oklch(0.922 0 0)) 30%,transparent)"

///|
const CommandInputStyle : String = "width:100%;min-width:0;height:100%;border:0;background:transparent;padding:0;color:inherit;font-size:0.875rem;line-height:1.25rem;outline:none;appearance:none;-webkit-appearance:none"

///|
const CommandListStyle : String = "min-height:0;max-height:18rem;overflow-x:hidden;overflow-y:auto;padding:0;scroll-padding-block:0.25rem"

///|
const CommandEmptyStyle : String = "padding:1.5rem 0.75rem;color:var(--rui-muted-foreground,oklch(0.556 0 0));font-size:0.875rem;line-height:1.25rem;text-align:center"

///|
const CommandGroupStyle : String = "min-width:0;padding:0.25rem"

///|
const CommandGroupHeadingStyle : String = "padding:0.375rem 0.5rem;color:var(--rui-muted-foreground,oklch(0.556 0 0));font-size:0.75rem;line-height:1rem;font-weight:500"

///|
const CommandItemStyle : String = "position:relative;display:flex;width:100%;min-width:0;min-height:2rem;align-items:center;gap:0.5rem;border-radius:var(--rui-command-item-radius,calc(var(--rui-radius,0.625rem) - 0.25rem));background:var(--rui-menu-item-bg,var(--rui-menu-item-base-bg,transparent));padding:0.375rem 0.5rem;color:var(--rui-menu-item-fg,var(--rui-menu-item-base-fg,inherit));font-size:0.875rem;line-height:1.25rem;text-align:start;outline:none;cursor:default;user-select:none"

///|
const CommandItemActiveStyle : String = "--rui-menu-item-base-bg:var(--rui-accent,oklch(0.97 0 0));--rui-menu-item-base-fg:var(--rui-accent-foreground,var(--rui-foreground,oklch(0.145 0 0)))"

///|
const CommandSeparatorStyle : String = "height:1px;margin:0 -0.25rem;background:var(--rui-border,oklch(0.922 0 0));pointer-events:none"

///|
const CommandShortcutStyle : String = "margin-inline-start:auto;color:var(--rui-muted-foreground,oklch(0.556 0 0));font-size:0.75rem;line-height:1rem;letter-spacing:0.08em"

///|
fn command_default_filter(
  query : String,
  value : String,
  keywords : Array[String],
) -> Bool {
  if query == "" {
    return true
  }
  let needle = query.to_lower()
  if value.to_lower().contains(needle) {
    return true
  }
  for keyword in keywords {
    if keyword.to_lower().contains(needle) {
      return true
    }
  }
  false
}

///|
fn command_entry_matches(
  entry : CommandEntry,
  query : String,
  should_filter : Bool,
  filter : (String, String, Array[String]) -> Bool,
) -> Bool {
  entry.force_mount ||
  !should_filter ||
  filter(query, entry.value, entry.keywords)
}

///|
fn command_match_count(scope : CommandScope) -> Int {
  let mut count = 0
  for entry in scope.catalog {
    if command_entry_matches(
        entry,
        scope.model.query,
        scope.should_filter,
        scope.filter,
      ) {
      count += 1
    }
  }
  count
}

///|
fn command_entry_enabled(scope : CommandScope, index : Int) -> Bool {
  index >= 0 &&
  index < scope.catalog.length() &&
  !scope.catalog[index].disabled &&
  command_entry_matches(
    scope.catalog[index],
    scope.model.query,
    scope.should_filter,
    scope.filter,
  )
}

///|
fn command_first_match(
  catalog : Array[CommandEntry],
  query : String,
  reverse : Bool,
  should_filter : Bool,
  filter : (String, String, Array[String]) -> Bool,
) -> Int {
  if reverse {
    let mut index = catalog.length() - 1
    while index >= 0 {
      let entry = catalog[index]
      if !entry.disabled &&
        command_entry_matches(entry, query, should_filter, filter) {
        return index
      }
      index -= 1
    }
  } else {
    for index, entry in catalog {
      if !entry.disabled &&
        command_entry_matches(entry, query, should_filter, filter) {
        return index
      }
    }
  }
  -1
}

///|
fn command_next_match(scope : CommandScope, direction : Int) -> Int {
  let length = scope.catalog.length()
  if length == 0 {
    return -1
  }
  let mut index = scope.model.active
  let mut remaining = length
  while remaining > 0 {
    index = if direction < 0 {
      if index <= 0 {
        length - 1
      } else {
        index - 1
      }
    } else if index < 0 || index >= length - 1 {
      0
    } else {
      index + 1
    }
    if command_entry_enabled(scope, index) {
      return index
    }
    remaining -= 1
  }
  -1
}

///|
fn command_item_id(scope : CommandScope, index : Int) -> String {
  if index >= 0 &&
    index < scope.catalog.length() &&
    scope.catalog[index].id is Some(id) {
    id
  } else {
    "\{scope.root_id}-item-\{index}"
  }
}

///|
fn command_input_id(scope : CommandScope) -> String {
  "\{scope.root_id}-input"
}

///|
fn command_list_id(scope : CommandScope) -> String {
  scope.list_id.val
}

///|
fn command_notify_string(
  notify : @cmd.Emit[String]?,
  value : String,
) -> @cmd.Cmd {
  if notify is Some(notify) {
    notify(value)
  } else {
    @cmd.none
  }
}

///|
#cfg(target="js")
fn command_scroll_active_now(root_id : String, index : Int) -> Unit {
  guard ui_element_by_id(root_id) is Some(root) else { return }
  guard root.query_selector("[data-command-index=\"\{index}\"]") is Some(option) else {
    return
  }
  option.scroll_into_view_with_options(block="nearest")
}

///|
#cfg(target="js")
fn command_scroll_active(root_id : String, index : Int) -> @cmd.Cmd {
  if index < 0 {
    return @cmd.none
  }
  @cmd.custom_cmd(kind=@cmd.after_render, _ => {
    command_scroll_active_now(root_id, index)
  })
}

///|
#cfg(not(target="js"))
fn command_scroll_active(root_id : String, index : Int) -> @cmd.Cmd {
  ignore((root_id, index))
  @cmd.none
}

///|
#cfg(target="js")
fn command_keyboard_attrs(
  scope : CommandScope,
  attrs : @html.Attrs?,
) -> @html.Attrs {
  let root_attrs = ui_attrs(attrs)
    .data_set("slot", "command")
    .data_set("filtered-count", "\{command_match_count(scope)}")
  ignore(
    root_attrs.on_keydown(event => {
      if event.alt_key() ||
        event.ctrl_key() ||
        event.meta_key() ||
        event.is_composing() {
        return @cmd.none
      }
      let key = event.key()
      if key == "ArrowDown" {
        event.prevent_default()
        (scope.emit)(CommandSetActive(command_next_match(scope, 1)))
      } else if key == "ArrowUp" {
        event.prevent_default()
        (scope.emit)(CommandSetActive(command_next_match(scope, -1)))
      } else if key == "Home" {
        event.prevent_default()
        (scope.emit)(
          CommandSetActive(
            command_first_match(
              scope.catalog,
              scope.model.query,
              false,
              scope.should_filter,
              scope.filter,
            ),
          ),
        )
      } else if key == "End" {
        event.prevent_default()
        (scope.emit)(
          CommandSetActive(
            command_first_match(
              scope.catalog,
              scope.model.query,
              true,
              scope.should_filter,
              scope.filter,
            ),
          ),
        )
      } else if key == "Enter" &&
        command_entry_enabled(scope, scope.model.active) {
        event.prevent_default()
        let entry = scope.catalog[scope.model.active]
        (scope.emit)(CommandSelect(entry.value, entry.select_command))
      } else if key == "Escape" && !scope.dialog && scope.model.query != "" {
        event.prevent_default()
        (scope.emit)(
          CommandSetQuery(
            "",
            command_first_match(
              scope.catalog,
              "",
              false,
              scope.should_filter,
              scope.filter,
            ),
          ),
        )
      } else {
        @cmd.none
      }
    }),
  )
  root_attrs
}

///|
#cfg(not(target="js"))
fn command_keyboard_attrs(
  scope : CommandScope,
  attrs : @html.Attrs?,
) -> @html.Attrs {
  ui_attrs(attrs)
  .data_set("slot", "command")
  .data_set("filtered-count", "\{command_match_count(scope)}")
}

///|
#cfg(not(target="js"))
fn command_noop_emit() -> @cmd.Emit[CommandMessage] {
  @cmd.Emit(_ => @cmd.none)
}

///|
fn command_scope(
  root_id : String,
  model : CommandModel,
  catalog : Array[CommandEntry],
  collecting : Bool,
  filter : (String, String, Array[String]) -> Bool,
  should_filter : Bool,
  dialog : Bool,
  emit : @cmd.Emit[CommandMessage],
  list_id : Ref[String],
) -> CommandScope {
  {
    root_id,
    model,
    catalog,
    collecting,
    cursor: Ref(0),
    group_cursor: Ref(0),
    list_id,
    filter,
    should_filter,
    dialog,
    emit,
  }
}

///|
fn command_effective_model(
  model : CommandModel,
  catalog : Array[CommandEntry],
  should_filter : Bool,
  filter : (String, String, Array[String]) -> Bool,
) -> CommandModel {
  let active = if model.active >= 0 &&
    model.active < catalog.length() &&
    !catalog[model.active].disabled &&
    command_entry_matches(
      catalog[model.active],
      model.query,
      should_filter,
      filter,
    ) {
    model.active
  } else {
    command_first_match(catalog, model.query, false, should_filter, filter)
  }
  { ..model, active, }
}

///|
fn command_surface(
  root_id : String,
  model : CommandModel,
  filter : (String, String, Array[String]) -> Bool,
  should_filter : Bool,
  dialog : Bool,
  emit : @cmd.Emit[CommandMessage],
  class : String?,
  title : String?,
  attrs : @html.Attrs?,
  style : Array[String],
  children : (CommandScope) -> @html.Html,
) -> @html.Html {
  // The first pure pass records item metadata. The second pass can therefore
  // render CommandEmpty and aria-activedescendant correctly regardless of the
  // order in which compound parts appear.
  let catalog : Array[CommandEntry] = []
  let list_id = Ref("\{root_id}-list")
  let collecting_scope = command_scope(
    root_id, model, catalog, true, filter, should_filter, dialog, emit, list_id,
  )
  ignore(children(collecting_scope))
  let effective_model = command_effective_model(
    model, catalog, should_filter, filter,
  )
  let scope = command_scope(
    root_id, effective_model, catalog, false, filter, should_filter, dialog, emit,
    list_id,
  )
  let content = children(scope)
  let root_styles = if dialog {
    [
      UiBoxSizing,
      UiFontSans,
      UiTextRendering,
      CommandRootStyle,
      CommandDialogRootStyle,
    ]
  } else {
    [UiBoxSizing, UiFontSans, UiTextRendering, CommandRootStyle]
  }
  @html.div(
    style=ui_styles(root_styles, style),
    id=root_id,
    class?,
    title?,
    attrs=command_keyboard_attrs(scope, attrs),
    content,
  )
}

///|
/// Read the current normalized query without exposing the scope representation.
pub fn command_query(scope : CommandScope) -> String {
  scope.model.query
}

///|
/// Render the ARIA combobox input that owns focus while options use
/// `aria-activedescendant`.
pub fn command_input(
  scope~ : CommandScope,
  placeholder? : String = "Type a command or search...",
  aria_label? : String = "Search commands",
  auto_complete? : @html.AutoComplete = Off,
  disabled? : Bool = false,
  on_input? : @cmd.Emit[String],
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  input_style? : Array[String] = [],
) -> @html.Html {
  if scope.collecting {
    return @html.nothing
  }
  let input_attrs = ui_attrs(attrs)
    .data_set("slot", "command-input")
    .role("combobox")
    .aria_label(aria_label)
    .aria_autocomplete("list")
    .aria_expanded("true")
    .aria_controls(command_list_id(scope))
  if scope.model.active >= 0 {
    ignore(
      input_attrs.aria_activedescendant(
        command_item_id(scope, scope.model.active),
      ),
    )
  }
  if disabled {
    ignore(input_attrs.disabled(true).aria_disabled("true"))
  }
  let set_query = @cmd.Emit(query => {
    let active = command_first_match(
      scope.catalog,
      query,
      false,
      scope.should_filter,
      scope.filter,
    )
    @cmd.batch([
      if on_input is Some(notify) {
        notify(query)
      } else {
        @cmd.none
      },
      (scope.emit)(CommandSetQuery(query, active)),
    ])
  })
  @html.div(
    style=ui_styles([UiBoxSizing, CommandInputWrapperStyle], style),
    attrs=@html.Attrs::build().data_set("slot", "command-input-wrapper"),
    [
      @html.span(
        style=[
          UiBoxSizing,
          "display:inline-flex;width:1rem;height:1rem;flex:none;align-items:center;justify-content:center;color:var(--rui-muted-foreground,oklch(0.556 0 0));font-size:1rem",
        ],
        attrs=@html.Attrs::build()
          .data_set("slot", "command-input-icon")
          .aria_hidden("true"),
        ui_search_icon(),
      ),
      @html.input(
        input_type=Text,
        value=scope.model.query,
        placeholder~,
        auto_complete~,
        style=ui_styles(
          [
            UiBoxSizing,
            UiFontSans,
            UiTextRendering,
            CommandInputStyle,
            ui_disabled_style(disabled),
          ],
          input_style,
        ),
        id=id.unwrap_or(command_input_id(scope)),
        class?,
        title?,
        on_input=set_query,
        attrs=input_attrs,
      ),
    ],
  )
}

///|
pub fn[C : @html.IsChildren] command_list(
  scope~ : CommandScope,
  aria_label? : String = "Commands",
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  if scope.collecting {
    scope.list_id.val = id.unwrap_or("\{scope.root_id}-list")
    return @html.nothing
  }
  @html.div(
    style=ui_styles([UiBoxSizing, CommandListStyle], style),
    id=id.unwrap_or(command_list_id(scope)),
    class?,
    title?,
    attrs=ui_attrs(attrs)
      .data_set("slot", "command-list")
      .data_set("count", "\{command_match_count(scope)}")
      .role("listbox")
      .aria_label(aria_label),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] command_empty(
  scope~ : CommandScope,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  if scope.collecting {
    return @html.nothing
  }
  let visible = command_match_count(scope) == 0
  @html.div(
    style=ui_styles(
      [
        UiBoxSizing,
        CommandEmptyStyle,
        if visible {
          ""
        } else {
          "display:none"
        },
      ],
      style,
    ),
    id?,
    class?,
    title?,
    hidden=!visible,
    attrs=ui_attrs(attrs)
      .data_set("slot", "command-empty")
      .data_set("state", if visible { "visible" } else { "hidden" })
      .role("status")
      .aria_live("polite"),
    children,
  )
}

///|
pub fn[C : @html.IsChildren] command_group(
  scope~ : CommandScope,
  heading? : String,
  heading_id? : String,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  heading_style? : Array[String] = [],
  children : C,
) -> @html.Html {
  if scope.collecting {
    return @html.nothing
  }
  let group_index = scope.group_cursor.val
  scope.group_cursor.val += 1
  let resolved_heading_id = heading_id.unwrap_or(
    "\{scope.root_id}-group-\{group_index}-heading",
  )
  let group_attrs = ui_attrs(attrs)
    .data_set("slot", "command-group")
    .role("group")
  if heading is Some(_) {
    ignore(group_attrs.aria_labelledby(resolved_heading_id))
  }
  @html.div(
    style=ui_styles([UiBoxSizing, CommandGroupStyle], style),
    id?,
    class?,
    title?,
    attrs=group_attrs,
    [
      if heading is Some(heading) {
        @html.div(
          style=ui_styles(
            [UiBoxSizing, CommandGroupHeadingStyle],
            heading_style,
          ),
          id=resolved_heading_id,
          attrs=@html.Attrs::build().data_set("slot", "command-group-heading"),
          heading,
        )
      } else {
        @html.nothing
      },
      @html.div(
        style=[UiBoxSizing, "display:contents"],
        attrs=@html.Attrs::build().data_set("slot", "command-group-items"),
        children,
      ),
    ],
  )
}

///|
pub fn command_separator(
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  @html.div(
    style=ui_styles([UiBoxSizing, CommandSeparatorStyle], style),
    id?,
    class?,
    title?,
    attrs=ui_attrs(attrs)
      .data_set("slot", "command-separator")
      .role("separator")
      .aria_orientation("horizontal"),
    @html.nothing,
  )
}

///|
pub fn[C : @html.IsChildren] command_item(
  scope~ : CommandScope,
  value~ : String,
  keywords? : Array[String] = [],
  disabled? : Bool = false,
  force_mount? : Bool = false,
  on_select? : @cmd.Emit[String],
  on_click? : @cmd.Cmd,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let commands : Array[@cmd.Cmd] = []
  if on_click is Some(command) {
    commands.push(command)
  }
  if on_select is Some(notify) {
    commands.push(notify(value))
  }
  let entry : CommandEntry = {
    value,
    keywords,
    disabled,
    force_mount,
    id,
    select_command: @cmd.batch(commands),
  }
  if scope.collecting {
    scope.catalog.push(entry)
    return @html.nothing
  }
  let index = scope.cursor.val
  scope.cursor.val += 1
  let visible = command_entry_matches(
    entry,
    scope.model.query,
    scope.should_filter,
    scope.filter,
  )
  let active = visible && !disabled && scope.model.active == index
  let item_attrs = ui_attrs(attrs)
    .data_set("slot", "command-item")
    .data_set("value", value)
    .data_set("keywords", keywords.join(" "))
    .data_set("command-index", "\{index}")
    .data_set("state", if active { "active" } else { "inactive" })
    .data_set("selected", ui_bool(active))
    .role("option")
    .aria_selected(ui_bool(active))
    .aria_disabled(ui_bool(disabled))
    .tabindex(-1)
  if disabled {
    ignore(item_attrs.data_set("disabled", ""))
  } else if visible {
    ignore(
      item_attrs
      .on_click(_ => (scope.emit)(CommandSelect(value, entry.select_command)))
      .on_mouseenter(_ => (scope.emit)(CommandSetActive(index))),
    )
  }
  @html.div(
    style=ui_styles(
      [
        UiBoxSizing,
        UiFontSans,
        UiTransition,
        CommandItemStyle,
        if active {
          CommandItemActiveStyle
        } else {
          ""
        },
        if visible {
          ""
        } else {
          "display:none"
        },
        ui_disabled_visual_style(disabled),
      ],
      style,
    ),
    id=id.unwrap_or(command_item_id(scope, index)),
    class?,
    title?,
    hidden=!visible,
    attrs=item_attrs,
    children,
  )
}

///|
pub fn[C : @html.IsChildren] command_shortcut(
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  @html.span(
    style=ui_styles([UiBoxSizing, CommandShortcutStyle], style),
    id?,
    class?,
    title?,
    attrs=ui_attrs(attrs).data_set("slot", "command-shortcut"),
    children,
  )
}

///|
#cfg(target="js")
fn command_update(
  root_id : String,
  close_dialog : String?,
  on_value_select : @cmd.Emit[String]?,
  on_query_change : @cmd.Emit[String]?,
  message : CommandMessage,
  current : CommandModel,
) -> (CommandModel, @cmd.Cmd) {
  match message {
    CommandSetQuery(query, active) =>
      (
        { query, active, },
        @cmd.batch([
          command_notify_string(on_query_change, query),
          command_scroll_active(root_id, active),
        ]),
      )
    CommandSetActive(active) =>
      ({ ..current, active, }, command_scroll_active(root_id, active))
    CommandSelect(value, item_command) =>
      (
        current,
        @cmd.batch([
          command_notify_string(on_value_select, value),
          item_command,
          if close_dialog is Some(id) {
            @dialog.close(id)
          } else {
            @cmd.none
          },
        ]),
      )
    CommandReset =>
      (
        { query: "", active: -1, },
        if current.query != "" {
          command_notify_string(on_query_change, "")
        } else {
          @cmd.none
        },
      )
  }
}

///|
/// Create an inline command box with Rabbita-owned query,
/// filtering, and active-option state.
#cfg(target="js")
pub fn command_box(
  id~ : String,
  default_query? : String = "",
  should_filter? : Bool = true,
  filter? : (String, String, Array[String]) -> Bool,
  on_value_select? : @cmd.Emit[String],
  on_query_change? : @cmd.Emit[String],
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : (CommandScope) -> @html.Html,
) -> @rabbita.Val[@html.Html] {
  let matcher = filter.unwrap_or(command_default_filter)
  let initial : CommandModel = { query: default_query, active: -1, }
  let (model, emit) = @rabbita.create_state(initial, update=fn(
    current,
    message,
    _,
  ) {
    command_update(id, None, on_value_select, on_query_change, message, current)
  })
  model.view(model => {
    command_surface(
      id, model, matcher, should_filter, false, emit, class, title, attrs, style,
      children,
    )
  })
}

///|
#cfg(not(target="js"))
pub fn command_box(
  id~ : String,
  default_query? : String = "",
  should_filter? : Bool = true,
  filter? : (String, String, Array[String]) -> Bool,
  on_value_select? : @cmd.Emit[String],
  on_query_change? : @cmd.Emit[String],
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : (CommandScope) -> @html.Html,
) -> @rabbita.Val[@html.Html] {
  ignore((on_value_select, on_query_change))
  @rabbita.Val::constant(
    command_surface(
      id,
      { query: default_query, active: -1, },
      filter.unwrap_or(command_default_filter),
      should_filter,
      false,
      command_noop_emit(),
      class,
      title,
      attrs,
      style,
      children,
    ),
  )
}

///|
/// Render a command palette inside a native dialog. Only the query and
/// active option are stateful; the browser owns visibility and focus.
///
/// Open it from an ordinary button with `@rabbita/dialog.show(id)` and close
/// it with a `<form method="dialog">` or `@rabbita/dialog.close(id)`.
/// Closing resets the query and active option. Selecting an item also closes
/// the dialog unless `close_on_select=false`.
/// `open=true` renders an initially open, non-modal dialog. `closedby` and
/// `on_cancel` follow the same native behavior as `@html.dialog`.
#cfg(target="js")
pub fn command_dialog(
  id~ : String,
  default_query? : String = "",
  should_filter? : Bool = true,
  filter? : (String, String, Array[String]) -> Bool,
  close_on_select? : Bool = true,
  open? : Bool,
  closedby? : String = "any",
  aria_label? : String = "Command menu",
  on_value_select? : @cmd.Emit[String],
  on_query_change? : @cmd.Emit[String],
  on_close? : @cmd.Emit[String],
  on_cancel? : @cmd.Cmd,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : (CommandScope) -> @html.Html,
) -> @rabbita.Val[@html.Html] {
  let root_id = "\{id}-command"
  let matcher = filter.unwrap_or(command_default_filter)
  let initial : CommandModel = { query: default_query, active: -1, }
  let (model, emit) = @rabbita.create_state(initial, update=fn(
    current,
    message,
    _,
  ) {
    command_update(
      root_id,
      if close_on_select {
        Some(id)
      } else {
        None
      },
      on_value_select,
      on_query_change,
      message,
      current,
    )
  })
  model.view(model => {
    @html.dialog(
      id~,
      open?,
      closedby~,
      on_close=@cmd.Emit(value => {
        @cmd.batch([emit(CommandReset), command_notify_string(on_close, value)])
      }),
      on_cancel?,
      class?,
      title?,
      attrs=ui_attrs(attrs)
        .data_set("slot", "command-dialog")
        .aria_label(aria_label),
      style=ui_styles([UiBoxSizing, CommandDialogStyle], style),
      command_surface(
        root_id,
        model,
        matcher,
        should_filter,
        true,
        emit,
        None,
        None,
        None,
        [],
        children,
      ),
    )
  })
}

///|
#cfg(not(target="js"))
pub fn command_dialog(
  id~ : String,
  default_query? : String = "",
  should_filter? : Bool = true,
  filter? : (String, String, Array[String]) -> Bool,
  close_on_select? : Bool = true,
  open? : Bool,
  closedby? : String = "any",
  aria_label? : String = "Command menu",
  on_value_select? : @cmd.Emit[String],
  on_query_change? : @cmd.Emit[String],
  on_close? : @cmd.Emit[String],
  on_cancel? : @cmd.Cmd,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : (CommandScope) -> @html.Html,
) -> @rabbita.Val[@html.Html] {
  ignore((close_on_select, on_value_select, on_query_change))
  @rabbita.Val::constant(
    @html.dialog(
      id~,
      open?,
      closedby~,
      on_close?,
      on_cancel?,
      class?,
      title?,
      attrs=ui_attrs(attrs)
        .data_set("slot", "command-dialog")
        .aria_label(aria_label),
      style=ui_styles([UiBoxSizing, CommandDialogStyle], style),
      command_surface(
        "\{id}-command",
        { query: default_query, active: -1, },
        filter.unwrap_or(command_default_filter),
        should_filter,
        true,
        command_noop_emit(),
        None,
        None,
        None,
        [],
        children,
      ),
    ),
  )
}
