import type { Screenshot } from '../../types';

interface ScreenshotGalleryProps {
  screenshots: Screenshot[];
}

export function ScreenshotGallery({ screenshots }: ScreenshotGalleryProps) {
  return (
    <div className="screenshot-gallery">
      {screenshots.map((screenshot) => (
        <div key={screenshot.id} className="screenshot-item">
          <img
            src={screenshot.src}
            alt={screenshot.alt}
            loading="lazy"
            decoding="async"
          />
          {screenshot.caption && (
            <span className="screenshot-caption">{screenshot.caption}</span>
          )}
        </div>
      ))}
    </div>
  );
}
