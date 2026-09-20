import { expect, test } from '@playwright/test';

test('radio group exposes the group and keeps a single checked item', async ({ page }) => {
  await page.goto('/');

  const group = page.getByRole('radiogroup', { name: 'Billing cycle' });
  await expect(group).toBeVisible();

  const monthly = page.getByRole('radio', { name: 'Monthly' });
  const annual = page.getByRole('radio', { name: 'Annual' });
  const weekly = page.getByRole('radio', { name: 'Weekly' });

  await expect(monthly).toBeChecked();
  await expect(annual).not.toBeChecked();
  await expect(weekly).not.toBeChecked();

  await annual.check();
  await expect(monthly).not.toBeChecked();
  await expect(annual).toBeChecked();
});

test('radio group arrow keys move the selection', async ({ page }) => {
  await page.goto('/');

  const monthly = page.getByRole('radio', { name: 'Monthly' });
  const annual = page.getByRole('radio', { name: 'Annual' });
  const weekly = page.getByRole('radio', { name: 'Weekly' });

  await monthly.focus();
  await expect(monthly).toBeChecked();
  await page.keyboard.press('ArrowRight');
  await expect(annual).toBeChecked();
  await page.keyboard.press('ArrowRight');
  await expect(weekly).toBeChecked();
  await page.keyboard.press('ArrowLeft');
  await expect(annual).toBeChecked();
});
