import type { ReactNode, HTMLAttributes } from 'react';

type GlassCardProps = HTMLAttributes<HTMLDivElement> & {
  children: ReactNode;
  variant?: 'default' | 'subtle';
  className?: string;
  hover?: boolean;
};

export function GlassCard({
  children,
  variant = 'default',
  className = '',
  hover = true,
  ...rest
}: GlassCardProps) {
  const variantClass = variant === 'subtle' ? 'glass-card--subtle' : '';
  const hoverClass = hover ? '' : 'glass-card--no-hover';

  return (
    <div className={`glass-card ${variantClass} ${hoverClass} ${className}`.trim()} {...rest}>
      {children}
    </div>
  );
}
