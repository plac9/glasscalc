import { FeatureCard } from '../ui/FeatureCard';
import { features } from '../../data/features';

export function Features() {
  return (
    <section id="features" className="features">
      <div className="container">
        <div className="section-header">
          <span className="section-header__label">Features</span>
          <h2 className="section-header__title">Everything you need</h2>
          <p className="section-header__subtitle">
            Everyday tools designed for speed, clarity, and privacy—no clutter.
          </p>
        </div>

        <div className="grid-3">
          {features.map((feature, index) => (
            <div key={feature.id} className={`fade-in-up delay-${index + 1}`}>
              <FeatureCard
                icon={feature.icon}
                title={feature.title}
                description={feature.description}
                isPro={feature.isPro}
                highlight={feature.highlight}
              />
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
