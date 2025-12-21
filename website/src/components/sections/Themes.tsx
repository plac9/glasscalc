import { ThemeShowcase } from '../ui/ThemeShowcase';
import { GlassCard } from '../ui/GlassCard';

export function Themes() {
  return (
    <section id="themes" className="themes">
      <div className="container">
        <div className="section-header">
          <span className="section-header__label">Personalize</span>
          <h2 className="section-header__title">6 Stunning Themes</h2>
          <p className="section-header__subtitle">
            Choose your favorite aesthetic. Aurora is free, unlock 5 more with Pro.
          </p>
        </div>

        <GlassCard className="themes__card" hover={false}>
          <ThemeShowcase />
        </GlassCard>
      </div>
    </section>
  );
}
