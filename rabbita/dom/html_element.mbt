///|
/// https://developer.mozilla.org/en-US/docs/Web/API/HTMLElement
#cfg(target="js")
#external
type HTMLElement

///|
#cfg(target="js")
#external
type ElementInternals

///|
#cfg(target="js")
#external
type EditContext

///|
#cfg(target="js")
pub trait IsHtmlElement: IsElement {
  fn as_html_element(Self) -> HTMLElement = _
  // Properties
  fn get_access_key(Self) -> String = _
  fn set_access_key(Self, String) -> Unit = _
  fn get_access_key_label(Self) -> String = _
  fn get_anchor_element(Self) -> Element? = _
  fn get_attribute_style_map(Self) -> StylePropertyMap = _
  fn get_auto_capitalize(Self) -> String = _
  fn set_auto_capitalize(Self, String) -> Unit = _
  fn get_auto_focus(Self) -> Bool = _
  fn set_auto_focus(Self, Bool) -> Unit = _
  fn get_auto_correct(Self) -> Bool = _
  fn set_auto_correct(Self, Bool) -> Unit = _
  fn get_content_editable(Self) -> String = _
  fn set_content_editable(Self, String) -> Unit = _
  fn get_dataset(Self) -> DOMStringMap = _
  fn get_dir(Self) -> String = _
  fn set_dir(Self, String) -> Unit = _
  fn get_draggable(Self) -> Bool = _
  fn set_draggable(Self, Bool) -> Unit = _
  fn get_edit_context(Self) -> EditContext? = _
  fn set_edit_context(Self, EditContext?) -> Unit = _
  fn get_enter_key_hint(Self) -> String = _
  fn set_enter_key_hint(Self, String) -> Unit = _
  fn get_hidden(Self) -> @js.Value = _
  fn set_hidden(Self, @js.Value) -> Unit = _
  fn get_inert(Self) -> Bool = _
  fn set_inert(Self, Bool) -> Unit = _
  fn get_inner_text(Self) -> String = _
  fn set_inner_text(Self, String) -> Unit = _
  fn get_input_mode(Self) -> String = _
  fn set_input_mode(Self, String) -> Unit = _
  fn get_is_content_editable(Self) -> Bool = _
  fn get_lang(Self) -> String = _
  fn set_lang(Self, String) -> Unit = _
  fn get_nonce(Self) -> String = _
  fn set_nonce(Self, String) -> Unit = _
  fn get_offset_height(Self) -> Double = _
  fn get_offset_left(Self) -> Double = _
  fn get_offset_parent(Self) -> Element? = _
  fn get_offset_top(Self) -> Double = _
  fn get_offset_width(Self) -> Double = _
  fn get_outer_text(Self) -> String = _
  fn set_outer_text(Self, String) -> Unit = _
  fn get_popover(Self) -> String? = _
  fn set_popover(Self, String?) -> Unit = _
  fn get_spellcheck(Self) -> Bool = _
  fn set_spellcheck(Self, Bool) -> Unit = _
  fn get_style(Self) -> CSSStyleDeclaration = _
  fn set_style_declaration(Self, CSSStyleDeclaration) -> Unit = _
  fn get_tab_index(Self) -> Int = _
  fn set_tab_index(Self, Int) -> Unit = _
  fn get_title(Self) -> String = _
  fn set_title(Self, String) -> Unit = _
  fn get_translate(Self) -> Bool = _
  fn set_translate(Self, Bool) -> Unit = _
  fn get_virtual_keyboard_policy(Self) -> String = _
  fn set_virtual_keyboard_policy(Self, String) -> Unit = _
  fn get_writing_suggestions(Self) -> String = _
  fn set_writing_suggestions(Self, String) -> Unit = _

  // Methods
  fn attach_internals(Self) -> ElementInternals = _
  fn blur(Self) -> Unit = _
  fn click(Self) -> Unit = _
  fn focus(Self) -> Unit = _
  /// https://developer.mozilla.org/en-US/docs/Web/API/HTMLElement/focus
  fn focus_with_options(Self, prevent_scroll? : Bool, focus_visible? : Bool) -> Unit = _
  /// https://developer.mozilla.org/en-US/docs/Web/API/HTMLElement/hidePopover
  fn hide_popover(Self) -> Unit = _
  /// https://developer.mozilla.org/en-US/docs/Web/API/HTMLElement/showPopover
  fn show_popover(Self) -> Unit = _
  /// https://developer.mozilla.org/en-US/docs/Web/API/HTMLElement/togglePopover
  fn toggle_popover(Self, Bool?) -> Bool = _
}

///|
#cfg(target="js")
pub impl IsEventTarget for HTMLElement

///|
#cfg(target="js")
pub extend HTMLElement with IsEventTarget::{
  add_event_listener,
  add_event_listener_with_options,
  as_event_target,
  dispatch_event,
  remove_event_listener,
  remove_event_listener_with_options,
  to_clipboard,
  to_comment,
  to_document,
  to_document_fragment,
  to_element,
  to_html_canvas_element,
  to_html_dialog_element,
  to_html_element,
  to_html_image_element,
  to_html_input_element,
  to_html_media_element,
  to_html_select_element,
  to_html_video_element,
  to_node,
  to_svg_element,
  to_svg_graphics_element,
  to_svg_image_element,
  to_text,
  to_window,
}

///|
#cfg(target="js")
pub impl @js.Cast for HTMLElement with fn into(value) {
  value |> ffi_to_html_element |> y => { y.to_option() }
}

///|
#cfg(target="js")
pub extend HTMLElement with @js.Cast::{from, into}

///|
#cfg(target="js")
pub impl @js.Cast for HTMLElement with fn from(value) {
  value |> js_identity
}

///|
#cfg(target="js")
pub impl IsNode for HTMLElement

///|
#cfg(target="js")
pub extend HTMLElement with IsNode::{
  append_child,
  as_node,
  contains,
  get_child,
  get_child_count,
  get_first_child,
  get_is_connected,
  get_last_child,
  get_next_sibling,
  get_node_name,
  get_node_type,
  get_node_value,
  get_parent_element,
  get_parent_node,
  get_previous_sibling,
  insert_before,
  is_same_node,
  remove_child,
  replace_child,
  set_node_value,
}

///|
#cfg(target="js")
pub impl IsElement for HTMLElement

///|
#cfg(target="js")
pub extend HTMLElement with IsElement::{
  as_element,
  closest,
  get_animations,
  get_attribute,
  get_bounding_client_rect,
  get_children,
  get_client_height,
  get_client_left,
  get_client_rects,
  get_client_top,
  get_client_width,
  get_property,
  get_scroll_height,
  get_scroll_left,
  get_scroll_top,
  get_scroll_width,
  has_attribute,
  has_pointer_capture,
  matches,
  query_selector,
  query_selector_all,
  release_pointer_capture,
  remove_attribute,
  remove_property,
  scroll_into_view,
  scroll_into_view_with_options,
  set_attribute,
  set_inner_html,
  set_pointer_capture,
  set_property,
  set_scroll_left,
  set_scroll_top,
}

///|
#cfg(target="js")
pub impl IsHtmlElement for HTMLElement

///|
#cfg(target="js")
pub extend HTMLElement with IsHtmlElement::{
  as_html_element,
  attach_internals,
  blur,
  click,
  focus,
  focus_with_options,
  get_access_key,
  get_access_key_label,
  get_anchor_element,
  get_attribute_style_map,
  get_auto_capitalize,
  get_auto_correct,
  get_auto_focus,
  get_content_editable,
  get_dataset,
  get_dir,
  get_draggable,
  get_edit_context,
  get_enter_key_hint,
  get_hidden,
  get_inert,
  get_inner_text,
  get_input_mode,
  get_is_content_editable,
  get_lang,
  get_nonce,
  get_offset_height,
  get_offset_left,
  get_offset_parent,
  get_offset_top,
  get_offset_width,
  get_outer_text,
  get_popover,
  get_spellcheck,
  get_style,
  get_tab_index,
  get_title,
  get_translate,
  get_virtual_keyboard_policy,
  get_writing_suggestions,
  hide_popover,
  set_access_key,
  set_auto_capitalize,
  set_auto_correct,
  set_auto_focus,
  set_content_editable,
  set_dir,
  set_draggable,
  set_edit_context,
  set_enter_key_hint,
  set_hidden,
  set_inert,
  set_inner_text,
  set_input_mode,
  set_lang,
  set_nonce,
  set_outer_text,
  set_popover,
  set_spellcheck,
  set_style_declaration,
  set_tab_index,
  set_title,
  set_translate,
  set_virtual_keyboard_policy,
  set_writing_suggestions,
  show_popover,
  toggle_popover,
}

///|
#cfg(target="js")
impl IsHtmlElement with fn as_html_element(s) {
  js_identity(s)
}

///|
#cfg(target="js")
impl IsHtmlElement with fn get_access_key(s) {
  ffi_html_element_get_access_key(s.as_html_element())
}

///|
#cfg(target="js")
impl IsHtmlElement with fn set_access_key(s, value) {
  ffi_html_element_set_access_key(s.as_html_element(), value)
}

///|
#cfg(target="js")
impl IsHtmlElement with fn get_access_key_label(s) {
  ffi_html_element_get_access_key_label(s.as_html_element())
}

///|
#cfg(target="js")
impl IsHtmlElement with fn get_anchor_element(s) {
  ffi_html_element_get_anchor_element(s.as_html_element()).to_option()
}

///|
#cfg(target="js")
impl IsHtmlElement with fn get_attribute_style_map(s) {
  ffi_html_element_get_attribute_style_map(s.as_html_element())
}

///|
#cfg(target="js")
impl IsHtmlElement with fn get_auto_capitalize(s) {
  ffi_html_element_get_autocapitalize(s.as_html_element())
}

///|
#cfg(target="js")
impl IsHtmlElement with fn set_auto_capitalize(s, value) {
  ffi_html_element_set_autocapitalize(s.as_html_element(), value)
}

///|
#cfg(target="js")
impl IsHtmlElement with fn get_auto_focus(s) {
  ffi_html_element_get_autofocus(s.as_html_element())
}

///|
#cfg(target="js")
impl IsHtmlElement with fn set_auto_focus(s, value) {
  ffi_html_element_set_autofocus(s.as_html_element(), value)
}

///|
#cfg(target="js")
impl IsHtmlElement with fn get_auto_correct(s) {
  ffi_html_element_get_autocorrect(s.as_html_element())
}

///|
#cfg(target="js")
impl IsHtmlElement with fn set_auto_correct(s, value) {
  ffi_html_element_set_autocorrect(s.as_html_element(), value)
}

///|
#cfg(target="js")
impl IsHtmlElement with fn get_content_editable(s) {
  ffi_html_element_get_content_editable(s.as_html_element())
}

///|
#cfg(target="js")
impl IsHtmlElement with fn set_content_editable(s, value) {
  ffi_html_element_set_content_editable(s.as_html_element(), value)
}

///|
#cfg(target="js")
impl IsHtmlElement with fn get_dataset(s) {
  ffi_html_element_get_dataset(s.as_html_element())
}

///|
#cfg(target="js")
impl IsHtmlElement with fn get_dir(s) {
  ffi_html_element_get_dir(s.as_html_element())
}

///|
#cfg(target="js")
impl IsHtmlElement with fn set_dir(s, value) {
  ffi_html_element_set_dir(s.as_html_element(), value)
}

///|
#cfg(target="js")
impl IsHtmlElement with fn get_draggable(s) {
  ffi_html_element_get_draggable(s.as_html_element())
}

///|
#cfg(target="js")
impl IsHtmlElement with fn set_draggable(s, value) {
  ffi_html_element_set_draggable(s.as_html_element(), value)
}

///|
#cfg(target="js")
impl IsHtmlElement with fn get_edit_context(s) {
  ffi_html_element_get_edit_context(s.as_html_element()).to_option()
}

///|
#cfg(target="js")
impl IsHtmlElement with fn set_edit_context(s, value) {
  ffi_html_element_set_edit_context(
    s.as_html_element(),
    @js.Nullable::from_option(value),
  )
}

///|
#cfg(target="js")
impl IsHtmlElement with fn get_enter_key_hint(s) {
  ffi_html_element_get_enter_key_hint(s.as_html_element())
}

///|
#cfg(target="js")
impl IsHtmlElement with fn set_enter_key_hint(s, value) {
  ffi_html_element_set_enter_key_hint(s.as_html_element(), value)
}

///|
#cfg(target="js")
impl IsHtmlElement with fn get_hidden(s) {
  ffi_html_element_get_hidden(s.as_html_element())
}

///|
#cfg(target="js")
impl IsHtmlElement with fn set_hidden(s, value) {
  ffi_html_element_set_hidden(s.as_html_element(), value)
}

///|
#cfg(target="js")
impl IsHtmlElement with fn get_inert(s) {
  ffi_html_element_get_inert(s.as_html_element())
}

///|
#cfg(target="js")
impl IsHtmlElement with fn set_inert(s, value) {
  ffi_html_element_set_inert(s.as_html_element(), value)
}

///|
#cfg(target="js")
impl IsHtmlElement with fn get_inner_text(s) {
  ffi_html_element_get_inner_text(s.as_html_element())
}

///|
#cfg(target="js")
impl IsHtmlElement with fn set_inner_text(s, value) {
  ffi_html_element_set_inner_text(s.as_html_element(), value)
}

///|
#cfg(target="js")
impl IsHtmlElement with fn get_input_mode(s) {
  ffi_html_element_get_input_mode(s.as_html_element())
}

///|
#cfg(target="js")
impl IsHtmlElement with fn set_input_mode(s, value) {
  ffi_html_element_set_input_mode(s.as_html_element(), value)
}

///|
#cfg(target="js")
impl IsHtmlElement with fn get_is_content_editable(s) {
  ffi_html_element_get_is_content_editable(s.as_html_element())
}

///|
#cfg(target="js")
impl IsHtmlElement with fn get_lang(s) {
  ffi_html_element_get_lang(s.as_html_element())
}

///|
#cfg(target="js")
impl IsHtmlElement with fn set_lang(s, value) {
  ffi_html_element_set_lang(s.as_html_element(), value)
}

///|
#cfg(target="js")
impl IsHtmlElement with fn get_nonce(s) {
  ffi_html_element_get_nonce(s.as_html_element())
}

///|
#cfg(target="js")
impl IsHtmlElement with fn set_nonce(s, value) {
  ffi_html_element_set_nonce(s.as_html_element(), value)
}

///|
#cfg(target="js")
impl IsHtmlElement with fn get_offset_height(s) {
  ffi_html_element_get_offset_height(s.as_html_element())
}

///|
#cfg(target="js")
impl IsHtmlElement with fn get_offset_left(s) {
  ffi_html_element_get_offset_left(s.as_html_element())
}

///|
#cfg(target="js")
impl IsHtmlElement with fn get_offset_parent(s) {
  ffi_html_element_get_offset_parent(s.as_html_element()).to_option()
}

///|
#cfg(target="js")
impl IsHtmlElement with fn get_offset_top(s) {
  ffi_html_element_get_offset_top(s.as_html_element())
}

///|
#cfg(target="js")
impl IsHtmlElement with fn get_offset_width(s) {
  ffi_html_element_get_offset_width(s.as_html_element())
}

///|
#cfg(target="js")
impl IsHtmlElement with fn get_outer_text(s) {
  ffi_html_element_get_outer_text(s.as_html_element())
}

///|
#cfg(target="js")
impl IsHtmlElement with fn set_outer_text(s, value) {
  ffi_html_element_set_outer_text(s.as_html_element(), value)
}

///|
#cfg(target="js")
impl IsHtmlElement with fn get_popover(s) {
  ffi_html_element_get_popover(s.as_html_element()).to_option()
}

///|
#cfg(target="js")
impl IsHtmlElement with fn set_popover(s, value) {
  ffi_html_element_set_popover(s.as_html_element(), value)
}

///|
#cfg(target="js")
impl IsHtmlElement with fn get_spellcheck(s) {
  ffi_html_element_get_spellcheck(s.as_html_element())
}

///|
#cfg(target="js")
impl IsHtmlElement with fn set_spellcheck(s, value) {
  ffi_html_element_set_spellcheck(s.as_html_element(), value)
}

///|
#cfg(target="js")
impl IsHtmlElement with fn get_style(s) {
  ffi_html_element_get_style(s.as_html_element())
}

///|
#cfg(target="js")
impl IsHtmlElement with fn set_style_declaration(s, value) {
  ffi_html_element_set_style_declaration(s.as_html_element(), value)
}

///|
#cfg(target="js")
impl IsHtmlElement with fn get_tab_index(s) {
  ffi_html_element_get_tab_index(s.as_html_element())
}

///|
#cfg(target="js")
impl IsHtmlElement with fn set_tab_index(s, value) {
  ffi_html_element_set_tab_index(s.as_html_element(), value)
}

///|
#cfg(target="js")
impl IsHtmlElement with fn get_title(s) {
  ffi_html_element_get_title(s.as_html_element())
}

///|
#cfg(target="js")
impl IsHtmlElement with fn set_title(s, value) {
  ffi_html_element_set_title(s.as_html_element(), value)
}

///|
#cfg(target="js")
impl IsHtmlElement with fn get_translate(s) {
  ffi_html_element_get_translate(s.as_html_element())
}

///|
#cfg(target="js")
impl IsHtmlElement with fn set_translate(s, value) {
  ffi_html_element_set_translate(s.as_html_element(), value)
}

///|
#cfg(target="js")
impl IsHtmlElement with fn get_virtual_keyboard_policy(s) {
  ffi_html_element_get_virtual_keyboard_policy(s.as_html_element())
}

///|
#cfg(target="js")
impl IsHtmlElement with fn set_virtual_keyboard_policy(s, value) {
  ffi_html_element_set_virtual_keyboard_policy(s.as_html_element(), value)
}

///|
#cfg(target="js")
impl IsHtmlElement with fn get_writing_suggestions(s) {
  ffi_html_element_get_writing_suggestions(s.as_html_element())
}

///|
#cfg(target="js")
impl IsHtmlElement with fn set_writing_suggestions(s, value) {
  ffi_html_element_set_writing_suggestions(s.as_html_element(), value)
}

///|
#cfg(target="js")
impl IsHtmlElement with fn attach_internals(s) {
  ffi_html_element_attach_internals(s.as_html_element())
}

///|
#cfg(target="js")
impl IsHtmlElement with fn blur(s) {
  ffi_html_element_blur(s.as_html_element())
}

///|
#cfg(target="js")
impl IsHtmlElement with fn click(s) {
  ffi_html_element_click(s.as_html_element())
}

///|
#cfg(target="js")
impl IsHtmlElement with fn focus(s) {
  ffi_html_element_focus(s.as_html_element())
}

///|
#cfg(target="js")
impl IsHtmlElement with fn focus_with_options(
  s,
  prevent_scroll?,
  focus_visible?,
) {
  ffi_html_element_focus_with_options(
    s.as_html_element(),
    prevent_scroll.unwrap_or(false),
    @js.Optional::from_option(focus_visible),
  )
}

///|
#cfg(target="js")
impl IsHtmlElement with fn hide_popover(s) {
  ffi_html_element_hide_popover(s.as_html_element())
}

///|
#cfg(target="js")
impl IsHtmlElement with fn show_popover(s) {
  ffi_html_element_show_popover(s.as_html_element())
}

///|
#cfg(target="js")
impl IsHtmlElement with fn toggle_popover(s, force) {
  ffi_html_element_toggle_popover(s.as_html_element(), force)
}

///|
#cfg(target="js")
extern "js" fn ffi_html_element_get_access_key(s : HTMLElement) -> String = "(s) => s.accessKey"

///|
#cfg(target="js")
extern "js" fn ffi_html_element_set_access_key(
  s : HTMLElement,
  value : String,
) -> Unit = "(s, value) => s.accessKey = value"

///|
#cfg(target="js")
extern "js" fn ffi_html_element_get_access_key_label(s : HTMLElement) -> String = "(s) => s.accessKeyLabel"

///|
#cfg(target="js")
extern "js" fn ffi_html_element_get_anchor_element(
  s : HTMLElement,
) -> @js.Nullable[Element] = "(s) => s.anchorElement"

///|
#cfg(target="js")
extern "js" fn ffi_html_element_get_attribute_style_map(
  s : HTMLElement,
) -> StylePropertyMap = "(s) => s.attributeStyleMap"

///|
#cfg(target="js")
extern "js" fn ffi_html_element_get_autocapitalize(s : HTMLElement) -> String = "(s) => s.autocapitalize"

///|
#cfg(target="js")
extern "js" fn ffi_html_element_set_autocapitalize(
  s : HTMLElement,
  value : String,
) -> Unit = "(s, value) => s.autocapitalize = value"

///|
#cfg(target="js")
extern "js" fn ffi_html_element_get_autofocus(s : HTMLElement) -> Bool = "(s) => s.autofocus"

///|
#cfg(target="js")
extern "js" fn ffi_html_element_set_autofocus(
  s : HTMLElement,
  value : Bool,
) -> Unit = "(s, value) => s.autofocus = value"

///|
#cfg(target="js")
extern "js" fn ffi_html_element_get_autocorrect(s : HTMLElement) -> Bool = "(s) => s.autocorrect"

///|
#cfg(target="js")
extern "js" fn ffi_html_element_set_autocorrect(
  s : HTMLElement,
  value : Bool,
) -> Unit = "(s, value) => s.autocorrect = value"

///|
#cfg(target="js")
extern "js" fn ffi_html_element_get_content_editable(s : HTMLElement) -> String = "(s) => s.contentEditable"

///|
#cfg(target="js")
extern "js" fn ffi_html_element_set_content_editable(
  s : HTMLElement,
  value : String,
) -> Unit = "(s, value) => s.contentEditable = value"

///|
#cfg(target="js")
extern "js" fn ffi_html_element_get_dataset(s : HTMLElement) -> DOMStringMap = "(s) => s.dataset"

///|
#cfg(target="js")
extern "js" fn ffi_html_element_get_dir(s : HTMLElement) -> String = "(s) => s.dir"

///|
#cfg(target="js")
extern "js" fn ffi_html_element_set_dir(
  s : HTMLElement,
  value : String,
) -> Unit = "(s, value) => s.dir = value"

///|
#cfg(target="js")
extern "js" fn ffi_html_element_get_draggable(s : HTMLElement) -> Bool = "(s) => s.draggable"

///|
#cfg(target="js")
extern "js" fn ffi_html_element_set_draggable(
  s : HTMLElement,
  value : Bool,
) -> Unit = "(s, value) => s.draggable = value"

///|
#cfg(target="js")
extern "js" fn ffi_html_element_get_edit_context(
  s : HTMLElement,
) -> @js.Nullable[EditContext] = "(s) => s.editContext"

///|
#cfg(target="js")
extern "js" fn ffi_html_element_set_edit_context(
  s : HTMLElement,
  value : @js.Nullable[EditContext],
) -> Unit = "(s, value) => s.editContext = value"

///|
#cfg(target="js")
extern "js" fn ffi_html_element_get_enter_key_hint(s : HTMLElement) -> String = "(s) => s.enterKeyHint"

///|
#cfg(target="js")
extern "js" fn ffi_html_element_set_enter_key_hint(
  s : HTMLElement,
  value : String,
) -> Unit = "(s, value) => s.enterKeyHint = value"

///|
#cfg(target="js")
extern "js" fn ffi_html_element_get_hidden(s : HTMLElement) -> @js.Value = "(s) => s.hidden"

///|
#cfg(target="js")
extern "js" fn ffi_html_element_set_hidden(
  s : HTMLElement,
  value : @js.Value,
) -> Unit = "(s, value) => s.hidden = value"

///|
#cfg(target="js")
extern "js" fn ffi_html_element_get_inert(s : HTMLElement) -> Bool = "(s) => s.inert"

///|
#cfg(target="js")
extern "js" fn ffi_html_element_set_inert(
  s : HTMLElement,
  value : Bool,
) -> Unit = "(s, value) => s.inert = value"

///|
#cfg(target="js")
extern "js" fn ffi_html_element_get_inner_text(s : HTMLElement) -> String = "(s) => s.innerText"

///|
#cfg(target="js")
extern "js" fn ffi_html_element_set_inner_text(
  s : HTMLElement,
  value : String,
) -> Unit = "(s, value) => s.innerText = value"

///|
#cfg(target="js")
extern "js" fn ffi_html_element_get_input_mode(s : HTMLElement) -> String = "(s) => s.inputMode"

///|
#cfg(target="js")
extern "js" fn ffi_html_element_set_input_mode(
  s : HTMLElement,
  value : String,
) -> Unit = "(s, value) => s.inputMode = value"

///|
#cfg(target="js")
extern "js" fn ffi_html_element_get_is_content_editable(
  s : HTMLElement,
) -> Bool = "(s) => s.isContentEditable"

///|
#cfg(target="js")
extern "js" fn ffi_html_element_get_lang(s : HTMLElement) -> String = "(s) => s.lang"

///|
#cfg(target="js")
extern "js" fn ffi_html_element_set_lang(
  s : HTMLElement,
  value : String,
) -> Unit = "(s, value) => s.lang = value"

///|
#cfg(target="js")
extern "js" fn ffi_html_element_get_nonce(s : HTMLElement) -> String = "(s) => s.nonce"

///|
#cfg(target="js")
extern "js" fn ffi_html_element_set_nonce(
  s : HTMLElement,
  value : String,
) -> Unit = "(s, value) => s.nonce = value"

///|
#cfg(target="js")
extern "js" fn ffi_html_element_get_offset_height(s : HTMLElement) -> Double = "(s) => s.offsetHeight"

///|
#cfg(target="js")
extern "js" fn ffi_html_element_get_offset_left(s : HTMLElement) -> Double = "(s) => s.offsetLeft"

///|
#cfg(target="js")
extern "js" fn ffi_html_element_get_offset_parent(
  s : HTMLElement,
) -> @js.Nullable[Element] = "(s) => s.offsetParent"

///|
#cfg(target="js")
extern "js" fn ffi_html_element_get_offset_top(s : HTMLElement) -> Double = "(s) => s.offsetTop"

///|
#cfg(target="js")
extern "js" fn ffi_html_element_get_offset_width(s : HTMLElement) -> Double = "(s) => s.offsetWidth"

///|
#cfg(target="js")
extern "js" fn ffi_html_element_get_outer_text(s : HTMLElement) -> String = "(s) => s.outerText"

///|
#cfg(target="js")
extern "js" fn ffi_html_element_set_outer_text(
  s : HTMLElement,
  value : String,
) -> Unit = "(s, value) => s.outerText = value"

///|
#cfg(target="js")
extern "js" fn ffi_html_element_get_popover(
  s : HTMLElement,
) -> @js.Nullable[String] = "(s) => s.popover ?? null"

///|
#cfg(target="js")
extern "js" fn ffi_html_element_set_popover(
  s : HTMLElement,
  value : String?,
) -> Unit = "(s, value) => s.popover = value"

///|
#cfg(target="js")
extern "js" fn ffi_html_element_get_spellcheck(s : HTMLElement) -> Bool = "(s) => s.spellcheck"

///|
#cfg(target="js")
extern "js" fn ffi_html_element_set_spellcheck(
  s : HTMLElement,
  value : Bool,
) -> Unit = "(s, value) => s.spellcheck = value"

///|
#cfg(target="js")
extern "js" fn ffi_html_element_get_style(
  s : HTMLElement,
) -> CSSStyleDeclaration = "(s) => s.style"

///|
#cfg(target="js")
extern "js" fn ffi_html_element_set_style_declaration(
  s : HTMLElement,
  value : CSSStyleDeclaration,
) -> Unit = "(s, value) => s.style = value"

///|
#cfg(target="js")
extern "js" fn ffi_html_element_get_tab_index(s : HTMLElement) -> Int = "(s) => s.tabIndex"

///|
#cfg(target="js")
extern "js" fn ffi_html_element_set_tab_index(
  s : HTMLElement,
  value : Int,
) -> Unit = "(s, value) => s.tabIndex = value"

///|
#cfg(target="js")
extern "js" fn ffi_html_element_get_title(s : HTMLElement) -> String = "(s) => s.title"

///|
#cfg(target="js")
extern "js" fn ffi_html_element_set_title(
  s : HTMLElement,
  value : String,
) -> Unit = "(s, value) => s.title = value"

///|
#cfg(target="js")
extern "js" fn ffi_html_element_get_translate(s : HTMLElement) -> Bool = "(s) => s.translate"

///|
#cfg(target="js")
extern "js" fn ffi_html_element_set_translate(
  s : HTMLElement,
  value : Bool,
) -> Unit = "(s, value) => s.translate = value"

///|
#cfg(target="js")
extern "js" fn ffi_html_element_get_virtual_keyboard_policy(
  s : HTMLElement,
) -> String = "(s) => s.virtualKeyboardPolicy"

///|
#cfg(target="js")
extern "js" fn ffi_html_element_set_virtual_keyboard_policy(
  s : HTMLElement,
  value : String,
) -> Unit = "(s, value) => s.virtualKeyboardPolicy = value"

///|
#cfg(target="js")
extern "js" fn ffi_html_element_get_writing_suggestions(
  s : HTMLElement,
) -> String = "(s) => s.writingSuggestions"

///|
#cfg(target="js")
extern "js" fn ffi_html_element_set_writing_suggestions(
  s : HTMLElement,
  value : String,
) -> Unit = "(s, value) => s.writingSuggestions = value"

///|
#cfg(target="js")
extern "js" fn ffi_html_element_attach_internals(
  s : HTMLElement,
) -> ElementInternals = "(s) => s.attachInternals()"

///|
#cfg(target="js")
extern "js" fn ffi_html_element_blur(s : HTMLElement) -> Unit = "(s) => s.blur()"

///|
#cfg(target="js")
extern "js" fn ffi_html_element_click(s : HTMLElement) -> Unit = "(s) => s.click()"

///|
#cfg(target="js")
extern "js" fn ffi_html_element_focus(s : HTMLElement) -> Unit = "(s) => s.focus()"

///|
#cfg(target="js")
extern "js" fn ffi_html_element_focus_with_options(
  s : HTMLElement,
  prevent_scroll : Bool,
  focus_visible : @js.Optional[Bool],
) -> Unit =
  #| (element, preventScroll, focusVisible) => {
  #|   if (focusVisible === undefined) element.focus({ preventScroll })
  #|   else element.focus({ preventScroll, focusVisible })
  #| }

///|
#cfg(target="js")
extern "js" fn ffi_html_element_hide_popover(s : HTMLElement) -> Unit = "(s) => s.hidePopover()"

///|
#cfg(target="js")
extern "js" fn ffi_html_element_show_popover(s : HTMLElement) -> Unit = "(s) => s.showPopover()"

///|
#cfg(target="js")
extern "js" fn ffi_html_element_toggle_popover(
  s : HTMLElement,
  force : Bool?,
) -> Bool = "(s, force) => s.togglePopover(force)"
