import React, { useState } from 'react';
import { Link } from 'react-router-dom';
import { HeartIcon, XIcon } from 'lucide-react';
import { useStore } from '../../contexts/StoreContext';
import { ButtonLink } from '../Button';
import { Price } from '../Price';
import { getProduct } from '../../utils/products';
import type { Product } from '../../types/product';

function WishlistItem({ product }: {product: Product;}) {
  const { addToCart, toggleWishlist } = useStore();
  const oneSize = product.sizes.length === 1;
  const [size, setSize] = useState(oneSize ? product.sizes[0] : '');
  const color = product.colors[0];

  return (
    <li className="flex flex-col">
      <div className="relative aspect-[4/5] bg-cream">
        <Link to={`/product/${product.id}`}>
          <img src={color.images[0]} alt={product.name} className={`h-full w-full object-cover ${product.soldOut ? 'opacity-60' : ''}`} />
        </Link>
        <button onClick={() => toggleWishlist(product.id)} aria-label={`Remove ${product.name} from wishlist`} className="absolute right-2 top-2 flex h-8 w-8 items-center justify-center bg-white text-ink">
          <XIcon className="h-4 w-4" />
        </button>
        {product.soldOut && <span className="absolute left-3 top-3 bg-white px-2 py-1 text-[10px] font-medium uppercase tracking-[0.14em] text-brass">Sold out</span>}
      </div>
      <div className="flex items-start justify-between gap-3 pt-3">
        <div className="min-w-0">
          <Link to={`/product/${product.id}`} className="block truncate text-[14px] font-medium hover:underline">{product.name}</Link>
          <p className="text-[13px] text-stone">{color.name}</p>
        </div>
        <Price price={product.price} compareAt={product.compareAt} className="shrink-0 text-[14px]" />
      </div>
      <div className="mt-auto flex gap-2 pt-4">
        {product.soldOut ?
        <button disabled className="h-10 flex-1 border border-hairline text-[11px] uppercase tracking-[0.12em] text-stone">Notify when back</button> :

        <>
            {!oneSize &&
          <select
            value={size}
            onChange={(e) => setSize(e.target.value)}
            aria-label={`Size for ${product.name}`}
            className="h-10 w-[72px] border border-hairline bg-white px-2 text-[13px] outline-none focus:border-ink">
            
                <option value="">Size</option>
                {product.sizes.map((s) =>
            <option key={s} value={s} disabled={product.soldOutSizes?.includes(s)}>{s}</option>
            )}
              </select>
          }
            <button
            disabled={!size}
            onClick={() => {
              addToCart(product.id, color.name, size);
              toggleWishlist(product.id);
            }}
            className="h-10 flex-1 bg-ink text-[11px] font-medium uppercase tracking-[0.12em] text-white transition-colors hover:bg-[#262626] disabled:bg-hairline disabled:text-stone">
            
              Move to bag
            </button>
          </>
        }
      </div>
    </li>);

}

export function WishlistPanel() {
  const { wishlist } = useStore();
  const items = wishlist.map(getProduct).filter((p): p is Product => Boolean(p));

  return (
    <section>
      <h2 className="font-serif text-[24px]">Wishlist <span className="font-sans text-[15px] text-stone">({items.length})</span></h2>
      {items.length === 0 ?
      <div className="mt-6 flex flex-col items-center bg-cream px-6 py-16 text-center">
          <HeartIcon className="h-8 w-8 text-stone" strokeWidth={1.25} />
          <p className="mt-4 font-serif text-[22px]">Nothing saved yet</p>
          <p className="mt-2 text-[14px] text-ink/65">Tap the heart on any piece to keep it here.</p>
          <ButtonLink to="/shop" className="mt-6">Browse the shop</ButtonLink>
        </div> :

      <ul className="mt-6 grid grid-cols-2 gap-x-3 gap-y-10 md:gap-x-6 xl:grid-cols-3">
          {items.map((p) => <WishlistItem key={p.id} product={p} />)}
        </ul>
      }
    </section>);

}