///|
// Capture demo links before Rabbita's per-anchor routing listener runs.
// The guard is scoped to previews so the site's own navigation remains active.
extern "js" fn install_showcase_navigation_guard() -> Unit =
  #| () => {
  #|   const blockDemoLink = event => {
  #|     const target = event.target instanceof Element
  #|       ? event.target : event.target?.parentElement;
  #|     if (!target?.closest('.rui-showcase-demo-preview a[href]')) return;
  #|     event.preventDefault();
  #|     event.stopPropagation();
  #|   };
  #|   document.addEventListener('click', blockDemoLink, true);
  #|   document.addEventListener('auxclick', blockDemoLink, true);
  #|   document.addEventListener('submit', event => {
  #|     if (event.target instanceof Element &&
  #|         event.target.closest('.rui-showcase-demo-preview')) {
  #|       event.preventDefault();
  #|     }
  #|   }, true);
  #| }
