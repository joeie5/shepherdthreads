import React, { useState } from 'react';
import { XIcon } from 'lucide-react';
import { useStore } from '../contexts/StoreContext';
import { calcTotals, formatPrice } from '../utils/currency';

interface PromoFieldProps {
  id: string;
}

export function PromoField({ id }: PromoFieldProps) {
  const { promo, applyPromo, removePromo } = useStore();
  const [code, setCode] = useState('');
  const [error, setError] = useState(false);

  if (promo) {
    return (
      <div className="flex items-center justify-between bg-cream px-3 py-2.5 text-[13px]">
        <span>
          <span className="font-medium">{promo.code}</span> · {promo.label}
        </span>
        <button onClick={removePromo} aria-label="Remove promo code" className="p-1 text-stone hover:text-ink">
          <XIcon className="h-4 w-4" />
        </button>
      </div>);

  }

  return (
    <form
      onSubmit={(e) => {
        e.preventDefault();
        setError(!applyPromo(code));
      }}>
      
      <label htmlFor={id} className="text-[13px]">
        Promo code
      </label>
      <div className="mt-2 flex">
        <input
          id={id}
          value={code}
          onChange={(e) => {
            setCode(e.target.value);
            setError(false);
          }}
          placeholder="Try SHEPHERD10"
          aria-invalid={error}
          className="h-11 min-w-0 flex-1 border border-r-0 border-hairline px-3 text-[14px] uppercase outline-none placeholder:normal-case placeholder:text-stone focus:border-ink" />
        
        <button type="submit" disabled={!code.trim()} className="h-11 border border-ink px-5 text-[11px] font-medium uppercase tracking-[0.12em] transition-colors hover:bg-ink hover:text-white disabled:border-hairline disabled:text-stone disabled:hover:bg-transparent">
          Apply
        </button>
      </div>
      {error && <p className="mt-2 text-[12px] text-brass">That code isn’t valid. Check the spelling and try again.</p>}
    </form>);

}

interface TotalsProps {
  shippingPrice?: number | null;
  shippingLabel?: string;
}

export function Totals({ shippingPrice = null, shippingLabel }: TotalsProps) {
  const { subtotal, promo } = useStore();
  const { discount, shipping, tax, total } = calcTotals(subtotal, promo?.percentOff ?? 0, shippingPrice);
  return (
    <dl className="space-y-2.5 text-[14px]">
      <div className="flex justify-between">
        <dt className="text-ink/70">Subtotal</dt>
        <dd className="tabular-nums">{formatPrice(subtotal)}</dd>
      </div>
      {discount > 0 &&
      <div className="flex justify-between">
          <dt className="text-ink/70">Discount ({promo?.code})</dt>
          <dd className="tabular-nums text-brass">−{formatPrice(discount)}</dd>
        </div>
      }
      <div className="flex justify-between">
        <dt className="text-ink/70">Shipping{shippingLabel ? ` · ${shippingLabel}` : ''}</dt>
        <dd className="tabular-nums">{shipping === 0 ? 'Free' : formatPrice(shipping)}</dd>
      </div>
      <div className="flex justify-between">
        <dt className="text-ink/70">Estimated tax</dt>
        <dd className="tabular-nums">{formatPrice(tax)}</dd>
      </div>
      <div className="flex items-baseline justify-between border-t border-hairline pt-4">
        <dt className="font-medium">Total</dt>
        <dd className="text-[18px] font-medium tabular-nums">{formatPrice(total)}</dd>
      </div>
    </dl>);

}