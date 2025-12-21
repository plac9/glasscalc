import { copy } from '../../data/copy';

export function Footer() {
  return (
    <footer className="footer">
      <div className="container footer__container">
        <div className="footer__brand">
          <span className="footer__logo">◇ PrismCalc</span>
          <p className="footer__tagline">{copy.tagline}</p>
        </div>

        <div className="footer__links">
          {copy.footer.links.map((link) => (
            <a key={link.label} href={link.href} className="footer__link">
              {link.label}
            </a>
          ))}
        </div>

        <div className="footer__app-store">
          <a
            href={copy.appStore.url}
            target="_blank"
            rel="noopener noreferrer"
            className="app-store-badge"
          >
            <img
              src="https://tools.applemediaservices.com/api/badges/download-on-the-app-store/black/en-us?size=250x83"
              alt="Download on the App Store"
            />
          </a>
        </div>

        <p className="footer__copyright">{copy.footer.copyright}</p>
      </div>
    </footer>
  );
}
