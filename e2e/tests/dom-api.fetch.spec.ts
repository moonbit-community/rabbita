import { expect, test } from '@playwright/test';

test('fetch bindings preserve native requests, responses, HTTP errors, and cancellation', async ({ page }) => {
  await page.route('**/fetch-api/**', async (route) => {
    const request = route.request();
    switch (new URL(request.url()).pathname) {
      case '/fetch-api/json':
        await route.fulfill({ json: { name: 'rabbit' } });
        break;
      case '/fetch-api/echo':
        await route.fulfill({
          status: 201,
          headers: { 'x-response': 'native' },
          json: {
            method: request.method(),
            body: request.postData(),
            header: request.headers()['x-rabbit'],
          },
        });
        break;
      case '/fetch-api/missing':
        await route.fulfill({ status: 404, body: 'missing' });
        break;
      case '/fetch-api/network':
        await route.abort('failed');
        break;
      default:
        throw new Error(`Unexpected fetch probe URL: ${request.url()}`);
    }
  });
  await page.goto('/');
  await page.getByRole('button', { name: 'Run Fetch APIs' }).click();
  await expect(page.locator('#fetch-result')).toHaveText('passed');
});
