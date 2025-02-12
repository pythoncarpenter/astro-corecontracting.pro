const { test, expect } = require('@playwright/test');

// Determine base URL from environment or fallback to localhost
const baseUrl = process.env.BASE_URL || 'http://localhost:4321';

// Helper function to attach a MutationObserver that logs theme changes.
async function attachThemeObserver(page) {
  await page.addInitScript(() => {
    window.themeMutations = [];
    const observer = new MutationObserver((mutations) => {
      mutations.forEach((mutation) => {
        if (mutation.attributeName === 'class') {
          // Record the current class list of the <html> element.
          window.themeMutations.push(document.documentElement.className);
        }
      });
    });
    observer.observe(document.documentElement, { attributes: true });
  });
}

test.describe('Theme Toggle Behavior - Dark Mode (System default dark)', () => {
  // Use a context that simulates a system dark mode
  test.use({ colorScheme: 'dark' });

  test('should load with dark theme and toggle to light correctly', async ({ page }) => {
    // Attach MutationObserver to capture class changes on <html>
    await attachThemeObserver(page);

    // Navigate using the baseUrl variable
    await page.goto(baseUrl);
    await page.waitForLoadState('load');

    // Debug: Log initial class attribute of <html>
    const initialHtmlClass = await page.locator('html').getAttribute('class');
    console.log('Initial <html> class:', initialHtmlClass);

    // Log the mutations recorded during page load.
    const themeMutations = await page.evaluate(() => window.themeMutations);
    console.log('Theme mutations during page load (dark mode):', themeMutations);

    // The page should load with dark theme applied (i.e. <html> has class "dark")
    await expect(page.locator('html')).toHaveClass(/dark/, { timeout: 10000 });

    // Simulate user clicking the theme toggle button (which should switch to light theme)
    await page.click('#theme-toggle');

    // Wait until the <html> element no longer has the "dark" class
    await page.waitForFunction(() => !document.documentElement.classList.contains('dark'));

    // After toggle, verify that the <html> element does not have the "dark" class.
    await expect(page.locator('html')).not.toHaveClass(/dark/);

    // Verify that localStorage is updated to reflect the light theme
    const colorSchemeAfterToggle = await page.evaluate(() => localStorage.getItem('colorScheme'));
    expect(colorSchemeAfterToggle).toBe('light');

    // Log the mutations that occurred after the toggle.
    const mutationsAfterToggle = await page.evaluate(() => window.themeMutations);
    console.log('Theme mutations after toggle (dark mode):', mutationsAfterToggle);
  });
});

test.describe('Theme Toggle Behavior - Light Mode (System default light)', () => {
  // Use a context that simulates a system light mode
  test.use({ colorScheme: 'light' });

  test('should load with light theme and toggle to dark correctly', async ({ page }) => {
    // Attach MutationObserver to capture class changes on <html>
    await attachThemeObserver(page);

    // Navigate using the baseUrl variable
    await page.goto(baseUrl);
    await page.waitForLoadState('load');

    // Debug: Log initial class attribute of <html>
    const initialHtmlClass = await page.locator('html').getAttribute('class');
    console.log('Initial <html> class:', initialHtmlClass);

    // Log the mutations recorded during page load.
    const themeMutations = await page.evaluate(() => window.themeMutations);
    console.log('Theme mutations during page load (light mode):', themeMutations);

    // The page should load with light theme (i.e. <html> should NOT have the "dark" class)
    await expect(page.locator('html')).not.toHaveClass(/dark/);

    // Simulate user clicking the theme toggle button (which should switch to dark theme)
    await page.click('#theme-toggle');

    // Wait until the <html> element has the "dark" class
    await page.waitForFunction(() => document.documentElement.classList.contains('dark'));

    // After the toggle, verify that the <html> element has the "dark" class.
    await expect(page.locator('html')).toHaveClass(/dark/);

    // Verify that localStorage is updated to reflect the dark theme
    const colorSchemeAfterToggle = await page.evaluate(() => localStorage.getItem('colorScheme'));
    expect(colorSchemeAfterToggle).toBe('dark');

    // Log the mutations that occurred after the toggle.
    const mutationsAfterToggle = await page.evaluate(() => window.themeMutations);
    console.log('Theme mutations after toggle (light mode):', mutationsAfterToggle);
  });
});