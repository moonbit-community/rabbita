import { expect, test } from '@playwright/test';

test('checkbox resolves mixed state and toggles with click and Space', async ({ page }) => {
  await page.goto('/');

  const checkbox = page.getByRole('checkbox', { name: 'Accept fixture policy' });
  const mixed = page.getByRole('checkbox', { name: 'Select all fixture items' });
  const disabled = page.getByRole('checkbox', { name: 'Managed fixture policy' });

  await expect(checkbox).not.toBeChecked();
  await checkbox.click();
  await expect(checkbox).toBeChecked();
  await checkbox.focus();
  await page.keyboard.press('Space');
  await expect(checkbox).not.toBeChecked();

  await expect(mixed).toHaveAttribute('aria-checked', 'mixed');
  await mixed.click();
  await expect(mixed).toHaveAttribute('aria-checked', 'true');
  await expect(disabled).toBeChecked();
  await expect(disabled).toBeDisabled();
});

test('switch toggles through pointer and keyboard while disabled stays checked', async ({ page }) => {
  await page.goto('/');

  const toggle = page.getByRole('switch', { name: 'Enable fixture previews' });
  const disabled = page.getByRole('switch', { name: 'Managed fixture backups' });

  await expect(toggle).not.toBeChecked();
  await toggle.click();
  await expect(toggle).toBeChecked();
  await toggle.focus();
  await page.keyboard.press('Space');
  await expect(toggle).not.toBeChecked();

  await expect(disabled).toBeChecked();
  await expect(disabled).toBeDisabled();
});

test('toggle exposes pressed state for pointer and keyboard activation', async ({ page }) => {
  await page.goto('/');

  const toggle = page.getByRole('button', { name: 'Pin fixture release' });
  await expect(toggle).toHaveAttribute('aria-pressed', 'false');
  await toggle.click();
  await expect(toggle).toHaveAttribute('aria-pressed', 'true');
  await toggle.focus();
  await page.keyboard.press('Space');
  await expect(toggle).toHaveAttribute('aria-pressed', 'false');
});

test('single toggle group keeps one value and skips its disabled item', async ({ page }) => {
  await page.goto('/');

  const group = page.getByRole('group', { name: 'Fixture layout' });
  const list = group.getByRole('button', { name: 'List' });
  const grid = group.getByRole('button', { name: 'Grid' });
  const disabled = group.getByRole('button', { name: 'Disabled' });

  await expect(grid).toHaveAttribute('aria-pressed', 'true');
  await list.click();
  await expect(list).toHaveAttribute('aria-pressed', 'true');
  await expect(grid).toHaveAttribute('aria-pressed', 'false');
  await expect(disabled).toBeDisabled();

  await list.focus();
  await page.keyboard.press('ArrowLeft');
  await expect(grid).toBeFocused();
});

test('multiple toggle group changes values independently', async ({ page }) => {
  await page.goto('/');

  const group = page.getByRole('group', { name: 'Fixture formatting' });
  const bold = group.getByRole('button', { name: 'Bold' });
  const italic = group.getByRole('button', { name: 'Italic' });

  await expect(bold).toHaveAttribute('aria-pressed', 'true');
  await expect(italic).toHaveAttribute('aria-pressed', 'false');
  await italic.click();
  await expect(bold).toHaveAttribute('aria-pressed', 'true');
  await expect(italic).toHaveAttribute('aria-pressed', 'true');
  await bold.click();
  await expect(bold).toHaveAttribute('aria-pressed', 'false');
  await expect(italic).toHaveAttribute('aria-pressed', 'true');
});
