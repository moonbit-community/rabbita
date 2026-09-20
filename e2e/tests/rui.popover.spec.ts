import { expect, test } from '@playwright/test';

test('popover opens with dialog semantics and closes from its close button', async ({ page }) => {
  await page.goto('/');

  const trigger = page.getByRole('button', { name: 'Open popover' });
  const dialog = page.getByRole('dialog', { name: 'Popover title' });

  await expect(dialog).toBeHidden();
  await expect(trigger).toHaveAttribute('aria-expanded', 'false');

  await trigger.click();
  await expect(dialog).toBeVisible();
  await expect(trigger).toHaveAttribute('aria-expanded', 'true');
  await expect(dialog.getByText('Popover description.')).toBeVisible();
  await expect(dialog.getByRole('button', { name: 'Close' })).toBeFocused();

  await dialog.getByRole('button', { name: 'Close' }).click();
  await expect(dialog).toBeHidden();
  await expect(trigger).toHaveAttribute('aria-expanded', 'false');
  await expect(trigger).toBeFocused();
});

test('popover closes on Escape', async ({ page }) => {
  await page.goto('/');

  const trigger = page.getByRole('button', { name: 'Open popover' });
  const dialog = page.getByRole('dialog', { name: 'Popover title' });

  await trigger.click();
  await expect(dialog).toBeVisible();
  await page.keyboard.press('Escape');
  await expect(dialog).toBeHidden();
  await expect(trigger).toHaveAttribute('aria-expanded', 'false');
  await expect(trigger).toBeFocused();
});

test('popover closes on an outside pointer press', async ({ page }) => {
  await page.goto('/');

  const trigger = page.getByRole('button', { name: 'Open popover' });
  const dialog = page.getByRole('dialog', { name: 'Popover title' });

  await trigger.click();
  await expect(dialog).toBeVisible();
  await page.getByRole('heading', { level: 1 }).click();
  await expect(dialog).toBeHidden();
});
