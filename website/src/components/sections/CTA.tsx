import { GlassCard } from '../ui/GlassCard';
import { copy } from '../../data/copy';

export function CTA() {
  return (
    <section className="cta">
      <div className="container">
        <GlassCard className="cta__card" hover={false}>
          <h2 className="cta__title">Ready to calculate beautifully?</h2>
          <p className="cta__subtitle">
            Free to download with basic calculator. Unlock Pro for{' '}
            <strong>{copy.proValue.price}</strong> — one-time, forever.
          </p>

          <a
            href={copy.appStore.url}
            target="_blank"
            rel="noopener noreferrer"
            className="app-store-badge cta__badge"
          >
            <img
              src="https://tools.applemediaservices.com/api/badges/download-on-the-app-store/black/en-us?size=250x83"
              alt="Download on the App Store"
            />
          </a>
        </GlassCard>
      </div>
    </section>
  );
}
