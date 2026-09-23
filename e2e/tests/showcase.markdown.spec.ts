import { expect, test } from '@playwright/test';

const markdown = '[data-slot="markdown"]';

test.beforeEach(async ({ page }) => {
  await page.goto('/components/markdown/');
  await expect(page.locator(markdown)).toHaveCount(5);
});

test('complete ripgrep README renders its headings, benchmarks, commands and final section', async ({ page }) => {
  const readme = page.locator(markdown).nth(1);
  await expect(readme.locator('h2')).toHaveText('ripgrep (rg)');
  await expect(readme.locator('table')).toHaveCount(6);
  await expect(readme.locator('img')).toHaveCount(4);
  expect(await readme.locator('pre').count()).toBeGreaterThanOrEqual(30);
  await expect(readme.getByRole('button', { name: 'Copy code', exact: true })).toHaveCount(31);
  await expect(readme.locator('h3').last()).toHaveText('Translations');
  await expect(readme.getByRole('link', { name: 'Configuration files', exact: true }))
    .toHaveAttribute('href', 'GUIDE.md#configuration-file');
  await expect(readme.getByRole('link', { name: 'Installation', exact: true })).toHaveAttribute('href', '#installation');
});

test('code copy buttons float at the first line without reserving a column or obscuring the second line and copy the full source by pointer and keyboard', async ({ page, context }) => {
  await context.grantPermissions(['clipboard-read', 'clipboard-write']);
  await page.setViewportSize({ width: 390, height: 844 });
  const sample = page.locator(markdown).first();
  for (const [index, selector] of ['code.language-moonbit', 'code.language-html'].entries()) {
    const code = sample.locator(selector);
    const frame = code.locator('xpath=ancestor::div[@class="rui-markdown-code"]');
    const button = frame.getByRole('button', { name: 'Copy code', exact: true });
    const scroller = frame.locator('pre');
    await frame.scrollIntoViewIfNeeded();
    const before = await button.boundingBox();
    const bounds = await frame.boundingBox();
    expect(before).toBeTruthy();
    expect(bounds).toBeTruthy();
    expect(before!.y - bounds!.y).toBeLessThan(18);
    expect(bounds!.x + bounds!.width - before!.x - before!.width).toBeLessThan(18);
    await scroller.evaluate(element => { element.scrollLeft = element.scrollWidth; });
    const after = await button.boundingBox();
    expect(after!.x).toBe(before!.x);
    const preBounds = await scroller.boundingBox();
    await expect(button).toHaveCSS('position', 'absolute');
    await expect(frame.locator('.rui-markdown-code-toolbar')).toHaveCount(0);
    const secondLineTop = await code.evaluate(e => {
      const style = getComputedStyle(e);
      return e.getBoundingClientRect().y + parseFloat(style.lineHeight);
    });
    const iconBackground = await button.locator(':scope > span').boundingBox();
    expect(iconBackground!.y + iconBackground!.height).toBeLessThanOrEqual(secondLineTop);
    expect(before!.width).toBe(44);
    expect(before!.height).toBe(44);
    expect(iconBackground!.width).toBe(32);
    expect(iconBackground!.height).toBe(32);
    await expect(button.locator('svg')).toHaveAttribute('width', '16');
    expect(preBounds!.width).toBeGreaterThan(bounds!.width - 3);
    const source = await code.textContent();
    if (index === 0) await button.click({ position: { x: 2, y: 40 } });
    else { await button.focus(); await button.press('Enter'); }
    await expect.poll(() => page.evaluate(() => navigator.clipboard.readText())).toBe(source);
  }
});

test('tasks, column alignment, source rendering and footnote references retain their meaning', async ({ page }) => {
  const sample = page.locator(markdown).first();
  const tasks = sample.getByRole('checkbox');
  await expect(tasks).toHaveCount(3);
  await expect(tasks.nth(0)).toBeChecked();
  await expect(tasks.nth(2)).not.toBeChecked();
  for (const checkbox of await tasks.all()) await expect(checkbox).toBeDisabled();
  for (const [index, alignment] of ['left', 'center', 'right'].entries()) {
    await expect(sample.locator('th').nth(index)).toHaveCSS('text-align', alignment);
  }
  await expect(sample.locator('ol').first()).toHaveAttribute('start', '3');
  await expect(sample.locator('pre code.language-html')).toContainText('<summary>Example</summary>');
  await expect(sample.locator('details, summary, kbd, script')).toHaveCount(0);
  await expect(sample).toContainText('Inline <kbd>Enter</kbd> remains visible source.');
  await expect(sample.locator('code.language-mermaid')).toHaveText('graph LR; Markdown-->Html');
  await expect(sample.locator('code.language-math').first()).toHaveText('$E = mc^2$');
  await expect(sample.locator('[role="doc-noteref"]')).toHaveCount(2);
  await expect(sample.locator('[role="doc-backlink"]')).toHaveCount(2);
});

test('example-local headings and footnotes scroll and focus without navigating away', async ({ page, context }) => {
  const url = page.url();
  const sample = page.locator(markdown).first();
  await sample.getByRole('link', { name: 'the checklist', exact: true }).click();
  await expect(sample.locator('#release-checklist')).toBeFocused();
  const reference = sample.locator('[role="doc-noteref"]').nth(1);
  const referenceId = await reference.getAttribute('id');
  await reference.focus();
  await reference.press('Enter');
  await expect(sample.locator('[role="doc-endnotes"] li')).toBeFocused();
  await sample.locator('[role="doc-backlink"]').nth(1).click();
  await expect(reference).toBeFocused();
  expect(referenceId).toBeTruthy();
  await sample.getByRole('link', { name: 'relative link', exact: true }).click();
  const readme = page.locator(markdown).nth(1);
  await readme.getByRole('link', { name: 'Installation', exact: true }).click();
  await expect(readme.locator('#installation')).toBeFocused();
  const external = readme.getByRole('link', { name: 'every release', exact: true });
  await external.click({ modifiers: ['ControlOrMeta'] });
  await external.click({ button: 'middle' });
  await expect(page).toHaveURL(url);
  expect(context.pages()).toHaveLength(1);
});

for (const colorScheme of ['light', 'dark'] as const) {
  test(`narrow ${colorScheme} layout confines wide tables and code to their scroll containers`, async ({ page }) => {
    await page.setViewportSize({ width: 390, height: 844 });
    await page.emulateMedia({ colorScheme, reducedMotion: 'reduce' });
    await page.reload();
    const sample = page.locator(markdown).first();
    await expect(sample).toBeVisible();
    const table = page.locator(markdown).nth(1).locator('.rui-markdown-table').first();
    const code = sample.locator('pre').first();
    for (const region of [table, code]) {
      await expect(region).toHaveCSS('overflow-x', 'auto');
      expect(await region.evaluate(element => element.scrollWidth > element.clientWidth)).toBe(true);
      await region.evaluate(element => { element.scrollLeft = 100; });
      expect(await region.evaluate(element => element.scrollLeft)).toBeGreaterThan(0);
    }
    expect(await page.evaluate(() => document.documentElement.scrollWidth)).toBeLessThanOrEqual(391);
    const foreground = await sample.evaluate(element => getComputedStyle(element).color);
    const background = await code.evaluate(element => getComputedStyle(element).backgroundColor);
    expect(foreground).not.toBe(background);
    await expect(sample.locator('h1')).toHaveCSS('text-align', 'start');
  });
}


test('every heading exposes its own visible anchor and supports keyboard navigation', async ({ page }) => {
  const sample = page.locator(markdown).first();
  const headings = sample.locator('h1,h2,h3,h4,h5,h6');
  for (const heading of await headings.all()) {
    const anchor = heading.locator('.rui-markdown-anchor');
    await expect(anchor).toBeVisible();
    await expect(anchor).toHaveAttribute('href', '#' + await heading.getAttribute('id'));
    await anchor.focus();
    await anchor.press('Enter');
    await expect(heading).toBeFocused();
  }
  await expect(page).toHaveURL(/\/components\/markdown\/$/);
});

test('custom rendered code keeps highlighting and copies the original source alongside a compact heading', async ({ page, context }) => {
  await context.grantPermissions(['clipboard-read', 'clipboard-write']);
  const custom = page.locator(markdown).nth(3);
  await expect(custom.locator('h3')).toHaveText('A compact heading');
  await expect(custom.locator('h3')).toHaveCSS('font-size', '14px');
  await expect(custom.locator('.rui-markdown-anchor')).toHaveCount(0);
  await expect(custom.locator('pre')).toHaveCount(1);
  await expect(custom.locator('pre code')).toHaveAttribute('data-info', 'moonbit check');
  await expect(custom.locator('pre code span')).toHaveText('let');
  await expect(custom.locator('pre code span')).toHaveCSS('font-weight', '700');
  await custom.getByRole('button', { name: 'Copy code', exact: true }).click();
  await expect.poll(() => page.evaluate(() => navigator.clipboard.readText()))
    .toBe('let greeting = "Hello from a custom renderer"');
});

for (const colorScheme of ['light', 'dark'] as const) {
  test(`task checkboxes match the actual Checkbox component in ${colorScheme} mode`, async ({ page }) => {
    await page.emulateMedia({ colorScheme });
    await page.reload();
    const sample = page.locator(markdown).first();
    const properties = ['width', 'height', 'borderRadius', 'borderColor', 'backgroundColor', 'color', 'opacity'];
    const task = sample.getByRole('checkbox').first();
    const taskStyle = await task.evaluate((e, props) => Object.fromEntries(props.map(p => [p, getComputedStyle(e)[p as any]])), properties);
    await expect(task.locator('svg')).toHaveAttribute('width', '14');
    await page.goto('/components/checkbox/');
    const checkbox = page.locator('#forms-variants-checkbox-disabled');
    await expect(checkbox).toBeChecked();
    const componentStyle = await checkbox.evaluate((e, props) => Object.fromEntries(props.map(p => [p, getComputedStyle(e)[p as any]])), properties);
    expect(taskStyle).toEqual(componentStyle);
    expect(taskStyle).toMatchObject({ width: '16px', height: '16px', borderRadius: '4px', opacity: '0.5' });
    await expect(checkbox.locator('svg')).toHaveAttribute('width', '14');
  });

  test(`nested bullets, mixed lists and long wrapped items align on narrow ${colorScheme} screens`, async ({ page }) => {
    await page.setViewportSize({ width: 390, height: 844 });
    await page.emulateMedia({ colorScheme });
    const lists = page.locator(markdown).nth(2);
    await expect(lists.locator('ul ul ul')).toHaveCount(1);
    await expect(lists.locator('.rui-markdown-task > ul > .rui-markdown-task')).toHaveCount(1);
    for (const nested of await lists.locator('li > ul, li > ol').all()) {
      const geometry = await nested.evaluate(el => {
        const child = el.querySelector('li')!;
        return { indent: child.getBoundingClientRect().x - el.parentElement!.getBoundingClientRect().x,
          marker: getComputedStyle(el).listStyleType, gap: getComputedStyle(el).marginTop };
      });
      expect(geometry.indent).toBeCloseTo(24, 0);
      expect(['disc', 'decimal']).toContain(geometry.marker);
      expect(geometry.gap).toBe('8px');
    }
    const wrapped = lists.locator('ul ul ul > li').first();
    const starts = await wrapped.evaluate(el => {
      const text = [...el.childNodes].find(n => n.nodeType === Node.TEXT_NODE)!;
      const range = document.createRange(); range.selectNodeContents(text);
      return [...range.getClientRects()].map(rect => rect.x);
    });
    expect(starts.length).toBeGreaterThan(1);
    for (const x of starts) expect(x).toBeCloseTo(starts[0], 0);
    for (const task of await lists.locator('.rui-markdown-task').all()) {
      const geometry = await task.evaluate(el => {
        const check = el.querySelector('[role=checkbox]')!.getBoundingClientRect();
        return { offset: el.getBoundingClientRect().x - check.x, right: check.right, text: el.getBoundingClientRect().x };
      });
      expect(geometry.offset).toBeCloseTo(24, 0);
      expect(geometry.right).toBeLessThan(geometry.text);
    }
    const paragraphs = lists.locator('li').filter({ has: page.locator(':scope > p', { hasText: 'A loose item' }) }).first().locator(':scope > p');
    expect((await paragraphs.nth(0).boundingBox())!.x).toBe((await paragraphs.nth(1).boundingBox())!.x);
    const frame = lists.locator('.rui-markdown-code');
    const pre = frame.locator('pre');
    expect((await pre.boundingBox())!.width).toBeGreaterThan((await frame.boundingBox())!.width - 3);
    expect(await page.evaluate(() => document.documentElement.scrollWidth)).toBeLessThanOrEqual(390);
  });
}


test('complete async 0.22.2 README retains source text and exposes the documented nested-task parser limitation', async ({ page }) => {
  const readme = page.locator(markdown).nth(4);
  await expect(readme.locator('h1')).toHaveText('Asynchronous programming library for MoonBit');
  await expect(readme.locator('h2')).toHaveCount(5);
  await expect(readme.locator('pre')).toHaveCount(2);
  // Six nested markers stay literal text with cmark 0.4.8; do not conceal this limitation.
  await expect(readme.getByRole('checkbox')).toHaveCount(20);
  await expect(readme).toContainText('- [X] graceful cancellation');
  await expect(readme).toContainText('- [ ] implement other IO primitives');
  await expect(readme.locator('[role=checkbox][aria-checked=true]')).toHaveCount(19);
  await expect(readme.locator('ul').first().locator('ul')).toHaveCount(2);
  await expect(readme.locator('code.language-bash')).toHaveText('moon add moonbitlang/async@0.22.1');
  await expect(readme.locator('code').last()).toHaveText('@async.Queue');
  await readme.getByRole('link', { name: 'Link to Task cancellation', exact: true }).click();
  await expect(readme.locator('#task-cancellation')).toBeFocused();
  await expect(page).toHaveURL(/\/components\/markdown\/$/);
});
