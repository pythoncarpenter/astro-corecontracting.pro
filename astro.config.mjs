import { defineConfig } from 'astro/config';
import tailwind from '@astrojs/tailwind';
import sitemap from '@astrojs/sitemap';
import netlify from '@astrojs/netlify';

export default defineConfig({
  output: 'server',
  adapter: netlify(),
  integrations: [
    tailwind({
      applyBaseStyles: true,
    }), 
    sitemap(),
  ],
  site: 'https://corecontracting.pro',
});