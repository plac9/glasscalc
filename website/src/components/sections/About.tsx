import { GlassCard } from '../ui/GlassCard';
import { copy } from '../../data/copy';

export function About() {
  return (
    <section id="about" className="about">
      <div className="container">
        <div className="grid-2">
          <GlassCard className="about__card">
            <h3 className="about__title">{copy.about.headline}</h3>
            <p className="about__text">{copy.about.body}</p>
            <p className="about__developer">
              Made by <strong>{copy.about.developer}</strong>
            </p>
          </GlassCard>

          <GlassCard className="about__card about__card--privacy">
            <h3 className="about__title">{copy.privacy.headline}</h3>
            <p className="about__text">{copy.privacy.body}</p>
            <div className="about__badges">
              <span className="about__badge">🔒 No Tracking</span>
              <span className="about__badge">📵 No Servers</span>
              <span className="about__badge">🛡️ 100% Private</span>
            </div>
          </GlassCard>
        </div>
      </div>
    </section>
  );
}
