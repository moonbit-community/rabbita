import { expect, test } from '@playwright/test';

const preview = '.rui-showcase-demo-preview';

test('sidebar examples expose one main toggle and keep fixed variants persistent', async ({ page }) => {
  await page.goto('/components/sidebar/');
  const examples = page.locator(preview);
  await expect(examples).toHaveCount(9);
  for (let index = 0; index < 8; index++) {
    const example = examples.nth(index);
    const toggle = example.locator('[data-slot="sidebar-trigger"]');
    await expect(example.getByRole('button', { name: 'Collapse sidebar', exact: true })).toHaveCount(0);
    if (index === 1 || index === 3) {
      await expect(toggle).toHaveCount(0);
      continue;
    }
    await expect(toggle).toHaveCount(1);
    const expanded = await toggle.getAttribute('aria-expanded');
    await toggle.click();
    await expect(toggle).toHaveAttribute('aria-expanded', expanded === 'true' ? 'false' : 'true');
    await toggle.click();
    await expect(toggle).toHaveAttribute('aria-expanded', expanded!);
  }
  const mobile = examples.nth(8);
  const open = mobile.getByRole('button', { name: 'Open mobile sidebar', exact: true });
  await open.click();
  const close = page.getByRole('button', { name: 'Close mobile sidebar', exact: true });
  await expect(close).toHaveCount(1);
  await close.click();
  await expect(close).toBeHidden();
  await expect(open).toBeFocused();
});

test('demo links ignore pointer and keyboard navigation while catalog links still work', async ({ page, context }) => {
  await page.goto('/components/sidebar/');
  const url = page.url();
  const overview = page.locator(preview).first().getByRole('link', { name: 'Overview', exact: true });
  const navigations: string[] = [];
  page.on('framenavigated', frame => {
    if (frame === page.mainFrame()) navigations.push(frame.url());
  });
  await overview.click();
  await overview.focus();
  await overview.press('Enter');
  await overview.click({ modifiers: ['ControlOrMeta'] });
  await overview.click({ button: 'middle' });
  await expect(page).toHaveURL(url);
  expect(navigations).toEqual([]);
  expect(context.pages()).toHaveLength(1);

  const catalog = page.locator('.rui-showcase-catalog-link, .rui-showcase-rail-link')
    .filter({ hasText: /^Button$/ }).filter({ visible: true }).first();
  await catalog.click();
  await expect(page).toHaveURL(/\/components\/button\/?$/);
});

test('breadcrumb, pagination and popup demo links do not change the page', async ({ page }) => {
  for (const component of ['breadcrumb', 'pagination', 'navigation-menu']) {
    await page.goto(`/components/${component}/`);
    const url = page.url();
    if (component === 'navigation-menu') {
      await page.getByRole('button', { name: 'Platform', exact: true }).hover();
    }
    const links = page.locator(`${preview} a[href]`).filter({ visible: true });
    await links.first().click();
    await expect(page).toHaveURL(url);
  }
});
