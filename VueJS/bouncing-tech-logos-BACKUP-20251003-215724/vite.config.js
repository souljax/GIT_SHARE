import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import { resolve } from 'path'

export default defineConfig({
  plugins: [vue()],
  base: './', // Chemins relatifs pour GitHub Pages
  server: {
    port: 3030
  },
  resolve: {
    alias: {
      '@': resolve(__dirname, 'src')
    }
  }
})