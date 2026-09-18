import { expect, test } from '@playwright/test';

test('single accordion owns one expanded panel and can collapse it', async ({ page }) => {
  await page.goto('/');

  const keyboard = page.getByRole('button', { name: 'Keyboard interaction' });
  const state = page.getByRole('button', { name: 'Owned state' });
  const disabled = page.getByRole('button', { name: 'Unavailable section' });

  await expect(keyboard).toHaveAttribute('aria-expanded', 'true');
  await expect(page.getByText('Enter and Space toggle this panel.')).toBeVisible();
  await expect(state).toHaveAttribute('aria-expanded', 'false');
  await expect(disabled).toBeDisabled();

  await state.click();
  await expect(state).toHaveAttribute('aria-expanded', 'true');
  await expect(page.getByText('Only one panel stays open.')).toBeVisible();
  await expect(keyboard).toHaveAttribute('aria-expanded', 'false');

  await state.click();
  await expect(state).toHaveAttribute('aria-expanded', 'false');
  await expect(page.getByText('Only one panel stays open.')).toBeHidden();
});

test('accordion keyboard navigation skips disabled triggers', async ({ page }) => {
  await page.goto('/');

  const keyboard = page.getByRole('button', { name: 'Keyboard interaction' });
  const state = page.getByRole('button', { name: 'Owned state' });

  await keyboard.focus();
  await page.keyboard.press('ArrowDown');
  await expect(state).toBeFocused();

  await page.keyboard.press('ArrowDown');
  await expect(keyboard).toBeFocused();

  await page.keyboard.press('End');
  await expect(state).toBeFocused();
  await page.keyboard.press('Home');
  await expect(keyboard).toBeFocused();
});

test('multiple accordion keeps independent panels expanded', async ({ page }) => {
  await page.goto('/');

  const first = page.getByRole('button', { name: 'First independent panel' });
  const second = page.getByRole('button', { name: 'Second independent panel' });

  await expect(first).toHaveAttribute('aria-expanded', 'true');
  await second.click();
  await expect(first).toHaveAttribute('aria-expanded', 'true');
  await expect(second).toHaveAttribute('aria-expanded', 'true');
  await expect(page.getByText('First panel content')).toBeVisible();
  await expect(page.getByText('Second panel content')).toBeVisible();
});

test('collapsible toggles through click and keyboard while disabled stays closed', async ({ page }) => {
  await page.goto('/');

  const trigger = page.getByRole('button', { name: 'Advanced settings' });
  const disabled = page.getByRole('button', { name: 'Unavailable settings' });

  await expect(trigger).toHaveAttribute('aria-expanded', 'false');
  await expect(page.getByText('Advanced settings content')).toBeHidden();
  await trigger.click();
  await expect(trigger).toHaveAttribute('aria-expanded', 'true');
  await expect(page.getByText('Advanced settings content')).toBeVisible();

  await trigger.focus();
  await page.keyboard.press('Space');
  await expect(trigger).toHaveAttribute('aria-expanded', 'false');
  await expect(disabled).toBeDisabled();
  await expect(disabled).toHaveAttribute('aria-expanded', 'false');
});

test('horizontal and vertical tabs select with their orientation keys', async ({ page }) => {
  await page.goto('/');

  const horizontal = page.getByRole('tablist', { name: 'Fixture workflow' });
  const preview = horizontal.getByRole('tab', { name: 'Preview' });
  const source = horizontal.getByRole('tab', { name: 'Source' });
  const disabled = horizontal.getByRole('tab', { name: 'Disabled' });

  await expect(preview).toHaveAttribute('aria-selected', 'true');
  await expect(page.getByRole('tabpanel', { name: 'Preview' })).toBeVisible();
  await preview.focus();
  await page.keyboard.press('ArrowRight');
  await expect(source).toBeFocused();
  await expect(source).toHaveAttribute('aria-selected', 'true');
  await expect(page.getByRole('tabpanel', { name: 'Source' })).toBeVisible();
  await page.keyboard.press('ArrowRight');
  await expect(preview).toBeFocused();
  await expect(disabled).toBeDisabled();

  const vertical = page.getByRole('tablist', { name: 'Fixture settings' });
  const general = vertical.getByRole('tab', { name: 'General' });
  const members = vertical.getByRole('tab', { name: 'Members' });
  await general.focus();
  await page.keyboard.press('ArrowDown');
  await expect(members).toBeFocused();
  await expect(members).toHaveAttribute('aria-selected', 'true');
  await expect(page.getByRole('tabpanel', { name: 'Members' })).toBeVisible();
});
