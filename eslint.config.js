import astro from 'eslint-plugin-astro';
import parser from 'astro-eslint-parser';

export default [
  {
    files: ['**/*.astro'],
    plugins: { astro },
    languageOptions: {
      parser, // Use astro-eslint-parser
      parserOptions: {
        ecmaVersion: 2020, // Optional, adjust as needed
        sourceType: 'module', // For ESModules
      },
    },
    rules: {
      // Add Astro-specific linting rules or keep as empty
    },
  },
];