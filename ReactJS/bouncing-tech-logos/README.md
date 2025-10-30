# 🚀 Bouncing Tech Logos - React Edition

**Interactive React component with 16 technology logos and realistic physics**

*Created by [SOULJAX](https://souljax.com)*

![React 18](https://img.shields.io/badge/react-18.x-blue) ![TypeScript](https://img.shields.io/badge/typescript-5.x-blue) ![License MIT](https://img.shields.io/badge/license-MIT-blue)

## ✨ Features

- 🎯 **16 Interactive Logos** - Angular, React, Vue, TypeScript, Node.js, MongoDB, etc.
- 💥 **Realistic Physics** - Enhanced collision detection with energy transfer
- 🔗 **Click to Visit** - Click any logo to visit the technology's official website
- ⚡ **Hover to Pause** - Logos freeze when hovered, resume when left
- 📱 **Responsive Design** - Adapts to any screen size
- 🚀 **High Performance** - Optimized React hooks and animations
- 🎯 **TypeScript Native** - Full type safety included

## 🎮 Live Demo

[**View Live Demo →**](https://souljax.github.io/souljax_dev_tools/ReactJS/bouncing-tech-logos/)

## � Quick Start

### 1. Clone & Install
```bash
git clone https://github.com/souljax/souljax_dev_tools.git
cd souljax_dev_tools/ReactJS/bouncing-tech-logos
npm install
```

### 2. Development
```bash
npm run dev
# Opens http://localhost:3030/
```

### 3. Production Build
```bash
npm run build
# Output in dist/ folder
```

## 🔧 Usage in Your Project

```tsx
import BouncingLogos from './components/BouncingLogos/BouncingLogos';

function App() {
  return (
    <div className="app">
      <BouncingLogos 
        logoCount={16}           // Number of logos (1-16)
        tooltipText="Visit site" // Hover tooltip text
        containerBounds={{       // Layout boundaries
          headerHeight: 80, 
          footerHeight: 100 
        }}
      />
    </div>
  );
}
```

## ⚙️ Configuration

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `logoCount` | number | `16` | Number of logos to display (1-16) |
| `tooltipText` | string | `'go to website'` | Text shown on hover |
| `containerBounds` | object | `{headerHeight: 80, footerHeight: 100}` | Layout boundaries |
| `isActive` | boolean | `true` | Enable/disable animation |

## 🎨 Included Technology Logos

**Frontend:** React, Vue.js, Angular, JavaScript, TypeScript, HTML, CSS  
**Backend:** Node.js, MongoDB, Supabase  
**Tools:** Bootstrap, Vite, Google Cloud, Nginx, Ubuntu, GitHub

*All logos link to their official websites*

## � Project Structure

```
bouncing-tech-logos/
├── src/
│   ├── components/BouncingLogos/    # Main component
│   ├── types/                       # TypeScript definitions  
│   └── App.tsx                      # Demo app
├── public/logos/                    # Technology logo assets
├── package.json                     # Dependencies & scripts
└── vite.config.ts                  # Build configuration
```

## 🛠️ Development Scripts

```bash
npm run dev        # Start development server
npm run build      # Create production build  
npm run preview    # Preview production build
npm run type-check # TypeScript validation
```

## 📄 License

MIT License - Free for commercial and personal use.

## 🙏 Credits

**Created by [SOULJAX](https://souljax.com)**

Enhanced React implementation with performance optimizations and interactive features.