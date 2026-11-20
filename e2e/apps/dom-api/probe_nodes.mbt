///|
fn probe_nodes() -> String {
  let failures : Array[String] = []
  let document = @dom.document()
  let root = document.create_element("section")
  @dom.IsElement::set_attribute(root, "id", "dom-probe-root")
  @dom.IsElement::set_attribute(root, "class", "probe-root")
  @dom.IsElement::set_attribute(root, "data-ready", "yes")
  if document.get_body() is Some(body) {
    @dom.IsNode::append_child(body, @dom.IsNode::as_node(root))
    record(
      failures,
      document.get_element_by_id("dom-probe-root").to_option() is Some(_),
      "get_element_by_id",
    )
    record(failures, document.get_body() is Some(_), "body")
    record(failures, document.get_head() is Some(_), "head")
    record(
      failures,
      document.get_document_element() is Some(_),
      "document_element",
    )
    record(failures, !document.hidden(), "document_hidden")
    record(failures, @dom.IsNode::get_is_connected(root), "element_connected")
    record(
      failures,
      @dom.IsNode::get_parent_element(root) is Some(_),
      "parent_element",
    )
    record(
      failures,
      @dom.IsNode::get_parent_node(root).to_option() is Some(_),
      "parent_node",
    )
    record(failures, @dom.IsNode::get_node_type(root) == 1, "element_node_type")
    record(
      failures,
      @dom.IsNode::get_node_name(root) == "SECTION",
      "element_node_name",
    )
    record(
      failures,
      physical_equal(@dom.IsElement::as_element(root), root),
      "as_element",
    )
    record(
      failures,
      @dom.IsNode::get_node_value(root) is None,
      "element_node_value",
    )
    let empty = document.create_element("div")
    record(
      failures,
      @dom.IsNode::get_first_child(empty) is None,
      "first_child_empty",
    )
    record(
      failures,
      @dom.IsNode::get_last_child(empty) is None,
      "last_child_empty",
    )

    let text = document.create_text_node("alpha")
    let comment = document.create_comment("note")
    record(failures, @dom.IsNode::get_node_type(text) == 3, "text_node_type")
    record(
      failures,
      @dom.IsEventTarget::to_text(text) is Some(_),
      "text_conversion",
    )
    if @dom.IsEventTarget::to_text(text) is Some(text_node) {
      ignore(text_node.to_node())
    }
    record(
      failures,
      @dom.IsEventTarget::to_comment(comment) is Some(_),
      "comment_conversion",
    )
    @dom.IsNode::append_child(root, @dom.IsNode::as_node(text))
    @dom.IsNode::append_child(root, comment.to_node())
    record(failures, @dom.IsNode::get_child_count(root) == 2, "append_child")
    record(
      failures,
      @dom.IsNode::get_node_value(text) == Some("alpha"),
      "text_node_value",
    )
    @dom.IsNode::set_node_value(text, @js.Nullable::from_option(Some("beta")))
    record(
      failures,
      @dom.IsNode::get_node_value(text) == Some("beta"),
      "set_node_value",
    )
    record(
      failures,
      @dom.IsNode::get_first_child(root) is Some(child) &&
      @dom.IsNode::is_same_node(child, @dom.IsNode::as_node(text)),
      "first_child",
    )
    record(
      failures,
      @dom.IsNode::get_last_child(root) is Some(child) &&
      @dom.IsNode::is_same_node(child, comment.to_node()),
      "last_child",
    )
    record(
      failures,
      @dom.IsNode::get_next_sibling(text).to_option() is Some(_),
      "next_sibling",
    )
    record(
      failures,
      @dom.IsNode::get_previous_sibling(comment).to_option() is Some(_),
      "previous_sibling",
    )
    record(
      failures,
      @dom.IsNode::contains(root, @dom.IsNode::as_node(text)),
      "contains",
    )
    record(
      failures,
      @dom.IsNode::is_same_node(
        @dom.IsNode::get_child(root, 0),
        @dom.IsNode::as_node(text),
      ),
      "get_child",
    )
    let before = document.create_element("b")
    @dom.IsNode::insert_before(
      root,
      @dom.IsNode::as_node(before),
      @js.Nullable::from_option(Some(comment.to_node())),
    )
    record(failures, @dom.IsNode::get_child_count(root) == 3, "insert_before")
    let replacement = document.create_element("i")
    @dom.IsNode::replace_child(
      root,
      @dom.IsNode::as_node(replacement),
      @dom.IsNode::as_node(before),
    )
    record(
      failures,
      @dom.IsNode::contains(root, @dom.IsNode::as_node(replacement)),
      "replace_child",
    )
    @dom.IsNode::remove_child(root, comment.to_node())
    record(failures, @dom.IsNode::get_child_count(root) == 2, "remove_child")

    let fragment = document.create_document_fragment()
    ignore(fragment.to_node())
    let fragment_child = document.create_element("em")
    @dom.IsNode::append_child(fragment, @dom.IsNode::as_node(fragment_child))
    record(
      failures,
      @dom.IsNode::get_child_count(fragment) == 1,
      "document_fragment",
    )
    record(
      failures,
      @dom.IsEventTarget::to_document_fragment(fragment) is Some(_),
      "fragment_conversion",
    )

    let children_html =
      #|<span id="named-child" class="hit" name="probe-name">one</span>
      #|<span class="hit">two</span>
      #|<div class="large-child" style="width:640px;height:360px"></div>
      #|
    @dom.IsElement::set_inner_html(root, children_html)
    let children = @dom.IsElement::get_children(root)
    record(failures, children.length() == 3, "children")
    let live_child = document.create_element("i")
    @dom.IsNode::append_child(root, live_child.as_node())
    record(failures, children.length() == 4, "children_live_collection")
    @dom.IsNode::remove_child(root, live_child.as_node())
    record(failures, children.length() == 3, "children_live_collection_remove")
    record(
      failures,
      @dom.IsElement::query_selector(root, ".hit") is Some(_),
      "query_selector",
    )
    record(
      failures,
      @dom.IsElement::query_selector(root, ".missing") is None,
      "query_selector_missing",
    )
    let hits = @dom.IsElement::query_selector_all(root, ".hit")
    record(failures, hits.length() == 2, "query_selector_all")
    let later_hit = document.create_element("span")
    later_hit.set_attribute("class", "hit")
    root.append_child(later_hit.as_node())
    record(
      failures,
      hits.length() == 2 &&
      @dom.IsElement::query_selector_all(root, ".hit").length() == 3,
      "query_selector_all_static_snapshot",
    )
    root.remove_child(later_hit.as_node())
    record(
      failures,
      @dom.IsElement::closest(root, "body") is Some(_),
      "closest",
    )
    record(failures, @dom.IsElement::matches(root, ".probe-root"), "matches")
    record(
      failures,
      @dom.IsElement::has_attribute(root, "data-ready"),
      "has_attribute",
    )
    record(
      failures,
      @dom.IsElement::get_attribute(root, "data-ready") == Some("yes"),
      "get_attribute",
    )
    @dom.IsElement::remove_attribute(root, "data-ready")
    record(
      failures,
      @dom.IsElement::get_attribute(root, "data-ready") is None,
      "remove_attribute",
    )
    @dom.IsElement::set_property(
      root,
      "probeValue",
      @js.Value::cast_from("rabbit"),
    )
    record(
      failures,
      @dom.IsElement::get_property(root, "probeValue").to_option() ==
      Some("rabbit"),
      "get_property",
    )
    @dom.IsElement::remove_property(root, "probeValue")
    record(
      failures,
      @dom.IsElement::get_property(root, "probeValue").is_undefined(),
      "remove_property",
    )

    record(
      failures,
      document.query_selector("#named-child").to_option() is Some(_),
      "document_query_selector",
    )
    record(
      failures,
      document.query_selector_all(".hit").get_length() == 2.0,
      "document_query_selector_all",
    )
    let by_class = document.get_elements_by_class_name("hit")
    record(failures, by_class.get_length() == 2.0, "class_collection")
    record(
      failures,
      by_class.item(0.0).to_option() is Some(_),
      "collection_item",
    )
    record(
      failures,
      by_class.named_item("named-child").to_option() is Some(_),
      "collection_named_item",
    )
    record(
      failures,
      document.get_elements_by_name("probe-name").get_length() == 1.0,
      "elements_by_name",
    )
    record(
      failures,
      document.get_elements_by_tag_name("span").get_length() >= 2.0,
      "elements_by_tag_name",
    )
    record(
      failures,
      document
      .get_elements_by_tag_name_ns(@dom.namespace_html, "span")
      .get_length() >=
      2.0,
      "elements_by_tag_name_ns",
    )
    record(
      failures,
      document.get_elements_by_name("probe-name").item(0.0).to_option()
      is Some(_),
      "node_list_item",
    )
    record(
      failures,
      document.to_node().get_node_type() == 9,
      "document_to_node",
    )

    if @dom.IsEventTarget::to_html_element(root) is Some(html) {
      let style = @dom.IsHtmlElement::get_style(html)
      style.set_property("width", "320px")
      style.set_property_with_priority("height", "180px", "important")
      style.set("overflow", "scroll")
      record(
        failures,
        style.get_property_value("width") == "320px",
        "style_property",
      )
      record(
        failures,
        style.get_property_priority("height") == "important",
        "style_priority",
      )
      record(failures, style.get("overflow") == "scroll", "style_index")
      record(failures, style.get_length() >= 3, "style_length")
      record(failures, style.item(0) != "", "style_item")
      record(failures, style.get_parent_rule() is None, "style_parent_rule")
      @dom.IsHtmlElement::set_style_declaration(html, style)
      style.set_css_float("left")
      record(failures, style.get_css_float() == "left", "css_float")
      style.set_css_text(
        "width: 320px; height: 180px; overflow: scroll; border: 2px solid black;",
      )
      record(failures, style.get_css_text().contains("width"), "css_text")
      record(
        failures,
        {
          ignore(style.remove_property("border"))
          style.get_property_value("border") == ""
        },
        "remove_style_property",
      )
      record(
        failures,
        @dom.IsElement::get_client_width(root) > 0.0,
        "client_width",
      )
      record(
        failures,
        @dom.IsElement::get_client_height(root) > 0.0,
        "client_height",
      )
      record(
        failures,
        @dom.IsElement::get_client_left(root) >= 0.0,
        "client_left",
      )
      record(
        failures,
        @dom.IsElement::get_client_top(root) >= 0.0,
        "client_top",
      )
      let client_rects = @dom.IsElement::get_client_rects(root)
      record(failures, client_rects.length() >= 1, "client_rects")
      record(
        failures,
        client_rects.item(0.0).to_option() is Some(_),
        "client_rects_item",
      )
      if client_rects.item(0.0).to_option() is Some(first_rect) {
        let original_width = first_rect.get_width()
        style.set_property("width", "360px")
        let refreshed = @dom.IsElement::get_client_rects(root)
        record(
          failures,
          first_rect.get_width() == original_width &&
          refreshed.item(0.0).to_option() is Some(next_rect) &&
          next_rect.get_width() > original_width,
          "client_rects_static_snapshot",
        )
        style.set_property("width", "320px")
      }
      let rect = @dom.IsElement::get_bounding_client_rect(root)
      record(failures, rect.get_width() > 0.0, "rect_width")
      record(failures, rect.get_height() > 0.0, "rect_height")
      record(failures, rect.get_right() >= rect.get_left(), "rect_horizontal")
      record(failures, rect.get_bottom() >= rect.get_top(), "rect_vertical")
      record(failures, rect.get_x() == rect.get_left(), "rect_x")
      record(failures, rect.get_y() == rect.get_top(), "rect_y")
      record(
        failures,
        @dom.IsElement::get_scroll_width(root) >=
        @dom.IsElement::get_client_width(root),
        "scroll_width",
      )
      record(
        failures,
        @dom.IsElement::get_scroll_height(root) >=
        @dom.IsElement::get_client_height(root),
        "scroll_height",
      )
      @dom.IsElement::set_scroll_top(root, 10.0)
      @dom.IsElement::set_scroll_left(root, 10.0)
      record(
        failures,
        @dom.IsElement::get_scroll_top(root) >= 0.0,
        "scroll_top",
      )
      record(
        failures,
        @dom.IsElement::get_scroll_left(root) >= 0.0,
        "scroll_left",
      )
      @dom.IsElement::scroll_into_view(root)
      @dom.IsElement::scroll_into_view_with_options(
        root,
        behavior="auto",
        block="center",
        inline="nearest",
        container="nearest",
      )

      @dom.IsHtmlElement::set_access_key(html, "k")
      record(
        failures,
        @dom.IsHtmlElement::get_access_key(html) == "k",
        "access_key",
      )
      ignore(@dom.IsHtmlElement::get_access_key_label(html))
      @dom.IsHtmlElement::set_auto_capitalize(html, "words")
      record(
        failures,
        @dom.IsHtmlElement::get_auto_capitalize(html) == "words",
        "autocapitalize",
      )
      @dom.IsHtmlElement::set_auto_focus(html, true)
      record(failures, @dom.IsHtmlElement::get_auto_focus(html), "autofocus")
      ignore(@dom.IsHtmlElement::get_anchor_element(html))
      @dom.IsHtmlElement::set_auto_correct(html, false)
      record(
        failures,
        !@dom.IsHtmlElement::get_auto_correct(html),
        "autocorrect",
      )
      @dom.IsHtmlElement::set_content_editable(html, "true")
      record(
        failures,
        @dom.IsHtmlElement::get_content_editable(html) == "true",
        "content_editable",
      )
      record(
        failures,
        @dom.IsHtmlElement::get_is_content_editable(html),
        "is_content_editable",
      )
      @dom.IsHtmlElement::set_dir(html, "rtl")
      record(failures, @dom.IsHtmlElement::get_dir(html) == "rtl", "dir")
      @dom.IsHtmlElement::set_draggable(html, true)
      record(failures, @dom.IsHtmlElement::get_draggable(html), "draggable")
      @dom.IsHtmlElement::set_edit_context(html, None)
      record(
        failures,
        @dom.IsHtmlElement::get_edit_context(html) is None,
        "edit_context",
      )
      @dom.IsHtmlElement::set_enter_key_hint(html, "done")
      record(
        failures,
        @dom.IsHtmlElement::get_enter_key_hint(html) == "done",
        "enter_key_hint",
      )
      @dom.IsHtmlElement::set_hidden(html, @js.Value::cast_from(false))
      ignore(@dom.IsHtmlElement::get_hidden(html))
      @dom.IsHtmlElement::set_inert(html, true)
      record(failures, @dom.IsHtmlElement::get_inert(html), "inert")
      @dom.IsHtmlElement::set_inert(html, false)
      @dom.IsHtmlElement::set_input_mode(html, "text")
      record(
        failures,
        @dom.IsHtmlElement::get_input_mode(html) == "text",
        "input_mode",
      )
      @dom.IsHtmlElement::set_lang(html, "en")
      record(failures, @dom.IsHtmlElement::get_lang(html) == "en", "lang")
      @dom.IsHtmlElement::set_nonce(html, "nonce-value")
      record(
        failures,
        @dom.IsHtmlElement::get_nonce(html) == "nonce-value",
        "nonce",
      )
      @dom.IsHtmlElement::set_spellcheck(html, false)
      record(failures, !@dom.IsHtmlElement::get_spellcheck(html), "spellcheck")
      @dom.IsHtmlElement::set_tab_index(html, 0)
      record(
        failures,
        @dom.IsHtmlElement::get_tab_index(html) == 0,
        "tab_index",
      )
      @dom.IsHtmlElement::set_title(html, "probe title")
      record(
        failures,
        @dom.IsHtmlElement::get_title(html) == "probe title",
        "title",
      )
      @dom.IsHtmlElement::set_translate(html, false)
      record(failures, !@dom.IsHtmlElement::get_translate(html), "translate")
      @dom.IsHtmlElement::set_virtual_keyboard_policy(html, "manual")
      record(
        failures,
        @dom.IsHtmlElement::get_virtual_keyboard_policy(html) == "manual",
        "virtual_keyboard_policy",
      )
      @dom.IsHtmlElement::set_writing_suggestions(html, "false")
      record(
        failures,
        @dom.IsHtmlElement::get_writing_suggestions(html) == "false",
        "writing_suggestions",
      )
      let clicks = [0]
      let click_listener : @dom.Listener = _ => clicks[0] += 1
      @dom.IsEventTarget::add_event_listener(html, "click", click_listener)
      @dom.IsHtmlElement::click(html)
      record(failures, clicks[0] == 1, "html_click")
      @dom.IsEventTarget::remove_event_listener(html, "click", click_listener)
      @dom.IsHtmlElement::focus_with_options(html, prevent_scroll=true)
      record(failures, document.get_active_element() is Some(_), "focus")
      @dom.IsHtmlElement::blur(html)
      record(
        failures,
        @dom.IsHtmlElement::get_offset_width(html) >= 0.0,
        "offset_width",
      )
      record(
        failures,
        @dom.IsHtmlElement::get_offset_height(html) >= 0.0,
        "offset_height",
      )
      ignore(@dom.IsHtmlElement::get_offset_left(html))
      ignore(@dom.IsHtmlElement::get_offset_top(html))
      ignore(@dom.IsHtmlElement::get_offset_parent(html))
      ignore(@dom.IsHtmlElement::get_dataset(html))
      ignore(@dom.IsHtmlElement::get_attribute_style_map(html))
      @dom.IsHtmlElement::set_inner_text(html, "inner text probe")
      record(
        failures,
        @dom.IsHtmlElement::get_inner_text(html) == "inner text probe",
        "inner_text",
      )
      record(
        failures,
        physical_equal(@dom.IsHtmlElement::as_html_element(html), html),
        "as_html_element",
      )
    } else {
      failures.push("html_element_conversion")
    }

    let input_element = document.create_element("input")
    if @dom.IsEventTarget::to_html_input_element(input_element) is Some(input) {
      input.set_value("after")
      record(failures, input.value() == "after", "input_value")
      record(
        failures,
        @dom.IsEventTarget::to_html_input_element(input) is Some(_),
        "input_conversion",
      )
    } else {
      failures.push("input_conversion")
    }
    let select_element = document.create_element("select")
    @dom.IsElement::set_inner_html(
      select_element, "<option value='rabbit' selected>Rabbit</option>",
    )
    if @dom.IsEventTarget::to_html_select_element(select_element)
      is Some(select) {
      record(failures, select.value() == "rabbit", "select_value")
    } else {
      failures.push("select_conversion")
    }

    let image = @dom.HTMLImageElement::new_with_size(40.0, 30.0)
    image.set_alt("Rabbit")
    image.set_cross_origin("anonymous")
    image.set_decoding("async")
    image.set_loading("lazy")
    image.set_referrer_policy("no-referrer")
    image.set_sizes("40px")
    image.set_srcset("")
    image.set_use_map("#probe-map")
    image.set_is_map(true)
    image.set_width(42.0)
    image.set_height(32.0)
    record(failures, image.get_alt() == "Rabbit", "image_alt")
    record(
      failures,
      image.get_cross_origin() == "anonymous",
      "image_cross_origin",
    )
    record(failures, image.get_decoding() == "async", "image_decoding")
    record(failures, image.get_loading() == "lazy", "image_loading")
    record(
      failures,
      image.get_referrer_policy() == "no-referrer",
      "image_referrer_policy",
    )
    record(failures, image.get_sizes() == "40px", "image_sizes")
    record(failures, image.get_use_map() == "#probe-map", "image_use_map")
    record(failures, image.get_is_map(), "image_is_map")
    record(failures, image.get_width() == 42.0, "image_width")
    record(failures, image.get_height() == 32.0, "image_height")
    ignore(image.get_complete())
    ignore(image.get_current_src())
    ignore(image.get_natural_width())
    ignore(image.get_natural_height())
    ignore(image.get_src())
    ignore(image.get_srcset())
    ignore(image.get_cross_origin())
    ignore(image.get_x())
    ignore(image.get_y())
    record(
      failures,
      @dom.IsEventTarget::to_html_image_element(image) is Some(_),
      "image_conversion",
    )
    let empty_image = @dom.HTMLImageElement::new()
    empty_image.set_src("")

    let svg = document.create_element_ns(@dom.namespace_svg, "svg")
    @dom.IsElement::set_attribute(svg, "width", "80")
    @dom.IsElement::set_attribute(svg, "height", "40")
    let rect_element = document.create_element_ns(@dom.namespace_svg, "rect")
    @dom.IsElement::set_attribute(rect_element, "width", "20")
    @dom.IsElement::set_attribute(rect_element, "height", "10")
    @dom.IsNode::append_child(svg, @dom.IsNode::as_node(rect_element))
    @dom.IsNode::append_child(root, @dom.IsNode::as_node(svg))
    record(
      failures,
      @dom.IsEventTarget::to_svg_element(svg) is Some(_),
      "svg_conversion",
    )
    if @dom.IsEventTarget::to_svg_element(svg) is Some(svg_element) {
      record(
        failures,
        physical_equal(
          @dom.IsSVGElement::as_svg_element(svg_element),
          svg_element,
        ),
        "as_svg_element",
      )
    }
    if @dom.IsEventTarget::to_svg_graphics_element(rect_element)
      is Some(graphics) {
      let bbox = @dom.IsSVGGraphicsElement::get_bbox(graphics)
      record(failures, bbox.get_width() == 20.0, "svg_bbox")
      ignore(@dom.IsSVGGraphicsElement::get_ctm(graphics))
      ignore(@dom.IsSVGGraphicsElement::get_screen_ctm(graphics))
      ignore(@dom.IsSVGGraphicsElement::get_required_extensions(graphics))
      ignore(@dom.IsSVGGraphicsElement::get_system_language(graphics))
      ignore(@dom.IsSVGGraphicsElement::get_transform(graphics))
      @dom.IsSVGElement::set_tab_index(graphics, 0)
      @dom.IsSVGElement::set_auto_focus(graphics, true)
      record(
        failures,
        @dom.IsSVGElement::get_auto_focus(graphics),
        "svg_autofocus",
      )
      @dom.IsSVGElement::set_nonce(graphics, "svg-nonce")
      record(
        failures,
        @dom.IsSVGElement::get_nonce(graphics) == "svg-nonce",
        "svg_nonce",
      )
      record(
        failures,
        @dom.IsSVGElement::get_tab_index(graphics) == 0,
        "svg_tab_index",
      )
      ignore(@dom.IsSVGElement::get_style(graphics))
      @dom.IsSVGElement::set_style(
        graphics,
        @dom.IsSVGElement::get_style(graphics),
      )
      ignore(@dom.IsSVGElement::get_attribute_style_map(graphics))
      ignore(@dom.IsSVGElement::get_data_set(graphics))
      ignore(@dom.IsSVGElement::get_owner_svg_element(graphics))
      ignore(@dom.IsSVGElement::get_viewport_element(graphics))
      @dom.IsSVGElement::focus(graphics)
      @dom.IsSVGElement::blur(graphics)
      record(
        failures,
        physical_equal(
          @dom.IsSVGGraphicsElement::as_svg_graphics_element(graphics),
          graphics,
        ),
        "as_svg_graphics_element",
      )
    } else {
      failures.push("svg_graphics_conversion")
    }
    let svg_image = document.create_element_ns(@dom.namespace_svg, "image")
    record(
      failures,
      @dom.IsEventTarget::to_svg_image_element(svg_image) is Some(_),
      "svg_image_conversion",
    )

    let outer = document.create_element("span")
    @dom.IsNode::append_child(root, @dom.IsNode::as_node(outer))
    if @dom.IsEventTarget::to_html_element(outer) is Some(outer_html) {
      ignore(@dom.IsHtmlElement::get_outer_text(outer_html))
      @dom.IsHtmlElement::set_outer_text(outer_html, "outer text probe")
    } else {
      failures.push("outer_text_conversion")
    }

    register_internals_probe_element()
    let internals_element = document.create_element("dom-api-internals")
    @dom.IsNode::append_child(body, @dom.IsNode::as_node(internals_element))
    if @dom.IsEventTarget::to_html_element(internals_element) is Some(custom) {
      ignore(@dom.IsHtmlElement::attach_internals(custom))
    } else {
      failures.push("attach_internals_conversion")
    }
    @dom.IsNode::remove_child(body, @dom.IsNode::as_node(internals_element))

    record(
      failures,
      @dom.IsEventTarget::to_element(root) is Some(_),
      "event_target_to_element",
    )
    record(
      failures,
      @dom.IsEventTarget::to_node(root) is Some(_),
      "event_target_to_node",
    )
    record(
      failures,
      @dom.IsEventTarget::to_document(document) is Some(_),
      "event_target_to_document",
    )
    record(
      failures,
      @dom.IsEventTarget::to_window(@dom.window()) is Some(_),
      "event_target_to_window",
    )
    record(
      failures,
      document.element_from_point(1.0, 1.0) is Some(_),
      "element_from_point",
    )
    let point_elements = document.elements_from_point(1.0, 1.0)
    record(
      failures,
      point_elements.length() >= 1 && point_elements.get(0) is Some(_),
      "elements_from_point",
    )

    @dom.IsNode::remove_child(body, @dom.IsNode::as_node(root))
    record(failures, !@dom.IsNode::get_is_connected(root), "cleanup_disconnect")
  } else {
    failures.push("missing_body")
  }
  finish_probe(failures)
}

///|
extern "js" fn register_internals_probe_element() -> Unit =
  #| () => {
  #|   if (!customElements.get('dom-api-internals')) {
  #|     customElements.define('dom-api-internals', class extends HTMLElement {})
  #|   }
  #| }
