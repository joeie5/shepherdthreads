import React, { useEffect, useRef, useState } from 'react';

interface ProductGalleryProps {
  images: string[];
  alt: string;
}

export function ProductGallery({ images, alt }: ProductGalleryProps) {
  const [active, setActive] = useState(0);
  const trackRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    setActive(0);
    trackRef.current?.scrollTo({ left: 0 });
  }, [images]);

  const onScroll = () => {
    const el = trackRef.current;
    if (!el) return;
    setActive(Math.round(el.scrollLeft / el.clientWidth));
  };

  return (
    <div>
      {/* Mobile: swipeable */}
      <div className="relative md:hidden">
        <div ref={trackRef} onScroll={onScroll} className="scrollbar-none flex snap-x snap-mandatory overflow-x-auto" aria-label="Product images">
          {images.map((src, i) =>
          <div key={src} className="aspect-[4/5] w-full shrink-0 snap-center bg-cream">
              <img src={src} alt={`${alt}, view ${i + 1}`} className="h-full w-full object-cover" />
            </div>
          )}
        </div>
        <div className="absolute bottom-4 left-0 right-0 flex justify-center gap-1.5" aria-hidden="true">
          {images.map((src, i) =>
          <span key={src} className={`h-[3px] transition-[width,background-color] duration-200 ${i === active ? 'w-6 bg-ink' : 'w-3 bg-ink/25'}`} />
          )}
        </div>
      </div>

      {/* Desktop: thumbnails + large */}
      <div className="hidden gap-4 md:grid md:grid-cols-[72px_1fr]">
        <ul className="flex flex-col gap-3" aria-label="Choose image">
          {images.map((src, i) =>
          <li key={src}>
              <button
              onClick={() => setActive(i)}
              aria-label={`Show view ${i + 1}`}
              aria-current={i === active}
              className={`block aspect-[4/5] w-full overflow-hidden bg-cream ring-1 ring-offset-2 transition-shadow ${i === active ? 'ring-ink' : 'ring-transparent hover:ring-stone/50'}`}>
              
                <img src={src} alt="" className="h-full w-full object-cover" />
              </button>
            </li>
          )}
        </ul>
        <div className="aspect-[4/5] overflow-hidden bg-cream">
          <img src={images[active] ?? images[0]} alt={`${alt}, view ${active + 1}`} className="h-full w-full object-cover" />
        </div>
      </div>
    </div>);

}