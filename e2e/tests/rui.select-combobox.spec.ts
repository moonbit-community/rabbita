import { expect, test } from '@playwright/test';

test('select opens on click, closes on Escape, and keeps the chosen value', async ({ page }) => {
  await page.goto('/');

  const trigger = page.locator('#fixture-select-trigger');
  const listbox = page.locator('#fixture-select-content');

  await expect(trigger).toHaveText('Choose an option…');
  await expect(trigger).toHaveAttribute('aria-expanded', 'false');
  await expect(listbox).toBeHidden();

  await trigger.click();
  await expect(trigger).toHaveAttribute('aria-expanded', 'true');
  await expect(listbox).toBeVisible();

  await listbox.getByRole('option', { name: 'Beta' }).click();
  await expect(trigger).toHaveText('Beta');
  await expect(trigger).toHaveAttribute('aria-expanded', 'false');
  await expect(listbox).toBeHidden();

  await trigger.click();
  await expect(listbox).toBeVisible();
  await page.keyboard.press('Escape');
  await expect(listbox).toBeHidden();
  await expect(trigger).toHaveAttribute('aria-expanded', 'false');
  await expect(trigger).toHaveText('Beta');
});

test('select keyboard opens, highlights, and confirms an option', async ({ page }) => {
  await page.goto('/');

  const trigger = page.locator('#fixture-select-trigger');
  const beta = page
    .locator('#fixture-select-content')
    .getByRole('option', { name: 'Beta' });
  await trigger.focus();
  await page.keyboard.press('ArrowDown');
  await expect(trigger).toHaveAttribute('aria-expanded', 'true');

  await page.keyboard.press('ArrowDown');
  await expect(beta).toBeFocused();
  await page.keyboard.press('Enter');
  await expect(trigger).toHaveText('Beta');
  await expect(trigger).toHaveAttribute('aria-expanded', 'false');
});

test('combobox filters options while typing and commits a choice', async ({ page }) => {
  await page.goto('/');

  const section = page.locator('#fixture-section-combobox');
  const input = section.getByRole('combobox', { name: 'Search options' });
  const listbox = page.locator('#fixture-combobox-content');

  await input.fill('mo');
  await expect(input).toHaveAttribute('aria-expanded', 'true');
  await expect(listbox.getByRole('option', { name: 'MoonBit' })).toBeVisible();
  await expect(listbox.getByRole('option', { name: 'Rabbita' })).toBeHidden();

  await listbox.getByRole('option', { name: 'MoonBit' }).click();
  await expect(input).toHaveValue('MoonBit');
  await expect(input).toHaveAttribute('aria-expanded', 'false');

  await section.getByRole('button', { name: 'Clear selection' }).click();
  await expect(input).toHaveValue('');
});

test('combobox shows its empty message for a dead-end query', async ({ page }) => {
  await page.goto('/');

  const section = page.locator('#fixture-section-combobox');
  const input = section.getByRole('combobox', { name: 'Search options' });
  await input.fill('zzz');
  await expect(page.locator('#fixture-combobox-content')).toBeVisible();
  await expect(section.getByText('No matching runtimes.')).toBeVisible();

  await page.keyboard.press('Escape');
  await expect(input).toHaveAttribute('aria-expanded', 'false');
});

test('select typeahead chooses an enabled match and keyboard navigation skips disabled options', async ({ page }) => {
  await page.goto('/');

  const trigger = page.locator('#fixture-select-trigger');
  const listbox = page.locator('#fixture-select-content');
  await trigger.focus();
  await trigger.press('b');
  await expect(trigger).toHaveText('Beta');

  await trigger.press('ArrowDown');
  await expect(listbox).toBeVisible();
  await page.keyboard.press('End');
  await expect(listbox.getByRole('option', { name: 'Beta' })).toBeFocused();
  await expect(listbox.getByRole('option', { name: 'Gamma' })).toHaveAttribute(
    'aria-disabled',
    'true',
  );
});

test('combobox popup matches its complete control while filtering and resizing', async ({ page }) => {
  await page.goto('/');
  const input = page.locator('#fixture-combobox-input');
  const control = page.locator('#fixture-combobox-control');
  const popup = page.locator('#fixture-combobox-content');
  for (const width of [1280, 390]) {
    await page.setViewportSize({ width, height: 844 });
    await input.fill('mo');
    await expect(popup).toBeVisible();
    for (const query of ['mo', 'zzz', '']) {
      await input.fill(query);
      await expect.poll(async () => {
        const anchor = await control.boundingBox();
        const box = await popup.boundingBox();
        return anchor && box ? Math.abs(box.width - anchor.width) : Infinity;
      }).toBeLessThan(1);
      const anchor = (await control.boundingBox())!;
      const box = (await popup.boundingBox())!;
      expect(Math.abs(box.x - anchor.x)).toBeLessThan(1);
      expect(box.x).toBeGreaterThanOrEqual(0);
      expect(box.x + box.width).toBeLessThanOrEqual(width);
    }
    await input.press('Escape');
  }
});
