import { expect, test } from '@playwright/test';

const booleanProperties = [
  ['optional-button', 'disabled'],
  ['optional-checkbox', 'checked'],
  ['optional-input', 'required'],
  ['optional-multiple', 'multiple'],
  ['optional-hidden', 'hidden'],
  ['optional-video', 'controls'],
  ['optional-video', 'autoplay'],
  ['optional-video', 'loop'],
  ['optional-video', 'muted'],
] as const;

for (const [id, property] of booleanProperties) {
  test(`${property} resets when omitted and can be added again`, async ({ page }) => {
    await page.goto('/');
    const target = page.locator(`#${id}`);
    const original = await target.elementHandle();
    await expect(target).toHaveJSProperty(property, true);
    // These must exercise native prototype setters, not deletable own fields.
    expect(await target.evaluate((node, key) => Object.hasOwn(node, key), property)).toBe(false);

    await page.getByRole('button', { name: 'Omit properties', exact: true }).click();
    await expect(target).toHaveJSProperty(property, false);
    expect(await target.evaluate((node, previous) => node === previous, original)).toBe(true);

    await page.getByRole('button', { name: 'Set updated properties' }).click();
    await expect(target).toHaveJSProperty(property, true);
    await page.getByRole('button', { name: 'Set empty properties' }).click();
    await expect(target).toHaveJSProperty(property, false);
    await page.getByRole('button', { name: 'Omit properties', exact: true }).click();
    await expect(target).toHaveJSProperty(property, false);
    await page.getByRole('button', { name: 'Set initial properties' }).click();
    await expect(target).toHaveJSProperty(property, true);
  });
}

for (const label of ['Optional text', 'Optional textarea', 'Optional selection']) {
  test(`${label} clears its value when omitted without replacing the element`, async ({ page }) => {
    await page.goto('/');
    const target = page.getByLabel(label, { exact: true });
    const original = await target.elementHandle();
    await expect(target).toHaveValue('initial');
    await page.getByRole('button', { name: 'Set updated properties' }).click();
    await expect(target).toHaveValue('updated');

    await page.getByRole('button', { name: 'Omit properties', exact: true }).click();
    await expect(target).toHaveValue('');
    expect(await target.evaluate((node, previous) => node === previous, original)).toBe(true);

    await page.getByRole('button', { name: 'Set initial properties' }).click();
    await expect(target).toHaveValue('initial');
    await page.getByRole('button', { name: 'Set empty properties' }).click();
    await expect(target).toHaveValue('');
    await page.getByRole('button', { name: 'Omit properties', exact: true }).click();
    await expect(target).toHaveValue('');
    await page.getByRole('button', { name: 'Set updated properties' }).click();
    await expect(target).toHaveValue('updated');
  });
}

test('omitted custom properties are assigned empty string or null, retaining their keys', async ({ page }) => {
  await page.goto('/');
  const target = page.locator('#property-probe');
  await expect(target).toHaveJSProperty('value', 'initial');
  await expect(target).toHaveJSProperty('checked', true);
  await page.getByRole('button', { name: 'Omit properties', exact: true }).click();
  await expect(target).toHaveJSProperty('value', '');
  await expect(target).toHaveJSProperty('checked', null);
  expect(await target.evaluate(node => [
    Object.hasOwn(node, 'value'),
    Object.hasOwn(node, 'checked'),
  ])).toEqual([true, true]);

  await page.getByRole('button', { name: 'Set empty properties' }).click();
  await expect(target).toHaveJSProperty('value', '');
  await expect(target).toHaveJSProperty('checked', false);
  await page.getByRole('button', { name: 'Omit properties', exact: true }).click();
  await expect(target).toHaveJSProperty('checked', null);
  await page.getByRole('button', { name: 'Set updated properties' }).click();
  await expect(target).toHaveJSProperty('value', 'updated');
  await expect(target).toHaveJSProperty('checked', true);
});

test('reset values follow the old VNode even if DOM property types have changed', async ({ page }) => {
  await page.goto('/');
  const target = page.locator('#property-probe');
  await expect(target).toHaveJSProperty('value', 'initial');
  await target.evaluate(node => {
    Object.assign(node, { value: 42, checked: 'external value' });
  });
  await page.getByRole('button', { name: 'Omit properties', exact: true }).click();
  await expect(target).toHaveJSProperty('value', '');
  await expect(target).toHaveJSProperty('checked', null);
});

test('continued omission preserves user edits and leaves other properties alone', async ({ page }) => {
  await page.goto('/');
  await page.getByRole('button', { name: 'Omit properties', exact: true }).click();
  const text = page.getByLabel('Optional text', { exact: true });
  const checkbox = page.getByLabel('Optional checkbox', { exact: true });
  await expect(text).toHaveValue('');
  await expect(checkbox).not.toBeChecked();
  await text.fill('user text');
  await checkbox.check();
  await page.getByRole('button', { name: 'Rerender properties' }).click();
  await expect(page.locator('#property-revision')).toHaveText('revision: 1');
  await expect(text).toHaveValue('user text');
  await expect(checkbox).toBeChecked();
  await expect(page.getByLabel('Name', { exact: true })).toHaveValue('initial');
  await expect(page.getByRole('button', { name: 'Controlled button', exact: true })).toBeEnabled();

  await page.getByRole('button', { name: 'Set updated properties' }).click();
  await expect(text).toHaveValue('updated');
  await page.getByRole('button', { name: 'Omit properties', exact: true }).click();
  await expect(text).toHaveValue('');
  await expect(checkbox).not.toBeChecked();
});
