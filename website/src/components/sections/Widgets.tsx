import { GlassCard } from '../ui/GlassCard';
import { widgetFeatures } from '../../data/widgets';

export function Widgets() {
  return (
    <section id="widgets" className="widgets">
      <div className="container">
        <div className="section-header">
          <span className="section-header__label">Widgets</span>
          <h2 className="section-header__title">Shortcuts everywhere</h2>
          <p className="section-header__subtitle">
            Keep PrismCalc one swipe away with widgets, Control Center, and Siri.
          </p>
        </div>

        <div className="grid-3 widgets__grid">
          {widgetFeatures.map((feature, index) => (
            <div key={feature.id} className={`fade-in-up delay-${index + 1}`}>
              <GlassCard className="widget-card" hover={false}>
                <div className="widget-card__icon">{feature.icon}</div>
                <h3 className="widget-card__title">{feature.title}</h3>
                <p className="widget-card__description">{feature.description}</p>
                <span className="widget-card__detail">{feature.detail}</span>
              </GlassCard>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
