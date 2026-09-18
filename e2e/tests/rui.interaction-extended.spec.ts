import { expect, test } from '@playwright/test';

test('multiple combobox removes chips and keeps the popup open while adding values', async ({ page }) => {
  await page.goto('/');

  const section = page.locator('#fixture-section-combobox-multiple');
  const input = section.getByRole('combobox', { name: 'Search options' });
  const output = section.locator('#fixture-combobox-multiple-output');

  await expect(section.locator('[data-slot="combobox-chip"]')).toHaveCount(2);
  await section.getByRole('button', { name: 'Remove: moonbit' }).click();
  await expect(output).toHaveText('rabbita');
  await expect(section.locator('[data-slot="combobox-chip"]')).toHaveCount(1);

  await input.fill('type');
  const content = section.locator('#fixture-combobox-multiple-content');
  await expect(content).toBeVisible();
  await content.getByRole('option', { name: 'TypeScript' }).click();
  await expect(output).toHaveText('rabbita,typescript');
  await expect(input).toHaveAttribute('aria-expanded', 'true');
  await expect(content.getByRole('option', { name: 'TypeScript' })).toHaveAttribute(
    'aria-selected',
    'true',
  );

  await input.press('Escape');
  await expect(content).toBeHidden();
});

test('multi-thumb slider reports keyboard changes and commits without crossing', async ({ page }) => {
  await page.goto('/');

  const section = page.locator('#fixture-section-slider-values');
  const lower = section.getByRole('slider', { name: 'Fixture budget 1' });
  const upper = section.getByRole('slider', { name: 'Fixture budget 2' });
  const root = section.locator('#fixture-slider-values-root');
  const output = section.locator('#fixture-slider-values-output');

  await expect(root).toHaveAttribute('data-values', '20,80');
  await lower.focus();
  await lower.press('PageUp');
  await expect(lower).toHaveValue('50');
  await expect(output).toHaveText('change:50,80|commit:50,80');

  await lower.press('End');
  await expect(lower).toHaveValue('60');
  await expect(root).toHaveAttribute('data-values', '60,80');
  await lower.press('ArrowRight');
  await expect(lower).toHaveValue('60');

  await upper.focus();
  await upper.press('Home');
  await expect(upper).toHaveValue('80');
  await expect(output).toHaveText('change:60,80|commit:60,80');
});

test('slider pointer interaction moves the nearest thumb and reports a commit', async ({ page }) => {
  await page.goto('/');

  const section = page.locator('#fixture-section-slider-values');
  const root = section.locator('#fixture-slider-values-root');
  await root.scrollIntoViewIfNeeded();
  const box = await root.boundingBox();
  if (!box) throw new Error('slider root has no layout box');

  await page.mouse.move(box.x + box.width * 0.1, box.y + box.height / 2);
  await page.mouse.down();
  await page.mouse.move(box.x + box.width * 0.4, box.y + box.height / 2);
  await page.mouse.up();

  await expect(root).not.toHaveAttribute('data-values', '20,80');
  await expect(section.locator('#fixture-slider-values-output')).not.toHaveText(
    'change:20,80|commit:none',
  );
});
