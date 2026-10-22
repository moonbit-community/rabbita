///|
const TooltipInteractionCss : String =
  #|@layer rui-interactions {
  #|  @keyframes rui-tooltip-in {
  #|    from { opacity:0;transform:translate(var(--rui-tooltip-enter-x,0px),var(--rui-tooltip-enter-y,0px)) scale(0.95); }
  #|    to { opacity:1;transform:translate(0,0) scale(1); }
  #|  }
  #|  @keyframes rui-tooltip-out {
  #|    from { opacity:1;transform:scale(1); }
  #|    to { opacity:0;transform:scale(0.95); }
  #|  }
  #|  [data-slot="tooltip"] {
  #|    --rui-tooltip-visibility:hidden;
  #|    --rui-tooltip-opacity:0;
  #|    --rui-tooltip-animation:rui-tooltip-out;
  #|    --rui-tooltip-wait:var(--rui-tooltip-close-delay,0ms);
  #|    --rui-tooltip-visibility-wait:calc(var(--rui-tooltip-close-delay,0ms) + 100ms);
  #|  }
  #|  [data-slot="tooltip"]:not([data-disabled="true"]):has(> :is([data-slot="tooltip-trigger"],[data-slot="sidebar-menu-button"]):hover) {
  #|    --rui-tooltip-visibility:visible;
  #|    --rui-tooltip-opacity:1;
  #|    --rui-tooltip-animation:rui-tooltip-in;
  #|    --rui-tooltip-wait:var(--rui-tooltip-delay,0ms);
  #|    --rui-tooltip-visibility-wait:var(--rui-tooltip-delay,0ms);
  #|  }
  #|  [data-sidebar-collapsed-only="true"] > [data-slot="tooltip-content"] {
  #|    --rui-tooltip-visibility:hidden;
  #|    --rui-tooltip-opacity:0;
  #|    --rui-tooltip-animation:none;
  #|    --rui-tooltip-visibility-wait:0ms;
  #|  }
  #|  [data-slot="sidebar"][data-collapsible="icon"][data-state="collapsed"]:not([data-mobile="true"]) [data-sidebar-collapsed-only="true"] > [data-slot="tooltip-content"] {
  #|    --rui-tooltip-visibility:inherit;
  #|    --rui-tooltip-opacity:inherit;
  #|    --rui-tooltip-animation:inherit;
  #|    --rui-tooltip-visibility-wait:inherit;
  #|  }
  #|  :where([data-slot="tooltip-content"][data-side="top"]) {
  #|    --rui-tooltip-enter-y:8px;
  #|    --rui-tooltip-bottom:calc(100% + var(--rui-tooltip-side-offset,4px));
  #|  }
  #|  :where([data-slot="tooltip-content"][data-side="bottom"]) {
  #|    --rui-tooltip-enter-y:-8px;
  #|    --rui-tooltip-top:calc(100% + var(--rui-tooltip-side-offset,4px));
  #|  }
  #|  :where([data-slot="tooltip-content"][data-side="right"]) {
  #|    --rui-tooltip-enter-x:-8px;
  #|    --rui-tooltip-left:calc(100% + var(--rui-tooltip-side-offset,4px));
  #|  }
  #|  :where([data-slot="tooltip-content"][data-side="left"]) {
  #|    --rui-tooltip-enter-x:8px;
  #|    --rui-tooltip-right:calc(100% + var(--rui-tooltip-side-offset,4px));
  #|  }
  #|  :where([data-slot="tooltip-content"]:is([data-side="top"],[data-side="bottom"])[data-align="start"]) {
  #|    --rui-tooltip-left:var(--rui-tooltip-align-offset,0px);
  #|  }
  #|  :where([data-slot="tooltip-content"]:is([data-side="top"],[data-side="bottom"])[data-align="center"]) {
  #|    --rui-tooltip-left:calc(50% + var(--rui-tooltip-align-offset,0px));
  #|    --rui-tooltip-translate:-50% 0;
  #|  }
  #|  :where([data-slot="tooltip-content"]:is([data-side="top"],[data-side="bottom"])[data-align="end"]) {
  #|    --rui-tooltip-right:calc(-1 * var(--rui-tooltip-align-offset,0px));
  #|  }
  #|  :where([data-slot="tooltip-content"]:is([data-side="left"],[data-side="right"])[data-align="start"]) {
  #|    --rui-tooltip-top:var(--rui-tooltip-align-offset,0px);
  #|  }
  #|  :where([data-slot="tooltip-content"]:is([data-side="left"],[data-side="right"])[data-align="center"]) {
  #|    --rui-tooltip-top:calc(50% + var(--rui-tooltip-align-offset,0px));
  #|    --rui-tooltip-translate:0 -50%;
  #|  }
  #|  :where([data-slot="tooltip-content"]:is([data-side="left"],[data-side="right"])[data-align="end"]) {
  #|    --rui-tooltip-bottom:calc(-1 * var(--rui-tooltip-align-offset,0px));
  #|  }
  #|  @supports (top:anchor(top)) {
  #|    [data-slot="tooltip-content"] {
  #|      --rui-tooltip-position:fixed;
  #|      --rui-tooltip-left:auto;
  #|      --rui-tooltip-right:auto;
  #|      --rui-tooltip-top:auto;
  #|      --rui-tooltip-bottom:auto;
  #|      --rui-tooltip-x:0px;
  #|      --rui-tooltip-y:0px;
  #|      --rui-tooltip-translate:var(--rui-tooltip-x) var(--rui-tooltip-y);
  #|    }
  #|    [data-slot="tooltip-content"][data-side="top"] {
  #|      --rui-tooltip-top:calc(anchor(top) - var(--rui-tooltip-side-offset,4px));
  #|      --rui-tooltip-y:-100%;
  #|    }
  #|    [data-slot="tooltip-content"][data-side="bottom"] {
  #|      --rui-tooltip-top:calc(anchor(bottom) + var(--rui-tooltip-side-offset,4px));
  #|    }
  #|    [data-slot="tooltip-content"][data-side="left"] {
  #|      --rui-tooltip-left:calc(anchor(left) - var(--rui-tooltip-side-offset,4px));
  #|      --rui-tooltip-x:-100%;
  #|    }
  #|    [data-slot="tooltip-content"][data-side="right"] {
  #|      --rui-tooltip-left:calc(anchor(right) + var(--rui-tooltip-side-offset,4px));
  #|    }
  #|    [data-slot="tooltip-content"]:is([data-side="top"],[data-side="bottom"])[data-align="start"] {
  #|      --rui-tooltip-left:calc(anchor(left) + var(--rui-tooltip-align-offset,0px));
  #|    }
  #|    [data-slot="tooltip-content"]:is([data-side="top"],[data-side="bottom"])[data-align="center"] {
  #|      --rui-tooltip-left:calc(anchor(center) + var(--rui-tooltip-align-offset,0px));
  #|      --rui-tooltip-x:-50%;
  #|    }
  #|    [data-slot="tooltip-content"]:is([data-side="top"],[data-side="bottom"])[data-align="end"] {
  #|      --rui-tooltip-left:calc(anchor(right) + var(--rui-tooltip-align-offset,0px));
  #|      --rui-tooltip-x:-100%;
  #|    }
  #|    [data-slot="tooltip-content"]:is([data-side="left"],[data-side="right"])[data-align="start"] {
  #|      --rui-tooltip-top:calc(anchor(top) + var(--rui-tooltip-align-offset,0px));
  #|    }
  #|    [data-slot="tooltip-content"]:is([data-side="left"],[data-side="right"])[data-align="center"] {
  #|      --rui-tooltip-top:calc(anchor(center) + var(--rui-tooltip-align-offset,0px));
  #|      --rui-tooltip-y:-50%;
  #|    }
  #|    [data-slot="tooltip-content"]:is([data-side="left"],[data-side="right"])[data-align="end"] {
  #|      --rui-tooltip-top:calc(anchor(bottom) + var(--rui-tooltip-align-offset,0px));
  #|      --rui-tooltip-y:-100%;
  #|    }
  #|  }
  #|  @media (prefers-reduced-motion:reduce) {
  #|    [data-slot="tooltip"] > [data-slot="tooltip-content"] {
  #|      animation:none !important;
  #|      transition:none !important;
  #|    }
  #|  }
  #|}
