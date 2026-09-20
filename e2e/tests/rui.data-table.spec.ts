import { expect, test } from '@playwright/test';

test('data table filters rows, reports its query, and renders an empty state', async ({ page }) => {
  await page.goto('/');

  const section = page.locator('#fixture-section-data-table');
  const table = section.getByRole('table', { name: 'Fixture payments' });
  const filter = section.getByRole('searchbox', { name: 'Filter rows' });

  await expect(table.getByRole('row')).toHaveCount(3);
  await filter.fill('Ada');
  await expect(table.getByRole('cell', { name: 'Ada' })).toBeVisible();
  await expect(table.getByRole('cell', { name: 'Grace' })).toHaveCount(0);
  await expect(section.locator('#fixture-data-table-output')).toHaveText(
    'query:Ada|selected:pay-002',
  );

  await filter.fill('no such payment');
  await expect(table).toContainText('No results.');
  await expect(section.locator('#fixture-data-table')).toHaveAttribute('data-row-count', '0');
});

test('data table sorts, paginates, and clamps pagination controls', async ({ page }) => {
  await page.goto('/');

  const section = page.locator('#fixture-section-data-table');
  const table = section.getByRole('table', { name: 'Fixture payments' });
  const amount = table.getByRole('columnheader', { name: 'Amount' });
  const previous = section.getByRole('button', { name: 'Previous' });
  const next = section.getByRole('button', { name: 'Next' });

  await expect(amount).toHaveAttribute('aria-sort', 'ascending');
  await expect(table.getByRole('row').nth(1)).toContainText('Evelyn');
  await amount.getByRole('button').click();
  await expect(amount).toHaveAttribute('aria-sort', 'descending');
  await expect(table.getByRole('row').nth(1)).toContainText('Lin');

  await expect(previous).toBeDisabled();
  await next.click();
  await expect(section.getByText('Page 2 of 3')).toBeVisible();
  await expect(previous).toBeEnabled();
  await next.click();
  await expect(section.getByText('Page 3 of 3')).toBeVisible();
  await expect(next).toBeDisabled();
});

test('data table reports row selection and toggles column visibility', async ({ page }) => {
  await page.goto('/');

  const section = page.locator('#fixture-section-data-table');
  const table = section.getByRole('table', { name: 'Fixture payments' });
  const grace = section.getByRole('checkbox', { name: 'Select row pay-002' });

  await expect(grace).toBeChecked();
  await grace.click();
  await expect(grace).not.toBeChecked();
  await expect(section.locator('#fixture-data-table-output')).toHaveText(
    'query:|selected:',
  );

  const columns = section.getByRole('button', { name: 'Columns' });
  await columns.click();
  await expect(columns).toHaveAttribute('aria-expanded', 'true');
  const owner = section.getByRole('checkbox', { name: 'Toggle Owner column' });
  await expect(owner).toBeChecked();
  await owner.click();
  await expect(table.getByRole('columnheader', { name: 'Owner' })).toHaveCount(0);
  await page.getByRole('heading', { name: 'Data Table' }).click();
  await expect(columns).toHaveAttribute('aria-expanded', 'false');
});
