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

test('navigation viewport aligns to the trigger start and stays inside narrow viewports', async ({ page }) => {
  for (const width of [1280, 390]) {
    await page.setViewportSize({ width, height: 844 });
    await page.goto('/');
    for (const direction of ['ltr', 'rtl']) {
      await page.evaluate((dir) => { document.documentElement.dir = dir; }, direction);
      const trigger = page.getByRole('button', { name: 'Platform' });
      const viewport = page.locator('[data-slot="navigation-menu-viewport"]');
      await trigger.hover();
      await expect(viewport).toBeVisible();
      await expect.poll(async () => {
        const anchor = await trigger.boundingBox();
        const popup = await viewport.boundingBox();
        if (!anchor || !popup) return Infinity;
        const start = direction === 'ltr' ? anchor.x : anchor.x + anchor.width - popup.width;
        const expected = Math.max(8, Math.min(start, width - popup.width - 8));
        return Math.abs(popup.x - expected);
      }).toBeLessThan(1);
      const popup = (await viewport.boundingBox())!;
      const content = (await viewport.locator('[data-slot="navigation-menu-content"]').boundingBox())!;
      expect(popup.x).toBeGreaterThanOrEqual(8);
      expect(popup.x + popup.width).toBeLessThanOrEqual(width - 8);
      expect(content.x).toBeGreaterThanOrEqual(popup.x);
      expect(content.x + content.width).toBeLessThanOrEqual(popup.x + popup.width);
      await page.keyboard.press('Escape');
      await page.mouse.move(0, 0);
    }
  }
});
