import React, { useState } from 'react';
import { Link } from 'react-router-dom';
import { HeartIcon } from 'lucide-react';
import { useStore } from '../contexts/StoreContext';
import { ColorSwatches } from './ColorSwatches';
import { Price } from './Price';
import type { Product } from '../types/product';

interface ProductCardProps {
  product: Product;
  quickAdd?: boolean;
}

export function ProductCard({ product, quickAdd = true }: ProductCardProps) {
  const { addToCart, toggleWishlist, isWishlisted } = useStore();
  const [colorName, setColorName] = useState(product.colors[0].name);
  const color = product.colors.find((c) => c.name === colorName) ?? product.colors[0];
  const [front, back] = color.images;
  const href = `/product/${product.id}?color=${encodeURIComponent(color.name)}`;
  const saved = isWishlisted(product.id);
  const oneSize = product.sizes.length === 1;

  return (
    <article className="group relative flex flex-col">
      <div className="relative aspect-[4/5] overflow-hidden bg-cream">
        <Link to={href} aria-label={`${product.name}, ${color.name}`} className="absolute inset-0">
          <img
            src={front}
            alt={`${product.name} in ${color.name}`}
            loading="lazy"
            className={`absolute inset-0 h-full w-full object-cover transition-opacity duration-300 ease-out ${back ? 'md:group-hover:opacity-0' : ''} ${product.soldOut ? 'opacity-60' : ''}`} />
          
          {back &&
          <img
            src={back}
            alt=""
            aria-hidden="true"
            loading="lazy"
            className="absolute inset-0 hidden h-full w-full object-cover opacity-0 transition-opacity duration-300 ease-out md:block md:group-hover:opacity-100" />

          }
        </Link>

        <div className="pointer-events-none absolute left-3 top-3 flex gap-1.5">
          {product.soldOut &&
          <span className="bg-white px-2 py-1 text-[10px] font-medium uppercase tracking-[0.14em] text-brass">Sold out</span>
          }
          {!product.soldOut && product.compareAt &&
          <span className="bg-white px-2 py-1 text-[10px] font-medium uppercase tracking-[0.14em] text-brass">Sale</span>
          }
          {!product.soldOut && product.isNew &&
          <span className="bg-ink px-2 py-1 text-[10px] font-medium uppercase tracking-[0.14em] text-white">New</span>
          }
        </div>

        <button
          type="button"
          onClick={() => toggleWishlist(product.id)}
          aria-pressed={saved}
          aria-label={saved ? `Remove ${product.name} from wishlist` : `Save ${product.name} to wishlist`}
          className="absolute right-2 top-2 flex h-9 w-9 items-center justify-center text-ink transition-colors hover:text-ink/70">
          
          <HeartIcon className={`h-[18px] w-[18px] ${saved ? 'fill-ink' : ''}`} strokeWidth={1.5} />
        </button>

        {quickAdd && !product.soldOut &&
        <div className="absolute inset-x-3 bottom-3 hidden translate-y-2 bg-white/95 p-3 opacity-0 backdrop-blur-sm transition-[opacity,transform] duration-200 ease-out group-focus-within:translate-y-0 group-focus-within:opacity-100 group-hover:translate-y-0 group-hover:opacity-100 md:block">
            {oneSize ?
          <button
            type="button"
            onClick={() => addToCart(product.id, color.name, 'One Size')}
            className="h-9 w-full bg-ink text-[11px] font-medium uppercase tracking-[0.12em] text-white transition-colors hover:bg-[#262626]">
            
                Quick add
              </button> :

          <>
                <p className="mb-2 text-[11px] uppercase tracking-[0.12em] text-stone">Quick add</p>
                <div className="grid grid-cols-6 gap-1">
                  {product.sizes.map((s) => {
                const out = product.soldOutSizes?.includes(s);
                return (
                  <button
                    key={s}
                    type="button"
                    disabled={out}
                    onClick={() => addToCart(product.id, color.name, s)}
                    aria-label={`Add size ${s} to bag${out ? ' (sold out)' : ''}`}
                    className="h-8 border border-hairline text-[11px] transition-colors hover:border-ink hover:bg-ink hover:text-white disabled:text-stone/60 disabled:line-through disabled:hover:border-hairline disabled:hover:bg-transparent">
                    
                        {s}
                      </button>);

              })}
                </div>
              </>
          }
          </div>
        }
      </div>

      <div className="flex items-start justify-between gap-3 pt-3">
        <div className="min-w-0">
          <h3 className="truncate text-[14px] font-medium">
            <Link to={href} className="hover:underline hover:underline-offset-4">
              {product.name}
            </Link>
          </h3>
          <p className="mt-0.5 truncate text-[13px] text-stone">{product.soldOut ? 'Sold out — notify me' : `${color.name} · ${product.subtitle}`}</p>
        </div>
        <Price price={product.price} compareAt={product.compareAt} className="shrink-0 text-[14px]" />
      </div>
      {product.colors.length > 1 &&
      <div className="mt-2.5">
          <ColorSwatches colors={product.colors} selected={color.name} onSelect={setColorName} />
        </div>
      }
    </article>);

}