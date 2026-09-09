import { expect, test, type Page } from '@playwright/test';

type Shape = 'fragment' | 'element' | 'empty' | 'text';

async function expectKeyedCount(page: Page, expected: number) {
  const reading = page.locator('#count-keyed-reading');
  const previous = Number(await reading.innerText());
  await page.getByRole('button', { name: 'Read keyed count', exact: true }).click();
  await expect(reading).toHaveText(String(previous + 1));
  await expect(page.locator('#count-keyed')).toHaveText(String(expected));
}

async function expectRows(page: Page, order: string[], shape: Shape = 'fragment', value = 1) {
  const ids = ['keyed-before'];
  let text = 'before|';
  for (const key of order) {
    const rowShape = key === 'a' ? shape : 'fragment';
    const rowValue = key === 'a' ? value : 1;
    if (rowShape === 'empty') continue;
    if (rowShape === 'text') {
      text += `${key} text ${rowValue}`;
      continue;
    }
    text += `${key}:${rowValue}Pick keyed ${key} ${rowValue}`;
    ids.push(...(rowShape === 'element'
      ? [`keyed-${key}-element`]
      : [`keyed-${key}-label`, `keyed-${key}-draft`, `keyed-${key}-pick`]));
  }
  ids.push('keyed-after');
  const stage = page.locator('#keyed-stage');
  await expect(stage).toHaveText(`${text}|after`);
  await expect.poll(() => stage.locator(':scope > [id]').evaluateAll(
    (nodes) => nodes.map(({ id }) => id),
  )).toEqual(ids);
}

async function expectFragmentBoundaries(page: Page, count: number) {
  await expect.poll(() => page.locator('#keyed-stage').evaluate((stage) =>
    Array.from(stage.childNodes)
      .filter((node) => node.nodeType === Node.COMMENT_NODE)
      .map((node) => node.nodeValue),
  )).toEqual(Array.from({ length: count }, () => ['[', ']']).flat());
}

test('keyed memo fragments retain nodes and drafts during moves and remount after deletion', async ({ page }) => {
  await page.goto('/');
  await expectRows(page, ['a', 'b', 'c']);
  const draft = page.getByPlaceholder('Keyed draft a');
  await draft.fill('draft a');
  const original = await draft.elementHandle();
  const sibling = page.getByPlaceholder('Keyed draft b');
  await sibling.fill('draft b');
  const originalSibling = await sibling.elementHandle();
  await expectKeyedCount(page, 3);

  for (const order of [['c', 'b', 'a'], ['a', 'b', 'c']]) {
    await page.getByRole('button', { name: 'Reverse keyed rows', exact: true }).click();
    await expectRows(page, order);
    await expectFragmentBoundaries(page, 3);
    await expect(draft).toHaveValue('draft a');
    expect(await draft.evaluate((node, original) => node === original, original)).toBe(true);
    await expectKeyedCount(page, 3);
  }

  await page.getByRole('button', { name: 'Remove keyed a', exact: true }).click();
  await expectRows(page, ['b', 'c']);
  expect(await original!.evaluate((node) => node.isConnected)).toBe(false);
  await page.getByRole('button', { name: 'Add keyed a', exact: true }).click();
  await expectRows(page, ['a', 'b', 'c']);
  await expect(draft).toHaveValue('');
  await expectKeyedCount(page, 4);
  await page.getByRole('button', { name: 'Pick keyed a 1', exact: true }).click();
  await expect(page.locator('#keyed-selected')).toHaveText('a:1');
  await page.getByRole('button', { name: 'Update keyed a', exact: true }).click();
  await expectRows(page, ['a', 'b', 'c'], 'fragment', 2);
  await page.getByRole('button', { name: 'Pick keyed a 2', exact: true }).click();
  await expect(page.locator('#keyed-selected')).toHaveText('a:2');
  await expectKeyedCount(page, 5);
  await expect(sibling).toHaveValue('draft b');
  expect(await sibling.evaluate((node, original) => node === original, originalSibling)).toBe(true);
});

test('keyed memo can move and change between element, fragment, empty, and text in one update', async ({ page }) => {
  await page.goto('/');
  await expectRows(page, ['a', 'b', 'c']);
  const shapes: Shape[] = ['element', 'fragment', 'empty', 'text', 'element'];
  for (const [index, shape] of shapes.entries()) {
    await page.getByRole('button', { name: `Move keyed a as ${shape}`, exact: true }).click();
    await expectRows(page, index % 2 === 0 ? ['c', 'b', 'a'] : ['a', 'b', 'c'], shape, index + 2);
    await expectFragmentBoundaries(page, shape === 'fragment' || shape === 'empty' ? 3 : 2);
    await expectKeyedCount(page, index + 4);
  }
  await page.getByRole('button', { name: 'Pick keyed a 6', exact: true }).click();
  await expect(page.locator('#keyed-selected')).toHaveText('a:6');
});

test('empty keyed memo keeps its start and end boundaries through moves, expansion, and removal', async ({ page }) => {
  await page.goto('/');
  await page.getByRole('button', { name: 'Clear keyed a', exact: true }).click();
  await expectRows(page, ['a', 'b', 'c'], 'empty');
  await expectFragmentBoundaries(page, 3);

  for (const order of [['c', 'b', 'a'], ['a', 'b', 'c']]) {
    await page.getByRole('button', { name: 'Reverse keyed rows', exact: true }).click();
    await expectRows(page, order, 'empty');
    await expectFragmentBoundaries(page, 3);
  }

  await page.getByRole('button', { name: 'Move keyed a as fragment', exact: true }).click();
  await expectRows(page, ['c', 'b', 'a'], 'fragment', 3);
  await expectFragmentBoundaries(page, 3);
  await page.getByRole('button', { name: 'Clear keyed a', exact: true }).click();
  await expectRows(page, ['c', 'b', 'a'], 'empty');
  await page.getByRole('button', { name: 'Reverse keyed rows', exact: true }).click();
  await expectRows(page, ['a', 'b', 'c'], 'empty');
  await expectFragmentBoundaries(page, 3);
  await page.getByRole('button', { name: 'Remove keyed a', exact: true }).click();
  await expectRows(page, ['b', 'c']);
  await expectFragmentBoundaries(page, 2);
});
