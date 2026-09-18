import { expect, test } from '@playwright/test';

test('command filters by keywords, skips disabled options, and reports selection', async ({ page }) => {
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

test('command exposes an empty result state for unmatched input', async ({ page }) => {
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

  await trigger.click();
  await expect(dialog).toBeVisible();
  await expect(dialog.getByRole('combobox', { name: 'Search commands' })).toBeFocused();
  await expect(output).toHaveText('state:open|selected:none');
  await page.keyboard.press('Escape');
  await expect(dialog).toBeHidden();
  await expect(trigger).toBeFocused();
  await expect(output).toHaveText('state:closed|selected:none');

  await trigger.click();
  const input = dialog.getByRole('combobox', { name: 'Search commands' });
  await input.fill('create');
  await expect(input).toHaveAttribute(
    'aria-activedescendant',
    'fixture-command-dialog-command-item-1',
  );
  await input.press('Enter');
  await expect(dialog).toBeHidden();
  await expect(trigger).toBeFocused();
  await expect(output).toHaveText('state:closed|selected:Create project');
});
