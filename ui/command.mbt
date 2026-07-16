///|
priv struct CommandModel {
  query : String
  active : Int
  open : Bool
  generation : Int
} derive(Eq)

///|
priv enum CommandMessage {
  CommandSetQuery(String, Int)
  CommandSetActive(Int)
  CommandSelect(String, @cmd.Cmd)
  CommandOpen
  CommandRequestClose
  CommandFinalizeClose(Int)
  CommandDidClose(String)
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
/// filtering, dialog state, and commands stay local to one Rabbita value.
struct CommandScope {
  root_id : String
  dialog_id : String?
  model : CommandModel
  catalog : Array[CommandEntry]
  collecting : Bool
  cursor : Ref[Int]
  group_cursor : Ref[Int]
  list_id : Ref[String]
  filter : (String, String, Array[String]) -> Bool
  should_filter : Bool
  dialog : Bool
  close_on_escape : Bool
  emit : @cmd.Emit[CommandMessage]
  open_command : @cmd.Cmd
  close_command : @cmd.Cmd
  native_open : Bool?
  native_on_close : @cmd.Emit[String]?
  native_on_cancel : @cmd.Cmd?
}

///|
const CommandRootStyle : String = "display:flex;width:100%;min-width:0;flex-direction:column;overflow:hidden;border:1px solid var(--rui-border,oklch(0.922 0 0));border-radius:var(--rui-radius,0.625rem);background:var(--rui-popover,var(--rui-background,oklch(1 0 0)));color:var(--rui-popover-foreground,var(--rui-foreground,oklch(0.145 0 0)));box-shadow:0 1px 2px rgb(0 0 0 / 0.05)"

///|
const CommandDialogContentStyle : String = "position:relative;width:min(100%,32rem);max-height:calc(100vh - 2rem);overflow:hidden;border:1px solid var(--rui-border,oklch(0.922 0 0));border-radius:var(--rui-radius,0.625rem);background:var(--rui-popover,var(--rui-background,oklch(1 0 0)));color:var(--rui-popover-foreground,var(--rui-foreground,oklch(0.145 0 0)));box-shadow:0 16px 48px rgb(0 0 0 / 0.2);opacity:var(--rui-dialog-content-opacity,1);transform:var(--rui-dialog-content-transform,translateY(0) scale(1));pointer-events:auto;transition:opacity 200ms ease,transform 200ms ease"

///|
const CommandInputWrapperStyle : String = "display:flex;min-width:0;align-items:center;gap:0.625rem;border-bottom:1px solid var(--rui-border,oklch(0.922 0 0));padding-inline:0.75rem"

///|
const CommandInputStyle : String = "width:100%;min-width:0;height:3rem;border:0;background:transparent;padding:0;color:inherit;font-size:0.875rem;line-height:1.25rem;outline:none;appearance:none;-webkit-appearance:none"

///|
const CommandListStyle : String = "min-height:0;max-height:18.75rem;overflow-x:hidden;overflow-y:auto;padding:0.25rem"

///|
const CommandEmptyStyle : String = "padding:1.5rem 0.75rem;color:var(--rui-muted-foreground,oklch(0.556 0 0));font-size:0.875rem;line-height:1.25rem;text-align:center"

///|
const CommandGroupStyle : String = "min-width:0;padding:0.25rem"

///|
const CommandGroupHeadingStyle : String = "padding:0.375rem 0.5rem;color:var(--rui-muted-foreground,oklch(0.556 0 0));font-size:0.75rem;line-height:1rem;font-weight:500"

///|
const CommandItemStyle : String = "position:relative;display:flex;width:100%;min-width:0;min-height:2rem;align-items:center;gap:0.5rem;border-radius:calc(var(--rui-radius,0.625rem) - 0.25rem);background:var(--rui-menu-item-bg,var(--rui-menu-item-base-bg,transparent));padding:0.375rem 0.5rem;color:var(--rui-menu-item-fg,var(--rui-menu-item-base-fg,inherit));font-size:0.875rem;line-height:1.25rem;text-align:start;outline:none;cursor:default;user-select:none"

///|
const CommandItemActiveStyle : String = "--rui-menu-item-base-bg:var(--rui-accent,oklch(0.97 0 0));--rui-menu-item-base-fg:var(--rui-accent-foreground,var(--rui-foreground,oklch(0.145 0 0)))"

///|
const CommandSeparatorStyle : String = "height:1px;margin:0.25rem -0.25rem;background:var(--rui-border,oklch(0.922 0 0));pointer-events:none"

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
fn command_notify_bool(notify : @cmd.Emit[Bool]?, value : Bool) -> @cmd.Cmd {
  if notify is Some(notify) {
    notify(value)
  } else {
    @cmd.none
  }
}

///|
#cfg(target="js")
extern "js" fn ffi_command_scroll_active(root_id : String, index : Int) -> Unit =
  #| (rootId, index) => {
  #|   const root = document.getElementById(rootId)
  #|   const option = root?.querySelector(`[data-command-index="${index}"]`)
  #|   option?.scrollIntoView?.({ block: "nearest" })
  #| }

///|
#cfg(target="js")
fn command_scroll_active(root_id : String, index : Int) -> @cmd.Cmd {
  if index < 0 {
    return @cmd.none
  }
  @cmd.custom_cmd(kind=@cmd.after_render, _ => {
    ffi_command_scroll_active(root_id, index)
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
    .data_set("state", if scope.model.open { "open" } else { "closed" })
    .data_set("filtered-count", "\{command_match_count(scope)}")
  ignore(
    root_attrs.on_keydown_after(event => {
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
      } else if key == "Escape" && scope.dialog && scope.close_on_escape {
        event.prevent_default()
        scope.close_command
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
  .data_set("state", if scope.model.open { "open" } else { "closed" })
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
  dialog_id : String?,
  model : CommandModel,
  catalog : Array[CommandEntry],
  collecting : Bool,
  filter : (String, String, Array[String]) -> Bool,
  should_filter : Bool,
  dialog : Bool,
  close_on_escape : Bool,
  emit : @cmd.Emit[CommandMessage],
  native_open : Bool?,
  native_on_close : @cmd.Emit[String]?,
  native_on_cancel : @cmd.Cmd?,
  list_id : Ref[String],
) -> CommandScope {
  {
    root_id,
    dialog_id,
    model,
    catalog,
    collecting,
    cursor: Ref(0),
    group_cursor: Ref(0),
    list_id,
    filter,
    should_filter,
    dialog,
    close_on_escape,
    emit,
    open_command: emit(CommandOpen),
    close_command: emit(CommandRequestClose),
    native_open,
    native_on_close,
    native_on_cancel,
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
  dialog_id : String?,
  model : CommandModel,
  filter : (String, String, Array[String]) -> Bool,
  should_filter : Bool,
  dialog : Bool,
  close_on_escape : Bool,
  emit : @cmd.Emit[CommandMessage],
  native_open : Bool?,
  native_on_close : @cmd.Emit[String]?,
  native_on_cancel : @cmd.Cmd?,
  class : String?,
  title : String?,
  attrs : @html.Attrs?,
  style : Array[String],
  children : (CommandScope) -> @html.Html,
) -> (@html.Html, CommandScope) {
  // The first pure pass records item metadata. The second pass can therefore
  // render CommandEmpty and aria-activedescendant correctly regardless of the
  // order in which compound parts appear.
  let catalog : Array[CommandEntry] = []
  let list_id = Ref("\{root_id}-list")
  let collecting_scope = command_scope(
    root_id, dialog_id, model, catalog, true, filter, should_filter, dialog, close_on_escape,
    emit, native_open, native_on_close, native_on_cancel, list_id,
  )
  ignore(children(collecting_scope))
  let effective_model = command_effective_model(
    model, catalog, should_filter, filter,
  )
  let scope = command_scope(
    root_id, dialog_id, effective_model, catalog, false, filter, should_filter, dialog,
    close_on_escape, emit, native_open, native_on_close, native_on_cancel, list_id,
  )
  let content = children(scope)
  let html = @html.div(
    style=ui_styles(
      [UiBoxSizing, UiFontSans, UiTextRendering, CommandRootStyle],
      style,
    ),
    id=root_id,
    class?,
    title?,
    attrs=command_keyboard_attrs(scope, attrs),
    content,
  )
  (html, scope)
}

///|
/// Read the current normalized query without exposing the scope representation.
pub fn command_query(scope : CommandScope) -> String {
  scope.model.query
}

///|
pub fn command_is_open(scope : CommandScope) -> Bool {
  scope.model.open
}

///|
/// Return commands for custom dialog triggers or dismiss controls.
pub fn command_open(scope : CommandScope) -> @cmd.Cmd {
  scope.open_command
}

///|
pub fn command_close(scope : CommandScope) -> @cmd.Cmd {
  scope.close_command
}

///|
/// Render the ARIA combobox input that owns focus while options use
/// `aria-activedescendant`.
pub fn command_input(
  scope~ : CommandScope,
  placeholder? : String = "Type a command or search...",
  aria_label? : String = "Search commands",
  auto_complete? : @html.AutoComplete = @html.Off,
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
    .aria_expanded(ui_bool(if scope.dialog { scope.model.open } else { true }))
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
        input_type=@html.Text,
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
      .on_click_after(_ => {
        (scope.emit)(CommandSelect(value, entry.select_command))
      })
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
  emit : @cmd.Emit[CommandMessage],
  root_id : String,
  dialog_id : String?,
  dialog : Bool,
  close_on_select : Bool,
  on_value_select : @cmd.Emit[String]?,
  on_query_change : @cmd.Emit[String]?,
  on_open_change : @cmd.Emit[Bool]?,
  on_close : @cmd.Emit[String]?,
  message : CommandMessage,
  current : CommandModel,
) -> (CommandModel, @cmd.Cmd) {
  match message {
    CommandSetQuery(query, active) =>
      (
        { ..current, query, active },
        @cmd.batch([
          command_notify_string(on_query_change, query),
          command_scroll_active(root_id, active),
        ]),
      )
    CommandSetActive(active) =>
      ({ ..current, active, }, command_scroll_active(root_id, active))
    CommandSelect(value, item_command) => {
      let selection = @cmd.batch([
        command_notify_string(on_value_select, value),
        item_command,
      ])
      if dialog && close_on_select && current.open && dialog_id is Some(_) {
        let generation = current.generation + 1
        (
          { query: "", active: -1, open: false, generation },
          @cmd.batch([
            selection,
            command_notify_string(on_query_change, ""),
            command_notify_bool(on_open_change, false),
            @rabbita.delay(
              emit(CommandFinalizeClose(generation)),
              DialogExitDurationMs,
            ),
          ]),
        )
      } else {
        (current, selection)
      }
    }
    CommandOpen =>
      if !dialog || current.open {
        (current, @cmd.none)
      } else if dialog_id is Some(id) {
        (
          {
            query: "",
            active: -1,
            open: true,
            generation: current.generation + 1,
          },
          @cmd.batch([
            ui_dialog_show(id, true),
            command_notify_bool(on_open_change, true),
          ]),
        )
      } else {
        (current, @cmd.none)
      }
    CommandRequestClose =>
      if dialog && current.open && dialog_id is Some(_) {
        let generation = current.generation + 1
        (
          { ..current, open: false, generation },
          @cmd.batch([
            command_notify_bool(on_open_change, false),
            @rabbita.delay(
              emit(CommandFinalizeClose(generation)),
              DialogExitDurationMs,
            ),
          ]),
        )
      } else if !dialog && current.query != "" {
        (
          { ..current, query: "", active: -1 },
          command_notify_string(on_query_change, ""),
        )
      } else {
        (current, @cmd.none)
      }
    CommandFinalizeClose(generation) =>
      if dialog &&
        !current.open &&
        current.generation == generation &&
        dialog_id is Some(id) {
        (current, ui_dialog_close(id))
      } else {
        (current, @cmd.none)
      }
    CommandDidClose(value) =>
      if dialog {
        (
          {
            query: "",
            active: -1,
            open: false,
            generation: current.generation + 1,
          },
          @cmd.batch([
            if current.open {
              command_notify_bool(on_open_change, false)
            } else {
              @cmd.none
            },
            command_notify_string(on_close, value),
          ]),
        )
      } else {
        (current, @cmd.none)
      }
  }
}

///|
/// Create a self-contained command palette with Rabbita-owned query,
/// filtering, and active-option state.
#cfg(target="js")
pub fn command(
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
  let initial : CommandModel = {
    query: default_query,
    active: -1,
    open: true,
    generation: 0,
  }
  let (model, emit) = @rabbita.create_state(initial, update=fn(
    emit,
    message,
    current,
  ) {
    command_update(
      emit,
      id,
      None,
      false,
      false,
      on_value_select,
      on_query_change,
      None,
      None,
      message,
      current,
    )
  })
  model.view(model => {
    command_surface(
      id,
      None,
      model,
      matcher,
      should_filter,
      false,
      true,
      emit,
      None,
      None,
      None,
      class,
      title,
      attrs,
      style,
      children,
    ).0
  })
}

///|
#cfg(not(target="js"))
pub fn command(
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
  let matcher = filter.unwrap_or(command_default_filter)
  @rabbita.Val::constant(
    command_surface(
      id,
      None,
      { query: default_query, active: -1, open: true, generation: 0 },
      matcher,
      should_filter,
      false,
      true,
      command_noop_emit(),
      None,
      None,
      None,
      class,
      title,
      attrs,
      style,
      children,
    ).0,
  )
}

///|
/// Default trigger for a CommandDialog. Supply it through the dialog's
/// `trigger` callback so it remains outside the native dialog top layer.
pub fn[C : @html.IsChildren] command_dialog_trigger(
  scope~ : CommandScope,
  variant? : ButtonVariant = Outline,
  size? : ButtonSize = Default,
  disabled? : Bool = false,
  id? : String,
  class? : String,
  title? : String,
  aria_label? : String,
  on_click? : @cmd.Cmd,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let trigger_attrs = ui_attrs(attrs)
    .data_set("slot", "command-dialog-trigger")
    .data_set("state", if scope.model.open { "open" } else { "closed" })
    .aria_haspopup("dialog")
    .aria_expanded(ui_bool(scope.model.open))
  if scope.dialog_id is Some(dialog_id) {
    ignore(trigger_attrs.aria_controls(dialog_id))
  }
  dialog_control_button(
    slot="command-dialog-trigger",
    command=scope.open_command,
    variant~,
    size~,
    disabled~,
    id~,
    class~,
    title~,
    aria_label~,
    on_click~,
    attrs=Some(trigger_attrs),
    style~,
    children,
  )
}

///|
fn command_dialog_view(
  dialog_id : String,
  model : CommandModel,
  filter : (String, String, Array[String]) -> Bool,
  should_filter : Bool,
  close_on_escape : Bool,
  emit : @cmd.Emit[CommandMessage],
  native_open : Bool?,
  native_on_close : @cmd.Emit[String]?,
  native_on_cancel : @cmd.Cmd?,
  aria_label : String,
  close_on_overlay : Bool,
  class : String?,
  title : String?,
  attrs : @html.Attrs?,
  style : Array[String],
  overlay_attrs : @html.Attrs?,
  overlay_style : Array[String],
  native_attrs : @html.Attrs?,
  native_style : Array[String],
  trigger : ((CommandScope) -> @html.Html)?,
  children : (CommandScope) -> @html.Html,
) -> @html.Html {
  let root_id = "\{dialog_id}-command"
  let surface_result = command_surface(
    root_id,
    Some(dialog_id),
    model,
    filter,
    should_filter,
    true,
    close_on_escape,
    emit,
    native_open,
    native_on_close,
    native_on_cancel,
    class,
    title,
    attrs,
    style,
    children,
  )
  let surface = surface_result.0
  let scope = surface_result.1
  let native_element_attrs = dialog_state_attrs(
      native_attrs,
      "command-dialog-native",
      model.open,
    )
    .aria_modal("true")
    .aria_label(aria_label)
  let overlay_element_attrs = dialog_state_attrs(
    overlay_attrs,
    "command-dialog-overlay",
    model.open,
  )
  if close_on_overlay {
    ignore(
      overlay_element_attrs.on_click_after(_ => {
        if ui_dialog_should_close_outside() {
          scope.close_command
        } else {
          @cmd.none
        }
      }),
    )
  }
  let positioner_attrs = dialog_state_attrs(
    None,
    "command-dialog-positioner",
    model.open,
  )
  let content_attrs = dialog_state_attrs(
    None,
    "command-dialog-content",
    model.open,
  )
  let closedby = if close_on_overlay {
    "any"
  } else if close_on_escape {
    "closerequest"
  } else {
    "none"
  }
  let open = scope.native_open
  let on_close = scope.native_on_close
  let on_cancel = scope.native_on_cancel
  @html.fragment([
    if trigger is Some(render_trigger) {
      render_trigger(scope)
    } else {
      @html.nothing
    },
    @html.dialog(
      style=ui_styles([UiBoxSizing, DialogNativeStyle], native_style),
      id=dialog_id,
      open?,
      closedby~,
      on_close?,
      on_cancel?,
      attrs=native_element_attrs,
      [
        @html.div(
          style=ui_styles(
            [
              UiBoxSizing,
              DialogOverlayStyle,
              dialog_overlay_motion_style(model.open),
            ],
            overlay_style,
          ),
          attrs=overlay_element_attrs,
          @html.nothing,
        ),
        @html.div(
          style=[UiBoxSizing, DialogPositionerStyle],
          attrs=positioner_attrs,
          @html.div(
            style=[
              UiBoxSizing,
              CommandDialogContentStyle,
              dialog_content_motion_style(model.open),
            ],
            attrs=content_attrs,
            surface,
          ),
        ),
      ],
    ),
  ])
}

///|
/// Create a modal command palette backed by native `<dialog>` semantics.
/// Focus trapping, Escape, top-layer stacking, and focus restoration are
/// supplied by the browser rather than a hidden runtime or stylesheet.
#cfg(target="js")
pub fn command_dialog(
  id~ : String,
  default_open? : Bool = false,
  default_query? : String = "",
  should_filter? : Bool = true,
  filter? : (String, String, Array[String]) -> Bool,
  close_on_select? : Bool = true,
  close_on_escape? : Bool = true,
  close_on_overlay? : Bool = true,
  aria_label? : String = "Command menu",
  on_value_select? : @cmd.Emit[String],
  on_query_change? : @cmd.Emit[String],
  on_open_change? : @cmd.Emit[Bool],
  on_close? : @cmd.Emit[String],
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  overlay_attrs? : @html.Attrs,
  overlay_style? : Array[String] = [],
  native_attrs? : @html.Attrs,
  native_style? : Array[String] = [],
  trigger? : (CommandScope) -> @html.Html,
  children : (CommandScope) -> @html.Html,
) -> @rabbita.Val[@html.Html] {
  let matcher = filter.unwrap_or(command_default_filter)
  let initial : CommandModel = {
    query: default_query,
    active: -1,
    open: default_open,
    generation: 0,
  }
  let (model, emit) = @rabbita.create_state_with_init(
    init=fn(_) {
      (initial, if default_open { ui_dialog_show(id, true) } else { @cmd.none })
    },
    update=fn(emit, message, current) {
      command_update(
        emit,
        "\{id}-command",
        Some(id),
        true,
        close_on_select,
        on_value_select,
        on_query_change,
        on_open_change,
        on_close,
        message,
        current,
      )
    },
  )
  model.view(model => {
    command_dialog_view(
      id,
      model,
      matcher,
      should_filter,
      close_on_escape,
      emit,
      None,
      Some(emit.map(value => CommandDidClose(value))),
      Some(if close_on_escape { emit(CommandRequestClose) } else { @cmd.none }),
      aria_label,
      close_on_overlay,
      class,
      title,
      attrs,
      style,
      overlay_attrs,
      overlay_style,
      native_attrs,
      native_style,
      trigger,
      children,
    )
  })
}

///|
#cfg(not(target="js"))
pub fn command_dialog(
  id~ : String,
  default_open? : Bool = false,
  default_query? : String = "",
  should_filter? : Bool = true,
  filter? : (String, String, Array[String]) -> Bool,
  close_on_select? : Bool = true,
  close_on_escape? : Bool = true,
  close_on_overlay? : Bool = true,
  aria_label? : String = "Command menu",
  on_value_select? : @cmd.Emit[String],
  on_query_change? : @cmd.Emit[String],
  on_open_change? : @cmd.Emit[Bool],
  on_close? : @cmd.Emit[String],
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  overlay_attrs? : @html.Attrs,
  overlay_style? : Array[String] = [],
  native_attrs? : @html.Attrs,
  native_style? : Array[String] = [],
  trigger? : (CommandScope) -> @html.Html,
  children : (CommandScope) -> @html.Html,
) -> @rabbita.Val[@html.Html] {
  ignore(
    (
      close_on_select, on_value_select, on_query_change, on_open_change, on_close,
    ),
  )
  let matcher = filter.unwrap_or(command_default_filter)
  @rabbita.Val::constant(
    command_dialog_view(
      id,
      { query: default_query, active: -1, open: default_open, generation: 0 },
      matcher,
      should_filter,
      close_on_escape,
      command_noop_emit(),
      Some(default_open),
      None,
      None,
      aria_label,
      close_on_overlay,
      class,
      title,
      attrs,
      style,
      overlay_attrs,
      overlay_style,
      native_attrs,
      native_style,
      trigger,
      children,
    ),
  )
}
