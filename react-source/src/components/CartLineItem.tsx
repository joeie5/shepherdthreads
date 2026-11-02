import React from 'react';
import { Link } from 'react-router-dom';
import { useStore } from '../contexts/StoreContext';
import { QuantityStepper } from './QuantityStepper';
import { formatPrice } from '../utils/currency';
import { getColor, getProduct } from '../utils/products';
import type { CartItem } from '../types/commerce';

interface CartLineItemProps {
  item: CartItem;
  size?: 'compact' | 'full';
  onNavigate?: () => void;
}

export function CartLineItem({ item, size = 'compact', onNavigate }: CartLineItemProps) {
  const { updateQty, removeItem, toggleWishlist, isWishlisted } = useStore();
  const product = getProduct(item.productId);
  if (!product) return null;
  const color = getColor(product, item.color);
  const href = `/product/${product.id}?color=${encodeURIComponent(color.name)}`;
  const thumb = size === 'compact' ? 'w-[88px]' : 'w-[104px] md:w-[132px]';

  return (
    <li className="flex gap-4 py-5">
      <Link to={href} onClick={onNavigate} className={`${thumb} aspect-[4/5] shrink-0 overflow-hidden bg-cream`}>
        <img src={color.images[0]} alt={`${product.name} in ${color.name}`} className="h-full w-full object-cover" />
      </Link>
      <div className="flex min-w-0 flex-1 flex-col">
        <div className="flex items-start justify-between gap-3">
          <div className="min-w-0">
            <Link to={href} onClick={onNavigate} className="block truncate text-[14px] font-medium hover:underline hover:underline-offset-4">
              {product.name}
            </Link>
            <p className="mt-1 text-[13px] text-stone">
              {color.name} · {item.size}
            </p>
            {size === 'full' && <p className="mt-1 text-[13px] text-stone">{formatPrice(product.price)} each</p>}
          </div>
          <p className="shrink-0 text-[14px] tabular-nums">{formatPrice(product.price * item.qty)}</p>
        </div>
        <div className="mt-auto flex items-center justify-between gap-3 pt-4">
          <QuantityStepper value={item.qty} onChange={(v) => updateQty(item.key, v)} label={product.name} />
          <div className="flex items-center gap-4 text-[12px] text-stone">
            {size === 'full' &&
            <button
              type="button"
              onClick={() => {
                if (!isWishlisted(product.id)) toggleWishlist(product.id);
                removeItem(item.key);
              }}
              className="underline underline-offset-4 transition-colors hover:text-ink">
              
                Save for later
              </button>
            }
            <button type="button" onClick={() => removeItem(item.key)} className="underline underline-offset-4 transition-colors hover:text-ink">
              Remove
            </button>
          </div>
        </div>
      </div>
    </li>);

}