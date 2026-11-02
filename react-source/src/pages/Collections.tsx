import React from 'react';
import { Link } from 'react-router-dom';
import { ArrowRightIcon } from 'lucide-react';
import { collections, products } from '../data/products';
import { images } from '../data/images';

const collectionImages: Record<string, string> = {
  'psalm-23': images.teeCreamModel,
  essentials: images.hoodieModel,
  sabbath: images.crewModel
};

export function Collections() {
  return (
    <div className="bg-white">
      <header className="bg-ink text-white">
        <div className="mx-auto max-w-site px-5 py-16 md:px-8 md:py-24">
          <h1 className="font-serif text-[40px] uppercase leading-tight tracking-[0.06em] md:text-[64px]">Collections</h1>
          <p className="mt-4 max-w-lg text-[15px] text-white/65">Three small, considered collections — each rooted in a passage we keep returning to.</p>
        </div>
      </header>
      <div className="mx-auto max-w-site px-5 py-16 md:px-8 md:py-24">
        <ul className="grid gap-12 md:grid-cols-3 md:gap-6">
          {collections.map((c) => {
            const count = products.filter((p) => p.collection === c.id).length;
            return (
              <li key={c.id}>
                <Link to={`/shop?collection=${c.id}`} className="group block">
                  <div className="aspect-[4/5] overflow-hidden bg-cream">
                    <img src={collectionImages[c.id]} alt="" className="h-full w-full object-cover transition-transform duration-300 ease-out group-hover:scale-[1.02]" />
                  </div>
                  <h2 className="mt-5 font-serif text-[24px]">{c.name}</h2>
                  <p className="mt-2 text-[14px] text-ink/65">{c.description}</p>
                  <p className="mt-4 inline-flex items-center gap-2 text-[12px] font-medium uppercase tracking-[0.14em]">
                    <span className="underline underline-offset-[6px]">Shop {count} pieces</span>
                    <ArrowRightIcon className="h-4 w-4 transition-transform duration-200 ease-out group-hover:translate-x-1" />
                  </p>
                </Link>
              </li>);

          })}
        </ul>
      </div>
    </div>);

}