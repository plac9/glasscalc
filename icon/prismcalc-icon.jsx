import React from 'react';

export default function PrismCalcIcon() {
  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-900 via-slate-800 to-slate-900 flex items-center justify-center p-8">
      <div className="flex flex-col items-center gap-8">
        {/* Main Icon Container */}
        <div className="relative">
          {/* Outer glow */}
          <div className="absolute inset-0 rounded-[60px] bg-gradient-to-br from-white/20 to-white/5 blur-xl scale-110" />
          
          {/* Squircle Background - Frosted Glass */}
          <div 
            className="relative w-80 h-80 rounded-[60px] overflow-hidden"
            style={{
              background: 'linear-gradient(145deg, rgba(255,255,255,0.15) 0%, rgba(255,255,255,0.05) 100%)',
              backdropFilter: 'blur(40px)',
              boxShadow: `
                0 0 0 1px rgba(255,255,255,0.2),
                inset 0 1px 0 rgba(255,255,255,0.3),
                0 25px 50px -12px rgba(0,0,0,0.5),
                0 0 100px rgba(255,255,255,0.1)
              `
            }}
          >
            {/* Inner frost texture */}
            <div 
              className="absolute inset-0"
              style={{
                background: 'radial-gradient(ellipse at 30% 20%, rgba(255,255,255,0.15) 0%, transparent 50%)',
              }}
            />
            
            {/* Light beam entering from left */}
            <div 
              className="absolute"
              style={{
                left: '10px',
                top: '50%',
                transform: 'translateY(-50%)',
                width: '80px',
                height: '8px',
                background: 'linear-gradient(90deg, rgba(255,255,255,0) 0%, rgba(255,255,255,0.9) 40%, rgba(255,255,255,1) 100%)',
                filter: 'blur(2px)',
                boxShadow: '0 0 20px rgba(255,255,255,0.8), 0 0 40px rgba(255,255,255,0.4)'
              }}
            />
            
            {/* Glass Prism - SVG */}
            <svg 
              viewBox="0 0 200 200" 
              className="absolute left-1/2 top-1/2 -translate-x-1/2 -translate-y-1/2 w-40 h-40"
              style={{ filter: 'drop-shadow(0 10px 30px rgba(0,0,0,0.3))' }}
            >
              <defs>
                {/* Prism gradient */}
                <linearGradient id="prismFace1" x1="0%" y1="0%" x2="100%" y2="100%">
                  <stop offset="0%" stopColor="rgba(255,255,255,0.4)" />
                  <stop offset="50%" stopColor="rgba(255,255,255,0.15)" />
                  <stop offset="100%" stopColor="rgba(255,255,255,0.3)" />
                </linearGradient>
                <linearGradient id="prismFace2" x1="100%" y1="0%" x2="0%" y2="100%">
                  <stop offset="0%" stopColor="rgba(255,255,255,0.2)" />
                  <stop offset="100%" stopColor="rgba(255,255,255,0.05)" />
                </linearGradient>
                <linearGradient id="prismEdge" x1="0%" y1="0%" x2="100%" y2="0%">
                  <stop offset="0%" stopColor="rgba(255,255,255,0.6)" />
                  <stop offset="100%" stopColor="rgba(255,255,255,0.2)" />
                </linearGradient>
              </defs>
              
              {/* Back face */}
              <polygon 
                points="100,30 160,150 40,150" 
                fill="url(#prismFace2)"
                stroke="rgba(255,255,255,0.3)"
                strokeWidth="1"
              />
              
              {/* Left face */}
              <polygon 
                points="100,30 40,150 70,160" 
                fill="url(#prismFace1)"
                stroke="rgba(255,255,255,0.4)"
                strokeWidth="0.5"
              />
              
              {/* Right face - brighter */}
              <polygon 
                points="100,30 160,150 130,160" 
                fill="rgba(255,255,255,0.25)"
                stroke="rgba(255,255,255,0.5)"
                strokeWidth="0.5"
              />
              
              {/* Top edge highlight */}
              <line 
                x1="100" y1="30" x2="100" y2="35" 
                stroke="rgba(255,255,255,0.8)" 
                strokeWidth="2"
                strokeLinecap="round"
              />
              
              {/* Internal refraction lines */}
              <line x1="80" y1="80" x2="120" y2="130" stroke="rgba(255,255,255,0.15)" strokeWidth="0.5" />
              <line x1="90" y1="70" x2="110" y2="140" stroke="rgba(255,255,255,0.1)" strokeWidth="0.5" />
            </svg>
            
            {/* Rainbow refracted light - 3x3 grid */}
            <div 
              className="absolute grid grid-cols-3 gap-2"
              style={{
                right: '30px',
                top: '50%',
                transform: 'translateY(-50%)',
                width: '90px',
                height: '90px'
              }}
            >
              {/* Row 1 */}
              <div className="rounded-lg" style={{ background: 'linear-gradient(135deg, #ff6b6b, #ee5a5a)', boxShadow: '0 0 15px rgba(255,107,107,0.6), 0 0 30px rgba(255,107,107,0.3)' }} />
              <div className="rounded-lg" style={{ background: 'linear-gradient(135deg, #ffa94d, #ff922b)', boxShadow: '0 0 15px rgba(255,169,77,0.6), 0 0 30px rgba(255,169,77,0.3)' }} />
              <div className="rounded-lg" style={{ background: 'linear-gradient(135deg, #ffd43b, #fab005)', boxShadow: '0 0 15px rgba(255,212,59,0.6), 0 0 30px rgba(255,212,59,0.3)' }} />
              
              {/* Row 2 */}
              <div className="rounded-lg" style={{ background: 'linear-gradient(135deg, #69db7c, #51cf66)', boxShadow: '0 0 15px rgba(105,219,124,0.6), 0 0 30px rgba(105,219,124,0.3)' }} />
              <div className="rounded-lg" style={{ background: 'linear-gradient(135deg, #4dabf7, #339af0)', boxShadow: '0 0 15px rgba(77,171,247,0.6), 0 0 30px rgba(77,171,247,0.3)' }} />
              <div className="rounded-lg" style={{ background: 'linear-gradient(135deg, #748ffc, #5c7cfa)', boxShadow: '0 0 15px rgba(116,143,252,0.6), 0 0 30px rgba(116,143,252,0.3)' }} />
              
              {/* Row 3 */}
              <div className="rounded-lg" style={{ background: 'linear-gradient(135deg, #9775fa, #845ef7)', boxShadow: '0 0 15px rgba(151,117,250,0.6), 0 0 30px rgba(151,117,250,0.3)' }} />
              <div className="rounded-lg" style={{ background: 'linear-gradient(135deg, #da77f2, #cc5de8)', boxShadow: '0 0 15px rgba(218,119,242,0.6), 0 0 30px rgba(218,119,242,0.3)' }} />
              <div className="rounded-lg" style={{ background: 'linear-gradient(135deg, #f783ac, #f06595)', boxShadow: '0 0 15px rgba(247,131,172,0.6), 0 0 30px rgba(247,131,172,0.3)' }} />
            </div>
            
            {/* Volumetric light rays from prism to grid */}
            <svg 
              className="absolute inset-0 w-full h-full pointer-events-none"
              style={{ opacity: 0.4 }}
            >
              <defs>
                <linearGradient id="ray1" x1="0%" y1="0%" x2="100%" y2="0%">
                  <stop offset="0%" stopColor="transparent" />
                  <stop offset="30%" stopColor="#ff6b6b" />
                  <stop offset="100%" stopColor="transparent" />
                </linearGradient>
                <linearGradient id="ray2" x1="0%" y1="0%" x2="100%" y2="0%">
                  <stop offset="0%" stopColor="transparent" />
                  <stop offset="30%" stopColor="#69db7c" />
                  <stop offset="100%" stopColor="transparent" />
                </linearGradient>
                <linearGradient id="ray3" x1="0%" y1="0%" x2="100%" y2="0%">
                  <stop offset="0%" stopColor="transparent" />
                  <stop offset="30%" stopColor="#5c7cfa" />
                  <stop offset="100%" stopColor="transparent" />
                </linearGradient>
              </defs>
              {/* Light rays */}
              <line x1="170" y1="115" x2="250" y2="105" stroke="url(#ray1)" strokeWidth="3" />
              <line x1="170" y1="160" x2="250" y2="160" stroke="url(#ray2)" strokeWidth="3" />
              <line x1="170" y1="205" x2="250" y2="215" stroke="url(#ray3)" strokeWidth="3" />
            </svg>
            
            {/* Subtle noise texture overlay */}
            <div 
              className="absolute inset-0 opacity-[0.03]"
              style={{
                backgroundImage: `url("data:image/svg+xml,%3Csvg viewBox='0 0 256 256' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='noise'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23noise)'/%3E%3C/svg%3E")`,
              }}
            />
          </div>
        </div>
        
        {/* Label */}
        <div className="text-center">
          <h1 className="text-2xl font-light text-white/90 tracking-wider">PrismCalc</h1>
          <p className="text-sm text-white/50 mt-1">App Icon Concept</p>
        </div>
        
        {/* Size variants preview */}
        <div className="flex gap-6 items-end mt-8">
          {[120, 80, 60, 40].map((size) => (
            <div key={size} className="flex flex-col items-center gap-2">
              <div 
                className="rounded-[20%] overflow-hidden"
                style={{
                  width: size,
                  height: size,
                  background: 'linear-gradient(145deg, rgba(255,255,255,0.15) 0%, rgba(255,255,255,0.05) 100%)',
                  boxShadow: '0 0 0 1px rgba(255,255,255,0.2), 0 8px 16px rgba(0,0,0,0.3)',
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center'
                }}
              >
                <div 
                  className="w-2/3 h-2/3 grid grid-cols-3 gap-[2px]"
                >
                  {['#ff6b6b','#ffa94d','#ffd43b','#69db7c','#4dabf7','#748ffc','#9775fa','#da77f2','#f783ac'].map((color, i) => (
                    <div 
                      key={i} 
                      className="rounded-sm"
                      style={{ 
                        background: color,
                        boxShadow: `0 0 ${size/20}px ${color}40`
                      }} 
                    />
                  ))}
                </div>
              </div>
              <span className="text-xs text-white/40">{size}px</span>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}
