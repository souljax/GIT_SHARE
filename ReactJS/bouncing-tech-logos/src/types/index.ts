// TypeScript definitions for Bouncing Tech Logos React component

export interface Logo {
  id: number;
  src: string;
  url: string;
  alt: string;
  x: number;
  y: number;
  vx: number;
  vy: number;
  width: number;
  height: number;
  isPaused: boolean;
}

export interface ContainerBounds {
  headerHeight?: number;
  footerHeight?: number;
  width?: number;
  height?: number;
}

export interface PhysicsConfig {
  gravity?: number;
  friction?: number;
  bounceEnergy?: number;
  wallBoost?: number;
  maxSpeed?: number;
  maxWallSpeed?: number;
}

export interface BouncingLogosProps {
  isActive?: boolean;
  logoCount?: number;
  tooltipText?: string;
  containerBounds?: ContainerBounds;
  physicsConfig?: PhysicsConfig;
  customLogos?: Array<{
    src: string;
    url: string;
    alt: string;
  }>;
}

export interface TechLogo {
  src: string;
  url: string;
  alt: string;
}

// Animation frame callback type
export type AnimationCallback = (timestamp: number) => void;

// Event handler types
export type LogoClickHandler = (url: string) => void;
export type LogoHoverHandler = (logoId: number, isHovered: boolean) => void;

// Component ref types
export interface BouncingLogosRef {
  pause: () => void;
  resume: () => void;
  reset: () => void;
  getLogos: () => Logo[];
  updatePhysics: (config: Partial<PhysicsConfig>) => void;
}

export default BouncingLogosProps;