import { expect, test } from '@playwright/test';

test('modal dialog traps focus, closes on Escape, and restores its trigger', async ({ page }) => {
  await page.goto('/');

  const trigger = page.getByRole('button', { name: 'Open modal dialog' });
  const dialog = page.getByRole('dialog', { name: 'Edit fixture profile' });
  const input = page.getByRole('textbox', { name: 'Display name' });

  await trigger.click();
  await expect(dialog).toBeVisible();
  await expect(dialog).toHaveAttribute('aria-modal', 'true');
  await expect(input).toBeFocused();

  await page.keyboard.press('Escape');
  await expect(dialog).toBeHidden();
  await expect(trigger).toBeFocused();

  await trigger.click();
  await dialog.getByRole('button', { name: 'Save dialog' }).click();
  await expect(dialog).toBeHidden();
  await expect(trigger).toBeFocused();
});

test('non-modal dialog leaves surrounding controls focusable', async ({ page }) => {
  await page.goto('/');

  const trigger = page.getByRole('button', { name: 'Open non-modal dialog' });
  const dialog = page.getByRole('dialog', { name: 'Non-modal fixture' });
  const outside = page.getByRole('button', { name: 'Open modal dialog' });

  await trigger.click();
  await expect(dialog).toBeVisible();
  await expect(dialog).not.toHaveAttribute('aria-modal', 'true');
  await expect(dialog).toHaveAttribute('data-modal', 'false');
  await outside.focus();
  await expect(outside).toBeFocused();
  await expect(dialog).toBeVisible();

  await dialog.getByRole('button', { name: 'Close non-modal' }).click();
  await expect(dialog).toBeHidden();
});

test('alert dialog cancel and action close and restore focus', async ({ page }) => {
  await page.goto('/');

  const trigger = page.getByRole('button', { name: 'Delete fixture' });
  const dialog = page.getByRole('alertdialog', { name: 'Delete this fixture?' });

  await trigger.click();
  await expect(dialog).toBeVisible();
  await expect(dialog.getByText('This action cannot be undone.')).toBeVisible();
  await dialog.getByRole('button', { name: 'Cancel deletion' }).click();
  await expect(dialog).toBeHidden();
  await expect(trigger).toBeFocused();

  await trigger.click();
  await dialog.getByRole('button', { name: 'Confirm deletion' }).click();
  await expect(dialog).toBeHidden();
  await expect(trigger).toBeFocused();
});

test('sheet exposes its placement and restores focus after dismissal', async ({ page }) => {
  await page.goto('/');

  const trigger = page.getByRole('button', { name: 'Open settings sheet' });
  const dialog = page.getByRole('dialog', { name: 'Fixture settings' });

  await trigger.click();
  await expect(dialog).toBeVisible();
  await expect(dialog.locator('[data-slot="sheet-content"]')).toHaveAttribute('data-side', 'right');
  await page.keyboard.press('Escape');
  await expect(dialog).toBeHidden();
  await expect(trigger).toBeFocused();

  const bottomTrigger = page.getByRole('button', { name: 'Open bottom sheet' });
  const bottom = page.getByRole('dialog', { name: 'Bottom fixture sheet' });
  await bottomTrigger.click();
  await expect(bottom.locator('[data-slot="sheet-content"]')).toHaveAttribute('data-side', 'bottom');
  await bottom.getByRole('button', { name: 'Close bottom sheet' }).click();
  await expect(bottom).toBeHidden();
  await expect(bottomTrigger).toBeFocused();
});
