# Rabbita UI

`moonbit-community/rabbita-ui` 是一套独立的 Rabbita 原生组件库。它移植
shadcn/ui **Vega** 的视觉规范与组件 API 拆分方式，并使用 Rabbita 原生
HTML/ARIA/Popover/Dialog 与 incremental state 重新实现交互和黑盒状态。

设计目标是“默认当黑盒使用，需要深改时复制源码”：

- 不依赖 Tailwind；
- 不要求引入任何 CSS 文件；
- 不做 JavaScript 样式注册或自动注册；根部 `theme` 会声明式输出一份内置静态
  `<style>`，专门承载 `:hover`、`:focus-visible` 与状态选择器；
- 不增加 PostCSS、代码生成、构建插件或其他构建步骤；
- 组件主体使用 Rabbita `style : Array[String]`，共享配方放在模块内部顶层常量；
- JS 目标提供交互，native 目标可生成同构的初始 SSR HTML；
- 每个组件都保留 `data-slot`，便于测试、定位和复制后定制。
- `showcase` 只作为公开 API 的下游消费者，运行时实现不识别示例 ID、文案、数据或
  DOM 顺序。

## 安装与导入

应用的 `moon.mod`：

```mbt nocheck
import {
  "moonbit-community/rabbita@0.13.1",
  "moonbit-community/rabbita-ui@0.1.0",
}
```

使用组件的 package 的 `moon.pkg`：

```mbt nocheck
import {
  "moonbit-community/rabbita",
  "moonbit-community/rabbita/html",
  "moonbit-community/rabbita-ui" @ui,
}
```

不需要初始化或 CSS import。应用根部包一层 `theme`，组件的基础配方、主题 token 与
交互伪类就会一起输出：

```mbt nocheck
@ui.theme(
  @ui.card([
    @ui.card_header([
      @ui.card_title("账户"),
      @ui.card_description("管理登录信息"),
    ]),
    @ui.card_content([
      @ui.input(placeholder="name@example.com"),
      @ui.button("保存"),
    ]),
  ]),
)
```

## 运行完整 Showcase

仓库内的 `showcase` 是真实组件工作台，不使用截图或另一套演示实现。先从 workspace
根目录构建 JS 目标，再以仓库根目录作为静态站点目录：

```sh
moon build ui/showcase/main --target js
python3 -m http.server 8123
```

然后打开 `http://127.0.0.1:8123/ui/showcase/public/`。Showcase 是一个三栏单页目录：
左栏列出全部组件，中栏展示当前组件及其变体舞台，右栏列出当前组件的变体目录。
每个舞台都带有可展开、可复制且由 Shiki 高亮的完整 MoonBit 示例；示例中的数据、状态、布局
和调用方式与实际舞台一致。主题切换、表单、选择器、折叠、菜单、Dialog、Popover、
滚动区与 Toast 等示例都直接调用本包公开 API，并通过 Rabbita incremental `Val` 组合。

Showcase 与组件运行时是单向依赖：`showcase/main` 可以导入 `@ui`，`@ui` 不导入、
注册或查询 Showcase。调试 Showcase 时发现的交互问题，必须归约为公开参数、opaque
scope、`data-slot`/组件私有 `data-*` 协议或通用状态机上的问题，并使用与示例不同的
ID、文案和结构补回归测试；禁止按 gallery ID、显示文字、样例值或页面中的元素次序
增加特判。

## 两类返回值

纯展示组件返回 `@html.Html`。它们不创建隐藏状态，可直接放进普通 Rabbita view，
例如 `button`、`card`、`table`、`input` 和 `separator`。

需要自己维护展开、选中、搜索、焦点索引、拖拽值或消息队列的黑盒组件，统一通过
Rabbita incremental API 持有状态并返回 `@rabbita.Val[@html.Html]`。例如：

- `accordion`、`collapsible`、`tabs`、`calendar`、`calendar_range`、
  `calendar_multiple`、`date_picker`、`date_range_picker`、`carousel`；
- `avatar_with_fallback`、`scroll_area_with_scrollbar`；
- `checkbox`、`switch`、`toggle`、`toggle_group`、`radio_group`；
- `select`、`combobox`、`command`、`input_otp`、`slider`、
  `resizable_panel_group`；
- `data_table`；
- `dialog`、`alert_dialog`、`sheet`、`drawer`、`popover`、`hover_card`、
  `tooltip`；
- `dropdown_menu`、`context_menu`、`menubar`、`navigation_menu`；
- `sidebar_provider`、`message_scroller`、`toaster`、`sonner`。

一个黑盒控件可以直接成为 view，也可以通过 `Val::view` 嵌入外层纯 HTML：

```mbt nocheck
fn settings() -> @rabbita.Val[@html.Html] {
  let notifications = @ui.switch(
    default_checked=true,
    aria_label="接收通知",
  )
  notifications.view(control =>
    @ui.card([
      @ui.card_header(@ui.card_title("通知")),
      @ui.card_content(@ui.label([control, "接收通知"])),
    ])
  )
}
```

组合多个有状态组件时使用 `Val::view2` 至 `Val::view9`。状态始终由组件内部的
incremental value 持有；`on_*_change` 只通知已经提交的新值，不把状态所有权转移给
调用方。

Compound API 通过不透明 scope 让内部状态只存在一份：

```mbt nocheck
@ui.radio_group(
  default_value="pro",
  name="plan",
  aria_label="套餐",
  scope => [
    @ui.radio_group_item(scope~, value="free", aria_label="免费"),
    @ui.radio_group_item(scope~, value="pro", aria_label="专业"),
  ],
)
```

`select`、`combobox`、菜单、Dialog、Popover、Sidebar 等同样把 scope 交给可选的
render/builder 参数。默认渲染适合黑盒使用；要重排内部结构时使用 compound parts；
要改变视觉体系或状态机时直接复制对应 `.mbt` 文件。

多值 Slider 使用 `slider_values(default_values=[...])`，每个 thumb 都由组件内部状态
管理；单值 `slider` 保持原有 `Int` callback。任意数量的可调整面板使用
`resizable_group(default_sizes=[...])`，并以 `resizable_group_panel(index=...)` 与
`resizable_group_handle(between=...)` 组合；旧双面板 API 仍可直接使用。

`tabs` 的 `list_variant` 支持 `TabsDefault` 与 `TabsLine`；前者使用紧凑的 muted
surface，后者使用透明列表与活动边缘指示器。两种变体共享同一套 Rabbita 内部选中与
键盘状态。

`data_table` 接收类型化的 `DataTableColumn[T]`，并在一个 incremental value 中维护
搜索、排序、分页、行选择、列显隐与列菜单状态。`value` 提供可搜索、可排序的文本，
`render` 只负责单元格视觉内容，因此自定义渲染不会改变表格操作语义。

Calendar 的三个黑盒入口各自持有组件局部 incremental 状态：`calendar` 使用单个
`CalendarDate`，`calendar_range` 使用不透明的 `DateRange`，`calendar_multiple`
使用 `Array[CalendarDate]`。范围模式第一次选择产生 `end() == None` 的开放区间，第二次
选择完成并规范化起止顺序；多选模式再次点击日期会切换选择，并通过 `on_select` 返回
完整的新数组（包括空数组）。

`date_picker` 提供单日期、可选快捷预设与自定义格式；`date_range_picker` 把同一套范围
Calendar 放进可开合的日期触发器。它们共享月份导航、焦点移动、日期网格以及范围起点、
终点和中间日期的视觉标记，但分别持有自己的 value 与 open 状态。

## 主题与样式覆盖

所有布局和基础配方都在 inline style 中读取 `--rui-*` token，并携带 Neutral light
fallback；`theme` 额外提供 light/dark token 和浏览器原生的 hover、focus-visible、
open、checked、selected 交互层。组件不要求外部 CSS，但完整交互外观需要在应用根部
使用一次 `theme`：

```mbt nocheck
@ui.theme(
  mode=@ui.Dark,
  style=[
    "--rui-primary:oklch(0.62 0.19 265)",
    "--rui-primary-foreground:white",
    "--rui-radius:0.75rem",
  ],
  @ui.button("品牌按钮"),
)
```

组件的内建配方先写入，调用方 `style` 最后追加，因此后写的同名 CSS 属性会覆盖
默认值：

```mbt nocheck
@ui.button(
  style=["background:rebeccapurple", "border-radius:2px"],
  "局部覆盖",
)
```

`attrs` 会先复制再补充 ARIA、事件与 `data-*`，组件不会修改调用方传入的 `Attrs`。
不要同时用组件的 `style` 参数和 `Attrs::style` 管理同一个元素；它们属于不同的
VDOM 更新路径。

Vega 的字体栈以 Inter 开头，但本模块不会下载字体；宿主没有 Inter 时自动回退到
系统 sans。

## 组件清单

[shadcn/ui 当前组件目录](https://ui.shadcn.com/docs/components) 同时包含底层组件、
组合组件和 Data Table、Date Picker、Typography 这类配方/样式指南，不能再用某个
registry 目录的文件数作为组件总数。本模块按当前目录持续对齐，并额外保留一个兼容旧
shadcn API 的 `Toast` surface；下表只描述已经存在的 Rabbita UI 源码，准确公开签名
以生成的 `pkg.generated.mbti` 为准。

| 分类 | shadcn 组件 | Rabbita UI 源码 |
|---|---|---|
| 基础 | Aspect Ratio, Avatar, Badge, Button, Button Group | `aspect_ratio.mbt`, `avatar.mbt`, `badge.mbt`, `button.mbt`, `button_group.mbt` |
| 基础 | Direction, Kbd, Label, Separator, Skeleton, Spinner | `direction.mbt`, `kbd.mbt`, `label.mbt`, `separator.mbt`, `skeleton.mbt`, `spinner.mbt` |
| 基础 | Toggle, Toggle Group | `toggle.mbt`, `toggle_group.mbt` |
| 表单 | Calendar, Checkbox, Combobox, Date Picker, Field, Form | `calendar.mbt`, `checkbox.mbt`, `combobox.mbt`, `date_picker.mbt`, `field.mbt`, `form.mbt` |
| 表单 | Input, Input Group, Input OTP, Native Select | `input.mbt`, `input_group.mbt`, `input_otp.mbt`, `native_select.mbt` |
| 表单 | Radio Group, Select, Slider, Switch, Textarea | `radio_group.mbt`, `select.mbt`, `slider.mbt`, `switch.mbt`, `textarea.mbt` |
| 数据与内容 | Alert, Attachment, Bubble, Card, Chart, Data Table, Empty, Item | `alert.mbt`, `attachment.mbt`, `bubble.mbt`, `card.mbt`, `chart.mbt`, `data_table.mbt`, `empty.mbt`, `item.mbt` |
| 数据与内容 | Marker, Message, Message Scroller, Progress, Resizable | `marker.mbt`, `message.mbt`, `message_scroller.mbt`, `progress.mbt`, `resizable.mbt` |
| 数据与内容 | Scroll Area, Table, Typography | `scroll_area.mbt`, `table.mbt`, `typography.mbt` |
| 导航与折叠 | Accordion, Breadcrumb, Carousel, Collapsible | `accordion.mbt`, `breadcrumb.mbt`, `carousel.mbt`, `collapsible.mbt` |
| 导航与折叠 | Navigation Menu, Pagination, Sidebar, Tabs | `navigation_menu.mbt`, `pagination.mbt`, `sidebar.mbt`, `tabs.mbt` |
| 浮层与菜单 | Alert Dialog, Command, Context Menu, Dialog, Drawer | `alert_dialog.mbt`, `command.mbt`, `context_menu.mbt`, `dialog.mbt`, `drawer.mbt` |
| 浮层与菜单 | Dropdown Menu, Hover Card, Menubar, Popover, Sheet, Tooltip | `dropdown_menu.mbt`, `hover_card.mbt`, `menubar.mbt`, `popover.mbt`, `sheet.mbt`, `tooltip.mbt` |
| 反馈 | Sonner | `sonner.mbt`, `toast.mbt` |
| 额外兼容 | Toast / Toaster | `toast.mbt` |

各文件中的 compound parts 对齐 shadcn 的拆分方式。例如 Card 提供 Header、Title、
Description、Action、Content、Footer；Menu 提供 Group、Item、CheckboxItem、
RadioGroup、RadioItem、Label、Separator、Shortcut、Sub；Sidebar 提供 Provider、
Trigger、Rail、Header、Footer、Content、Group 和完整 Menu 子组件。

Data Table 和 Date Picker 是基于本包基础组件组合出的黑盒组件，不要求调用方另外接入
TanStack Table、React DayPicker 或表单状态库。Typography 提供 H1–H4、段落、引用、
列表、行内代码、lead、large、small 与 muted 等纯展示入口。

官方单独导出的 Portal、Overlay、Anchor、Media、ChartTooltip、ChartLegendContent、
ChartStyle、ComboboxChipsInput 与 FormField 也都有 Rabbita 对应入口。由于原生
`<dialog>` 和 Popover 本身会进入 top layer，`*_portal` 是零 DOM fragment 适配器，
不额外注册 portal runtime。`chart_style` 用 `display:contents` 节点承载可继承的
inline CSS 变量，不生成 `<style>`。`form_field` 提供原生表单的语义/ARIA 适配，
不会引入 React Hook Form context、注册或验证流程。

## 交互实现

实现优先使用浏览器已经正确处理的原生语义：

- Button、Input、Textarea、Select、Radio、Details/Summary 保留原生键盘与表单行为；
- Dialog、Alert Dialog、Sheet、Drawer、Command Dialog 使用原生 `<dialog>` 顶层，
  由浏览器提供 modal focus boundary、Escape 与焦点恢复；
- Popover、Hover Card、Tooltip 和菜单使用原生 popover/floating 基础能力，并由
  incremental model 管理 open、hover/focus、active item 与延迟；
- Navigation Menu 默认把当前 Content 挂载到共享 Viewport；传 `viewport=false`
  时改用各 Item 自己的原生 popover；
- Menu/Command/Combobox/Select 实现对应 role、ARIA、方向键、Home/End、Enter、
  Escape、roving focus 或 active option；
- Tabs 按手动激活模型移动焦点，default/line 只改变视觉配方；Calendar 的单选、范围
  和多选模式按 React DayPicker 9.8.1 保持单一 Tab stop，并支持方向键、Home/End、
  PageUp/PageDown 与跨月焦点；范围和多选网格声明 `aria-multiselectable="true"`；
  Date Picker 与 Date Range Picker 复用这套焦点和月份导航，并由各自的 incremental
  model 持有值与 open 状态；
- Checkbox 支持 `aria-checked="mixed"`；Switch 使用 `role="switch"`；Toggle 使用
  `aria-pressed`；
- `disabled`、`read_only`、`invalid` 与状态 `data-*` 会同步到适用的原生或 ARIA
  属性。

JS 目标执行事件和状态更新。native 目标返回包含默认状态的 `Val::constant`，用于
SSR/快照；它不会在服务器进程里模拟浏览器交互。

## 有意保留的边界

纯 inline style 无法声明 `:hover`、`:focus-visible`、媒体查询、伪元素或
`@keyframes`。因此 `theme` 会在返回的 Rabbita HTML 中声明式携带一份固定的内部
交互样式表；它不是运行时注册流程，也不读取调用方数据。hover 与 focus 只走 CSS，
incremental model 仅维护 open、checked、selected 等真正的组件状态：

- Button、Toggle、菜单项、Tabs、Calendar、Sidebar、Table、Slider 与浮层触发器
  使用与 Vega 对齐的 hover/focus/状态色和 ring；
- Skeleton 使用 `theme` 内置的 `rui-pulse` keyframes，并随
  `prefers-reduced-motion` 关闭动画；不需要宿主提供动画 CSS；
- Input/Textarea 默认使用 Vega 桌面字号；iOS 项目可传
  `style=["font-size:1rem"]` 避免聚焦缩放；
- Avatar 的纯 compound parts 不持有图片加载状态；需要自动 load/error fallback
  时使用 incremental 的 `avatar_with_fallback`；
- `scroll_area_with_scrollbar` 会测量滚动范围、同步比例 thumb，并支持点击 track；
  wheel、touch 与键盘仍走原生滚动。当前 Rabbita 事件层没有安全的 document-level
  pointer capture，因此 thumb 本身不做跨元素拖拽；纯 `scroll_area` 则直接使用
  平台原生 scrollbar；
- Drawer 使用原生 `<dialog>` 的焦点、Escape 与 top-layer 行为；`drawer_handle` 是
  装饰 part，不模拟 Vaul 的拖动速度和 snap points；
- Chart 提供 Vega 容器、Tooltip 与 Legend surface，不绑定 Recharts 或其他图表
  引擎；业务可把 SVG/Canvas 图形作为 children 放入；
- Calendar 与 Carousel 是 Rabbita 原生状态机，不依赖 React DayPicker 或 Embla；
- Sonner/Toaster 使用组件局部队列，不创建全局 JavaScript singleton。

## 复制源码做深度定制

一般定制优先用 `style`、token、`attrs` 与 compound builder。需要改变 DOM 结构、
尺寸体系、状态机或交互策略时，复制对应 `.mbt` 文件到应用内单独维护。组件专属的
Vega 常量、状态类型和渲染函数尽量与组件放在同一文件；复制到另一个 package 时，
还需复制或内联 `theme.mbt` 中的少量 `Ui*` 常量、`ui_attrs` 与 `ui_styles` helper。

这条路径没有 vendor 同步、自动注册、生成器或额外构建约定。升级时按需人工对比
上游与本模块源码即可。

## 上游参考与许可证

- [shadcn/ui 当前组件文档](https://ui.shadcn.com/docs/components)与
  [shadcn/ui 官方源码](https://github.com/shadcn-ui/ui)：用于跟踪当前组件目录、Vega
  视觉配方和 compound API；不再把某个历史 registry commit 当成完整目录基线。
- React DayPicker calendar interaction reference：v9.8.1 / commit
  [`bd55df2e3a4917f4c368020f3ef64f60b6882627`](https://github.com/gpbl/react-day-picker/tree/bd55df2e3a4917f4c368020f3ef64f60b6882627)

本模块采用 MIT 许可证。上游版权和移植说明见 `THIRD_PARTY_NOTICES.md`。
