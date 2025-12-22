import { GlassCard } from '../ui/GlassCard';
import { copy } from '../../data/copy';

const roadmapItems = [
  {
    title: 'Scientific + Advanced',
    description: 'Trig, logs, exponents, parentheses, and fraction handling.',
    status: 'Planned',
  },
  {
    title: 'Currency + Tax Tools',
    description: 'Custom currency defaults, tax rates, and quick conversions.',
    status: 'Planned',
  },
  {
    title: 'Smart Split Enhancements',
    description: 'Weighted splits, tax toggles, and sharing via Messages.',
    status: 'In design',
  },
  {
    title: 'Shortcuts + Watch',
    description: 'Siri shortcuts, Apple Watch widgets, and menu bar mode on Mac.',
    status: 'Exploring',
  },
  {
    title: 'Accessibility Themes',
    description: 'High-contrast palettes, dyslexia-friendly font option, and tuning.',
    status: 'Planned',
  },
  {
    title: 'Localization + Web',
    description: 'Multi-language support, RTL layouts, and a lightweight web version.',
    status: 'Exploring',
  },
];

export function Roadmap() {
  return (
    <section id="roadmap" className="roadmap">
      <div className="container">
        <div className="section-header">
          <span className="section-header__label">Roadmap</span>
          <h2 className="section-header__title">What we want to build next</h2>
          <p className="section-header__subtitle">
            PrismCalc stays focused on everyday speed today, with deeper tools on the way.
          </p>
        </div>

        <div className="grid-3">
          {roadmapItems.map((item) => (
            <GlassCard key={item.title} className="roadmap__card" hover={false}>
              <div className="roadmap__meta">
                <span className="roadmap__status">{item.status}</span>
              </div>
              <h3 className="roadmap__title">{item.title}</h3>
              <p className="roadmap__text">{item.description}</p>
            </GlassCard>
          ))}
        </div>

        <p className="roadmap__note">
          Want a feature sooner? Email us at <a href={`mailto:${copy.about.support}`}>{copy.about.support}</a>.
        </p>
      </div>
    </section>
  );
}
