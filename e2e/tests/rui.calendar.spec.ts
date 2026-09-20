import { expect, test } from '@playwright/test';

const calendarSection = '#fixture-section-calendar';

test('calendar marks today and the selected day', async ({ page }) => {
  await page.goto('/');

  const section = page.locator(calendarSection);
  const grid = section.getByRole('grid');
  await expect(grid).toBeVisible();

  const today = section.locator('[data-slot="calendar-day-button"][data-day="2026-07-16"]');
  await expect(today).toHaveAttribute('aria-selected', 'true');
  await expect(today).toHaveAttribute('aria-current', 'date');
});

test('calendar selection moves with clicks and focus moves with arrows', async ({ page }) => {
  await page.goto('/');

  const section = page.locator(calendarSection);
  const day16 = section.locator('[data-slot="calendar-day-button"][data-day="2026-07-16"]');
  const day21 = section.locator('[data-slot="calendar-day-button"][data-day="2026-07-21"]');
  const day22 = section.locator('[data-slot="calendar-day-button"][data-day="2026-07-22"]');

  await day21.click();
  await expect(day21).toHaveAttribute('aria-selected', 'true');
  await expect(day16).toHaveAttribute('aria-selected', 'false');
  await expect(day21).toHaveAttribute('data-focused', '');

  await page.keyboard.press('ArrowRight');
  await expect(day22).toHaveAttribute('data-focused', '');
  await expect(day22).toHaveAttribute('aria-selected', 'false');
});

test('date picker opens a popup calendar and commits a chosen day', async ({ page }) => {
  await page.goto('/');

  const trigger = page.locator('#fixture-date-picker-trigger');
  await expect(trigger).toHaveText('July 16, 2026');
  await expect(trigger).toHaveAttribute('aria-expanded', 'false');

  await trigger.click();
  await expect(trigger).toHaveAttribute('aria-expanded', 'true');
  const popup = page.locator('[data-slot="date-picker-content"]');
  await expect(popup).toBeVisible();
  await expect(popup.getByRole('grid')).toBeVisible();

  await popup.locator('[data-slot="calendar-day-button"][data-day="2026-07-21"]').click();
  await expect(trigger).toHaveText('July 21, 2026');
  await expect(trigger).toHaveAttribute('aria-expanded', 'false');
  await expect(popup).toBeHidden();
});

test('date picker closes on Escape without changing the value', async ({ page }) => {
  await page.goto('/');

  const trigger = page.locator('#fixture-date-picker-trigger');
  await trigger.click();
  await expect(page.locator('[data-slot="date-picker-content"]')).toBeVisible();

  await page.keyboard.press('Escape');
  await expect(page.locator('[data-slot="date-picker-content"]')).toBeHidden();
  await expect(trigger).toHaveText('July 16, 2026');
});

test('date picker preset commits its date and closes the popup', async ({ page }) => {
  await page.goto('/');

  const trigger = page.locator('#fixture-date-picker-trigger');
  await trigger.click();
  const popup = page.locator('[data-slot="date-picker-content"]');
  await popup.getByRole('button', { name: 'Release' }).click();
  await expect(trigger).toHaveText('August 4, 2026');
  await expect(trigger).toHaveAttribute('aria-expanded', 'false');
  await expect(popup).toBeHidden();
});

test('range calendar starts a new range and normalizes reversed boundaries', async ({ page }) => {
  await page.goto('/');

  const section = page.locator('#fixture-section-calendar-range');
  const calendar = section.locator('#fixture-calendar-range');
  const day = (iso: string) =>
    section.locator(`[data-slot="calendar-day-button"][data-day="${iso}"]`);

  await expect(calendar).toHaveAttribute('data-range-start', '2026-07-10');
  await expect(calendar).toHaveAttribute('data-range-end', '2026-07-17');
  await expect(day('2026-07-12')).toHaveAttribute('data-range-middle', '');

  await day('2026-07-25').click();
  await expect(section.locator('#fixture-calendar-range-output')).toHaveText(
    '2026-07-25..pending',
  );
  await day('2026-07-22').click();
  await expect(calendar).toHaveAttribute('data-range-start', '2026-07-22');
  await expect(calendar).toHaveAttribute('data-range-end', '2026-07-25');
  await expect(section.locator('#fixture-calendar-range-output')).toHaveText(
    '2026-07-22..2026-07-25',
  );
});

test('multiple calendar independently toggles selected dates', async ({ page }) => {
  await page.goto('/');

  const section = page.locator('#fixture-section-calendar-multiple');
  const calendar = section.locator('#fixture-calendar-multiple');
  const day8 = section.locator('[data-day="2026-07-08"]');
  const day23 = section.locator('[data-day="2026-07-23"]');

  await expect(calendar).toHaveAttribute('data-selected-count', '2');
  await expect(day8).toHaveAttribute('aria-selected', 'true');
  await day8.click();
  await expect(day8).toHaveAttribute('aria-selected', 'false');
  await expect(calendar).toHaveAttribute('data-selected-count', '1');

  await day23.click();
  await expect(day23).toHaveAttribute('aria-selected', 'true');
  await expect(section.locator('#fixture-calendar-multiple-output')).toHaveText(
    '2026-07-16,2026-07-23',
  );
});

test('date range picker stays open for the first boundary and commits the second', async ({ page }) => {
  await page.goto('/');

  const section = page.locator('#fixture-section-date-range-picker');
  const trigger = section.locator('#fixture-date-range-picker-trigger');
  const output = section.locator('#fixture-date-range-picker-output');

  await trigger.click();
  await expect(trigger).toHaveAttribute('aria-expanded', 'true');
  const popup = section.locator('[data-slot="date-range-picker-content"]');
  await expect(popup).toBeVisible();

  await popup.locator('[data-day="2026-07-25"]').click();
  await expect(output).toHaveText('state:open|value:2026-07-25..pending');
  await expect(popup).toBeVisible();
  await popup.locator('[data-day="2026-07-22"]').click();
  await expect(output).toHaveText('state:closed|value:2026-07-22..2026-07-25');
  await expect(trigger).toHaveAttribute('aria-expanded', 'false');
  await expect(popup).toBeHidden();
});
