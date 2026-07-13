///|
#cfg(target="js")
extern "js" fn vdom_test_parent() -> @dom.Node =
  #| () => {
  #|   globalThis.HTMLElement ??= class {};
  #|   const withSiblings = node => {
  #|     Object.defineProperties(node, {
  #|       previousSibling: {
  #|         get() {
  #|           if (this.parentNode === null) return null;
  #|           const index = this.parentNode.childNodes.indexOf(this);
  #|           return index > 0 ? this.parentNode.childNodes[index - 1] : null;
  #|         },
  #|       },
  #|       nextSibling: {
  #|         get() {
  #|           if (this.parentNode === null) return null;
  #|           const siblings = this.parentNode.childNodes;
  #|           const index = siblings.indexOf(this);
  #|           return index >= 0 && index + 1 < siblings.length
  #|             ? siblings[index + 1]
  #|             : null;
  #|         },
  #|       },
  #|     });
  #|     return node;
  #|   };
  #|   const removeNode = (parent, node) => {
  #|     const index = parent.childNodes.indexOf(node);
  #|     if (index >= 0) parent.childNodes.splice(index, 1);
  #|     node.parentNode = null;
  #|     return node;
  #|   };
  #|   const insertNode = (parent, node, before) => {
  #|     if (node.isFragment) {
  #|       for (const child of [...node.childNodes]) {
  #|         insertNode(parent, child, before);
  #|       }
  #|       return node;
  #|     }
  #|     if (node === before) return node;
  #|     const sameParent = node.parentNode === parent;
  #|     if (node.parentNode !== null) {
  #|       const oldIndex = node.parentNode.childNodes.indexOf(node);
  #|       if (oldIndex >= 0) node.parentNode.childNodes.splice(oldIndex, 1);
  #|     }
  #|     const index = before === null
  #|       ? parent.childNodes.length
  #|       : parent.childNodes.indexOf(before);
  #|     parent.childNodes.splice(index, 0, node);
  #|     node.parentNode = parent;
  #|     if (sameParent) parent.relocations += 1;
  #|     return node;
  #|   };
  #|   class FakeElement extends HTMLElement {
  #|     constructor(tag) {
  #|       super();
  #|       this.nodeType = 1;
  #|       this.nodeName = tag.toUpperCase();
  #|       this.parentNode = null;
  #|       this.childNodes = [];
  #|       this.relocations = 0;
  #|       this.listeners = {};
  #|       this.style = {
  #|         setProperty() {},
  #|         removeProperty() {},
  #|       };
  #|       withSiblings(this);
  #|     }
  #|     addEventListener(name, handler) { this.listeners[name] = handler; }
  #|     setAttribute() {}
  #|     removeAttribute() {}
  #|     insertBefore(node, before) {
  #|       return insertNode(this, node, before);
  #|     }
  #|     removeChild(node) {
  #|       return removeNode(this, node);
  #|     }
  #|   }
  #|   globalThis.document = {
  #|     createElement(tag) { return new FakeElement(tag); },
  #|     createTextNode(value) {
  #|       return withSiblings({
  #|         nodeType: 3,
  #|         nodeName: '#text',
  #|         nodeValue: value,
  #|         parentNode: null,
  #|       });
  #|     },
  #|     createComment(value) {
  #|       return withSiblings({
  #|         nodeType: 8,
  #|         nodeName: '#comment',
  #|         nodeValue: value,
  #|         parentNode: null,
  #|       });
  #|     },
  #|     createDocumentFragment() {
  #|       const fragment = withSiblings({
  #|         nodeType: 11,
  #|         nodeName: '#document-fragment',
  #|         nodeValue: null,
  #|         parentNode: null,
  #|         childNodes: [],
  #|         relocations: 0,
  #|         isFragment: true,
  #|       });
  #|       fragment.insertBefore = (node, before) =>
  #|         insertNode(fragment, node, before);
  #|       fragment.appendChild = node => insertNode(fragment, node, null);
  #|       fragment.removeChild = node => removeNode(fragment, node);
  #|       return fragment;
  #|     },
  #|   };
  #|   const parent = {
  #|     childNodes: [],
  #|     relocations: 0,
  #|     insertBefore(node, before) {
  #|       return insertNode(this, node, before);
  #|     },
  #|     removeChild(node) {
  #|       return removeNode(this, node);
  #|     },
  #|   };
  #|   return parent;
  #| }

///|
#cfg(target="js")
extern "js" fn vdom_test_relocations(parent : @dom.Node) -> Int = "(parent) => parent.relocations"

///|
#cfg(target="js")
extern "js" fn reset_vdom_test_relocations(parent : @dom.Node) -> Unit = "(parent) => { parent.relocations = 0; }"

///|
#cfg(target="js")
extern "js" fn vdom_test_child_values(parent : @dom.Node) -> String = "(parent) => parent.childNodes.map(node => node.nodeValue ?? node.nodeName).join(',')"

///|
#cfg(target="js")
test "empty Props maps use copy-on-write isolation" {
  let first = Props::empty()
  let second = Props::empty()
  assert_true(physical_equal(first.attrs, second.attrs))
  assert_true(physical_equal(first.handlers, second.handlers))
  first.set_attribute("class", "first")
  first.set_property("hidden", Boolean(true))
  first.set_style("color", "red")
  first.set_handler("click", fn(_, _) {  })
  assert_true(first.attrs.get("class") is Some("first"))
  assert_true(second.attrs.is_empty())
  assert_true(second.props.is_empty())
  assert_true(second.styles.is_empty())
  assert_true(second.handlers.is_empty())
  let copied = second.copy()
  copied.set_attribute("id", "copy")
  assert_true(second.attrs.is_empty())
}

///|
#cfg(target="js")
fn mount_keyed_for_test(
  vnodes : Map[String, VNode],
  sandbox : Sandbox,
  parent : @dom.Node,
  before : @js.Nullable[@dom.Node],
) -> Children[INode] {
  let mounted = {}
  for key, vnode in vnodes {
    mounted[key] = vnode.insert(sandbox, parent, before)
  }
  Map(mounted)
}

///|
#cfg(target="js")
test "diff reuses an INode for the identical VNode" {
  let parent = vdom_test_parent()
  let sandbox = Sandbox::new()
  let vnode = VNode::text("stable")
  let inode = vnode.insert(sandbox, parent, null())
  let updated = diff_node(inode, vnode, sandbox, parent, null())
  assert_true(physical_equal(inode, updated))
}

///|
#cfg(target="js")
test "thunk reuses its INode without rerendering an equal hash" {
  let parent = vdom_test_parent()
  let sandbox = Sandbox::new()
  let render_count = Ref::{ val: 0 }
  let first = VNode::Thunk(1, () => {
    render_count.val += 1
    VNode::text("first")
  })
  let inode = first.insert(sandbox, parent, null())
  assert_eq(render_count.val, 1)
  let same_hash = VNode::Thunk(1, () => {
    render_count.val += 100
    VNode::text("unused")
  })
  let updated = diff_node(inode, same_hash, sandbox, parent, null())
  assert_eq(render_count.val, 1)
  assert_true(physical_equal(inode, updated))
  let changed_hash = VNode::Thunk(2, () => {
    render_count.val += 1
    VNode::text("second")
  })
  ignore(diff_node(updated, changed_hash, sandbox, parent, null()))
  assert_eq(render_count.val, 2)
}

///|
#cfg(target="js")
test "sharing a VNode keeps listener slots local to each mount" {
  let parent = vdom_test_parent()
  let sandbox = Sandbox::new()
  let props = Props::new({}, {}, {}, { "click": fn(_, _) {  } })
  let vnode = VNode::elem("button", props, Array([]))
  let first = vnode.insert(sandbox, parent, null())
  let second = vnode.insert(sandbox, parent, null())
  assert_true(props.slots.is_empty())
  match (first, second) {
    (
      Elem(_, _, first_props, _, namespace_uri=_, _),
      Elem(_, _, second_props, _, namespace_uri=_, _),
    ) => {
      guard pairs_get(first_props.slots, "click") is Some(first_slot) else {
        fail("first mount has no click listener slot")
      }
      guard pairs_get(second_props.slots, "click") is Some(second_slot) else {
        fail("second mount has no click listener slot")
      }
      assert_false(physical_equal(first_slot, second_slot))
    }
    _ => fail("expected two mounted elements")
  }
}

///|
#cfg(target="js")
test "keyed diff leaves an unchanged order in place" {
  let parent = vdom_test_parent()
  let sandbox = Sandbox::new()
  let anchor = VNode::text("anchor").insert(sandbox, parent, null())
  let before = nullable(anchor.start())
  let a = VNode::text("a")
  let b = VNode::text("b")
  let c = VNode::text("c")
  let vnode_map = Map::from_array([("a", a), ("b", b), ("c", c)])
  let children : Children[VNode] = Map(vnode_map)
  let mounted = mount_keyed_for_test(vnode_map, sandbox, parent, before)
  reset_vdom_test_relocations(parent)
  let mounted = diff_children(mounted, children, sandbox, parent, before)
  assert_eq(vdom_test_relocations(parent), 0)
  assert_eq(vdom_test_child_values(parent), "a,b,c,anchor")
  // The returned INode map must retain new-key order for the next frame.
  reset_vdom_test_relocations(parent)
  ignore(diff_children(mounted, children, sandbox, parent, before))
  assert_eq(vdom_test_relocations(parent), 0)
}

///|
#cfg(target="js")
test "keyed prefix append keeps existing nodes in place" {
  let parent = vdom_test_parent()
  let sandbox = Sandbox::new()
  let anchor = VNode::text("anchor").insert(sandbox, parent, null())
  let before = nullable(anchor.start())
  let a = VNode::text("a")
  let b = VNode::text("b")
  let old_map = Map::from_array([("a", a), ("b", b)])
  let mounted = mount_keyed_for_test(old_map, sandbox, parent, before)
  let appended : Children[VNode] = Map(
    Map::from_array([
      ("a", a),
      ("b", b),
      ("c", VNode::text("c")),
      ("d", VNode::text("d")),
    ]),
  )
  reset_vdom_test_relocations(parent)
  ignore(diff_children(mounted, appended, sandbox, parent, before))
  assert_eq(vdom_test_relocations(parent), 0)
  assert_eq(vdom_test_child_values(parent), "a,b,c,d,anchor")
}

///|
#cfg(target="js")
test "keyed deletion subsequence removes without relocating survivors" {
  let parent = vdom_test_parent()
  let sandbox = Sandbox::new()
  let anchor = VNode::text("anchor").insert(sandbox, parent, null())
  let before = nullable(anchor.start())
  let a = VNode::text("a")
  let b = VNode::text("b")
  let c = VNode::text("c")
  let d = VNode::text("d")
  let old_map = Map::from_array([("a", a), ("b", b), ("c", c), ("d", d)])
  let mounted = mount_keyed_for_test(old_map, sandbox, parent, before)
  let removed : Children[VNode] = Map(
    Map::from_array([("a", a), ("c", c), ("d", d)]),
  )
  reset_vdom_test_relocations(parent)
  ignore(diff_children(mounted, removed, sandbox, parent, before))
  assert_eq(vdom_test_relocations(parent), 0)
  assert_eq(vdom_test_child_values(parent), "a,c,d,anchor")
}

///|
#cfg(target="js")
test "keyed diff moves only nodes outside the LIS for a distant swap" {
  let parent = vdom_test_parent()
  let sandbox = Sandbox::new()
  let anchor = VNode::text("anchor").insert(sandbox, parent, null())
  let before = nullable(anchor.start())
  let a = VNode::text("a")
  let b = VNode::Thunk(1, () => VNode::text("b"))
  let c = VNode::text("c")
  let d = VNode::Thunk(2, () => VNode::text("d"))
  let e = VNode::text("e")
  let old_map = Map::from_array([
    ("a", a),
    ("b", b),
    ("c", c),
    ("d", d),
    ("e", e),
  ])
  let mounted = mount_keyed_for_test(old_map, sandbox, parent, before)
  let swapped : Children[VNode] = Map(
    Map::from_array([("a", a), ("d", d), ("c", c), ("b", b), ("e", e)]),
  )
  reset_vdom_test_relocations(parent)
  let mounted = diff_children(mounted, swapped, sandbox, parent, before)
  assert_eq(vdom_test_relocations(parent), 2)
  assert_eq(vdom_test_child_values(parent), "a,d,c,b,e,anchor")
  reset_vdom_test_relocations(parent)
  ignore(diff_children(mounted, swapped, sandbox, parent, before))
  assert_eq(vdom_test_relocations(parent), 0)
}

///|
#cfg(target="js")
test "keyed diff inserts and removes around the supplied anchor" {
  let parent = vdom_test_parent()
  let sandbox = Sandbox::new()
  let anchor = VNode::text("anchor").insert(sandbox, parent, null())
  let before = nullable(anchor.start())
  let a = VNode::text("a")
  let b = VNode::text("b")
  let c = VNode::text("c")
  let old_map = Map::from_array([("a", a), ("b", b), ("c", c)])
  let mounted = mount_keyed_for_test(old_map, sandbox, parent, before)
  let next : Children[VNode] = Map(
    Map::from_array([("b", b), ("x", VNode::text("x")), ("a", a)]),
  )
  reset_vdom_test_relocations(parent)
  ignore(diff_children(mounted, next, sandbox, parent, before))
  assert_eq(vdom_test_relocations(parent), 1)
  assert_eq(vdom_test_child_values(parent), "b,x,a,anchor")
}

///|
#cfg(target="js")
test "a stable key can replace its VNode kind and element tag" {
  let parent = vdom_test_parent()
  let sandbox = Sandbox::new()
  let anchor = VNode::text("anchor").insert(sandbox, parent, null())
  let before = nullable(anchor.start())
  let b = VNode::text("b")
  let old_map = Map::from_array([("a", VNode::text("a")), ("b", b)])
  let mounted = mount_keyed_for_test(old_map, sandbox, parent, before)
  let empty_props = Props::new({}, {}, {}, {})
  let with_element : Children[VNode] = Map(
    Map::from_array([
      ("a", VNode::elem("div", empty_props, Array([]))),
      ("b", b),
    ]),
  )
  let mounted = diff_children(mounted, with_element, sandbox, parent, before)
  assert_eq(vdom_test_child_values(parent), "DIV,b,anchor")
  let with_new_tag : Children[VNode] = Map(
    Map::from_array([
      ("a", VNode::elem("span", Props::new({}, {}, {}, {}), Array([]))),
      ("b", b),
    ]),
  )
  ignore(diff_children(mounted, with_new_tag, sandbox, parent, before))
  assert_eq(vdom_test_child_values(parent), "SPAN,b,anchor")
}

///|
#cfg(target="js")
test "a non-LIS replacement is inserted without a redundant relocation" {
  let parent = vdom_test_parent()
  let sandbox = Sandbox::new()
  let anchor = VNode::text("anchor").insert(sandbox, parent, null())
  let before = nullable(anchor.start())
  let a = VNode::text("a")
  let b = VNode::text("b")
  let old_map = Map::from_array([
    ("a", a),
    ("b", b),
    ("c", VNode::text("old-c")),
  ])
  let mounted = mount_keyed_for_test(old_map, sandbox, parent, before)
  let next : Children[VNode] = Map(
    Map::from_array([
      ("c", Thunk(1, () => VNode::text("new-c"))),
      ("a", a),
      ("b", b),
    ]),
  )
  reset_vdom_test_relocations(parent)
  ignore(diff_children(mounted, next, sandbox, parent, before))
  assert_eq(vdom_test_relocations(parent), 0)
  assert_eq(vdom_test_child_values(parent), "new-c,a,b,anchor")
}

///|
#cfg(target="js")
test "keyed LIS relocation keeps a fragment range intact" {
  let parent = vdom_test_parent()
  let sandbox = Sandbox::new()
  let anchor = VNode::text("anchor").insert(sandbox, parent, null())
  let before = nullable(anchor.start())
  let fragment = VNode::fragment([VNode::text("f1"), VNode::text("f2")])
  let thunk = VNode::Thunk(1, () => VNode::text("t"))
  let z = VNode::text("z")
  let old_map = Map::from_array([
    ("fragment", fragment),
    ("thunk", thunk),
    ("z", z),
  ])
  let mounted = mount_keyed_for_test(old_map, sandbox, parent, before)
  let reordered : Children[VNode] = Map(
    Map::from_array([("thunk", thunk), ("z", z), ("fragment", fragment)]),
  )
  ignore(diff_children(mounted, reordered, sandbox, parent, before))
  assert_eq(vdom_test_child_values(parent), "t,z,start,f1,f2,end,anchor")
}
