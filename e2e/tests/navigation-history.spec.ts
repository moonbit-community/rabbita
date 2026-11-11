import { expect, test } from '@playwright/test';

for (const target of [null, '', '_self', '_SELF']) {
  test(`same-context target ${JSON.stringify(target)} is captured`, async ({ page }) => {
    await page.goto('/origin');
    const link = page.locator('#captured-link');
    await link.evaluate((node, target) => {
      if (target === null) node.removeAttribute('target');
      else node.setAttribute('target', target);
    }, target);
    await link.locator('span').click();
    await expect(page.locator('#request-count')).toHaveText('requests: 1');
    await expect(page).toHaveURL(/\/captured$/);
  });
}

const bypassCases: { name: string; target?: string; download?: string; cancelled?: boolean; mouse?: MouseEventInit }[] = [
  { name: 'blank target', target: '_blank' },
  { name: 'named target', target: 'preview' },
  { name: 'parent target', target: '_parent' },
  { name: 'top target', target: '_top' },
  { name: 'empty download attribute', download: '' },
  { name: 'named download', download: 'example.txt' },
  { name: 'prior preventDefault', cancelled: true },
  { name: 'Ctrl click', mouse: { ctrlKey: true } },
  { name: 'Meta click', mouse: { metaKey: true } },
  { name: 'Shift click', mouse: { shiftKey: true } },
  { name: 'Alt click', mouse: { altKey: true } },
  { name: 'non-primary click', mouse: { button: 1 } },
];

for (const scenario of bypassCases) {
  test(`${scenario.name} bypasses the navigation hook`, async ({ page }) => {
    await page.goto('/origin');
    const intercepted = await page.locator('#captured-link').evaluate((node, scenario) => {
      if (scenario.target !== undefined) node.setAttribute('target', scenario.target);
      if (scenario.download !== undefined) node.setAttribute('download', scenario.download);
      if (scenario.cancelled) node.addEventListener('click', event => event.preventDefault(), { capture: true, once: true });
      let intercepted = false;
      document.addEventListener('click', event => {
        intercepted = event.defaultPrevented;
        // Stop native navigation only AFTER the framework's link listener ran.
        event.preventDefault();
      }, { once: true });
      node.querySelector('span')!.dispatchEvent(new MouseEvent('click', {
        bubbles: true, cancelable: true, button: 0, ...scenario.mouse,
      }));
      return intercepted;
    }, scenario);
    expect(intercepted).toBe(Boolean(scenario.cancelled));
    await page.getByRole('button', { name: 'Increment preserved state' }).click();
    await expect(page.locator('#preserved-count')).toHaveText('count: 1');
    await expect(page.locator('#request-count')).toHaveText('requests: 0');
    await expect(page).toHaveURL(/\/origin$/);
  });
}

test('keyboard activation still uses the navigation hook', async ({ page }) => {
  await page.goto('/origin');
  await page.locator('#captured-link').press('Enter');
  await expect(page.locator('#request-count')).toHaveText('requests: 1');
  await expect(page).toHaveURL(/\/captured$/);
});

test('blank links really open a new page', async ({ page }) => {
  await page.goto('/origin');
  const popupPromise = page.waitForEvent('popup');
  await page.locator('#blank-link').click();
  const popup = await popupPromise;
  await expect(popup).toHaveURL(/\/new-tab$/);
  await expect(page.locator('#request-count')).toHaveText('requests: 0');
  await expect(page).toHaveURL(/\/origin$/);
  await popup.close();
});

test('download links really start a download', async ({ page }) => {
  await page.goto('/origin');
  const link = page.locator('#download-link');
  await link.evaluate(node => {
    node.setAttribute('href', URL.createObjectURL(new Blob(['download fixture'], { type: 'text/plain' })));
  });
  const downloadPromise = page.waitForEvent('download');
  await link.click();
  const download = await downloadPromise;
  expect(download.suggestedFilename()).toBe('example.txt');
  expect(await download.failure()).toBeNull();
  await expect(page.locator('#request-count')).toHaveText('requests: 0');
  await expect(page).toHaveURL(/\/origin$/);
});

test('deep links, push, and replace preserve application state', async ({ page }) => {
  await page.goto('/deep?mode=e2e');

  await expect(page.locator('#location')).toHaveText('/deep?mode=e2e');
  await page.getByRole('button', { name: 'Increment preserved state' }).click();
  await expect(page.locator('#preserved-count')).toHaveText('count: 1');

  await page.getByRole('button', { name: 'Push first URL' }).click();
  await expect(page).toHaveURL(/\/first\?from=push$/);
  await expect(page.locator('#location')).toHaveText('/first?from=push');
  await expect(page.locator('#preserved-count')).toHaveText('count: 1');

  await page.getByRole('button', { name: 'Replace with second URL' }).click();
  await expect(page).toHaveURL(/\/second\?from=replace$/);
  await expect(page.locator('#location')).toHaveText('/second?from=replace');
  await expect(page.locator('#preserved-count')).toHaveText('count: 1');
});

test('back and forward traverse same-origin history without reloads', async ({ page }) => {
  await page.goto('/origin');
  await page.getByRole('button', { name: 'Increment preserved state' }).click();
  await page.getByRole('button', { name: 'Push first URL' }).click();
  await page.getByRole('button', { name: 'Replace with second URL' }).click();

  await page.getByRole('button', { name: 'Go back' }).click();
  await expect(page).toHaveURL(/\/origin$/);
  await expect(page.locator('#location')).toHaveText('/origin');
  await expect(page.locator('#preserved-count')).toHaveText('count: 1');

  await page.getByRole('button', { name: 'Go forward' }).click();
  await expect(page).toHaveURL(/\/second\?from=replace$/);
  await expect(page.locator('#location')).toHaveText('/second?from=replace');
  await expect(page.locator('#preserved-count')).toHaveText('count: 1');
});
