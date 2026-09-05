///|
priv struct ShowcasePageEntry {
  slug : String
  title : String
}

///|
let showcase_page_entries : Array[ShowcasePageEntry] = [
  { slug: "accordion", title: "Accordion", },
  { slug: "alert", title: "Alert", },
  { slug: "alert-dialog", title: "Alert Dialog", },
  { slug: "aspect-ratio", title: "Aspect Ratio", },
  { slug: "attachment", title: "Attachment", },
  { slug: "avatar", title: "Avatar", },
  { slug: "badge", title: "Badge", },
  { slug: "breadcrumb", title: "Breadcrumb", },
  { slug: "bubble", title: "Bubble", },
  { slug: "button", title: "Button", },
  { slug: "button-group", title: "Button Group", },
  { slug: "calendar", title: "Calendar", },
  { slug: "card", title: "Card", },
  { slug: "carousel", title: "Carousel", },
  { slug: "chart", title: "Chart", },
  { slug: "checkbox", title: "Checkbox", },
  { slug: "collapsible", title: "Collapsible", },
  { slug: "combobox", title: "Combobox", },
  { slug: "command", title: "Command", },
  { slug: "context-menu", title: "Context Menu", },
  { slug: "data-table", title: "Data Table", },
  { slug: "date-picker", title: "Date Picker", },
  { slug: "dialog", title: "Dialog", },
  { slug: "direction", title: "Direction", },
  { slug: "drawer", title: "Drawer", },
  { slug: "dropdown-menu", title: "Dropdown Menu", },
  { slug: "empty", title: "Empty", },
  { slug: "field", title: "Field", },
  { slug: "hover-card", title: "Hover Card", },
  { slug: "input", title: "Input", },
  { slug: "input-group", title: "Input Group", },
  { slug: "input-otp", title: "Input OTP", },
  { slug: "item", title: "Item", },
  { slug: "kbd", title: "Kbd", },
  { slug: "label", title: "Label", },
  { slug: "marker", title: "Marker", },
  { slug: "menubar", title: "Menubar", },
  { slug: "message", title: "Message", },
  { slug: "message-scroller", title: "Message Scroller", },
  { slug: "native-select", title: "Native Select", },
  { slug: "navigation-menu", title: "Navigation Menu", },
  { slug: "pagination", title: "Pagination", },
  { slug: "popover", title: "Popover", },
  { slug: "progress", title: "Progress", },
  { slug: "radio-group", title: "Radio Group", },
  { slug: "resizable", title: "Resizable", },
  { slug: "scroll-area", title: "Scroll Area", },
  { slug: "select", title: "Select", },
  { slug: "separator", title: "Separator", },
  { slug: "sheet", title: "Sheet", },
  { slug: "sidebar", title: "Sidebar", },
  { slug: "skeleton", title: "Skeleton", },
  { slug: "slider", title: "Slider", },
  { slug: "sonner", title: "Sonner", },
  { slug: "spinner", title: "Spinner", },
  { slug: "switch", title: "Switch", },
  { slug: "table", title: "Table", },
  { slug: "tabs", title: "Tabs", },
  { slug: "textarea", title: "Textarea", },
  { slug: "toast", title: "Toast", },
  { slug: "toggle", title: "Toggle", },
  { slug: "toggle-group", title: "Toggle Group", },
  { slug: "tooltip", title: "Tooltip", },
  { slug: "typography", title: "Typography", },
]

///|
fn showcase_page_index_by_slug(slug : String) -> Int {
  for index = 0; index < showcase_page_entries.length(); index = index + 1 {
    if showcase_page_entries[index].slug == slug {
      return index
    }
  }
  -1
}

///|
fn showcase_page_index_by_title(title : String) -> Int {
  for index = 0; index < showcase_page_entries.length(); index = index + 1 {
    if showcase_page_entries[index].title == title {
      return index
    }
  }
  -1
}

///|
fn showcase_default_page_slug() -> String {
  showcase_page_entries[0].slug
}

///|
fn showcase_page_title(slug : String) -> String {
  let index = showcase_page_index_by_slug(slug)
  if index >= 0 {
    showcase_page_entries[index].title
  } else {
    "Components"
  }
}

///|
#cfg(target="js")
extern "js" fn showcase_page_href(slug : String) -> String =
  #| slug => {
  #|   const pathname = globalThis.location?.pathname || "/components/";
  #|   const marker = "/components";
  #|   const markerIndex = pathname.indexOf(marker);
  #|   const root = markerIndex >= 0 ? pathname.slice(0, markerIndex) : "";
  #|   return `${root}/components/${encodeURIComponent(slug)}/`;
  #| }

///|
#cfg(not(target="js"))
fn showcase_page_href(slug : String) -> String {
  "/components/" + slug + "/"
}
