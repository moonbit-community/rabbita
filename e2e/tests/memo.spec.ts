import { expect, test, type Page } from '@playwright/test';

async function expectCount(page: Page, name: string, expected: number) {
  const reading = page.locator(`#count-${name}-reading`);
  const previousReading = Number(await reading.innerText());
  await page.getByRole('button', { name: `Read ${name} count`, exact: true }).click();
  await expect(reading).toHaveText(String(previousReading + 1));
  await expect(page.locator(`#count-${name}`)).toHaveText(String(expected));
}

async function expectShape(page: Page, text: string, ids: string[]) {
  const stage = page.locator('#transition-stage');
  await expect(stage).toHaveText(`before${text}after`);
  await expect
    .poll(() => stage.locator(':scope > [id]').evaluateAll((nodes) => nodes.map(({ id }) => id)))
    .toEqual(['before-shape', ...ids, 'after-shape']);
}

test('memo skips unchanged input and keeps same-hash sibling caches independent', async ({ page }) => {
  await page.goto('/');
  await expect(page.locator('#basic-value')).toHaveText('memo value: 1');
  await expect(page.locator('#sibling-value')).toHaveText('sibling value: 1');
  await expectCount(page, 'basic', 1);
  await expectCount(page, 'sibling', 1);
  await expectCount(page, 'basic_view', 1);

  const draft = page.getByPlaceholder('Memo draft');
  await draft.fill('keep this draft');
  const original = await draft.elementHandle();
  for (let parent = 1; parent <= 3; parent += 1) {
    await page.getByRole('button', { name: 'Update parent', exact: true }).click();
    await expect(page.locator('#parent-version')).toHaveText(`parent: ${parent}`);
    await expectCount(page, 'basic_view', parent + 1);
    await expectCount(page, 'basic', 1);
    await expectCount(page, 'sibling', 1);
  }

  await expect(draft).toHaveValue('keep this draft');
  expect(await draft.evaluate((node, original) => node === original, original)).toBe(true);
  await expect(page.locator('#sibling-value')).toHaveText('sibling value: 1');

  await page.getByRole('button', { name: 'Update memo input', exact: true }).click();
  await expect(page.locator('#basic-value')).toHaveText('memo value: 2');
  await expect(page.locator('#sibling-value')).toHaveText('sibling value: 2');
  await expectCount(page, 'basic', 2);
  await expectCount(page, 'sibling', 2);
});

test('memo updates DOM and event closures when its input changes', async ({ page }) => {
  await page.goto('/');
  await page.getByRole('button', { name: 'Choose memo value', exact: true }).click();
  await expect(page.locator('#selected-value')).toHaveText('selected: 1');
  await expectCount(page, 'basic', 1);

  await page.getByRole('button', { name: 'Update memo input', exact: true }).click();
  await expect(page.locator('#basic-value')).toHaveText('memo value: 2');
  await expectCount(page, 'basic', 2);
  await page.getByRole('button', { name: 'Choose memo value', exact: true }).click();
  await expect(page.locator('#selected-value')).toHaveText('selected: 2');
  await expectCount(page, 'basic', 2);
});

test('memo_by supports an input without Hash and invalidates only with the custom hash', async ({ page }) => {
  await page.goto('/');
  await expect(page.locator('#custom-value')).toHaveText('custom value: 1');
  await expectCount(page, 'custom', 1);
  await expectCount(page, 'custom_view', 1);

  await page.getByRole('button', { name: 'Update ignored field', exact: true }).click();
  await expect(page.locator('#ignored-version')).toHaveText('ignored: 1');
  await expectCount(page, 'custom_view', 2);
  await expect(page.locator('#custom-value')).toHaveText('custom value: 1');
  await expectCount(page, 'custom', 1);
  await page.getByRole('button', { name: 'Choose custom value', exact: true }).click();
  await expect(page.locator('#selected-value')).toHaveText('selected: 1');

  await page.getByRole('button', { name: 'Update memo input', exact: true }).click();
  await expect(page.locator('#custom-value')).toHaveText('custom value: 2');
  await expectCount(page, 'custom', 2);
  await page.getByRole('button', { name: 'Choose custom value', exact: true }).click();
  await expect(page.locator('#selected-value')).toHaveText('selected: 2');
  await expectCount(page, 'custom', 2);
});

test('memo and ordinary elements, text, and fragments replace each other without disturbing siblings', async ({ page }) => {
  await page.goto('/');
  await expectShape(page, 'memo element 1', ['memo-element']);

  const shapes = [
    { button: 'Plain element', text: 'plain element 1', ids: ['plain-element'] },
    { button: 'Memo element', text: 'memo element 1', ids: ['memo-element'] },
    { button: 'Plain text', text: 'plain text 1', ids: [] },
    { button: 'Memo text', text: 'memo text 1', ids: [] },
    { button: 'Plain fragment', text: 'plain first 1plain second 1', ids: ['plain-first', 'plain-second'] },
    { button: 'Memo fragment', text: 'memo first 1Choose fragment value 1', ids: ['memo-first', 'memo-second'] },
    { button: 'Plain element', text: 'plain element 1', ids: ['plain-element'] },
  ];
  for (const shape of shapes) {
    await page.getByRole('button', { name: shape.button, exact: true }).click();
    await expectShape(page, shape.text, shape.ids);
  }
  await expectCount(page, 'shape', 4);
});

test('memo results can change node kind and nest another memo with current event handlers', async ({ page }) => {
  await page.goto('/');
  await expectShape(page, 'memo element 1', ['memo-element']);
  await page.getByRole('button', { name: 'Memo text', exact: true }).click();
  await expectShape(page, 'memo text 1', []);
  await page.getByRole('button', { name: 'Memo fragment', exact: true }).click();
  await expectShape(page, 'memo first 1Choose fragment value 1', ['memo-first', 'memo-second']);
  await page.getByRole('button', { name: 'Nested memo', exact: true }).click();
  await expectShape(page, 'nested first 1Choose nested value 1', ['nested-first', 'nested-second']);
  await expectCount(page, 'shape', 4);
  await expectCount(page, 'nested', 1);
  await expectCount(page, 'lifecycle_view', 4);

  await page.getByRole('button', { name: 'Update parent', exact: true }).click();
  await expect(page.locator('#parent-version')).toHaveText('parent: 1');
  await expectCount(page, 'lifecycle_view', 5);
  await expectCount(page, 'shape', 4);
  await expectCount(page, 'nested', 1);

  await page.getByRole('button', { name: 'Update memo input', exact: true }).click();
  await expectShape(page, 'nested first 2Choose nested value 2', ['nested-first', 'nested-second']);
  await expectCount(page, 'shape', 5);
  await expectCount(page, 'nested', 2);
  await page.getByRole('button', { name: 'Choose nested value 2', exact: true }).click();
  await expect(page.locator('#selected-value')).toHaveText('selected: 2');
  await expectCount(page, 'shape', 5);
  await expectCount(page, 'nested', 2);

  await page.getByRole('button', { name: 'Memo element', exact: true }).click();
  await expectShape(page, 'memo element 2', ['memo-element']);
  await expectCount(page, 'shape', 6);
});

test('invalidating an outer memo retains the inner memo cache until its own input changes', async ({ page }) => {
  await page.goto('/');
  await page.getByRole('button', { name: 'Nested memo', exact: true }).click();
  await expectShape(page, 'nested first 1Choose nested value 1', ['nested-first', 'nested-second']);
  const original = await page.locator('#nested-first').elementHandle();
  await expectCount(page, 'shape', 2);
  await expectCount(page, 'nested', 1);

  for (let revision = 1; revision <= 2; revision += 1) {
    await page.getByRole('button', { name: 'Invalidate outer memo', exact: true }).click();
    await expect(page.locator('#outer-revision')).toHaveText(`outer revision: ${revision}`);
    await expectCount(page, 'shape', 2 + revision);
    await expectCount(page, 'nested', 1);
  }
  expect(await page.locator('#nested-first').evaluate((node, original) => node === original, original)).toBe(true);

  await page.getByRole('button', { name: 'Update memo input', exact: true }).click();
  await expectShape(page, 'nested first 2Choose nested value 2', ['nested-first', 'nested-second']);
  await expectCount(page, 'shape', 5);
  await expectCount(page, 'nested', 2);
  await page.getByRole('button', { name: 'Choose nested value 2', exact: true }).click();
  await expect(page.locator('#selected-value')).toHaveText('selected: 2');
});

for (const shape of [
  { button: 'Memo fragment', prefix: 'memo', label: 'fragment' },
  { button: 'Nested memo', prefix: 'nested', label: 'nested' },
]) {
  test(`${shape.button} removes its entire DOM range and recomputes after remounting`, async ({ page }) => {
    await page.goto('/');
    await page.getByRole('button', { name: shape.button, exact: true }).click();
    const text = (value: number) => `${shape.prefix} first ${value}Choose ${shape.label} value ${value}`;
    const ids = [`${shape.prefix}-first`, `${shape.prefix}-second`];
    await expectShape(page, text(1), ids);
    const original = await page.locator(`#${shape.prefix}-first`).elementHandle();
    await expectCount(page, 'shape', 2);

    await page.getByRole('button', { name: 'Hide memo shape', exact: true }).click();
    await expectShape(page, '', []);
    expect(await original!.evaluate((node) => node.isConnected)).toBe(false);
    await page.getByRole('button', { name: 'Update parent', exact: true }).click();
    await expect(page.locator('#parent-version')).toHaveText('parent: 1');
    await expectCount(page, 'shape', 2);

    await page.getByRole('button', { name: 'Show memo shape', exact: true }).click();
    await expectShape(page, text(1), ids);
    await expectCount(page, 'shape', 3);
    if (shape.label === 'nested') {
      await expectCount(page, 'nested', 2);
    }

    await page.getByRole('button', { name: 'Hide memo shape', exact: true }).click();
    await expectShape(page, '', []);
    await page.getByRole('button', { name: 'Update memo input', exact: true }).click();
    await expect(page.locator('#input-value')).toHaveText('input: 2');
    await expectCount(page, 'shape', 3);
    await page.getByRole('button', { name: 'Show memo shape', exact: true }).click();
    await expectShape(page, text(2), ids);
    await expectCount(page, 'shape', 4);
    await page.getByRole('button', { name: `Choose ${shape.label} value 2`, exact: true }).click();
    await expect(page.locator('#selected-value')).toHaveText('selected: 2');
  });
}
