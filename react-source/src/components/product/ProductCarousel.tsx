import React, { useRef } from 'react';
import { ChevronLeftIcon, ChevronRightIcon } from 'lucide-react';
import { ProductCard } from '../ProductCard';
import type { Product } from '../../types/product';

interface ProductCarouselProps {
  title: string;
  products: Product[];
}

export function ProductCarousel({ title, products }: ProductCarouselProps) {
  const ref = useRef<HTMLUListElement>(null);
  const scroll = (dir: 1 | -1) => {
    const el = ref.current;
    if (el) el.scrollBy({ left: dir * el.clientWidth * 0.8, behavior: 'smooth' });
  };

  return (
    <section aria-label={title} className="mx-auto max-w-site py-16 md:px-8 md:py-24">
      <div className="flex items-end justify-between px-5 md:px-0">
        <h2 className="font-serif text-[28px] uppercase tracking-[0.06em] md:text-[36px]">{title}</h2>
        <div className="hidden gap-2 md:flex">
          <button onClick={() => scroll(-1)} aria-label="Scroll left" className="flex h-10 w-10 items-center justify-center border border-hairline transition-colors hover:border-ink">
            <ChevronLeftIcon className="h-4 w-4" />
          </button>
          <button onClick={() => scroll(1)} aria-label="Scroll right" className="flex h-10 w-10 items-center justify-center border border-hairline transition-colors hover:border-ink">
            <ChevronRightIcon className="h-4 w-4" />
          </button>
        </div>
      </div>
      <ul ref={ref} className="scrollbar-none mt-8 flex snap-x snap-mandatory gap-3 overflow-x-auto px-5 md:gap-6 md:px-0">
        {products.map((p) =>
        <li key={p.id} className="w-[64%] shrink-0 snap-start sm:w-[40%] md:w-[calc((100%-72px)/4)]">
            <ProductCard product={p} />
          </li>
        )}
      </ul>
    </section>);

}