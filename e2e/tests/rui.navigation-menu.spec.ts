import { expect, test } from '@playwright/test';

test('navigation menu opens its viewport on hover', async ({ page }) => {
  await page.goto('/');

  const platform = page.getByRole('button', { name: 'Platform' });
  const viewport = page.locator('[data-slot="navigation-menu-viewport"]');

  await expect(viewport).toBeHidden();
  await expect(platform).toHaveAttribute('aria-expanded', 'false');

  await platform.hover();
  await expect(platform).toHaveAttribute('aria-expanded', 'true');
  await expect(viewport).toBeVisible();
  await expect(viewport.getByRole('link', { name: 'Components' })).toBeVisible();
  await expect(viewport.getByRole('link', { name: 'API reference' })).toBeHidden();
});

test('navigation menu switches content when hovering another item', async ({ page }) => {
  await page.goto('/');

  const platform = page.getByRole('button', { name: 'Platform' });
  const resources = page.getByRole('button', { name: 'Resources' });
  const viewport = page.locator('[data-slot="navigation-menu-viewport"]');

  await platform.hover();
  await expect(viewport.getByRole('link', { name: 'Components' })).toBeVisible();

  await resources.hover();
  await expect(viewport.getByRole('link', { name: 'API reference' })).toBeVisible();
  await expect(viewport.getByRole('link', { name: 'Components' })).toBeHidden();
  await expect(resources).toHaveAttribute('aria-expanded', 'true');
  await expect(platform).toHaveAttribute('aria-expanded', 'false');
});

test('navigation menu toggles on keyboard activation and closes on Escape', async ({ page }) => {
  await page.goto('/');

  const platform = page.getByRole('button', { name: 'Platform' });
  const viewport = page.locator('[data-slot="navigation-menu-viewport"]');

  await platform.focus();
  await page.keyboard.press('Enter');
  await expect(platform).toHaveAttribute('aria-expanded', 'true');
  await expect(viewport).toBeVisible();

  await page.keyboard.press('Escape');
  await expect(viewport).toBeHidden();
  await expect(platform).toHaveAttribute('aria-expanded', 'false');
  await expect(platform).toBeFocused();

  await platform.hover();
  await expect(viewport).toBeVisible();
  await page.keyboard.press('Enter');
  await expect(viewport).toBeHidden();
});

test('navigation menu roves triggers and moves into content with ArrowDown', async ({ page }) => {
  await page.goto('/');

  const platform = page.getByRole('button', { name: 'Platform' });
  const resources = page.getByRole('button', { name: 'Resources' });
  const viewport = page.locator('[data-slot="navigation-menu-viewport"]');

  await platform.focus();
  await page.keyboard.press('ArrowRight');
  await expect(resources).toBeFocused();
  await page.keyboard.press('Home');
  await expect(platform).toBeFocused();
  await page.keyboard.press('End');
  await expect(resources).toBeFocused();
  await page.keyboard.press('ArrowDown');
  await expect(viewport).toBeVisible();
  await expect(viewport.getByRole('link', { name: 'API reference' })).toBeFocused();
  await page.keyboard.press('Escape');
  await expect(resources).toBeFocused();
});
