import { test, expect } from '@playwright/test';

test('landing page loads core sections', async ({ page }) => {
  await page.goto('/');

  const primaryNav = page.getByLabel('Primary navigation');

  await expect(
    page.getByRole('heading', { name: 'Beautiful calculations, real-world clarity' })
  ).toBeVisible();

  await primaryNav.getByRole('link', { name: 'Demo' }).click();
  await expect(page.locator('#demo')).toBeVisible();

  await primaryNav.getByRole('link', { name: 'Accessibility' }).click();
  await expect(page.locator('#accessibility')).toBeVisible();

  await primaryNav.getByRole('link', { name: 'About' }).click();
  await expect(page.locator('#about')).toBeVisible();
});

test('high contrast toggle updates document state and demo tabs swap', async ({ page }) => {
  await page.goto('/');

  const contrastToggle = page.getByRole('button', { name: /high contrast mode/i });
  await contrastToggle.click();
  const contrast = await page.evaluate(() => document.documentElement.getAttribute('data-contrast'));
  expect(contrast).toBe('high');

  await page.locator('#demo').getByRole('button', { name: 'Tip', exact: true }).click();
  await expect(page.getByRole('img', { name: 'Tip screenshot' })).toBeVisible();
});
