import { expect, test } from '@playwright/test';

test('message scroller jump controls track both scroll edges', async ({ page }) => {
  await page.goto('/');

  const section = page.locator('#fixture-section-message-scroller');
  const viewport = section.locator('#fixture-message-scroller-viewport');
  const start = section.getByRole('button', { name: 'Jump to first fixture message' });
  const end = section.getByRole('button', { name: 'Jump to latest fixture message' });

  await expect(viewport).toHaveAttribute('data-at-start', 'true');
  await expect(start).toBeDisabled();
  await expect(end).toBeEnabled();
  await end.click();
  await expect(viewport).toHaveAttribute('data-at-end', 'true');
  await expect(end).toBeDisabled();
  await expect(start).toBeEnabled();

  await start.click();
  await expect(viewport).toHaveAttribute('data-at-start', 'true');
  await expect(start).toBeDisabled();
});
