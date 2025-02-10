// tests/portfolio-linked-projects.spec.js
import { test, expect } from '@playwright/test';

test('All portfolio sub pages load correctly', async ({ page }) => {
  // Navigate to your portfolio page (adjust the URL if needed)
  await page.goto('http://localhost:4321/portfolio');

  // Verify the portfolio cards container is visible using its id
  const portfolioCards = page.locator('#portfolio-cards');
  await expect(portfolioCards).toBeVisible();

  // Locate each portfolio card by targeting the direct children of the grid container
  const cards = portfolioCards.locator('.grid > div');
  const count = await cards.count();
  expect(count).toBeGreaterThan(0);

  // Iterate through each portfolio card to test each sub page
  for (let i = 0; i < count; i++) {
    // Use nth() to get each card individually
    const card = cards.nth(i);
    // Locate the "View Project" link within the card
    const viewLink = card.locator('a:has(button)');
    await expect(viewLink).toBeVisible();
    const href = await viewLink.getAttribute('href');
    expect(href).toBeTruthy();

    // Click the link and wait for the page to load
    await viewLink.click();
    await page.waitForLoadState('networkidle');

    // Verify that the new URL contains the expected href (you can adjust this check as needed)
    await expect(page).toHaveURL(new RegExp(href));

    // Navigate back to the portfolio page for the next iteration
    await page.goBack();
    await page.waitForLoadState('networkidle');
  }
});