import React, { useState, useEffect, useRef, useCallback } from 'react';
import './BouncingLogos.css';

interface Logo {
  id: number;
  name: string;
  src: string;
  x: number;
  y: number;
  vx: number;
  vy: number;
  rotation: number;
  rotationSpeed: number;
  opacity: number;
  baseSize: number;
  actualWidth: number;
  actualHeight: number;
  imageLoaded: boolean;
  isPaused: boolean;
  savedVx: number;
  savedVy: number;
  savedRotationSpeed: number;
}

interface ContainerBounds {
  width: number;
  height: number;
  headerHeight: number;
  footerHeight: number;
}

interface BouncingLogosProps {
  isActive?: boolean;
  logoCount?: number;
  tooltipText?: string;
  containerBounds?: { headerHeight: number; footerHeight: number };
}

const BouncingLogos: React.FC<BouncingLogosProps> = ({
  isActive = true,
  logoCount = 3,
  tooltipText = 'go to website',
  containerBounds: propBounds = { headerHeight: 80, footerHeight: 100 }
}) => {
  const [logos, setLogos] = useState<Logo[]>([]);
  const animationIdRef = useRef<number | null>(null);
  const containerBoundsRef = useRef<ContainerBounds>({
    width: window.innerWidth,
    height: window.innerHeight,
    headerHeight: propBounds.headerHeight,
    footerHeight: propBounds.footerHeight
  });

  // Logos tech sélectionnés pour commencer : React, JavaScript, TypeScript
  const availableLogos = [
    'react.png',
    'js.png',
    'typescript.png'
  ];

  // URLs vers pages officielles des technologies
  const logoUrls: Record<string, string> = {
    'react.png': 'https://react.dev/',
    'js.png': 'https://developer.mozilla.org/en-US/docs/Web/JavaScript',
    'typescript.png': 'https://www.typescriptlang.org/'
  };

  const createLogo = useCallback((logoName: string, index: number): Logo => {
    const baseSize = 50;
    const bounds = containerBoundsRef.current;
    
    const x = Math.random() * (bounds.width - baseSize * 1.5);
    const y = bounds.headerHeight + Math.random() * 
              (bounds.height - bounds.headerHeight - bounds.footerHeight - baseSize * 1.5);

    return {
      id: index,
      name: logoName,
      src: `./logos/bouncing_logos/${logoName}`,
      x: x,
      y: y,
      vx: (Math.random() - 0.5) * 1.5, // Vitesse de départ augmentée (1.15 → 1.5)
      vy: (Math.random() - 0.5) * 1.5, // Vitesse de départ augmentée (1.15 → 1.5)
      rotation: 0,
      rotationSpeed: (Math.random() - 0.5) * 1.44, // +15% de rotation (1.25 → 1.44)
      opacity: Math.random() * 0.2 + 0.8,
      baseSize: baseSize,
      actualWidth: baseSize,
      actualHeight: baseSize,
      imageLoaded: false,
      isPaused: false,
      savedVx: 0,
      savedVy: 0,
      savedRotationSpeed: 0
    };
  }, []);

  const updateContainerBounds = useCallback(() => {
    let realHeaderHeight = propBounds.headerHeight;
    let realFooterHeight = propBounds.footerHeight;
    
    try {
      const header = document.querySelector('header, .navbar, .header, .explorer-header');
      if (header) {
        realHeaderHeight = header.getBoundingClientRect().height + 10;
        console.log(`📏 Header détecté: ${realHeaderHeight}px`);
      }
      
      const footer = document.querySelector('footer, .footer, .explorer-footer');
      if (footer) {
        realFooterHeight = footer.getBoundingClientRect().height + 8;
        console.log(`📏 Footer détecté: ${realFooterHeight}px`);
      }
    } catch (error) {
      console.warn('Erreur mesure DOM, utilisation valeurs par défaut');
    }
    
    containerBoundsRef.current = {
      width: window.innerWidth,
      height: window.innerHeight,
      headerHeight: realHeaderHeight,
      footerHeight: realFooterHeight
    };
    
    console.log(`📐 Zones d'animation: Y=${realHeaderHeight}px à Y=${window.innerHeight - realFooterHeight}px`);
  }, [propBounds]);

  const initializeLogos = useCallback(() => {
    const shuffled = [...availableLogos].sort(() => Math.random() - 0.5);
    const selected = shuffled.slice(0, logoCount);
    
    console.log('🎨 BOUNCING LOGOS - Initialisation:', { isActive, logoCount, selected });
    
    const newLogos = selected.map((logoName, index) => createLogo(logoName, index));
    setLogos(newLogos);
    
    console.log(`🎨 ${newLogos.length} logos tech créés:`, newLogos);
  }, [createLogo, logoCount, isActive]);

  const handleImageLoad = useCallback((event: React.SyntheticEvent<HTMLImageElement>, logoId: number) => {
    const img = event.target as HTMLImageElement;
    const naturalWidth = img.naturalWidth;
    const naturalHeight = img.naturalHeight;
    
    if (naturalWidth && naturalHeight) {
      setLogos(prev => prev.map(logo => {
        if (logo.id === logoId) {
          const aspectRatio = naturalWidth / naturalHeight;
          let actualWidth, actualHeight;
          
          if (aspectRatio > 1.2) {
            actualWidth = logo.baseSize * 1.2;
            actualHeight = actualWidth / aspectRatio;
          } else if (aspectRatio < 0.8) {
            actualHeight = logo.baseSize * 1.2;
            actualWidth = actualHeight * aspectRatio;
          } else {
            actualWidth = logo.baseSize;
            actualHeight = logo.baseSize;
          }
          
          return {
            ...logo,
            actualWidth,
            actualHeight,
            imageLoaded: true
          };
        }
        return logo;
      }));
      
      console.log(`🖼️ ${logoId}: ${naturalWidth}x${naturalHeight} → dimensions ajustées`);
    }
  }, []);

  const handleImageError = useCallback((logoId: number) => {
    console.warn(`Erreur chargement logo tech: ${logoId}`);
    setLogos(prev => prev.map(logo => {
      if (logo.id === logoId) {
        return {
          ...logo,
          actualWidth: logo.baseSize,
          actualHeight: logo.baseSize,
          imageLoaded: true
        };
      }
      return logo;
    }));
  }, []);

  const handleLogoHover = useCallback((logoId: number) => {
    setLogos(prev => prev.map(logo => {
      if (logo.id === logoId && !logo.isPaused) {
        return {
          ...logo,
          savedVx: logo.vx,
          savedVy: logo.vy,
          savedRotationSpeed: logo.rotationSpeed,
          vx: 0,
          vy: 0,
          rotationSpeed: 0,
          rotation: 0,
          isPaused: true
        };
      }
      return logo;
    }));
  }, []);

  const handleLogoLeave = useCallback((logoId: number) => {
    setLogos(prev => prev.map(logo => {
      if (logo.id === logoId && logo.isPaused) {
        return {
          ...logo,
          vx: logo.savedVx,
          vy: logo.savedVy,
          rotationSpeed: logo.savedRotationSpeed,
          isPaused: false
        };
      }
      return logo;
    }));
  }, []);

  const handleLogoClick = useCallback((logoName: string) => {
    const url = logoUrls[logoName];
    if (url) {
      window.open(url, '_blank', 'noopener,noreferrer');
      console.log(`🔗 Ouverture de ${logoName}: ${url}`);
    } else {
      console.warn(`URL non trouvée pour ${logoName}`);
    }
  }, []);

  const updateLogos = useCallback(() => {
    if (!isActive) return;

    setLogos(prev => {
      const newLogos = [...prev];
      const bounds = containerBoundsRef.current;

      // 1. Mise à jour des positions
      newLogos.forEach(logo => {
        if (!logo.isPaused) {
          logo.x += logo.vx;
          logo.y += logo.vy;
          logo.rotation += logo.rotationSpeed;
        }
      });

      // 2. Vérifier les collisions entre logos
      for (let i = 0; i < newLogos.length; i++) {
        for (let j = i + 1; j < newLogos.length; j++) {
          const logo1 = newLogos[i];
          const logo2 = newLogos[j];
          
          const logo1Radius = Math.max(logo1.actualWidth, logo1.actualHeight) / 2;
          const logo2Radius = Math.max(logo2.actualWidth, logo2.actualHeight) / 2;
          const dx = logo1.x + logo1.actualWidth/2 - (logo2.x + logo2.actualWidth/2);
          const dy = logo1.y + logo1.actualHeight/2 - (logo2.y + logo2.actualHeight/2);
          const distance = Math.sqrt(dx * dx + dy * dy);
          const minDistance = logo1Radius + logo2Radius;
          
          if (distance < minDistance) {
            const angle = Math.atan2(dy, dx);
            const overlap = minDistance - distance;
            const separateX = Math.cos(angle) * overlap * 0.5;
            const separateY = Math.sin(angle) * overlap * 0.5;
            
            // Séparation intelligente
            if (!logo1.isPaused) {
              logo1.x += separateX;
              logo1.y += separateY;
            }
            if (!logo2.isPaused) {
              logo2.x -= separateX;
              logo2.y -= separateY;
            }
            
            // Physique réaliste
            const cos = Math.cos(angle);
            const sin = Math.sin(angle);
            
            if (logo1.isPaused && !logo2.isPaused) {
              const speed2 = Math.sqrt(logo2.vx * logo2.vx + logo2.vy * logo2.vy);
              const bounceBoost = 1.50; // +15% de boost (1.3 → 1.50)
              logo2.vx = -cos * speed2 * bounceBoost;
              logo2.vy = -sin * speed2 * bounceBoost;
            } else if (!logo1.isPaused && logo2.isPaused) {
              const speed1 = Math.sqrt(logo1.vx * logo1.vx + logo1.vy * logo1.vy);
              const bounceBoost = 1.50; // +15% de boost (1.3 → 1.50)
              logo1.vx = cos * speed1 * bounceBoost;
              logo1.vy = sin * speed1 * bounceBoost;
            } else if (!logo1.isPaused && !logo2.isPaused) {
              // Collision normale
              const v1n = logo1.vx * cos + logo1.vy * sin;
              const v1t = -logo1.vx * sin + logo1.vy * cos;
              const v2n = logo2.vx * cos + logo2.vy * sin;
              const v2t = -logo2.vx * sin + logo2.vy * cos;
              
              const boost = 1.27; // +15% de boost d'énergie (1.1 → 1.27)
              const newV1n = v2n * boost;
              const newV2n = v1n * boost;
              
              logo1.vx = newV1n * cos - v1t * sin;
              logo1.vy = newV1n * sin + v1t * cos;
              logo2.vx = newV2n * cos - v2t * sin;
              logo2.vy = newV2n * sin + v2t * cos;
            }
            
            // Limiter la vitesse max
            const maxSpeed = 3.45; // +15% de vitesse max (3.0 → 3.45)
            [logo1, logo2].forEach(logo => {
              const speed = Math.sqrt(logo.vx * logo.vx + logo.vy * logo.vy);
              if (speed > maxSpeed) {
                logo.vx = (logo.vx / speed) * maxSpeed;
                logo.vy = (logo.vy / speed) * maxSpeed;
              }
            });
          }
        }
      }

      // 3. Rebonds sur les bords avec GAIN d'énergie (effet inverse) + LIMITE DE SÉCURITÉ
      newLogos.forEach(logo => {
        const wallBoost = 1.10; // +25% d'énergie au lieu de -15% (inverse de 0.85)
        const maxWallSpeed = 3.75; // PLAFOND AUGMENTÉ pour rebonds plus énergiques ! (4.0 → 5.0)
        
        // Rebond horizontal avec BOOST d'énergie
        if (logo.x <= 0 || logo.x >= bounds.width - logo.actualWidth) {
          logo.vx = -logo.vx * wallBoost; // Inversion + GAIN d'énergie
          logo.x = Math.max(0, Math.min(logo.x, bounds.width - logo.actualWidth));
          
          // SÉCURITÉ : Limiter la vitesse après rebond
          if (Math.abs(logo.vx) > maxWallSpeed) {
            logo.vx = Math.sign(logo.vx) * maxWallSpeed;
          }
        }
        
        // Rebond vertical avec BOOST d'énergie
        if (logo.y <= bounds.headerHeight || 
            logo.y >= bounds.height - bounds.footerHeight - logo.actualHeight) {
          logo.vy = -logo.vy * wallBoost; // Inversion + GAIN d'énergie
          logo.y = Math.max(bounds.headerHeight, 
                           Math.min(logo.y, bounds.height - bounds.footerHeight - logo.actualHeight));
          
          // SÉCURITÉ : Limiter la vitesse après rebond
          if (Math.abs(logo.vy) > maxWallSpeed) {
            logo.vy = Math.sign(logo.vy) * maxWallSpeed;
          }
        }
      });

      return newLogos;
    });

    animationIdRef.current = requestAnimationFrame(updateLogos);
  }, [isActive]);

  const handleResize = useCallback(() => {
    updateContainerBounds();
    setLogos(prev => prev.map(logo => {
      const bounds = containerBoundsRef.current;
      let newY = logo.y;
      
      if (logo.y < bounds.headerHeight) {
        newY = bounds.headerHeight + 10;
      }
      if (logo.y > bounds.height - bounds.footerHeight - logo.actualHeight) {
        newY = bounds.height - bounds.footerHeight - logo.actualHeight - 10;
      }
      
      return { ...logo, y: newY };
    }));
  }, [updateContainerBounds]);

  useEffect(() => {
    const init = async () => {
      await new Promise(resolve => setTimeout(resolve, 100));
      updateContainerBounds();
      initializeLogos();
      updateLogos();
      window.addEventListener('resize', handleResize);
    };
    
    init();
    
    return () => {
      if (animationIdRef.current) {
        cancelAnimationFrame(animationIdRef.current);
      }
      window.removeEventListener('resize', handleResize);
    };
  }, [updateContainerBounds, initializeLogos, updateLogos, handleResize]);

  if (!isActive) return null;

  return (
    <div className="bouncing-logos-container">
      {logos.map((logo) => (
        <div
          key={logo.id}
          className="bouncing-logo"
          onMouseEnter={() => handleLogoHover(logo.id)}
          onMouseLeave={() => handleLogoLeave(logo.id)}
          onClick={() => handleLogoClick(logo.name)}
          style={{
            left: `${logo.x}px`,
            top: `${logo.y}px`,
            transform: `rotate(${logo.rotation}deg)`,
            opacity: logo.opacity,
            width: `${logo.actualWidth}px`,
            height: `${logo.actualHeight}px`
          }}
        >
          <img
            src={logo.src}
            alt={logo.name}
            className="logo-image"
            onLoad={(e) => handleImageLoad(e, logo.id)}
            onError={() => handleImageError(logo.id)}
          />
          
          {logo.isPaused && (
            <div 
              className="logo-tooltip"
              style={{
                top: `${logo.actualHeight + 5}px`
              }}
            >
              {tooltipText}
            </div>
          )}
        </div>
      ))}
    </div>
  );
};

export default BouncingLogos;