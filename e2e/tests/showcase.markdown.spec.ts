import { expect, test } from '@playwright/test';

const markdown = '[data-slot="markdown"]';

test.beforeEach(async ({ page }) => {
  await page.goto('/components/markdown/');
  await expect(page.locator(markdown)).toHaveCount(2);
});

test('complete ripgrep README renders its headings, benchmarks, commands and final section', async ({ page }) => {
  const readme = page.locator(markdown).nth(1);
  await expect(readme.locator('h2')).toHaveText('ripgrep (rg)');
  await expect(readme.locator('table')).toHaveCount(6);
  await expect(readme.locator('img')).toHaveCount(4);
  expect(await readme.locator('pre').count()).toBeGreaterThanOrEqual(30);
  await expect(readme.locator('h3').last()).toHaveText('Translations');
  await expect(readme.getByRole('link', { name: 'Configuration files', exact: true }))
    .toHaveAttribute('href', 'GUIDE.md#configuration-file');
  await expect(readme.getByRole('link', { name: 'Installation', exact: true })).toHaveAttribute('href', '#installation');
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
    const table = sample.locator('.rui-markdown-table');
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
