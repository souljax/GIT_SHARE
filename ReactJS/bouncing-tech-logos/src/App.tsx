import React, { useState } from 'react';
import BouncingLogos from './components/BouncingLogos/BouncingLogos';
import './App.css';

function App() {
  const [isActive, setIsActive] = useState(true);
  const [logoCount, setLogoCount] = useState(3);

  return (
    <div className="app">
      {/* Header */}
      <header className="app-header">
        <div className="container">
          <h1>🚀 Bouncing Tech Logos - React Edition</h1>
          <p>Interactive demonstration with enhanced physics</p>
        </div>
      </header>

      {/* Controls */}
      <div className="controls-panel">
        <div className="container">
          <div className="controls-grid">
            <div className="control-group">
              <label>
                <input 
                  type="checkbox" 
                  checked={isActive}
                  onChange={(e) => setIsActive(e.target.checked)}
                />
                Enable Bouncing Logos
              </label>
            </div>
            
            <div className="control-group">
              <label>
                Logo Count: 
                <input 
                  type="range" 
                  min="1" 
                  max="15" 
                  value={logoCount}
                  onChange={(e) => setLogoCount(parseInt(e.target.value))}
                />
                <span className="range-value">{logoCount}</span>
              </label>
            </div>

            <div className="info-group">
              <p>🖱️ <strong>Hover</strong> to pause • 🖱️ <strong>Click</strong> to visit website</p>
              <p>⚡ <strong>Enhanced:</strong> 30% faster + energy-boosting walls!</p>
            </div>
          </div>
        </div>
      </div>

      {/* Main Content Area - Card à gauche */}
      <main className="main-content">
        <div className="container">
          <div className="content-card">
            <div className="demo-section">
              <h2>Interactive Demo</h2>
              <p>
                This React component features realistic physics simulation with enhanced performance. 
                Logos bounce around the screen, freeze when hovered, and accelerate when hitting walls.
              </p>
            </div>
          </div>
        </div>
      </main>

      {/* Bouncing Logos Component */}
      {isActive && (
        <BouncingLogos 
          isActive={isActive}
          logoCount={logoCount}
          tooltipText="Visit technology website"
          containerBounds={{ 
            headerHeight: 120, 
            footerHeight: 80 
          }}
        />
      )}

      {/* Footer */}
      <footer className="app-footer">
        <div className="container">
          <p>&copy; 2024 SOULJAX - Enhanced React Edition</p>
          <p>
            <a href="https://souljax.com" target="_blank" rel="noopener noreferrer">
              Visit SOULJAX.com
            </a>
          </p>
        </div>
      </footer>
    </div>
  );
}

export default App;