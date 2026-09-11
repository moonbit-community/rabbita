import { expect, test } from '@playwright/test';

test('counter updates beside a shared subtree without diffing it', async ({ page }) => {
  await page.goto('/');

  const count = page.getByRole('heading', { level: 1 });
  const increment = page.getByRole('button', { name: '+', exact: true });
  const decrement = page.getByRole('button', { name: '-', exact: true });

  await expect(count).toHaveText('0');
  const actions = page.locator('.actions');
  await actions.evaluate((element: HTMLElement) => {
    const style = element.style;
    let reads = 0;
    element.dataset.styleReads = '0';
    // diff_props reads style even when every property is unchanged.
    Object.defineProperty(element, 'style', {
      configurable: true,
      get() {
        element.dataset.styleReads = String(++reads);
        return style;
      },
    });
  });

  await increment.click();
  await expect(count).toHaveText('1');
  await expect(actions).toHaveAttribute('data-style-reads', '0');

  await decrement.click();
  await expect(count).toHaveText('0');
  await expect(actions).toHaveAttribute('data-style-reads', '0');
});
