import { expect, test } from '@playwright/test';

test('three-panel resizable group updates adjacent panels and preserves the third', async ({ page }) => {
  await page.goto('/');

  const section = page.locator('#fixture-section-resizable-group');
  const root = section.locator('#fixture-resizable-group');
  const first = section.getByRole('slider', { name: 'Resize files and editor' });
  const second = section.getByRole('slider', { name: 'Resize editor and preview' });

  await expect(root).toHaveAttribute('data-sizes', '26,44,30');
  await first.focus();
  await first.press('Home');
  await expect(root).toHaveAttribute('data-sizes', '16,54,30');
  await expect(section.locator('#fixture-resizable-group-output')).toHaveText('16,54,30');

  await second.focus();
  await second.press('End');
  await expect(root).toHaveAttribute('data-sizes', '16,66,18');
  await second.press('ArrowDown');
  await expect(root).toHaveAttribute('data-sizes', '16,66,18');
});

test('resizable pointer drag changes real panel geometry and emits sizes', async ({ page }) => {
  await page.goto('/');

  const section = page.locator('#fixture-section-resizable-group');
  const handle = section.locator('[data-slot="resizable-handle"][data-between="0"]');
  const files = section.locator('#fixture-resizable-files');
  const before = await files.boundingBox();
  const handleBox = await handle.boundingBox();
  if (!before || !handleBox) throw new Error('resizable fixture has no layout box');

  await page.mouse.move(handleBox.x, handleBox.y + handleBox.height / 2);
  await page.mouse.down();
  await page.mouse.move(handleBox.x + 70, handleBox.y + handleBox.height / 2);
  await page.mouse.up();

  const after = await files.boundingBox();
  if (!after) throw new Error('resizable panel disappeared after drag');
  expect(after.width).toBeGreaterThan(before.width + 40);
  await expect(section.locator('#fixture-resizable-group-output')).not.toHaveText(
    '26,44,30',
  );
});

test('managed scroll areas expose measured scrollbars and respond to keyboard scrolling', async ({ page }) => {
  await page.goto('/');

  const vertical = page.locator('#fixture-scroll-area');
  const verticalViewport = page.locator('#fixture-scroll-area-viewport');
  const horizontal = page.locator('#fixture-scroll-area-horizontal');
  const horizontalViewport = page.locator('#fixture-scroll-area-horizontal-viewport');

  await expect(vertical).toHaveAttribute('data-scrollable', 'true');
  await expect(horizontal).toHaveAttribute('data-scrollable', 'true');
  await expect(vertical.locator('[data-slot="scroll-area-scrollbar"]')).toHaveAttribute(
    'data-orientation',
    'vertical',
  );
  await verticalViewport.focus();
  await verticalViewport.press('End');
  await expect(verticalViewport).not.toHaveAttribute('data-scroll-offset', '0');

  await horizontalViewport.focus();
  await horizontalViewport.press('ArrowRight');
  await expect(horizontalViewport).not.toHaveAttribute('data-scroll-offset', '0');
});
