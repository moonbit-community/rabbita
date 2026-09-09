import { expect, test, type Locator, type Page } from '@playwright/test';

async function expectComputes(page: Page, expected: number) {
  const reading = page.locator('#count-shared_keyed-reading');
  const previous = Number(await reading.innerText());
  await page.getByRole('button', { name: 'Read shared_keyed count', exact: true }).click();
  await expect(reading).toHaveText(String(previous + 1));
  await expect(page.locator('#count-shared_keyed')).toHaveText(String(expected));
}

async function expectBoundaries(stage: Locator, count: number) {
  await expect.poll(() => stage.evaluate((element) => Array.from(element.childNodes)
    .filter((node) => node.nodeType === Node.COMMENT_NODE)
    .map((node) => node.nodeValue))).toEqual(Array.from({ length: count }, () => ['[', ']']).flat());
}

test('shared keyed nodes skip diff but still relocate, including empty fragments and aliased VNodes', async ({ page }) => {
  await page.goto('/?physical-keyed');
  const stage = page.locator('#shared-stage');
  await expect(stage).toHaveText('shared textfragmentthunkafter');
  await expectComputes(page, 1);
  const original = await stage.evaluateHandle((element) => Array.from(element.childNodes));
  const drafts = ['Element draft', 'Fragment draft', 'Thunk draft'];
  for (const draft of drafts) await page.getByPlaceholder(draft, { exact: true }).fill(draft);
  const aliases = page.getByPlaceholder('Shared alias draft', { exact: true });
  await aliases.nth(0).fill('alias a');
  await aliases.nth(1).fill('alias b');
  await stage.evaluate((element: HTMLElement) => {
    element.dataset.inserts = '0';
    element.dataset.styleReads = '0';
    const insertBefore = element.insertBefore;
    element.insertBefore = function <T extends Node>(node: T, anchor: Node | null): T {
      element.dataset.inserts = String(Number(element.dataset.inserts) + 1);
      return insertBefore.call(this, node, anchor) as T;
    };
    for (const child of element.querySelectorAll<HTMLElement>('#shared-element, #shared-fragment, #shared-thunk, .shared-alias')) {
      const style = child.style;
      Object.defineProperty(child, 'style', {
        configurable: true,
        get() {
          element.dataset.styleReads = String(Number(element.dataset.styleReads) + 1);
          return style;
        },
      });
    }
  });

  await page.getByRole('button', { name: 'Refresh shared rows', exact: true }).click();
  await expect(page.locator('#shared-tick')).toHaveText('1');
  await expect(stage).toHaveAttribute('data-inserts', '0');
  await expect(stage).toHaveAttribute('data-style-reads', '0');

  for (const reversed of [true, false]) {
    await page.getByRole('button', { name: 'Reverse shared rows', exact: true }).click();
    await expect(stage).toHaveText(reversed ? 'thunkfragmentshared textafter' : 'shared textfragmentthunkafter');
    await expectBoundaries(stage, 3);
    expect(await stage.evaluate((element, nodes) => nodes.every((node) => node.parentNode === element), original)).toBe(true);
    for (const draft of drafts) await expect(page.getByPlaceholder(draft, { exact: true })).toHaveValue(draft);
    await expect(aliases.nth(0)).toHaveValue(reversed ? 'alias b' : 'alias a');
    await expect(aliases.nth(1)).toHaveValue(reversed ? 'alias a' : 'alias b');
    await expect(stage).toHaveAttribute('data-style-reads', '0');
    await expectComputes(page, 1);
  }
  expect(await stage.evaluate((element, nodes) => nodes.every((node, index) => element.childNodes[index] === node), original)).toBe(true);
  expect(Number(await stage.getAttribute('data-inserts'))).toBeGreaterThan(0);

  await page.getByRole('button', { name: 'Toggle shared tail', exact: true }).click();
  await expect(page.locator('#shared-after')).toHaveCount(0);
  await page.getByRole('button', { name: 'Reverse shared rows', exact: true }).click();
  await expect(stage).toHaveText('thunkfragmentshared text');
  await expectBoundaries(stage, 3);
  await expect(page.getByPlaceholder('Element draft', { exact: true })).toHaveValue('Element draft');
});

test('removing and remounting shared keyed ranges keeps surviving nodes and creates fresh DOM', async ({ page }) => {
  await page.goto('/?physical-keyed');
  const stage = page.locator('#shared-stage');
  await expectBoundaries(stage, 3);
  const ranges = await stage.evaluateHandle((element) => Array.from(element.childNodes).filter((node) =>
    node.nodeType === Node.COMMENT_NODE || (node instanceof HTMLElement &&
      (node.id === 'shared-fragment' || node.id === 'shared-thunk' || ['Fragment draft', 'Thunk draft'].includes(node.getAttribute('placeholder') ?? '')))));
  const survivor = page.getByPlaceholder('Element draft', { exact: true });
  const original = await survivor.elementHandle();
  await survivor.fill('survives');
  await page.getByPlaceholder('Fragment draft', { exact: true }).fill('removed draft');
  await expectComputes(page, 1);

  await page.getByRole('button', { name: 'Toggle shared ranges', exact: true }).click();
  await expect(stage).toHaveText('shared textafter');
  await expectBoundaries(stage, 0);
  expect(await ranges.evaluate((nodes) => nodes.every((node) => !node.isConnected))).toBe(true);
  await page.getByRole('button', { name: 'Toggle shared ranges', exact: true }).click();
  await expect(stage).toHaveText('shared textfragmentthunkafter');
  await expectBoundaries(stage, 3);
  expect(await ranges.evaluate((nodes) => nodes.every((node) => !node.isConnected))).toBe(true);
  await expect(page.getByPlaceholder('Fragment draft', { exact: true })).toHaveValue('');
  await expect(page.getByPlaceholder('Thunk draft', { exact: true })).toHaveValue('');
  await expect(survivor).toHaveValue('survives');
  expect(await survivor.evaluate((node, saved) => node === saved, original)).toBe(true);
  await expectComputes(page, 2);
});
