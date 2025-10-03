<template>
  <div v-if="isActive" class="bouncing-logos-container">
    <div
      v-for="logo in logos"
      :key="logo.id"
      class="bouncing-logo"
      @mouseenter="onLogoHover(logo)"
      @mouseleave="onLogoLeave(logo)"
      @click="onLogoClick(logo)"
      :style="{
        left: logo.x + 'px',
        top: logo.y + 'px',
        transform: `rotate(${logo.rotation}deg)`,
        opacity: logo.opacity,
        width: logo.actualWidth + 'px',
        height: logo.actualHeight + 'px'
      }"
    >
      <img
        :src="logo.src"
        :alt="logo.name"
        class="logo-image"
        @load="onImageLoad($event, logo)"
        @error="onImageError($event, logo)"
      />
      
      <!-- 💬 TOOLTIP "GO TO WEBSITE" -->
      <div 
        v-if="logo.isPaused" 
        class="logo-tooltip"
        :style="{
          top: logo.actualHeight + 5 + 'px'
        }"
      >
        {{ tooltipText }}
      </div>
    </div>
  </div>
</template>

<script>
/**
 * BouncingTechLogos - Interactive bouncing technology logos
 * Created by SOULJAX (https://souljax.com)
 * 
 * Features:
 * - Realistic physics with collisions and energy transfer
 * - Interactive hover/pause functionality
 * - Click to open official technology websites
 * - Responsive and customizable
 */

import { defineComponent, ref, onMounted, onBeforeUnmount } from 'vue'

export default defineComponent({
  name: 'BouncingTechLogos',
  props: {
    // Control visibility of the component
    isActive: {
      type: Boolean,
      default: true
    },
    // Custom logos array (optional)
    customLogos: {
      type: Array,
      default: () => []
    },
    // Number of logos to display
    logoCount: {
      type: Number,
      default: 12
    },
    // Custom tooltip text
    tooltipText: {
      type: String,
      default: 'go to website'
    },
    // Physics configuration
    physicsConfig: {
      type: Object,
      default: () => ({
        wallBounceEnergy: 0.85,
        collisionEnergyBoost: 1.1,
        pausedCollisionBoost: 1.3,
        maxSpeed: 3
      })
    },
    // Container bounds
    containerBounds: {
      type: Object,
      default: () => ({
        headerHeight: 80,
        footerHeight: 100
      })
    }
  },
  setup(props) {
    const logos = ref([])
    const animationId = ref(null)
    const containerBounds = ref({
      width: window.innerWidth,
      height: window.innerHeight,
      headerHeight: props.containerBounds.headerHeight,
      footerHeight: props.containerBounds.footerHeight
    })

    // 🔄 AVAILABLE LOGOS (standalone package)
    const availableLogos = ref([])
    
    // Default logos included in package
    const defaultLogos = [
      'react.png', 'vue_2.png', 'js.png', 'typescript.png', 'nodejs_2.png',
      'html.png', 'css.png', 'bootstrap.png', 'vite.png', 'mongodb.png',
      'supabase.png', 'google-cloud.png', 'nginx_2.png', 'ubuntu.png',
      'shopify.png', 'angular_2.png'
    ]
    
    // Load available logos
    const loadAvailableLogos = async () => {
      if (props.customLogos.length > 0) {
        availableLogos.value = props.customLogos
      } else {
        // Use default logos from package
        availableLogos.value = defaultLogos
      }
      console.log('🔄 Logos loaded:', availableLogos.value.length)
      return availableLogos.value
    }

    const createLogo = (logoName, index) => {
      const baseSize = 50
      
      const x = Math.random() * (containerBounds.value.width - baseSize * 1.5)
      const y = containerBounds.value.headerHeight + Math.random() * 
                (containerBounds.value.height - containerBounds.value.headerHeight - containerBounds.value.footerHeight - baseSize * 1.5)
      
      return {
        id: index,
        name: logoName,
        src: props.customLogos.length > 0 ? logoName : `./logos/${logoName}`,
        x: x,
        y: y,
        vx: (Math.random() - 0.5) * 4,
        vy: (Math.random() - 0.5) * 4,
        rotation: 0,
        rotationSpeed: (Math.random() - 0.5) * 1.25,
        opacity: Math.random() * 0.2 + 0.8,
        baseSize: baseSize,
        actualWidth: baseSize,
        actualHeight: baseSize,
        imageLoaded: false,
        // Hover/pause system
        isPaused: false,
        savedVx: 0,
        savedVy: 0,
        savedRotationSpeed: 0
      }
    }

    // 🖼️ INTELLIGENT IMAGE SIZING
    const onImageLoad = (event, logo) => {
      const img = event.target
      const naturalWidth = img.naturalWidth
      const naturalHeight = img.naturalHeight
      
      if (naturalWidth && naturalHeight) {
        const aspectRatio = naturalWidth / naturalHeight
        
        if (aspectRatio > 1.2) {
          logo.actualWidth = logo.baseSize * 1.2
          logo.actualHeight = logo.actualWidth / aspectRatio
        } else if (aspectRatio < 0.8) {
          logo.actualHeight = logo.baseSize * 1.2
          logo.actualWidth = logo.actualHeight * aspectRatio
        } else {
          logo.actualWidth = logo.baseSize
          logo.actualHeight = logo.baseSize
        }
        
        logo.imageLoaded = true
        console.log(`🖼️ ${logo.name}: ${naturalWidth}x${naturalHeight} → ${logo.actualWidth.toFixed(0)}x${logo.actualHeight.toFixed(0)}px`)
      }
    }

    const onImageError = (event, logo) => {
      console.warn(`⚠️ Error loading: ${logo.name}`)
      logo.actualWidth = logo.baseSize
      logo.actualHeight = logo.baseSize
      logo.imageLoaded = true
    }

    // 🎯 HOVER/PAUSE SYSTEM
    const onLogoHover = (logo) => {
      if (!logo.isPaused) {
        logo.savedVx = logo.vx
        logo.savedVy = logo.vy
        logo.savedRotationSpeed = logo.rotationSpeed
        
        logo.vx = 0
        logo.vy = 0
        logo.rotationSpeed = 0
        logo.rotation = 0 // Reset to natural rotation
        
        logo.isPaused = true
      }
    }

    const onLogoLeave = (logo) => {
      if (logo.isPaused) {
        logo.vx = logo.savedVx
        logo.vy = logo.savedVy
        logo.rotationSpeed = logo.savedRotationSpeed
        logo.isPaused = false
      }
    }

    // 🔗 OFFICIAL WEBSITE MAPPING
    const logoUrls = {
      'react.png': 'https://react.dev/',
      'react2.png': 'https://react.dev/',
      'vue_2.png': 'https://vuejs.org/',
      'js.png': 'https://developer.mozilla.org/en-US/docs/Web/JavaScript',
      'typescript.png': 'https://www.typescriptlang.org/',
      'nodejs_2.png': 'https://nodejs.org/',
      'html.png': 'https://developer.mozilla.org/en-US/docs/Web/HTML',
      'css.png': 'https://developer.mozilla.org/en-US/docs/Web/CSS',
      'bootstrap.png': 'https://getbootstrap.com/',
      'vite.png': 'https://vitejs.dev/',
      'mongodb.png': 'https://www.mongodb.com/',
      'MongoDB2.png': 'https://www.mongodb.com/',
      'supabase.png': 'https://supabase.com/',
      'google-cloud.png': 'https://cloud.google.com/',
      'nginx_2.png': 'https://nginx.org/',
      'ubuntu.png': 'https://ubuntu.com/',
      'shopify.png': 'https://www.shopify.com/',
      'angular_2.png': 'https://angular.io/'
    }

    // 🖱️ CLICK TO OPEN OFFICIAL WEBSITE
    const onLogoClick = (logo) => {
      const url = logoUrls[logo.name]
      if (url) {
        window.open(url, '_blank', 'noopener,noreferrer')
        console.log(`🔗 Opening ${logo.name}: ${url}`)
      } else {
        console.warn(`⚠️ URL not found for ${logo.name}`)
      }
    }

    const initializeLogos = async () => {
      if (availableLogos.value.length === 0) {
        await loadAvailableLogos()
      }
      
      logos.value = []
      
      const shuffled = [...availableLogos.value].sort(() => Math.random() - 0.5)
      const selected = shuffled.slice(0, Math.min(props.logoCount, shuffled.length))
      
      console.log('✅ Selected logos:', selected)
      
      selected.forEach((logoName, index) => {
        logos.value.push(createLogo(logoName, index))
      })
      
      console.log(`🎯 ${logos.value.length} logos created`)
    }

    const updateLogos = () => {
      if (!props.isActive) return

      // 1. Update positions (only if not paused)
      logos.value.forEach(logo => {
        if (!logo.isPaused) {
          logo.x += logo.vx
          logo.y += logo.vy
          logo.rotation += logo.rotationSpeed
        }
      })

      // 2. Check collisions between logos
      for (let i = 0; i < logos.value.length; i++) {
        for (let j = i + 1; j < logos.value.length; j++) {
          const logo1 = logos.value[i]
          const logo2 = logos.value[j]
          
          const logo1Radius = Math.max(logo1.actualWidth, logo1.actualHeight) / 2
          const logo2Radius = Math.max(logo2.actualWidth, logo2.actualHeight) / 2
          const dx = logo1.x + logo1.actualWidth/2 - (logo2.x + logo2.actualWidth/2)
          const dy = logo1.y + logo1.actualHeight/2 - (logo2.y + logo2.actualHeight/2)
          const distance = Math.sqrt(dx * dx + dy * dy)
          const minDistance = logo1Radius + logo2Radius
          
          if (distance < minDistance) {
            const angle = Math.atan2(dy, dx)
            
            // Smart separation (only non-paused logos move)
            const overlap = minDistance - distance
            const separateX = Math.cos(angle) * overlap * 0.5
            const separateY = Math.sin(angle) * overlap * 0.5
            
            if (!logo1.isPaused) {
              logo1.x += separateX
              logo1.y += separateY
            }
            if (!logo2.isPaused) {
              logo2.x -= separateX
              logo2.y -= separateY
            }
            
            // Extra separation for paused logo collisions
            if (logo1.isPaused && !logo2.isPaused) {
              logo2.x -= separateX
              logo2.y -= separateY
            } else if (!logo1.isPaused && logo2.isPaused) {
              logo1.x += separateX
              logo1.y += separateY
            }
            
            // Collision physics
            const cos = Math.cos(angle)
            const sin = Math.sin(angle)
            
            if (logo1.isPaused && !logo2.isPaused) {
              const speed2 = Math.sqrt(logo2.vx * logo2.vx + logo2.vy * logo2.vy)
              const bounceBoost = props.physicsConfig.pausedCollisionBoost
              logo2.vx = -cos * speed2 * bounceBoost
              logo2.vy = -sin * speed2 * bounceBoost
            } else if (!logo1.isPaused && logo2.isPaused) {
              const speed1 = Math.sqrt(logo1.vx * logo1.vx + logo1.vy * logo1.vy)
              const bounceBoost = props.physicsConfig.pausedCollisionBoost
              logo1.vx = cos * speed1 * bounceBoost
              logo1.vy = sin * speed1 * bounceBoost
            } else if (!logo1.isPaused && !logo2.isPaused) {
              // Normal collision physics
              const v1n = logo1.vx * cos + logo1.vy * sin
              const v1t = -logo1.vx * sin + logo1.vy * cos
              const v2n = logo2.vx * cos + logo2.vy * sin
              const v2t = -logo2.vx * sin + logo2.vy * cos
              
              const boost = props.physicsConfig.collisionEnergyBoost
              const newV1n = v2n * boost
              const newV2n = v1n * boost
              
              logo1.vx = newV1n * cos - v1t * sin
              logo1.vy = newV1n * sin + v1t * cos
              logo2.vx = newV2n * cos - v2t * sin
              logo2.vy = newV2n * sin + v2t * cos
            }
            
            // Speed limiting
            const maxSpeed = props.physicsConfig.maxSpeed
            ;[logo1, logo2].forEach(logo => {
              if (!logo.isPaused) {
                const speed = Math.sqrt(logo.vx * logo.vx + logo.vy * logo.vy)
                if (speed > maxSpeed) {
                  logo.vx = (logo.vx / speed) * maxSpeed
                  logo.vy = (logo.vy / speed) * maxSpeed
                }
              }
            })
          }
        }
      }

      // 3. Wall bouncing with energy loss
      logos.value.forEach(logo => {
        if (!logo.isPaused) {
          const wallDamping = props.physicsConfig.wallBounceEnergy
          
          if (logo.x <= 0 || logo.x >= containerBounds.value.width - logo.actualWidth) {
            logo.vx = -logo.vx * wallDamping
            logo.x = Math.max(0, Math.min(logo.x, containerBounds.value.width - logo.actualWidth))
          }

          if (logo.y <= containerBounds.value.headerHeight || 
              logo.y >= containerBounds.value.height - containerBounds.value.footerHeight - logo.actualHeight) {
            logo.vy = -logo.vy * wallDamping
            logo.y = Math.max(containerBounds.value.headerHeight, 
                             Math.min(logo.y, containerBounds.value.height - containerBounds.value.footerHeight - logo.actualHeight))
          }
        }
      })

      animationId.value = requestAnimationFrame(updateLogos)
    }

    const updateContainerBounds = () => {
      containerBounds.value = {
        width: window.innerWidth,
        height: window.innerHeight,
        headerHeight: props.containerBounds.headerHeight,
        footerHeight: props.containerBounds.footerHeight
      }
    }

    const handleResize = () => {
      updateContainerBounds()
      logos.value.forEach(logo => {
        if (logo.y < containerBounds.value.headerHeight) {
          logo.y = containerBounds.value.headerHeight + 10
        }
        if (logo.y > containerBounds.value.height - containerBounds.value.footerHeight - logo.actualHeight) {
          logo.y = containerBounds.value.height - containerBounds.value.footerHeight - logo.actualHeight - 10
        }
      })
    }

    onMounted(async () => {
      await new Promise(resolve => setTimeout(resolve, 100))
      
      updateContainerBounds()
      await initializeLogos()
      updateLogos()
      window.addEventListener('resize', handleResize)
    })

    onBeforeUnmount(() => {
      if (animationId.value) {
        cancelAnimationFrame(animationId.value)
      }
      window.removeEventListener('resize', handleResize)
    })

    return {
      logos,
      onImageLoad,
      onImageError,
      onLogoHover,
      onLogoLeave,
      onLogoClick
    }
  }
})
</script>

<style scoped>
.bouncing-logos-container {
  position: fixed;
  top: 0;
  left: 0;
  width: 100vw;
  height: 100vh;
  pointer-events: none;
  z-index: 50;
}

.bouncing-logo {
  position: absolute;
  pointer-events: auto;
  cursor: pointer;
}

.logo-image {
  width: 100%;
  height: 100%;
  object-fit: contain;
  filter: drop-shadow(0 2px 4px rgba(0,0,0,0.1));
}

/* 💬 TOOLTIP HOVER */
.logo-tooltip {
  position: absolute;
  left: 50%;
  transform: translateX(-50%);
  background: rgba(255, 255, 255, 0.95);
  color: #333;
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 11px;
  font-weight: 500;
  white-space: nowrap;
  box-shadow: 0 2px 8px rgba(0,0,0,0.15);
  border: 1px solid rgba(0,0,0,0.1);
  z-index: 10;
  pointer-events: none;
  animation: tooltipFadeIn 0.2s ease-out;
}

@keyframes tooltipFadeIn {
  from {
    opacity: 0;
    transform: translateX(-50%) translateY(-5px);
  }
  to {
    opacity: 1;
    transform: translateX(-50%) translateY(0);
  }
}
</style>