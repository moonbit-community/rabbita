import { expect, test } from '@playwright/test';

test('toast shows with its title and description and closes from its button', async ({ page }) => {
  await page.goto('/');

  await page.getByRole('button', { name: 'Show toast' }).click();
  const toast = page.locator('[data-slot="toast"]');
  await expect(toast).toBeVisible();
  await expect(toast.getByText('Saved')).toBeVisible();
  await expect(toast.getByText('The draft is kept.')).toBeVisible();

  await toast.getByRole('button', { name: 'Close notification' }).click();
  await expect(toast).toBeHidden();
});

test('toast dismisses itself after its duration', async ({ page }) => {
  await page.clock.install();
  await page.goto('/');

  await page.getByRole('button', { name: 'Show toast' }).click();
  const toast = page.locator('[data-slot="toast"]');
  await expect(toast).toBeVisible();

  await page.clock.runFor(5000);
  await expect(toast).toBeHidden();
});

test('toast swipe dismisses toward the inline end', async ({ page }) => {
  await page.goto('/');

  await page.getByRole('button', { name: 'Show toast' }).click();
  const toast = page.locator('[data-slot="toast"]');
  await expect(toast).toBeVisible();

  const box = await toast.boundingBox();
  expect(box).not.toBeNull();
  const startX = box!.x + 24;
  const startY = box!.y + box!.height / 2;
  await page.mouse.move(startX, startY);
  await page.mouse.down();
  await page.mouse.move(startX + 200, startY, { steps: 6 });
  await page.mouse.up();
  await expect(toast).toBeHidden();
});

test('toast pauses its timeout while hovered and resumes after leaving', async ({ page }) => {
  await page.clock.install();
  await page.goto('/');

  await page.getByRole('button', { name: 'Show toast' }).click();
  const toast = page.locator('[data-slot="toast"]');
  await expect(toast).toBeVisible();
  await toast.hover();
  await page.clock.runFor(5000);
  await expect(toast).toBeVisible();

  await page.getByRole('heading', { name: 'Toast', exact: true }).hover();
  await page.clock.runFor(4500);
  await expect(toast).toBeHidden();
});

test('sonner bounds its queue and dismisses every visible toast', async ({ page }) => {
  await page.goto('/');

  const show = page.getByRole('button', { name: 'Show toast' });
  await show.click();
  await show.click();
  await show.click();
  await show.click();
  await expect(page.locator('[data-slot="toast"]')).toHaveCount(3);

  await page.getByRole('button', { name: 'Dismiss all toasts' }).click();
  await expect(page.locator('[data-slot="toast"]')).toHaveCount(0);
});

async function expectToastContentContained(toast: import('@playwright/test').Locator) {
  const surface = await toast.boundingBox();
  expect(surface).not.toBeNull();
  expect(await toast.evaluate(el => el.scrollWidth > el.clientWidth + 1)).toBe(false);
  for (const slot of ['toast-title', 'toast-description', 'toast-close']) {
    const item = toast.locator(`[data-slot="${slot}"]`);
    await expect(item).toBeVisible();
    const box = await item.boundingBox();
    expect(box).not.toBeNull();
    expect(box!.x).toBeGreaterThanOrEqual(surface!.x - 1);
    expect(box!.x + box!.width).toBeLessThanOrEqual(surface!.x + surface!.width + 1);
  }
}

test('long unbroken toast text stays inside the notification surface', async ({ page }) => {
  await page.goto('/');

  await page.getByRole('button', { name: 'Show long path toast' }).click();
  const pathToast = page.locator('[data-slot="toast"]').last();
  await expect(pathToast).toBeVisible();
  await expect(
    pathToast.locator('[data-slot="toast-description"]'),
  ).toContainText('/tmp/abcdefghijklmnopqrstuvwxyz');
  await expectToastContentContained(pathToast);

  await pathToast.getByRole('button', { name: 'Close notification' }).click();
  await expect(pathToast).toBeHidden();

  await page.getByRole('button', { name: 'Show long title toast' }).click();
  const titleToast = page.locator('[data-slot="toast"]').last();
  await expect(titleToast).toBeVisible();
  await expectToastContentContained(titleToast);

  await page.setViewportSize({ width: 360, height: 640 });
  await page.getByRole('button', { name: 'Dismiss all toasts' }).click();
  await expect(page.locator('[data-slot="toast"]')).toHaveCount(0);
  await page.getByRole('button', { name: 'Show long path toast' }).click();
  const narrowToast = page.locator('[data-slot="toast"]');
  await expect(narrowToast).toBeVisible();
  await expectToastContentContained(narrowToast);
  await narrowToast.getByRole('button', { name: 'Close notification' }).click();
  await expect(narrowToast).toBeHidden();
});

