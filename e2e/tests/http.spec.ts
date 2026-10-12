import { expect, test } from '@playwright/test';

for (const baseHref of [undefined, '/assets/', 'https://cdn.example.test/assets/']) {
  test('relative HTTP URLs use the document base: ' + (baseHref ?? '/uml/'), async ({ page }) => {
    await page.route('**/api/resource', (route) =>
      route.fulfill({ contentType: 'text/plain', body: 'resource ready' }),
    );
    const urls: string[] = [];
    await page.route(/\/api(?:\/method\/[^/]+)?$/, async (route) => {
      urls.push(route.request().url());
      await route.fulfill({ contentType: 'text/plain', body: 'ok' });
    });
    await page.goto('/');
    const origin = new URL(page.url()).origin;
    await page.evaluate((baseHref) => {
      history.replaceState(null, '', '/uml/');
      if (baseHref) {
        const base = document.createElement('base');
        base.href = baseHref;
        document.head.append(base);
      }
    }, baseHref);

    const expectedBase = baseHref
      ? new URL(baseHref, origin).href
      : origin + '/uml/';
    for (const method of ['GET', 'POST', 'PUT', 'PATCH', 'DELETE']) {
      await page.getByRole('button', { name: 'Send ' + method }).click();
      await expect(page.locator('#' + method.toLowerCase() + '-status'))
        .toHaveText(method === 'DELETE' ? 'deleted' : 'ok');
    }
    expect(urls).toEqual(
      ['api', 'api/method/post', 'api/method/put', 'api/method/patch', 'api/method/delete'].map(
        (path) => expectedBase + path,
      ),
    );
  });
}

test('GET, POST, PUT, PATCH, and DELETE preserve request semantics', async ({ page }) => {
  const requests: Array<{
    method: string;
    body: string | null;
    contentType: string | undefined;
  }> = [];
  await page.route('**/api/resource', (route) =>
    route.fulfill({ contentType: 'text/plain', body: 'resource ready' }),
  );
  await page.route(/\/api(?:\/method\/[^/]+)?$/, async (route) => {
    const request = route.request();
    requests.push({
      method: request.method(),
      body: request.postData(),
      contentType: request.headers()['content-type'],
    });
    if (request.method() === 'DELETE') {
      await route.fulfill({ status: 204 });
    } else {
      await route.fulfill({
        contentType: 'text/plain',
        body: `${request.method().toLowerCase()}-ok`,
      });
    }
  });
  await page.goto('/');

  for (const method of ['GET', 'POST', 'PUT', 'PATCH', 'DELETE']) {
    await page.getByRole('button', { name: `Send ${method}` }).click();
  }
  await expect(page.locator('#get-status')).toHaveText('get-ok');
  await expect(page.locator('#post-status')).toHaveText('post-ok');
  await expect(page.locator('#put-status')).toHaveText('put-ok');
  await expect(page.locator('#patch-status')).toHaveText('patch-ok');
  await expect(page.locator('#delete-status')).toHaveText('deleted');

  expect(requests.map(({ method }) => method)).toEqual([
    'GET',
    'POST',
    'PUT',
    'PATCH',
    'DELETE',
  ]);
  expect(requests[0]?.body).toBeNull();
  expect(JSON.parse(requests[1]?.body ?? '{}')).toEqual({ name: 'rabbit' });
  expect(requests[1]?.contentType).toContain('application/json');
  expect(requests[2]?.body).toBe('put-body');
  expect(requests[3]?.body).toBe('patch-body');
  expect(requests[4]?.body).toBeNull();
});

test('text, JSON, blob, and bytes decoders expose response values', async ({ page }) => {
  await page.route('**/api/resource', (route) =>
    route.fulfill({ contentType: 'text/plain', body: 'resource ready' }),
  );
  await page.route('**/api/decode/text', (route) =>
    route.fulfill({ contentType: 'text/plain', body: 'text value' }),
  );
  await page.route('**/api/decode/json', (route) =>
    route.fulfill({
      contentType: 'application/json',
      body: JSON.stringify({ value: 'json value' }),
    }),
  );
  await page.route('**/api/decode/blob', (route) =>
    route.fulfill({ contentType: 'application/octet-stream', body: 'blob-data' }),
  );
  await page.route('**/api/decode/bytes', (route) =>
    route.fulfill({ contentType: 'application/custom', body: 'bytes' }),
  );
  await page.goto('/');

  await page.getByRole('button', { name: 'Decode text' }).click();
  await expect(page.locator('#text-status')).toHaveText('text value');
  await page.getByRole('button', { name: 'Decode JSON' }).click();
  await expect(page.locator('#json-status')).toHaveText('json value');
  await page.getByRole('button', { name: 'Decode blob' }).click();
  await expect(page.locator('#blob-status')).toHaveText('application/octet-stream:9');
  await page.getByRole('button', { name: 'Decode bytes' }).click();
  await expect(page.locator('#bytes-status')).toHaveText('application/custom:5');
});

test('resource moves from pending to loaded', async ({ page }) => {
  let releaseResource: (() => void) | undefined;
  const gate = new Promise<void>((resolve) => {
    releaseResource = resolve;
  });
  await page.route('**/api/resource', async (route) => {
    await gate;
    await route.fulfill({ contentType: 'text/plain', body: 'resource ready' });
  });
  await page.goto('/');

  await expect(page.locator('#resource-status')).toHaveText('pending');
  releaseResource?.();
  await expect(page.locator('#resource-status')).toHaveText('loaded: resource ready');
});

test('HTTP and resource failures become stable failure states', async ({ page }) => {
  await page.route('**/api/resource', (route) =>
    route.fulfill({ status: 503, contentType: 'text/plain', body: 'unavailable' }),
  );
  await page.route('**/api/failure', (route) =>
    route.fulfill({ status: 500, contentType: 'text/plain', body: 'broken' }),
  );
  await page.goto('/');

  await expect(page.locator('#resource-status')).toHaveText('failed');
  await page.getByRole('button', { name: 'Request failure' }).click();
  await expect(page.locator('#failure-status')).toHaveText('failed');
});
