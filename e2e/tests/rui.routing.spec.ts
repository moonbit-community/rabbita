import { expect, test } from '@playwright/test';

test('fixture navigation switches pages inside the SPA and follows history', async ({ page }) => {
  await page.goto('/');
  await expect(page.locator('#fixture-route-title')).toHaveText('Index');

  await page.getByRole('link', { name: 'Forms' }).click();
  await expect(page).toHaveURL(/\/forms$/);
  await expect(page.locator('#fixture-route-title')).toHaveText('Forms');
  await expect(page.getByText('This is the Forms route.')).toBeVisible();

  await page.getByRole('link', { name: 'Modals' }).click();
  await expect(page).toHaveURL(/\/modals$/);
  await expect(page.locator('#fixture-route-title')).toHaveText('Modals');
  await expect(page.getByText('This is the Modals route.')).toBeVisible();

  await page.goBack();
  await expect(page).toHaveURL(/\/forms$/);
  await expect(page.locator('#fixture-route-title')).toHaveText('Forms');
});

test('fixture renders an explicit not-found page for unknown routes', async ({ page }) => {
  await page.goto('/missing-fixture');

  await expect(page.locator('#fixture-route-title')).toHaveText('Not found');
  await expect(page.getByRole('heading', { name: 'Fixture page not found' })).toBeVisible();
  await expect(page.getByText('No fixture page exists for /missing-fixture.')).toBeVisible();
});
