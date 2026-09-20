import { expect, test } from '@playwright/test';

test('alert, buttons, and attachment expose roles, disabled state, and real actions', async ({ page }) => {
  await page.goto('/');

  const section = page.locator('#fixture-section-semantic-actions');
  const output = section.locator('#fixture-semantic-actions-output');
  const alert = section.getByRole('alert');

  await expect(alert).toContainText('Fixture deployment ready');
  await alert.getByRole('button', { name: 'Acknowledge fixture alert' }).click();
  await expect(output).toHaveText('alert-acknowledged');

  const group = section.getByRole('group', { name: 'Fixture edit actions' });
  await group.getByRole('button', { name: 'Save fixture' }).click();
  await expect(output).toHaveText('saved');
  const disabled = group.getByRole('button', { name: 'Delete fixture' });
  await expect(disabled).toBeDisabled();
  await disabled.press('Enter');
  await expect(output).toHaveText('saved');

  await expect(section.locator('#fixture-attachment')).toHaveAttribute(
    'data-state',
    'uploading',
  );
  await expect(section.getByRole('status', { name: 'Uploading fixture file' })).toBeVisible();
  await section.getByRole('button', { name: 'Cancel fixture upload' }).click();
  await expect(output).toHaveText('upload-cancelled');
});

test('avatar load state, fallback state, aspect ratio, and RTL direction are observable', async ({ page }) => {
  await page.goto('/');

  const section = page.locator('#fixture-section-semantic-media');
  const loaded = section.locator('#fixture-avatar-loaded');
  const failed = section.locator('#fixture-avatar-failed');

  await expect(loaded.getByRole('img', { name: 'Loaded fixture avatar' })).toBeVisible();
  await expect(loaded.locator('[data-slot="avatar-fallback"]')).toBeHidden();
  await expect(failed.locator('[data-slot="avatar-image"]')).toBeHidden();
  await expect(failed.locator('[data-slot="avatar-fallback"]')).toBeVisible();
  await expect(failed.locator('[data-slot="avatar-fallback"]')).toHaveText('FA');

  const ratio = section.locator('#fixture-aspect-ratio');
  const box = await ratio.boundingBox();
  if (!box) throw new Error('aspect ratio fixture has no layout box');
  expect(box.width / box.height).toBeCloseTo(2, 1);
  await expect(section.locator('#fixture-direction-rtl')).toHaveAttribute('dir', 'rtl');
});

test('breadcrumb and pagination expose link targets and current-page semantics', async ({ page }) => {
  await page.goto('/');

  const section = page.locator('#fixture-section-semantic-navigation');
  const breadcrumb = section.getByRole('navigation', { name: 'Fixture breadcrumb' });
  const pagination = section.getByRole('navigation', { name: 'Fixture pagination' });

  await expect(breadcrumb.getByRole('list')).toBeVisible();
  await expect(breadcrumb.getByRole('link', { name: 'Fixtures' })).toHaveAttribute(
    'href',
    '#fixture-main',
  );
  await expect(pagination.getByRole('link', { name: 'Fixture page 1' })).toHaveAttribute(
    'aria-current',
    'page',
  );
  const previous = pagination.getByRole('link', { name: 'Go to previous page' });
  await expect(previous).toHaveAttribute('aria-disabled', 'true');
  await expect(previous).toHaveAttribute('tabindex', '-1');
  await expect(section.getByRole('link', { name: 'Unavailable fixture badge' })).toHaveAttribute(
    'aria-disabled',
    'true',
  );
  await expect(section.locator('[data-slot="marker"]')).toHaveAttribute(
    'data-variant',
    'border',
  );
});

test('card, empty, item, message, and bubble keep their public compound structure', async ({ page }) => {
  await page.goto('/');

  const section = page.locator('#fixture-section-semantic-compositions');
  await expect(section.locator('#fixture-card [data-slot="card-title"]')).toHaveText(
    'Fixture card',
  );
  await expect(section.locator('#fixture-empty [data-slot="empty-title"]')).toHaveText(
    'No fixture results',
  );
  await expect(section.locator('#fixture-item-group')).toHaveAttribute('role', 'list');
  await expect(section.locator('#fixture-item-group [data-slot="item"]')).toContainText(
    'Fixture item',
  );
  await expect(section.locator('#fixture-message')).toHaveAttribute('data-align', 'end');
  await expect(section.locator('#fixture-message [data-slot="bubble"]')).toHaveAttribute(
    'data-variant',
    'secondary',
  );
  await expect(section.getByText('Delivered', { exact: true })).toBeVisible();
});

test('table, chart, and progress expose native data semantics and clamped values', async ({ page }) => {
  await page.goto('/');

  const section = page.locator('#fixture-section-semantic-data');
  const table = section.getByRole('table', { name: 'Fixture build matrix' });
  await expect(table.getByRole('columnheader')).toHaveCount(2);
  await expect(table.getByRole('cell', { name: 'Chromium' })).toBeVisible();

  await expect(section.getByRole('img', { name: 'Fixture coverage chart' })).toBeVisible();
  await expect(section.locator('#fixture-chart-bar')).toHaveCSS(
    'background-color',
    'rgb(37, 99, 235)',
  );

  const complete = section.getByRole('progressbar', { name: 'Fixture completion' });
  await expect(complete).toHaveAttribute('aria-valuenow', '100');
  await expect(complete).toHaveAttribute('aria-valuetext', '100%');
  await expect(complete).toHaveAttribute('data-state', 'complete');
  const pending = section.getByRole('progressbar', { name: 'Fixture pending work' });
  await expect(pending).not.toHaveAttribute('aria-valuenow');
  await expect(pending).toHaveAttribute('data-state', 'indeterminate');
});

test('typography, keyboard hints, separator, skeleton, spinner, and theme render semantics', async ({ page }) => {
  await page.goto('/');

  const section = page.locator('#fixture-section-semantic-status');
  await expect(section.getByRole('heading', { name: 'Fixture typography', level: 2 })).toBeVisible();
  await expect(section.locator('[data-slot="kbd"]')).toHaveCount(2);
  await expect(section.locator('#fixture-semantic-separator')).toHaveAttribute(
    'role',
    'separator',
  );
  await expect(section.locator('#fixture-semantic-separator')).toHaveAttribute(
    'aria-orientation',
    'horizontal',
  );
  await expect(section.locator('#fixture-skeleton')).toHaveCSS(
    'animation-name',
    'rui-pulse',
  );
  await expect(section.getByRole('status', { name: 'Loading fixture semantics' })).toBeVisible();
  await expect(page.locator('#fixture-theme')).toHaveAttribute('data-rui-theme', '');
});
