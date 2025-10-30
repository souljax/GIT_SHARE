import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import { resolve } from 'path'

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [react()],
  
  // Base path for GitHub Pages subdirectory
  base: './',
  
  // Development server configuration
  server: {
    port: 3030,
    host: true,
    open: true,
    strictPort: true,
    fs: {
      strict: false
    }
  },

  // Build configuration
  build: {
    outDir: 'dist',
    assetsDir: 'assets',
    sourcemap: true,
    minify: 'esbuild',
    target: 'es2020',
    rollupOptions: {
      input: {
        main: resolve(__dirname, 'index.html')
      },
      output: {
        manualChunks: {
          vendor: ['react', 'react-dom'],
          components: ['./src/components/BouncingLogos/BouncingLogos.tsx']
        }
      }
    }
  },

  // Path resolution
  resolve: {
    alias: {
      '@': resolve(__dirname, './src'),
      '@/components': resolve(__dirname, './src/components'),
      '@/types': resolve(__dirname, './src/types')
    }
  },

  // CSS configuration
  css: {
    devSourcemap: true,
    preprocessorOptions: {
      css: {
        charset: false
      }
    }
  },

  // Performance optimizations
  optimizeDeps: {
    include: ['react', 'react-dom'],
    exclude: []
  },

  // Preview configuration (for production preview)
  preview: {
    port: 3030,
    host: true,
    strictPort: true
  },

  // Environment variables
  define: {
    __APP_VERSION__: JSON.stringify(process.env.npm_package_version),
    __BUILD_TIME__: JSON.stringify(new Date().toISOString())
  }
})