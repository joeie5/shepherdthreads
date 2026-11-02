import React from 'react';
import { deliveryOptions } from '../../data/account';
import { formatPrice } from '../../utils/currency';

interface DeliveryStepProps {
  value: string;
  onChange: (id: string) => void;
  freeStandard: boolean;
}

export function DeliveryStep({ value, onChange, freeStandard }: DeliveryStepProps) {
  return (
    <section>
      <h2 className="font-serif text-[22px]">Delivery method</h2>
      <div className="mt-5 divide-y divide-hairline border border-hairline" role="radiogroup" aria-label="Delivery method">
        {deliveryOptions.map((o) => {
          const active = value === o.id;
          const price = o.id === 'standard' && !freeStandard ? 8 : o.price;
          return (
            <label key={o.id} className={`flex cursor-pointer items-center gap-4 p-5 transition-colors ${active ? 'bg-cream' : 'hover:bg-cream/50'}`}>
              <input type="radio" name="delivery" value={o.id} checked={active} onChange={() => onChange(o.id)} className="h-4 w-4 accent-ink" />
              <span className="flex-1">
                <span className="block text-[14px] font-medium">{o.name}</span>
                <span className="block text-[13px] text-stone">{o.eta}</span>
              </span>
              <span className="text-[14px] tabular-nums">{price === 0 ? 'Free' : formatPrice(price)}</span>
            </label>);

        })}
      </div>
      <p className="mt-4 text-[13px] text-stone">Orders placed before 1pm ET ship the same business day.</p>
    </section>);

}