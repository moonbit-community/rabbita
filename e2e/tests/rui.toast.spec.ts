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
