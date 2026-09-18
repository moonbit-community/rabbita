import { expect, test } from '@playwright/test';

test('drawer opens, traps focus, and closes on Escape', async ({ page }) => {
  await page.goto('/');

  const trigger = page.getByRole('button', { name: 'Open drawer' });
  const dialog = page.getByRole('dialog', { name: 'Drawer title' });

  await expect(dialog).toBeHidden();
  await expect(trigger).toHaveAttribute('aria-expanded', 'false');

  await trigger.click();
  await expect(dialog).toBeVisible();
  await expect(dialog).toHaveAttribute('aria-modal', 'true');
  await expect(trigger).toHaveAttribute('aria-expanded', 'true');
  await expect(page.getByText('Drawer body')).toBeVisible();

  const surface = dialog.locator('[data-slot="drawer-content"]');
  const title = dialog.getByRole('heading', { name: 'Drawer title' });
  const handle = dialog.locator('[data-slot="drawer-handle"]');
  const surfaceBox = await surface.boundingBox();
  const titleBox = await title.boundingBox();
  const handleBox = await handle.boundingBox();
  if (!surfaceBox || !titleBox || !handleBox) {
    throw new Error('drawer content has no layout box');
  }
  expect(titleBox.y - surfaceBox.y).toBeLessThan(120);
  expect(handleBox.height).toBeGreaterThan(handleBox.width);
  expect(handleBox.y + handleBox.height / 2).toBeCloseTo(
    surfaceBox.y + surfaceBox.height / 2,
    0,
  );

  const closeButtons = dialog.getByRole('button', { name: 'Close drawer' });
  await expect(closeButtons).toHaveCount(2);
  await expect(closeButtons.first()).toBeFocused();

  await closeButtons.last().focus();
  await page.keyboard.press('Tab');
  // Native modal dialogs may yield one tab stop to browser chrome. The next
  // press must return to the dialog instead of reaching background content.
  await expect(page.locator(':focus')).toHaveCount(0);

  await page.keyboard.press('Tab');
  await expect(closeButtons.first()).toBeFocused();

  await page.keyboard.press('Shift+Tab');
  await expect(page.locator(':focus')).toHaveCount(0);

  await page.keyboard.press('Shift+Tab');
  await expect(closeButtons.last()).toBeFocused();

  await page.keyboard.press('Escape');
  await expect(dialog).toBeHidden();
  await expect(trigger).toHaveAttribute('aria-expanded', 'false');
  await expect(trigger).toBeFocused();
});

test('drawer closes from the footer button and from the overlay', async ({ page }) => {
  await page.goto('/');

  const trigger = page.getByRole('button', { name: 'Open drawer' });
  const dialog = page.getByRole('dialog', { name: 'Drawer title' });

  await trigger.click();
  await expect(dialog).toBeVisible();
  await dialog.getByRole('button', { name: 'Close drawer' }).last().click();
  await expect(dialog).toBeHidden();
  await expect(trigger).toBeFocused();

  await trigger.click();
  await expect(dialog).toBeVisible();
  await page.mouse.click(5, 5);
  await expect(dialog).toBeHidden();
});
