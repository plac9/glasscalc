import { GlassButton } from '../ui/GlassButton';
import { copy } from '../../data/copy';

export function Hero() {
  return (
    <section className="hero">
      <div className="container hero__container">
        <div className="hero__content fade-in-up">
          <h1 className="hero__title">{copy.tagline}</h1>
          <p className="hero__subtitle">{copy.heroSubtitle}</p>

          <div className="hero__cta">
            <a
              href={copy.appStore.url}
              target="_blank"
              rel="noopener noreferrer"
              className="app-store-badge pulse"
            >
              <img
                src="https://tools.applemediaservices.com/api/badges/download-on-the-app-store/black/en-us?size=250x83"
                alt="Download on the App Store"
                loading="eager"
              />
            </a>
            <GlassButton variant="secondary" href="#features">
              Learn More
            </GlassButton>
          </div>

          <div className="hero__badges">
            <span className="hero__badge">iOS 18+</span>
            <span className="hero__badge">iPadOS 18+</span>
            <span className="hero__badge">macOS 15+</span>
            <span className="hero__badge">watchOS 10+</span>
            <span className="hero__badge">Privacy-first</span>
          </div>
        </div>

        <div className="hero__mockup fade-in delay-2">
          <div className="hero__device float">
            <img
              src="/showcase/iphone_hero.png"
              alt="PrismCalc app screenshot"
              className="hero__screenshot"
              loading="eager"
              decoding="async"
              fetchPriority="high"
            />
          </div>
        </div>
      </div>
    </section>
  );
}
