import { expect, test } from '@playwright/test';

test('fixture navigation switches pages inside the SPA and follows history', async ({ page }) => {
  await page.goto('/');
  await expect(page.locator('#fixture-route-title')).toHaveText('Index');

  await page.getByRole('link', { name: 'Forms', exact: true }).click();
  await expect(page).toHaveURL(/\/forms$/);
  await expect(page.locator('#fixture-route-title')).toHaveText('Forms');
  await expect(page.getByText('This is the Forms route.')).toBeVisible();

  await page.getByRole('link', { name: 'Modals' }).click();
  await expect(page).toHaveURL(/\/modals$/);
  await expect(page.locator('#fixture-route-title')).toHaveText('Modals');
  await expect(page.getByText('This is the Modals route.')).toBeVisible();

  await page.goBack();
  await expect(page).toHaveURL(/\/forms$/);
  await expect(page.locator('#fixture-route-title')).toHaveText('Forms');
});

test('fixture renders an explicit not-found page for unknown routes', async ({ page }) => {
  await page.goto('/missing-fixture');

  await expect(page.locator('#fixture-route-title')).toHaveText('Not found');
  await expect(page.getByRole('heading', { name: 'Fixture page not found' })).toBeVisible();
  await expect(page.getByText('No fixture page exists for /missing-fixture.')).toBeVisible();
});

for (const mode of ['routed', 'native'] as const) {
  test(`Markdown ${mode} links ${mode === 'routed' ? 'use SPA routing' : 'perform browser navigation'}`, async ({ page }) => {
    await page.goto('/');
    await expect(page.locator('#fixture-route-title')).toHaveText('Index');
    await page.evaluate(() => { document.documentElement.dataset.navigationSentinel = 'present'; });
    await page.locator(`#markdown-${mode}`).getByRole('link', { name: 'Markdown Forms', exact: true }).click();
    await expect(page).toHaveURL(/\/forms$/);
    await expect(page.locator('#fixture-route-title')).toHaveText('Forms');
    expect(await page.evaluate(() => document.documentElement.dataset.navigationSentinel))
      .toBe(mode === 'routed' ? 'present' : undefined);
  });

  test(`Markdown ${mode} mode applies to reference links, autolinks, headings and footnotes`, async ({ page }) => {
    await page.goto('/');
    await expect(page.locator('#fixture-route-title')).toHaveText('Index');
    // Observe whether Rabbita captured the link before stopping the browser's
    // default navigation. Routing commands remain free to update SPA state.
    await page.evaluate(() => {
      document.addEventListener('click', event => {
        document.documentElement.dataset.linkCaptured = String(event.defaultPrevented);
        event.preventDefault();
      });
    });
    const content = page.locator(`#markdown-${mode}`);
    for (const selector of [
      'a[href="/forms"]',
      'a[href$="#autolink"]',
      '.rui-markdown-anchor',
      '[role="doc-noteref"]',
      '[role="doc-backlink"]',
    ]) {
      await content.locator(selector).last().click();
      await expect(page.locator('html')).toHaveAttribute('data-link-captured', String(mode === 'routed'));
    }
  });
}
