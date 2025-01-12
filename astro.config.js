import { defineConfig } from 'astro/config';
import tailwind from '@astrojs/tailwind';
import sitemap from '@astrojs/sitemap';
import vue from '@astrojs/vue';
import netlify from '@astrojs/netlify';

export default defineConfig({
  output: 'server',
  adapter: netlify(),
  integrations: [
    tailwind(),
    vue(),
    sitemap(),
  ],
  site: 'https://corecontracting.pro',
});
