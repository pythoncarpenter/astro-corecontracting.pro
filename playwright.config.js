// playwright.config.js
import { defineConfig } from '@playwright/test';

export default defineConfig({
  // Run tests with 4 workers in parallel
  workers: 1,
  testDir: './tests',

  use 
  // You can add more configuration options here if needed
});