import { GlassCard } from '../ui/GlassCard';
import { platforms } from '../../data/platforms';

export function Platforms() {
  return (
    <section id="platforms" className="platforms">
      <div className="container">
        <div className="section-header">
          <span className="section-header__label">Platforms</span>
          <h2 className="section-header__title">Native on every Apple screen</h2>
          <p className="section-header__subtitle">
            Purpose-built layouts for iPhone, iPad, Mac, and Apple Watch.
          </p>
        </div>

        <div className="grid-2 platforms__grid">
          {platforms.map((platform, index) => (
            <div key={platform.id} className={`fade-in-up delay-${index + 1}`}>
              <GlassCard className="platform-card" hover={false}>
                <div className="platform-card__header">
                  <span className="platform-card__icon">{platform.icon}</span>
                  <div>
                    <h3 className="platform-card__title">{platform.title}</h3>
                    <p className="platform-card__subtitle">{platform.subtitle}</p>
                  </div>
                </div>
                <ul className="platform-card__list">
                  {platform.details.map((detail) => (
                    <li key={detail}>{detail}</li>
                  ))}
                </ul>
                <div className="platform-card__media">
                  <img
                    src={platform.image}
                    alt={platform.imageAlt}
                    loading="lazy"
                    decoding="async"
                  />
                </div>
                <span className="platform-card__badge">{platform.badge}</span>
              </GlassCard>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
