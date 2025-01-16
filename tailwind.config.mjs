/** @type {import('tailwindcss').Config} */
export default {
  content: [
    './src/**/*.{astro,html,js,jsx,svelte,ts,tsx,vue}', // Update with your file paths
  ],
  darkMode: 'class',
  theme: {
    extend: {
      colors: {
        primary: {
          50: '#f8f9fa',
          100: '#e9ecef',
          200: '#dee2e6',
          300: '#ced4da',
          400: '#adb5bd',
          500: '#6c757d',
          600: '#495057',
          700: '#343a40',
          800: '#212529',
          900: '#121416',
        },
        wood: {
          light: '#d4a373',
          DEFAULT: '#a87c4f',
          dark: '#744924',
        },
        metal: {
          light: '#e9ecef',
          DEFAULT: '#adb5bd',
          dark: '#495057',
        },
        brown: {
          50: '#fdf8f5',
          100: '#faf2ec',
          200: '#f4e4da',
          300: '#e7c9b9',
          400: '#d9ac94',
          500: "#744923", // You can tweak these hex codes to suit your brand
          600: '#ac744f',
          700: '#8b5a3c',
          800: '#6a422b',
          900: '#4c2c1c',
        },
      },
      fontFamily: {
        sans: ['Inter', 'system-ui', 'sans-serif'],
        serif: ['Merriweather', 'Georgia', 'serif'],
        display: ['Racing Sans One', 'system-ui', 'sans-serif'],
      },
    },
  },
  plugins: [require('@tailwindcss/typography')],
};