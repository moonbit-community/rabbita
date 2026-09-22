import { expect, test, type Page } from '@playwright/test';

async function openDrawer(page: Page, direction = 'right') {
  await page.getByRole('button', { name: `Open ${direction} drawer` }).click();
  const drawer = page.locator(`#fixture-drawer-${direction}`);
  await expect(drawer).toBeVisible();
  await expect(drawer).toHaveCSS('transform', 'matrix(1, 0, 0, 1, 0, 0)');
  return drawer;
}

test('native drawer contains focus and restores it on Escape', async ({ page }) => {
  await page.goto('/');
  const trigger = page.getByRole('button', { name: 'Open right drawer' });
  await expect(page.locator('dialog')).toHaveCount(6);
  for (const drawer of await page.locator('dialog').all()) {
    await expect(drawer).toBeHidden();
  }

  const drawer = await openDrawer(page);
  await expect(drawer).toHaveAccessibleName('right drawer');
  await expect(drawer).toHaveAccessibleDescription(
    'Drag beside the drawer to dismiss, or close the drawer below.',
  );
  expect(await drawer.evaluate((el) => el.matches(':modal'))).toBe(true);
  const close = drawer.getByRole('button', { name: 'Close drawer', exact: true });
  await expect(drawer.getByRole('button')).toHaveCount(1);
  await expect(close).toBeFocused();
  await page.keyboard.press('Tab');
  // Native modal dialogs may yield one tab stop to browser chrome.
  await expect(page.locator(':focus')).toHaveCount(0);
  await page.keyboard.press('Tab');
  await expect(close).toBeFocused();

  await page.keyboard.press('Escape');
  await expect(drawer).toBeHidden();
  await expect(trigger).toBeFocused();
});

test('native forms return values and the backdrop also dismisses', async ({ page }) => {
  await page.goto('/');
  const drawer = await openDrawer(page);
  await drawer.getByRole('button', { name: 'Close drawer', exact: true }).click();
  await expect(drawer).toBeHidden();
  await expect(drawer).toHaveJSProperty('returnValue', 'saved');

  await openDrawer(page);
  await page.mouse.click(5, 5);
  await expect(drawer).toBeHidden();
});

for (const direction of ['top', 'right', 'bottom', 'left']) {
  test(`${direction} drawer has a floating panel and an outside swipe area`, async ({ page }) => {
    await page.goto('/');
    const drawer = await openDrawer(page, direction);
    await expect(drawer).toHaveCSS('border-radius', '10px');
    await expect(drawer.locator('[data-slot="drawer-title"]')).toHaveCSS('font-size', '16px');
    await expect(drawer.locator('[data-slot="drawer-title"]')).toHaveCSS('line-height', '24px');
    await expect(drawer.locator('[data-slot="drawer-description"]')).toHaveCSS('line-height', '20px');
    const overlayStyle = await drawer.evaluate((el) => {
      const style = getComputedStyle(el, '::backdrop');
      return { background: style.backgroundColor, blur: style.backdropFilter };
    });
    expect(overlayStyle).toEqual({ background: 'rgba(0, 0, 0, 0.3)', blur: 'blur(8px)' });
    const area = drawer.locator('[data-slot="drawer-swipe-area"]');
    const geometry = await drawer.evaluate((el) => {
      const box = (selector: string) => el.querySelector(selector)!.getBoundingClientRect().toJSON();
      return {
        drawer: el.getBoundingClientRect().toJSON(),
        area: box('[data-slot="drawer-swipe-area"]'),
        body: box('p:not([data-slot])'),
        close: box('[data-slot="drawer-footer"] button'),
      };
    });
    expect(geometry.close.y - geometry.body.bottom).toBeGreaterThanOrEqual(16);
    expect(geometry.drawer.bottom - geometry.close.bottom).toBeGreaterThanOrEqual(16);
    if (direction === 'left' || direction === 'right') {
      expect(geometry.drawer.width).toBe(384);
      expect(geometry.drawer.height).toBe(704);
      expect(geometry.drawer.y).toBe(8);
      expect(geometry.drawer.bottom).toBe(712);
      expect(direction === 'right' ? 1280 - geometry.drawer.right : geometry.drawer.x).toBe(8);
      expect(geometry.area.height).toBe(720);
      expect(geometry.area.width).toBe(50);
      expect(geometry.area.y).toBe(0);
      expect(geometry.close.bottom).toBeCloseTo(695, 0);
      expect(Math.abs(geometry.area.x - (direction === 'right' ? geometry.drawer.x - 50 : geometry.drawer.right))).toBeLessThanOrEqual(1);
    } else {
      expect(geometry.drawer.width).toBe(1264);
      expect(geometry.drawer.x).toBe(8);
      expect(direction === 'top' ? geometry.drawer.y : 720 - geometry.drawer.bottom).toBe(8);
      expect(geometry.drawer.height).toBeLessThanOrEqual(624);
      expect(geometry.area.width).toBe(1280);
      expect(geometry.area.height).toBe(50);
      expect(geometry.area.x).toBe(0);
      expect(Math.abs(geometry.area.y - (direction === 'top' ? geometry.drawer.bottom : geometry.drawer.y - 50))).toBeLessThanOrEqual(1);
    }

    const start = { x: geometry.area.x + geometry.area.width / 2, y: geometry.area.y + geometry.area.height / 2 };
    const dx = direction === 'right' ? 128 : direction === 'left' ? -128 : 0;
    const dy = direction === 'bottom' ? 90 : direction === 'top' ? -90 : 0;
    await page.mouse.move(start.x, start.y);
    await page.mouse.down();
    await page.mouse.move(start.x + dx, start.y + dy, { steps: 8 });
    await expect(drawer).toHaveAttribute('data-dragging', '');
    const backdrop = await drawer.evaluate((el) => getComputedStyle(el, '::backdrop').opacity);
    expect(Number(backdrop)).toBeLessThan(1);
    await page.mouse.up();
    await expect(drawer).toBeHidden();
    await expect(drawer).not.toHaveAttribute('data-dragging');

    await openDrawer(page, direction);
    await expect(area).toBeVisible();
    await expect(drawer).toHaveCSS('transform', 'matrix(1, 0, 0, 1, 0, 0)');
    expect(await drawer.evaluate((el) => getComputedStyle(el, '::backdrop').opacity)).toBe('1');
  });
}

test('short and reverse drags snap back; native close releases an active gesture', async ({ page }) => {
  await page.goto('/');
  const drawer = await openDrawer(page);
  const area = drawer.locator('[data-slot="drawer-swipe-area"]');
  for (const distance of [12, -80]) {
    const box = (await area.boundingBox())!;
    await page.mouse.move(box.x + box.width / 2, box.y + box.height / 2);
    await page.mouse.down();
    await page.mouse.move(box.x + box.width / 2 + distance, box.y + box.height / 2, { steps: 4 });
    await page.mouse.up();
    await expect(drawer).toHaveJSProperty('open', true);
    await expect(drawer).toHaveCSS('transform', 'matrix(1, 0, 0, 1, 0, 0)');
  }
  const box = (await area.boundingBox())!;
  await page.mouse.move(box.x + box.width / 2, box.y + box.height / 2);
  await page.mouse.down();
  await page.mouse.move(box.x + 45, box.y + box.height / 2);
  await expect(drawer).toHaveAttribute('data-dragging', '');
  await page.keyboard.press('Escape');
  await expect(drawer).toBeHidden();
  await page.mouse.up();
  await openDrawer(page);
  await expect(drawer).not.toHaveAttribute('data-dragging');
  expect(await drawer.evaluate((el) => el.style.getPropertyValue('--rui-drawer-drag-transform'))).toBe('');
});

test('mobile drawers use responsive width and vertical header alignment', async ({ page }) => {
  await page.setViewportSize({ width: 390, height: 844 });
  await page.emulateMedia({ reducedMotion: 'reduce' });
  await page.goto('/');
  for (const direction of ['right', 'bottom']) {
    const drawer = await openDrawer(page, direction);
    const box = (await drawer.boundingBox())!;
    const header = drawer.locator('[data-slot="drawer-header"]');
    await expect(header).toHaveCSS('text-align', direction === 'bottom' ? 'center' : 'left');
    expect(box.width).toBe(direction === 'right' ? 292.5 : 374);
    await expect(drawer).toHaveCSS('transition-duration', '1e-05s');
    await drawer.getByRole('button', { name: 'Close drawer', exact: true }).click();
    await expect(drawer).toBeHidden();
  }
});

test('outside swipe area is opt-in and its width is configurable', async ({ page }) => {
  await page.goto('/');
  const disabled = await openDrawer(page, 'disabled');
  await expect(disabled.locator('[data-slot="drawer-swipe-area"]')).toHaveCount(0);
  await disabled.getByRole('button', { name: 'Close drawer', exact: true }).click();
  await expect(disabled).toBeHidden();

  const wide = await openDrawer(page, 'wide');
  const area = wide.locator('[data-slot="drawer-swipe-area"]');
  await expect(area).toHaveCSS('width', '80px');
  await expect(area).toHaveCSS('height', '720px');
  // The area is outside the panel, including near the top of the viewport.
  const box = (await area.boundingBox())!;
  await page.mouse.move(box.x + 5, 4);
  await page.mouse.down();
  await page.mouse.move(box.x + 145, 4, { steps: 8 });
  await expect(wide).toHaveAttribute('data-dragging', '');
  await page.mouse.up();
  await expect(wide).toBeHidden();

  await openDrawer(page, 'wide');
  await area.click();
  await expect(wide).toBeHidden();
});

test('pointer capture keeps the native grab cursor on the swipe area', async ({ page }) => {
  await page.goto('/');
  const drawer = await openDrawer(page);
  const area = drawer.locator('[data-slot="drawer-swipe-area"]');
  const box = (await area.boundingBox())!;
  const start = { x: box.x + box.width / 2, y: box.y + box.height / 2 };
  await page.mouse.move(start.x, start.y);
  await expect(area).toHaveCSS('cursor', 'grab');
  await page.mouse.down();
  for (const distance of [8, 12, 20, 12]) {
    await page.mouse.move(start.x + distance, start.y);
    await expect(area).toHaveCSS('cursor', 'grabbing');
    expect(await area.evaluate((el) => el.hasPointerCapture(1))).toBe(true);
    expect(await drawer.evaluate((el) => el.hasPointerCapture(1))).toBe(false);
  }
  await page.mouse.up();
  await expect(drawer).toHaveJSProperty('open', true);
  await expect(area).toHaveCSS('cursor', 'grab');
  expect(await area.evaluate((el) => el.hasPointerCapture(1))).toBe(false);
});
