import { expect, test } from '@playwright/test';

test('carousel exposes slides and the active one is marked', async ({ page }) => {
  await page.goto('/');

  const carousel = page.getByRole('region', { name: 'Fixture carousel' });
  const first = carousel.getByRole('group', { name: 'Slide 1 of 3' });
  const second = carousel.getByRole('group', { name: 'Slide 2 of 3', includeHidden: true });
  const third = carousel.getByRole('group', { name: 'Slide 3 of 3', includeHidden: true });

  await expect(first).toHaveAttribute('aria-current', 'true');
  await expect(second).not.toHaveAttribute('aria-current', 'true');
  await expect(third).not.toHaveAttribute('aria-current', 'true');
});

test('carousel next and previous buttons step through slides', async ({ page }) => {
  await page.goto('/');

  const carousel = page.getByRole('region', { name: 'Fixture carousel' });
  const next = carousel.getByRole('button', { name: 'Next slide' });
  const previous = carousel.getByRole('button', { name: 'Previous slide' });
  const first = carousel.getByRole('group', { name: 'Slide 1 of 3' });
  const second = carousel.getByRole('group', { name: 'Slide 2 of 3' });
  const third = carousel.getByRole('group', { name: 'Slide 3 of 3' });

  await next.click();
  await expect(second).toHaveAttribute('aria-current', 'true');

  await next.click();
  await expect(third).toHaveAttribute('aria-current', 'true');

  await previous.click();
  await expect(second).toHaveAttribute('aria-current', 'true');
});

test('carousel loop wraps in both directions', async ({ page }) => {
  await page.goto('/');

  const carousel = page.getByRole('region', { name: 'Fixture carousel' });
  const next = carousel.getByRole('button', { name: 'Next slide' });
  const previous = carousel.getByRole('button', { name: 'Previous slide' });
  const first = carousel.getByRole('group', { name: 'Slide 1 of 3' });
  const third = carousel.getByRole('group', { name: 'Slide 3 of 3' });

  await next.click();
  await next.click();
  await expect(third).toHaveAttribute('aria-current', 'true');
  await next.click();
  await expect(first).toHaveAttribute('aria-current', 'true');

  await previous.click();
  await expect(third).toHaveAttribute('aria-current', 'true');
});

test('bounded carousel disables controls at both ends and handles arrow keys', async ({ page }) => {
  await page.goto('/');

  const section = page.locator('#fixture-section-carousel-non-loop');
  const carousel = section.getByRole('region', { name: 'Fixture bounded carousel' });
  const previous = section.getByRole('button', { name: 'Previous slide' });
  const next = section.getByRole('button', { name: 'Next slide' });
  const output = section.locator('#fixture-carousel-non-loop-output');

  await expect(previous).toBeDisabled();
  await expect(next).toBeEnabled();
  await next.focus();
  await next.press('ArrowRight');
  await expect(output).toHaveText('index:1');
  await next.press('ArrowRight');
  await expect(output).toHaveText('index:2');
  await expect(next).toBeDisabled();
  await expect(section.locator('#fixture-carousel-non-loop')).toHaveAttribute(
    'data-active-index',
    '2',
  );
});

test('bounded carousel responds to a real pointer swipe', async ({ page }) => {
  await page.goto('/');

  const section = page.locator('#fixture-section-carousel-non-loop');
  const viewport = section.locator('[data-slot="carousel-content"]');
  await viewport.scrollIntoViewIfNeeded();
  const box = await viewport.boundingBox();
  if (!box) throw new Error('carousel viewport has no layout box');

  const y = box.y + box.height / 2;
  await page.mouse.move(box.x + box.width * 0.8, y);
  await page.mouse.down();
  await page.mouse.move(box.x + box.width * 0.2, y, { steps: 6 });
  await page.mouse.up();

  await expect(section.locator('#fixture-carousel-non-loop-output')).toHaveText('index:1');
  await expect(section.getByRole('group', { name: 'Slide 2 of 3' })).toHaveAttribute(
    'aria-current',
    'true',
  );
});
