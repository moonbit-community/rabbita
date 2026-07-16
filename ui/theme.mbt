///|
/// Shared Vega foundations. Component-specific recipes stay next to their
/// component so copying source remains straightforward.
const UiFontSans : String = "font-family:Inter,ui-sans-serif,system-ui,-apple-system,BlinkMacSystemFont,\"Segoe UI\",sans-serif"

///|
const UiBoxSizing : String = "box-sizing:border-box"

///|
const UiTextRendering : String = "-webkit-font-smoothing:antialiased;text-rendering:optimizeLegibility"

///|
const UiTransition : String = "transition:color 150ms ease,background-color 150ms ease,border-color 150ms ease,box-shadow 150ms ease,opacity 150ms ease,transform 150ms ease"

///|
const UiShadowXs : String = "box-shadow:0 1px 2px rgb(0 0 0 / 0.05)"

///|
const UiDisabled : String = "cursor:not-allowed;pointer-events:none;opacity:0.5"

///|
const UiDisabledVisual : String = "cursor:not-allowed;opacity:0.5"

///|
/// Pseudo classes cannot live in an HTML `style` attribute. This small,
/// declarative sheet supplies the interaction layer while every component's
/// layout and base recipe remain inline. It is emitted by `theme`, so callers
/// still import no CSS and no script registers or mutates hover state.
const UiInteractionCss : String =
  #|@keyframes rui-spin {
  #|  to { transform:rotate(360deg); }
  #|}
  #|@keyframes rui-pulse {
  #|  50% { opacity:0.5; }
  #|}
  #|@keyframes rui-shimmer {
  #|  to { background-position:-200% 0; }
  #|}
  #|@keyframes rui-caret-blink {
  #|  0%,70%,100% { opacity:1; }
  #|  20%,50% { opacity:0; }
  #|}
  #|@layer rui-interactions {
  #|  :where([hidden]:not([hidden="until-found"])) {
  #|    display:none !important;
  #|  }
  #|  :where([data-slot="input"],[data-slot="input-group-control"],[data-slot="textarea"])::placeholder {
  #|    color:var(--rui-muted-foreground,oklch(0.556 0 0));
  #|    opacity:1;
  #|  }
  #|  :where([data-slot="input"],[data-slot="input-group-control"],[data-slot="textarea"])::selection {
  #|    background:var(--rui-primary,oklch(0.205 0 0));
  #|    color:var(--rui-primary-foreground,oklch(0.985 0 0));
  #|  }
  #|  [data-slot="input"]::file-selector-button {
  #|    display:inline-flex;
  #|    height:1.75rem;
  #|    align-items:center;
  #|    border:0;
  #|    margin-inline-end:0.5rem;
  #|    background:transparent;
  #|    padding:0;
  #|    color:var(--rui-foreground,oklch(0.145 0 0));
  #|    font:inherit;
  #|    font-size:0.875rem;
  #|    font-weight:500;
  #|  }
  #|  [data-slot="field-set"]:has(> :where([data-slot="checkbox-group"],[data-slot="radio-group"])) {
  #|    gap:0.75rem;
  #|  }
  #|  [data-slot="field-group"] > [data-slot="field-group"] {
  #|    gap:1rem;
  #|  }
  #|  [data-slot="field"][data-orientation="vertical"] > *,
  #|  [data-slot="field"][data-orientation="responsive"] > * {
  #|    width:100%;
  #|  }
  #|  [data-slot="field"][data-orientation="horizontal"] > [data-slot="field-label"] {
  #|    flex:auto;
  #|  }
  #|  [data-slot="field"][data-orientation="horizontal"]:has(> [data-slot="field-content"]) {
  #|    align-items:flex-start;
  #|  }
  #|  @container rui-field-group (min-width:28rem) {
  #|    [data-slot="field"][data-orientation="responsive"] {
  #|      flex-direction:row;
  #|      align-items:center;
  #|    }
  #|    [data-slot="field"][data-orientation="responsive"] > * {
  #|      width:auto;
  #|    }
  #|    [data-slot="field"][data-orientation="responsive"] > [data-slot="field-label"] {
  #|      flex:auto;
  #|    }
  #|    [data-slot="field"][data-orientation="responsive"]:has(> [data-slot="field-content"]) {
  #|      align-items:flex-start;
  #|    }
  #|  }
  #|  [data-slot="input-otp-group"] > [data-slot="input-otp-slot"]:first-child {
  #|    border-inline-start:1px solid var(--rui-otp-border,var(--rui-input,oklch(0.922 0 0)));
  #|    border-start-start-radius:calc(var(--rui-radius,0.625rem) - 0.125rem);
  #|    border-end-start-radius:calc(var(--rui-radius,0.625rem) - 0.125rem);
  #|  }
  #|  [data-slot="input-otp-group"] > [data-slot="input-otp-slot"]:last-child {
  #|    border-start-end-radius:calc(var(--rui-radius,0.625rem) - 0.125rem);
  #|    border-end-end-radius:calc(var(--rui-radius,0.625rem) - 0.125rem);
  #|  }
  #|  [data-slot="input-otp-group"] > [data-slot="input-otp-slot"]:only-child {
  #|    border-radius:calc(var(--rui-radius,0.625rem) - 0.125rem);
  #|  }
  #|  [data-slot="input-otp-caret"] {
  #|    visibility:hidden;
  #|  }
  #|  [data-slot="input-otp"]:focus-within [data-slot="input-otp-slot"][data-current="true"] {
  #|    z-index:10;
  #|    --rui-otp-border:var(--rui-ring,oklch(0.708 0 0));
  #|    --rui-otp-shadow:0 0 0 3px color-mix(in oklch,var(--rui-ring,oklch(0.708 0 0)) 50%,transparent);
  #|  }
  #|  [data-slot="input-otp"]:focus-within [data-slot="input-otp-slot"][data-current="true"][aria-invalid="true"] {
  #|    --rui-otp-border:var(--rui-destructive-border,var(--rui-destructive,oklch(0.577 0.245 27.325)));
  #|    --rui-otp-shadow:0 0 0 3px var(--rui-destructive-ring,oklch(0.577 0.245 27.325 / 0.2));
  #|  }
  #|  [data-slot="input-otp"]:focus-within [data-slot="input-otp-caret"] {
  #|    visibility:visible;
  #|  }
  #|  :where([data-slot="button"],[data-slot="attachment-action"],[data-slot="message-scroller-button"]) svg {
  #|    width:var(--rui-button-icon-size,1rem);
  #|    height:var(--rui-button-icon-size,1rem);
  #|    flex-shrink:0;
  #|    pointer-events:none;
  #|  }
  #|  :where([data-slot="toggle"],[data-slot="toggle-group-item"]) svg {
  #|    width:var(--rui-toggle-icon-size,1rem);
  #|    height:var(--rui-toggle-icon-size,1rem);
  #|    flex-shrink:0;
  #|    pointer-events:none;
  #|  }
  #|  :where([data-slot="badge"],[data-slot="kbd"],[data-slot="alert"],[data-slot="empty-icon"],[data-slot="item-media"][data-variant="icon"],[data-slot="marker"],[data-slot="marker-icon"],[data-slot="avatar-group-count"],[data-slot="attachment-media"],[data-slot="bubble-reactions"]) svg {
  #|    width:var(--rui-icon-size,1rem);
  #|    height:var(--rui-icon-size,1rem);
  #|    flex-shrink:0;
  #|    pointer-events:none;
  #|  }
  #|  :where([data-slot="select-trigger"],[data-slot="select-item"],[data-slot="select-scroll-up-button"],[data-slot="select-scroll-down-button"],[data-slot="combobox-trigger"],[data-slot="combobox-clear"],[data-slot="combobox-item"],[data-slot="combobox-chip-remove"],[data-slot="input-otp-separator"],[data-slot="command-input-wrapper"],[role^="menuitem"],[data-submenu-key]) svg {
  #|    width:1rem;
  #|    height:1rem;
  #|    flex-shrink:0;
  #|    pointer-events:none;
  #|  }
  #|  :where([data-slot="checkbox-indicator"],[data-slot="breadcrumb-separator"]) svg {
  #|    width:0.875rem;
  #|    height:0.875rem;
  #|  }
  #|  :where([data-icon="inline-end"],[data-icon="inline-start"]):dir(rtl) {
  #|    transform:scaleX(-1);
  #|  }
  #|  [data-slot="command-group"]:not(:has([data-slot="command-item"]:not([hidden]))) {
  #|    display:none !important;
  #|  }
  #|  dialog:where([data-slot="dialog-native"],[data-slot="alert-dialog-native"],[data-slot="sheet-native"],[data-slot="drawer-native"],[data-slot="command-dialog-native"],[data-slot="popover-content"])::backdrop {
  #|    background:transparent;
  #|  }
  #|  :where([data-slot="sidebar-trigger"],[data-slot="sidebar-menu-button"],[data-slot="sidebar-menu-sub-button"],[data-slot="sidebar-group-action"],[data-slot="sidebar-menu-action"],[data-slot="dialog-close"],[data-slot="sheet-close"],[data-slot="drawer-close"]) svg {
  #|    width:1rem;
  #|    height:1rem;
  #|    flex-shrink:0;
  #|    pointer-events:none;
  #|  }
  #|  [data-slot="alert-dialog-media"] svg {
  #|    width:2rem;
  #|    height:2rem;
  #|  }
  #|  [data-slot="avatar-badge"] > svg {
  #|    width:var(--rui-avatar-badge-icon-size,0.5rem);
  #|    height:var(--rui-avatar-badge-icon-size,0.5rem);
  #|  }
  #|  [data-slot="attachment-media"] [data-slot="spinner"] {
  #|    width:var(--rui-attachment-spinner-size,1rem);
  #|    height:var(--rui-attachment-spinner-size,1rem);
  #|  }
  #|  :where([data-slot="attachment-media"][data-variant="image"],[data-slot="item-media"][data-variant="image"]) img {
  #|    width:100%;
  #|    height:100%;
  #|    object-fit:cover;
  #|  }
  #|  [data-slot="attachment"]:has(> [data-slot="attachment-content"]) {
  #|    --rui-attachment-padding-block:var(--rui-attachment-content-padding-block,0);
  #|    --rui-attachment-padding-inline:var(--rui-attachment-content-padding-inline-root,0);
  #|  }
  #|  [data-slot="attachment"]:has(> [data-slot="attachment-media"]):not(:has(> [data-slot="attachment-content"])) {
  #|    --rui-attachment-padding-block:var(--rui-attachment-media-padding,0);
  #|    --rui-attachment-padding-inline:var(--rui-attachment-media-padding,0);
  #|  }
  #|  :where(button,a)[data-size]:has(> svg) {
  #|    --rui-button-padding-inline:var(--rui-button-padding-inline-with-icon,var(--rui-button-padding-inline));
  #|  }
  #|  [data-slot="marker"][data-variant="separator"]::before,
  #|  [data-slot="marker"][data-variant="separator"]::after {
  #|    content:"";
  #|    height:1px;
  #|    min-width:0;
  #|    flex:1;
  #|    margin-inline:0.25rem;
  #|    background:var(--rui-border,oklch(0.922 0 0));
  #|  }
  #|  [data-slot="marker"][data-variant="separator"] > [data-slot="marker-content"] {
  #|    flex:none;
  #|    text-align:center;
  #|  }
  #|  [data-slot="alert"]:has(> svg) {
  #|    --rui-alert-columns:auto minmax(0,1fr) auto;
  #|    --rui-alert-column-gap:0.75rem;
  #|  }
  #|  [data-slot="alert"] > svg {
  #|    width:1rem;
  #|    height:1rem;
  #|    transform:translateY(0.125rem);
  #|  }
  #|  [data-slot="card-header"]:has(> [data-slot="card-action"]) {
  #|    --rui-card-header-columns:minmax(0,1fr) auto;
  #|    --rui-card-header-column-gap:0.5rem;
  #|  }
  #|  [data-slot="alert-description"] > p {
  #|    line-height:1.625;
  #|  }
  #|  [data-slot="item"]:has([data-slot="item-description"]) > [data-slot="item-media"] {
  #|    align-self:flex-start;
  #|    transform:translateY(0.125rem);
  #|  }
  #|  [data-slot="item"]:not([aria-disabled="true"]):not(:disabled):focus-visible {
  #|    --rui-item-border:var(--rui-ring,oklch(0.708 0 0));
  #|    --rui-item-shadow:0 0 0 3px color-mix(in oklab,var(--rui-ring,oklch(0.708 0 0)) 50%,transparent);
  #|    outline:none;
  #|  }
  #|  :where(a,button)[data-slot="item"]:not([aria-disabled="true"]):not(:disabled):where(:hover,:focus-visible) {
  #|    --rui-item-bg:color-mix(in oklab,var(--rui-accent,oklch(0.97 0 0)) 50%,transparent);
  #|  }
  #|  a[data-slot="badge"]:not([aria-disabled="true"]):focus-visible {
  #|    --rui-badge-border:var(--rui-ring,oklch(0.708 0 0));
  #|    --rui-badge-shadow:0 0 0 3px color-mix(in oklab,var(--rui-ring,oklch(0.708 0 0)) 50%,transparent);
  #|    outline:none;
  #|  }
  #|  [data-slot="badge"][aria-invalid="true"] {
  #|    --rui-badge-border:var(--rui-destructive-border,var(--rui-destructive,oklch(0.577 0.245 27.325)));
  #|    --rui-badge-shadow:0 0 0 3px var(--rui-destructive-ring,oklch(0.577 0.245 27.325 / 0.2));
  #|  }
  #|  [data-slot="bubble"][data-variant] > :is(a,button)[data-slot="bubble-content"]:not([aria-disabled="true"],:disabled):focus-visible {
  #|    --rui-bubble-border:var(--rui-ring,oklch(0.708 0 0));
  #|    --rui-bubble-shadow:0 0 0 3px color-mix(in oklab,var(--rui-ring,oklch(0.708 0 0)) 50%,transparent);
  #|    outline:none;
  #|  }
  #|  [data-slot="bubble-reactions"]:has(button) {
  #|    padding:0;
  #|  }
  #|  a[data-slot="marker"]:not([aria-disabled="true"]):focus-visible {
  #|    --rui-marker-shadow:0 0 0 3px color-mix(in oklab,var(--rui-ring,oklch(0.708 0 0)) 50%,transparent);
  #|    outline:none;
  #|  }
  #|  [data-slot="message"]:has([data-slot="message-footer"]) [data-slot="message-avatar"] {
  #|    transform:translateY(-2rem);
  #|  }
  #|  [data-slot="message"][data-align="end"] [data-slot="message-footer"] {
  #|    justify-content:flex-end;
  #|  }
  #|  [data-slot="message"]:has([data-slot="bubble"][data-variant="ghost"]) :where([data-slot="message-header"],[data-slot="message-footer"]) {
  #|    padding-inline:0;
  #|  }
  #|  [data-slot="tabs-list"][data-variant="line"] > [data-slot="tabs-trigger"] {
  #|    position:relative;
  #|    --rui-tabs-active-bg:transparent;
  #|    --rui-tabs-active-border:transparent;
  #|    --rui-tabs-active-shadow:none;
  #|  }
  #|  [data-slot="tabs-list"][data-variant="line"] > [data-slot="tabs-trigger"]::after {
  #|    content:"";
  #|    position:absolute;
  #|    background:var(--rui-foreground,oklch(0.145 0 0));
  #|    opacity:0;
  #|    transition:opacity 150ms ease;
  #|  }
  #|  [data-slot="tabs-list"][data-variant="line"][data-orientation="horizontal"] > [data-slot="tabs-trigger"]::after {
  #|    inset-inline:0;
  #|    bottom:-5px;
  #|    height:2px;
  #|  }
  #|  [data-slot="tabs-list"][data-variant="line"][data-orientation="vertical"] > [data-slot="tabs-trigger"]::after {
  #|    inset-block:0;
  #|    inset-inline-end:-0.25rem;
  #|    width:2px;
  #|  }
  #|  [data-slot="tabs-list"][data-variant="line"] > [data-slot="tabs-trigger"][data-state="active"]::after {
  #|    opacity:1;
  #|  }
  #|  [data-slot="typography-p"]:not(:first-child) {
  #|    margin-top:1.5rem;
  #|  }
  #|  [data-slot="typography-list"] > li:not(:first-child) {
  #|    margin-top:0.5rem;
  #|  }
  #|  [data-slot="table-body"] > [data-slot="table-row"]:last-child {
  #|    border-bottom:0;
  #|  }
  #|  :where([data-slot="table-head"],[data-slot="table-cell"]):has([role="checkbox"]) {
  #|    padding-inline-end:0;
  #|  }
  #|  :where([data-slot="table-head"],[data-slot="table-cell"]) > [role="checkbox"] {
  #|    transform:translateY(2px);
  #|  }
  #|  [data-slot="scroll-area-viewport"]::-webkit-scrollbar {
  #|    display:none;
  #|  }
  #|  [data-slot="carousel"]:dir(rtl) [data-slot="carousel-track"][data-orientation="horizontal"] {
  #|    --rui-carousel-offset:var(--rui-carousel-rtl-offset);
  #|  }
  #|  [data-slot="carousel"]:dir(rtl) :where([data-slot="carousel-previous"] [data-icon="previous"],[data-slot="carousel-next"] [data-icon="next"]) {
  #|    transform:scaleX(-1);
  #|  }
  #|  @media (max-width:767px) {
  #|    [data-slot="popover-content"][data-date-range-picker-popup] {
  #|      --rui-date-range-picker-width:15.5rem;
  #|      --rui-date-range-picker-max-height:calc(100% - 1rem);
  #|      --rui-date-range-picker-overflow-y:auto;
  #|    }
  #|  }
  #|  @media (min-width:768px) {
  #|    [data-slot="empty"] { --rui-empty-padding:3rem; }
  #|    :where([data-slot="input"],[data-slot="input-group-control"],[data-slot="textarea"]) {
  #|      font-size:0.875rem;
  #|      line-height:1.25rem;
  #|    }
  #|  }
  #|  @starting-style {
  #|    :where([data-slot="popover-content"],[data-slot="tooltip-content"],[data-slot="hover-card-content"],[data-slot="select-content"],[data-slot="combobox-content"],[data-slot="dropdown-menu-content"],[data-slot="context-menu-content"],[data-slot="menubar-content"],[data-slot="navigation-menu-content"],[data-submenu-owner])[data-state="open"]:popover-open {
  #|      visibility:hidden !important;
  #|      opacity:0 !important;
  #|      transform:scale(0.95) !important;
  #|    }
  #|    dialog[data-slot="popover-content"][data-state="open"][open] {
  #|      visibility:hidden !important;
  #|      opacity:0 !important;
  #|      transform:scale(0.95) !important;
  #|    }
  #|    :where([data-slot="dialog-overlay"],[data-slot="alert-dialog-overlay"],[data-slot="sheet-overlay"],[data-slot="drawer-overlay"],[data-slot="command-dialog-overlay"])[data-state="open"] {
  #|      opacity:0 !important;
  #|    }
  #|    :where([data-slot="dialog-content"],[data-slot="alert-dialog-content"],[data-slot="command-dialog-content"])[data-state="open"] {
  #|      opacity:0 !important;
  #|      transform:translateY(-0.5rem) scale(0.95) !important;
  #|    }
  #|    [data-slot="sheet-content"][data-state="open"],
  #|    [data-slot="drawer-content"][data-state="open"] { opacity:0 !important; }
  #|    [data-slot="sheet-content"][data-state="open"][data-side="top"],
  #|    [data-slot="drawer-content"][data-state="open"][data-direction="top"] { transform:translate3d(0,-100%,0) !important; }
  #|    [data-slot="sheet-content"][data-state="open"][data-side="right"],
  #|    [data-slot="drawer-content"][data-state="open"][data-direction="right"] { transform:translate3d(100%,0,0) !important; }
  #|    [data-slot="sheet-content"][data-state="open"][data-side="bottom"],
  #|    [data-slot="drawer-content"][data-state="open"][data-direction="bottom"] { transform:translate3d(0,100%,0) !important; }
  #|    [data-slot="sheet-content"][data-state="open"][data-side="left"],
  #|    [data-slot="drawer-content"][data-state="open"][data-direction="left"] { transform:translate3d(-100%,0,0) !important; }
  #|    :where([data-slot="toaster"],[data-slot="sonner"])[data-position^="top"] > [data-slot="toast"][data-state="open"] {
  #|      opacity:0 !important;
  #|      transform:translateY(-0.5rem) scale(0.98) !important;
  #|    }
  #|    :where([data-slot="toaster"],[data-slot="sonner"])[data-position^="bottom"] > [data-slot="toast"][data-state="open"] {
  #|      opacity:0 !important;
  #|      transform:translateY(0.5rem) scale(0.98) !important;
  #|    }
  #|  }
  #|  @media (prefers-reduced-motion:reduce) {
  #|    :where([data-slot="popover-content"],[data-slot="tooltip-content"],[data-slot="hover-card-content"],[data-slot="select-content"],[data-slot="combobox-content"],[data-slot="dropdown-menu-content"],[data-slot="context-menu-content"],[data-slot="menubar-content"],[data-slot="navigation-menu-content"],[data-submenu-owner]) {
  #|      transition-duration:0s !important;
  #|    }
  #|  }
  #|
  #|  @media (hover: hover) {
  #|    :where(button,a)[data-variant][data-size]:not([data-slot="toggle"]):not([data-slot="toggle-group-item"]):not([data-rui-close-icon]):not(:disabled):not([aria-disabled="true"])[data-variant="default"]:hover {
  #|      --rui-button-bg:color-mix(in oklab,var(--rui-primary,oklch(0.205 0 0)) 90%,transparent);
  #|    }
  #|    :where(button,a)[data-variant][data-size]:not([data-slot="toggle"]):not([data-slot="toggle-group-item"]):not([data-rui-close-icon]):not(:disabled):not([aria-disabled="true"])[data-variant="destructive"]:hover {
  #|      --rui-button-bg:color-mix(in oklab,var(--rui-destructive,oklch(0.577 0.245 27.325)) 90%,transparent);
  #|      --rui-button-fg:white;
  #|    }
  #|    :where(button,a)[data-variant][data-size]:not([data-slot="toggle"]):not([data-slot="toggle-group-item"]):not([data-rui-close-icon]):not(:disabled):not([aria-disabled="true"])[data-variant="outline"]:hover {
  #|      --rui-button-bg:var(--rui-outline-hover-bg,var(--rui-accent,oklch(0.97 0 0)));
  #|      --rui-button-fg:var(--rui-accent-foreground,oklch(0.205 0 0));
  #|    }
  #|    :where(button,a)[data-variant][data-size]:not([data-slot="toggle"]):not([data-slot="toggle-group-item"]):not([data-slot="message-scroller-button"]):not([data-rui-close-icon]):not(:disabled):not([aria-disabled="true"])[data-variant="secondary"]:hover {
  #|      --rui-button-bg:color-mix(in oklab,var(--rui-secondary,oklch(0.97 0 0)) 80%,transparent);
  #|    }
  #|    :where(button,a)[data-variant][data-size]:not([data-slot="toggle"]):not([data-slot="toggle-group-item"]):not([data-rui-close-icon]):not(:disabled):not([aria-disabled="true"])[data-variant="ghost"]:hover {
  #|      --rui-button-bg:var(--rui-ghost-hover-bg,var(--rui-accent,oklch(0.97 0 0)));
  #|      --rui-button-fg:var(--rui-accent-foreground,oklch(0.205 0 0));
  #|    }
  #|    :where(button,a)[data-variant][data-size]:not(:disabled):not([aria-disabled="true"])[data-variant="link"]:hover {
  #|      text-decoration-line:underline;
  #|    }
  #|    :where([data-slot="toggle"],[data-slot="toggle-group-item"]):not(:disabled):not([aria-disabled="true"])[data-state="off"][data-variant="default"]:hover {
  #|      --rui-toggle-bg:color-mix(in oklab,var(--rui-muted,oklch(0.97 0 0)) 65%,transparent);
  #|      --rui-toggle-fg:var(--rui-foreground,oklch(0.145 0 0));
  #|    }
  #|    :where([data-slot="toggle"],[data-slot="toggle-group-item"]):not(:disabled):not([aria-disabled="true"])[data-state="off"][data-variant="outline"]:hover {
  #|      --rui-toggle-bg:color-mix(in oklab,var(--rui-accent,oklch(0.97 0 0)) 65%,transparent);
  #|      --rui-toggle-fg:var(--rui-accent-foreground,oklch(0.205 0 0));
  #|    }
  #|    :where([role^="menuitem"],[data-slot="select-item"],[data-slot="combobox-item"],[data-slot="command-item"]):not([aria-disabled="true"]):hover {
  #|      --rui-menu-item-bg:var(--rui-accent,oklch(0.97 0 0));
  #|      --rui-menu-item-fg:var(--rui-accent-foreground,oklch(0.205 0 0));
  #|    }
  #|    :where([role^="menuitem"])[data-variant="destructive"]:not([aria-disabled="true"]):hover {
  #|      --rui-menu-item-bg:var(--rui-destructive-subtle,oklch(0.577 0.245 27.325 / 0.1));
  #|      --rui-menu-item-fg:var(--rui-destructive,oklch(0.577 0.245 27.325));
  #|    }
  #|    :where([data-slot="select-trigger"],[data-slot="combobox-trigger"],[data-slot="native-select"]):not(:disabled):not([aria-disabled="true"]):hover {
  #|      --rui-control-bg:var(--rui-select-hover-bg,var(--rui-control-base-bg,transparent));
  #|    }
  #|    [data-slot="combobox-chip-remove"]:not(:disabled):not([aria-disabled="true"]):hover {
  #|      --rui-chip-remove-opacity:1;
  #|    }
  #|    [data-slot="message-scroller-button"]:not(:disabled):not([aria-disabled="true"]):hover {
  #|      --rui-button-bg:var(--rui-muted,oklch(0.97 0 0));
  #|      --rui-button-fg:var(--rui-foreground,oklch(0.145 0 0));
  #|    }
  #|    :where([data-slot="navigation-menu-trigger"],[data-slot="navigation-menu-link"]):not(:disabled):hover {
  #|      --rui-nav-bg:var(--rui-accent,oklch(0.97 0 0));
  #|      --rui-nav-fg:var(--rui-accent-foreground,oklch(0.205 0 0));
  #|    }
  #|    [data-slot="navigation-menu-trigger"][data-state="open"]:not(:disabled):hover,
  #|    [data-slot="navigation-menu-link"][data-active="true"]:not(:disabled):hover {
  #|      --rui-nav-bg:var(--rui-accent,oklch(0.97 0 0));
  #|      --rui-nav-fg:var(--rui-accent-foreground,oklch(0.205 0 0));
  #|    }
  #|    [data-slot="tabs-trigger"][data-state="inactive"]:not(:disabled):not([aria-disabled="true"]):hover {
  #|      --rui-tabs-fg:var(--rui-foreground,oklch(0.145 0 0));
  #|    }
  #|    :where([data-slot="accordion-trigger"],[data-slot="collapsible-trigger"]):not([aria-disabled="true"]):hover {
  #|      text-decoration-line:underline;
  #|    }
  #|    :where([data-slot="calendar-previous"],[data-slot="calendar-next"],[data-slot="calendar-day-button"]):not(:disabled):not([aria-disabled="true"]):not([data-selected-single="true"]):not([data-range-start]):not([data-range-end]):hover {
  #|      --rui-calendar-bg:var(--rui-accent,oklch(0.97 0 0));
  #|      --rui-calendar-fg:var(--rui-accent-foreground,oklch(0.205 0 0));
  #|    }
  #|    [data-slot="slider-thumb"]:has(+ [data-slot="slider-control"]:not(:disabled):hover) {
  #|      --rui-slider-thumb-shadow:0 0 0 4px color-mix(in oklab,var(--rui-ring,oklch(0.708 0 0)) 50%,transparent),var(--rui-slider-thumb-base-shadow,0 1px 2px rgb(0 0 0 / 0.1));
  #|    }
  #|    :where([data-slot="sidebar-menu-button"],[data-slot="sidebar-menu-sub-button"]):not(:disabled):not([aria-disabled="true"]):hover {
  #|      --rui-sidebar-item-bg:var(--rui-sidebar-accent,var(--rui-accent,oklch(0.97 0 0)));
  #|      --rui-sidebar-item-fg:var(--rui-sidebar-accent-foreground,var(--rui-accent-foreground,oklch(0.205 0 0)));
  #|    }
  #|    [data-slot="sidebar-rail"]:hover {
  #|      --rui-sidebar-rail-line-bg:var(--rui-sidebar-border,var(--rui-border,oklch(0.922 0 0)));
  #|    }
  #|    :where([data-slot="sidebar-group-action"],[data-slot="sidebar-menu-action"]):not(:disabled):not([aria-disabled="true"]):hover {
  #|      --rui-sidebar-action-bg:var(--rui-sidebar-accent,var(--rui-accent,oklch(0.97 0 0)));
  #|      --rui-sidebar-action-fg:var(--rui-sidebar-accent-foreground,var(--rui-accent-foreground,oklch(0.205 0 0)));
  #|    }
  #|    [data-slot="sidebar-menu-item"]:hover > [data-slot="sidebar-menu-action"][data-show-on-hover="true"]:not(:disabled):not([aria-disabled="true"]) {
  #|      --rui-sidebar-action-opacity:1;
  #|    }
  #|    [data-slot="sidebar-menu-item"]:hover > [data-slot="sidebar-menu-action"][data-show-on-hover="true"]:where(:disabled,[aria-disabled="true"]) {
  #|      --rui-sidebar-action-opacity:0.5;
  #|    }
  #|    [data-slot="sidebar-menu-item"]:hover > [data-slot="sidebar-menu-badge"] {
  #|      --rui-sidebar-badge-fg:var(--rui-sidebar-accent-foreground,var(--rui-accent-foreground,oklch(0.205 0 0)));
  #|    }
  #|    [data-slot="sidebar-menu-item"]:hover > [data-slot="sidebar-menu-action"] {
  #|      --rui-button-fg:var(--rui-sidebar-accent-foreground,var(--rui-accent-foreground,oklch(0.205 0 0)));
  #|    }
  #|    [data-slot="attachment"]:has(> :where(a,button)[data-slot="attachment-trigger"]:not([aria-disabled="true"],:disabled):hover) {
  #|      --rui-attachment-bg:color-mix(in oklab,var(--rui-muted,oklch(0.97 0 0)) 50%,transparent);
  #|    }
  #|    a[data-slot="badge"]:not([aria-disabled="true"])[data-variant="default"]:hover {
  #|      --rui-badge-bg:color-mix(in oklab,var(--rui-primary,oklch(0.205 0 0)) 90%,transparent);
  #|    }
  #|    a[data-slot="badge"]:not([aria-disabled="true"])[data-variant="secondary"]:hover {
  #|      --rui-badge-bg:color-mix(in oklab,var(--rui-secondary,oklch(0.97 0 0)) 80%,transparent);
  #|    }
  #|    a[data-slot="badge"]:not([aria-disabled="true"])[data-variant="destructive"]:hover {
  #|      --rui-badge-bg:color-mix(in oklab,var(--rui-destructive,oklch(0.577 0.245 27.325)) 90%,transparent);
  #|    }
  #|    a[data-slot="badge"]:not([aria-disabled="true"]):where([data-variant="outline"],[data-variant="ghost"]):hover {
  #|      --rui-badge-bg:var(--rui-accent,oklch(0.97 0 0));
  #|      --rui-badge-fg:var(--rui-accent-foreground,oklch(0.205 0 0));
  #|    }
  #|    a[data-slot="badge"]:not([aria-disabled="true"])[data-variant="link"]:hover {
  #|      text-decoration-line:underline;
  #|    }
  #|    [data-slot="bubble"][data-variant="default"] > :is(a,button)[data-slot="bubble-content"]:not([aria-disabled="true"],:disabled):hover {
  #|      --rui-bubble-bg:color-mix(in oklch,var(--rui-primary,oklch(0.205 0 0)) 80%,transparent);
  #|    }
  #|    [data-slot="bubble"][data-variant="secondary"] > :is(a,button)[data-slot="bubble-content"]:not([aria-disabled="true"],:disabled):hover {
  #|      --rui-bubble-bg:color-mix(in oklch,var(--rui-secondary,oklch(0.97 0 0)) 95%,var(--rui-foreground,oklch(0.145 0 0)) 5%);
  #|    }
  #|    [data-slot="bubble"][data-variant="muted"] > :is(a,button)[data-slot="bubble-content"]:not([aria-disabled="true"],:disabled):hover {
  #|      --rui-bubble-bg:color-mix(in oklch,var(--rui-muted,oklch(0.97 0 0)) 95%,var(--rui-foreground,oklch(0.145 0 0)) 5%);
  #|    }
  #|    [data-slot="bubble"][data-variant="tinted"] > :is(a,button)[data-slot="bubble-content"]:not([aria-disabled="true"],:disabled):hover {
  #|      --rui-bubble-bg:light-dark(oklch(from var(--rui-primary,oklch(0.205 0 0)) 0.88 calc(c * 0.5) h),oklch(from var(--rui-primary,oklch(0.922 0 0)) 0.35 calc(c * 0.5) h));
  #|    }
  #|    [data-slot="bubble"][data-variant="outline"] > :is(a,button)[data-slot="bubble-content"]:not([aria-disabled="true"],:disabled):hover {
  #|      --rui-bubble-bg:light-dark(var(--rui-muted,oklch(0.97 0 0)),color-mix(in oklch,var(--rui-input,oklch(1 0 0 / 0.15)) 30%,transparent));
  #|      --rui-bubble-fg:var(--rui-foreground,oklch(0.145 0 0));
  #|    }
  #|    [data-slot="bubble"][data-variant="ghost"] > :is(a,button)[data-slot="bubble-content"]:not([aria-disabled="true"],:disabled):hover {
  #|      --rui-bubble-bg:light-dark(var(--rui-muted,oklch(0.97 0 0)),color-mix(in oklch,var(--rui-muted,oklch(0.269 0 0)) 50%,transparent));
  #|      --rui-bubble-fg:var(--rui-foreground,oklch(0.145 0 0));
  #|    }
  #|    [data-slot="bubble"][data-variant="destructive"] > :is(a,button)[data-slot="bubble-content"]:not([aria-disabled="true"],:disabled):hover {
  #|      --rui-bubble-bg:light-dark(color-mix(in oklch,var(--rui-destructive,oklch(0.577 0.245 27.325)) 20%,transparent),color-mix(in oklch,var(--rui-destructive,oklch(0.704 0.191 22.216)) 30%,transparent));
  #|    }
  #|    [data-slot="table-row"]:not([data-state="selected"]):hover {
  #|      --rui-table-row-bg:color-mix(in oklab,var(--rui-muted,oklch(0.97 0 0)) 50%,transparent);
  #|    }
  #|    [data-slot="breadcrumb-link"]:hover {
  #|      --rui-link-fg:var(--rui-foreground,oklch(0.145 0 0));
  #|    }
  #|    :where([data-slot="marker"],[data-slot="marker-content"]) a:hover {
  #|      color:var(--rui-foreground,oklch(0.145 0 0));
  #|    }
  #|    a[data-slot="marker"]:not([aria-disabled="true"]):hover {
  #|      --rui-marker-fg:var(--rui-foreground,oklch(0.145 0 0));
  #|    }
  #|    :where([data-slot="field-description"],[data-slot="empty-description"],[data-slot="item-description"]) > a:hover {
  #|      color:var(--rui-primary,oklch(0.205 0 0));
  #|    }
  #|    :where([data-slot="dialog-close"],[data-slot="sheet-close"],[data-slot="drawer-close"]):hover {
  #|      --rui-close-opacity:1;
  #|    }
  #|  }
  #|  @media (hover: none) {
  #|    [data-slot="sidebar-menu-action"][data-show-on-hover="true"]:not(:disabled):not([aria-disabled="true"]) {
  #|      --rui-sidebar-action-opacity:1;
  #|    }
  #|    [data-slot="sidebar-menu-action"][data-show-on-hover="true"]:where(:disabled,[aria-disabled="true"]) {
  #|      --rui-sidebar-action-opacity:0.5;
  #|    }
  #|  }
  #|
  #|  :where(button,a)[data-variant][data-size]:not([data-slot="toggle"]):not([data-slot="toggle-group-item"]):not(:disabled):not([aria-disabled="true"]):not([aria-haspopup]):active,
  #|  [data-slot="date-picker-trigger"]:not(:disabled):not([aria-disabled="true"]):active,
  #|  :where([data-slot="toggle"],[data-slot="toggle-group-item"]):not(:disabled):not([aria-disabled="true"]):active {
  #|    transform:translateY(1px);
  #|  }
  #|  :is(a,button)[data-slot="bubble-content"]:not(:disabled):not([aria-disabled="true"]):active {
  #|    transform:translateY(1px);
  #|  }
  #|
  #|  [data-slot="slider-control"] {
  #|    pointer-events:none;
  #|  }
  #|  [data-slot="slider-control"]::-webkit-slider-runnable-track {
  #|    border:0;
  #|    background:transparent;
  #|  }
  #|  [data-slot="slider-control"]::-webkit-slider-thumb {
  #|    width:1rem;
  #|    height:1rem;
  #|    border:0;
  #|    background:transparent;
  #|    opacity:0;
  #|    pointer-events:auto;
  #|    -webkit-appearance:none;
  #|  }
  #|  [data-slot="slider-control"]::-moz-range-track {
  #|    border:0;
  #|    background:transparent;
  #|  }
  #|  [data-slot="slider-control"]::-moz-range-thumb {
  #|    width:1rem;
  #|    height:1rem;
  #|    border:0;
  #|    background:transparent;
  #|    opacity:0;
  #|    pointer-events:auto;
  #|  }
  #|  :where([data-slot="field-description"],[data-slot="empty-description"],[data-slot="item-description"]) > a {
  #|    text-decoration-line:underline;
  #|    text-underline-offset:4px;
  #|  }
  #|  [data-slot="calendar"]:dir(rtl) [data-slot="calendar-day"] {
  #|    --rui-calendar-range-start-direction:to left;
  #|    --rui-calendar-range-end-direction:to left;
  #|  }
  #|
  #|  :where(button,a)[data-variant][data-size]:not(:disabled):not([aria-disabled="true"]):focus-visible {
  #|    --rui-button-border:var(--rui-ring,oklch(0.708 0 0));
  #|    --rui-button-shadow:0 0 0 3px color-mix(in oklab,var(--rui-ring,oklch(0.708 0 0)) 50%,transparent),var(--rui-button-base-shadow,0 0 #0000);
  #|    outline:none;
  #|  }
  #|  [data-slot="combobox-chip-remove"]:not(:disabled):not([aria-disabled="true"]):focus-visible {
  #|    --rui-chip-remove-opacity:1;
  #|  }
  #|  :where(button,a)[data-variant="destructive"][data-size]:not(:disabled):not([aria-disabled="true"]):focus-visible {
  #|    --rui-button-shadow:0 0 0 3px var(--rui-destructive-ring,oklch(0.577 0.245 27.325 / 0.2)),var(--rui-button-base-shadow,0 0 #0000);
  #|  }
  #|  :where([data-slot="dialog-close"],[data-slot="sheet-close"],[data-slot="drawer-close"])[data-rui-close-icon]:focus-visible {
  #|    --rui-close-shadow:0 0 0 2px var(--rui-background,oklch(1 0 0)),0 0 0 4px var(--rui-ring,oklch(0.708 0 0));
  #|    outline:none;
  #|  }
  #|  :where([data-slot="input"],[data-slot="textarea"],[data-slot="native-select"],[data-slot="select-trigger"],[data-slot="combobox-trigger"],[data-slot="sidebar-input"],[data-slot="checkbox"],[data-slot="switch"],[data-slot="radio-group-item"],[data-slot="tabs-trigger"]):not(:disabled):not([aria-disabled="true"]):focus-visible {
  #|    --rui-control-border:var(--rui-ring,oklch(0.708 0 0));
  #|    --rui-control-shadow:0 0 0 3px color-mix(in oklab,var(--rui-ring,oklch(0.708 0 0)) 50%,transparent),var(--rui-control-base-shadow,0 0 #0000);
  #|    outline:none;
  #|  }
  #|  :where([data-slot="calendar-previous"],[data-slot="calendar-next"],[data-slot="calendar-day-button"]):not(:disabled):not([aria-disabled="true"]):focus-visible {
  #|    --rui-calendar-border:var(--rui-ring,oklch(0.708 0 0));
  #|    --rui-calendar-shadow:0 0 0 3px color-mix(in oklab,var(--rui-ring,oklch(0.708 0 0)) 50%,transparent),var(--rui-calendar-base-shadow,0 0 #0000);
  #|    outline:none;
  #|  }
  #|  [data-slot="slider-thumb"]:has(+ [data-slot="slider-control"]:not(:disabled):focus-visible) {
  #|    --rui-slider-thumb-shadow:0 0 0 4px color-mix(in oklab,var(--rui-ring,oklch(0.708 0 0)) 50%,transparent),var(--rui-slider-thumb-base-shadow,0 1px 2px rgb(0 0 0 / 0.1));
  #|  }
  #|  [data-slot="slider-control"]:not(:disabled):focus-visible {
  #|    outline:none;
  #|  }
  #|  [data-slot="input-group"]:has([data-slot="input-group-control"]:focus-visible),
  #|  :where([data-slot="combobox-control"],[data-slot="combobox-chips"]):focus-within {
  #|    --rui-control-border:var(--rui-ring,oklch(0.708 0 0));
  #|    --rui-control-shadow:0 0 0 3px color-mix(in oklab,var(--rui-ring,oklch(0.708 0 0)) 50%,transparent),var(--rui-control-base-shadow,0 0 #0000);
  #|  }
  #|  [data-slot="combobox-chips"]:has([aria-invalid="true"]) {
  #|    --rui-control-border:var(--rui-destructive-border,var(--rui-destructive,oklch(0.577 0.245 27.325)));
  #|    --rui-control-shadow:0 0 0 3px var(--rui-destructive-ring,oklch(0.577 0.245 27.325 / 0.2));
  #|  }
  #|  [data-slot="field-label"]:has(> [data-slot="field"]) {
  #|    --rui-field-label-width:100%;
  #|    --rui-field-label-direction:column;
  #|    --rui-field-label-align:stretch;
  #|    --rui-field-label-border-width:1px;
  #|    --rui-field-label-border:var(--rui-border,oklch(0.922 0 0));
  #|    --rui-field-label-radius:calc(var(--rui-radius,0.625rem) - 0.125rem);
  #|  }
  #|  [data-slot="field-label"] > [data-slot="field"] {
  #|    padding:1rem;
  #|  }
  #|  [data-slot="field-label"]:has(:where([data-slot="checkbox"],[data-slot="radio-group-item"])[data-state="checked"]) {
  #|    --rui-field-label-border:var(--rui-primary,oklch(0.205 0 0));
  #|    --rui-field-label-bg:var(--rui-field-label-checked-bg,color-mix(in oklab,var(--rui-primary,oklch(0.205 0 0)) 5%,transparent));
  #|  }
  #|  :where([data-slot="toggle"],[data-slot="toggle-group-item"]):not(:disabled):not([aria-disabled="true"]):focus-visible {
  #|    --rui-toggle-border:var(--rui-ring,oklch(0.708 0 0));
  #|    --rui-toggle-shadow:0 0 0 3px color-mix(in oklab,var(--rui-ring,oklch(0.708 0 0)) 50%,transparent),var(--rui-toggle-base-shadow,0 0 #0000);
  #|    outline:none;
  #|  }
  #|  :where([role^="menuitem"],[data-slot="select-item"],[data-slot="combobox-item"],[data-slot="command-item"]):not([aria-disabled="true"]):where(:focus,[data-highlighted="true"],[data-selected="true"]) {
  #|    --rui-menu-item-bg:var(--rui-accent,oklch(0.97 0 0));
  #|    --rui-menu-item-fg:var(--rui-accent-foreground,oklch(0.205 0 0));
  #|    outline:none;
  #|  }
  #|  :where([role^="menuitem"])[data-variant="destructive"]:not([aria-disabled="true"]):where(:focus,[data-highlighted="true"]) {
  #|    --rui-menu-item-bg:var(--rui-destructive-subtle,oklch(0.577 0.245 27.325 / 0.1));
  #|    --rui-menu-item-fg:var(--rui-destructive,oklch(0.577 0.245 27.325));
  #|  }
  #|  :where([data-slot="dropdown-menu-sub-trigger"],[data-slot="context-menu-sub-trigger"],[data-slot="menubar-sub-trigger"],[data-slot="menubar-trigger"])[data-state="open"] {
  #|    --rui-menu-item-bg:var(--rui-accent,oklch(0.97 0 0));
  #|    --rui-menu-item-fg:var(--rui-accent-foreground,oklch(0.205 0 0));
  #|  }
  #|  :where([data-slot="toggle"],[data-slot="toggle-group-item"]):not(:disabled):not([aria-disabled="true"])[data-variant][data-state="on"] {
  #|    --rui-toggle-bg:var(--rui-accent,oklch(0.97 0 0));
  #|    --rui-toggle-fg:var(--rui-accent-foreground,oklch(0.205 0 0));
  #|  }
  #|  [data-slot="button-group"] > :where(button,a,[role="button"]):focus-visible {
  #|    position:relative;
  #|    z-index:10;
  #|  }
  #|  [data-slot="button-group"][data-orientation="horizontal"]:dir(ltr) > :not(:first-child) {
  #|    --rui-control-border-left-width:0px;
  #|    --rui-control-radius-top-left:0px;
  #|    --rui-control-radius-bottom-left:0px;
  #|  }
  #|  [data-slot="button-group"][data-orientation="horizontal"]:dir(ltr) > :not(:last-child) {
  #|    --rui-control-radius-top-right:0px;
  #|    --rui-control-radius-bottom-right:0px;
  #|  }
  #|  [data-slot="button-group"][data-orientation="horizontal"]:dir(rtl) > :not(:first-child) {
  #|    --rui-control-border-right-width:0px;
  #|    --rui-control-radius-top-right:0px;
  #|    --rui-control-radius-bottom-right:0px;
  #|  }
  #|  [data-slot="button-group"][data-orientation="horizontal"]:dir(rtl) > :not(:last-child) {
  #|    --rui-control-radius-top-left:0px;
  #|    --rui-control-radius-bottom-left:0px;
  #|  }
  #|  [data-slot="button-group"][data-orientation="vertical"] > :not(:first-child) {
  #|    --rui-control-border-top-width:0px;
  #|    --rui-control-radius-top-left:0px;
  #|    --rui-control-radius-top-right:0px;
  #|  }
  #|  [data-slot="button-group"][data-orientation="vertical"] > :not(:last-child) {
  #|    --rui-control-radius-bottom-left:0px;
  #|    --rui-control-radius-bottom-right:0px;
  #|  }
  #|  [data-slot="toggle-group"][data-spacing="0"] > [data-slot="toggle-group-item"]:focus,
  #|  [data-slot="toggle-group"][data-spacing="0"] > [data-slot="toggle-group-item"]:focus-visible {
  #|    z-index:10;
  #|  }
  #|  [data-slot="toggle-group"][data-spacing="0"][data-orientation="horizontal"] > [data-slot="toggle-group-item"][data-variant="outline"]:not(:first-child) {
  #|    --rui-toggle-border-inline-start-width:0px;
  #|  }
  #|  [data-slot="toggle-group"][data-spacing="0"][data-orientation="horizontal"]:dir(ltr) > [data-slot="toggle-group-item"]:first-child,
  #|  [data-slot="toggle-group"][data-spacing="0"][data-orientation="horizontal"]:dir(rtl) > [data-slot="toggle-group-item"]:last-child {
  #|    --rui-toggle-radius:var(--rui-control-radius,calc(var(--rui-radius,0.625rem) - 0.125rem)) 0 0 var(--rui-control-radius,calc(var(--rui-radius,0.625rem) - 0.125rem));
  #|  }
  #|  [data-slot="toggle-group"][data-spacing="0"][data-orientation="horizontal"]:dir(ltr) > [data-slot="toggle-group-item"]:last-child,
  #|  [data-slot="toggle-group"][data-spacing="0"][data-orientation="horizontal"]:dir(rtl) > [data-slot="toggle-group-item"]:first-child {
  #|    --rui-toggle-radius:0 var(--rui-control-radius,calc(var(--rui-radius,0.625rem) - 0.125rem)) var(--rui-control-radius,calc(var(--rui-radius,0.625rem) - 0.125rem)) 0;
  #|  }
  #|  [data-slot="toggle-group"][data-spacing="0"][data-orientation="vertical"] > [data-slot="toggle-group-item"][data-variant="outline"]:not(:first-child) {
  #|    --rui-toggle-border-block-start-width:0px;
  #|  }
  #|  [data-slot="toggle-group"][data-spacing="0"][data-orientation="vertical"] > [data-slot="toggle-group-item"]:first-child {
  #|    --rui-toggle-radius:var(--rui-control-radius,calc(var(--rui-radius,0.625rem) - 0.125rem)) var(--rui-control-radius,calc(var(--rui-radius,0.625rem) - 0.125rem)) 0 0;
  #|  }
  #|  [data-slot="toggle-group"][data-spacing="0"][data-orientation="vertical"] > [data-slot="toggle-group-item"]:last-child {
  #|    --rui-toggle-radius:0 0 var(--rui-control-radius,calc(var(--rui-radius,0.625rem) - 0.125rem)) var(--rui-control-radius,calc(var(--rui-radius,0.625rem) - 0.125rem));
  #|  }
  #|  [data-slot="toggle-group"][data-spacing="0"] > [data-slot="toggle-group-item"]:only-child {
  #|    --rui-toggle-radius:var(--rui-control-radius,calc(var(--rui-radius,0.625rem) - 0.125rem));
  #|  }
  #|  [data-slot="alert"]:dir(rtl) > [data-slot="alert-action"] {
  #|    --rui-alert-action-offset-inline:-0.25rem;
  #|  }
  #|  [data-slot="navigation-menu-trigger"][data-state="open"] {
  #|    --rui-nav-bg:color-mix(in oklab,var(--rui-accent,oklch(0.97 0 0)) 50%,transparent);
  #|    --rui-nav-fg:var(--rui-accent-foreground,oklch(0.205 0 0));
  #|  }
  #|  :where([data-slot="navigation-menu-trigger"],[data-slot="navigation-menu-link"]):focus {
  #|    --rui-nav-bg:var(--rui-accent,oklch(0.97 0 0));
  #|    --rui-nav-fg:var(--rui-accent-foreground,oklch(0.205 0 0));
  #|    outline:none;
  #|  }
  #|  :where([data-slot="navigation-menu-trigger"],[data-slot="navigation-menu-link"]):focus-visible {
  #|    --rui-nav-shadow:0 0 0 3px color-mix(in oklab,var(--rui-ring,oklch(0.708 0 0)) 50%,transparent);
  #|    outline:none;
  #|  }
  #|  :where([data-slot="sidebar-menu-button"],[data-slot="sidebar-menu-sub-button"]):not(:disabled):not([aria-disabled="true"]):focus-visible {
  #|    --rui-sidebar-item-border:var(--rui-sidebar-ring,var(--rui-ring,oklch(0.708 0 0)));
  #|    --rui-sidebar-item-shadow:0 0 0 2px color-mix(in oklab,var(--rui-sidebar-ring,var(--rui-ring,oklch(0.708 0 0))) 50%,transparent);
  #|    outline:none;
  #|  }
  #|  :where([data-slot="sidebar-group-action"],[data-slot="sidebar-menu-action"]):not(:disabled):not([aria-disabled="true"]):focus-visible {
  #|    --rui-sidebar-action-shadow:0 0 0 2px color-mix(in oklab,var(--rui-sidebar-ring,var(--rui-ring,oklch(0.708 0 0))) 50%,transparent);
  #|    outline:none;
  #|  }
  #|  :where([data-slot="accordion-trigger"],[data-slot="collapsible-trigger"]):not([aria-disabled="true"]):focus-visible {
  #|    --rui-accordion-border:var(--rui-ring,oklch(0.708 0 0));
  #|    --rui-accordion-shadow:0 0 0 3px color-mix(in oklab,var(--rui-ring,oklch(0.708 0 0)) 50%,transparent);
  #|    outline:none;
  #|  }
  #|  [data-slot="navigation-menu-link"][data-active="true"] {
  #|    --rui-nav-bg:color-mix(in oklab,var(--rui-accent,oklch(0.97 0 0)) 50%,transparent);
  #|    --rui-nav-fg:var(--rui-accent-foreground,oklch(0.205 0 0));
  #|  }
  #|  [data-slot="navigation-menu-trigger"][data-state="open"]:not(:disabled):focus,
  #|  [data-slot="navigation-menu-link"][data-active="true"]:not(:disabled):focus {
  #|    --rui-nav-bg:var(--rui-accent,oklch(0.97 0 0));
  #|    --rui-nav-fg:var(--rui-accent-foreground,oklch(0.205 0 0));
  #|    outline:none;
  #|  }
  #|  :where([data-slot="sidebar-menu-button"],[data-slot="sidebar-menu-sub-button"]):where(:active,[data-active="true"]) {
  #|    --rui-sidebar-item-bg:var(--rui-sidebar-accent,var(--rui-accent,oklch(0.97 0 0)));
  #|    --rui-sidebar-item-fg:var(--rui-sidebar-accent-foreground,var(--rui-accent-foreground,oklch(0.205 0 0)));
  #|  }
  #|  [data-slot="sidebar-menu-button"][data-active="true"] ~ [data-slot="sidebar-menu-badge"] {
  #|    --rui-sidebar-badge-fg:var(--rui-sidebar-accent-foreground,var(--rui-accent-foreground,oklch(0.205 0 0)));
  #|  }
  #|  [data-slot="sidebar-menu-button"][data-active="true"] ~ [data-slot="sidebar-menu-action"] {
  #|    --rui-button-fg:var(--rui-sidebar-accent-foreground,var(--rui-accent-foreground,oklch(0.205 0 0)));
  #|  }
  #|  [data-slot="sidebar-menu-item"]:focus-within > [data-slot="sidebar-menu-action"][data-show-on-hover="true"]:not(:disabled):not([aria-disabled="true"]) {
  #|    --rui-sidebar-action-opacity:1;
  #|  }
  #|  [data-slot="sidebar-menu-item"]:focus-within > [data-slot="sidebar-menu-action"][data-show-on-hover="true"]:where(:disabled,[aria-disabled="true"]) {
  #|    --rui-sidebar-action-opacity:0.5;
  #|  }
  #|  [data-slot="sidebar-menu-action"][data-show-on-hover="true"][data-state="open"] {
  #|    --rui-sidebar-action-opacity:1;
  #|  }
  #|  [data-slot="attachment"]:focus-within {
  #|    --rui-attachment-shadow:0 0 0 1px color-mix(in oklab,var(--rui-ring,oklch(0.708 0 0)) 50%,transparent);
  #|  }
  #|  [data-slot="table-row"]:has([aria-expanded="true"]) {
  #|    --rui-table-row-bg:color-mix(in oklab,var(--rui-muted,oklch(0.97 0 0)) 50%,transparent);
  #|  }
  #|  [data-slot="resizable-handle"]:has([data-slot="resizable-control"]:focus-visible) {
  #|    box-shadow:0 0 0 1px var(--rui-ring,oklch(0.708 0 0));
  #|    outline:none;
  #|  }
  #|  :where([data-slot="scroll-area"],[data-slot="scroll-area-viewport"]):focus-visible {
  #|    box-shadow:0 0 0 3px color-mix(in oklab,var(--rui-ring,oklch(0.708 0 0)) 50%,transparent);
  #|    outline:1px solid var(--rui-ring,oklch(0.708 0 0));
  #|  }
  #|  @media (prefers-reduced-motion:reduce) {
  #|    [data-slot="spinner"] svg,
  #|    [data-slot="skeleton"],
  #|    [data-slot="attachment-title"],
  #|    [data-slot="input-otp-caret"] > span {
  #|      animation:none !important;
  #|    }
  #|    :where([data-slot="accordion-content"],[data-slot="collapsible-content"],[data-slot="carousel-track"],[data-slot="toast"],[data-slot="dialog-overlay"],[data-slot="dialog-content"],[data-slot="alert-dialog-overlay"],[data-slot="alert-dialog-content"],[data-slot="sheet-overlay"],[data-slot="sheet-content"],[data-slot="drawer-overlay"],[data-slot="drawer-content"],[data-slot="command-dialog-overlay"],[data-slot="command-dialog-content"]) {
  #|      animation:none !important;
  #|      transition-duration:0.01ms !important;
  #|    }
  #|  }
  #|}
  #|

///|
pub(all) enum ColorMode {
  Light
  Dark
} derive(Debug, Eq)

///|
const ThemeBaseStyle : String = "background:var(--rui-background);color:var(--rui-foreground)"

///|
const ThemeLightStyle : String = "color-scheme:light;--rui-radius:0.625rem;--rui-background:oklch(1 0 0);--rui-foreground:oklch(0.145 0 0);--rui-card:oklch(1 0 0);--rui-card-foreground:oklch(0.145 0 0);--rui-popover:oklch(1 0 0);--rui-popover-foreground:oklch(0.145 0 0);--rui-primary:oklch(0.205 0 0);--rui-primary-foreground:oklch(0.985 0 0);--rui-secondary:oklch(0.97 0 0);--rui-secondary-foreground:oklch(0.205 0 0);--rui-muted:oklch(0.97 0 0);--rui-muted-foreground:oklch(0.556 0 0);--rui-accent:oklch(0.97 0 0);--rui-accent-foreground:oklch(0.205 0 0);--rui-destructive:oklch(0.577 0.245 27.325);--rui-destructive-border:oklch(0.577 0.245 27.325);--rui-destructive-subtle:oklch(0.577 0.245 27.325 / 0.1);--rui-destructive-surface:var(--rui-destructive);--rui-destructive-ring:oklch(0.577 0.245 27.325 / 0.2);--rui-border:oklch(0.922 0 0);--rui-input:oklch(0.922 0 0);--rui-input-background:transparent;--rui-outline-background:oklch(1 0 0);--rui-outline-border:oklch(0.922 0 0);--rui-outline-hover-bg:oklch(0.97 0 0);--rui-ghost-hover-bg:oklch(0.97 0 0);--rui-select-hover-bg:var(--rui-control-base-bg,transparent);--rui-tabs-active-bg:var(--rui-background);--rui-tabs-active-border:transparent;--rui-field-label-checked-bg:color-mix(in oklab,var(--rui-primary) 5%,transparent);--rui-ring:oklch(0.708 0 0);--rui-switch-unchecked:oklch(0.922 0 0);--rui-switch-thumb-checked:oklch(1 0 0);--rui-switch-thumb-unchecked:oklch(1 0 0)"

///|
const ThemeDarkStyle : String = "color-scheme:dark;--rui-radius:0.625rem;--rui-background:oklch(0.145 0 0);--rui-foreground:oklch(0.985 0 0);--rui-card:oklch(0.205 0 0);--rui-card-foreground:oklch(0.985 0 0);--rui-popover:oklch(0.205 0 0);--rui-popover-foreground:oklch(0.985 0 0);--rui-primary:oklch(0.922 0 0);--rui-primary-foreground:oklch(0.205 0 0);--rui-secondary:oklch(0.269 0 0);--rui-secondary-foreground:oklch(0.985 0 0);--rui-muted:oklch(0.269 0 0);--rui-muted-foreground:oklch(0.708 0 0);--rui-accent:oklch(0.269 0 0);--rui-accent-foreground:oklch(0.985 0 0);--rui-destructive:oklch(0.704 0.191 22.216);--rui-destructive-border:oklch(0.704 0.191 22.216 / 0.5);--rui-destructive-subtle:oklch(0.704 0.191 22.216 / 0.2);--rui-destructive-surface:color-mix(in oklab,var(--rui-destructive) 60%,transparent);--rui-destructive-ring:oklch(0.704 0.191 22.216 / 0.4);--rui-border:oklch(1 0 0 / 0.1);--rui-input:oklch(1 0 0 / 0.15);--rui-input-background:oklch(1 0 0 / 0.045);--rui-outline-background:oklch(1 0 0 / 0.045);--rui-outline-border:oklch(1 0 0 / 0.15);--rui-outline-hover-bg:color-mix(in oklab,oklch(1 0 0 / 0.15) 50%,transparent);--rui-ghost-hover-bg:color-mix(in oklab,oklch(0.269 0 0) 50%,transparent);--rui-select-hover-bg:color-mix(in oklab,var(--rui-input) 50%,transparent);--rui-tabs-active-bg:var(--rui-outline-background);--rui-tabs-active-border:var(--rui-input);--rui-field-label-checked-bg:color-mix(in oklab,var(--rui-primary) 10%,transparent);--rui-ring:oklch(0.556 0 0);--rui-switch-unchecked:oklch(1 0 0 / 0.12);--rui-switch-thumb-checked:oklch(0.205 0 0);--rui-switch-thumb-unchecked:oklch(0.985 0 0)"

///|
fn theme_mode_style(mode : ColorMode) -> String {
  match mode {
    Light => ThemeLightStyle
    Dark => ThemeDarkStyle
  }
}

///|
fn ui_disabled_style(disabled : Bool) -> String {
  if disabled {
    UiDisabled
  } else {
    ""
  }
}

///|
fn ui_disabled_visual_style(disabled : Bool) -> String {
  if disabled {
    UiDisabledVisual
  } else {
    ""
  }
}

///|
fn ui_bool(value : Bool) -> String {
  if value {
    "true"
  } else {
    "false"
  }
}

///|
fn ui_attrs(attrs : @html.Attrs?) -> @html.Attrs {
  if attrs is Some(attrs) {
    attrs.copy()
  } else {
    @html.Attrs::build()
  }
}

///|
fn ui_styles(parts : Array[String], extra : Array[String]) -> Array[String] {
  let styles : Array[String] = []
  for part in parts {
    if part != "" {
      styles.push(part)
    }
  }
  for part in extra {
    if part != "" {
      styles.push(part)
    }
  }
  styles
}

///|
#warnings("-alert_xss_vulnerable")
fn ui_interaction_stylesheet() -> @html.Html {
  // `UiInteractionCss` is a closed library constant. `inner_html` is required
  // here so SSR does not escape CSS selectors; no caller input reaches it.
  let attrs = @html.Attrs::build()
    .data_set("rui-style", "interactions")
    .inner_html(UiInteractionCss)
  @html.style_tag(attrs~, ([] : Array[@html.Html]))
}

///|
/// Provide the official shadcn Neutral tokens to a subtree.
///
/// The wrapper emits the library's static pseudo-class interaction sheet, so
/// no external CSS import or runtime stylesheet registration is required.
/// Every component still carries light-theme fallback values. Append custom
/// CSS variables through `style` to override any token.
pub fn[C : @html.IsChildren] theme(
  mode? : ColorMode = Light,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let element_attrs = ui_attrs(attrs).data_set("rui-theme", "")
  @html.fragment([
    ui_interaction_stylesheet(),
    @html.div(
      style=ui_styles(
        [
          UiBoxSizing,
          UiFontSans,
          UiTextRendering,
          theme_mode_style(mode),
          ThemeBaseStyle,
        ],
        style,
      ),
      id?,
      class?,
      title?,
      attrs=element_attrs,
      children,
    ),
  ])
}
