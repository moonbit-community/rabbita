///|
fn showcase_static_page(body : @html.Html) -> @rabbita.Val[@html.Html] {
  @rabbita.Val::constant(body)
}

///|
fn showcase_toggle_page() -> @rabbita.Val[@html.Html] {
  let pin_view = @rui.toggle(
    variant=Outline,
    size=Lg,
    aria_label="Pin release",
    "Pin release",
  )
  let watch_view = @rui.toggle(
    variant=Default,
    size=Sm,
    aria_label="Watch release",
    "Watch",
  )
  pin_view.view2(watch_view, foundations_toggle_demo)
}

///|
fn showcase_toggle_group_page() -> @rabbita.Val[@html.Html] {
  let density_view = @rui.toggle_group(
    default_values=["grid"],
    variant=Outline,
    size=Sm,
    aria_label="Preview layout",
    scope => {
      @html.fragment([
        @rui.toggle_group_item(scope~, value="list", aria_label="List", "List"),
        @rui.toggle_group_item(scope~, value="grid", aria_label="Grid", "Grid"),
      ])
    },
  )
  let formatting_view = @rui.toggle_group(
    default_values=["bold"],
    multiple=true,
    variant=Default,
    size=Lg,
    aria_label="Text formatting",
    scope => {
      @html.fragment([
        @rui.toggle_group_item(
          scope~,
          value="bold",
          aria_label="Bold",
          showcase_bold_icon(),
        ),
        @rui.toggle_group_item(
          scope~,
          value="italic",
          aria_label="Italic",
          showcase_italic_icon(),
        ),
        @rui.toggle_group_item(
          scope~,
          value="underline",
          aria_label="Underline",
          showcase_underline_icon(),
        ),
      ])
    },
  )
  density_view.view2(formatting_view, foundations_toggle_group_demo)
}

///|
fn showcase_foundations_page(slug : String) -> @rabbita.Val[@html.Html] {
  match slug {
    "alert" => showcase_static_page(foundations_alert_demo())
    "aspect-ratio" => showcase_static_page(foundations_aspect_ratio_demo())
    "attachment" => showcase_static_page(fdv_attachments_demo())
    "avatar" => showcase_static_page(foundations_avatar_demo())
    "badge" => showcase_static_page(foundations_badge_demo())
    "bubble" => showcase_static_page(foundations_bubble_demo())
    "button" => showcase_static_page(foundations_button_demo())
    "button-group" => showcase_static_page(foundations_button_group_demo())
    "card" => showcase_static_page(foundations_card_demo())
    "chart" => showcase_static_page(foundations_chart_demo())
    "data-table" => fdv_data_table_view().view(fdv_data_table_demo)
    "direction" => showcase_static_page(foundations_direction_demo())
    "empty" => showcase_static_page(fdv_empty_demo())
    "item" => showcase_static_page(fdv_items_demo())
    "kbd" => showcase_static_page(foundations_kbd_demo())
    "label" => showcase_static_page(foundations_label_demo())
    "markdown" => showcase_static_page(markdown_demo())
    "marker" => showcase_static_page(fdv_marker_demo())
    "message" => showcase_static_page(foundations_message_demo())
    "progress" => showcase_static_page(fdv_progress_demo())
    "separator" => showcase_static_page(foundations_separator_demo())
    "skeleton" => showcase_static_page(foundations_skeleton_demo())
    "spinner" => showcase_static_page(foundations_spinner_demo())
    "table" => showcase_static_page(foundations_table_demo())
    "toggle" => showcase_toggle_page()
    "toggle-group" => showcase_toggle_group_page()
    "typography" => showcase_static_page(fdv_typography_demo())
    _ => showcase_static_page(@html.nothing)
  }
}
