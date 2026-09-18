import { expect, test, type Locator, type Page } from '@playwright/test';

async function settleFrame(page: Page) {
  await page.evaluate(() => new Promise<void>((resolve) => {
    requestAnimationFrame(() => requestAnimationFrame(() => resolve()));
  }));
}

async function countStyleReads(element: Locator) {
  await element.evaluate((node) => {
    const element = node as HTMLElement;
    const style = element.style;
    element.dataset.styleReads = '0';
    Object.defineProperty(element, 'style', {
      get() {
        element.dataset.styleReads = String(Number(element.dataset.styleReads) + 1);
        return style;
      },
    });
  });
}

test('container roots skip identical references and cache each replacement', async ({ page }) => {
  await page.goto('/?physical-root');
  await settleFrame(page);
  const root = page.locator('#physical-root');
  await countStyleReads(root);
  for (const [value, reads] of [['A', 0], ['B', 1], ['B', 1], ['A', 2], ['A', 2]] as const) {
    await page.getByRole('button', { name: 'Advance root', exact: true }).click();
    await settleFrame(page);
    await expect(page.locator('#physical-root-value')).toHaveText(value);
    await expect(root).toHaveAttribute('data-style-reads', String(reads));
  }
});

for (const markers of [true, false]) {
  test(`hydrated document roots and shared nodes retain their caches with ${markers ? 'existing' : 'missing'} fragment markers`, async ({ page }) => {
    // Serve actual pre-rendered nodes before the application module hydrates them.
    const fragment = '<span id="hydrated-fragment">fragment</span>';
    await page.route('**/?physical-document', (route) => route.fulfill({
      contentType: 'text/html',
      body: `<!doctype html><html><head><title>Physical document 0</title></head><body>` +
        `<button>Refresh document</button><button>Update document</button>` +
        `<p id="document-version">revision: 0</p>` +
        `<div id="hydrated-element">element A</div>shared text` +
        (markers ? `<!--[-->${fragment}<!--]-->` : fragment) +
        `<div id="hydrated-thunk">thunk</div>` +
        `<script>
          document.documentElement.physicalSeed = {
            element: document.getElementById('hydrated-element'),
            text: [...document.body.childNodes].find(node => node.nodeType === 3 && node.nodeValue === 'shared text'),
            fragment: document.getElementById('hydrated-fragment'),
            thunk: document.getElementById('hydrated-thunk'),
          };
        </script><script type="module" src="/index.js"></script></body></html>`,
    }));
    await page.goto('/?physical-document');
    await expect(page.locator('html')).toHaveId('physical-hydrated');
    await settleFrame(page);

    expect(await page.evaluate(() => {
      const seed = (document.documentElement as HTMLElement & {
        physicalSeed: Record<string, Node>;
      }).physicalSeed;
      return {
        element: seed.element === document.getElementById('hydrated-element'),
        text: seed.text.isConnected,
        fragment: seed.fragment === document.getElementById('hydrated-fragment'),
        thunk: seed.thunk === document.getElementById('hydrated-thunk'),
        markers: [...document.body.childNodes]
          .filter(node => node.nodeType === 8)
          .map(node => node.nodeValue),
      };
    })).toEqual({ element: true, text: true, fragment: markers, thunk: true, markers: ['[', ']'] });
    await expect(page.locator('#hydrated-fragment')).toHaveCount(1);
    await expect(page.locator('#hydrated-fragment')).toHaveText('fragment');

    const html = page.locator('html');
    const element = page.locator('#hydrated-element');
    const sharedFragment = page.locator('#hydrated-fragment');
    await countStyleReads(html);
    await countStyleReads(element);
    await countStyleReads(sharedFragment);

    await page.getByRole('button', { name: 'Refresh document', exact: true }).click();
    await settleFrame(page);
    await expect(html).toHaveAttribute('data-style-reads', '0');

    for (const [revision, value, reads] of [[1, 'A', 0], [2, 'B', 1], [3, 'B', 1], [4, 'A', 2]] as const) {
      await page.getByRole('button', { name: 'Update document', exact: true }).click();
      await expect(page.locator('#document-version')).toHaveText(`revision: ${revision}`);
      await expect(page).toHaveTitle(`Physical document ${revision}`);
      await expect(element).toHaveText(`element ${value}`);
      await expect(html).toHaveAttribute('data-style-reads', String(revision));
      await expect(element).toHaveAttribute('data-style-reads', String(reads));
      await expect(sharedFragment).toHaveAttribute('data-style-reads', '0');
      await page.getByRole('button', { name: 'Refresh document', exact: true }).click();
      await settleFrame(page);
      await expect(html).toHaveAttribute('data-style-reads', String(revision));
    }
  });
}
