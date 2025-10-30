import React, { useState } from 'react';
import BouncingLogos from './components/BouncingLogos/BouncingLogos';
import './App.css';

function App() {
  const [isActive] = useState(true);
  const [logoCount] = useState(3);

  return (
    <div className="app">
      {/* Header */}
      <div className="header">
        HEADER
      </div>

      {/* Main Content Area */}
      <div className="content">
        {/* Test Info */}
        <div className="test-info">
          <p><strong>🎮 Interactive Test:</strong></p>
          <p>🖱️ <strong>Hover</strong> on logo = Pause movement</p>
          <p>🖱️ <strong>Click</strong> on logo = Visit website</p>
          <p>⚡ Enhanced React version with energy-boosting physics!</p>
        </div>

        {/* Bouncing Logos Component */}
        {isActive && (
          <BouncingLogos 
            isActive={isActive}
            logoCount={logoCount}
            tooltipText="Visit technology website"
            containerBounds={{ 
              headerHeight: 55, 
              footerHeight: 55 
            }}
          />
        )}
      </div>

      {/* Footer */}
      <div className="footer">
        FOOTER
      </div>
    </div>
  );
}

export default App;