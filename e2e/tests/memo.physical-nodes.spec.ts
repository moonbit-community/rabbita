import { expect, test, type Page } from '@playwright/test';

async function update(page: Page, action: string) {
  const revision = page.locator('#physical-revision');
  const previous = Number(await revision.innerText());
  await page.getByRole('button', { name: action, exact: true }).click();
  await expect(revision).toHaveText(String(previous + 1));
}

async function expectComputes(page: Page, expected: number) {
  const reading = page.locator('#count-physical-reading');
  const previous = Number(await reading.innerText());
  await page.getByRole('button', { name: 'Read physical count', exact: true }).click();
  await expect(reading).toHaveText(String(previous + 1));
  await expect(page.locator('#count-physical')).toHaveText(String(expected));
}

async function expectNodes(page: Page, value: string) {
  await expect(page.locator('#physical-element')).toHaveText(`element ${value}`);
  await expect(page.locator('#physical-element')).toHaveAttribute('title', value);
  await expect(page.locator('#physical-text-stage')).toHaveText(`text ${value}`);
  await expect(page.locator('#physical-fragment-stage')).toHaveText(`before|first ${value}second ${value}|after`);
  await expect(page.locator('#physical-thunk')).toHaveText(`thunk ${value}`);
}

async function watchElementDiff(page: Page) {
  await page.locator('#physical-element').evaluate((element: HTMLElement) => {
    const style = element.style;
    let reads = 0;
    element.dataset.styleReads = '0';
    // diff_props reads style even for a structurally identical fresh VNode.
    Object.defineProperty(element, 'style', {
      configurable: true,
      get() {
        element.dataset.styleReads = String(++reads);
        return style;
      },
    });
  });
}

test('shared element, text, fragment and thunk references survive A/A/B/B/A updates', async ({ page }) => {
  await page.goto('/?physical-nodes');
  await expectNodes(page, 'A');
  await expectComputes(page, 1);
  await watchElementDiff(page);
  const text = await page.locator('#physical-text-stage').evaluateHandle((stage) => stage.firstChild);
  const fragmentStart = await page.locator('#physical-fragment-stage').evaluateHandle((stage) => stage.childNodes[1]);
  let svg = await page.locator('#physical-svg').elementHandle();
  expect(await svg!.evaluate((node) => node.namespaceURI)).toBe('http://www.w3.org/1999/xhtml');

  for (const [action, value, reads, computes] of [
    ['Reuse nodes', 'A', 0, 1],
    ['Use B', 'B', 1, 2],
    ['Reuse nodes', 'B', 1, 2],
    ['Use A', 'A', 2, 3],
  ] as const) {
    await update(page, action);
    await expectNodes(page, value);
    await expect(page.locator('#physical-element')).toHaveAttribute('data-style-reads', String(reads));
    await expectComputes(page, computes);
    expect(await page.locator('#physical-text-stage').evaluate((stage, original) => stage.firstChild === original, text)).toBe(true);
    expect(await page.locator('#physical-fragment-stage').evaluate((stage, original) => stage.childNodes[1] === original, fragmentStart)).toBe(true);
    for (const kind of ['element', 'thunk']) {
      await page.locator(`#physical-${kind}`).click();
      await expect(page.locator('#physical-selected')).toHaveText(`${kind} ${value}`);
    }
    const namespace = value === 'A' ? 'http://www.w3.org/1999/xhtml' : 'http://www.w3.org/2000/svg';
    expect(await page.locator('#physical-svg').evaluate((node) => node.namespaceURI)).toBe(namespace);
    expect(await svg!.evaluate((node) => node.isConnected)).toBe(action === 'Reuse nodes');
    svg = await page.locator('#physical-svg').elementHandle();
  }
});

test('fresh equal nodes still diff properties while equal text and same-hash thunks preserve their DOM', async ({ page }) => {
  await page.goto('/?physical-nodes');
  await expectNodes(page, 'A');
  await watchElementDiff(page);
  const text = await page.locator('#physical-text-stage').evaluateHandle((stage) => stage.firstChild);
  const thunk = await page.locator('#physical-thunk').elementHandle();

  for (const [action, reads] of [['Use fresh A', 1], ['Reuse nodes', 2], ['Use A', 3], ['Reuse nodes', 3]] as const) {
    await update(page, action);
    await expectNodes(page, 'A');
    await expect(page.locator('#physical-element')).toHaveAttribute('data-style-reads', String(reads));
    await expectComputes(page, 1);
    expect(await page.locator('#physical-text-stage').evaluate((stage, original) => stage.firstChild === original, text)).toBe(true);
    expect(await page.locator('#physical-thunk').evaluate((node, original) => node === original, thunk)).toBe(true);
  }

  await update(page, 'Use B');
  await expectNodes(page, 'B');
  await expectComputes(page, 2);
  await page.locator('#physical-thunk').click();
  await expect(page.locator('#physical-selected')).toHaveText('thunk B');
});

test('shared nodes can change tag or kind, become empty fragments and restore their full ranges', async ({ page }) => {
  await page.goto('/?physical-nodes');
  await expectNodes(page, 'A');
  const element = await page.locator('#physical-element').elementHandle();
  const text = await page.locator('#physical-text-stage').evaluateHandle((stage) => stage.firstChild);
  const fragment = await page.locator('#physical-fragment-stage').evaluateHandle((stage) => stage.childNodes[1]);
  const thunk = await page.locator('#physical-thunk').elementHandle();

  await update(page, 'Replace node kinds');
  await expect(page.locator('#physical-element-stage')).toHaveText('replacement element');
  expect(await page.locator('#physical-element').evaluate((node) => node.tagName)).toBe('SPAN');
  await expect(page.locator('#physical-text-replacement')).toHaveText('replacement text');
  await expect(page.locator('#physical-fragment-stage')).toHaveText('before|replacement fragment|after');
  await expect(page.locator('#physical-thunk-replacement')).toHaveText('replacement thunk');
  for (const original of [element!, text, fragment, thunk!]) {
    expect(await original.evaluate((node) => node!.isConnected)).toBe(false);
  }

  await update(page, 'Use A');
  await expectNodes(page, 'A');
  await expectComputes(page, 2);
  const boundary = await page.locator('#physical-fragment-stage').evaluateHandle((stage) => stage.childNodes[1]);
  await update(page, 'Use empty fragments');
  await expect(page.locator('#physical-fragment-stage')).toHaveText('before||after');
  for (const kind of ['element', 'text', 'thunk']) {
    await expect(page.locator(`#physical-${kind}-stage`)).toBeEmpty();
  }
  const fragmentStage = page.locator('#physical-fragment-stage');
  expect(await fragmentStage.evaluate((stage, original) => stage.childNodes[1] === original, boundary)).toBe(true);
  expect(await fragmentStage.evaluate((stage) => Array.from(stage.childNodes).map((node) => node.nodeType))).toEqual([1, 8, 8, 1]);

  await update(page, 'Reuse nodes');
  expect(await fragmentStage.evaluate((stage, original) => stage.childNodes[1] === original, boundary)).toBe(true);
  await expectComputes(page, 2);
  await update(page, 'Use B');
  await expectNodes(page, 'B');
  await expectComputes(page, 3);
  expect(await fragmentStage.evaluate((stage) => Array.from(stage.childNodes).map((node) => node.nodeType))).toEqual([1, 8, 1, 1, 8, 1]);
  await update(page, 'Use A');
  await expectNodes(page, 'A');
  await expectComputes(page, 4);
});
