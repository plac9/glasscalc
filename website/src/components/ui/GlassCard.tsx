import type { ReactNode } from 'react';

interface GlassCardProps {
  children: ReactNode;
  variant?: 'default' | 'subtle';
  className?: string;
  hover?: boolean;
}

export function GlassCard({
  children,
  variant = 'default',
  className = '',
  hover = true,
}: GlassCardProps) {
  const variantClass = variant === 'subtle' ? 'glass-card--subtle' : '';
  const hoverClass = hover ? '' : 'glass-card--no-hover';

  return (
    <div className={`glass-card ${variantClass} ${hoverClass} ${className}`.trim()}>
      {children}
    </div>
  );
}
