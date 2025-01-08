import { defineConfig } from 'astro/config';
import tailwind from '@astrojs/tailwind';
import sitemap from '@astrojs/sitemap';
import vue from '@astrojs/vue';
import netlify from '@astrojs/netlify';

export default defineConfig({
  output: 'server',  // Ensure SSR is used for dynamic pages like this
  adapter: netlify(),  // Keep the Netlify adapter for deployment
  integrations: [
    tailwind(),
    vue(),
    sitemap(),
  ],
  site: 'https://corecontracting.pro'
});