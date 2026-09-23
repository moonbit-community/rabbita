///|
// Capture demo links before Rabbita's per-anchor routing listener runs.
// The guard is scoped to previews so the site's own navigation remains active.
extern "js" fn install_showcase_navigation_guard() -> Unit =
  #| () => {
  #|   const blockDemoLink = event => {
  #|     const target = event.target instanceof Element
  #|       ? event.target : event.target?.parentElement;
  #|     const link = target?.closest('.rui-showcase-demo-preview a[href]');
  #|     if (!link) return;
  #|     event.preventDefault();
  #|     event.stopPropagation();
  #|     if (event.type !== 'click' || event.button !== 0 ||
  #|         event.metaKey || event.ctrlKey || event.shiftKey || event.altKey) return;
  #|     const href = link.getAttribute('href');
  #|     if (!href?.startsWith('#') || href.length < 2) return;
  #|     let id;
  #|     try { id = decodeURIComponent(href.slice(1)); } catch { return; }
  #|     const scope = link.closest('[data-slot="markdown"]') ||
  #|       link.closest('.rui-showcase-demo-preview');
  #|     const destination = Array.from(scope.querySelectorAll('[id]'))
  #|       .find(element => element.id === id);
  #|     if (!destination) return;
  #|     destination.scrollIntoView({ block: 'start' });
  #|     if (!destination.hasAttribute('tabindex')) destination.setAttribute('tabindex', '-1');
  #|     destination.focus({ preventScroll: true });
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
