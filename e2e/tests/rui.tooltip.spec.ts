import { expect, test } from '@playwright/test';

test('tooltip opens on hover and closes when the pointer leaves', async ({ page }) => {
  await page.goto('/');

  const trigger = page.getByRole('button', { name: 'Hover for tooltip' });
  const tooltip = page.getByRole('tooltip', { name: 'Tooltip body content' });

  await expect(tooltip).toBeHidden();
  await trigger.hover();
  await expect(tooltip).toBeVisible();

  await page.getByRole('heading', { level: 1 }).hover();
  await expect(tooltip).toBeHidden();
});

test('tooltip visibility follows hover, without focus or dismissal state', async ({ page }) => {
  await page.goto('/');
  const trigger = page.getByRole('button', { name: 'Hover for tooltip' });
  const tooltip = page.getByRole('tooltip', { name: 'Tooltip body content' });
  await page.keyboard.press('Tab');
  await expect(trigger).toBeFocused();
  await expect(tooltip).toBeHidden();
  await trigger.hover();
  await expect(tooltip).toBeVisible();
  await trigger.click();
  await page.keyboard.press('Escape');
  await expect(tooltip).toBeVisible();
  await page.mouse.move(0, 0);
  await expect(trigger).toBeFocused();
  await expect(tooltip).toBeHidden();
});

test('hover card opens on trigger hover and closes after leaving', async ({ page }) => {
  await page.goto('/');

  const trigger = page.getByText('Hover profile', { exact: true });
  const body = page.getByText('Native MoonBit components with incremental state.');

  await expect(body).toBeHidden();
  await trigger.hover();
  await expect(body).toBeVisible();

  await body.hover();
  await expect(body).toBeVisible();

  await page.getByRole('heading', { level: 1 }).hover();
  await expect(body).toBeHidden();
});

test('tooltip HTML can mount late and survive repeated DOM replacement', async ({ page }) => {
  await page.goto('/');
  // The former initialization-time binder stopped after 60 animation frames.
  await page.evaluate(async () => {
    for (let frame = 0; frame < 75; frame++) {
      await new Promise<void>(resolve => requestAnimationFrame(() => resolve()));
    }
  });
  const tip = page.getByRole('tooltip', { name: 'Late tooltip content', exact: true });
  for (let cycle = 0; cycle < 3; cycle++) {
    await page.getByRole('button', { name: 'Mount tooltip', exact: true }).click();
    await page.getByRole('button', { name: 'Late tooltip trigger', exact: true }).hover();
    await expect(tip).toBeVisible();
    await page.getByRole('button', { name: 'Unmount tooltip', exact: true }).click();
    await expect(tip).toHaveCount(0);
  }
});

test('provider delay and disabled trigger work with CSS only', async ({ page }) => {
  await page.goto('/');
  const trigger = page.getByRole('button', { name: 'Provider trigger', exact: true });
  const tip = page.getByRole('tooltip', { name: 'Provider content', exact: true });
  await trigger.hover();
  await expect(tip).toBeVisible();
  await expect(tip).toHaveCSS('animation-delay', '0.16s');
  await expect(tip).toHaveCSS('pointer-events', 'none');
  await page.mouse.move(0, 0);
  await expect(tip).toBeHidden();
  await page.getByRole('button', { name: 'Disabled trigger' }).hover({ force: true });
  await expect(page.getByRole('tooltip', { name: 'Disabled content' })).toBeHidden();
});

test('hover and leave still work when JavaScript is disabled', async ({ page, browser }) => {
  await page.goto('/');
  const markup = await page.locator('#fixture-theme').evaluate(element => element.outerHTML);
  const css = await page.locator('style[data-rui-style="interactions"]').textContent();
  const context = await browser.newContext({ javaScriptEnabled: false });
  try {
    const staticPage = await context.newPage();
    await staticPage.setContent(`<style>${css}</style>${markup}`);
    const trigger = staticPage.getByRole('button', { name: 'Hover for tooltip' });
    const tip = staticPage.getByRole('tooltip', { name: 'Tooltip body content' });
    await expect(tip).toBeHidden();
    await trigger.hover();
    await expect(tip).toBeVisible();
    await staticPage.mouse.move(0, 0);
    await expect(tip).toBeHidden();
    await staticPage.keyboard.press('Tab');
    await expect(trigger).toBeFocused();
    await expect(tip).toBeHidden();
    await trigger.hover();
    await expect(tip).toBeVisible();
    await staticPage.mouse.move(0, 0);
    await expect(tip).toBeHidden();
  } finally {
    await context.close();
  }
});

test('tooltip animates in and out and keeps its arrow visible', async ({ page }) => {
  await page.goto('/');
  const trigger = page.locator('#fixture-tooltip-trigger');
  const tip = page.locator('#fixture-tooltip');
  const sample = async (progress: number) => tip.evaluate((element, progress) => {
    const animation = element.getAnimations().find(animation => animation instanceof CSSAnimation)!;
    animation.pause();
    const { delay, duration } = animation.effect!.getTiming();
    animation.currentTime = Number(delay) + Number(duration) * progress;
    const style = getComputedStyle(element);
    const matrix = new DOMMatrixReadOnly(style.transform);
    return { opacity: Number(style.opacity), scale: matrix.a, y: matrix.f, name: style.animationName };
  }, progress);
  await expect(tip).toBeHidden();
  await trigger.hover();
  const start = await sample(0);
  const middle = await sample(0.5);
  const end = await sample(1);
  expect(start.name).toBe('rui-tooltip-in');
  expect(start.opacity).toBe(0);
  expect(start.scale).toBeCloseTo(0.95);
  expect(start.y).toBeCloseTo(8);
  expect(middle.opacity).toBeGreaterThan(0);
  expect(middle.opacity).toBeLessThan(1);
  expect(end.opacity).toBe(1);
  expect(end.scale).toBe(1);
  expect(end.y).toBe(0);
  await expect(tip).toBeVisible();
  const arrow = tip.locator('[data-slot="tooltip-arrow"]');
  await expect(arrow).toBeVisible();
  await expect(tip).toHaveCSS('overflow', 'visible');
  const contentBox = (await tip.boundingBox())!;
  const arrowBox = (await arrow.boundingBox())!;
  expect(arrowBox.y + arrowBox.height).toBeGreaterThan(contentBox.y + contentBox.height);
  await page.mouse.move(0, 0);
  const exit = await sample(0.5);
  await expect(tip).toBeVisible();
  expect(exit.name).toBe('rui-tooltip-out');
  expect(exit.opacity).toBeGreaterThan(0);
  expect(exit.opacity).toBeLessThan(1);
  expect(exit.scale).toBeGreaterThan(0.95);
  expect(exit.scale).toBeLessThan(1);
  await expect(tip).toBeHidden();
});

test('reduced motion disables tooltip animations', async ({ page }) => {
  await page.emulateMedia({ reducedMotion: 'reduce' });
  await page.goto('/');
  const tip = page.locator('#fixture-tooltip');
  await page.locator('#fixture-tooltip-trigger').hover();
  await expect(tip).toBeVisible();
  await expect(tip).toHaveCSS('animation-name', 'none');
  await page.mouse.move(0, 0);
  await expect(tip).toBeHidden();
});

for (const fallback of [false, true]) {
  test(`tooltip side and alignment use ${fallback ? 'absolute fallback' : 'CSS anchors'}`, async ({ page }) => {
    await page.goto('/');
    if (fallback) {
      // Exercise the stylesheet path used by browsers without CSS anchors.
      await page.locator('style[data-rui-style="interactions"]').evaluate(element => {
        const sheet = (element as HTMLStyleElement).sheet!;
        for (const rule of sheet.cssRules) {
          if (rule instanceof CSSGroupingRule) {
            for (let i = rule.cssRules.length - 1; i >= 0; i--) {
              const child = rule.cssRules[i];
              if (child instanceof CSSSupportsRule && child.conditionText.includes('anchor(top)')) {
                rule.deleteRule(i);
              }
            }
          }
        }
      });
    }
    for (const side of ['top', 'right', 'bottom', 'left']) {
      const trigger = page.locator(`#fixture-tip-${side}-trigger`);
      const tip = page.locator(`#fixture-tip-${side}`);
      await trigger.hover();
      await expect(tip).toBeVisible();
      await expect(tip).toHaveCSS('opacity', '1');
      const a = (await trigger.boundingBox())!;
      const b = (await tip.boundingBox())!;
      if (side === 'top') {
        expect(b.y + b.height).toBeCloseTo(a.y - 4, 0);
        expect(b.x).toBeCloseTo(a.x, 0);
      } else if (side === 'bottom') {
        expect(b.y).toBeCloseTo(a.y + a.height + 4, 0);
        expect(b.x + b.width).toBeCloseTo(a.x + a.width, 0);
      } else {
        expect(b.y + b.height / 2).toBeCloseTo(a.y + a.height / 2, 0);
        if (side === 'right') expect(b.x).toBeCloseTo(a.x + a.width + 4, 0);
        else expect(b.x + b.width).toBeCloseTo(a.x - 4, 0);
      }
      await page.mouse.move(0, 0);
      await expect(tip).toBeHidden();
    }
  });
}
