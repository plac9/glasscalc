import { GlassCard } from '../ui/GlassCard';
import { copy } from '../../data/copy';

export function About() {
  return (
    <section id="about" className="about">
      <div className="container">
        <div className="grid-3">
          <GlassCard className="about__card">
            <h3 className="about__title">{copy.about.headline}</h3>
            <p className="about__text">{copy.about.body}</p>
            <p className="about__developer">
              Made by <strong>{copy.about.developer}</strong>
            </p>
          </GlassCard>

          <GlassCard className="about__card about__card--privacy" id="privacy">
            <h3 className="about__title">{copy.privacy.headline}</h3>
            <p className="about__text">{copy.privacy.body}</p>
            <div className="about__badges">
              <span className="about__badge">🔒 No Tracking</span>
              <span className="about__badge">☁️ Optional iCloud</span>
              <span className="about__badge">🛡️ Apple Ecosystem Only</span>
            </div>
          </GlassCard>

          <GlassCard className="about__card about__card--support">
            <h3 className="about__title">Support & Updates</h3>
            <p className="about__text">
              PrismCalc is actively maintained with regular quality updates. Reach out anytime for help or feedback.
            </p>
            <p className="about__developer">
              Support: <a href={`mailto:${copy.about.support}`}>{copy.about.support}</a>
            </p>
          </GlassCard>
        </div>
      </div>
    </section>
  );
}
