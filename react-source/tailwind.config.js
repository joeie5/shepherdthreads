export default {
  content: [
  './index.html',
  './src/**/*.{js,ts,jsx,tsx}'
],
  theme: {
    extend: {
      colors: {
        ink: '#0A0A0A',
        cream: '#F7F5F0',
        stone: '#8C8C88',
        brass: '#B08D57',
        hairline: '#E4E1DA',
      },
      fontFamily: {
        serif: ['"Playfair Display"', 'Georgia', 'serif'],
        sans: ['Inter', 'system-ui', '-apple-system', 'Segoe UI', 'sans-serif'],
      },
      maxWidth: {
        site: '1440px',
      },
    },
  },
  plugins: [],
}
