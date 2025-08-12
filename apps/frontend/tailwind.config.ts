import type { Config } from 'tailwindcss'

export default {
  darkMode: 'class', // ✅ вместо ['class']
  content: ['./index.html', './src/**/*.{ts,tsx}'],
  theme: { extend: {} },
  plugins: [],
} satisfies Config
