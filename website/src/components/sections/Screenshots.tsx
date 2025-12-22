import { ScreenshotGallery } from '../ui/ScreenshotGallery';
import { screenshots } from '../../data/screenshots';

export function Screenshots() {
  return (
    <section id="screenshots" className="screenshots">
      <div className="container">
        <div className="section-header">
          <span className="section-header__label">Gallery</span>
          <h2 className="section-header__title">See it in action</h2>
          <p className="section-header__subtitle">
            Explore the UI at a glance, then try the interactive demo above.
          </p>
        </div>

        <ScreenshotGallery screenshots={screenshots} />
      </div>
    </section>
  );
}
