///|
#cfg(target="js")
fn first_child(node : @dom.Node) -> @dom.Node? {
  if node.get_child_count() == 0 {
    None
  } else {
    Some(node.get_first_child())
  }
}

///|
/// Returns whether `node` can be claimed by `vnode` during hydration.
///
/// Text content and ordinary attributes are reconciled after claiming, so matching
/// normally uses only the node kind and rendered tag. The `id` attribute and
/// identity-bearing attributes of `meta`, `link`, and `script` are also checked to
/// avoid claiming the wrong same-tag sibling while skipping externally injected nodes.
#cfg(target="js")
fn node_matches(vnode : VNode, node : @dom.Node) -> Bool {
  fn element_identity_matches(
    element : @dom.Element,
    tag : String,
    props : Props,
  ) -> Bool {
    fn attribute_matches(name) {
      if props.attrs.get(name) is Some(expected) {
        element.get_attribute(name) == Some(expected)
      } else {
        true
      }
    }

    if element.get_node_name().to_lower() != rendered_tag(tag).to_lower() {
      return false
    }
    if !attribute_matches("id") {
      return false
    }
    match rendered_tag(tag) {
      "meta" =>
        attribute_matches("charset") &&
        attribute_matches("name") &&
        attribute_matches("property") &&
        attribute_matches("http-equiv")
      "link" => attribute_matches("rel") && attribute_matches("href")
      "script" => attribute_matches("src") && attribute_matches("type")
      _ => true
    }
  }

  match vnode {
    Text(_) => node.get_node_type() == 3
    Elem(tag, props, _, ..) =>
      if node.to_element() is Some(element) {
        element_identity_matches(element, tag, props)
      } else {
        false
      }
    _ => false
  }
}

///|
#cfg(target="js")
fn is_boundary(node : @dom.Node, boundary : @dom.Node?) -> Bool {
  if boundary is Some(boundary) {
    node.is_same_node(boundary)
  } else {
    false
  }
}

///|
#cfg(target="js")
fn fragment_marker(node : @dom.Node, marker : String) -> @dom.Comment? {
  if node.get_node_type() == 8 && node.get_node_value() == marker {
    node.to_comment()
  } else {
    None
  }
}

///|
/// Finds a DOM node that `vnode` can claim without crossing `boundary`.
#cfg(target="js")
fn find_hydratable(
  vnode : VNode,
  current : @dom.Node?,
  boundary : @dom.Node?,
  allow_skip~ : Bool,
) -> @dom.Node? {
  let mut current = current
  while current is Some(node) {
    if is_boundary(node, boundary) {
      return None
    }
    if node_matches(vnode, node) {
      return Some(node)
    }
    if !allow_skip {
      return None
    }
    current = node.get_next_sibling().to_option()
  }
  None
}

///|
#cfg(target="js")
fn recover_mismatch(
  vnode : VNode,
  scheduler : &Scheduler,
  captured_link_listener : @dom.Listener,
  parent : @dom.Node,
  current : @dom.Node?,
  boundary : @dom.Node?,
) -> (INode, @dom.Node?) {
  let inode = vnode.insert(
    scheduler,
    captured_link_listener,
    parent,
    @js.Nullable::from_option(current),
  )
  if current is Some(node) && !is_boundary(node, boundary) {
    let next = node.get_next_sibling().to_option()
    parent.remove_child(node)
    (inode, next)
  } else {
    (inode, current)
  }
}

///|
#cfg(target="js")
fn remove_until(
  parent : @dom.Node,
  current : @dom.Node?,
  boundary : @dom.Node?,
) -> Unit {
  let mut current = current
  while current is Some(node) && !is_boundary(node, boundary) {
    let next = node.get_next_sibling().to_option()
    parent.remove_child(node)
    current = next
  }
}

///|
#cfg(target="js")
fn hydrate_existing_element(
  tag : String,
  props : Props,
  children : Children[VNode],
  namespace_uri : String?,
  element : @dom.Element,
  scheduler : &Scheduler,
  captured_link_listener : @dom.Listener,
  allow_skip_children~ : Bool,
  vnode : VNode,
) -> INode {
  let mounted_props = insert_props(
    element, tag, props, scheduler, captured_link_listener,
  )
  let has_raw_children = props.props.contains("innerHTML") ||
    props.props.contains("textContent")
  let mounted_children = if is_html_void_element(tag) || has_raw_children {
    Array([])
  } else {
    let (mounted, next) = hydrate_children(
      children,
      first_child(element.as_node()),
      scheduler,
      captured_link_listener,
      element.as_node(),
      boundary=None,
      allow_skip=allow_skip_children,
    )
    if !allow_skip_children {
      remove_until(element.as_node(), next, None)
    }
    mounted
  }
  reapply_child_sensitive_properties(element, tag, mounted_props.props)
  Elem(tag, mounted_props, mounted_children, namespace_uri~, element, vnode)
}

///|
#cfg(target="js")
fn hydrate_fragment(
  children : Array[VNode],
  scheduler : &Scheduler,
  captured_link_listener : @dom.Listener,
  parent : @dom.Node,
  current : @dom.Node?,
  boundary~ : @dom.Node?,
  allow_skip~ : Bool,
  vnode : VNode,
) -> (INode, @dom.Node?) {
  fn find_fragment_start(current : @dom.Node?) -> @dom.Comment? {
    let mut current = current
    while current is Some(node) && !is_boundary(node, boundary) {
      if fragment_marker(node, FRAGMENT_START_MARKER) is Some(start) {
        return Some(start)
      }
      if !allow_skip {
        return None
      }
      current = node.get_next_sibling().to_option()
    }
    None
  }

  fn find_fragment_end(current : @dom.Node?) -> @dom.Comment? {
    let mut current = current
    let mut depth = 0
    while current is Some(node) && !is_boundary(node, boundary) {
      if fragment_marker(node, FRAGMENT_START_MARKER) is Some(_) {
        depth += 1
      } else if fragment_marker(node, FRAGMENT_END_MARKER) is Some(end) {
        if depth == 0 {
          return Some(end)
        }
        depth -= 1
      }
      current = node.get_next_sibling().to_option()
    }
    None
  }

  if find_fragment_start(current) is Some(start) {
    let closing = find_fragment_end(start.get_next_sibling().to_option())
    let child_boundary = if closing is Some(end) {
      Some(end.as_node())
    } else {
      boundary
    }
    let (mounted, next) = hydrate_children(
      Array(children),
      start.get_next_sibling().to_option(),
      scheduler,
      captured_link_listener,
      parent,
      boundary=child_boundary,
      allow_skip~,
    )
    let end = if closing is Some(end) {
      if !allow_skip {
        remove_until(parent, next, Some(end.as_node()))
      }
      end
    } else {
      let end = @dom.document().create_comment(FRAGMENT_END_MARKER)
      parent.insert_before(end.as_node(), @js.Nullable::from_option(next))
      end
    }
    let children = if mounted is Array(children) { children } else { [] }
    (Frag(children, start, end, vnode), end.get_next_sibling().to_option())
  } else {
    recover_mismatch(
      vnode, scheduler, captured_link_listener, parent, current, boundary,
    )
  }
}

///|
#cfg(target="js")
fn hydrate_node(
  vnode : VNode,
  scheduler : &Scheduler,
  captured_link_listener : @dom.Listener,
  parent : @dom.Node,
  current : @dom.Node?,
  boundary~ : @dom.Node?,
  allow_skip~ : Bool,
) -> (INode, @dom.Node?) {
  match vnode {
    Thunk(hash, render) => {
      let (inode, next) = hydrate_node(
        render(),
        scheduler,
        captured_link_listener,
        parent,
        current,
        boundary~,
        allow_skip~,
      )
      (Thunk(hash, inode, vnode), next)
    }
    Frag(children) =>
      hydrate_fragment(
        children,
        scheduler,
        captured_link_listener,
        parent,
        current,
        boundary~,
        allow_skip~,
        vnode,
      )
    Text(text) =>
      if find_hydratable(vnode, current, boundary, allow_skip~) is Some(node) {
        if node.get_node_value() != text {
          node.set_node_value(nullable(text))
        }
        let element : @dom.Element = @js.Value::cast_from(node).cast()
        (Text(text, element, vnode), node.get_next_sibling().to_option())
      } else {
        recover_mismatch(
          vnode, scheduler, captured_link_listener, parent, current, boundary,
        )
      }
    Elem(tag, props, children, namespace_uri~) =>
      if find_hydratable(vnode, current, boundary, allow_skip~) is Some(node) &&
        node.to_element() is Some(element) {
        let inode = hydrate_existing_element(
          tag,
          props,
          children,
          namespace_uri,
          element,
          scheduler,
          captured_link_listener,
          allow_skip_children=false,
          vnode,
        )
        (inode, node.get_next_sibling().to_option())
      } else {
        recover_mismatch(
          vnode, scheduler, captured_link_listener, parent, current, boundary,
        )
      }
  }
}

///|
#cfg(target="js")
fn hydrate_children(
  children : Children[VNode],
  current : @dom.Node?,
  scheduler : &Scheduler,
  captured_link_listener : @dom.Listener,
  parent : @dom.Node,
  boundary~ : @dom.Node?,
  allow_skip~ : Bool,
) -> (Children[INode], @dom.Node?) {
  let mut current = current
  match children {
    RawHtml(html) => {
      parent.to_element().unwrap().set_inner_html(html)
      (RawHtml(html), boundary)
    }
    Array(children) => {
      let mounted = []
      for child in children {
        let (inode, next) = hydrate_node(
          child,
          scheduler,
          captured_link_listener,
          parent,
          current,
          boundary~,
          allow_skip~,
        )
        mounted.push(inode)
        current = next
      }
      (Array(mounted), current)
    }
    Map(children) => {
      let mounted : Map[String, INode] = Map([])
      for key, child in children {
        let (inode, next) = hydrate_node(
          child,
          scheduler,
          captured_link_listener,
          parent,
          current,
          boundary~,
          allow_skip~,
        )
        mounted[key] = inode
        current = next
      }
      (Map(mounted), current)
    }
  }
}

///|
#cfg(target="js")
fn hydrate_root(
  vnode : VNode,
  scheduler : &Scheduler,
  captured_link_listener : @dom.Listener,
) -> INode {
  match vnode {
    Elem(
      "html",
      props,
      Array(
        [
          Elem(
            "head",
            head_props,
            head_children,
            namespace_uri=head_namespace_uri
          ) as head_vnode,
          Elem(
            "body",
            body_props,
            body_children,
            namespace_uri=body_namespace_uri
          ) as body_vnode,
        ]
      ),
      ..
    ) => {
      let document = @dom.document()
      let html = document.get_document_element().unwrap()
      let head_element = document.get_head().unwrap().as_element()
      let body_element = document.get_body().unwrap().as_element()
      let html_props = insert_props(
        html, "html", props, scheduler, captured_link_listener,
      )
      let head = hydrate_existing_element(
        "head",
        head_props,
        head_children,
        head_namespace_uri,
        head_element,
        scheduler,
        captured_link_listener,
        allow_skip_children=true,
        head_vnode,
      )
      let body = hydrate_existing_element(
        "body",
        body_props,
        body_children,
        body_namespace_uri,
        body_element,
        scheduler,
        captured_link_listener,
        allow_skip_children=true,
        body_vnode,
      )
      Elem(
        "html",
        html_props,
        Array([head, body]),
        html,
        namespace_uri=None,
        vnode,
      )
    }
    _ => panic()
  }
}
