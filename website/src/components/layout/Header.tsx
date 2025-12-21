import { useState } from 'react';
import { GlassButton } from '../ui/GlassButton';
import { copy } from '../../data/copy';

const navItems = [
  { id: 'features', label: 'Features', href: '#features' },
  { id: 'screenshots', label: 'Screenshots', href: '#screenshots' },
  { id: 'faq', label: 'FAQ', href: '#faq' },
  { id: 'about', label: 'About', href: '#about' },
];

export function Header() {
  const [isMenuOpen, setIsMenuOpen] = useState(false);

  return (
    <header className="header">
      <div className="container header__container">
        <a href="/" className="header__logo">
          <span className="header__logo-icon">◇</span>
          <span className="header__logo-text">PrismCalc</span>
        </a>

        <nav className={`header__nav ${isMenuOpen ? 'header__nav--open' : ''}`}>
          {navItems.map((item) => (
            <a
              key={item.id}
              href={item.href}
              className="header__nav-link"
              onClick={() => setIsMenuOpen(false)}
            >
              {item.label}
            </a>
          ))}
        </nav>

        <div className="header__actions">
          <GlassButton
            variant="primary"
            size="default"
            href={copy.appStore.url}
          >
            Download
          </GlassButton>

          <button
            className="header__menu-toggle"
            onClick={() => setIsMenuOpen(!isMenuOpen)}
            aria-label="Toggle menu"
            aria-expanded={isMenuOpen}
          >
            <span className="header__menu-icon">{isMenuOpen ? '✕' : '☰'}</span>
          </button>
        </div>
      </div>
    </header>
  );
}
