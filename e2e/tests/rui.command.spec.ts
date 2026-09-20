import { expect, test } from '@playwright/test';

test('command box filters by keywords, skips disabled options, and reports selection', async ({ page }) => {
  await page.goto('/');

  const section = page.locator('#fixture-section-command');
  const input = section.getByRole('combobox', { name: 'Search commands' });
  const output = section.locator('#fixture-command-output');

  await expect(section.getByRole('listbox', { name: 'Fixture actions' })).toBeVisible();
  await input.fill('new');
  await expect(section.getByRole('option', { name: 'Create project' })).toBeVisible();
  await expect(section.getByRole('option', { name: 'Open dashboard' })).toBeHidden();
  await expect(output).toHaveText('query:new|selected:none');

  await input.fill('');
  await expect(output).toHaveText('query:|selected:none');
  await input.press('Home');
  await expect(input).toHaveAttribute(
    'aria-activedescendant',
    'fixture-command-item-0',
  );
  await input.press('ArrowDown');
  await expect(input).toHaveAttribute(
    'aria-activedescendant',
    'fixture-command-item-1',
  );
  await input.press('ArrowDown');
  await expect(input).toHaveAttribute(
    'aria-activedescendant',
    'fixture-command-item-3',
  );
  await input.press('Enter');
  await expect(output).toHaveText('query:|selected:Open settings');
});

test('command box exposes an empty result state for unmatched input', async ({ page }) => {
  await page.goto('/');

  const section = page.locator('#fixture-section-command');
  await section.getByRole('combobox', { name: 'Search commands' }).fill('missing');
  await expect(section.locator('[data-slot="command-empty"]')).toHaveText(
    'No matching fixture actions.',
  );
  await expect(section.getByRole('listbox')).toHaveAttribute('data-count', '0');
});

test('command dialog restores focus on Escape and closes after keyboard selection', async ({ page }) => {
  await page.goto('/');

  const section = page.locator('#fixture-section-command-dialog');
  const trigger = section.getByRole('button', { name: 'Open fixture palette' });
  const dialog = page.getByRole('dialog', { name: 'Fixture command palette' });
  const output = section.locator('#fixture-command-dialog-output');

  await expect(page.locator('dialog[open]')).toHaveCount(0);
  await trigger.click();
  await expect(dialog).toBeVisible();
  await expect(dialog.getByRole('combobox', { name: 'Search commands' })).toBeFocused();
  await expect(output).toHaveText('query:|selected:none|closed:pending');
  await dialog.getByRole('combobox').fill('settings');
  // Let input state render before closing; deferred bug: https://github.com/moonbit-community/rabbita/issues/189
  await page.waitForTimeout(50);
  await page.keyboard.press('Escape');
  await expect(dialog).toBeHidden();
  await expect(trigger).toBeFocused();
  await expect(output).toHaveText('query:|selected:none|closed:');

  await trigger.click();
  const input = dialog.getByRole('combobox', { name: 'Search commands' });
  await expect(input).toHaveValue('');
  await input.fill('create');
  await page.waitForTimeout(50);
  await expect(input).toHaveAttribute(
    'aria-activedescendant',
    'fixture-command-dialog-command-item-1',
  );
  await input.press('Enter');
  await expect(dialog).toBeHidden();
  await expect(trigger).toBeFocused();
  await expect(output).toHaveText('query:|selected:Create project|closed:');
});

test('command dialog resets on native close and dismisses on backdrop click', async ({ page }) => {
  await page.goto('/');
  const trigger = page.getByRole('button', { name: 'Open fixture palette', exact: true });
  const dialog = page.locator('#fixture-command-dialog');
  const output = page.locator('#fixture-command-dialog-output');
  await trigger.click();
  await expect(dialog).toBeVisible();
  await dialog.getByRole('combobox').fill('new');
  await page.waitForTimeout(50);
  await dialog.evaluate((element: HTMLDialogElement) => element.close('saved'));
  await expect(dialog).toBeHidden();
  await expect(trigger).toBeFocused();
  await expect(dialog).toHaveJSProperty('returnValue', 'saved');
  await expect(output).toHaveText('query:|selected:none|closed:saved');
  await trigger.click();
  await expect(dialog.getByRole('combobox')).toHaveValue('');
  await expect(dialog.getByRole('option', { name: 'Open dashboard' })).toBeVisible();
  await page.mouse.click(5, 5);
  await expect(dialog).toBeHidden();
  await expect(trigger).toBeFocused();
});

test('close_on_select=false keeps the native palette and query open', async ({ page }) => {
  await page.goto('/');
  await page.getByRole('button', { name: 'Open Persistent palette', exact: true }).click();
  const dialog = page.locator('#fixture-command-persistent');
  const input = dialog.getByRole('combobox');
  await input.fill('new');
  await page.waitForTimeout(50);
  await input.press('Enter');
  await expect(page.locator('#fixture-command-persistent-selection')).toHaveText('Create project');
  await expect(dialog).toBeVisible();
  await expect(input).toHaveValue('new');
  await expect(input).toBeFocused();
});

test('canceling Escape preserves the query and still allows selecting a command', async ({ page }) => {
  await page.goto('/');
  await page.getByRole('button', { name: 'Open Cancel palette', exact: true }).click();
  const dialog = page.locator('#fixture-command-cancel');
  const input = dialog.getByRole('combobox');
  await input.fill('settings');
  await page.waitForTimeout(50);
  await input.press('Escape');
  await expect(dialog).toBeVisible();
  await expect(input).toHaveValue('settings');
  await expect(input).toBeFocused();
  await input.press('Enter');
  await expect(page.locator('#fixture-command-cancel-selection')).toHaveText('Open settings');
  await expect(dialog).toBeHidden();
});
