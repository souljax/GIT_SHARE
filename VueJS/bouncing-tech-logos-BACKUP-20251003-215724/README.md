# 🚀 Bouncing Tech Logos

**Interactive Vue.js component with realistic physics simulation**

*Created by [SOULJAX](https://souljax.com)*

![Vue 3](https://img.shields.io/badge/vue-3.x-green)
![License MIT](https://img.shields.io/badge/license-MIT-blue)

## ✨ Features

- 🎯 **Interactive Hover/Pause** - Logos freeze when hovered, resume when left
- 💥 **Realistic Physics** - Collision detection with energy transfer
- 🔗 **Click to Explore** - Click logos to visit official technology websites  
- ⚡ **Smart Collisions** - Paused logos become immovable obstacles
- 📱 **Responsive Design** - Adapts to any screen size
- 🎨 **Customizable** - Configure physics, logos, and appearance

## 🎮 Live Demo

The package includes a live test page at: `http://localhost:3030/bouncing-tech-logos-test`

## 📋 Prerequisites

### System Requirements
- **Node.js**: 16+ 
- **npm**: 7+
- **Modern browser** with ES6+ support (Chrome 88+, Firefox 85+, Safari 14+)

### Environment
- **Port 3030**: Must be available (dev server default)
- **No additional environment variables required**

## 📦 Installation & Setup

### Method 1: Git Clone (Recommended)
```bash
# Clone the repository
git clone https://github.com/[username]/bouncing-tech-logos.git

# Navigate to package directory
cd bouncing-tech-logos

# Install dependencies
npm install
```

### Method 2: Download ZIP
```bash
# After downloading and extracting the ZIP file
cd bouncing-tech-logos

# Install dependencies
npm install
```

## 🚀 Testing the Package

### Start Development Server
```bash
# Launch the test environment
npm run dev
```

### Access Test Page
- **URL**: `http://localhost:3030/bouncing-tech-logos-test`
- **Auto-redirect**: `http://localhost:3030/` redirects to test page
- **Expected behavior**: 
  - Header/Footer with "HEADER"/"FOOTER" text
  - 16 technology logos bouncing with physics
  - Interactive hover/pause functionality
  - Click-to-website functionality

### Test Controls
- 🖱️ **Hover on logo**: Pauses movement, becomes obstacle
- 🖱️ **Click on logo**: Opens technology's official website
- ⚡ **Watch collisions**: Moving logos bounce off paused ones

## 🧹 Cleanup

### Stop Development Server
```bash
# Press Ctrl+C in terminal where npm run dev is running
```

### Remove Installation Files
```bash
# Clean up node_modules and lock file
rm -rf node_modules package-lock.json
```

### Complete Reset
```bash
# Return to original clean state
git clean -fd  # (if using git)
# OR manually delete node_modules and package-lock.json
```

## 📁 Package Structure

```
bouncing-tech-logos/
├── src/
│   ├── components/
│   │   └── BouncingTechLogos.vue    # Main component
│   ├── views/
│   │   └── BouncingTechLogosTest.vue # Test page
│   ├── App.vue                      # Vue app wrapper
│   └── main.js                      # Entry point with routing
├── public/
│   └── logos/                       # Technology logo assets (16 files)
├── index.html                       # HTML entry point
├── package.json                     # Dependencies & scripts
├── vite.config.js                   # Vite configuration
└── README.md                        # This documentation
```

## 🔧 Integration in Your Project

### Import Component
```vue
<template>
  <BouncingTechLogos 
    :is-active="true"
    :logo-count="12"
    tooltip-text="Visit website"
    :container-bounds="{ headerHeight: 80, footerHeight: 100 }"
  />
</template>

<script>
import BouncingTechLogos from './path/to/BouncingTechLogos.vue'

export default {
  components: {
    BouncingTechLogos
  }
}
</script>
```

### Available Props
| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `isActive` | Boolean | `true` | Show/hide component |
| `logoCount` | Number | `12` | Number of logos to display |
| `customLogos` | Array | `[]` | Custom logo filenames |
| `tooltipText` | String | `'go to website'` | Hover tooltip |
| `containerBounds` | Object | `{headerHeight: 55, footerHeight: 55}` | Layout boundaries |

## 🎨 Included Technology Logos

- **Frontend**: React, Vue.js, Angular, JavaScript, TypeScript, HTML, CSS
- **Backend**: Node.js, MongoDB, Supabase  
- **Tools**: Bootstrap, Vite, Google Cloud, Nginx, Ubuntu
- **All logos link to official websites**

## 🐛 Troubleshooting

### Port 3030 Already in Use
```bash
# Check what's using the port
lsof -i :3030

# Kill the process if needed
kill -9 [PID]

# Or use different port in vite.config.js
```

### Logos Not Loading
- Verify `public/logos/` folder contains 16 PNG files
- Check browser console for 404 errors
- Ensure Vite dev server is serving static files correctly

### Component Import Errors
- Verify Vue 3 compatibility in your project
- Check import paths are correct
- Ensure all dependencies are installed

## 📄 License

MIT License - free for commercial and personal use.

## 🙏 Credits

**Created by [SOULJAX](https://souljax.com)**

- 🌐 Website: [souljax.com](https://souljax.com)
- 💼 Professional Vue.js development services
- 🚀 More components available

---

## 🎯 Quick Start Summary

```bash
# 1. Get the package
git clone https://github.com/[username]/bouncing-tech-logos.git
cd bouncing-tech-logos

# 2. Install & test
npm install
npm run dev

# 3. Open browser
# http://localhost:3030/bouncing-tech-logos-test

# 4. Clean up when done
# Ctrl+C to stop server
rm -rf node_modules package-lock.json
```

**Ready to bounce! 🚀**