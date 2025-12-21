import type { ReactNode, ButtonHTMLAttributes } from 'react';

interface GlassButtonProps extends ButtonHTMLAttributes<HTMLButtonElement> {
  children: ReactNode;
  variant?: 'default' | 'primary' | 'secondary';
  size?: 'default' | 'large';
  href?: string;
}

export function GlassButton({
  children,
  variant = 'default',
  size = 'default',
  href,
  className = '',
  ...props
}: GlassButtonProps) {
  const variantClass = variant !== 'default' ? `glass-button--${variant}` : '';
  const sizeClass = size === 'large' ? 'glass-button--large' : '';
  const classes = `glass-button ${variantClass} ${sizeClass} ${className}`.trim();

  if (href) {
    return (
      <a href={href} className={classes} target="_blank" rel="noopener noreferrer">
        {children}
      </a>
    );
  }

  return (
    <button className={classes} {...props}>
      {children}
    </button>
  );
}
