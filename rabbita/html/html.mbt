///|
using @runtime {type VNode}

///|
using @cmd {type Cmd, type Emit}

///|
#alias(T)
pub(all) struct Html(@runtime.VNode) derive(Eq)

///|
pub fn Html::to_virtual_dom(self : Html) -> @runtime.VNode {
  self.0
}

///|
pub fn Html::from_vnode(vdom : @runtime.VNode) -> Html {
  Html(vdom)
}

///|
pub fn[C : IsChildren] node(tag : String, attrs : Attrs, children : C) -> Html {
  let props = attrs.to_props()
  VNode::elem(tag, props, children.to_children())
}

///|
fn resolve_attrs(attrs : Attrs?) -> Attrs {
  match attrs {
    Some(a) => a.copy()
    None => Attrs::build()
  }
}

///|
/// Represents an empty element
pub let nothing : Html = VNode::fragment([])

///|
pub fn fragment(children : Array[Html]) -> Html {
  @runtime.VNode::fragment(children.map(x => x.0))
}

///|
/// Defer constructing a subtree until it is mounted or rendered.
///
/// On the client, Rabbita reuses the previously mounted subtree while `hash`
/// stays the same. Change `hash` whenever any value captured by `render`
/// changes; otherwise the DOM for this subtree will intentionally stay stale.
///
/// ```mbt check
/// test {
///   let name = "Rabbita"
///   let greeting = lazy(name.hash(), () => p("Hello, \{name}!"))
///   ignore(greeting)
/// }
/// ```
pub fn lazy(hash : Int, render : () -> Html) -> Html {
  @runtime.VNode::thunk(hash, () => render().0)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/button)
pub fn[C : IsChildren] button(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  type_? : String,
  disabled? : Bool,
  name? : String,
  value? : String,
  autofocus? : Bool,
  on_click? : Cmd,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_type(type_, attrs)
  push_disabled(disabled, attrs)
  push_name(name, attrs)
  push_value_attr_string(value, attrs)
  push_autofocus(autofocus, attrs)
  push_click(on_click, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("button", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/h1)
pub fn[C : IsChildren] h1(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  cite? : String,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_cite(cite, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("h1", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/h2)
pub fn[C : IsChildren] h2(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("h2", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/h3)
pub fn[C : IsChildren] h3(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("h3", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/h4)
pub fn[C : IsChildren] h4(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("h4", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/h5)
pub fn[C : IsChildren] h5(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("h5", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/h6)
pub fn[C : IsChildren] h6(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("h6", attrs, children)
}

// ------ grouping content ------

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/div)
pub fn[C : IsChildren] div(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  on_click? : Cmd,
  on_mousedown? : Emit[Mouse],
  on_mouseup? : Emit[Mouse],
  on_scroll? : Emit[Scroll],
  on_keydown? : Emit[Keyboard],
  on_keyup? : Emit[Keyboard],
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_click(on_click, attrs)
  push_mousedown(on_mousedown, attrs)
  push_mouseup(on_mouseup, attrs)
  push_scroll(on_scroll, attrs)
  push_keydown(on_keydown, attrs)
  push_keyup(on_keyup, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("div", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/p)
pub fn[C : IsChildren] p(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("p", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/hr)
pub fn hr(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : Attrs,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("hr", attrs, ([] : Array[Html]))
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/pre)
pub fn[C : IsChildren] pre(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("pre", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/blockquote)
pub fn[C : IsChildren] blockquote(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("blockquote", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/section)
pub fn[C : IsChildren] section(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("section", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/header)
pub fn[C : IsChildren] header(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("header", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/footer)
pub fn[C : IsChildren] footer(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("footer", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/nav)
pub fn[C : IsChildren] nav(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("nav", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/main)
pub fn[C : IsChildren] main_(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("main", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/article)
pub fn[C : IsChildren] article(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("article", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/aside)
pub fn[C : IsChildren] aside(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("aside", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/figure)
pub fn[C : IsChildren] figure(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("figure", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/figcaption)
pub fn[C : IsChildren] figcaption(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("figcaption", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/details)
pub fn[C : IsChildren] details(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  open? : Bool,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_open(open, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("details", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/summary)
pub fn[C : IsChildren] summary(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("summary", attrs, children)
}

// ---- text ----

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/span)
pub fn[C : IsChildren] span(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("span", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/small)
pub fn[C : IsChildren] small(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("small", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/mark)
pub fn[C : IsChildren] mark(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("mark", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/del)
pub fn[C : IsChildren] del(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("del", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/ins)
pub fn[C : IsChildren] ins(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("ins", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/s)
pub fn[C : IsChildren] s(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("s", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/cite)
pub fn[C : IsChildren] cite(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("cite", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/q)
pub fn[C : IsChildren] q(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("q", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/abbr)
pub fn[C : IsChildren] abbr(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("abbr", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/kbd)
pub fn[C : IsChildren] kbd(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("kbd", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/samp)
pub fn[C : IsChildren] samp(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("samp", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/var)
pub fn[C : IsChildren] var_(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("var", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/time)
pub fn[C : IsChildren] time(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  datetime? : String,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_datetime(datetime, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("time", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/address)
pub fn[C : IsChildren] address(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("address", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/a)
/// Create `a` element.
/// 
/// # Parameters
/// 
/// - `escape`: an optional boolean that determines whether the link 
///  should be escaped. By default, it is set to `false`. 
/// 
///   When `escape` is set to `true`, clicking the escaped link will cause the browser 
///   to immediately navigate to the `href` target, bypassing any interception logic. 
///   As a result, the `UrlRequest` message will not be triggered.
/// 
/// - `target`: an optional `Target` that specifies where to open the link.
/// 
/// If the user holds the `ctrl` key (or the command key on macOS) while clicking the link,
/// the click event will be handled by the browser, and the `UrlRequest` will not be triggered either.
///
/// If `App::with_route(url_request=...)` is not configured, browser native navigation
/// is used as well.
pub fn[C : IsChildren] a(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  href~ : String,
  target? : Target = Self,
  rel? : String,
  download? : String,
  attrs? : Attrs,
  children : C,
  escape? : Bool = false,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  ignore(attrs.attribute("href", href))
  ignore(attrs.target(target))
  push_rel(rel, attrs)
  push_download(download, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  @runtime.VNode::link(attrs.to_props(), children.to_children(), escape~)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/code)
pub fn[C : IsChildren] code(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("code", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/em)
pub fn[C : IsChildren] em(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("em", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/strong)
pub fn[C : IsChildren] strong(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("strong", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/i)
pub fn[C : IsChildren] i(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("i", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/b)
pub fn[C : IsChildren] b(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("b", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/u)
pub fn[C : IsChildren] u(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("u", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/sub)
pub fn[C : IsChildren] sub(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("sub", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/sup)
pub fn[C : IsChildren] sup(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("sup", attrs, children)
}

///|
pub fn text(str : String) -> Html {
  VNode::text(str)
}

// ---- lists ----

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/ul)
pub fn[C : IsChildren] ul(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  on_click? : Cmd,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_click(on_click, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("ul", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/ol)
/// Notice that the `type` attribute for `ol` is not important for the browser now.
/// If you want to change the type of the list, you should use the `list-style-type` property in CSS.
pub fn[C : IsChildren] ol(
  style? : Array[String] = [],
  reversed? : Bool,
  start? : Int,
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_reversed(reversed, attrs)
  push_start(start, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("ol", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/li)
pub fn[C : IsChildren] li(
  style? : Array[String] = [],
  value? : Int,
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  on_click? : Cmd,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_click(on_click, attrs)
  push_value_attr_int(value, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("li", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/dl)
pub fn[C : IsChildren] dl(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("dl", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/dt)
pub fn[C : IsChildren] dt(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("dt", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/dd)
pub fn[C : IsChildren] dd(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("dd", attrs, children)
}

// ---- embbded content ----

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/img)
pub fn img(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  hidden? : Bool,
  src? : String,
  alt? : String,
  title? : String,
  width? : Int,
  height? : Int,
  srcset? : String,
  sizes? : String,
  loading? : String,
  decoding? : String,
  attrs? : Attrs,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_hidden(hidden, attrs)
  push_src(src, attrs)
  push_alt(alt, attrs)
  push_title(title, attrs)
  push_width(width, attrs)
  push_height(height, attrs)
  push_srcset(srcset, attrs)
  push_sizes(sizes, attrs)
  push_loading(loading, attrs)
  push_decoding(decoding, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("img", attrs, ([] : Array[Html]))
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/iframe)
pub fn iframe(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  hidden? : Bool,
  src? : String,
  title? : String,
  width? : Int,
  height? : Int,
  loading? : String,
  allow? : String,
  sandbox? : String,
  allowfullscreen? : Bool,
  attrs? : Attrs,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_hidden(hidden, attrs)
  push_src(src, attrs)
  push_title(title, attrs)
  push_width(width, attrs)
  push_height(height, attrs)
  push_loading(loading, attrs)
  push_allow(allow, attrs)
  push_sandbox(sandbox, attrs)
  push_allowfullscreen(allowfullscreen, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("iframe", attrs, ([] : Array[Html]))
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/fencedframe)
pub fn fencedframe(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  hidden? : Bool,
  src? : String,
  title? : String,
  width? : Int,
  height? : Int,
  loading? : String,
  allow? : String,
  sandbox? : String,
  allowfullscreen? : Bool,
  attrs? : Attrs,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_hidden(hidden, attrs)
  push_src(src, attrs)
  push_title(title, attrs)
  push_width(width, attrs)
  push_height(height, attrs)
  push_loading(loading, attrs)
  push_allow(allow, attrs)
  push_sandbox(sandbox, attrs)
  push_allowfullscreen(allowfullscreen, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("fencedframe", attrs, ([] : Array[Html]))
}

// ---- inputs ----

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/br)
pub fn br(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : Attrs,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("br", attrs, ([] : Array[Html]))
}

///|
pub(all) enum InputType {
  Button
  Checkbox
  Color
  Date
  DateTimeLocal
  Email
  File
  Hidden
  Image
  Month
  Number
  Password
  Radio
  Range
  Reset
  Search
  Submit
  Tel
  Text
  Time
  Url
  Week
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/form)
///
/// `on_submit` will call `prevent_default()` before dispatching the command.
/// If you need the browser default behavior, use `attrs` with `Attrs::on_submit`.
pub fn[C : IsChildren] form(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  action? : String,
  name? : String,
  on_submit? : Cmd,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_action(action, attrs)
  push_name(name, attrs)
  push_submit(on_submit, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("form", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/label)
pub fn[C : IsChildren] label(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  for_? : String,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_for(for_, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("label", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/fieldset)
pub fn[C : IsChildren] fieldset(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  disabled? : Bool,
  name? : String,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_disabled(disabled, attrs)
  push_name(name, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("fieldset", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/legend)
pub fn[C : IsChildren] legend(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("legend", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/input)
pub fn input(
  input_type? : InputType = Text,
  name? : String,
  value? : String,
  checked? : Bool,
  read_only? : Bool,
  multiple? : Bool,
  accept? : String,
  placeholder? : String,
  auto_complete? : AutoComplete,
  style? : Array[String] = [],
  max? : Int,
  min? : Int,
  step? : Int,
  maxlength? : Int,
  minlength? : Int,
  pattern? : String,
  size? : Int,
  width? : Int,
  height? : Int,
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  required? : Bool,
  autofocus? : Bool,
  list? : String,
  inputmode? : String,
  on_change? : Emit[String],
  on_input? : Emit[String],
  attrs? : Attrs,
) -> Html {
  let input_type = match input_type {
    Button => "button"
    Checkbox => "checkbox"
    Color => "color"
    Date => "date"
    DateTimeLocal => "datetime-local"
    Email => "email"
    File => "file"
    Hidden => "hidden"
    Image => "image"
    Month => "month"
    Number => "number"
    Password => "password"
    Radio => "radio"
    Range => "range"
    Reset => "reset"
    Search => "search"
    Submit => "submit"
    Tel => "tel"
    Text => "text"
    Time => "time"
    Url => "url"
    Week => "week"
  }
  let auto_complete = match auto_complete {
    Some(On) => "on"
    _ => "off"
  }
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_required(required, attrs)
  push_autofocus(autofocus, attrs)
  push_list(list, attrs)
  push_inputmode(inputmode, attrs)
  ignore(attrs.attribute("type", input_type))
  ignore(attrs.attribute("autocomplete", auto_complete))
  push_name(name, attrs)
  push_value_prop_string(value, attrs)
  push_checked(checked, attrs)
  push_readonly(read_only, attrs)
  push_multiple(multiple, attrs)
  push_accept(accept, attrs)
  push_max(max, attrs)
  push_min(min, attrs)
  push_step(step, attrs)
  push_maxlength(maxlength, attrs)
  push_minlength(minlength, attrs)
  push_pattern(pattern, attrs)
  push_size(size, attrs)
  push_width(width, attrs)
  push_height(height, attrs)
  push_placeholder(placeholder, attrs)
  push_change(on_change, attrs)
  push_input(on_input, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("input", attrs, ([] : Array[Html]))
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/textarea)
pub fn[C : IsChildren] textarea(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  name? : String,
  value? : String,
  rows? : Int,
  cols? : Int,
  placeholder? : String,
  read_only? : Bool,
  disabled? : Bool,
  maxlength? : Int,
  minlength? : Int,
  required? : Bool,
  autofocus? : Bool,
  wrap? : String,
  on_change? : Emit[String],
  on_input? : Emit[String],
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_name(name, attrs)
  push_value_prop_string(value, attrs)
  push_rows(rows, attrs)
  push_cols(cols, attrs)
  push_placeholder(placeholder, attrs)
  push_readonly(read_only, attrs)
  push_disabled(disabled, attrs)
  push_maxlength(maxlength, attrs)
  push_minlength(minlength, attrs)
  push_required(required, attrs)
  push_autofocus(autofocus, attrs)
  push_wrap(wrap, attrs)
  push_change(on_change, attrs)
  push_input(on_input, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("textarea", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/select)
pub fn[C : IsChildren] select(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  disabled? : Bool,
  name? : String,
  multiple? : Bool,
  size? : Int,
  required? : Bool,
  autofocus? : Bool,
  on_change? : Emit[String],
  attrs? : Attrs,
  children : C,
) -> Html {
  // TODO: support more attribute for select tag
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_disabled(disabled, attrs)
  push_name(name, attrs)
  push_multiple(multiple, attrs)
  push_size(size, attrs)
  push_required(required, attrs)
  push_autofocus(autofocus, attrs)
  push_change(on_change, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("select", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/optgroup)
pub fn[C : IsChildren] optgroup(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  label? : String,
  disabled? : Bool,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_label(label, attrs)
  push_disabled(disabled, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("optgroup", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/option)
pub fn[C : IsChildren] option(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  label? : String,
  disabled? : Bool,
  value? : String,
  selected? : Bool = false,
  attrs? : Attrs,
  children : C,
) -> Html {
  // TODO: support more attribute for option tag

  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_label(label, attrs)
  push_disabled(disabled, attrs)
  push_value_attr_string(value, attrs)
  ignore(attrs.property("selected", @variant.Boolean(selected)))
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("option", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/datalist)
pub fn[C : IsChildren] datalist(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("datalist", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/output)
pub fn[C : IsChildren] output(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  name? : String,
  for_? : String,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_name(name, attrs)
  push_for(for_, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("output", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/progress)
pub fn[C : IsChildren] progress(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  value? : Int,
  max? : Int,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_value_attr_int(value, attrs)
  push_max(max, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("progress", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/meter)
pub fn[C : IsChildren] meter(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  value? : Int,
  min? : Int,
  max? : Int,
  low? : Int,
  high? : Int,
  optimum? : Int,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_value_attr_int(value, attrs)
  push_min(min, attrs)
  push_max(max, attrs)
  push_low(low, attrs)
  push_high(high, attrs)
  push_optimum(optimum, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("meter", attrs, children)
}

// ///|
// pub fn external(
//   node : @dom.Node,
//   attrs : Ref[Attrs?],
//   width~ : Int,
//   height~ : Int,
// ) -> Html {
//   let attrs = attrs.map(_.map(_.map(x => x.0)))
//   @runtime.external(node, attrs, width~, height~)
// }

// table

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/table)
pub fn[C : IsChildren] table(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("table", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/caption)
pub fn[C : IsChildren] caption(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("caption", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/thead)
pub fn[C : IsChildren] thead(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("thead", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/tbody)
pub fn[C : IsChildren] tbody(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("tbody", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/col)
pub fn col(
  style? : Array[String] = [],
  id? : String,
  span? : Int,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : Attrs,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_span(span, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("col", attrs, ([] : Array[Html]))
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/colgroup)
pub fn[C : IsChildren] colgroup(
  style? : Array[String] = [],
  id? : String,
  span? : Int,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_span(span, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("colgroup", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/tr)
pub fn[C : IsChildren] tr(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("tr", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/td)
pub fn[C : IsChildren] td(
  style? : Array[String] = [],
  id? : String,
  colspan? : Int,
  rowspan? : Int,
  headers? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_colspan(colspan, attrs)
  push_rowspan(rowspan, attrs)
  push_headers(headers, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("td", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/th)
pub fn[C : IsChildren] th(
  style? : Array[String] = [],
  id? : String,
  abbr? : String,
  colspan? : Int,
  rowspan? : Int,
  headers? : String,
  scope? : Scope,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_colspan(colspan, attrs)
  push_rowspan(rowspan, attrs)
  push_headers(headers, attrs)
  push_abbr(abbr, attrs)
  push_scope(scope, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("th", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/tfoot)
pub fn[C : IsChildren] tfoot(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("tfoot", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/dialog)
/// Dialog element. 
/// 
/// Hint: You can use the `show` and `close` commands in the `@dialog` package
/// to manipulate the dialog.
///
/// # Attributes
/// 
/// - `open`: indicates whether the dialog is open or closed by default.
/// 
/// - `closedby`: emits the limited-support browser `closedby` attribute.
///   Rabbita does not polyfill dismissal behavior.
///
/// # Messages
/// 
/// - `close`: triggered when the dialog is closed. 
///   
///   The string payload of the `close` message is the return value of the dialog.
/// 
/// - `cancel`: triggered when the user instructs the browser that they wish to 
///   dismiss the current open dialog.
/// 
///   It can be triggered when the user presses `esc` or uses the `request_close` command.
/// 
///   If the `cancel` argument is provided, **the dialog will not close automatically** 
///   after this message is triggered. You can use the `@dialog.close` command 
///   to close it or `@cmd.none` to keep it open.
/// 
/// # Example
/// 
/// ```moonbit skip
/// typealias Model = String
///
/// enum Msg {
///   Open
///   Closed(String)
///   YesNo(Bool)
/// }
///
/// fn update(msg : Msg, model : Model) -> (Cmd[Msg], Model) {
///   match msg {
///     Open => (@dialog.show("confirm"), model)
///     YesNo(answer) => (@dialog.close("confirm", return_value=answer.to_string()), model) 
///     Closed(value) => (none(), value)
///   }
/// }
///
/// fn view(model : Model) -> Html {
///   div([
///     h1([text(model)]),
///     button(on_click=Msg::Open, [text("open")]),
///     dialog(id="confirm", on_close=Msg::Closed, [
///       p([text("Are you sure?")]),
///       button(on_click=YesNo(true), [text("Yes")]),
///       button(on_click=YesNo(false), [text("No")]),
///     ]),
///   ])
/// }
/// ```
/// 
pub fn[C : IsChildren] dialog(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  open? : Bool,
  closedby? : String,
  on_close? : Emit[String],
  on_cancel? : Cmd,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_open(open, attrs)
  push_closedby(closedby, attrs)
  push_close(on_close, attrs)
  push_cancel(on_cancel, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("dialog", attrs, children)
}

// ---- document ----

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/html)
pub fn[C : IsChildren] html(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  lang? : String,
  dir? : String,
  hidden? : Bool,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_lang(lang, attrs)
  push_dir(dir, attrs)
  push_hidden(hidden, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("html", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/head)
pub fn[C : IsChildren] head(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("head", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/body)
pub fn[C : IsChildren] body(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  lang? : String,
  dir? : String,
  hidden? : Bool,
  on_scroll? : Emit[Scroll],
  on_keydown? : Emit[Keyboard],
  on_keyup? : Emit[Keyboard],
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_lang(lang, attrs)
  push_dir(dir, attrs)
  push_hidden(hidden, attrs)
  push_scroll(on_scroll, attrs)
  push_keydown(on_keydown, attrs)
  push_keyup(on_keyup, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("body", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/title)
pub fn[C : IsChildren] title(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("title", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/base)
pub fn base(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  href? : String,
  target? : String,
  attrs? : Attrs,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_href(href, attrs)
  push_target(target, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("base", attrs, ([] : Array[Html]))
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/meta)
pub fn meta(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  charset? : String,
  name? : String,
  content? : String,
  http_equiv? : String,
  attrs? : Attrs,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_charset(charset, attrs)
  push_name(name, attrs)
  push_content(content, attrs)
  push_http_equiv(http_equiv, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("meta", attrs, ([] : Array[Html]))
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/link)
pub fn link(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  href? : String,
  rel? : String,
  type_? : String,
  media? : String,
  sizes? : String,
  attrs? : Attrs,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_href(href, attrs)
  push_rel(rel, attrs)
  push_type(type_, attrs)
  push_media(media, attrs)
  push_sizes(sizes, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("link", attrs, ([] : Array[Html]))
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/style)
pub fn[C : IsChildren] style_tag(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("style", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/script)
pub fn[C : IsChildren] script(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  src? : String,
  type_? : String,
  async_? : Bool,
  defer_? : Bool,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_src(src, attrs)
  push_type(type_, attrs)
  push_async(async_, attrs)
  push_defer(defer_, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("script", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/noscript)
pub fn[C : IsChildren] noscript(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("noscript", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/template)
pub fn[C : IsChildren] template(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("template", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/slot)
pub fn[C : IsChildren] slot(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("slot", attrs, children)
}

// ---- inline text (attrs) ----

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/data)
pub fn[C : IsChildren] data(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("data", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/dfn)
pub fn[C : IsChildren] dfn(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("dfn", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/bdi)
pub fn[C : IsChildren] bdi(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("bdi", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/bdo)
pub fn[C : IsChildren] bdo(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("bdo", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/ruby)
pub fn[C : IsChildren] ruby(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("ruby", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/rt)
pub fn[C : IsChildren] rt(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("rt", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/rp)
pub fn[C : IsChildren] rp(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("rp", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/wbr)
pub fn wbr(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : Attrs,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("wbr", attrs, ([] : Array[Html]))
}

// ---- sectioning (attrs) ----

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/hgroup)
pub fn[C : IsChildren] hgroup(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("hgroup", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/menu)
pub fn[C : IsChildren] menu(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("menu", attrs, children)
}

// ---- embedded content (attrs) ----

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/canvas)
pub fn[C : IsChildren] canvas(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  on_mousedown? : Emit[Mouse],
  on_mouseup? : Emit[Mouse],
  on_scroll? : Emit[Scroll],
  on_keydown? : Emit[Keyboard],
  on_keyup? : Emit[Keyboard],
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_mousedown(on_mousedown, attrs)
  push_mouseup(on_mouseup, attrs)
  push_scroll(on_scroll, attrs)
  push_keydown(on_keydown, attrs)
  push_keyup(on_keyup, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("canvas", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/SVG/Reference/Element/svg)
pub fn[C : IsChildren] svg(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("svg", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/MathML/Reference/Element/math)
pub fn[C : IsChildren] math(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("math", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/picture)
pub fn[C : IsChildren] picture(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("picture", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/audio)
pub fn[C : IsChildren] audio(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  src? : String,
  controls? : Bool,
  autoplay? : Bool,
  loop_? : Bool,
  muted? : Bool,
  preload? : String,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_src(src, attrs)
  push_controls(controls, attrs)
  push_autoplay(autoplay, attrs)
  push_loop(loop_, attrs)
  push_muted(muted, attrs)
  push_preload(preload, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("audio", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/video)
pub fn[C : IsChildren] video(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  src? : String,
  controls? : Bool,
  autoplay? : Bool,
  loop_? : Bool,
  muted? : Bool,
  preload? : String,
  poster? : String,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_src(src, attrs)
  push_controls(controls, attrs)
  push_autoplay(autoplay, attrs)
  push_loop(loop_, attrs)
  push_muted(muted, attrs)
  push_preload(preload, attrs)
  push_poster(poster, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("video", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/map)
pub fn[C : IsChildren] map(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  name? : String,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_name(name, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("map", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/area)
pub fn area(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  alt? : String,
  coords? : String,
  shape? : String,
  href? : String,
  target? : String,
  attrs? : Attrs,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_alt(alt, attrs)
  push_coords(coords, attrs)
  push_shape(shape, attrs)
  push_href(href, attrs)
  push_target(target, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("area", attrs, ([] : Array[Html]))
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/source)
pub fn source(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  src? : String,
  srcset? : String,
  media? : String,
  type_? : String,
  sizes? : String,
  attrs? : Attrs,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_src(src, attrs)
  push_srcset(srcset, attrs)
  push_media(media, attrs)
  push_type(type_, attrs)
  push_sizes(sizes, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("source", attrs, ([] : Array[Html]))
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/track)
pub fn track(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  kind? : String,
  srclang? : String,
  label? : String,
  default? : Bool,
  src? : String,
  attrs? : Attrs,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_kind(kind, attrs)
  push_srclang(srclang, attrs)
  push_label(label, attrs)
  push_default(default, attrs)
  push_src(src, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("track", attrs, ([] : Array[Html]))
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/object)
pub fn[C : IsChildren] object(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("object", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/embed)
pub fn embed(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : Attrs,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("embed", attrs, ([] : Array[Html]))
}

// ---- additional elements ----

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/search)
pub fn[C : IsChildren] search(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("search", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/selectedcontent)
pub fn[C : IsChildren] selectedcontent(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("selectedcontent", attrs, children)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/geolocation)
pub fn[C : IsChildren] geolocation(
  style? : Array[String] = [],
  id? : String,
  class? : String,
  title? : String,
  hidden? : Bool,
  attrs? : Attrs,
  children : C,
) -> Html {
  let attrs = resolve_attrs(attrs)
  push_title(title, attrs)
  push_hidden(hidden, attrs)
  push_style(style, attrs)
  push_class(class, attrs)
  push_id(id, attrs)
  node("geolocation", attrs, children)
}
