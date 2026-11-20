import { expect, test } from '@playwright/test';

test('closed context menus do not scan item geometry while typing', async ({ page }) => {
  await page.goto('/');

  const textarea = page.locator('#fixture-scan-textarea');
  await textarea.click();

  await page.evaluate(() => {
    const original = Element.prototype.getClientRects;
    (window as unknown as { __menuRectCalls: number }).__menuRectCalls = 0;
    Element.prototype.getClientRects = function (this: Element) {
      (window as unknown as { __menuRectCalls: number }).__menuRectCalls += 1;
      return original.call(this);
    };
  });

  await page.keyboard.type('hello', { delay: 20 });

  await expect(textarea).toHaveValue('hello');
  expect(
    await page.evaluate(
      () => (window as unknown as { __menuRectCalls: number }).__menuRectCalls,
    ),
  ).toBe(0);
});
