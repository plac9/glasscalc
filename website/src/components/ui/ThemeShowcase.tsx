import { themes } from '../../data/themes';

export function ThemeShowcase() {
  return (
    <div className="theme-grid">
      {themes.map((theme) => (
        <div
          key={theme.id}
          className="theme-swatch"
          title={theme.name}
        >
          <div
            className="theme-swatch__gradient"
            style={{
              background: `linear-gradient(135deg, ${theme.colors.gradient[0]}, ${theme.colors.gradient[1]}, ${theme.colors.gradient[2]})`,
            }}
          />
          <span className="theme-swatch__name">
            {theme.name}
            {theme.isPro && ' ✦'}
          </span>
        </div>
      ))}
    </div>
  );
}
