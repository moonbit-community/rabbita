///|
using @runtime {type Props}

///|
using @variant {type Variant}

///|
#cfg(target="js")
using @dom {type Event}

///|
#cfg(not(target="js"))
type Event = Unit

///|
struct Attrs(Props)

///|
pub fn Attrs::build() -> Attrs {
  Attrs(Props::empty())
}

///|
fn Attrs::to_props(self : Attrs) -> Props {
  self.0
}

///|
fn Attrs::copy(self : Attrs) -> Attrs {
  Attrs(self.0.copy())
}

///|
/// Sets raw HTML and bypasses normal escaping.
/// 
/// # Vulnerability Warning
///
/// This is **XSS‑prone** and should
/// only be used with trusted or sanitized input. It affects both HTML and SVG
/// content since the browser will parse the string into DOM nodes.
#internal(xss_vulnerable, "This function may cause xss attack.")
pub fn Attrs::inner_html(self : Attrs, html : String) -> Attrs {
  self.0.set_property("innerHTML", @variant.String(html))
  self
}

///|
/// Set a raw attribute.
fn Attrs::attribute(self : Attrs, key : String, value : String) -> Attrs {
  self.0.set_attribute(key, value)
  self
}

///|
/// Set a property.
fn Attrs::property(self : Attrs, key : String, value : Variant) -> Attrs {
  self.0.set_property(key, value)
  self
}

///|
/// Set a style declaration.
pub fn Attrs::style(self : Attrs, key : String, value : String) -> Attrs {
  self.0.set_style(key, value)
  self
}

///|
/// Set an event handler.
fn Attrs::handler(
  self : Attrs,
  key : String,
  value : (Event, &@cmd.Scheduler) -> Unit,
) -> Attrs {
  self.0.set_handler(key, value)
  self
}

///|
pub(all) enum Target {
  Self
  Blank
}

///|
fn Target::to_string(self : Target) -> String {
  match self {
    Self => "_self"
    Blank => "_blank"
  }
}

///|
pub(all) enum AutoComplete {
  On
  Off
}

///|
pub(all) enum Scope {
  Row
  Col
  RowGroup
  ColGroup
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/accept)

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/accept)
pub fn Attrs::accept(self : Attrs, value : String) -> Attrs {
  self.attribute("accept", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/accept-charset)
pub fn Attrs::accept_charset(self : Attrs, value : String) -> Attrs {
  self.attribute("accept-charset", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Global_attributes/accesskey)
pub fn Attrs::accesskey(self : Attrs, value : String) -> Attrs {
  self.attribute("accesskey", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/action)
pub fn Attrs::action(self : Attrs, value : String) -> Attrs {
  self.attribute("action", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/align)
pub fn Attrs::align(self : Attrs, value : String) -> Attrs {
  self.attribute("align", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/allow)
pub fn Attrs::allow(self : Attrs, value : String) -> Attrs {
  self.attribute("allow", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/alpha)
pub fn Attrs::alpha(self : Attrs, value : String) -> Attrs {
  self.attribute("alpha", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/alt)
pub fn Attrs::alt(self : Attrs, value : String) -> Attrs {
  self.attribute("alt", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/as)
pub fn Attrs::as_(self : Attrs, value : String) -> Attrs {
  self.attribute("as", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/async)
pub fn Attrs::async_(self : Attrs, value : Bool) -> Attrs {
  self.property("async", @variant.Boolean(value))
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Global_attributes/autocapitalize)
pub fn Attrs::autocapitalize(self : Attrs, value : String) -> Attrs {
  self.attribute("autocapitalize", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/autocomplete)
pub fn Attrs::autocomplete(self : Attrs, value : AutoComplete) -> Attrs {
  let s = match value {
    On => "on"
    Off => "off"
  }
  self.attribute("autocomplete", s)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/autoplay)
pub fn Attrs::autoplay(self : Attrs, value : Bool) -> Attrs {
  self.property("autoplay", @variant.Boolean(value))
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/background)
pub fn Attrs::background(self : Attrs, value : String) -> Attrs {
  self.attribute("background", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/bgcolor)
pub fn Attrs::bgcolor(self : Attrs, value : String) -> Attrs {
  self.attribute("bgcolor", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/border)
pub fn Attrs::border(self : Attrs, value : Int) -> Attrs {
  self.attribute("border", value.to_string())
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/capture)
pub fn Attrs::capture(self : Attrs, value : String) -> Attrs {
  self.attribute("capture", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/charset)
pub fn Attrs::charset(self : Attrs, value : String) -> Attrs {
  self.attribute("charset", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/checked)
pub fn Attrs::checked(self : Attrs, value : Bool) -> Attrs {
  self.property("checked", @variant.Boolean(value))
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/cite)
pub fn Attrs::cite(self : Attrs, value : String) -> Attrs {
  self.attribute("cite", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Global_attributes/class)
pub fn Attrs::class(self : Attrs, value : String) -> Attrs {
  self.attribute("class", value)
}

///|
/// Set the dialog `closedby` attribute.
///
/// Browser support is limited. Rabbita only emits the attribute; it does not
/// polyfill dismissal behavior. Values include `"none"`, `"closerequest"`,
/// and `"any"`.
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/API/HTMLDialogElement/closedBy)
pub fn Attrs::closedby(self : Attrs, value : String) -> Attrs {
  self.attribute("closedby", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/color)
pub fn Attrs::color(self : Attrs, value : String) -> Attrs {
  self.attribute("color", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/colorspace)
pub fn Attrs::colorspace(self : Attrs, value : String) -> Attrs {
  self.attribute("colorspace", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/cols)
pub fn Attrs::cols(self : Attrs, value : Int) -> Attrs {
  self.attribute("cols", value.to_string())
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/colspan)
pub fn Attrs::colspan(self : Attrs, value : Int) -> Attrs {
  self.attribute("colspan", value.to_string())
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/content)
pub fn Attrs::content(self : Attrs, value : String) -> Attrs {
  self.attribute("content", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Global_attributes/contenteditable)
pub fn Attrs::contenteditable(self : Attrs, value : String) -> Attrs {
  self.attribute("contenteditable", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/controls)
pub fn Attrs::controls(self : Attrs, value : Bool) -> Attrs {
  self.property("controls", @variant.Boolean(value))
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/coords)
pub fn Attrs::coords(self : Attrs, value : String) -> Attrs {
  self.attribute("coords", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/crossorigin)
pub fn Attrs::crossorigin(self : Attrs, value : String) -> Attrs {
  self.attribute("crossorigin", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/csp)
pub fn Attrs::csp(self : Attrs, value : String) -> Attrs {
  self.attribute("csp", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/data)
pub fn Attrs::data(self : Attrs, value : String) -> Attrs {
  self.attribute("data", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Global_attributes/data-*)
pub fn Attrs::data_set(self : Attrs, name : String, value : String) -> Attrs {
  self.attribute("data-" + name, value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/datetime)
pub fn Attrs::datetime(self : Attrs, value : String) -> Attrs {
  self.attribute("datetime", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/decoding)
pub fn Attrs::decoding(self : Attrs, value : String) -> Attrs {
  self.attribute("decoding", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/default)
pub fn Attrs::default(self : Attrs, value : Bool) -> Attrs {
  self.property("default", @variant.Boolean(value))
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/defer)
pub fn Attrs::defer_(self : Attrs, value : Bool) -> Attrs {
  self.property("defer", @variant.Boolean(value))
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Global_attributes/dir)
pub fn Attrs::dir(self : Attrs, value : String) -> Attrs {
  self.attribute("dir", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/dirname)
pub fn Attrs::dirname(self : Attrs, value : String) -> Attrs {
  self.attribute("dirname", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/disabled)
pub fn Attrs::disabled(self : Attrs, value : Bool) -> Attrs {
  // Note: `disabled` is a DOM property; removing it using `remove_property` does not work.
  // Treat it as an attribute to ensure it is correctly removed by vdom diff.
  if value {
    ignore(self.attribute("disabled", "disabled"))
  }
  self
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/download)
pub fn Attrs::download(self : Attrs, value : String) -> Attrs {
  self.attribute("download", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Global_attributes/draggable)
pub fn Attrs::draggable(self : Attrs, value : String) -> Attrs {
  self.attribute("draggable", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/enctype)
pub fn Attrs::enctype(self : Attrs, value : String) -> Attrs {
  self.attribute("enctype", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Global_attributes/enterkeyhint)
pub fn Attrs::enterkeyhint(self : Attrs, value : String) -> Attrs {
  self.attribute("enterkeyhint", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/elementtiming)
pub fn Attrs::elementtiming(self : Attrs, value : String) -> Attrs {
  self.attribute("elementtiming", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/fetchpriority)
pub fn Attrs::fetchpriority(self : Attrs, value : String) -> Attrs {
  self.attribute("fetchpriority", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/for)
pub fn Attrs::for_(self : Attrs, value : String) -> Attrs {
  self.attribute("for", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/form)
pub fn Attrs::form(self : Attrs, value : String) -> Attrs {
  self.attribute("form", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/formaction)
pub fn Attrs::formaction(self : Attrs, value : String) -> Attrs {
  self.attribute("formaction", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/formenctype)
pub fn Attrs::formenctype(self : Attrs, value : String) -> Attrs {
  self.attribute("formenctype", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/formmethod)
pub fn Attrs::formmethod(self : Attrs, value : String) -> Attrs {
  self.attribute("formmethod", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/formnovalidate)
pub fn Attrs::formnovalidate(self : Attrs, value : Bool) -> Attrs {
  self.property("formnovalidate", @variant.Boolean(value))
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/formtarget)
pub fn Attrs::formtarget(self : Attrs, value : String) -> Attrs {
  self.attribute("formtarget", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/headers)
pub fn Attrs::headers(self : Attrs, value : String) -> Attrs {
  self.attribute("headers", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/height)
pub fn Attrs::height(self : Attrs, value : Int) -> Attrs {
  self.attribute("height", value.to_string())
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Global_attributes/hidden)
pub fn Attrs::hidden(self : Attrs, value : Bool) -> Attrs {
  self.property("hidden", @variant.Boolean(value))
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/high)
pub fn Attrs::high(self : Attrs, value : Int) -> Attrs {
  self.attribute("high", value.to_string())
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/href)
pub fn Attrs::href(self : Attrs, value : String) -> Attrs {
  self.property("href", @variant.String(value))
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/hreflang)
pub fn Attrs::hreflang(self : Attrs, value : String) -> Attrs {
  self.attribute("hreflang", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/http-equiv)
pub fn Attrs::http_equiv(self : Attrs, value : String) -> Attrs {
  self.attribute("http-equiv", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Global_attributes/id)
pub fn Attrs::id(self : Attrs, value : String) -> Attrs {
  self.attribute("id", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/integrity)
pub fn Attrs::integrity(self : Attrs, value : String) -> Attrs {
  self.attribute("integrity", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Global_attributes/inputmode)
pub fn Attrs::inputmode(self : Attrs, value : String) -> Attrs {
  self.attribute("inputmode", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/ismap)
pub fn Attrs::ismap(self : Attrs, value : Bool) -> Attrs {
  self.property("ismap", @variant.Boolean(value))
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Global_attributes/itemprop)
pub fn Attrs::itemprop(self : Attrs, value : String) -> Attrs {
  self.attribute("itemprop", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/kind)
pub fn Attrs::kind(self : Attrs, value : String) -> Attrs {
  self.attribute("kind", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/label)
pub fn Attrs::label(self : Attrs, value : String) -> Attrs {
  self.attribute("label", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Global_attributes/lang)
pub fn Attrs::lang(self : Attrs, value : String) -> Attrs {
  self.attribute("lang", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/language)
pub fn Attrs::language(self : Attrs, value : String) -> Attrs {
  self.attribute("language", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/loading)
pub fn Attrs::loading(self : Attrs, value : String) -> Attrs {
  self.attribute("loading", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/list)
pub fn Attrs::list(self : Attrs, value : String) -> Attrs {
  self.attribute("list", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/loop)
pub fn Attrs::loop_(self : Attrs, value : Bool) -> Attrs {
  self.property("loop", @variant.Boolean(value))
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/low)
pub fn Attrs::low(self : Attrs, value : Int) -> Attrs {
  self.attribute("low", value.to_string())
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/max)
pub fn Attrs::max(self : Attrs, value : Int) -> Attrs {
  self.attribute("max", value.to_string())
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/maxlength)
pub fn Attrs::maxlength(self : Attrs, value : Int) -> Attrs {
  self.attribute("maxlength", value.to_string())
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/media)
pub fn Attrs::media(self : Attrs, value : String) -> Attrs {
  self.attribute("media", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/method)
pub fn Attrs::method_(self : Attrs, value : String) -> Attrs {
  self.attribute("method", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/min)
pub fn Attrs::min(self : Attrs, value : Int) -> Attrs {
  self.attribute("min", value.to_string())
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/minlength)
pub fn Attrs::minlength(self : Attrs, value : Int) -> Attrs {
  self.attribute("minlength", value.to_string())
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/multiple)
pub fn Attrs::multiple(self : Attrs, value : Bool) -> Attrs {
  self.property("multiple", @variant.Boolean(value))
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/muted)
pub fn Attrs::muted(self : Attrs, value : Bool) -> Attrs {
  self.property("muted", @variant.Boolean(value))
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/name)
pub fn Attrs::name(self : Attrs, value : String) -> Attrs {
  self.attribute("name", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/novalidate)
pub fn Attrs::novalidate(self : Attrs, value : Bool) -> Attrs {
  self.property("novalidate", @variant.Boolean(value))
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/open)
pub fn Attrs::open(self : Attrs, value : Bool) -> Attrs {
  self.property("open", @variant.Boolean(value))
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/optimum)
pub fn Attrs::optimum(self : Attrs, value : Int) -> Attrs {
  self.attribute("optimum", value.to_string())
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/pattern)
pub fn Attrs::pattern(self : Attrs, value : String) -> Attrs {
  self.attribute("pattern", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/ping)
pub fn Attrs::ping(self : Attrs, value : String) -> Attrs {
  self.attribute("ping", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/placeholder)
pub fn Attrs::placeholder(self : Attrs, value : String) -> Attrs {
  self.attribute("placeholder", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/playsinline)
pub fn Attrs::playsinline(self : Attrs, value : Bool) -> Attrs {
  self.property("playsinline", @variant.Boolean(value))
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/poster)
pub fn Attrs::poster(self : Attrs, value : String) -> Attrs {
  self.attribute("poster", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/preload)
pub fn Attrs::preload(self : Attrs, value : String) -> Attrs {
  self.attribute("preload", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/readonly)
pub fn Attrs::readonly_(self : Attrs, value : Bool) -> Attrs {
  self.property("readonly", @variant.Boolean(value))
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/referrerpolicy)
pub fn Attrs::referrerpolicy(self : Attrs, value : String) -> Attrs {
  self.attribute("referrerpolicy", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/rel)
pub fn Attrs::rel(self : Attrs, value : String) -> Attrs {
  self.attribute("rel", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/required)
pub fn Attrs::required(self : Attrs, value : Bool) -> Attrs {
  self.property("required", @variant.Boolean(value))
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/reversed)
pub fn Attrs::reversed(self : Attrs, value : Bool) -> Attrs {
  self.property("reversed", @variant.Boolean(value))
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Global_attributes/role)
pub fn Attrs::role(self : Attrs, value : String) -> Attrs {
  self.attribute("role", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/rows)
pub fn Attrs::rows(self : Attrs, value : Int) -> Attrs {
  self.attribute("rows", value.to_string())
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/rowspan)
pub fn Attrs::rowspan(self : Attrs, value : Int) -> Attrs {
  self.attribute("rowspan", value.to_string())
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/sandbox)
pub fn Attrs::sandbox(self : Attrs, value : String) -> Attrs {
  self.attribute("sandbox", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/scope)
pub fn Attrs::scope(self : Attrs, value : Scope) -> Attrs {
  let s = match value {
    Row => "row"
    Col => "col"
    RowGroup => "rowgroup"
    ColGroup => "colgroup"
  }
  self.attribute("scope", s)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/selected)
pub fn Attrs::selected(self : Attrs, value : Bool) -> Attrs {
  self.property("selected", @variant.Boolean(value))
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/shape)
pub fn Attrs::shape(self : Attrs, value : String) -> Attrs {
  self.attribute("shape", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/size)
pub fn Attrs::size(self : Attrs, value : Int) -> Attrs {
  self.attribute("size", value.to_string())
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/sizes)
pub fn Attrs::sizes(self : Attrs, value : String) -> Attrs {
  self.attribute("sizes", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Global_attributes/slot)
pub fn Attrs::slot(self : Attrs, value : String) -> Attrs {
  self.attribute("slot", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/span)
pub fn Attrs::span(self : Attrs, value : Int) -> Attrs {
  self.attribute("span", value.to_string())
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Global_attributes/spellcheck)
pub fn Attrs::spellcheck(self : Attrs, value : Bool) -> Attrs {
  self.property("spellcheck", @variant.Boolean(value))
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/src)
pub fn Attrs::src(self : Attrs, value : String) -> Attrs {
  self.attribute("src", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/srcdoc)
pub fn Attrs::srcdoc(self : Attrs, value : String) -> Attrs {
  self.attribute("srcdoc", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/srclang)
pub fn Attrs::srclang(self : Attrs, value : String) -> Attrs {
  self.attribute("srclang", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/srcset)
pub fn Attrs::srcset(self : Attrs, value : String) -> Attrs {
  self.attribute("srcset", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/start)
pub fn Attrs::start(self : Attrs, value : Int) -> Attrs {
  self.attribute("start", value.to_string())
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/step)
pub fn Attrs::step(self : Attrs, value : Int) -> Attrs {
  self.attribute("step", value.to_string())
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Global_attributes/style)
pub fn Attrs::style_attr(self : Attrs, value : String) -> Attrs {
  self.attribute("style", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/summary)
pub fn Attrs::summary(self : Attrs, value : String) -> Attrs {
  self.attribute("summary", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Global_attributes/tabindex)
pub fn Attrs::tabindex(self : Attrs, value : Int) -> Attrs {
  self.attribute("tabindex", value.to_string())
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/target)
pub fn Attrs::target(self : Attrs, value : Target) -> Attrs {
  self.attribute("target", value.to_string())
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Global_attributes/title)
pub fn Attrs::title(self : Attrs, value : String) -> Attrs {
  self.attribute("title", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Global_attributes/translate)
pub fn Attrs::translate(self : Attrs, value : String) -> Attrs {
  self.attribute("translate", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/type)
pub fn Attrs::type_(self : Attrs, value : String) -> Attrs {
  self.attribute("type", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/usemap)
pub fn Attrs::usemap(self : Attrs, value : String) -> Attrs {
  self.attribute("usemap", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/value)
pub fn Attrs::value(self : Attrs, value : String) -> Attrs {
  self.attribute("value", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/width)
pub fn Attrs::width(self : Attrs, value : Int) -> Attrs {
  self.attribute("width", value.to_string())
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/wrap)
pub fn Attrs::wrap(self : Attrs, value : String) -> Attrs {
  self.attribute("wrap", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/abbr)
pub fn Attrs::abbr(self : Attrs, value : String) -> Attrs {
  self.attribute("abbr", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Global_attributes/anchor)
pub fn Attrs::anchor(self : Attrs, value : String) -> Attrs {
  self.attribute("anchor", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Global_attributes/autocorrect)
pub fn Attrs::autocorrect(self : Attrs, value : String) -> Attrs {
  self.attribute("autocorrect", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Global_attributes/autofocus)
pub fn Attrs::autofocus(self : Attrs, value : Bool) -> Attrs {
  self.property("autofocus", @variant.Boolean(value))
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Global_attributes/exportparts)
pub fn Attrs::exportparts(self : Attrs, value : String) -> Attrs {
  self.attribute("exportparts", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Global_attributes/inert)
pub fn Attrs::inert(self : Attrs, value : Bool) -> Attrs {
  self.property("inert", @variant.Boolean(value))
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Global_attributes/is)
pub fn Attrs::is_(self : Attrs, value : String) -> Attrs {
  self.attribute("is", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Global_attributes/itemid)
pub fn Attrs::itemid(self : Attrs, value : String) -> Attrs {
  self.attribute("itemid", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Global_attributes/itemref)
pub fn Attrs::itemref(self : Attrs, value : String) -> Attrs {
  self.attribute("itemref", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Global_attributes/itemscope)
pub fn Attrs::itemscope(self : Attrs, value : Bool) -> Attrs {
  self.property("itemscope", @variant.Boolean(value))
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Global_attributes/itemtype)
pub fn Attrs::itemtype(self : Attrs, value : String) -> Attrs {
  self.attribute("itemtype", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Global_attributes/nonce)
pub fn Attrs::nonce(self : Attrs, value : String) -> Attrs {
  self.attribute("nonce", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Global_attributes/part)
pub fn Attrs::part(self : Attrs, value : String) -> Attrs {
  self.attribute("part", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Global_attributes/popover)
pub fn Attrs::popover(self : Attrs, value : String) -> Attrs {
  self.attribute("popover", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/allowfullscreen)
pub fn Attrs::allowfullscreen(self : Attrs, value : Bool) -> Attrs {
  self.property("allowfullscreen", @variant.Boolean(value))
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/value)
pub fn Attrs::value_int(self : Attrs, value : Int) -> Attrs {
  self.attribute("value", value.to_string())
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/value)
pub fn Attrs::value_prop(self : Attrs, value : String) -> Attrs {
  self.property("value", @variant.String(value))
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Reference/Attributes/aria-activedescendant)
pub fn Attrs::aria_activedescendant(self : Attrs, value : String) -> Attrs {
  self.attribute("aria-activedescendant", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Reference/Attributes/aria-atomic)
pub fn Attrs::aria_atomic(self : Attrs, value : String) -> Attrs {
  self.attribute("aria-atomic", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Reference/Attributes/aria-autocomplete)
pub fn Attrs::aria_autocomplete(self : Attrs, value : String) -> Attrs {
  self.attribute("aria-autocomplete", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Reference/Attributes/aria-braillelabel)
pub fn Attrs::aria_braillelabel(self : Attrs, value : String) -> Attrs {
  self.attribute("aria-braillelabel", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Reference/Attributes/aria-brailleroledescription)
pub fn Attrs::aria_brailleroledescription(
  self : Attrs,
  value : String,
) -> Attrs {
  self.attribute("aria-brailleroledescription", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Reference/Attributes/aria-busy)
pub fn Attrs::aria_busy(self : Attrs, value : String) -> Attrs {
  self.attribute("aria-busy", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Reference/Attributes/aria-checked)
pub fn Attrs::aria_checked(self : Attrs, value : String) -> Attrs {
  self.attribute("aria-checked", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Reference/Attributes/aria-colcount)
pub fn Attrs::aria_colcount(self : Attrs, value : String) -> Attrs {
  self.attribute("aria-colcount", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Reference/Attributes/aria-colindex)
pub fn Attrs::aria_colindex(self : Attrs, value : String) -> Attrs {
  self.attribute("aria-colindex", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Reference/Attributes/aria-colindextext)
pub fn Attrs::aria_colindextext(self : Attrs, value : String) -> Attrs {
  self.attribute("aria-colindextext", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Reference/Attributes/aria-colspan)
pub fn Attrs::aria_colspan(self : Attrs, value : String) -> Attrs {
  self.attribute("aria-colspan", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Reference/Attributes/aria-controls)
pub fn Attrs::aria_controls(self : Attrs, value : String) -> Attrs {
  self.attribute("aria-controls", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Reference/Attributes/aria-current)
pub fn Attrs::aria_current(self : Attrs, value : String) -> Attrs {
  self.attribute("aria-current", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Reference/Attributes/aria-describedby)
pub fn Attrs::aria_describedby(self : Attrs, value : String) -> Attrs {
  self.attribute("aria-describedby", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Reference/Attributes/aria-description)
pub fn Attrs::aria_description(self : Attrs, value : String) -> Attrs {
  self.attribute("aria-description", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Reference/Attributes/aria-details)
pub fn Attrs::aria_details(self : Attrs, value : String) -> Attrs {
  self.attribute("aria-details", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Reference/Attributes/aria-disabled)
pub fn Attrs::aria_disabled(self : Attrs, value : String) -> Attrs {
  self.attribute("aria-disabled", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Reference/Attributes/aria-dropeffect)
pub fn Attrs::aria_dropeffect(self : Attrs, value : String) -> Attrs {
  self.attribute("aria-dropeffect", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Reference/Attributes/aria-errormessage)
pub fn Attrs::aria_errormessage(self : Attrs, value : String) -> Attrs {
  self.attribute("aria-errormessage", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Reference/Attributes/aria-expanded)
pub fn Attrs::aria_expanded(self : Attrs, value : String) -> Attrs {
  self.attribute("aria-expanded", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Reference/Attributes/aria-flowto)
pub fn Attrs::aria_flowto(self : Attrs, value : String) -> Attrs {
  self.attribute("aria-flowto", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Reference/Attributes/aria-grabbed)
pub fn Attrs::aria_grabbed(self : Attrs, value : String) -> Attrs {
  self.attribute("aria-grabbed", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Reference/Attributes/aria-haspopup)
pub fn Attrs::aria_haspopup(self : Attrs, value : String) -> Attrs {
  self.attribute("aria-haspopup", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Reference/Attributes/aria-hidden)
pub fn Attrs::aria_hidden(self : Attrs, value : String) -> Attrs {
  self.attribute("aria-hidden", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Reference/Attributes/aria-invalid)
pub fn Attrs::aria_invalid(self : Attrs, value : String) -> Attrs {
  self.attribute("aria-invalid", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Reference/Attributes/aria-keyshortcuts)
pub fn Attrs::aria_keyshortcuts(self : Attrs, value : String) -> Attrs {
  self.attribute("aria-keyshortcuts", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Reference/Attributes/aria-label)
pub fn Attrs::aria_label(self : Attrs, value : String) -> Attrs {
  self.attribute("aria-label", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Reference/Attributes/aria-labelledby)
pub fn Attrs::aria_labelledby(self : Attrs, value : String) -> Attrs {
  self.attribute("aria-labelledby", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Reference/Attributes/aria-level)
pub fn Attrs::aria_level(self : Attrs, value : String) -> Attrs {
  self.attribute("aria-level", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Reference/Attributes/aria-live)
pub fn Attrs::aria_live(self : Attrs, value : String) -> Attrs {
  self.attribute("aria-live", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Reference/Attributes/aria-modal)
pub fn Attrs::aria_modal(self : Attrs, value : String) -> Attrs {
  self.attribute("aria-modal", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Reference/Attributes/aria-multiline)
pub fn Attrs::aria_multiline(self : Attrs, value : String) -> Attrs {
  self.attribute("aria-multiline", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Reference/Attributes/aria-multiselectable)
pub fn Attrs::aria_multiselectable(self : Attrs, value : String) -> Attrs {
  self.attribute("aria-multiselectable", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Reference/Attributes/aria-orientation)
pub fn Attrs::aria_orientation(self : Attrs, value : String) -> Attrs {
  self.attribute("aria-orientation", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Reference/Attributes/aria-owns)
pub fn Attrs::aria_owns(self : Attrs, value : String) -> Attrs {
  self.attribute("aria-owns", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Reference/Attributes/aria-placeholder)
pub fn Attrs::aria_placeholder(self : Attrs, value : String) -> Attrs {
  self.attribute("aria-placeholder", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Reference/Attributes/aria-posinset)
pub fn Attrs::aria_posinset(self : Attrs, value : String) -> Attrs {
  self.attribute("aria-posinset", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Reference/Attributes/aria-pressed)
pub fn Attrs::aria_pressed(self : Attrs, value : String) -> Attrs {
  self.attribute("aria-pressed", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Reference/Attributes/aria-readonly)
pub fn Attrs::aria_readonly(self : Attrs, value : String) -> Attrs {
  self.attribute("aria-readonly", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Reference/Attributes/aria-relevant)
pub fn Attrs::aria_relevant(self : Attrs, value : String) -> Attrs {
  self.attribute("aria-relevant", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Reference/Attributes/aria-required)
pub fn Attrs::aria_required(self : Attrs, value : String) -> Attrs {
  self.attribute("aria-required", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Reference/Attributes/aria-roledescription)
pub fn Attrs::aria_roledescription(self : Attrs, value : String) -> Attrs {
  self.attribute("aria-roledescription", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Reference/Attributes/aria-rowcount)
pub fn Attrs::aria_rowcount(self : Attrs, value : String) -> Attrs {
  self.attribute("aria-rowcount", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Reference/Attributes/aria-rowindex)
pub fn Attrs::aria_rowindex(self : Attrs, value : String) -> Attrs {
  self.attribute("aria-rowindex", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Reference/Attributes/aria-rowindextext)
pub fn Attrs::aria_rowindextext(self : Attrs, value : String) -> Attrs {
  self.attribute("aria-rowindextext", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Reference/Attributes/aria-rowspan)
pub fn Attrs::aria_rowspan(self : Attrs, value : String) -> Attrs {
  self.attribute("aria-rowspan", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Reference/Attributes/aria-selected)
pub fn Attrs::aria_selected(self : Attrs, value : String) -> Attrs {
  self.attribute("aria-selected", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Reference/Attributes/aria-setsize)
pub fn Attrs::aria_setsize(self : Attrs, value : String) -> Attrs {
  self.attribute("aria-setsize", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Reference/Attributes/aria-sort)
pub fn Attrs::aria_sort(self : Attrs, value : String) -> Attrs {
  self.attribute("aria-sort", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Reference/Attributes/aria-valuemax)
pub fn Attrs::aria_valuemax(self : Attrs, value : String) -> Attrs {
  self.attribute("aria-valuemax", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Reference/Attributes/aria-valuemin)
pub fn Attrs::aria_valuemin(self : Attrs, value : String) -> Attrs {
  self.attribute("aria-valuemin", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Reference/Attributes/aria-valuenow)
pub fn Attrs::aria_valuenow(self : Attrs, value : String) -> Attrs {
  self.attribute("aria-valuenow", value)
}

///|
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Reference/Attributes/aria-valuetext)
pub fn Attrs::aria_valuetext(self : Attrs, value : String) -> Attrs {
  self.attribute("aria-valuetext", value)
}
