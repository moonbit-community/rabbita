import { expect, test } from '@playwright/test';

const sidebarRoot = '#fixture-sidebar-root';

test('sidebar collapses and expands through the trigger', async ({ page }) => {
  await page.goto('/');

  const root = page.locator(sidebarRoot);
  const trigger = page.getByRole('button', { name: 'Toggle sidebar' });

  await expect(root).toHaveAttribute('data-state', 'expanded');
  await trigger.click();
  await expect(root).toHaveAttribute('data-state', 'collapsed');
  await trigger.click();
  await expect(root).toHaveAttribute('data-state', 'expanded');
});

test('collapsed icon sidebar opens a tooltip on hover', async ({ page }) => {
  await page.goto('/');

  await page.getByRole('button', { name: 'Toggle sidebar' }).click();
  await expect(page.locator(sidebarRoot)).toHaveAttribute('data-state', 'collapsed');

  const overview = page.locator('#fixture-sidebar-overview');
  await expect(overview).toBeVisible();

  const tooltip = page.getByRole('tooltip', { name: 'Overview' });
  await expect(tooltip).toBeHidden();
  await overview.hover();
  await expect(tooltip).toBeVisible();

  await page.getByText('Workspace overview', { exact: true }).hover();
  await expect(tooltip).toBeHidden();
});

test('sidebar rail drag resizes without collapsing', async ({ page }) => {
  await page.goto('/');

  const root = page.locator(sidebarRoot);
  const rail = page.getByRole('button', { name: 'Resize sidebar' });
  const before = await root.boundingBox();
  const railBox = await rail.boundingBox();
  expect(before).not.toBeNull();
  expect(railBox).not.toBeNull();

  const startX = railBox!.x + railBox!.width / 2;
  const startY = railBox!.y + railBox!.height / 2;
  await page.mouse.move(startX, startY);
  await page.mouse.down();
  await page.mouse.move(startX + 40, startY, { steps: 4 });
  await page.mouse.up();

  const after = await root.boundingBox();
  expect(after!.width).toBeGreaterThan(before!.width);
  await expect(root).toHaveAttribute('data-state', 'expanded');
});

test('mobile sidebar traps focus, closes on Escape, and restores its trigger', async ({ page }) => {
  await page.goto('/');

  const section = page.locator('#fixture-section-sidebar-mobile');
  const trigger = section.locator('[data-slot="sidebar-trigger"]');
  const dialog = page.getByRole('dialog', { name: 'Fixture mobile navigation' });
  const close = dialog.getByRole('button', { name: 'Close mobile navigation' });

  await trigger.click();
  await expect(dialog).toBeVisible();
  await expect(dialog).toHaveAttribute('aria-modal', 'true');
  await expect(trigger).toHaveAttribute('aria-expanded', 'true');
  await expect(section.locator('#fixture-sidebar-mobile-output')).toHaveText('open');
  await expect(dialog).toBeFocused();

  await close.focus();
  await close.press('Shift+Tab');
  await expect(dialog.getByRole('link', { name: 'Mobile settings' })).toBeFocused();
  await page.keyboard.press('Tab');
  await expect(close).toBeFocused();

  await page.keyboard.press('Escape');
  await expect(dialog).toBeHidden();
  await expect(trigger).toBeFocused();
  await expect(section.locator('#fixture-sidebar-mobile-output')).toHaveText('closed');
});

test('mobile sidebar overlay dismisses the sheet', async ({ page }) => {
  await page.goto('/');

  const section = page.locator('#fixture-section-sidebar-mobile');
  const trigger = section.locator('[data-slot="sidebar-trigger"]');
  await trigger.click();
  await expect(page.getByRole('dialog', { name: 'Fixture mobile navigation' })).toBeVisible();
  const overlay = page.locator('[data-slot="sidebar-overlay"][data-state="open"]');
  const overlayBox = await overlay.boundingBox();
  if (!overlayBox) throw new Error('mobile sidebar overlay has no layout box');
  await page.mouse.click(
    overlayBox.x + overlayBox.width - 4,
    overlayBox.y + overlayBox.height / 2,
  );
  await expect(page.getByRole('dialog', { name: 'Fixture mobile navigation' })).toBeHidden();
  await expect(trigger).toBeFocused();
});
