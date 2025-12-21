import { GlassCard } from './GlassCard';

interface FeatureCardProps {
  icon: string;
  title: string;
  description: string;
  isPro?: boolean;
  highlight?: string;
}

export function FeatureCard({
  icon,
  title,
  description,
  isPro = false,
  highlight,
}: FeatureCardProps) {
  return (
    <GlassCard className="feature-card">
      <div className="feature-card__icon">{icon}</div>
      <h3 className="feature-card__title">
        {title}
        {isPro && <span className="pro-badge">Pro</span>}
      </h3>
      <p className="feature-card__description">{description}</p>
      {highlight && (
        <span className="feature-card__highlight">{highlight}</span>
      )}
    </GlassCard>
  );
}
