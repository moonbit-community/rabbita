import { expect, test } from '@playwright/test';

test('form fields keep labels, descriptions, controlled values, and submit output', async ({ page }) => {
  await page.goto('/');

  const name = page.getByRole('textbox', { name: 'Display name' });
  const site = page.getByRole('textbox', { name: 'Workspace URL' });
  const note = page.getByRole('textbox', { name: 'Launch note' });
  const output = page.locator('#fixture-form-output');

  await expect(name).toHaveAttribute('required', '');
  await expect(name).toHaveAttribute('name', 'display-name');
  await expect(name).toHaveAttribute('aria-describedby', 'fixture-name-description');
  await expect(page.locator('#fixture-name-description')).toHaveText(
    'Shown to fixture collaborators.',
  );
  await expect(site).toHaveValue('analytical-engine');
  await expect(note).toHaveValue('Initial launch note');
  await expect(page.getByText('https://', { exact: true })).toBeVisible();
  await expect(page.getByText('.moonbit.app', { exact: true })).toBeVisible();

  await name.fill('Grace Hopper');
  await site.fill('compiler-lab');
  await note.fill('Ready for launch');
  await expect(output).toHaveText('editing:Grace Hopper|compiler-lab|Ready for launch');

  await page.getByRole('button', { name: 'Save fixture profile' }).click();
  await expect(output).toHaveText('submitted:Grace Hopper|compiler-lab|Ready for launch');
  await expect(page).toHaveURL(/\/$/);
});

test('native select reports changes and preserves its disabled value', async ({ page }) => {
  await page.goto('/');

  const select = page.getByRole('combobox', { name: 'Access scope' });
  const disabled = page.getByRole('combobox', { name: 'Environment' });

  await expect(select).toHaveValue('team');
  await select.selectOption('organization');
  await expect(select).toHaveValue('organization');
  await expect(page.locator('#fixture-native-select-output')).toHaveText(
    'selected:organization',
  );

  await expect(disabled).toBeDisabled();
  await expect(disabled).toHaveValue('production');
});

test('input OTP reports edits and completion while disabled code stays immutable', async ({ page }) => {
  await page.goto('/');

  const otp = page.getByRole('textbox', { name: 'Fixture verification code' });
  const disabled = page.getByRole('textbox', {
    name: 'Previously verified fixture code',
  });

  await otp.fill('12345');
  await expect(page.locator('#fixture-otp-value')).toHaveText('value:12345');
  await expect(page.locator('#fixture-otp-complete')).toHaveText('complete:');

  await otp.press('6');
  await expect(otp).toHaveValue('123456');
  await expect(page.locator('#fixture-otp-value')).toHaveText('value:123456');
  await expect(page.locator('#fixture-otp-complete')).toHaveText('complete:123456');

  await otp.press('Backspace');
  await expect(otp).toHaveValue('12345');
  await expect(page.locator('[data-slot="input-otp-separator"]')).toBeVisible();

  await expect(disabled).toBeDisabled();
  await expect(disabled).toHaveValue('482931');
});
