import React from 'react';
import { FREE_SHIPPING_THRESHOLD, formatPrice } from '../utils/currency';

export function FreeShippingMeter({ subtotal }: {subtotal: number;}) {
  const remaining = Math.max(0, FREE_SHIPPING_THRESHOLD - subtotal);
  const pct = Math.min(100, subtotal / FREE_SHIPPING_THRESHOLD * 100);
  return (
    <div>
      <p className="text-[13px]">
        {remaining > 0 ?
        <>
            You’re <span className="font-medium">{formatPrice(remaining)}</span> away from free shipping
          </> :

        'Your order ships free'
        }
      </p>
      <div className="mt-2 h-[2px] w-full bg-hairline" role="progressbar" aria-valuenow={Math.round(pct)} aria-valuemin={0} aria-valuemax={100}>
        <div className="h-full bg-ink transition-[width] duration-300 ease-out" style={{ width: `${pct}%` }} />
      </div>
    </div>);

}