import { useState } from 'react';
import { copy } from '../../data/copy';

const navItems = [
  { id: 'features', label: 'Features', href: '#features' },
  { id: 'faq', label: 'FAQ', href: '#faq' },
  { id: 'about', label: 'About', href: '#about' },
];

export function Header() {
  const [isMenuOpen, setIsMenuOpen] = useState(false);

  return (
    <header className="header-floating">
      <nav className="header-pill">
        {/* Logo */}
        <a href="/" className="header-pill__logo">
          <span className="header-pill__icon">◇</span>
          <span className="header-pill__name">PrismCalc</span>
        </a>

        {/* Desktop Nav */}
        <div className="header-pill__nav">
          {navItems.map((item) => (
            <a
              key={item.id}
              href={item.href}
              className="header-pill__link"
            >
              {item.label}
            </a>
          ))}
        </div>

        {/* Download Button */}
        <a
          href={copy.appStore.url}
          className="header-pill__cta"
        >
          Download
        </a>

        {/* Mobile Menu Toggle */}
        <button
          className="header-pill__toggle"
          onClick={() => setIsMenuOpen(!isMenuOpen)}
          aria-label="Toggle menu"
          aria-expanded={isMenuOpen}
        >
          {isMenuOpen ? '✕' : '☰'}
        </button>
      </nav>

      {/* Mobile Menu */}
      {isMenuOpen && (
        <div className="header-mobile">
          {navItems.map((item) => (
            <a
              key={item.id}
              href={item.href}
              className="header-mobile__link"
              onClick={() => setIsMenuOpen(false)}
            >
              {item.label}
            </a>
          ))}
          <a
            href={copy.appStore.url}
            className="header-mobile__cta"
            onClick={() => setIsMenuOpen(false)}
          >
            Download on App Store
          </a>
        </div>
      )}
    </header>
  );
}
