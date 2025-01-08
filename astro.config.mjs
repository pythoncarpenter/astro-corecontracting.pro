import { defineConfig } from 'astro/config';
import tailwind from '@astrojs/tailwind';
import sitemap from '@astrojs/sitemap';
import vue from '@astrojs/vue';
import netlify from '@astrojs/netlify';

export default defineConfig({
  integrations: [
    tailwind(),
    sitemap(),
    vue()
  ],
  output: 'server', // Netlify supports server-side rendering
  adapter: netlify(), // Use Netlify adapter for this project
  site: 'https://corecontracting.pro'
});