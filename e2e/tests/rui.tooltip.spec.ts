import { expect, test } from '@playwright/test';

test('tooltip opens on hover and closes when the pointer leaves', async ({ page }) => {
  await page.goto('/');

  const trigger = page.getByRole('button', { name: 'Hover for tooltip' });
  const tooltip = page.getByRole('tooltip', { name: 'Tooltip body content' });

  await expect(tooltip).toBeHidden();
  await trigger.hover();
  await expect(tooltip).toBeVisible();

  await page.getByRole('heading', { level: 1 }).hover();
  await expect(tooltip).toBeHidden();
});

test('tooltip opens on keyboard focus and closes on Escape', async ({ page }) => {
  await page.goto('/');

  const trigger = page.getByRole('button', { name: 'Hover for tooltip' });
  const tooltip = page.getByRole('tooltip', { name: 'Tooltip body content' });

  await expect(trigger).toBeVisible();
  await page.keyboard.press('Tab');
  await expect(trigger).toBeFocused();
  await expect(tooltip).toBeVisible();

  await page.keyboard.press('Escape');
  await expect(tooltip).toBeHidden();
});

test('hover card opens on trigger hover and closes after leaving', async ({ page }) => {
  await page.goto('/');

  const trigger = page.getByText('Hover profile', { exact: true });
  const body = page.getByText('Native MoonBit components with incremental state.');

  await expect(body).toBeHidden();
  await trigger.hover();
  await expect(body).toBeVisible();

  await body.hover();
  await expect(body).toBeVisible();

  await page.getByRole('heading', { level: 1 }).hover();
  await expect(body).toBeHidden();
});
