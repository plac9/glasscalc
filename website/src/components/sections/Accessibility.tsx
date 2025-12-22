import { GlassCard } from '../ui/GlassCard';

const accessibilityItems = [
  {
    title: 'High Contrast Mode',
    description:
      'Increase text and border contrast for bright environments and easier readability.',
    icon: 'Aa',
  },
  {
    title: 'VoiceOver Ready',
    description:
      'Clear labels and predictable focus order across all primary workflows.',
    icon: 'VO',
  },
  {
    title: 'Dynamic Type Support',
    description:
      'Typography scales with system settings so results stay legible at any size.',
    icon: 'DT',
  },
  {
    title: 'Reduced Motion Respect',
    description:
      'Animations and effects slow down or disable when Reduce Motion is enabled.',
    icon: 'RM',
  },
];

export function Accessibility() {
  return (
    <section id="accessibility" className="accessibility">
      <div className="container">
        <div className="section-header">
          <span className="section-header__label">Accessibility</span>
          <h2 className="section-header__title">Readable, calm, and inclusive</h2>
          <p className="section-header__subtitle">
            PrismCalc is designed to stay clear and usable across lighting conditions,
            text sizes, and assistive technologies.
          </p>
        </div>

        <div className="grid-2">
          {accessibilityItems.map((item) => (
            <GlassCard key={item.title} className="accessibility__card" hover={false}>
              <div className="accessibility__icon" aria-hidden="true">
                {item.icon}
              </div>
              <div>
                <h3 className="accessibility__title">{item.title}</h3>
                <p className="accessibility__text">{item.description}</p>
              </div>
            </GlassCard>
          ))}
        </div>

        <p className="accessibility__note">
          Toggle High Contrast using the <strong>Aa</strong> control in the header to
          sharpen glass cards and typography.
        </p>
      </div>
    </section>
  );
}
