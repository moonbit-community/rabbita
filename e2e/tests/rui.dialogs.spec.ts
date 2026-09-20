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

test('alert dialog keeps its backdrop inert and closes with native form results', async ({ page }) => {
  await page.goto('/');

  const trigger = page.getByRole('button', { name: 'Delete fixture' });
  const dialog = page.getByRole('alertdialog', { name: 'Delete this fixture?' });

  await trigger.click();
  await expect(dialog).toBeVisible();
  await expect(dialog.getByText('This action cannot be undone.')).toBeVisible();
  await expect(dialog.getByRole('button', { name: 'Cancel deletion' })).toBeFocused();
  await page.mouse.click(5, 5);
  await expect(dialog).toHaveJSProperty('open', true);
  await dialog.getByRole('button', { name: 'Cancel deletion' }).click();
  await expect(dialog).toBeHidden();
  await expect(trigger).toBeFocused();

  await trigger.click();
  await expect(dialog).toHaveJSProperty('returnValue', 'cancel');
  await dialog.getByRole('button', { name: 'Confirm deletion' }).click();
  await expect(dialog).toBeHidden();
  await expect(page.locator('#fixture-alert-dialog')).toHaveJSProperty('returnValue', 'confirm');
  await expect(trigger).toBeFocused();

  await trigger.click();
  await page.keyboard.press('Escape');
  await expect(dialog).toBeHidden();
  await expect(trigger).toBeFocused();
});

test('sheet owns footer spacing and supports native form and backdrop dismissal', async ({ page }) => {
  await page.emulateMedia({ reducedMotion: 'reduce' });
  await page.goto('/');

  const trigger = page.getByRole('button', { name: 'Open settings sheet' });
  const dialog = page.getByRole('dialog', { name: 'Fixture settings' });
  await trigger.click();
  await expect(dialog.getByRole('textbox', { name: 'Notification email' })).toBeFocused();
  const gap = await dialog.evaluate(element => {
    const input = element.querySelector('input')!.getBoundingClientRect();
    const footer = element.querySelector('[data-slot="sheet-footer"]')!.getBoundingClientRect();
    return footer.top - input.bottom;
  });
  expect(gap).toBeGreaterThanOrEqual(16);
  await dialog.getByRole('button', { name: 'Save sheet' }).click();
  await expect(dialog).toBeHidden();
  await expect(page.locator('#fixture-sheet-right')).toHaveJSProperty('returnValue', 'saved');
  await expect(trigger).toBeFocused();

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

for (const side of ['right', 'bottom', 'top', 'left'] as const) {
  test(`sheet anchors to the ${side} edge and restores focus`, async ({ page }) => {
    await page.emulateMedia({ reducedMotion: 'reduce' });
    await page.goto('/');

    const trigger = page.getByRole('button', {
      name: side === 'right' ? 'Open settings sheet' : `Open ${side} sheet`,
    });
    const dialog = page.getByRole('dialog', {
      name: side === 'right' ? 'Fixture settings' : `${side} fixture sheet`,
    });
    await trigger.click();
    await expect(dialog).toBeVisible();
    const bounds = (await dialog.boundingBox())!;
    const viewport = page.viewportSize()!;
    if (side === 'right' || side === 'left') {
      expect(bounds.y).toBeCloseTo(0, 0);
      expect(bounds.height).toBeCloseTo(viewport.height, 0);
      expect(side === 'right' ? bounds.x + bounds.width : bounds.x)
        .toBeCloseTo(side === 'right' ? viewport.width : 0, 0);
    } else {
      expect(bounds.x).toBeCloseTo(0, 0);
      expect(bounds.width).toBeCloseTo(viewport.width, 0);
      expect(side === 'bottom' ? bounds.y + bounds.height : bounds.y)
        .toBeCloseTo(side === 'bottom' ? viewport.height : 0, 0);
    }
    await page.keyboard.press('Escape');
    await expect(dialog).toBeHidden();
    await expect(trigger).toBeFocused();

    if (side !== 'right') {
      await trigger.click();
      await dialog.getByRole('button', { name: `Close ${side} sheet` }).click();
      await expect(dialog).toBeHidden();
      await expect(trigger).toBeFocused();
    }
  });
}
