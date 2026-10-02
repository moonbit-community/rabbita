import { expect, test } from '@playwright/test';

declare global {
  interface Window {
    testSockets: WebSocket[];
  }
}

for (const name of ['Invalid socket scheme', 'Socket URL fragment', 'Duplicate socket protocols']) {
  test(`${name} delivers one error without breaking subscriptions`, async ({ page }) => {
    const pageErrors: string[] = [];
    page.on('pageerror', error => pageErrors.push(error.message));
    await page.goto('/');
    await page.getByRole('button', { name, exact: true }).click();
    await expect(page.locator('#socket-errors')).toHaveText('socket errors: 1');

    // A failed connection stays inert until removed, even as its error updates state.
    await page.getByRole('button', { name: 'Flush barrier', exact: true }).click();
    await expect(page.locator('#barrier')).toHaveText('barrier: 1');
    await expect(page.locator('#socket-errors')).toHaveText('socket errors: 1');
    await page.getByRole('button', { name: 'Remove socket', exact: true }).click();
    await page.getByRole('button', { name, exact: true }).click();
    await expect(page.locator('#socket-errors')).toHaveText('socket errors: 2');
    await page.keyboard.press('K');
    await expect(page.locator('#last-key')).toHaveText('last key: K');
    expect(pageErrors).toEqual([]);
  });
}

for (const name of ['Valid socket', 'Valid socket with protocol']) {
  test(`${name} retains events and cleans up listeners`, async ({ page }) => {
    let closes = 0;
    await page.routeWebSocket('ws://example.test/socket', socket => {
      socket.send('hello');
      socket.onClose(() => { closes += 1; });
    });
    await page.goto('/');
    // Install after Playwright's WebSocket routing shim, and ignore Warren's socket.
    await page.evaluate(() => {
      const NativeWebSocket = window.WebSocket;
      window.testSockets = [];
      window.WebSocket = class extends NativeWebSocket {
        constructor(url: string | URL, protocols?: string | string[]) {
          super(url, protocols);
          if (this.url === 'ws://example.test/socket') {
            window.testSockets.push(this);
          }
        }
      };
    });
    await page.getByRole('button', { name, exact: true }).click();
    await expect(page.locator('#socket-opens')).toHaveText('socket opens: 1');
    await expect(page.locator('#socket-message')).toHaveText('socket message: hello');
    await page.evaluate(() => window.testSockets[0].dispatchEvent(new Event('error')));
    await expect(page.locator('#socket-errors')).toHaveText('socket errors: 1');
    await page.getByRole('button', { name: 'Remove socket', exact: true }).click();
    await expect.poll(() => closes).toBe(1);
    await page.evaluate(() => window.testSockets[0].dispatchEvent(new Event('error')));
    await page.getByRole('button', { name: 'Flush barrier', exact: true }).click();
    await expect(page.locator('#barrier')).toHaveText('barrier: 1');
    await expect(page.locator('#socket-errors')).toHaveText('socket errors: 1');
  });
}

test('resize and global keyboard subscriptions deliver browser events', async ({ page }) => {
  await page.goto('/');

  await page.setViewportSize({ width: 900, height: 700 });
  await expect(page.locator('#viewport')).toHaveText('viewport: 900x700');
  await expect(page.locator('#resize-count')).toHaveText(/resizes: [1-9]\d*/);

  await page.keyboard.press('K');
  await expect(page.locator('#key-count')).toHaveText('keys: 1');
  await expect(page.locator('#last-key')).toHaveText('last key: K');
});

test('subscriptions stop when disabled and resume when enabled', async ({ page }) => {
  await page.goto('/');

  await page.getByRole('button', { name: 'Disable subscriptions' }).click();
  await expect(page.locator('#subscription-state')).toHaveText('inactive');
  await page.evaluate(() => window.dispatchEvent(new Event('resize')));
  await page.keyboard.press('X');
  await page.getByRole('button', { name: 'Flush barrier' }).click();
  await expect(page.locator('#barrier')).toHaveText('barrier: 1');
  await expect(page.locator('#resize-count')).toHaveText('resizes: 0');
  await expect(page.locator('#key-count')).toHaveText('keys: 0');

  await page.getByRole('button', { name: 'Enable subscriptions' }).click();
  await expect(page.locator('#subscription-state')).toHaveText('active');
  await page.evaluate(() => window.dispatchEvent(new Event('resize')));
  await page.keyboard.press('Y');
  await expect(page.locator('#resize-count')).toHaveText('resizes: 1');
  await expect(page.locator('#key-count')).toHaveText('keys: 1');
  await expect(page.locator('#last-key')).toHaveText('last key: Y');
});

test('a retained subscription dispatches through the latest tagger', async ({ page }) => {
  await page.goto('/');

  await expect(page.locator('#tagger-mode')).toHaveText('tagger: old');
  await page.keyboard.press('A');
  await expect(page.locator('#old-tagger-count')).toHaveText('old tagger: 1');
  await expect(page.locator('#new-tagger-count')).toHaveText('new tagger: 0');

  await page.getByRole('button', { name: 'Use new tagger' }).click();
  await expect(page.locator('#tagger-mode')).toHaveText('tagger: new');
  await page.keyboard.press('B');
  await expect(page.locator('#old-tagger-count')).toHaveText('old tagger: 1');
  await expect(page.locator('#new-tagger-count')).toHaveText('new tagger: 1');
  await expect(page.locator('#last-key')).toHaveText('last key: B');

  await page.getByRole('button', { name: 'Use old tagger' }).click();
  await expect(page.locator('#tagger-mode')).toHaveText('tagger: old');
  await page.keyboard.press('C');
  await expect(page.locator('#old-tagger-count')).toHaveText('old tagger: 2');
  await expect(page.locator('#new-tagger-count')).toHaveText('new tagger: 1');
  await expect(page.locator('#last-key')).toHaveText('last key: C');
});
