import { expect, test } from '@playwright/test';

test('modal dialog traps focus, closes on Escape, and restores its trigger', async ({ page }) => {
  await page.goto('/');

  const trigger = page.getByRole('button', { name: 'Open modal dialog' });
  const dialog = page.getByRole('dialog', { name: 'Edit fixture profile' });
  const input = page.getByRole('textbox', { name: 'Display name' });

  await expect(dialog).toBeHidden();
  await trigger.click();
  await expect(dialog).toBeVisible();
  await expect(dialog).toHaveJSProperty('open', true);
  expect(await dialog.evaluate((element) => element.matches(':modal'))).toBe(true);
  await expect(input).toBeFocused();
  await trigger.focus();
  await expect(input).toBeFocused();

  await page.keyboard.press('Escape');
  await expect(dialog).toBeHidden();
  await expect(trigger).toBeFocused();

  await trigger.click();
  await dialog.getByRole('button', { name: 'Save dialog' }).click();
  await expect(dialog).toBeHidden();
  await expect(page.locator('#fixture-dialog-modal')).toHaveJSProperty('returnValue', 'saved');
  await expect(page.locator('#fixture-dialog-status')).toHaveText('saved');
  await expect(trigger).toBeFocused();
});

test('caller updates preserve the native open state and closing reports its result', async ({ page }) => {
  await page.goto('/');

  const trigger = page.getByRole('button', { name: 'Open modal dialog' });
  const dialog = page.getByRole('dialog', { name: 'Edit fixture profile' });
  const status = page.locator('#fixture-dialog-status');

  await trigger.click();
  await dialog.getByRole('button', { name: 'Update caller state' }).click();
  await expect(status).toHaveText('Updated');
  await expect(dialog).toHaveJSProperty('open', true);
  await expect(dialog).toBeVisible();
  await dialog.getByRole('button', { name: 'Save dialog' }).click();
  await expect(status).toHaveText('saved');
  await expect(dialog).toBeHidden();

  await trigger.click();
  await expect(dialog).toBeVisible();
  await dialog.getByRole('button', { name: 'Close', exact: true }).click();
  await expect(dialog).toBeHidden();
});

test('dialog uses native backdrop dismissal and its default close form', async ({ page }) => {
  await page.goto('/');

  const trigger = page.getByRole('button', { name: 'Open modal dialog' });
  const dialog = page.getByRole('dialog', { name: 'Edit fixture profile' });

  await trigger.click();
  await expect(dialog).toBeVisible();
  await page.mouse.click(5, 5);
  await expect(dialog).toBeHidden();
  await expect(trigger).toBeFocused();

  await trigger.click();
  await dialog.getByRole('button', { name: 'Close', exact: true }).click();
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
  expect(await dialog.evaluate((element) => element.matches(':modal'))).toBe(false);
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
