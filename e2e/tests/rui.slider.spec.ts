import { expect, test } from '@playwright/test';

test('slider is a native range with the configured value', async ({ page }) => {
  await page.goto('/');

  const slider = page.getByRole('slider', { name: 'Fixture slider' });
  await expect(slider).toHaveValue('30');
  await expect(slider).toHaveAttribute('min', '0');
  await expect(slider).toHaveAttribute('max', '100');
  await expect(slider).toHaveAttribute('step', '10');
});

test('slider arrow keys step through the range and clamp at the ends', async ({ page }) => {
  await page.goto('/');

  const slider = page.getByRole('slider', { name: 'Fixture slider' });
  await slider.focus();

  await page.keyboard.press('ArrowRight');
  await expect(slider).toHaveValue('40');

  await page.keyboard.press('ArrowLeft');
  await expect(slider).toHaveValue('30');
  await page.keyboard.press('ArrowLeft');
  await expect(slider).toHaveValue('20');
  await page.keyboard.press('ArrowLeft');
  await expect(slider).toHaveValue('10');

  await page.keyboard.press('Home');
  await expect(slider).toHaveValue('0');

  await page.keyboard.press('ArrowLeft');
  await expect(slider).toHaveValue('0');

  await page.keyboard.press('End');
  await expect(slider).toHaveValue('100');

  await page.keyboard.press('ArrowRight');
  await expect(slider).toHaveValue('100');
});
