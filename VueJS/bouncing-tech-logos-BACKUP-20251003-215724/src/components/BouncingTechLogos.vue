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
      
      <!-- Tooltip "GO TO WEBSITE" -->
      <div 
        v-if="logo.isPaused" 
        class="logo-tooltip"
        :style="{
          top: logo.actualHeight + 5 + 'px'
        }"
      >
        go to website
      </div>
    </div>
  </div>
</template>

<script>
import { defineComponent, ref, onMounted, onBeforeUnmount } from 'vue'

export default defineComponent({
  name: 'BouncingTechLogos',
  props: {
    isActive: {
      type: Boolean,
      default: true
    }
  },
  setup(props) {
    const logos = ref([])
    const animationId = ref(null)
    const containerBounds = ref({
      width: window.innerWidth,
      height: window.innerHeight,
      headerHeight: 80,
      footerHeight: 100
    })

    // CHARGEMENT DYNAMIQUE DES LOGOS
    const availableLogos = ref([])
    
    // Charger les logos dynamiquement au montage
    const loadAvailableLogos = async () => {
      try {
        // Utiliser la nouvelle config dynamique
        const logoModules = import.meta.glob('/public/logos/*.{png,svg,jpg,jpeg}')
        const logoNames = Object.keys(logoModules).map(path => path.split('/').pop())
        
        availableLogos.value = logoNames
        console.log('Logos chargés dynamiquement:', logoNames)
        return logoNames
      } catch (error) {
        console.warn('Fallback vers liste statique')
        // Fallback si problème
        const fallbackLogos = [
          'react.png', 'vue_2.png', 'js.png', 'typescript.png', 'nodejs_2.png',
          'html.png', 'css.png', 'bootstrap.png', 'vite.png', 'mongodb.png',
          'supabase.png', 'google-cloud.png', 'nginx_2.png', 'ubuntu.png',
          'shopify.png', 'angular_2.png'
        ]
        availableLogos.value = fallbackLogos
        return fallbackLogos
      }
    }

    const createLogo = (logoName, index) => {
      // TAILLE FIXE INTELLIGENTE (plus de variation aléatoire)
      const baseSize = 50 // Taille de référence fixe
      
      const x = Math.random() * (containerBounds.value.width - baseSize * 1.5) // Marge pour logos larges
      const y = containerBounds.value.headerHeight + Math.random() * 
                (containerBounds.value.height - containerBounds.value.headerHeight - containerBounds.value.footerHeight - baseSize * 1.5)
      
      return {
        id: index,
        name: logoName,
        src: `./logos/${logoName}`,
        x: x,
        y: y,
        vx: (Math.random() - 0.5) * 1.0,
        vy: (Math.random() - 0.5) * 1.0,
        rotation: 0,
        rotationSpeed: (Math.random() - 0.5) * 1.25,
        opacity: Math.random() * 0.2 + 0.8, // Plus visibles : 0.8 à 1.0 (au lieu de 0.7 à 1.0)
        baseSize: baseSize,      // Taille de référence
        actualWidth: baseSize,   // Sera ajustée après chargement image
        actualHeight: baseSize,  // Sera ajustée après chargement image
        imageLoaded: false,      // Flag pour savoir si les dimensions sont connues
        // Système de pause hover
        isPaused: false,         // État de pause
        savedVx: 0,              // Vitesse X sauvegardée
        savedVy: 0,              // Vitesse Y sauvegardée
        savedRotationSpeed: 0    // Rotation sauvegardée
      }
    }

    // 🖼️ GESTION INTELLIGENTE DES DIMENSIONS D'IMAGES
    const onImageLoad = (event, logo) => {
      const img = event.target
      const naturalWidth = img.naturalWidth
      const naturalHeight = img.naturalHeight
      
      if (naturalWidth && naturalHeight) {
        // Calculer le ratio pour garder les proportions
        const aspectRatio = naturalWidth / naturalHeight
        
        // Adapter intelligemment selon le format
        if (aspectRatio > 1.2) {
          // Image large (horizontale) - limiter la largeur
          logo.actualWidth = logo.baseSize * 1.2
          logo.actualHeight = logo.actualWidth / aspectRatio
        } else if (aspectRatio < 0.8) {
          // Image haute (verticale) - limiter la hauteur  
          logo.actualHeight = logo.baseSize * 1.2
          logo.actualWidth = logo.actualHeight * aspectRatio
        } else {
          // Image plutôt carrée - taille standard
          logo.actualWidth = logo.baseSize
          logo.actualHeight = logo.baseSize
        }
        
        logo.imageLoaded = true
        console.log(`🖼️ ${logo.name}: ${naturalWidth}x${naturalHeight} → ${logo.actualWidth.toFixed(0)}x${logo.actualHeight.toFixed(0)}px`)
      }
    }

    const onImageError = (event, logo) => {
      console.warn(`Erreur chargement: ${logo.name}`)
      // Garder la taille par défaut en cas d'erreur
      logo.actualWidth = logo.baseSize
      logo.actualHeight = logo.baseSize
      logo.imageLoaded = true
    }

    // Système de pause hover
    const onLogoHover = (logo) => {
      if (!logo.isPaused) {
        // Sauvegarder l'état complet du mouvement
        logo.savedVx = logo.vx
        logo.savedVy = logo.vy
        logo.savedRotationSpeed = logo.rotationSpeed
        
        // Arrêter complètement
        logo.vx = 0
        logo.vy = 0
        logo.rotationSpeed = 0
        
        // Repositionner dans la rotation naturelle (0°)
        logo.rotation = 0
        
        logo.isPaused = true
      }
    }

    const onLogoLeave = (logo) => {
      if (logo.isPaused) {
        // Restaurer exactement l'état d'avant
        logo.vx = logo.savedVx
        logo.vy = logo.savedVy
        logo.rotationSpeed = logo.savedRotationSpeed
        logo.isPaused = false
      }
    }

    // MAPPING DES URLS OFFICIELLES
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

    // CLIC SUR LOGO = OUVERTURE PAGE OFFICIELLE
    const onLogoClick = (logo) => {
      const url = logoUrls[logo.name]
      if (url) {
        window.open(url, '_blank', 'noopener,noreferrer')
        console.log(`Ouverture de ${logo.name} : ${url}`)
      } else {
        console.warn(`URL non trouvée pour ${logo.name}`)
      }
    }

    const initializeLogos = async () => {
      // S'assurer que les logos sont chargés
      if (availableLogos.value.length === 0) {
        await loadAvailableLogos()
      }
      
      logos.value = []
      
      // Sélectionner 12 logos uniques aléatoirement
      const shuffled = [...availableLogos.value].sort(() => Math.random() - 0.5)
      const selected = shuffled.slice(0, 12)
      
      console.log('Logos sélectionnés (uniques):', selected)
      
      selected.forEach((logoName, index) => {
        logos.value.push(createLogo(logoName, index))
      })
      
      console.log(`${logos.value.length} logos créés`)
    }

    const updateLogos = () => {
      if (!props.isActive) return

      // 1. Mise à jour des positions (seulement si pas en pause)
      logos.value.forEach(logo => {
        if (!logo.isPaused) {
          logo.x += logo.vx
          logo.y += logo.vy
          logo.rotation += logo.rotationSpeed
        }
      })

      // 2. Vérifier les collisions entre logos
      for (let i = 0; i < logos.value.length; i++) {
        for (let j = i + 1; j < logos.value.length; j++) {
          const logo1 = logos.value[i]
          const logo2 = logos.value[j]
          
          // Calculer la distance entre les centres (avec dimensions réelles)
          const logo1Radius = Math.max(logo1.actualWidth, logo1.actualHeight) / 2
          const logo2Radius = Math.max(logo2.actualWidth, logo2.actualHeight) / 2
          const dx = logo1.x + logo1.actualWidth/2 - (logo2.x + logo2.actualWidth/2)
          const dy = logo1.y + logo1.actualHeight/2 - (logo2.y + logo2.actualHeight/2)
          const distance = Math.sqrt(dx * dx + dy * dy)
          const minDistance = logo1Radius + logo2Radius
          
          // Collision détectée !
          if (distance < minDistance) {
            // Calculer l'angle de collision
            const angle = Math.atan2(dy, dx)
            
            // Séparer les logos pour éviter qu'ils restent collés
            const overlap = minDistance - distance
            const separateX = Math.cos(angle) * overlap * 0.5
            const separateY = Math.sin(angle) * overlap * 0.5
            
            // SÉPARATION INTELLIGENTE : seuls les logos non-pausés bougent
            if (!logo1.isPaused) {
              logo1.x += separateX
              logo1.y += separateY
            }
            if (!logo2.isPaused) {
              logo2.x -= separateX
              logo2.y -= separateY
            }
            
            // Si les deux sont en pause ou qu'un seul peut bouger, 
            // on déplace davantage celui qui peut bouger
            if (logo1.isPaused && !logo2.isPaused) {
              logo2.x -= separateX // Double déplacement pour compenser
              logo2.y -= separateY
            } else if (!logo1.isPaused && logo2.isPaused) {
              logo1.x += separateX // Double déplacement pour compenser
              logo1.y += separateY
            }
            
            // ⚡ PHYSIQUE RÉALISTE : transfert d'énergie cinétique
            // Calculer les vitesses selon l'axe de collision
            const cos = Math.cos(angle)
            const sin = Math.sin(angle)
            
            // CAS SPÉCIAL : Collision avec logo en pause
            if (logo1.isPaused && !logo2.isPaused) {
              // Logo1 en pause, Logo2 rebondit avec boost
              const speed2 = Math.sqrt(logo2.vx * logo2.vx + logo2.vy * logo2.vy)
              const bounceBoost = 1.3 // 30% de boost pour rebond sur logo fixe
              // Rebond selon l'angle de collision (logo2 s'éloigne de logo1)
              logo2.vx = -cos * speed2 * bounceBoost
              logo2.vy = -sin * speed2 * bounceBoost
              // Logo1 reste immobile (pas de changement)
            } else if (!logo1.isPaused && logo2.isPaused) {
              // Logo2 en pause, Logo1 rebondit avec boost
              const speed1 = Math.sqrt(logo1.vx * logo1.vx + logo1.vy * logo1.vy)
              const bounceBoost = 1.3 // 30% de boost pour rebond sur logo fixe
              // Rebond selon l'angle de collision (logo1 s'éloigne de logo2)
              logo1.vx = cos * speed1 * bounceBoost
              logo1.vy = sin * speed1 * bounceBoost
              // Logo2 reste immobile (pas de changement)
            } else if (!logo1.isPaused && !logo2.isPaused) {
              // Aucun logo en pause : physique normale
              // Vitesses dans le référentiel de collision
              const v1n = logo1.vx * cos + logo1.vy * sin  // Vitesse normale logo1
              const v1t = -logo1.vx * sin + logo1.vy * cos // Vitesse tangentielle logo1
              const v2n = logo2.vx * cos + logo2.vy * sin  // Vitesse normale logo2
              const v2t = -logo2.vx * sin + logo2.vy * cos // Vitesse tangentielle logo2
              
              // Conservation de l'énergie + boost énergétique (effet astéroïde)
              const boost = 1.1 // 10% d'énergie en plus à chaque collision !
              const newV1n = v2n * boost
              const newV2n = v1n * boost
              
              // Reconvertir dans le référentiel global
              logo1.vx = newV1n * cos - v1t * sin
              logo1.vy = newV1n * sin + v1t * cos
              logo2.vx = newV2n * cos - v2t * sin
              logo2.vy = newV2n * sin + v2t * cos
            }
            // Si les deux sont en pause, aucun changement
            
            // Limiter la vitesse max pour éviter que ça devienne fou
            const maxSpeed = 3
            const logo1Speed = Math.sqrt(logo1.vx * logo1.vx + logo1.vy * logo1.vy)
            const logo2Speed = Math.sqrt(logo2.vx * logo2.vx + logo2.vy * logo2.vy)
            
            if (logo1Speed > maxSpeed) {
              logo1.vx = (logo1.vx / logo1Speed) * maxSpeed
              logo1.vy = (logo1.vy / logo1Speed) * maxSpeed
            }
            if (logo2Speed > maxSpeed) {
              logo2.vx = (logo2.vx / logo2Speed) * maxSpeed
              logo2.vy = (logo2.vy / logo2Speed) * maxSpeed
            }
          }
        }
      }

      // 3. Rebonds sur les bords avec perte d'énergie (réalisme)
      logos.value.forEach(logo => {
        // Facteur d'absorption des parois (comme dans la vraie vie)
        const wallDamping = 0.85 // Les parois absorbent 15% de l'énergie
        
        // Rebond horizontal (murs gauche/droit) - avec dimensions réelles
        if (logo.x <= 0 || logo.x >= containerBounds.value.width - logo.actualWidth) {
          logo.vx = -logo.vx * wallDamping // Inversion + perte d'énergie
          logo.x = Math.max(0, Math.min(logo.x, containerBounds.value.width - logo.actualWidth))
        }

        // Rebond vertical (murs haut/bas) - avec dimensions réelles
        if (logo.y <= containerBounds.value.headerHeight || 
            logo.y >= containerBounds.value.height - containerBounds.value.footerHeight - logo.actualHeight) {
          logo.vy = -logo.vy * wallDamping // Inversion + perte d'énergie
          logo.y = Math.max(containerBounds.value.headerHeight, 
                           Math.min(logo.y, containerBounds.value.height - containerBounds.value.footerHeight - logo.actualHeight))
        }
      })

      animationId.value = requestAnimationFrame(updateLogos)
    }

    const updateContainerBounds = () => {
      // 🔍 MESURE AUTOMATIQUE DES ZONES D'EXCLUSION
      let realHeaderHeight = 80  // Valeur par défaut
      let realFooterHeight = 95  // Valeur par défaut réduite de 5px (100→95)
      
      try {
        // Chercher le header/navbar
        const header = document.querySelector('header, .navbar, .header')
        if (header) {
          realHeaderHeight = header.offsetHeight + 10 // +10px de marge sécurité
          console.log(`📏 Header détecté: ${realHeaderHeight}px`)
        }
        
        // Chercher le footer
        const footer = document.querySelector('footer, .footer')
        if (footer) {
          realFooterHeight = footer.offsetHeight + 8 // +8px de marge sécurité (réduit de 10 à 5)
          console.log(`📏 Footer détecté: ${realFooterHeight}px`)
        }
        
        // Chercher spécifiquement le ticker todo (peut-être dans le header)
        const todoTicker = document.querySelector('[class*="ticker"], [class*="todo"], .bloomberg-ticker')
        if (todoTicker) {
          const tickerBottom = todoTicker.offsetTop + todoTicker.offsetHeight
          realHeaderHeight = Math.max(realHeaderHeight, tickerBottom + 10)
          console.log(`📏 Ticker todo détecté: zone exclusion jusqu'à ${realHeaderHeight}px`)
        }
        
      } catch (error) {
        console.warn('Erreur mesure DOM, utilisation valeurs par défaut')
      }
      
      containerBounds.value = {
        width: window.innerWidth,
        height: window.innerHeight,
        headerHeight: realHeaderHeight,
        footerHeight: realFooterHeight
      }
      
      console.log(`📐 Zones d'animation: Y=${realHeaderHeight}px à Y=${window.innerHeight - realFooterHeight}px`)
    }

    const handleResize = () => {
      updateContainerBounds()
      // Repositionner les logos qui seraient hors zone après resize
      logos.value.forEach(logo => {
        if (logo.y < containerBounds.value.headerHeight) {
          logo.y = containerBounds.value.headerHeight + 10
        }
        if (logo.y > containerBounds.value.height - containerBounds.value.footerHeight - logo.size) {
          logo.y = containerBounds.value.height - containerBounds.value.footerHeight - logo.size - 10
        }
      })
    }

    onMounted(async () => {
      // Attendre un peu que le DOM soit stable
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

/* Tooltip hover */
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